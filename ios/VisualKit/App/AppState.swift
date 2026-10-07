import Foundation
import UIKit

@MainActor
final class AppState: ObservableObject {
    @Published var selectedTab: AppTab = .home
    @Published private(set) var creations: [Creation] = []
    @Published private(set) var savedStyles: [SavedStyle] = []
    @Published private(set) var templates: [Template] = Template.catalog
    @Published private(set) var isSyncing = false
    @Published var pendingStyle: SavedStyle?
    @Published var pendingReferenceImage: SelectedImage?
    @Published var pendingCreateDraft: GenerationDraft?

    let backend: any BackendAPIClient
    let jobService: any JobService
    let imageUpload: any ImageUploadService
    let imageSelection: any ImageSelectionService
    let persistence: any PersistenceService
    let styleRepository: any StyleRepository
    let creationRepository: any CreationRepository
    private let remoteClient: GoAPIClient?

    init(
        backend: (any BackendAPIClient)? = nil,
        jobService: (any JobService)? = nil,
        imageUpload: (any ImageUploadService)? = nil,
        imageSelection: any ImageSelectionService = NativeImageSelectionService(),
        persistence: any PersistenceService = InMemoryPersistenceService(),
        styleRepository: any StyleRepository = JSONStyleRepository(),
        creationRepository: any CreationRepository = JSONCreationRepository()
    ) {
        let configuredClient = APIConfiguration.fromEnvironment().map {
            GoAPIClient(configuration: $0)
        }
        let resolvedBackend = backend ?? configuredClient ?? MockBackendAPIClient()
        self.backend = resolvedBackend
        self.remoteClient = resolvedBackend as? GoAPIClient ?? configuredClient
        self.jobService = jobService
            ?? self.remoteClient.map(RemoteJobService.init)
            ?? MockJobService()
        self.imageUpload = imageUpload
            ?? self.remoteClient.map { RemoteImageUploadService(api: $0) }
            ?? MockImageUploadService()
        self.imageSelection = imageSelection
        self.persistence = persistence
        self.styleRepository = styleRepository
        self.creationRepository = creationRepository
        creations = (try? creationRepository.fetchAll()) ?? Creation.samples
        savedStyles = (try? styleRepository.fetchAll()) ?? SavedStyle.samples
        print("[VisualKit] AppState initialized remoteAPI=\(remoteClient != nil) templates=\(templates.count)")

        if remoteClient != nil {
            Task { [weak self] in
                await self?.refreshRemoteData()
            }
        }
    }

    var isUsingRemoteAPI: Bool {
        remoteClient != nil
    }

    func refreshRemoteData() async {
        guard let remoteClient else { return }
        isSyncing = true
        defer { isSyncing = false }

        async let remoteTemplates = remoteClient.listTemplates()
        async let remoteStyles = remoteClient.listStyles()
        async let remoteCreations = remoteClient.listCreations(limit: 30, cursor: nil)

        do {
            let values = try await remoteTemplates
            let thumbnailCount = values.filter { $0.thumbnailURL != nil || $0.previewImageName != nil }.count
            let categorySummary = Dictionary(grouping: values, by: \.category.title)
                .mapValues(\.count)
                .sorted { $0.key < $1.key }
                .map { "\($0.key)=\($0.value)" }
                .joined(separator: ", ")
            print("[VisualKit] Remote templates loaded count=\(values.count) thumbnails=\(thumbnailCount) categories=[\(categorySummary)] first=\(values.prefix(5).map(\.id))")
            if !values.isEmpty {
                templates = values
            }
        } catch {
            print("[VisualKit] Remote templates failed error=\(error)")
        }
        if let values = try? await remoteStyles {
            savedStyles = values
            persistStyles()
        }
        if let page = try? await remoteCreations {
            creations = page.items
            persistCreations()
        }
    }

    func addCreation(_ creation: Creation) {
        creations.removeAll { $0.id == creation.id }
        creations.insert(creation, at: 0)
        persistCreations()
    }

    func updateCreation(_ creation: Creation) {
        guard let index = creations.firstIndex(where: { $0.id == creation.id }) else {
            addCreation(creation)
            return
        }
        creations[index] = creation
        creations.sort { $0.createdAt > $1.createdAt }
        persistCreations()
    }

    func deleteCreation(_ creation: Creation) {
        creations.removeAll { $0.id == creation.id }
        persistCreations()
        guard let remoteClient else { return }
        Task {
            try? await remoteClient.deleteCreation(id: creation.id)
        }
    }

    @discardableResult
    func addProcessingCreation(for request: ImageGenerationRequest) -> UUID {
        let id = UUID()
        let creation = Creation(
            id: id,
            prompt: request.userPrompt,
            template: request.template,
            visualDNA: request.visualDNA,
            preservation: request.preservation,
            referenceImage: request.referenceImage,
            settings: request.settings,
            palette: request.visualDNA?.palette ?? ["indigo", "olive", "ink"],
            status: .processing,
            generationRequest: request
        )
        addCreation(creation)
        return id
    }

    func removeCreation(id: UUID) {
        creations.removeAll { $0.id == id }
        persistCreations()
    }

    func markCreationFailed(
        id: UUID,
        message: String
    ) {
        guard let creation = creations.first(where: { $0.id == id }) else {
            return
        }
        updateCreation(
            creation.replacing(
                status: .failed,
                failureMessage: message
            )
        )
    }

    func saveStyle(_ style: SavedStyle) {
        savedStyles.insert(style, at: 0)
        persistStyles()
        guard let remoteClient else { return }
        Task { [weak self] in
            guard let self else { return }
            guard let remoteStyle = try? await remoteClient.createStyle(style) else { return }
            savedStyles.removeAll { $0.id == style.id }
            savedStyles.insert(remoteStyle, at: 0)
            persistStyles()
        }
    }

    func updateStyle(_ style: SavedStyle) {
        guard let index = savedStyles.firstIndex(where: { $0.id == style.id }) else {
            return
        }
        savedStyles[index] = style
        persistStyles()
        guard let remoteClient else { return }
        Task { [weak self] in
            guard let self else { return }
            guard let remoteStyle = try? await remoteClient.updateStyle(style) else { return }
            if let index = savedStyles.firstIndex(where: { $0.id == style.id }) {
                savedStyles[index] = remoteStyle
                persistStyles()
            }
        }
    }

    func deleteStyle(_ style: SavedStyle) {
        savedStyles.removeAll { $0.id == style.id }
        persistStyles()
        guard let remoteClient else { return }
        Task {
            try? await remoteClient.deleteStyle(id: style.id)
        }
    }

    func useStyle(_ style: SavedStyle) {
        pendingStyle = style
        pendingReferenceImage = nil
        pendingCreateDraft = nil
        selectedTab = .create
    }

    func useTemplate(_ template: Template) {
        print("[VisualKit] Use template id=\(template.id) backendID=\(template.backendID?.uuidString ?? "nil") name=\(template.name) thumbnailURL=\(template.thumbnailURL?.absoluteString ?? "nil") preview=\(template.previewImageName ?? "nil")")
        var draft = GenerationDraft()
        draft.selectedTemplate = template
        draft.prompt = template.promptInstructions
        draft.settings = template.generationSettings
            ?? GenerationSettings(aspectRatio: template.recommendedAspectRatio)
        pendingCreateDraft = draft
        pendingStyle = nil
        pendingReferenceImage = nil
        selectedTab = .create
    }

    func useCreationAsReference(_ creation: Creation) {
        if let image = creation.generatedImage {
            Task { [weak self] in
                await self?.setCreationReference(image)
            }
            return
        }

        guard let assetURL = creation.generatedImageURL else {
            return
        }
        Task { [weak self] in
            guard let self else { return }
            do {
                let (data, response) = try await URLSession.shared.data(from: assetURL)
                guard let httpResponse = response as? HTTPURLResponse,
                      (200..<300).contains(httpResponse.statusCode),
                      let image = UIImage(data: data) else {
                    return
                }
                let selected = SelectedImage(
                    assetID: nil,
                    data: data,
                    filename: "creation-reference.jpg",
                    mimeType: "image/jpeg",
                    sourceTypeIdentifier: "public.jpeg",
                    pixelWidth: Int(image.size.width),
                    pixelHeight: Int(image.size.height),
                    originalByteCount: data.count,
                    byteCount: data.count
                )
                await setCreationReference(selected)
            } catch {}
        }
    }

    private func setCreationReference(_ image: SelectedImage) async {
        let reference: SelectedImage
        if remoteClient != nil, image.assetID == nil {
            reference = (try? await imageUpload.upload(image: image)) ?? image
        } else {
            reference = image
        }
        pendingReferenceImage = reference
        pendingStyle = nil
        pendingCreateDraft = nil
        selectedTab = .create
    }

    func useCreationStyle(_ creation: Creation) {
        guard let visualDNA = creation.visualDNA else {
            return
        }
        useStyle(
            SavedStyle(
                name: "\(creation.template.name) Direction",
                previewImage: creation.thumbnailData ?? creation.generatedImage?.data,
                dna: visualDNA
            )
        )
    }

    func regenerateCreation(_ creation: Creation) {
        guard let request = creation.generationRequest else {
            return
        }
        pendingCreateDraft = GenerationDraft(request: request)
        pendingStyle = nil
        pendingReferenceImage = nil
        selectedTab = .create
    }

    private func persistStyles() {
        try? styleRepository.saveAll(savedStyles)
    }

    private func persistCreations() {
        try? creationRepository.saveAll(creations)
    }
}

enum AppTab: Hashable {
    case home
    case create
    case creations
    case styles
    case settings
}
