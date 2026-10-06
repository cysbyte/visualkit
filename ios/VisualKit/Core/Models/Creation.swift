import Foundation

enum CreationStatus: String, Codable, Hashable, Sendable {
    case processing
    case completed
    case failed

    var title: String {
        switch self {
        case .processing:
            return "Processing"
        case .completed:
            return "Completed"
        case .failed:
            return "Failed"
        }
    }

    var symbol: String {
        switch self {
        case .processing:
            return "hourglass"
        case .completed:
            return "checkmark.circle.fill"
        case .failed:
            return "exclamationmark.triangle.fill"
        }
    }
}

struct Creation: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    var generatedImage: SelectedImage?
    var thumbnailData: Data?
    var generatedAssetID: UUID?
    var thumbnailAssetID: UUID?
    var generatedImageURL: URL?
    var thumbnailURL: URL?
    let prompt: String
    let template: Template
    let visualDNA: VisualDNA?
    let preservation: PreservationSettings
    let referenceImage: SelectedImage?
    let settings: GenerationSettings
    let palette: [String]
    let createdAt: Date
    var status: CreationStatus
    var failureMessage: String?
    let generationRequest: ImageGenerationRequest?

    private enum CodingKeys: String, CodingKey {
        case id
        case generatedImage
        case thumbnailData
        case generatedAssetID
        case thumbnailAssetID
        case prompt
        case template
        case visualDNA
        case preservation
        case referenceImage
        case settings
        case palette
        case createdAt
        case status
        case failureMessage
        case generationRequest
    }

    var templateName: String {
        template.name
    }

    var hasImage: Bool {
        generatedImage != nil || thumbnailData != nil
    }

    init(
        id: UUID = UUID(),
        generatedImage: SelectedImage? = nil,
        thumbnailData: Data? = nil,
        generatedAssetID: UUID? = nil,
        thumbnailAssetID: UUID? = nil,
        generatedImageURL: URL? = nil,
        thumbnailURL: URL? = nil,
        prompt: String,
        template: Template,
        visualDNA: VisualDNA? = nil,
        preservation: PreservationSettings = .defaultSelection,
        referenceImage: SelectedImage? = nil,
        settings: GenerationSettings = GenerationSettings(),
        palette: [String],
        createdAt: Date = Date(),
        status: CreationStatus = .completed,
        failureMessage: String? = nil,
        generationRequest: ImageGenerationRequest? = nil
    ) {
        self.id = id
        self.generatedImage = generatedImage
        self.thumbnailData = thumbnailData
        self.generatedAssetID = generatedAssetID
        self.thumbnailAssetID = thumbnailAssetID
        self.generatedImageURL = generatedImageURL
        self.thumbnailURL = thumbnailURL
        self.prompt = prompt
        self.template = template
        self.visualDNA = visualDNA
        self.preservation = preservation
        self.referenceImage = referenceImage
        self.settings = settings
        self.palette = palette
        self.createdAt = createdAt
        self.status = status
        self.failureMessage = failureMessage
        self.generationRequest = generationRequest
    }

    init(
        id: UUID = UUID(),
        prompt: String,
        templateName: String,
        palette: [String],
        createdAt: Date = Date()
    ) {
        let template = Template.catalog.first {
            $0.name.caseInsensitiveCompare(templateName) == .orderedSame
        } ?? Template.catalog[0]

        self.init(
            id: id,
            prompt: prompt,
            template: template,
            palette: palette,
            createdAt: createdAt
        )
    }

    func replacing(
        status: CreationStatus,
        generatedImage: SelectedImage? = nil,
        thumbnailData: Data? = nil,
        failureMessage: String? = nil
    ) -> Creation {
        Creation(
            id: id,
            generatedImage: generatedImage ?? self.generatedImage,
            thumbnailData: thumbnailData ?? self.thumbnailData,
            generatedAssetID: self.generatedAssetID,
            thumbnailAssetID: self.thumbnailAssetID,
            generatedImageURL: self.generatedImageURL,
            thumbnailURL: self.thumbnailURL,
            prompt: prompt,
            template: template,
            visualDNA: visualDNA,
            preservation: preservation,
            referenceImage: referenceImage,
            settings: settings,
            palette: palette,
            createdAt: createdAt,
            status: status,
            failureMessage: failureMessage,
            generationRequest: generationRequest
        )
    }

    static let samples: [Creation] = [
        Creation(
            prompt: "A quiet reading corner with sculptural furniture",
            template: Template.catalog.first(where: { $0.id == "case-isometric-space" }) ?? Template.catalog[0],
            palette: ["cream", "coral", "ink"],
            createdAt: Date().addingTimeInterval(-60 * 60 * 6)
        ),
        Creation(
            prompt: "Tangerine glassware on a sunlit table",
            template: Template.catalog.first(where: { $0.id == "case-studio-product" }) ?? Template.catalog[0],
            palette: ["mint", "coral", "cream"],
            createdAt: Date().addingTimeInterval(-60 * 60 * 28)
        ),
        Creation(
            prompt: "A botanical study in a brutalist greenhouse",
            template: Template.catalog.first(where: { $0.id == "case-story-scene" }) ?? Template.catalog[0],
            palette: ["olive", "indigo", "ink"],
            createdAt: Date().addingTimeInterval(-60 * 60 * 52)
        )
    ]
}

extension VisualDNA {
    var palette: [String] {
        let text = colorPalette.map(\.value).joined(separator: " ").lowercased()
        var tokens: [String] = []
        if text.contains("mint") { tokens.append("mint") }
        if text.contains("coral") || text.contains("terracotta") { tokens.append("coral") }
        if text.contains("cream") || text.contains("warm") { tokens.append("cream") }
        if text.contains("blue") || text.contains("slate") { tokens.append("indigo") }
        if text.contains("muted") { tokens.append("olive") }
        return tokens.isEmpty ? ["cream", "coral", "ink"] : Array(tokens.prefix(4))
    }
}
