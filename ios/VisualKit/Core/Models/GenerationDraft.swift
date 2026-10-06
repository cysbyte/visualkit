import Foundation

enum AspectRatio: String, CaseIterable, Codable, Hashable, Sendable {
    case square = "1:1"
    case portrait = "4:5"
    case story = "9:16"
    case landscape = "16:9"

    var symbol: String {
        switch self {
        case .square: return "square"
        case .portrait: return "rectangle.portrait"
        case .story: return "rectangle.portrait.fill"
        case .landscape: return "rectangle"
        }
    }
}

enum StyleSelection: Hashable, Codable, Sendable {
    case none
    case fromReference
    case savedStyle(SavedStyle)

    var title: String {
        switch self {
        case .none: return "None"
        case .fromReference: return "From Reference"
        case .savedStyle(let style): return style.name
        }
    }
}

struct GenerationSettings: Hashable, Codable, Sendable {
    var aspectRatio: AspectRatio = .square
}

struct GenerationDraft: Hashable, Codable, Sendable {
    var prompt = ""
    var referenceImage: SelectedImage?
    var referenceAssetID: UUID?
    var visualDNA: VisualDNA?
    var preservation = PreservationSettings.defaultSelection
    var selectedTemplate: Template = .catalog[0]
    var selectedStyle: StyleSelection = .none
    var settings = GenerationSettings()

    var hasReferenceImage: Bool {
        referenceImage != nil || referenceAssetID != nil
    }

    var isValid: Bool {
        !prompt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var selectedVisualDNA: VisualDNA? {
        switch selectedStyle {
        case .none:
            return nil
        case .fromReference:
            return visualDNA
        case .savedStyle(let style):
            return style.dna
        }
    }

    init() {}

    init(request: ImageGenerationRequest) {
        prompt = request.userPrompt
        referenceImage = request.referenceImage
        referenceAssetID = request.referenceAssetID
        visualDNA = request.visualDNA
        preservation = request.preservation
        selectedTemplate = request.template
        settings = request.settings

        if let visualDNA = request.visualDNA {
            if request.referenceImage != nil || request.referenceAssetID != nil {
                selectedStyle = .fromReference
            } else {
                selectedStyle = .savedStyle(
                    SavedStyle(
                        name: "\(request.template.name) Direction",
                        dna: visualDNA
                    )
                )
            }
        } else {
            selectedStyle = .none
        }
    }
}
