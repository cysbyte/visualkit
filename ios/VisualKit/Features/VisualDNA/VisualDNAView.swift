import SwiftUI
import UIKit

struct VisualDNAView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: CreateViewModel
    @Binding var dna: VisualDNA
    let referenceImage: SelectedImage
    let jobService: any JobService
    @Binding var preservation: PreservationSettings
    let onContinue: () -> Void
    let onSaveStyle: (SavedStyle) -> Void

    @State private var isShowingPrompt = false
    @State private var isShowingSaveStyle = false
    @State private var styleName = ""
    @State private var editingAttribute: EditingAttribute?
    @State private var addingCategory: VisualDNACategory?
    @State private var attributeText = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                referenceHeader
                summary
                preservationSection
                attributes
                aiPromptSection
                continueButton
            }
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 36)
        }
        .scrollIndicators(.hidden)
        .background(VisualKitTheme.paper.ignoresSafeArea())
        .navigationTitle("Visual DNA")
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear {
            viewModel.cancelAnalysis(using: jobService)
        }
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    styleName = suggestedStyleName
                    isShowingSaveStyle = true
                } label: {
                    Image(systemName: "bookmark")
                }
                .accessibilityLabel("Save Visual DNA as style")

                Button {
                    viewModel.startAnalysis(using: jobService)
                } label: {
                    Image(systemName: "arrow.clockwise")
                }
                .disabled(viewModel.isAnalyzingReference)
                .accessibilityLabel("Regenerate Visual DNA")
            }
        }
        .overlay {
            if viewModel.isAnalyzingReference {
                analysisOverlay
            }
        }
        .alert(
            "Edit attribute",
            isPresented: Binding(
                get: { editingAttribute != nil },
                set: { if !$0 { editingAttribute = nil } }
            )
        ) {
            TextField("Attribute", text: $attributeText)
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                guard let editingAttribute else { return }
                dna.edit(
                    editingAttribute.value,
                    as: attributeText,
                    in: editingAttribute.category
                )
                self.editingAttribute = nil
            }
        }
        .alert(
            "Add attribute",
            isPresented: Binding(
                get: { addingCategory != nil },
                set: { if !$0 { addingCategory = nil } }
            )
        ) {
            TextField("New attribute", text: $attributeText)
            Button("Cancel", role: .cancel) {}
            Button("Add") {
                guard let addingCategory else { return }
                dna.add(attributeText, to: addingCategory)
                self.addingCategory = nil
            }
        } message: {
            Text("Add a visual characteristic to \(addingCategory?.title ?? "this category").")
        }
        .alert(
            "Save Style",
            isPresented: $isShowingSaveStyle
        ) {
            TextField("Style name", text: $styleName)
            Button("Cancel", role: .cancel) {}
            Button("Save") {
                let trimmedName = styleName.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !trimmedName.isEmpty else { return }
                onSaveStyle(
                    SavedStyle(
                        name: trimmedName,
                        previewImage: referenceImage.data,
                        previewAssetID: referenceImage.assetID,
                        dna: dna
                    )
                )
            }
        } message: {
            Text("Give this Visual DNA a name you will recognize later.")
        }
    }

    private var referenceHeader: some View {
        VStack(alignment: .leading, spacing: 12) {
            ZStack(alignment: .bottomLeading) {
                if let image = UIImage(data: referenceImage.data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 250)
                        .clipped()
                } else {
                    Rectangle()
                        .fill(VisualKitTheme.surface)
                        .frame(height: 250)
                        .overlay {
                            Image(systemName: "photo")
                                .font(.largeTitle)
                                .foregroundStyle(.secondary)
                        }
                }

                LinearGradient(
                    colors: [.clear, .black.opacity(0.64)],
                    startPoint: .center,
                    endPoint: .bottom
                )

                HStack(spacing: 8) {
                    Image(systemName: "photo")
                    Text(referenceImage.filename)
                }
                .font(.caption.weight(.semibold))
                .foregroundStyle(.white)
                .padding(14)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

            VStack(alignment: .leading, spacing: 6) {
                Text("Your visual language, decoded.")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.primary)
                Text("Review the characteristics VisualKit found. Edit anything that does not feel right.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var summary: some View {
        HStack(spacing: 12) {
            SummaryMetric(value: "\(dna.attributeCount)", label: "attributes", symbol: "circle.hexagongrid")
            SummaryMetric(value: "\(dna.colorPalette.count)", label: "color cues", symbol: "paintpalette")
            SummaryMetric(value: "AI", label: "analysis", symbol: "sparkles")
        }
    }

    private var attributes: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text("Visual characteristics")
                    .font(.title3.weight(.bold))
                Spacer()
                Text("EDITABLE")
                    .font(.caption.weight(.bold))
                    .tracking(0.8)
                    .foregroundStyle(.secondary)
            }

            LazyVStack(spacing: 12) {
                ForEach(VisualDNACategory.allCases) { category in
                    AttributeGroup(
                        category: category,
                        values: dna.values(for: category),
                        onAdd: {
                            attributeText = ""
                            addingCategory = category
                        },
                        onEdit: { value in
                            attributeText = value.value
                            editingAttribute = EditingAttribute(category: category, value: value)
                        },
                        onRemove: { value in
                            dna.remove(value, from: category)
                        }
                    )
                }
            }
        }
    }

    private var preservationSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text("Preserve")
                        .font(.title3.weight(.bold))
                    Spacer()
                    Text("\(preservation.preservedCount) of \(VisualDNACategory.allCases.count)")
                        .font(.caption.weight(.semibold).monospacedDigit())
                        .foregroundStyle(.secondary)
                }

                Text("Choose which visual characteristics should carry forward. The rest can change with your new prompt.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            FlowLayout(spacing: 8) {
                ForEach(VisualDNACategory.preservationOrder) { category in
                    PreservationChip(
                        category: category,
                        isSelected: preservation.isPreserved(category)
                    ) {
                        preservation.setPreserved(
                            !preservation.isPreserved(category),
                            for: category
                        )
                    }
                }
            }

            PreservationPreview(preservation: preservation)
        }
        .padding(16)
        .visualkitSurface(cornerRadius: 18)
    }

    private var aiPromptSection: some View {
        DisclosureGroup(isExpanded: $isShowingPrompt) {
            Text(dna.aiPrompt)
                .font(.caption)
                .foregroundStyle(.secondary)
                .textSelection(.enabled)
                .padding(.top, 8)
        } label: {
            Label("View AI Prompt", systemImage: "text.quote")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
        }
        .padding(16)
        .visualkitSurface()
    }

    private var continueButton: some View {
        Button {
            onContinue()
            dismiss()
        } label: {
            HStack {
                Image(systemName: "wand.and.stars")
                Text("Continue to generation")
                Spacer()
                Image(systemName: "arrow.up.right")
            }
            .font(.headline.weight(.bold))
            .foregroundStyle(.white)
            .padding(.horizontal, 18)
            .frame(height: 58)
            .background(VisualKitTheme.deepInk)
            .clipShape(RoundedRectangle(cornerRadius: VisualKitTheme.cardRadius, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityHint("Returns to Create with this Visual DNA selected")
    }

    private var suggestedStyleName: String {
        let values = dna.style.map(\.value)
        return values.isEmpty ? "New Style" : values.prefix(2).joined(separator: " ")
    }

    private var analysisOverlay: some View {
        ZStack {
            Color.black.opacity(0.22)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                ProgressView()
                    .tint(.white)
                Text("Analyzing visual characteristics...")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
            }
            .padding(22)
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        }
        .transition(.opacity)
    }
}

private struct SummaryMetric: View {
    let value: String
    let label: String
    let symbol: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: symbol)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(VisualKitTheme.coral)
            Text(value)
                .font(.title3.weight(.bold))
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(13)
        .visualkitSurface(cornerRadius: 16)
        .accessibilityElement(children: .combine)
    }
}

private struct PreservationChip: View {
    let category: VisualDNACategory
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 7) {
                Image(systemName: isSelected ? "checkmark" : category.symbol)
                    .font(.caption.weight(.bold))
                Text(category.preservationTitle)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 12)
            .frame(minHeight: 36)
            .background(
                isSelected
                    ? VisualKitTheme.deepInk
                    : VisualKitTheme.paper
            )
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .stroke(
                        isSelected
                            ? VisualKitTheme.deepInk
                            : VisualKitTheme.line,
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
        .accessibilityLabel(
            "\(category.preservationTitle), \(isSelected ? "preserved from reference" : "allowed to change")"
        )
        .accessibilityHint("Double tap to \(isSelected ? "allow it to change" : "preserve it")")
    }
}

private struct PreservationPreview: View {
    let preservation: PreservationSettings

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            PreservationStatusRow(
                title: "Preserved from reference",
                detail: "These characteristics guide the next image.",
                symbol: "checkmark.circle.fill",
                tint: VisualKitTheme.mint,
                categories: preservation.preservedCategories
            )

            Divider()

            PreservationStatusRow(
                title: "Allowed to change",
                detail: "These characteristics remain open to your prompt.",
                symbol: "arrow.triangle.2.circlepath",
                tint: VisualKitTheme.muted,
                categories: preservation.allowedToChangeCategories
            )
        }
        .padding(14)
        .background(VisualKitTheme.paper.opacity(0.72))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

private struct PreservationStatusRow: View {
    let title: String
    let detail: String
    let symbol: String
    let tint: Color
    let categories: [VisualDNACategory]

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: symbol)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(tint)

            Text(detail)
                .font(.caption)
                .foregroundStyle(.secondary)

            if categories.isEmpty {
                Text("None selected")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            } else {
                Text(categories.map(\.preservationTitle).joined(separator: "  •  "))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct AttributeGroup: View {
    let category: VisualDNACategory
    let values: [VisualDNAValue]
    let onAdd: () -> Void
    let onEdit: (VisualDNAValue) -> Void
    let onRemove: (VisualDNAValue) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: category.symbol)
                    .foregroundStyle(VisualKitTheme.coral)
                Text(category.title)
                    .font(.subheadline.weight(.bold))
                Spacer()
                Button(action: onAdd) {
                    Image(systemName: "plus")
                        .font(.caption.weight(.bold))
                        .frame(width: 28, height: 28)
                        .background(VisualKitTheme.coral.opacity(0.12), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Add \(category.title) attribute")
            }

            if values.isEmpty {
                Button("Add a characteristic", action: onAdd)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(VisualKitTheme.coral)
            } else {
                FlowLayout(spacing: 8) {
                    ForEach(values) { value in
                        EditableDNAChip(
                            value: value,
                            onEdit: { onEdit(value) },
                            onRemove: { onRemove(value) }
                        )
                    }
                }
            }
        }
        .padding(14)
        .visualkitSurface()
    }
}

private struct EditableDNAChip: View {
    let value: VisualDNAValue
    let onEdit: () -> Void
    let onRemove: () -> Void

    var body: some View {
        HStack(spacing: 7) {
            Button(action: onEdit) {
                Text(value.value)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
            }
            .accessibilityLabel("Edit \(value.value)")
            Button(action: onRemove) {
                Image(systemName: "xmark")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .accessibilityLabel("Remove \(value.value)")
        }
        .padding(.horizontal, 11)
        .frame(minHeight: 34)
        .background(VisualKitTheme.paper)
        .clipShape(Capsule())
        .overlay {
            Capsule()
                .stroke(VisualKitTheme.line, lineWidth: 1)
        }
        .accessibilityElement(children: .contain)
    }
}

private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) -> CGSize {
        let width = proposal.width ?? 320
        var currentX: CGFloat = 0
        var currentY: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX > 0, currentX + size.width > width {
                currentX = 0
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }

        return CGSize(width: width, height: currentY + rowHeight)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout ()
    ) {
        var currentX = bounds.minX
        var currentY = bounds.minY
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if currentX > bounds.minX, currentX + size.width > bounds.maxX {
                currentX = bounds.minX
                currentY += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(
                at: CGPoint(x: currentX, y: currentY),
                proposal: ProposedViewSize(size)
            )
            currentX += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }
}

private struct EditingAttribute {
    let category: VisualDNACategory
    let value: VisualDNAValue
}
