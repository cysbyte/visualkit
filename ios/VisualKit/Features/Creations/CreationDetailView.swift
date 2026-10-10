import SwiftUI
import UIKit

struct CreationDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @State private var isShowingDetails = false
    @State private var isShowingDeleteConfirmation = false
    @State private var isShowingShareSheet = false

    let creation: Creation

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                artwork
                actionBar
                details
            }
            .padding(VisualKitTheme.horizontalPadding)
            .padding(.bottom, 36)
        }
        .scrollIndicators(.hidden)
        .background(VisualKitTheme.paper.ignoresSafeArea())
        .navigationTitle("Gallery Image")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $isShowingShareSheet) {
            CreationShareSheet(items: CreationShareSheet.items(for: creation))
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        appState.regenerateCreation(creation)
                    } label: {
                        Label("Regenerate", systemImage: "arrow.clockwise")
                    }

                    Button {
                        appState.useCreationAsReference(creation)
                    } label: {
                        Label("Use as Reference", systemImage: "photo")
                    }

                    if creation.visualDNA != nil {
                        Button {
                            appState.useCreationStyle(creation)
                        } label: {
                            Label("Use Style", systemImage: "bookmark")
                        }
                    }

                    Button(role: .destructive) {
                        isShowingDeleteConfirmation = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .font(.title3)
                }
                .accessibilityLabel("Gallery image actions")
            }
        }
        .alert("Delete Gallery Image?", isPresented: $isShowingDeleteConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                appState.deleteCreation(creation)
                dismiss()
            }
        } message: {
            Text("This removes the generated image from your Gallery.")
        }
    }

    private var artwork: some View {
        ZStack(alignment: .bottomLeading) {
            if creation.status == .processing {
                Rectangle()
                    .fill(VisualKitTheme.deepInk)
                    .overlay {
                        VStack(spacing: 12) {
                            ProgressView()
                                .tint(.white)
                            Text("Creating your image...")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.white)
                        }
                    }
            } else if creation.status == .failed {
                Rectangle()
                    .fill(VisualKitTheme.surface)
                    .overlay {
                        VStack(spacing: 12) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.largeTitle)
                                .foregroundStyle(VisualKitTheme.coral)
                            Text(creation.failureMessage ?? "Generation failed")
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 24)
                        }
                    }
            } else {
                CreationImageView(creation: creation)
            }

            if creation.status == .completed {
                Label("Generated with VisualKit", systemImage: "sparkles")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.94))
                    .padding(14)
            }
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(aspectRatio, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private var actionBar: some View {
        HStack(spacing: 10) {
            if canShare {
                Button {
                    isShowingShareSheet = true
                } label: {
                    DetailActionLabel(title: "Share", symbol: "square.and.arrow.up")
                }
            }

            Button {
                appState.regenerateCreation(creation)
            } label: {
                DetailActionLabel(title: "Regenerate", symbol: "arrow.clockwise")
            }
            .disabled(creation.generationRequest == nil && creation.status != .failed)

            Button {
                appState.useCreationAsReference(creation)
            } label: {
                DetailActionLabel(title: "Reference", symbol: "photo")
            }
            .disabled(!canUseAsReference)
        }
        .buttonStyle(.plain)
    }

    private var canShare: Bool {
        creation.status == .completed && (creation.generatedImage != nil || creation.generatedImageURL != nil)
    }

    private var canUseAsReference: Bool {
        creation.status == .completed && (creation.generatedImage != nil || creation.generatedImageURL != nil)
    }

    private var details: some View {
        DisclosureGroup(isExpanded: $isShowingDetails) {
            VStack(alignment: .leading, spacing: 18) {
                TemplatePreviewTile(template: creation.template)
                DetailRow(title: "Original prompt", value: creation.prompt)
                DetailRow(title: "Template", value: creation.template.name)
                DetailRow(title: "Aspect ratio", value: creation.settings.aspectRatio.rawValue)
                DetailRow(
                    title: "Preserved",
                    value: creation.preservation.preservedCategories
                        .map(\.preservationTitle)
                        .joined(separator: ", ")
                )

                if let visualDNA = creation.visualDNA {
                    VStack(alignment: .leading, spacing: 9) {
                        Text("Visual DNA")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)

                        ForEach(VisualDNACategory.preservationOrder) { category in
                            let values = visualDNA.values(for: category).map(\.value)
                            if !values.isEmpty {
                                HStack(alignment: .top, spacing: 8) {
                                    Text(category.preservationTitle)
                                        .font(.caption.weight(.semibold))
                                        .frame(width: 92, alignment: .leading)
                                    Text(values.joined(separator: ", "))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }

                if let referenceImage = creation.referenceImage {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Reference image")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                        if let image = UIImage(data: referenceImage.data) {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(height: 120)
                                .clipped()
                                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        }
                    }
                }
            }
            .padding(.top, 12)
        } label: {
            Label("View details", systemImage: "slider.horizontal.3")
                .font(.subheadline.weight(.semibold))
        }
        .padding(16)
        .visualkitSurface()
    }

    private var aspectRatio: CGFloat {
        switch creation.settings.aspectRatio {
        case .square:
            return 1
        case .portrait:
            return 4.0 / 5.0
        case .story:
            return 9.0 / 16.0
        case .landscape:
            return 16.0 / 9.0
        }
    }
}

private struct DetailActionLabel: View {
    let title: String
    let symbol: String

    var body: some View {
        VStack(spacing: 7) {
            Image(systemName: symbol)
                .font(.headline.weight(.semibold))
                .foregroundStyle(VisualKitTheme.coral)
                .frame(width: 30, height: 30)
                .background(VisualKitTheme.coral.opacity(0.14), in: Circle())
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 72)
        .visualkitSurface(cornerRadius: 16)
        .accessibilityElement(children: .combine)
    }
}

private struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
            Text(value.isEmpty ? "None selected" : value)
                .font(.subheadline)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
