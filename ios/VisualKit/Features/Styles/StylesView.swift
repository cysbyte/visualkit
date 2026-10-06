import SwiftUI
import UIKit

struct StylesView: View {
    @EnvironmentObject private var appState: AppState
    @State private var editingStyle: SavedStyle?
    @State private var styleToDelete: SavedStyle?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header

                if appState.savedStyles.isEmpty {
                    VisualKitEmptyState(
                        title: "No saved styles yet",
                        message: "Upload and analyze a reference image in Create, then save its Visual DNA as a reusable style.",
                        symbol: "photo.badge.plus",
                        actionTitle: "Analyze Reference",
                        action: { appState.selectedTab = .create }
                    )
                } else {
                    LazyVStack(spacing: 14) {
                        ForEach(appState.savedStyles) { style in
                            styleRow(style)
                        }
                    }
                }
            }
            .padding(VisualKitTheme.horizontalPadding)
            .padding(.bottom, 120)
        }
        .scrollIndicators(.hidden)
        .background(VisualKitTheme.paper.ignoresSafeArea())
        .navigationTitle("Saved Styles")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $editingStyle) { style in
            StyleEditorView(style: style) { updatedStyle in
                appState.updateStyle(updatedStyle)
                editingStyle = nil
            }
        }
        .alert(
            "Delete Saved Style?",
            isPresented: Binding(
                get: { styleToDelete != nil },
                set: { if !$0 { styleToDelete = nil } }
            )
        ) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if let styleToDelete {
                    appState.deleteStyle(styleToDelete)
                }
                styleToDelete = nil
            }
        } message: {
            Text("This removes \(styleToDelete?.name ?? "this saved style") from your library.")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Saved Styles")
                .font(.largeTitle.weight(.bold))
            Text("Saved from analyzed reference images. Reuse their Visual DNA as a style source in Create.")
                .font(.subheadline)
                .foregroundStyle(VisualKitTheme.muted)
        }
        .accessibilityElement(children: .combine)
    }

    private func styleRow(_ style: SavedStyle) -> some View {
        ViewThatFits(in: .horizontal) {
            horizontalStyleRow(style)
            verticalStyleRow(style)
        }
        .padding(12)
        .visualkitSurface(cornerRadius: 20)
        .accessibilityElement(children: .combine)
    }

    private func horizontalStyleRow(_ style: SavedStyle) -> some View {
        HStack(spacing: 14) {
            stylePreview(style)

            VStack(alignment: .leading, spacing: 5) {
                Text(style.name)
                    .font(.headline)
                    .lineLimit(2)
                Label("From reference image analysis", systemImage: "circle.hexagongrid")
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(VisualKitTheme.coral)
                Text(styleTagSummary(style))
                    .font(.caption)
                    .foregroundStyle(VisualKitTheme.muted)
                    .lineLimit(1)
                Text(style.createdAt.visualkitRelativeString)
                    .font(.caption2)
                    .foregroundStyle(VisualKitTheme.muted)
            }

            Spacer(minLength: 4)

            Button {
                appState.useStyle(style)
            } label: {
                Label("Use", systemImage: "wand.and.stars")
                    .font(.caption.weight(.bold))
            }
            .buttonStyle(.borderedProminent)
            .tint(VisualKitTheme.deepInk)

            Menu {
                Button {
                    editingStyle = style
                } label: {
                    Label("Edit Saved Style", systemImage: "pencil")
                }

                Button {
                    appState.useStyle(style)
                } label: {
                    Label("Use as Style Source", systemImage: "wand.and.stars")
                }

                Button(role: .destructive) {
                    styleToDelete = style
                } label: {
                    Label("Delete Saved Style", systemImage: "trash")
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.headline.weight(.bold))
                    .frame(width: 32, height: 38)
            }
            .accessibilityLabel("Actions for \(style.name)")
        }
    }

    private func verticalStyleRow(_ style: SavedStyle) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                stylePreview(style)
                VStack(alignment: .leading, spacing: 5) {
                    Text(style.name)
                        .font(.headline)
                    Label("From reference image analysis", systemImage: "circle.hexagongrid")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(VisualKitTheme.coral)
                    Text(styleTagSummary(style))
                        .font(.caption)
                        .foregroundStyle(VisualKitTheme.muted)
                        .lineLimit(1)
                    Text(style.createdAt.visualkitRelativeString)
                        .font(.caption2)
                        .foregroundStyle(VisualKitTheme.muted)
                }
            }

            HStack(spacing: 10) {
                Button {
                    appState.useStyle(style)
                } label: {
                    Label("Use Style", systemImage: "wand.and.stars")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(VisualKitTheme.deepInk)

                Button {
                    editingStyle = style
                } label: {
                    Label("Edit", systemImage: "pencil")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(VisualKitTheme.deepInk)
            }
        }
    }

    private func stylePreview(_ style: SavedStyle) -> some View {
        StyleLibraryPreview(style: style)
            .frame(width: 82, height: 82)
    }

    private func styleTagSummary(_ style: SavedStyle) -> String {
        let tags = [
            style.dna.style.first?.value,
            style.dna.lighting.first?.value,
            style.dna.colorPalette.first?.value
        ]
        .compactMap { $0 }

        return tags.isEmpty ? "\(style.dna.attributeCount) visual traits" : tags.joined(separator: " · ")
    }
}

private struct StyleLibraryPreview: View {
    @EnvironmentObject private var appState: AppState
    let style: SavedStyle

    var body: some View {
        Group {
            if let previewImage = style.previewImage,
               let image = UIImage(data: previewImage) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if let previewImageURL = style.previewImageURL {
                RemoteImageView(
                    url: previewImageURL,
                    refreshURL: previewRefreshURL
                )
            } else {
                PalettePreview(colors: style.dna.palette)
            }
        }
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private var previewRefreshURL: (() async throws -> URL)? {
        guard let assetID = style.previewAssetID else { return nil }
        return { try await appState.backend.downloadURL(for: assetID).downloadURL }
    }
}
