import Foundation

enum TemplateCategory: String, CaseIterable, Codable, Hashable, Sendable {
    case postersTypography
    case productsEcommerce
    case brandLogos
    case uiInterfaces
    case chartsInfographics
    case architectureSpaces
    case photographyRealism
    case illustrationArt
    case charactersPeople
    case scenesStorytelling
    case historyClassicalThemes
    case documentsPublishing
    case otherUseCases

    var title: String {
        switch self {
        case .postersTypography: return "Posters & Typography"
        case .productsEcommerce: return "Products & E-commerce"
        case .brandLogos: return "Brand & Logos"
        case .uiInterfaces: return "UI & Interfaces"
        case .chartsInfographics: return "Charts & Infographics"
        case .architectureSpaces: return "Architecture & Spaces"
        case .photographyRealism: return "Photography & Realism"
        case .illustrationArt: return "Illustration & Art"
        case .charactersPeople: return "Characters & People"
        case .scenesStorytelling: return "Scenes & Storytelling"
        case .historyClassicalThemes: return "History & Classical Themes"
        case .documentsPublishing: return "Documents & Publishing"
        case .otherUseCases: return "Other Use Cases"
        }
    }

    var accentToken: String {
        switch self {
        case .postersTypography: return "coral"
        case .productsEcommerce: return "mint"
        case .brandLogos: return "coral"
        case .uiInterfaces: return "mint"
        case .chartsInfographics: return "mint"
        case .architectureSpaces: return "olive"
        case .photographyRealism: return "indigo"
        case .illustrationArt: return "lavender"
        case .charactersPeople: return "lavender"
        case .scenesStorytelling: return "indigo"
        case .historyClassicalThemes: return "olive"
        case .documentsPublishing: return "cream"
        case .otherUseCases: return "indigo"
        }
    }
}

extension TemplateCategory: Identifiable {
    var id: String { rawValue }
}

enum TemplateFilterTaxonomy {
    static let styleOrder = [
        "3D",
        "Architecture",
        "Brand",
        "Character",
        "Characters",
        "Charts",
        "Classical",
        "Documents",
        "History",
        "Illustration",
        "Infographic",
        "Other Use Cases",
        "Photography",
        "Poster",
        "Product",
        "Products",
        "Realistic",
        "Scenes",
        "UI"
    ]

    static let sceneOrder = [
        "Creative",
        "Tech",
        "Commerce",
        "Education",
        "Social",
        "Fashion",
        "Food",
        "Travel",
        "Story",
        "History"
    ]

    static func orderedStyles(from templates: [Template]) -> [String] {
        orderedValues(from: templates.flatMap(\.styles), order: styleOrder)
    }

    static func orderedScenes(from templates: [Template]) -> [String] {
        orderedValues(from: templates.flatMap(\.scenes), order: sceneOrder)
    }

    private static func orderedValues(from values: [String], order: [String]) -> [String] {
        let unique = Set(values.map(normalizedDisplayValue).filter { !$0.isEmpty })
        let known = order.filter { unique.contains($0) }
        let unknown = unique.subtracting(known).sorted {
            $0.localizedCaseInsensitiveCompare($1) == .orderedAscending
        }
        return known + unknown
    }

    private static func normalizedDisplayValue(_ value: String) -> String {
        value.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

struct Template: Identifiable, Hashable, Codable, Sendable {
    let id: String
    var backendID: UUID?
    let name: String
    let description: String
    let category: TemplateCategory
    let thumbnail: String
    let promptInstructions: String
    let recommendedAspectRatio: AspectRatio
    let generationSettings: GenerationSettings?
    let styles: [String]
    let scenes: [String]
    let sourceURL: URL?
    let sourceLabel: String?
    let githubURL: URL?
    let sourceCaseID: Int?
    let sourceImagePath: String?
    let imageAlt: String?
    let featured: Bool
    let thumbnailURL: URL?
    let previewImageName: String?

    var accent: String {
        category.accentToken
    }

    var styleSummary: String {
        styles.prefix(3).joined(separator: " · ")
    }

    var sceneSummary: String {
        scenes.prefix(3).joined(separator: " · ")
    }

    var backendSlugFallback: String? {
        switch id {
        case "case-editorial-poster",
             "case-type-specimen",
             "case-music-event-poster",
             "case-editorial-magazine-cover",
             "case-social-announcement-poster":
            return "editorial"
        case "case-studio-product":
            return "product-photography"
        case "case-saas-dashboard":
            return "3d"
        case "case-isometric-space":
            return "3d"
        case "case-character-sheet":
            return "portrait"
        case "case-data-infographic":
            return "minimal"
        case "case-brand-mark":
            return "minimal"
        case "case-realistic-portrait":
            return "portrait"
        case "case-story-scene":
            return "cinematic"
        case "case-illustrated-cover":
            return "anime"
        case "case-archive-document":
            return "editorial"
        case "case-classical-remix":
            return "cinematic"
        case "case-experimental-template":
            return "minimal"
        default:
            return nil
        }
    }

    var editablePromptFields: [String] {
        Self.editablePromptFields(in: promptInstructions)
    }

    static func editablePromptFields(in prompt: String) -> [String] {
        let pattern = #"\[[^\[\]]+\]"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return []
        }
        let range = NSRange(prompt.startIndex..<prompt.endIndex, in: prompt)
        let matches = regex.matches(in: prompt, range: range)
        var values: [String] = []
        for match in matches {
            guard let range = Range(match.range, in: prompt) else { continue }
            let value = String(prompt[range])
            if !values.contains(value) {
                values.append(value)
            }
        }
        return values
    }

    init(
        id: String,
        backendID: UUID? = nil,
        name: String,
        description: String,
        category: TemplateCategory,
        thumbnail: String,
        promptInstructions: String,
        recommendedAspectRatio: AspectRatio,
        generationSettings: GenerationSettings?,
        styles: [String] = [],
        scenes: [String] = [],
        sourceURL: URL? = nil,
        sourceLabel: String? = nil,
        githubURL: URL? = nil,
        sourceCaseID: Int? = nil,
        sourceImagePath: String? = nil,
        imageAlt: String? = nil,
        featured: Bool = false,
        thumbnailURL: URL? = nil,
        previewImageName: String? = nil
    ) {
        self.id = id
        self.backendID = backendID
        self.name = name
        self.description = description
        self.category = category
        self.thumbnail = thumbnail
        self.promptInstructions = promptInstructions
        self.recommendedAspectRatio = recommendedAspectRatio
        self.generationSettings = generationSettings
        self.styles = styles
        self.scenes = scenes
        self.sourceURL = sourceURL
        self.sourceLabel = sourceLabel
        self.githubURL = githubURL
        self.sourceCaseID = sourceCaseID
        self.sourceImagePath = sourceImagePath
        self.imageAlt = imageAlt
        self.featured = featured
        self.thumbnailURL = thumbnailURL
        self.previewImageName = previewImageName
    }

    static let catalog: [Template] = [
        Template(
            id: "case-editorial-poster",
            backendID: nil,
            name: "Editorial Launch Poster",
            description: "A typographic campaign image with strong hierarchy and polished layout.",
            category: .postersTypography,
            thumbnail: "textformat.size",
            promptInstructions: "Create a premium editorial launch poster for [SUBJECT]. The poster should feel like a finished campaign key visual, not a generic illustration. Use one large bold headline reading [HEADLINE], a short supporting line reading [SUBTITLE], and a small footer with [DATE OR CTA]. Build a strong typographic hierarchy with oversized display type, refined spacing, crisp alignment, and a confident modern grid. Combine clean abstract graphic shapes with one clear focal visual related to [SUBJECT]. Use a polished print-design finish, intentional negative space, high contrast, and production-ready details. Keep every visible word legible, correctly spelled, and limited to the requested text only. No watermark, no mockup frame, no extra logos, no random filler text.",
            recommendedAspectRatio: .portrait,
            generationSettings: GenerationSettings(aspectRatio: .portrait),
            styles: ["Poster", "Brand"],
            scenes: ["Creative", "Social"],
            sourceURL: nil,
            previewImageName: "template-editorial-poster"
        ),
        Template(
            id: "case-type-specimen",
            backendID: nil,
            name: "Type Specimen Poster",
            description: "A typography-forward poster built around letterforms, rhythm, and contrast.",
            category: .postersTypography,
            thumbnail: "textformat.abc",
            promptInstructions: "Create a type specimen poster centered on the exact word or phrase [WORD OR PHRASE]. Treat the letterforms as the main visual subject. Use oversized typography, cropped glyph details, baseline/grid marks, scale notes, and a refined typographic layout that demonstrates rhythm, contrast, weight, and spacing. Include only a few supporting labels such as [TYPEFACE NAME], [STYLE NOTE], and [YEAR OR CONTEXT]. Make the composition feel like a premium printed design-system artifact with crisp edges, careful alignment, and sophisticated negative space. Keep all text readable and intentionally placed. Avoid random placeholder copy, watermarks, and illegible microtext.",
            recommendedAspectRatio: .portrait,
            generationSettings: GenerationSettings(aspectRatio: .portrait),
            styles: ["Poster", "UI"],
            scenes: ["Creative", "Education"]
        ),
        Template(
            id: "case-music-event-poster",
            backendID: nil,
            name: "Music Event Poster",
            description: "A bold event poster with atmosphere, motion, and clear hierarchy.",
            category: .postersTypography,
            thumbnail: "music.note.list",
            promptInstructions: "Create a contemporary music event poster for [ARTIST OR EVENT]. Include the exact headline [ARTIST OR EVENT], the date [DATE], the venue [VENUE], and one short line [SUPPORTING LINE]. Use bold display typography, rhythmic spacing, layered visual texture, and a strong atmospheric image that suggests sound, movement, and live energy. The layout should have clear event hierarchy from a distance, with a polished gig-poster finish suitable for print and social promotion. Keep the design modern, expressive, and legible. Do not add extra acts, fake sponsors, random logos, watermarks, or unreadable text.",
            recommendedAspectRatio: .portrait,
            generationSettings: GenerationSettings(aspectRatio: .portrait),
            styles: ["Poster", "Realistic"],
            scenes: ["Social", "Fashion"]
        ),
        Template(
            id: "case-editorial-magazine-cover",
            backendID: nil,
            name: "Magazine Cover System",
            description: "A refined cover layout with headline, image, and editorial structure.",
            category: .postersTypography,
            thumbnail: "newspaper",
            promptInstructions: "Create an editorial magazine cover about [TOPIC]. Use a strong masthead reading [MAGAZINE NAME], a main cover line reading [MAIN STORY], and two short secondary cover lines: [COVER LINE 1] and [COVER LINE 2]. Build the cover around premium photography or polished editorial illustration, with refined hierarchy, thoughtful cropping, clear margins, and a cohesive contemporary publishing layout. The result should feel like a real high-end culture, design, or technology magazine cover. Keep text readable and limited to the requested cover copy. Avoid fake barcodes unless requested, random filler text, watermarks, and distorted typography.",
            recommendedAspectRatio: .portrait,
            generationSettings: GenerationSettings(aspectRatio: .portrait),
            styles: ["Poster", "Illustration"],
            scenes: ["Creative", "Story"]
        ),
        Template(
            id: "case-social-announcement-poster",
            backendID: nil,
            name: "Social Announcement Poster",
            description: "A mobile-first graphic poster for launches, drops, and announcements.",
            category: .postersTypography,
            thumbnail: "rectangle.portrait",
            promptInstructions: "Create a vertical mobile-first announcement poster for [LAUNCH OR MESSAGE]. Use the exact main headline [HEADLINE], a concise subheading [SUBHEADING], and a small call-to-action [CTA]. Design for immediate visual impact in a social feed: strong focal composition, bold readable type, high-contrast color, clean spacing, and a polished campaign look. The image should feel ready for a product launch, drop, or event announcement. Keep important content center-safe for mobile cropping. Do not include random extra text, watermarks, brand logos unless specified, or unreadable typography.",
            recommendedAspectRatio: .story,
            generationSettings: GenerationSettings(aspectRatio: .story),
            styles: ["Poster", "Product"],
            scenes: ["Social", "Commerce"]
        ),
        Template(
            id: "case-studio-product",
            backendID: nil,
            name: "Studio Product Hero",
            description: "Clean commercial product imagery with material detail and controlled light.",
            category: .productsEcommerce,
            thumbnail: "cube.transparent",
            promptInstructions: "Create a premium studio product hero image for [PRODUCT]. Show the product as the clear focal subject on a considered surface or plinth, with clean commercial lighting, elegant soft shadows, sharp material detail, and a refined background that supports the product without distraction. Include visual cues for [MATERIAL], [COLOR], and [USE CASE]. The composition should work as a high-end e-commerce hero image and square template preview. No logos, no readable packaging text unless supplied, no watermark, no clutter, and no extra products competing with the main subject.",
            recommendedAspectRatio: .square,
            generationSettings: GenerationSettings(aspectRatio: .square),
            styles: ["Product", "Realistic"],
            scenes: ["Commerce", "Tech"],
            previewImageName: "template-studio-product"
        ),
        Template(
            id: "case-saas-dashboard",
            backendID: nil,
            name: "SaaS Dashboard Mockup",
            description: "A polished interface concept built for product pages and app previews.",
            category: .uiInterfaces,
            thumbnail: "macwindow",
            promptInstructions: "Create a modern SaaS dashboard UI mockup for [PRODUCT OR WORKFLOW]. Show a realistic desktop app screen with clear left navigation, top-level metrics, charts, tables, status indicators, and one focused workflow area for [PRIMARY TASK]. The interface should feel dense but organized, operational, and production-ready rather than decorative. Use restrained color, readable spacing, consistent components, and plausible data labels. Avoid real company names, random broken text, excessive gradients, marketing fluff, and impossible UI. The result should be suitable for a product preview or template thumbnail.",
            recommendedAspectRatio: .landscape,
            generationSettings: GenerationSettings(aspectRatio: .landscape),
            styles: ["UI", "Realistic"],
            scenes: ["Tech", "Commerce"],
            previewImageName: "template-saas-dashboard"
        ),
        Template(
            id: "case-isometric-space",
            backendID: nil,
            name: "Isometric Interior Scene",
            description: "A miniature room or environment with readable spatial storytelling.",
            category: .architectureSpaces,
            thumbnail: "house.lodge",
            promptInstructions: "Create an isometric miniature interior scene for [SPACE OR ACTIVITY]. Build the image like a detailed architectural diorama with clear room geometry, believable scale, layered furniture and objects, warm practical lighting, and small narrative details that explain how the space is used. Include visual hints of [MOOD], [TIME OF DAY], and [KEY OBJECT]. Keep the composition readable from above at a three-quarter isometric angle, polished and tactile, with no floating labels, no people unless requested, and no messy perspective errors.",
            recommendedAspectRatio: .square,
            generationSettings: GenerationSettings(aspectRatio: .square),
            styles: ["Architecture", "3D"],
            scenes: ["Creative", "Travel"]
        ),
        Template(
            id: "case-character-sheet",
            backendID: nil,
            name: "Character Concept Sheet",
            description: "A reusable character design format with expressive personality cues.",
            category: .charactersPeople,
            thumbnail: "person.crop.square",
            promptInstructions: "Create a production-quality character concept image for [CHARACTER]. Show the character in a clear full-body or three-quarter pose with an expressive face, readable silhouette, distinct outfit, coherent accessories, and visual details that communicate [PERSONALITY], [ROLE], and [WORLD]. Include subtle design-callout thinking through shapes, materials, and color, but keep the final image clean and polished rather than cluttered. Avoid extra characters, random text, distorted anatomy, inconsistent costume details, and copyrighted franchise likenesses.",
            recommendedAspectRatio: .portrait,
            generationSettings: GenerationSettings(aspectRatio: .portrait),
            styles: ["Character", "Illustration"],
            scenes: ["Creative", "Fashion"]
        ),
        Template(
            id: "case-data-infographic",
            backendID: nil,
            name: "Data Story Infographic",
            description: "A visual explanation layout for metrics, timelines, or comparisons.",
            category: .chartsInfographics,
            thumbnail: "chart.xyaxis.line",
            promptInstructions: "Create a clean editorial infographic about [TOPIC]. Organize the information into clear sections with a title [TITLE], three key points [POINT 1], [POINT 2], [POINT 3], and a simple visual comparison or chart. Use legible labels, structured hierarchy, balanced spacing, and a professional information-design style. The visual should explain the topic at a glance, with icons or diagrams only where they improve clarity. Keep all text readable and limited to the specified content. Avoid fake statistics unless provided, clutter, watermarks, and decorative elements that reduce comprehension.",
            recommendedAspectRatio: .portrait,
            generationSettings: GenerationSettings(aspectRatio: .portrait),
            styles: ["Infographic", "UI"],
            scenes: ["Education", "Tech"]
        ),
        Template(
            id: "case-brand-mark",
            backendID: nil,
            name: "Brand Mark Exploration",
            description: "Logo and identity direction for a new product or company.",
            category: .brandLogos,
            thumbnail: "seal",
            promptInstructions: "Create a brand identity exploration for [BRAND]. Include a clean logo mark, supporting typography direction, simple color system, and a realistic presentation on neutral brand materials.",
            recommendedAspectRatio: .square,
            generationSettings: GenerationSettings(aspectRatio: .square),
            styles: ["Brand", "Product"],
            scenes: ["Commerce", "Creative"]
        ),
        Template(
            id: "case-realistic-portrait",
            backendID: nil,
            name: "Realistic Portrait Study",
            description: "Natural portrait photography with intentional light and mood.",
            category: .photographyRealism,
            thumbnail: "camera.aperture",
            promptInstructions: "Create a realistic portrait of [PERSON OR ROLE]. Use natural skin texture, intentional framing, flattering light, believable background detail, and a refined photographic mood.",
            recommendedAspectRatio: .square,
            generationSettings: GenerationSettings(aspectRatio: .square),
            styles: ["Realistic", "Photography"],
            scenes: ["Fashion", "Social"]
        ),
        Template(
            id: "case-story-scene",
            backendID: nil,
            name: "Cinematic Story Frame",
            description: "A narrative image with atmosphere, subject, and visual tension.",
            category: .scenesStorytelling,
            thumbnail: "film",
            promptInstructions: "Create a cinematic story frame about [SCENE]. Use a clear subject, atmospheric depth, motivated lighting, environmental detail, and a strong sense of before-and-after narrative.",
            recommendedAspectRatio: .landscape,
            generationSettings: GenerationSettings(aspectRatio: .landscape),
            styles: ["Realistic", "Scenes"],
            scenes: ["Story", "Travel"]
        ),
        Template(
            id: "case-illustrated-cover",
            backendID: nil,
            name: "Illustrated Cover Art",
            description: "A polished cover image with expressive shape, color, and composition.",
            category: .illustrationArt,
            thumbnail: "paintpalette",
            promptInstructions: "Create illustrated cover art for [TOPIC]. Use expressive shapes, cohesive color, clear focal composition, polished rendering, and a memorable editorial illustration style.",
            recommendedAspectRatio: .story,
            generationSettings: GenerationSettings(aspectRatio: .story),
            styles: ["Illustration", "Poster"],
            scenes: ["Creative", "Story"]
        ),
        Template(
            id: "case-archive-document",
            backendID: nil,
            name: "Archive Document Layout",
            description: "A believable document or publishing concept with refined page detail.",
            category: .documentsPublishing,
            thumbnail: "doc.richtext",
            promptInstructions: "Create a refined document layout for [SUBJECT]. Use editorial structure, realistic paper or screen presentation, careful typography, organized annotations, and credible publishing detail.",
            recommendedAspectRatio: .portrait,
            generationSettings: GenerationSettings(aspectRatio: .portrait),
            styles: ["Documents", "Poster"],
            scenes: ["Education", "History"]
        ),
        Template(
            id: "case-classical-remix",
            backendID: nil,
            name: "Classical Theme Remix",
            description: "Historical or classical visual language adapted to a modern subject.",
            category: .historyClassicalThemes,
            thumbnail: "building.columns",
            promptInstructions: "Create an image of [SUBJECT] using classical historical visual language. Combine period-informed composition, refined ornament, dramatic lighting, and a modern readable concept.",
            recommendedAspectRatio: .square,
            generationSettings: GenerationSettings(aspectRatio: .square),
            styles: ["Classical", "History"],
            scenes: ["History", "Story"]
        ),
        Template(
            id: "case-experimental-template",
            backendID: nil,
            name: "Experimental Visual System",
            description: "A flexible creative format for cases that do not fit one category.",
            category: .otherUseCases,
            thumbnail: "sparkles",
            promptInstructions: "Create a polished experimental image for [IDEA]. Use a clear concept, intentional visual system, coherent composition, and production-quality detail while keeping the result practical to reuse.",
            recommendedAspectRatio: .square,
            generationSettings: GenerationSettings(aspectRatio: .square),
            styles: ["Other Use Cases", "Illustration"],
            scenes: ["Creative", "Tech"]
        )
    ]

    // Kept as a compatibility name for existing request and mock-service code.
    static let collection = catalog
}

typealias CreativeTemplate = Template
