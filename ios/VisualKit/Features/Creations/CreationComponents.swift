import SwiftUI
import UIKit

struct CreationShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(
        _ uiViewController: UIActivityViewController,
        context: Context
    ) {}

    static func items(for creation: Creation) -> [Any] {
        var items: [Any] = []
        if let data = creation.generatedImage?.data,
           let image = UIImage(data: data) {
            items.append(image)
        } else if let url = creation.generatedImageURL {
            items.append(url)
        }
        items.append(
            "VisualKit\n\(creation.prompt)\n\(creation.template.name)"
        )
        return items
    }
}

struct CreationImageView: View {
    @EnvironmentObject private var appState: AppState
    let creation: Creation
    var useThumbnail = false
    var contentMode: ContentMode = .fill

    var body: some View {
        Group {
            if let data = imageData,
               let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else if let url = imageURL {
                RemoteImageView(
                    url: url,
                    contentMode: contentMode,
                    refreshURL: assetRefreshURL
                )
            } else {
                CreationPaletteArtwork(colors: creation.palette)
            }
        }
        .clipped()
    }

    private var imageData: Data? {
        if useThumbnail {
            return creation.thumbnailData ?? creation.generatedImage?.data
        }
        return creation.generatedImage?.data ?? creation.thumbnailData
    }

    private var imageURL: URL? {
        if useThumbnail {
            return creation.thumbnailURL ?? creation.generatedImageURL
        }
        return creation.generatedImageURL ?? creation.thumbnailURL
    }

    private var assetRefreshURL: (() async throws -> URL)? {
        let assetID = useThumbnail
            ? (creation.thumbnailAssetID ?? creation.generatedAssetID)
            : (creation.generatedAssetID ?? creation.thumbnailAssetID)
        guard let assetID else { return nil }
        return { try await appState.backend.downloadURL(for: assetID).downloadURL }
    }
}

struct CreationThumbnail: View {
    let creation: Creation
    var compact = false

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 8 : 10) {
            ZStack(alignment: .topTrailing) {
                CreationImageView(creation: creation, useThumbnail: true)
                    .frame(
                        maxWidth: .infinity,
                        minHeight: compact ? 112 : 150,
                        maxHeight: compact ? 112 : 190
                    )
                    .aspectRatio(compact ? 1.18 : 1.12, contentMode: .fill)
                    .clipShape(RoundedRectangle(cornerRadius: compact ? 15 : 18, style: .continuous))

                statusBadge
                    .padding(9)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(creation.prompt)
                    .font(compact ? .caption.weight(.semibold) : .subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(compact ? 1 : 2)

                HStack(spacing: 5) {
                    Text(creation.template.name)
                    Text("•")
                    Text(creation.createdAt.visualkitRelativeString)
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
            }
        }
        .padding(compact ? 7 : 9)
        .frame(width: compact ? 186 : nil, alignment: .leading)
        .background(VisualKitTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: compact ? 17 : 20, style: .continuous))
        .visualkitHairline(cornerRadius: compact ? 17 : 20)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(creation.prompt), \(creation.status.title)")
    }

    @ViewBuilder
    private var statusBadge: some View {
        switch creation.status {
        case .completed:
            Label(creation.template.name, systemImage: "sparkles")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white.opacity(0.94))
                .padding(.horizontal, 8)
                .frame(minHeight: 26)
                .background(.black.opacity(0.42), in: Capsule())
        case .processing:
            Label("Processing", systemImage: "hourglass")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .frame(minHeight: 26)
                .background(VisualKitTheme.deepInk.opacity(0.82), in: Capsule())
        case .failed:
            Label("Failed", systemImage: "exclamationmark.triangle.fill")
                .font(.caption2.weight(.bold))
                .foregroundStyle(.white)
                .padding(.horizontal, 8)
                .frame(minHeight: 26)
                .background(VisualKitTheme.coral.opacity(0.9), in: Capsule())
        }
    }
}

struct TemplatePreviewTile: View {
    let template: Template
    var height: CGFloat = 96

    var body: some View {
        HStack(spacing: 12) {
            GalleryTemplatePreviewArtwork(template: template)
                .frame(width: height, height: height)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

            VStack(alignment: .leading, spacing: 5) {
                Text(template.name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                Text(template.category.title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Template, \(template.name)")
    }
}

struct GalleryTemplatePreviewArtwork: View {
    let template: Template

    var body: some View {
        Group {
            if let thumbnailURL = template.thumbnailURL {
                RemoteImageView(url: thumbnailURL)
            } else if let previewImageName = template.previewImageName,
                      UIImage(named: previewImageName) != nil {
                Image(previewImageName)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    LinearGradient(
                        colors: [
                            VisualKitTheme.color(for: template.accent),
                            VisualKitTheme.deepInk
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Image(systemName: template.thumbnail)
                        .font(.system(size: 32, weight: .semibold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.white.opacity(0.82))
                }
            }
        }
        .clipped()
    }
}

struct CreationPaletteArtwork: View {
    let colors: [String]

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: (colors.isEmpty ? ["indigo", "olive", "ink"] : colors)
                        .map(VisualKitTheme.color(for:)),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(.white.opacity(0.2))
                    .frame(width: proxy.size.width * 0.76)
                    .offset(
                        x: proxy.size.width * 0.28,
                        y: -proxy.size.height * 0.27
                    )

                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(.black.opacity(0.14))
                    .frame(
                        width: proxy.size.width * 0.62,
                        height: proxy.size.height * 0.3
                    )
                    .rotationEffect(.degrees(-14))
                    .offset(
                        x: -proxy.size.width * 0.12,
                        y: proxy.size.height * 0.15
                    )

                Image(systemName: "sparkles")
                    .font(.system(size: 32, weight: .light))
                    .foregroundStyle(.white.opacity(0.82))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
