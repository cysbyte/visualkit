import SwiftUI

enum VisualKitTheme {
    static let ink = Color.primary
    static let deepInk = Color(red: 0.09, green: 0.10, blue: 0.12)
    static let paper = Color(uiColor: .systemBackground)
    static let surface = Color(uiColor: .secondarySystemBackground)
    static let muted = Color.secondary
    static let line = Color(uiColor: .separator).opacity(0.65)
    static let coral = Color(red: 0.94, green: 0.39, blue: 0.28)
    static let mint = Color(red: 0.58, green: 0.78, blue: 0.69)
    static let lavender = Color(red: 0.68, green: 0.62, blue: 0.86)
    static let indigo = Color(red: 0.25, green: 0.28, blue: 0.52)
    static let olive = Color(red: 0.48, green: 0.52, blue: 0.31)
    static let cream = Color(red: 0.92, green: 0.82, blue: 0.63)

    static let horizontalPadding: CGFloat = 20
    static let sectionSpacing: CGFloat = 28
    static let cardRadius: CGFloat = 18
    static let compactRadius: CGFloat = 14

    static func color(for token: String) -> Color {
        switch token {
        case "coral": return coral
        case "mint": return mint
        case "lavender": return lavender
        case "indigo": return indigo
        case "olive": return olive
        case "cream": return cream
        case "ink": return deepInk
        default: return ink
        }
    }
}

struct SurfaceModifier: ViewModifier {
    var cornerRadius: CGFloat = VisualKitTheme.cardRadius

    func body(content: Content) -> some View {
        content
            .background(VisualKitTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .stroke(VisualKitTheme.line, lineWidth: 1)
            }
    }
}

extension View {
    func visualkitSurface(cornerRadius: CGFloat = VisualKitTheme.cardRadius) -> some View {
        modifier(SurfaceModifier(cornerRadius: cornerRadius))
    }

    func visualkitHairline(cornerRadius: CGFloat = VisualKitTheme.cardRadius) -> some View {
        overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .stroke(VisualKitTheme.line, lineWidth: 1)
        }
    }
}

struct PalettePreview: View {
    let colors: [String]

    var body: some View {
        GeometryReader { proxy in
            HStack(spacing: 0) {
                ForEach(Array(colors.enumerated()), id: \.offset) { _, token in
                    VisualKitTheme.color(for: token)
                        .frame(width: proxy.size.width / CGFloat(max(colors.count, 1)))
                }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

struct VisualKitScreenHeader: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text(title)
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }
}

struct VisualKitEmptyState: View {
    let title: String
    let message: String
    let symbol: String
    var actionTitle: String?
    var action: (() -> Void)?

    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: symbol)
                .font(.system(size: 34, weight: .semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(VisualKitTheme.coral)
                .frame(width: 60, height: 60)
                .background(VisualKitTheme.coral.opacity(0.12), in: Circle())

            VStack(spacing: 5) {
                Text(title)
                    .font(.headline.weight(.bold))
                    .multilineTextAlignment(.center)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let actionTitle, let action {
                Button(actionTitle, action: action)
                    .font(.subheadline.weight(.semibold))
                    .buttonStyle(.borderedProminent)
                    .tint(VisualKitTheme.deepInk)
                    .padding(.top, 2)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .visualkitSurface()
    }
}
