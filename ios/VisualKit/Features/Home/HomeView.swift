import SwiftUI
import UIKit

struct HomeView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedCategory: TemplateCategory?

    private var categoryRows: [(category: TemplateCategory, templates: [Template])] {
        TemplateCategory.allCases.compactMap { category in
            let templates = appState.templates.filter { $0.category == category }
            guard !templates.isEmpty else { return nil }
            return (category, templates)
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 28) {
                header
                featuredTemplateSection
                templateCategoriesSection
                stylesSection
                recentSection
            }
            .padding(.horizontal, VisualKitTheme.horizontalPadding)
            .padding(.top, 12)
            .padding(.bottom, 108)
        }
        .scrollIndicators(.hidden)
        .background(VisualKitTheme.paper.ignoresSafeArea())
        .navigationTitle("Home")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    appState.selectedTab = .settings
                } label: {
                    Image(systemName: "person.crop.circle")
                        .font(.title3)
                        .symbolRenderingMode(.hierarchical)
                }
                .accessibilityLabel("Open settings")
            }
        }
        .navigationDestination(item: $selectedCategory) { category in
            TemplateCategoryDetailView(
                category: category,
                templates: appState.templates.filter { $0.category == category },
                onSelect: openCreate(with:)
            )
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("VisualKit")
                .font(.caption.weight(.bold))
                .tracking(1.5)
                .foregroundStyle(VisualKitTheme.coral)

            Text("Start from a reusable image template.")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            Text("Browse preset templates, edit the style and prompt, then generate with or without a reference image.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var featuredTemplateSection: some View {
        if let template = appState.templates.first(where: { $0.featured == true }) ?? appState.templates.first {
            FeaturedTemplateCard(template: template) {
                openCreate(with: template)
            }
        }
    }

    private var templateCategoriesSection: some View {
        VStack(alignment: .leading, spacing: 22) {
            ForEach(categoryRows, id: \.category) { row in
                TemplateCategoryRow(
                    category: row.category,
                    templates: row.templates,
                    onSelect: openCreate(with:),
                    onSeeAll: {
                        selectedCategory = row.category
                    }
                )
            }
        }
        .padding(.horizontal, -VisualKitTheme.horizontalPadding)
    }

    private var stylesSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeading(
                title: "Saved Styles",
                actionTitle: "See all",
                action: openStyles
            )

            ScrollView(.horizontal) {
                LazyHStack(spacing: 12) {
                    if appState.savedStyles.isEmpty {
                        VisualKitEmptyState(
                            title: "No saved styles",
                            message: "Analyze a reference image in Create and save its Visual DNA for reuse.",
                            symbol: "bookmark",
                            actionTitle: "Analyze Reference",
                            action: openCreate
                        )
                        .frame(width: 280)
                    } else {
                        ForEach(appState.savedStyles.prefix(6)) { style in
                            StylePreviewCard(style: style)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .contentMargins(.trailing, 20, for: .scrollContent)
        }
        .padding(.horizontal, -VisualKitTheme.horizontalPadding)
        .padding(.leading, VisualKitTheme.horizontalPadding)
    }

    private var recentSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeading(
                title: "Recent Gallery",
                actionTitle: "See all",
                action: openCreations
            )

            ScrollView(.horizontal) {
                LazyHStack(spacing: 12) {
                    if appState.creations.isEmpty {
                        VisualKitEmptyState(
                            title: "No generated images yet",
                            message: "Generate your first image and it will appear in your Gallery.",
                            symbol: "photo.on.rectangle.angled",
                            actionTitle: "Create Image",
                            action: openCreate
                        )
                        .frame(width: 280)
                    } else {
                        ForEach(appState.creations.prefix(6)) { creation in
                            CreationThumbnail(creation: creation, compact: true)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .contentMargins(.trailing, 20, for: .scrollContent)
        }
        .padding(.horizontal, -VisualKitTheme.horizontalPadding)
        .padding(.leading, VisualKitTheme.horizontalPadding)
    }

    private func openCreate() {
        appState.selectedTab = .create
    }

    private func openCreate(with template: Template) {
        appState.useTemplate(template)
    }

    private func openStyles() {
        appState.selectedTab = .styles
    }

    private func openCreations() {
        appState.selectedTab = .creations
    }
}

struct SectionHeading: View {
    let title: String
    let actionTitle: String?
    let action: (() -> Void)?

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.title3.weight(.bold))
                .foregroundStyle(.primary)

            Spacer()

            if let actionTitle, let action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(VisualKitTheme.coral)
                        .padding(.horizontal, 12)
                        .frame(minHeight: 32)
                        .background(VisualKitTheme.surface)
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .stroke(VisualKitTheme.coral.opacity(0.55), lineWidth: 1)
                        }
                }
                .buttonStyle(.plain)
            }
        }
    }
}

private struct FeaturedTemplateCard: View {
    let template: Template
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack(alignment: .bottomLeading) {
                TemplateArtwork(template: template)
                    .frame(minHeight: 224)

                VStack(alignment: .leading, spacing: 16) {
                    HStack {
                        Label(template.category.title.uppercased(), systemImage: template.thumbnail)
                            .font(.caption.weight(.bold))
                            .tracking(0.9)
                            .lineLimit(1)
                            .foregroundStyle(.white.opacity(0.8))
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                    }

                    VStack(alignment: .leading, spacing: 7) {
                        Text(template.name)
                            .font(.title2.weight(.bold))
                            .foregroundStyle(.white)
                            .lineLimit(2)
                        Text(template.description)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.76))
                            .lineLimit(3)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(20)
            }
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Use \(template.name) template")
    }
}

private struct TemplateCategoryRow: View {
    let category: TemplateCategory
    let templates: [Template]
    let onSelect: (Template) -> Void
    let onSeeAll: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeading(title: category.title, actionTitle: "See all", action: onSeeAll)
                .padding(.horizontal, VisualKitTheme.horizontalPadding)

            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 12) {
                    ForEach(templates) { template in
                        HomeTemplateCard(template: template) {
                            onSelect(template)
                        }
                    }
                }
                .padding(.horizontal, VisualKitTheme.horizontalPadding)
            }
            .scrollIndicators(.hidden)
            .contentMargins(.trailing, VisualKitTheme.horizontalPadding, for: .scrollContent)
        }
    }
}

private struct TemplateCategoryDetailView: View {
    let category: TemplateCategory
    let templates: [Template]
    let onSelect: (Template) -> Void
    @State private var selectedStyle: String?
    @State private var selectedScene: String?

    private let columns = [
        GridItem(.flexible(), spacing: 12),
        GridItem(.flexible(), spacing: 12)
    ]

    private var availableStyles: [String] {
        TemplateFilterTaxonomy.styleOrder
    }

    private var availableScenes: [String] {
        TemplateFilterTaxonomy.sceneOrder
    }

    private var filteredTemplates: [Template] {
        templates.filter { template in
            let matchesStyle = selectedStyle.map { template.styles.contains($0) } ?? true
            let matchesScene = selectedScene.map { template.scenes.contains($0) } ?? true
            return matchesStyle && matchesScene
        }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                FilterChipSection(
                    title: "Style",
                    values: availableStyles,
                    selection: $selectedStyle
                )

                FilterChipSection(
                    title: "Scene",
                    values: availableScenes,
                    selection: $selectedScene
                )

                LazyVGrid(columns: columns, alignment: .leading, spacing: 14) {
                    ForEach(filteredTemplates) { template in
                        CategoryTemplateGridCard(template: template) {
                            onSelect(template)
                        }
                    }
                }
            }
            .padding(.horizontal, VisualKitTheme.horizontalPadding)
            .padding(.top, 14)
            .padding(.bottom, 108)
        }
        .scrollIndicators(.hidden)
        .background(VisualKitTheme.paper.ignoresSafeArea())
        .navigationTitle(category.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct FilterChipSection: View {
    let title: String
    let values: [String]
    @Binding var selection: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline.weight(.bold))
                .foregroundStyle(.primary)

            ScrollView(.horizontal) {
                LazyHStack(spacing: 8) {
                    FilterChip(
                        title: "All",
                        isSelected: selection == nil
                    ) {
                        selection = nil
                    }

                    ForEach(values, id: \.self) { value in
                        FilterChip(
                            title: value,
                            isSelected: selection == value
                        ) {
                            selection = value
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .contentMargins(.trailing, VisualKitTheme.horizontalPadding, for: .scrollContent)
        }
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .lineLimit(1)
                .foregroundStyle(isSelected ? VisualKitTheme.deepInk : .primary)
                .padding(.horizontal, 14)
                .frame(minHeight: 40)
                .background(isSelected ? VisualKitTheme.mint.opacity(0.22) : VisualKitTheme.surface)
                .clipShape(Capsule())
                .overlay {
                    Capsule()
                        .stroke(
                            isSelected ? VisualKitTheme.mint : VisualKitTheme.line,
                            lineWidth: isSelected ? 1.5 : 1
                        )
                }
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

private struct CategoryTemplateGridCard: View {
    let template: Template
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                TemplateArtwork(template: template)
                    .aspectRatio(1, contentMode: .fill)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(alignment: .topTrailing) {
                        Image(systemName: template.thumbnail)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 28, height: 28)
                            .background(.black.opacity(0.36), in: Circle())
                            .padding(8)
                    }

                VStack(alignment: .leading, spacing: 5) {
                    Text(template.name)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(template.description)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .padding(9)
            .frame(maxWidth: .infinity, alignment: .leading)
            .visualkitSurface(cornerRadius: 18)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Use \(template.name) template")
    }
}

private struct HomeTemplateCard: View {
    let template: Template
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 10) {
                TemplateArtwork(template: template)
                    .frame(width: 182, height: 132)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay(alignment: .topTrailing) {
                        Image(systemName: template.thumbnail)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 28, height: 28)
                            .background(.black.opacity(0.36), in: Circle())
                            .padding(8)
                    }

                VStack(alignment: .leading, spacing: 5) {
                    Text(template.name)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    Text(template.styleSummary.isEmpty ? template.sceneSummary : template.styleSummary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(9)
            .frame(width: 200, alignment: .leading)
            .visualkitSurface(cornerRadius: 18)
        }
        .buttonStyle(.plain)
        .accessibilityLabel("Use \(template.name) template")
    }
}

private struct TemplateArtwork: View {
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

                    GeometryReader { proxy in
                        ZStack {
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .fill(.white.opacity(0.14))
                                .frame(width: proxy.size.width * 0.58, height: proxy.size.height * 0.52)
                                .rotationEffect(.degrees(-12))
                                .offset(x: proxy.size.width * 0.28, y: proxy.size.height * 0.04)

                            Circle()
                                .fill(.white.opacity(0.11))
                                .frame(width: proxy.size.width * 0.42)
                                .offset(x: -proxy.size.width * 0.22, y: -proxy.size.height * 0.26)

                            Image(systemName: template.thumbnail)
                                .font(.system(size: min(proxy.size.width, proxy.size.height) * 0.26, weight: .semibold))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.white.opacity(0.82))
                                .offset(x: proxy.size.width * 0.14, y: -proxy.size.height * 0.02)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                    }
                }
            }
        }
    }
}

struct StylePreviewCard: View {
    @EnvironmentObject private var appState: AppState
    let style: SavedStyle

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                stylePreview
                    .frame(width: 164, height: 116)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))

                Label("Saved Look", systemImage: "bookmark.fill")
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.white.opacity(0.94))
                    .padding(.horizontal, 8)
                    .frame(minHeight: 24)
                    .background(.black.opacity(0.42), in: Capsule())
                    .padding(8)
            }

            VStack(alignment: .leading, spacing: 3) {
                Text(style.name)
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                Text(tagSummary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
        }
        .padding(9)
        .frame(width: 182, alignment: .leading)
        .visualkitSurface(cornerRadius: 18)
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var stylePreview: some View {
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
            StyleArtwork(colors: style.dna.palette)
        }
    }

    private var previewRefreshURL: (() async throws -> URL)? {
        guard let assetID = style.previewAssetID else { return nil }
        return { try await appState.backend.downloadURL(for: assetID).downloadURL }
    }

    private var tagSummary: String {
        let tags = [
            style.dna.style.first?.value,
            style.dna.lighting.first?.value,
            style.dna.colorPalette.first?.value
        ]
        .compactMap { $0 }

        return tags.isEmpty ? "\(style.dna.attributeCount) visual traits" : tags.joined(separator: " · ")
    }
}

private struct StyleArtwork: View {
    let colors: [String]

    var body: some View {
        ZStack {
            LinearGradient(
                colors: colors.map(VisualKitTheme.color(for:)),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            Circle()
                .fill(.white.opacity(0.18))
                .frame(width: 100, height: 100)
                .offset(x: 36, y: -28)
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.28), lineWidth: 1)
                .frame(width: 92, height: 70)
                .rotationEffect(.degrees(-18))
                .offset(x: -12, y: 12)
        }
    }
}

private struct HomeArtwork: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Circle()
                    .fill(VisualKitTheme.coral.opacity(0.72))
                    .frame(width: proxy.size.width * 0.66)
                    .blur(radius: 16)
                    .offset(x: proxy.size.width * 0.25, y: -proxy.size.height * 0.18)
                Circle()
                    .fill(VisualKitTheme.mint.opacity(0.75))
                    .frame(width: proxy.size.width * 0.54)
                    .blur(radius: 10)
                    .offset(x: proxy.size.width * 0.34, y: proxy.size.height * 0.33)
                RoundedRectangle(cornerRadius: 42, style: .continuous)
                    .fill(.white.opacity(0.13))
                    .frame(width: proxy.size.width * 0.52, height: proxy.size.height * 0.62)
                    .rotationEffect(.degrees(-18))
                    .offset(x: proxy.size.width * 0.28, y: proxy.size.height * 0.04)
                Image(systemName: "circle.hexagongrid.fill")
                    .font(.system(size: 56, weight: .ultraLight))
                    .foregroundStyle(.white.opacity(0.52))
                    .offset(x: proxy.size.width * 0.28, y: proxy.size.height * 0.03)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
        }
    }
}
