import Foundation
import PhotosUI

@MainActor
final class CreateViewModel: ObservableObject {
    @Published var draft = GenerationDraft()
    @Published var isPreparingReference = false
    @Published var isUploadingReference = false
    @Published private(set) var referenceUploadProgress: Double?
    @Published var isAnalyzingReference = false
    @Published var isGenerating = false
    @Published var shouldShowVisualDNA = false
    @Published var isShowingGenerationResult = false
    @Published var errorMessage: String?
    @Published var validationMessage: String?
    @Published private(set) var analysisStatus: JobStatus?
    @Published private(set) var generationStatus: JobStatus?
    @Published private(set) var generationPhase: GenerationPhase = .creating
    @Published private(set) var generationResult: GenerationResult?
    @Published private(set) var activeGenerationRequest: ImageGenerationRequest?
    @Published private(set) var generationFailureMessage: String?

    private var analysisTask: Task<Void, Never>?
    private var generationTask: Task<Void, Never>?
    private var generationPhaseTask: Task<Void, Never>?
    private var analysisJob: Job<VisualDNA>?
    private var generationJob: Job<Creation>?

    var canGenerate: Bool {
        draft.isValid && !isAnalyzingReference && !isGenerating
    }

    var generationRequest: ImageGenerationRequest {
        ImageGenerationRequest(draft: draft)
    }

    var aiPromptPreview: String {
        GenerationPromptPreviewBuilder.make(for: generationRequest)
    }

    func reconcileTemplates(_ templates: [Template]) {
        guard let replacement = templates.first(where: {
            $0.id == draft.selectedTemplate.id
        }) ?? templates.first(where: {
            $0.id == draft.selectedTemplate.backendSlugFallback
        }) ?? templates.first(where: {
            $0.name.caseInsensitiveCompare(draft.selectedTemplate.name) == .orderedSame
        }) else {
            return
        }
        draft.selectedTemplate = replacement
    }

    func applyStyle(_ style: SavedStyle) {
        draft.visualDNA = style.dna
        draft.selectedStyle = .savedStyle(style)
        draft.preservation = .defaultSelection
        validationMessage = nil
    }

    func applyReferenceImage(_ image: SelectedImage) {
        draft.referenceImage = image
        draft.referenceAssetID = image.assetID
        draft.visualDNA = nil
        draft.selectedStyle = .none
        draft.preservation = .defaultSelection
        validationMessage = nil
    }

    func importReference(
        from result: PHPickerResult,
        using selectionService: any ImageSelectionService,
        uploadService: any ImageUploadService
    ) async {
        isPreparingReference = true
        errorMessage = nil
        defer { isPreparingReference = false }

        do {
            let localImage = try await selectionService.prepareImage(from: result)
            isUploadingReference = true
            referenceUploadProgress = 0
            defer { isUploadingReference = false }
            defer { referenceUploadProgress = nil }
            if let progressService = uploadService as? any ProgressReportingImageUploadService {
                draft.referenceImage = try await progressService.upload(image: localImage) { [weak self] progress in
                    Task { @MainActor [weak self] in
                        self?.referenceUploadProgress = progress
                    }
                }
            } else {
                draft.referenceImage = try await uploadService.upload(image: localImage)
            }
            draft.referenceAssetID = draft.referenceImage?.assetID
            draft.visualDNA = nil
            draft.preservation = .defaultSelection
            if case .fromReference = draft.selectedStyle {
                draft.selectedStyle = .none
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    func startAnalysis(using service: any JobService) {
        cancelAnalysis(using: service)
        guard let referenceImage = draft.referenceImage else {
            errorMessage = "Add a reference image before analyzing it."
            return
        }

        isAnalyzingReference = true
        analysisStatus = .queued
        errorMessage = nil

        analysisTask = Task { [weak self] in
            guard let self else { return }
            do {
                let request = ImageAnalysisRequest(
                    assetID: referenceImage.assetID,
                    imageData: referenceImage.data,
                    filename: referenceImage.filename
                )
                let job: Job<VisualDNA> = try await service.createJob(
                    request,
                    kind: .imageAnalysis
                )
                analysisJob = job
                analysisStatus = job.status

                let completedJob = try await service.waitForCompletion(
                    job,
                    pollingInterval: .seconds(1.5),
                    timeout: .seconds(10 * 60)
                )
                guard let result = completedJob.result else {
                    throw JobServiceError.failed("The analysis returned no Visual DNA.")
                }
                self.draft.visualDNA = result
                self.analysisStatus = completedJob.status
                self.shouldShowVisualDNA = true
            } catch is CancellationError {
                return
            } catch {
                if !Task.isCancelled {
                    self.errorMessage = error.localizedDescription
                    self.analysisStatus = .failed
                }
            }

            self.isAnalyzingReference = false
            self.analysisJob = nil
            self.analysisTask = nil
        }
    }

    func startGeneration(
        using service: any JobService,
        request: ImageGenerationRequest? = nil
    ) {
        cancelGeneration(using: service)
        guard draft.isValid else {
            validationMessage = "Add a prompt before generating."
            return
        }

        let request = request ?? generationRequest
        activeGenerationRequest = request
        generationResult = nil
        generationFailureMessage = nil
        isShowingGenerationResult = true
        isGenerating = true
        generationStatus = .queued
        generationPhase = .creating
        validationMessage = nil
        errorMessage = nil

        generationPhaseTask?.cancel()
        generationPhaseTask = Task { [weak self] in
            let phases: [GenerationPhase] = [
                .creating,
                .analyzingStyle,
                .applyingTemplate,
                .generating
            ]

            for (index, phase) in phases.enumerated() {
                if index > 0 {
                    try? await Task.sleep(for: .milliseconds(700))
                }
                guard !Task.isCancelled else { return }
                self?.generationPhase = phase
            }
        }

        generationTask = Task { [weak self] in
            guard let self else { return }
            do {
                let job: Job<Creation> = try await service.createJob(
                    request,
                    kind: .imageGeneration
                )
                generationJob = job
                generationStatus = .processing

                let completedJob = try await service.waitForCompletion(
                    job,
                    pollingInterval: .seconds(1.5),
                    timeout: .seconds(20 * 60)
                )
                guard let creation = completedJob.result else {
                    throw JobServiceError.failed("The generation returned no image.")
                }
                self.generationPhaseTask?.cancel()
                self.generationPhase = .completed
                self.generationStatus = completedJob.status
                self.generationResult = GenerationResult(
                    creation: creation,
                    request: request
                )
            } catch is CancellationError {
                return
            } catch {
                if !Task.isCancelled {
                    self.errorMessage = error.localizedDescription
                    self.generationStatus = .failed
                    self.generationFailureMessage = error.localizedDescription
                }
            }

            self.isGenerating = false
            self.generationJob = nil
            self.generationTask = nil
        }
    }

    func cancelAnalysis(using service: any JobService) {
        analysisTask?.cancel()
        if let job = analysisJob {
            Task {
                try? await service.cancelJob(job)
            }
        }
        analysisTask = nil
        analysisJob = nil
        isAnalyzingReference = false
    }

    func cancelGeneration(using service: any JobService) {
        generationTask?.cancel()
        generationPhaseTask?.cancel()
        if let job = generationJob {
            Task {
                try? await service.cancelJob(job)
            }
        }
        generationTask = nil
        generationPhaseTask = nil
        generationJob = nil
        isGenerating = false
    }

    func cancelOperations(using service: any JobService) {
        cancelAnalysis(using: service)
        cancelGeneration(using: service)
    }

    func removeReference() {
        draft.referenceImage = nil
        draft.referenceAssetID = nil
        draft.visualDNA = nil
        draft.preservation = .defaultSelection
        shouldShowVisualDNA = false
        if case .fromReference = draft.selectedStyle {
            draft.selectedStyle = .none
        }
    }

    func retryGeneration(using service: any JobService) {
        startGeneration(using: service, request: activeGenerationRequest)
    }

    func leaveGenerationResult(using service: any JobService) {
        if isGenerating {
            cancelGeneration(using: service)
        }
        isShowingGenerationResult = false
    }

    func useGenerationAsReference() -> Bool {
        guard let generationResult,
              let image = MockGeneratedImageFactory.makeSelectedImage(
                for: generationResult
              ) else {
            return false
        }

        draft.referenceImage = image
        draft.visualDNA = nil
        draft.preservation = .defaultSelection
        draft.selectedStyle = .none
        isShowingGenerationResult = false
        return true
    }

    func makeSavedStyleFromGeneration() -> SavedStyle? {
        guard let request = activeGenerationRequest,
              let visualDNA = request.visualDNA,
              let generationResult else {
            return nil
        }

        let style = SavedStyle(
            id: UUID(),
            name: "\(request.template.name) Direction",
            previewImage: MockGeneratedImageFactory
                .makeSelectedImage(for: generationResult)?
                .data,
            dna: visualDNA
        )
        draft.selectedStyle = .savedStyle(style)
        return style
    }

    deinit {
        analysisTask?.cancel()
        generationTask?.cancel()
        generationPhaseTask?.cancel()
    }
}
