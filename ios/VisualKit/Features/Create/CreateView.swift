import PhotosUI
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct CreateView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var viewModel = CreateViewModel()
    @FocusState private var isPromptFocused: Bool
    @State private var isShowingImagePicker = false
    @State private var isShowingAIPrompt = false
    @State private var isShowingTemplatePreview = false
    @State private var promptFieldBeingEdited: String?
    @State private var promptFieldReplacement = ""
    @State private var activeCreationID: UUID?

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: VisualKitTheme.sectionSpacing) {
                        titleBlock
                        selectedTemplateOverview
                        templateMetadataSection
                        referenceSection
                        promptSection
                        styleSection
                        preservationSection
                        aspectRatioSection
                        aiPromptSection
                        validationMessage
                    }
                    .padding(.horizontal, VisualKitTheme.horizontalPadding)
                    .padding(.top, 14)
                    .padding(.bottom, 126)
                }
                .scrollIndicators(.hidden)
                .scrollDismissesKeyboard(.interactively)
                .onChange(of: isPromptFocused) { _, focused in
                    guard focused else { return }
                    withAnimation(.snappy) {
                        proxy.scrollTo("prompt-field", anchor: .center)
                    }
                }
            }

            generateButton
        }
        .background(VisualKitTheme.paper.ignoresSafeArea())
        .navigationTitle("Create")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            applyPendingStyle()
            viewModel.reconcileTemplates(appState.templates)
        }
        .onChange(of: appState.templates) { _, templates in
            viewModel.reconcileTemplates(templates)
        }
        .onChange(of: appState.pendingStyle) { _, _ in
            applyPendingStyle()
        }
        .onChange(of: appState.pendingReferenceImage) { _, _ in
            applyPendingStyle()
        }
        .onChange(of: appState.pendingCreateDraft) { _, _ in
            applyPendingStyle()
        }
        .onChange(of: viewModel.generationResult) { _, result in
            guard let result, let activeCreationID else {
                return
            }
            appState.replaceCreation(id: activeCreationID, with: result.creation)
            self.activeCreationID = nil
        }
        .onChange(of: viewModel.generationFailureMessage) { _, message in
            guard let message, let activeCreationID else {
                return
            }
            appState.markCreationFailed(id: activeCreationID, message: message)
            self.activeCreationID = nil
        }
        .onChange(of: viewModel.isGenerating) { _, isGenerating in
            if isGenerating, activeCreationID == nil {
                activeCreationID = appState.addProcessingCreation(
                    for: viewModel.activeGenerationRequest ?? viewModel.generationRequest
                )
                return
            }

            guard !isGenerating,
                  viewModel.generationResult == nil,
                  viewModel.generationFailureMessage == nil,
                  let activeCreationID else {
                return
            }
            appState.removeCreation(id: activeCreationID)
            self.activeCreationID = nil
        }
        .onDisappear {
            if !viewModel.isShowingGenerationResult && !viewModel.shouldShowVisualDNA {
                viewModel.cancelOperations(using: appState.jobService)
            }
        }
        .navigationDestination(isPresented: $viewModel.shouldShowVisualDNA) {
            if let referenceImage = viewModel.draft.referenceImage,
               let visualDNA = viewModel.draft.visualDNA {
                VisualDNAView(
                    viewModel: viewModel,
                    dna: Binding(
                        get: { viewModel.draft.visualDNA ?? visualDNA },
                        set: { viewModel.draft.visualDNA = $0 }
                    ),
                    referenceImage: referenceImage,
                    jobService: appState.jobService,
                    preservation: $viewModel.draft.preservation,
                    onContinue: {
                        viewModel.draft.selectedStyle = .fromReference
                        viewModel.shouldShowVisualDNA = false
                    },
                    onSaveStyle: { style in
                        appState.saveStyle(style)
                    }
                )
            } else {
                ContentUnavailableView(
                    "Visual DNA unavailable",
                    systemImage: "circle.hexagongrid",
                    description: Text("Analyze a reference image to continue.")
                )
            }
        }
        .navigationDestination(isPresented: $viewModel.isShowingGenerationResult) {
            GenerationResultView(
                viewModel: viewModel,
                jobService: appState.jobService
            )
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isPromptFocused = false
                }
            }
        }
        .sheet(isPresented: $isShowingImagePicker) {
            ReferenceImagePicker { result in
                isShowingImagePicker = false
                guard let result else { return }
                Task {
                    await viewModel.importReference(
                        from: result,
                        using: appState.imageSelection,
                        uploadService: appState.imageUpload
                    )
                }
            }
        }
        .sheet(isPresented: $isShowingTemplatePreview) {
            TemplateImagePreviewSheet(template: viewModel.draft.selectedTemplate)
        }
        .alert(
            "Something went wrong",
            isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.errorMessage ?? "")
        }
        .alert(
            "Edit Field",
            isPresented: Binding(
                get: { promptFieldBeingEdited != nil },
                set: { if !$0 { promptFieldBeingEdited = nil } }
            )
        ) {
            TextField(promptFieldBeingEdited ?? "", text: $promptFieldReplacement)
            Button("Replace") {
                replacePromptField()
            }
            .disabled(promptFieldReplacement.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            Button("Cancel", role: .cancel) {
                promptFieldBeingEdited = nil
                promptFieldReplacement = ""
            }
        } message: {
            Text("Replace \(promptFieldBeingEdited ?? "this field") everywhere in the prompt.")
        }
    }

    private var titleBlock: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("Make it yours.")
                .font(.largeTitle.weight(.bold))
                .foregroundStyle(.primary)
            Text("Start from the selected template, then adjust the prompt or add a reference image before generating.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .accessibilityElement(children: .combine)
    }

    private func applyPendingStyle() {
        if let pendingDraft = appState.pendingCreateDraft {
            viewModel.draft = pendingDraft
            appState.pendingCreateDraft = nil
            appState.pendingReferenceImage = nil
            appState.pendingStyle = nil
            return
        }

        if let referenceImage = appState.pendingReferenceImage {
            viewModel.applyReferenceImage(referenceImage)
            appState.pendingReferenceImage = nil
        }

        guard let style = appState.pendingStyle else {
            return
        }
        viewModel.applyStyle(style)
        appState.pendingStyle = nil
    }

    private var referenceSection: some View {
        CreateSection(title: "Reference Image", detail: "OPTIONAL") {
            if viewModel.isPreparingReference || viewModel.isUploadingReference {
                HStack(spacing: 12) {
                    ProgressView()
                    VStack(alignment: .leading, spacing: 3) {
                        Text(viewModel.isUploadingReference ? "Uploading image..." : "Preparing image...")
                            .font(.subheadline.weight(.semibold))
                        Text(viewModel.isUploadingReference ? "Securing it with the VisualKit API" : "Optimizing it for local use")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                        if let progress = viewModel.referenceUploadProgress {
                            ProgressView(value: progress)
                                .tint(VisualKitTheme.coral)
                                .frame(maxWidth: 180)
                        }
                    }
                    Spacer()
                }
                .padding(16)
                .visualkitSurface()
                .accessibilityElement(children: .combine)
            } else if let image = viewModel.draft.referenceImage {
                selectedReferenceView(image)
            } else {
                Button {
                    isShowingImagePicker = true
                } label: {
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(VisualKitTheme.deepInk)
                            Image(systemName: "plus")
                                .font(.headline.weight(.bold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 54, height: 54)

                        VStack(alignment: .leading, spacing: 3) {
                            Text("Add Image")
                                .font(.subheadline.weight(.bold))
                                .foregroundStyle(.primary)
                            Text("Use a photo to guide the visual direction")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.secondary)
                    }
                    .padding(12)
                    .visualkitSurface()
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Add reference image")
                .accessibilityHint("Opens the photo picker")
            }
        }
    }

    private func selectedReferenceView(_ image: SelectedImage) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .topTrailing) {
                if let uiImage = UIImage(data: image.data) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 220)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(VisualKitTheme.surface)
                        .frame(height: 220)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        }
                }

                Button {
                    viewModel.removeReference()
                } label: {
                    Image(systemName: "xmark")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.primary)
                        .frame(width: 30, height: 30)
                        .background(.thinMaterial, in: Circle())
                }
                .buttonStyle(.plain)
                .padding(12)
                .accessibilityLabel("Remove reference image")
            }
            .clipShape(RoundedRectangle(cornerRadius: VisualKitTheme.cardRadius, style: .continuous))

            ViewThatFits(in: .horizontal) {
                HStack(spacing: 10) {
                    referenceActions
                }

                VStack(alignment: .leading, spacing: 10) {
                    referenceActions
                }
            }

            Text("\(image.pixelWidth) x \(image.pixelHeight) px  •  \(formattedByteCount(image.byteCount))")
                .font(.caption)
                .foregroundStyle(.secondary)

            if viewModel.draft.visualDNA != nil {
                Button {
                    viewModel.shouldShowVisualDNA = true
                } label: {
                    Label("View & edit Visual DNA", systemImage: "circle.hexagongrid")
                        .font(.subheadline.weight(.semibold))
                }
                .buttonStyle(.plain)
                .foregroundStyle(VisualKitTheme.coral)
            }
        }
        .padding(10)
        .visualkitSurface(cornerRadius: 20)
    }

    private var referenceActions: some View {
        Group {
            Button {
                isShowingImagePicker = true
            } label: {
                Label("Replace", systemImage: "arrow.triangle.2.circlepath")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(VisualKitTheme.deepInk)

            Button {
                viewModel.startAnalysis(using: appState.jobService)
            } label: {
                Label(
                    viewModel.isAnalyzingReference ? "Analyzing..." : "Analyze Image",
                    systemImage: viewModel.isAnalyzingReference
                        ? "hourglass"
                        : "circle.hexagongrid"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(VisualKitTheme.coral)
            .disabled(viewModel.isAnalyzingReference)
        }
    }

    private var preservationSection: some View {
        CreateSection(title: "Preserve", detail: preservationDetail) {
            PreservationControls(
                preservation: $viewModel.draft.preservation,
                visualDNA: viewModel.draft.selectedVisualDNA
            )
        }
    }

    private var preservationDetail: String {
        guard viewModel.draft.selectedVisualDNA != nil else {
            return "NO STYLE SELECTED"
        }
        return "\(viewModel.draft.preservation.preservedCount) PRESERVED"
    }

    private var promptSection: some View {
        CreateSection(title: "Full Prompt", detail: "\(viewModel.draft.prompt.count)/4000") {
            VStack(alignment: .leading, spacing: 12) {
                EditablePromptFieldsView(
                    fields: Template.editablePromptFields(in: viewModel.draft.prompt),
                    onEdit: beginEditingPromptField(_:)
                )

                TextField(
                    "Describe what you want to create...",
                    text: $viewModel.draft.prompt,
                    axis: .vertical
                )
                .focused($isPromptFocused)
                .lineLimit(10...22)
                .font(.body)
                .foregroundStyle(.primary)
                .padding(16)
                .background(VisualKitTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(
                            isPromptFocused ? VisualKitTheme.coral : VisualKitTheme.line,
                            lineWidth: isPromptFocused ? 1.5 : 1
                        )
                }
                .onChange(of: viewModel.draft.prompt) { _, newValue in
                    if newValue.count > 4000 {
                        viewModel.draft.prompt = String(newValue.prefix(4000))
                    }
                }
                .id("prompt-field")
                .accessibilityLabel("Prompt")
                .accessibilityHint("Edit the complete prompt sent to image generation.")
            }
        }
    }

    private func beginEditingPromptField(_ field: String) {
        promptFieldBeingEdited = field
        promptFieldReplacement = ""
    }

    private func replacePromptField() {
        guard let promptFieldBeingEdited else { return }
        let replacement = promptFieldReplacement.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !replacement.isEmpty else { return }
        viewModel.draft.prompt = viewModel.draft.prompt.replacingOccurrences(
            of: promptFieldBeingEdited,
            with: replacement
        )
        self.promptFieldBeingEdited = nil
        promptFieldReplacement = ""
    }

    private var selectedTemplateOverview: some View {
        let template = viewModel.draft.selectedTemplate
        return VStack(alignment: .leading, spacing: 12) {
            TemplatePreviewArtwork(template: template)
                .frame(maxWidth: .infinity)
                .frame(height: 236)
                .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                .overlay(alignment: .topLeading) {
                    Label(template.category.title, systemImage: template.thumbnail)
                        .font(.caption.weight(.bold))
                        .lineLimit(1)
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .frame(minHeight: 30)
                        .background(.black.opacity(0.42), in: Capsule())
                        .padding(12)
                }
                .overlay(alignment: .topTrailing) {
                    Button {
                        isShowingTemplatePreview = true
                    } label: {
                        Image(systemName: "arrow.up.left.and.arrow.down.right")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 34, height: 34)
                            .background(.black.opacity(0.42), in: Circle())
                            .padding(12)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("Maximize template image")
                }

            VStack(alignment: .leading, spacing: 6) {
                Text(template.name)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(template.description)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var templateMetadataSection: some View {
        let template = viewModel.draft.selectedTemplate
        return CreateSection(title: "Template Direction", detail: template.recommendedAspectRatio.rawValue) {
            VStack(alignment: .leading, spacing: 12) {
                MetadataPillRow(
                    title: "Category",
                    values: [template.category.title],
                    symbol: "square.grid.2x2"
                )

                FlowChipGroup(
                    title: "Style",
                    values: template.styles.isEmpty ? ["custom"] : template.styles,
                    symbol: "paintbrush"
                )

                FlowChipGroup(
                    title: "Scene",
                    values: template.scenes.isEmpty ? [template.category.title] : template.scenes,
                    symbol: "square.stack.3d.down.right"
                )
            }
            .padding(14)
            .visualkitSurface(cornerRadius: 16)
        }
    }

    private var aiPromptSection: some View {
        DisclosureGroup(isExpanded: $isShowingAIPrompt) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Preview only. Your prompt stays separate from the visual direction and is never overwritten.")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Text(viewModel.aiPromptPreview)
                    .font(.caption)
                    .foregroundStyle(.primary)
                    .textSelection(.enabled)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 10)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "text.quote")
                    .foregroundStyle(VisualKitTheme.coral)
                Text("View AI Prompt")
                    .font(.subheadline.weight(.semibold))
                Spacer()
                Text("Preview")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(VisualKitTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(VisualKitTheme.line, lineWidth: 1)
        }
    }

    private var styleSection: some View {
        CreateSection(title: "Saved Style", detail: "OPTIONAL") {
            VStack(alignment: .leading, spacing: 12) {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 10) {
                        SelectionChip(
                            title: "None",
                            symbol: "circle.slash",
                            tint: VisualKitTheme.muted,
                            isSelected: isStyleSelected(.none)
                        ) {
                            viewModel.draft.selectedStyle = .none
                        }

                        SelectionChip(
                            title: "From Reference",
                            symbol: "photo",
                            tint: VisualKitTheme.mint,
                            isSelected: isStyleSelected(.fromReference),
                            isEnabled: viewModel.draft.visualDNA != nil
                        ) {
                            viewModel.draft.selectedStyle = .fromReference
                        }

                        ForEach(appState.savedStyles.prefix(4)) { style in
                            SelectionChip(
                                title: style.name,
                                symbol: "photo",
                                tint: VisualKitTheme.lavender,
                                isSelected: isStyleSelected(.savedStyle(style))
                            ) {
                                viewModel.draft.selectedStyle = .savedStyle(style)
                            }
                        }
                    }
                }
                .scrollIndicators(.hidden)

                Button {
                    appState.selectedTab = .styles
                } label: {
                    Label("See all saved styles", systemImage: "bookmark")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(VisualKitTheme.coral)
                        .padding(.horizontal, 12)
                        .frame(minHeight: 34)
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

    private var aspectRatioSection: some View {
        CreateSection(title: "Aspect Ratio", detail: "OUTPUT FORMAT") {
            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8)
                ],
                spacing: 8
            ) {
                ForEach(AspectRatio.allCases, id: \.self) { ratio in
                    Button {
                        viewModel.draft.settings.aspectRatio = ratio
                    } label: {
                        VStack(spacing: 8) {
                            Image(systemName: ratio.symbol)
                                .font(.headline)
                                .frame(height: 22)
                            Text(ratio.rawValue)
                                .font(.caption.weight(.bold).monospacedDigit())
                        }
                        .foregroundStyle(
                            viewModel.draft.settings.aspectRatio == ratio
                                ? .white
                                : .primary
                        )
                        .frame(maxWidth: .infinity, minHeight: 70)
                        .background(
                            viewModel.draft.settings.aspectRatio == ratio
                                ? VisualKitTheme.deepInk
                                : VisualKitTheme.surface
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay {
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .stroke(VisualKitTheme.line, lineWidth: 1)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var generateButton: some View {
        Button {
            isPromptFocused = false
            viewModel.startGeneration(using: appState.jobService)
        } label: {
            HStack(spacing: 10) {
                if viewModel.isGenerating {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "wand.and.stars")
                }
                Text(viewModel.isGenerating ? "Generating..." : "Generate")
                Spacer()
                if !viewModel.isGenerating {
                    Image(systemName: "arrow.up.right")
                }
            }
            .font(.headline.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(height: 58)
            .background(viewModel.canGenerate ? VisualKitTheme.deepInk : VisualKitTheme.muted)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(!viewModel.canGenerate || viewModel.isPreparingReference)
        .padding(.horizontal, VisualKitTheme.horizontalPadding)
        .padding(.top, 10)
        .padding(.bottom, 12)
        .background(
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea(edges: .bottom)
        )
        .accessibilityHint(viewModel.canGenerate ? "Starts image generation" : "Enter a prompt before generating")
    }

    @ViewBuilder
    private var validationMessage: some View {
        if let validationMessage = viewModel.validationMessage {
            Label(validationMessage, systemImage: "info.circle")
                .font(.caption)
                .foregroundStyle(VisualKitTheme.coral)
        }
    }

    private func isStyleSelected(_ style: StyleSelection) -> Bool {
        viewModel.draft.selectedStyle == style
    }

    private func formattedByteCount(_ byteCount: Int) -> String {
        ByteCountFormatter.string(fromByteCount: Int64(byteCount), countStyle: .file)
    }
}

private struct CreateSection<Content: View>: View {
    let title: String
    let detail: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)
                Spacer()
                Text(detail)
                    .font(.caption.weight(.bold))
                    .tracking(0.8)
                    .foregroundStyle(.secondary)
            }
            content
        }
    }
}

private struct SelectionChip: View {
    let title: String
    let symbol: String
    let tint: Color
    let isSelected: Bool
    var isEnabled = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: symbol)
                    .font(.caption.weight(.semibold))
                Text(title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
            }
            .foregroundStyle(isSelected ? .white : (isEnabled ? .primary : .secondary))
            .padding(.horizontal, 14)
            .frame(minHeight: 44)
            .background(
                isSelected
                    ? VisualKitTheme.deepInk
                    : VisualKitTheme.surface
            )
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(
                        isSelected ? .clear : VisualKitTheme.line,
                        lineWidth: 1
                    )
            }
            .opacity(isEnabled ? 1 : 0.48)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .tint(tint)
    }
}

private struct FlowChipGroup: View {
    let title: String
    let values: [String]
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: symbol)
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)

            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 96), spacing: 8)],
                alignment: .leading,
                spacing: 8
            ) {
                ForEach(values, id: \.self) { value in
                    Text(value)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.82)
                        .padding(.horizontal, 10)
                        .frame(maxWidth: .infinity, minHeight: 34)
                        .background(VisualKitTheme.surface)
                        .clipShape(Capsule())
                        .overlay {
                            Capsule()
                                .stroke(VisualKitTheme.line, lineWidth: 1)
                        }
                }
            }
        }
    }
}

private struct EditablePromptFieldsView: View {
    let fields: [String]
    let onEdit: (String) -> Void

    var body: some View {
        if !fields.isEmpty {
            VStack(alignment: .leading, spacing: 8) {
                Label("Editable fields", systemImage: "highlighter")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)

                LazyVGrid(
                    columns: [GridItem(.adaptive(minimum: 126), spacing: 8)],
                    alignment: .leading,
                    spacing: 8
                ) {
                    ForEach(fields, id: \.self) { field in
                        Button {
                            onEdit(field)
                        } label: {
                            Text(field)
                                .font(.caption.weight(.bold))
                                .foregroundStyle(VisualKitTheme.deepInk)
                                .lineLimit(1)
                                .minimumScaleFactor(0.78)
                                .padding(.horizontal, 10)
                                .frame(maxWidth: .infinity, minHeight: 34)
                                .background(VisualKitTheme.coral.opacity(0.14))
                                .clipShape(Capsule())
                                .overlay {
                                    Capsule()
                                        .stroke(VisualKitTheme.coral.opacity(0.5), lineWidth: 1)
                                }
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Edit \(field)")
                    }
                }
            }
            .padding(14)
            .visualkitSurface(cornerRadius: 16)
        }
    }
}

private struct MetadataPillRow: View {
    let title: String
    let values: [String]
    let symbol: String

    var body: some View {
        FlowChipGroup(title: title, values: values, symbol: symbol)
    }
}

private struct TemplatePreviewArtwork: View {
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
                            RoundedRectangle(cornerRadius: 32, style: .continuous)
                                .fill(.white.opacity(0.14))
                                .frame(width: proxy.size.width * 0.58, height: proxy.size.height * 0.5)
                                .rotationEffect(.degrees(-12))
                                .offset(x: proxy.size.width * 0.24, y: proxy.size.height * 0.02)

                            Circle()
                                .fill(.white.opacity(0.11))
                                .frame(width: proxy.size.width * 0.42)
                                .offset(x: -proxy.size.width * 0.25, y: -proxy.size.height * 0.2)

                            Image(systemName: template.thumbnail)
                                .font(.system(size: min(proxy.size.width, proxy.size.height) * 0.22, weight: .semibold))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.white.opacity(0.86))
                                .offset(x: proxy.size.width * 0.1, y: -proxy.size.height * 0.01)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipped()
                    }
                }
            }
        }
    }
}

private struct TemplateImagePreviewSheet: View {
    @Environment(\.dismiss) private var dismiss
    let template: Template

    var body: some View {
        ZStack(alignment: .top) {
            VisualKitTheme.deepInk.ignoresSafeArea()

            GeometryReader { proxy in
                TemplatePreviewArtwork(template: template)
                    .aspectRatio(1, contentMode: .fit)
                    .frame(maxWidth: proxy.size.width)
                    .padding(.horizontal, 18)
                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .center)
            }

            HStack(spacing: 12) {
                Text(template.name)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)

                Spacer()

                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(VisualKitTheme.coral)
                        .frame(width: 44, height: 44)
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close template image")
            }
            .padding(.leading, VisualKitTheme.horizontalPadding)
            .padding(.trailing, 12)
            .padding(.top, 8)
            .background(
                LinearGradient(
                    colors: [
                        VisualKitTheme.deepInk,
                        VisualKitTheme.deepInk.opacity(0.78),
                        .clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: 94)
                .ignoresSafeArea(edges: .top),
                alignment: .top
            )
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
}

private struct ReferenceImagePicker: UIViewControllerRepresentable {
    let onSelectionFinished: (PHPickerResult?) -> Void

    func makeCoordinator() -> Coordinator {
        Coordinator(onSelectionFinished: onSelectionFinished)
    }

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.filter = .images
        configuration.selectionLimit = 1
        configuration.preferredAssetRepresentationMode = .current

        let controller = PHPickerViewController(configuration: configuration)
        controller.delegate = context.coordinator
        return controller
    }

    func updateUIViewController(_ controller: PHPickerViewController, context: Context) {}

    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let onSelectionFinished: (PHPickerResult?) -> Void

        init(onSelectionFinished: @escaping (PHPickerResult?) -> Void) {
            self.onSelectionFinished = onSelectionFinished
        }

        func picker(
            _ picker: PHPickerViewController,
            didFinishPicking results: [PHPickerResult]
        ) {
            picker.dismiss(animated: true)
            DispatchQueue.main.async { [onSelectionFinished] in
                onSelectionFinished(results.first)
            }
        }
    }
}
