import SwiftUI

struct GenerationResultView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @ObservedObject var viewModel: CreateViewModel
    let jobService: any JobService

    @State private var isShowingConfiguration = false
    @State private var isShowingSaveConfirmation = false
    @State private var didSaveCreation = false
    @State private var didSaveStyle = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                resultHeader
                resultContent
            }
            .padding(.horizontal, VisualKitTheme.horizontalPadding)
            .padding(.top, 12)
            .padding(.bottom, 36)
        }
        .scrollIndicators(.hidden)
        .background(VisualKitTheme.paper.ignoresSafeArea())
        .navigationTitle("Result")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.leaveGenerationResult(using: jobService)
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                }
                .accessibilityLabel("Back to Create")
            }
        }
        .alert(
            "Saved to Gallery",
            isPresented: $isShowingSaveConfirmation
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("You can find this image in Gallery and Recent Gallery on Home.")
        }
        .onAppear {
            if let result = viewModel.generationResult,
               appState.creations.contains(where: { $0.id == result.creation.id }) {
                didSaveCreation = true
            }
        }
    }

    private var resultHeader: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Your visual direction, realized.")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.primary)

            Text("The image is generated from your prompt and the configuration you chose.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var resultContent: some View {
        if viewModel.isGenerating {
            generatingState
        } else if let message = viewModel.generationFailureMessage {
            failedState(message: message)
        } else if let result = viewModel.generationResult {
            completedState(result: result)
        } else {
            generatingState
        }
    }

    private var generatingState: some View {
        VStack(alignment: .leading, spacing: 18) {
            GenerationArtworkPlaceholder(
                colors: ["indigo", "olive", "ink"],
                aspectRatio: viewModel.draft.settings.aspectRatio,
                isAnimated: true
            )

            HStack(spacing: 12) {
                ProgressView()
                    .tint(VisualKitTheme.coral)

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.generationPhase.title)
                        .font(.headline.weight(.bold))
                    Text("This may take a moment.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding(16)
            .visualkitSurface()
            .accessibilityElement(children: .combine)
        }
    }

    private func completedState(result: GenerationResult) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            GenerationArtwork(
                creation: result.creation,
                aspectRatio: result.request.settings.aspectRatio
            )

            actionGrid(result: result)
            configurationSection(result: result)
        }
    }

    private func failedState(message: String) -> some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(spacing: 14) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(VisualKitTheme.coral)

                Text("Generation failed")
                    .font(.title3.weight(.bold))

                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)

                Button {
                    viewModel.retryGeneration(using: jobService)
                } label: {
                    Label("Retry", systemImage: "arrow.clockwise")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(VisualKitTheme.deepInk)
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity)
            .padding(24)
            .visualkitSurface(cornerRadius: 22)
        }
    }

    private func actionGrid(result: GenerationResult) -> some View {
        VStack(spacing: 10) {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 10) {
                    saveButton(result: result)
                    shareButton(result: result)
                }

                VStack(spacing: 10) {
                    saveButton(result: result)
                    shareButton(result: result)
                }
            }

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 10) {
                    regenerateButton
                    useAsReferenceButton(result: result)
                }

                VStack(spacing: 10) {
                    regenerateButton
                    useAsReferenceButton(result: result)
                }
            }

            Button {
                guard let style = viewModel.makeSavedStyleFromGeneration() else {
                    return
                }
                appState.saveStyle(style)
                didSaveStyle = true
            } label: {
                HStack(spacing: 10) {
                    Image(systemName: didSaveStyle ? "checkmark.circle.fill" : "bookmark")
                    Text(didSaveStyle ? "Look Saved" : "Save This Look")
                    Spacer()
                    if !didSaveStyle {
                        Image(systemName: "arrow.up.right")
                    }
                }
                .font(.subheadline.weight(.bold))
                .foregroundStyle(didSaveStyle ? VisualKitTheme.mint : .primary)
                .padding(.horizontal, 16)
                .frame(height: 52)
                .visualkitSurface(cornerRadius: 16)
            }
            .buttonStyle(.plain)
            .disabled(result.request.visualDNA == nil || didSaveStyle)
            .opacity(result.request.visualDNA == nil ? 0.48 : 1)
        }
    }

    private func saveButton(result: GenerationResult) -> some View {
        Button {
            saveCreation(result.creation)
        } label: {
            ResultActionLabel(
                title: didSaveCreation ? "Saved" : "Save",
                symbol: didSaveCreation ? "checkmark" : "square.and.arrow.down",
                tint: VisualKitTheme.coral
            )
        }
        .buttonStyle(.plain)
    }

    private func shareButton(result: GenerationResult) -> some View {
        ShareLink(item: shareText(for: result)) {
            ResultActionLabel(
                title: "Share",
                symbol: "square.and.arrow.up",
                tint: VisualKitTheme.indigo
            )
        }
    }

    private var regenerateButton: some View {
        Button {
            viewModel.retryGeneration(using: jobService)
        } label: {
            ResultActionLabel(
                title: "Regenerate",
                symbol: "arrow.clockwise",
                tint: VisualKitTheme.olive
            )
        }
        .buttonStyle(.plain)
    }

    private func useAsReferenceButton(result: GenerationResult) -> some View {
        Button {
            appState.useCreationAsReference(result.creation)
            dismiss()
        } label: {
            ResultActionLabel(
                title: "Use as Reference",
                symbol: "photo",
                tint: VisualKitTheme.mint
            )
        }
        .buttonStyle(.plain)
    }

    private func configurationSection(result: GenerationResult) -> some View {
        DisclosureGroup(isExpanded: $isShowingConfiguration) {
            GenerationConfigurationDetails(request: result.request)
                .padding(.top, 10)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "slider.horizontal.3")
                    .foregroundStyle(VisualKitTheme.coral)
                Text("View configuration")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text(result.request.template.name)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .visualkitSurface()
    }

    private func saveCreation(_ creation: Creation) {
        guard !didSaveCreation else {
            isShowingSaveConfirmation = true
            return
        }
        appState.addCreation(creation)
        didSaveCreation = true
        isShowingSaveConfirmation = true
    }

    private func shareText(for result: GenerationResult) -> String {
        "VisualKit\n\(result.request.userPrompt)\n\(result.request.template.name) • \(result.request.settings.aspectRatio.rawValue)"
    }
}

private struct ResultActionLabel: View {
    let title: String
    let symbol: String
    let tint: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.headline.weight(.semibold))
                .foregroundStyle(tint)
                .frame(width: 30, height: 30)
                .background(tint.opacity(0.14), in: Circle())

            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 78)
        .visualkitSurface(cornerRadius: 16)
        .accessibilityElement(children: .combine)
    }
}

private struct GenerationArtwork: View {
    let creation: Creation
    let aspectRatio: AspectRatio
    @State private var isShowingExpandedImage = false

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if creation.generatedImage != nil || creation.generatedImageURL != nil {
                CreationImageView(creation: creation)
                    .aspectRatio(aspectRatio.value, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            } else {
                GenerationArtworkPlaceholder(
                    colors: creation.palette,
                    aspectRatio: aspectRatio,
                    isAnimated: false
                )
            }

            HStack(spacing: 7) {
                Image(systemName: "sparkles")
                Text("Generated with VisualKit")
            }
            .font(.caption.weight(.semibold))
            .foregroundStyle(.white.opacity(0.92))
            .padding(14)

            if canExpand {
                Button {
                    isShowingExpandedImage = true
                } label: {
                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.white)
                        .frame(width: 42, height: 42)
                        .background(.black.opacity(0.48), in: Circle())
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.18), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(12)
                .accessibilityLabel("Maximize generated image")
            }
        }
        .fullScreenCover(isPresented: $isShowingExpandedImage) {
            ExpandedGenerationImageView(creation: creation)
        }
    }

    private var canExpand: Bool {
        creation.generatedImage != nil || creation.generatedImageURL != nil
    }
}

private struct ExpandedGenerationImageView: View {
    @Environment(\.dismiss) private var dismiss
    let creation: Creation

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            CreationImageView(creation: creation, contentMode: .fit)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.horizontal, 12)
                .padding(.vertical, 56)

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .frame(width: 44, height: 44)
                    .background(.white.opacity(0.16), in: Circle())
            }
            .buttonStyle(.plain)
            .padding(.top, 18)
            .padding(.trailing, 18)
            .accessibilityLabel("Close")
        }
    }
}

private struct GenerationArtworkPlaceholder: View {
    let colors: [String]
    let aspectRatio: AspectRatio
    let isAnimated: Bool

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                LinearGradient(
                    colors: colors.map(VisualKitTheme.color(for:)),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )

                Circle()
                    .fill(.white.opacity(0.18))
                    .frame(width: proxy.size.width * 0.72)
                    .offset(
                        x: proxy.size.width * 0.28,
                        y: -proxy.size.height * 0.28
                    )

                RoundedRectangle(cornerRadius: 34, style: .continuous)
                    .fill(.black.opacity(0.14))
                    .frame(
                        width: proxy.size.width * 0.58,
                        height: proxy.size.height * 0.28
                    )
                    .rotationEffect(.degrees(-14))
                    .offset(
                        x: -proxy.size.width * 0.14,
                        y: proxy.size.height * 0.16
                    )

                Image(systemName: isAnimated ? "wand.and.stars" : "circle.hexagongrid.fill")
                    .font(.system(size: isAnimated ? 46 : 54, weight: .ultraLight))
                    .foregroundStyle(.white.opacity(0.68))
                    .symbolEffect(.pulse, isActive: isAnimated)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
        }
        .aspectRatio(aspectRatio.value, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct GenerationConfigurationDetails: View {
    let request: ImageGenerationRequest

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ConfigurationRow(title: "Original prompt", value: request.userPrompt)
            ConfigurationRow(title: "Template", value: request.template.name)
            ConfigurationRow(
                title: "Aspect ratio",
                value: request.settings.aspectRatio.rawValue
            )
            ConfigurationRow(
                title: "Preserved",
                value: request.preservation.preservedCategories
                    .map(\.preservationTitle)
                    .joined(separator: ", ")
            )

            VStack(alignment: .leading, spacing: 7) {
                Text("Selected Visual DNA")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)

                if let visualDNA = request.visualDNA {
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
                } else {
                    Text("None selected")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}

private struct ConfigurationRow: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
            Text(value.isEmpty ? "None selected" : value)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

private extension AspectRatio {
    var value: CGFloat {
        switch self {
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
