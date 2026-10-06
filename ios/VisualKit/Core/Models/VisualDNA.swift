import Foundation

struct VisualDNAValue: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    var value: String

    init(value: String, id: UUID = UUID()) {
        self.id = id
        self.value = value
    }
}

enum VisualDNACategory: String, CaseIterable, Codable, Hashable, Identifiable, Sendable {
    case style
    case lighting
    case colorPalette
    case camera
    case depthOfField
    case composition
    case mood
    case texture
    case subject
    case background

    var id: String { rawValue }

    static var preservationOrder: [VisualDNACategory] {
        [.style, .lighting, .colorPalette, .composition, .camera, .depthOfField, .mood, .texture, .subject, .background]
    }

    var title: String {
        switch self {
        case .style: return "Style"
        case .lighting: return "Lighting"
        case .colorPalette: return "Color Palette"
        case .camera: return "Camera"
        case .depthOfField: return "Depth of Field"
        case .composition: return "Composition"
        case .mood: return "Mood"
        case .texture: return "Texture"
        case .subject: return "Subject"
        case .background: return "Background"
        }
    }

    var preservationTitle: String {
        switch self {
        case .colorPalette:
            return "Colors"
        default:
            return title
        }
    }

    var symbol: String {
        switch self {
        case .style: return "paintbrush.pointed"
        case .lighting: return "sun.max"
        case .colorPalette: return "paintpalette"
        case .camera: return "camera"
        case .depthOfField: return "camera.aperture"
        case .composition: return "rectangle.split.3x1"
        case .mood: return "face.smiling"
        case .texture: return "square.3.layers.3d"
        case .subject: return "person.crop.square"
        case .background: return "mountain.2"
        }
    }
}

struct VisualDNA: Hashable, Codable, Sendable {
    let sourceName: String
    var style: [VisualDNAValue]
    var lighting: [VisualDNAValue]
    var colorPalette: [VisualDNAValue]
    var camera: [VisualDNAValue]
    var depthOfField: [VisualDNAValue]
    var composition: [VisualDNAValue]
    var mood: [VisualDNAValue]
    var texture: [VisualDNAValue]
    var subject: [VisualDNAValue]
    var background: [VisualDNAValue]
    var aiPrompt: String
    var metadata: [String: VisualDNAMetadata]

    init(
        sourceName: String,
        style: [VisualDNAValue],
        lighting: [VisualDNAValue],
        colorPalette: [VisualDNAValue],
        camera: [VisualDNAValue],
        depthOfField: [VisualDNAValue],
        composition: [VisualDNAValue],
        mood: [VisualDNAValue],
        texture: [VisualDNAValue],
        subject: [VisualDNAValue],
        background: [VisualDNAValue],
        aiPrompt: String = "",
        metadata: [String: VisualDNAMetadata] = [:]
    ) {
        self.sourceName = sourceName
        self.style = style
        self.lighting = lighting
        self.colorPalette = colorPalette
        self.camera = camera
        self.depthOfField = depthOfField
        self.composition = composition
        self.mood = mood
        self.texture = texture
        self.subject = subject
        self.background = background
        self.aiPrompt = aiPrompt
        self.metadata = metadata
    }

    var attributeCount: Int {
        VisualDNACategory.allCases.reduce(0) { $0 + values(for: $1).count }
    }

    func values(for category: VisualDNACategory) -> [VisualDNAValue] {
        switch category {
        case .style: return style
        case .lighting: return lighting
        case .colorPalette: return colorPalette
        case .camera: return camera
        case .depthOfField: return depthOfField
        case .composition: return composition
        case .mood: return mood
        case .texture: return texture
        case .subject: return subject
        case .background: return background
        }
    }

    mutating func update(_ values: [VisualDNAValue], for category: VisualDNACategory) {
        switch category {
        case .style: style = values
        case .lighting: lighting = values
        case .colorPalette: colorPalette = values
        case .camera: camera = values
        case .depthOfField: depthOfField = values
        case .composition: composition = values
        case .mood: mood = values
        case .texture: texture = values
        case .subject: subject = values
        case .background: background = values
        }
    }

    mutating func add(_ value: String, to category: VisualDNACategory) {
        let trimmedValue = value.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else { return }
        var categoryValues = values(for: category)
        categoryValues.append(VisualDNAValue(value: trimmedValue))
        update(categoryValues, for: category)
    }

    mutating func remove(_ value: VisualDNAValue, from category: VisualDNACategory) {
        update(values(for: category).filter { $0.id != value.id }, for: category)
    }

    mutating func edit(_ value: VisualDNAValue, as newValue: String, in category: VisualDNACategory) {
        let trimmedValue = newValue.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedValue.isEmpty else { return }
        let updatedValues = values(for: category).map {
            $0.id == value.id ? VisualDNAValue(value: trimmedValue, id: value.id) : $0
        }
        update(updatedValues, for: category)
    }

    static let sample = VisualDNA(
        sourceName: "morning-studio.jpg",
        style: [VisualDNAValue(value: "Cinematic"), VisualDNAValue(value: "Editorial")],
        lighting: [VisualDNAValue(value: "Golden Hour"), VisualDNAValue(value: "Soft Directional")],
        colorPalette: [
            VisualDNAValue(value: "Warm"),
            VisualDNAValue(value: "Muted"),
            VisualDNAValue(value: "Terracotta")
        ],
        camera: [VisualDNAValue(value: "35mm Look")],
        depthOfField: [VisualDNAValue(value: "Shallow")],
        composition: [VisualDNAValue(value: "Centered"), VisualDNAValue(value: "Portrait")],
        mood: [VisualDNAValue(value: "Nostalgic"), VisualDNAValue(value: "Premium")],
        texture: [VisualDNAValue(value: "Subtle Film Grain")],
        subject: [VisualDNAValue(value: "Sculptural Interior")],
        background: [VisualDNAValue(value: "Warm Architectural Space")],
        aiPrompt: "Cinematic editorial image with golden hour, soft directional lighting, warm muted terracotta tones, a 35mm look, shallow depth of field, centered portrait composition, nostalgic premium mood, subtle film grain, and a warm architectural background."
    )

    static let quietCinema = VisualDNA(
        sourceName: "quiet-cinema.jpg",
        style: [VisualDNAValue(value: "Cinematic"), VisualDNAValue(value: "Analog")],
        lighting: [VisualDNAValue(value: "Low-Key"), VisualDNAValue(value: "Side Lit")],
        colorPalette: [VisualDNAValue(value: "Muted Blue"), VisualDNAValue(value: "Slate")],
        camera: [VisualDNAValue(value: "50mm Look")],
        depthOfField: [VisualDNAValue(value: "Medium")],
        composition: [VisualDNAValue(value: "Wide Framing"), VisualDNAValue(value: "Layered Depth")],
        mood: [VisualDNAValue(value: "Quiet"), VisualDNAValue(value: "Reflective")],
        texture: [VisualDNAValue(value: "Fine Film Grain")],
        subject: [VisualDNAValue(value: "Solitary Figure")],
        background: [VisualDNAValue(value: "Moody Interior")],
        aiPrompt: "Quiet cinematic frame with low-key side lighting, muted blue and slate tones, a 50mm look, medium depth of field, wide layered framing, reflective mood, fine film grain, and a moody interior."
    )
}

struct VisualDNAMetadata: Hashable, Codable, Sendable {
    var observations: [String]
    var inferences: [String]
    var confidence: Double
}

extension VisualDNA {
    private enum CodingKeys: String, CodingKey {
        case schemaVersion = "schema_version"
        case sourceName
        case style
        case lighting
        case colorPalette = "color_palette"
        case camera
        case depthOfField = "depth_of_field"
        case composition
        case mood
        case texture
        case subject
        case background
        case aiPrompt
    }

    private struct BackendCategory: Codable {
        let attributes: [String]?
        let observations: [String]?
        let inferences: [String]?
        let confidence: Double?
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        sourceName = try container.decodeIfPresent(String.self, forKey: .sourceName) ?? "Reference image"
        aiPrompt = try container.decodeIfPresent(String.self, forKey: .aiPrompt) ?? ""
        var metadata: [String: VisualDNAMetadata] = [:]

        func values(for key: CodingKeys, name: String) throws -> [VisualDNAValue] {
            if let backend = try container.decodeIfPresent(BackendCategory.self, forKey: key) {
                metadata[name] = VisualDNAMetadata(
                    observations: backend.observations ?? [],
                    inferences: backend.inferences ?? [],
                    confidence: backend.confidence ?? 0
                )
                return (backend.attributes ?? []).map { VisualDNAValue(value: $0) }
            }
            return try container.decodeIfPresent([VisualDNAValue].self, forKey: key) ?? []
        }

        style = try values(for: .style, name: "style")
        lighting = try values(for: .lighting, name: "lighting")
        colorPalette = try values(for: .colorPalette, name: "color_palette")
        camera = try values(for: .camera, name: "camera")
        depthOfField = try values(for: .depthOfField, name: "depth_of_field")
        composition = try values(for: .composition, name: "composition")
        mood = try values(for: .mood, name: "mood")
        texture = try values(for: .texture, name: "texture")
        subject = try values(for: .subject, name: "subject")
        background = try values(for: .background, name: "background")
        self.metadata = metadata
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        func category(_ category: VisualDNACategory, key: String) -> BackendCategory {
            let details = metadata[key] ?? VisualDNAMetadata(
                observations: [],
                inferences: [],
                confidence: 0
            )
            return BackendCategory(
                attributes: values(for: category).map(\.value),
                observations: details.observations,
                inferences: details.inferences,
                confidence: details.confidence
            )
        }

        try container.encode(1, forKey: .schemaVersion)
        try container.encode(category(.style, key: "style"), forKey: .style)
        try container.encode(category(.lighting, key: "lighting"), forKey: .lighting)
        try container.encode(category(.colorPalette, key: "color_palette"), forKey: .colorPalette)
        try container.encode(category(.camera, key: "camera"), forKey: .camera)
        try container.encode(category(.depthOfField, key: "depth_of_field"), forKey: .depthOfField)
        try container.encode(category(.composition, key: "composition"), forKey: .composition)
        try container.encode(category(.mood, key: "mood"), forKey: .mood)
        try container.encode(category(.texture, key: "texture"), forKey: .texture)
        try container.encode(category(.subject, key: "subject"), forKey: .subject)
        try container.encode(category(.background, key: "background"), forKey: .background)
    }
}

struct SavedStyle: Identifiable, Hashable, Codable, Sendable {
    let id: UUID
    var name: String
    var previewImage: Data?
    var previewImageURL: URL?
    var previewAssetID: UUID?
    var dna: VisualDNA
    let createdAt: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case previewImage
        case previewAssetID
        case dna
        case createdAt
    }

    init(
        id: UUID = UUID(),
        name: String,
        previewImage: Data? = nil,
        previewImageURL: URL? = nil,
        previewAssetID: UUID? = nil,
        dna: VisualDNA,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.previewImage = previewImage
        self.previewImageURL = previewImageURL
        self.previewAssetID = previewAssetID
        self.dna = dna
        self.createdAt = createdAt
    }

    static let samples: [SavedStyle] = [
        SavedStyle(name: "Morning Studio", dna: .sample),
        SavedStyle(name: "Quiet Cinema", dna: .quietCinema),
        SavedStyle(
            name: "Fresh Objects",
            dna: VisualDNA(
                sourceName: "fresh-objects.jpg",
                style: [VisualDNAValue(value: "Product Editorial")],
                lighting: [VisualDNAValue(value: "Bright Studio")],
                colorPalette: [
                    VisualDNAValue(value: "Mint"),
                    VisualDNAValue(value: "Cream"),
                    VisualDNAValue(value: "Coral")
                ],
                camera: [VisualDNAValue(value: "Clean 85mm Look")],
                depthOfField: [VisualDNAValue(value: "Medium")],
                composition: [VisualDNAValue(value: "Graphic Centered")],
                mood: [VisualDNAValue(value: "Fresh"), VisualDNAValue(value: "Playful")],
                texture: [VisualDNAValue(value: "Glossy Materials")],
                subject: [VisualDNAValue(value: "Colorful Objects")],
                background: [VisualDNAValue(value: "Minimal Studio")],
                aiPrompt: "Fresh product editorial image with bright studio lighting, mint cream and coral colors, a clean 85mm look, medium depth of field, graphic centered composition, playful mood, glossy materials, and a minimal studio background."
            )
        )
    ]
}
