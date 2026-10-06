import SwiftUI

struct CreationsView: View {
    @EnvironmentObject private var appState: AppState
    @State private var selectedCreation: Creation?
    @State private var creationToDelete: Creation?

    private let columns = [
        GridItem(.adaptive(minimum: 154), spacing: 12)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                header

                if appState.creations.isEmpty {
                    emptyState
                } else {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(appState.creations) { creation in
                            CreationGridCard(
                                creation: creation,
                                open: { selectedCreation = creation },
                                regenerate: { appState.regenerateCreation(creation) },
                                useAsReference: { appState.useCreationAsReference(creation) },
                                useStyle: { appState.useCreationStyle(creation) },
                                delete: { creationToDelete = creation }
                            )
                        }
                    }
                }
            }
            .padding(VisualKitTheme.horizontalPadding)
            .padding(.bottom, 120)
        }
        .scrollIndicators(.hidden)
        .background(VisualKitTheme.paper.ignoresSafeArea())
        .navigationTitle("Gallery")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedCreation) { creation in
            CreationDetailView(creation: creation)
        }
        .alert(
            "Delete Gallery Image?",
            isPresented: Binding(
                get: { creationToDelete != nil },
                set: { if !$0 { creationToDelete = nil } }
            )
        ) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                guard let creationToDelete else { return }
                appState.deleteCreation(creationToDelete)
                self.creationToDelete = nil
            }
        } message: {
            Text("This removes the generated image from your Gallery.")
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Generated Gallery")
                .font(.largeTitle.weight(.bold))

            Text("Browse generated images, including prompts, templates, and style settings used to create them.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }

    private var emptyState: some View {
        VisualKitEmptyState(
            title: "No generated images yet",
            message: "Generate an image in Create and it will appear in your Gallery.",
            symbol: "photo.on.rectangle.angled",
            actionTitle: "Create Image",
            action: { appState.selectedTab = .create }
        )
    }

}

private struct CreationGridCard: View {
    let creation: Creation
    let open: () -> Void
    let regenerate: () -> Void
    let useAsReference: () -> Void
    let useStyle: () -> Void
    let delete: () -> Void
    @State private var isShowingShareSheet = false

    var body: some View {
        VStack(alignment: .leading, spacing: 9) {
            Button(action: open) {
                ZStack {
                    if creation.status == .processing {
                        processingArtwork
                    } else if creation.status == .failed {
                        failedArtwork
                    } else {
                        CreationImageView(creation: creation, useThumbnail: true)
                    }
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(0.82, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 17, style: .continuous))
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 4) {
                Text(creation.prompt)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)

                Text(creation.template.name)
                    .font(.caption.weight(.medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            if creation.status == .failed {
                Button(action: regenerate) {
                    Label("Retry", systemImage: "arrow.clockwise")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(VisualKitTheme.coral)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(8)
        .visualkitSurface(cornerRadius: 18)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(creation.prompt), \(creation.status.title)")
        .sheet(isPresented: $isShowingShareSheet) {
            CreationShareSheet(items: CreationShareSheet.items(for: creation))
        }
        .contextMenu {
            Button(action: open) {
                Label("Open", systemImage: "arrow.up.right.square")
            }

            if creation.status == .completed {
                Button {
                    isShowingShareSheet = true
                } label: {
                    Label("Share", systemImage: "square.and.arrow.up")
                }

                Button(action: regenerate) {
                    Label("Regenerate", systemImage: "arrow.clockwise")
                }

                Button(action: useAsReference) {
                    Label("Use as Reference", systemImage: "photo")
                }

                if creation.visualDNA != nil {
                    Button(action: useStyle) {
                        Label("Use Style", systemImage: "bookmark")
                    }
                }
            } else if creation.status == .failed {
                Button(action: regenerate) {
                    Label("Retry", systemImage: "arrow.clockwise")
                }
            }

            Button(role: .destructive, action: delete) {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private var processingArtwork: some View {
        ZStack {
            LinearGradient(
                colors: [VisualKitTheme.deepInk, VisualKitTheme.indigo],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            ProgressView()
                .tint(.white)
                .scaleEffect(1.15)
        }
    }

    private var failedArtwork: some View {
        ZStack {
            VisualKitTheme.surface
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(VisualKitTheme.coral)
                Text("Needs retry")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
    }
}
