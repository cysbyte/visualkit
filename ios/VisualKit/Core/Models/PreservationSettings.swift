import Foundation

struct PreservationSettings: Hashable, Codable, Sendable {
    var style = true
    var lighting = true
    var color = true
    var composition = true
    var camera = false
    var depthOfField = false
    var mood = false
    var texture = false
    var subject = false
    var background = false

    private enum CodingKeys: String, CodingKey {
        case style
        case lighting
        case color
        case composition
        case camera
        case depthOfField = "depth_of_field"
        case mood
        case texture
        case subject
        case background
    }

    static let defaultSelection = PreservationSettings()

    var preservedCategories: [VisualDNACategory] {
        VisualDNACategory.preservationOrder.filter { isPreserved($0) }
    }

    var allowedToChangeCategories: [VisualDNACategory] {
        VisualDNACategory.preservationOrder.filter { !isPreserved($0) }
    }

    var preservedCount: Int {
        preservedCategories.count
    }

    func isPreserved(_ category: VisualDNACategory) -> Bool {
        switch category {
        case .style:
            return style
        case .lighting:
            return lighting
        case .colorPalette:
            return color
        case .composition:
            return composition
        case .camera:
            return camera
        case .depthOfField:
            return depthOfField
        case .mood:
            return mood
        case .texture:
            return texture
        case .subject:
            return subject
        case .background:
            return background
        }
    }

    mutating func setPreserved(_ isPreserved: Bool, for category: VisualDNACategory) {
        switch category {
        case .style:
            style = isPreserved
        case .lighting:
            lighting = isPreserved
        case .colorPalette:
            color = isPreserved
        case .composition:
            composition = isPreserved
        case .camera:
            camera = isPreserved
        case .depthOfField:
            depthOfField = isPreserved
        case .mood:
            mood = isPreserved
        case .texture:
            texture = isPreserved
        case .subject:
            subject = isPreserved
        case .background:
            background = isPreserved
        }
    }
}
