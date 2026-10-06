import Foundation

enum JobKind: String, Codable, Sendable {
    case imageAnalysis
    case imageGeneration
}

enum JobStatus: String, Codable, Sendable {
    case queued
    case processing
    case completed
    case failed
    case cancelled

    var isTerminal: Bool {
        self == .completed || self == .failed || self == .cancelled
    }
}

struct Job<Result: Codable & Hashable & Sendable>: Identifiable, Hashable, Codable, Sendable {
    let id: String
    let kind: JobKind
    var status: JobStatus
    var result: Result?
    var errorMessage: String?
    let createdAt: Date
    var updatedAt: Date

    init(
        id: String,
        kind: JobKind,
        status: JobStatus = .queued,
        result: Result? = nil,
        errorMessage: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.kind = kind
        self.status = status
        self.result = result
        self.errorMessage = errorMessage
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

struct JobReference: Hashable, Codable, Sendable {
    let id: String
    let kind: JobKind
    var status: JobStatus = .queued

    init(id: String, kind: JobKind, status: JobStatus = .queued) {
        self.id = id
        self.kind = kind
        self.status = status
    }

    enum CodingKeys: String, CodingKey {
        case id
        case jobID = "job_id"
        case kind
        case type
        case status
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decodeIfPresent(String.self, forKey: .jobID)
            ?? container.decode(String.self, forKey: .id)
        let rawKind = try container.decodeIfPresent(JobKind.self, forKey: .kind)
        let type = try container.decodeIfPresent(String.self, forKey: .type)
        let kind = rawKind ?? (type == "image_generation" ? .imageGeneration : .imageAnalysis)
        self.init(
            id: id,
            kind: kind,
            status: try container.decodeIfPresent(JobStatus.self, forKey: .status) ?? .queued
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(kind, forKey: .kind)
        try container.encode(status, forKey: .status)
    }
}

struct ImageAnalysisRequest: Codable, Sendable {
    let assetID: UUID?
    let imageData: Data?
    let filename: String?

    init(
        assetID: UUID? = nil,
        imageData: Data? = nil,
        filename: String? = nil
    ) {
        self.assetID = assetID
        self.imageData = imageData
        self.filename = filename
    }
}

struct ImageGenerationRequest: Codable, Hashable, Sendable {
    let userPrompt: String
    let referenceImage: SelectedImage?
    let referenceAssetID: UUID?
    let visualDNA: VisualDNA?
    let preservation: PreservationSettings
    let template: Template
    let settings: GenerationSettings
    let idempotencyKey: UUID

    init(draft: GenerationDraft, idempotencyKey: UUID = UUID()) {
        userPrompt = draft.prompt
        referenceImage = draft.referenceImage
        referenceAssetID = draft.referenceAssetID ?? draft.referenceImage?.assetID
        visualDNA = draft.selectedVisualDNA
        preservation = draft.preservation
        template = draft.selectedTemplate
        settings = draft.settings
        self.idempotencyKey = idempotencyKey
    }
}

enum GenerationPromptPreviewBuilder {
    static func make(for request: ImageGenerationRequest) -> String {
        var lines = [
            "User prompt",
            request.userPrompt
        ]

        lines.append("")
        lines.append("Template direction")
        lines.append("\(request.template.name): \(request.template.promptInstructions)")

        if let visualDNA = request.visualDNA {
            let preservedCategories = request.preservation.preservedCategories
            let preservedLines = preservedCategories.compactMap { category -> String? in
                let values = visualDNA.values(for: category).map(\.value)
                guard !values.isEmpty else { return nil }
                return "\(category.preservationTitle): \(values.joined(separator: ", "))"
            }

            lines.append("")
            lines.append("Visual DNA to preserve")
            if preservedLines.isEmpty {
                lines.append("None selected")
            } else {
                lines.append(contentsOf: preservedLines.map { "• \($0)" })
            }
        } else {
            lines.append("")
            lines.append("Visual DNA to preserve")
            lines.append("None selected")
        }

        lines.append("")
        lines.append("Generation settings")
        lines.append("Aspect ratio: \(request.settings.aspectRatio.rawValue)")
        lines.append("Reference image: \(request.referenceImage == nil ? "None" : "Attached")")

        return lines.joined(separator: "\n")
    }
}

enum GenerationPhase: String, CaseIterable, Codable, Sendable {
    case creating
    case analyzingStyle
    case applyingTemplate
    case generating
    case completed

    var title: String {
        switch self {
        case .creating:
            return "Creating your image..."
        case .analyzingStyle:
            return "Analyzing style..."
        case .applyingTemplate:
            return "Applying template..."
        case .generating:
            return "Generating..."
        case .completed:
            return "Image ready"
        }
    }

    var symbol: String {
        switch self {
        case .creating:
            return "sparkles"
        case .analyzingStyle:
            return "circle.hexagongrid"
        case .applyingTemplate:
            return "wand.and.stars"
        case .generating:
            return "photo.artframe"
        case .completed:
            return "checkmark.circle.fill"
        }
    }
}

struct GenerationResult: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    let creation: Creation
    let request: ImageGenerationRequest

    init(creation: Creation, request: ImageGenerationRequest) {
        id = creation.id
        self.creation = creation
        self.request = request
    }
}
