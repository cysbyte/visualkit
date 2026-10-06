import SwiftUI

struct PreservationControls: View {
    @Binding var preservation: PreservationSettings
    let visualDNA: VisualDNA?

    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Choose which visual characteristics should carry forward. The rest can change with your prompt.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(VisualDNACategory.preservationOrder) { category in
                    PreservationControlChip(
                        category: category,
                        isSelected: preservation.isPreserved(category),
                        isEnabled: visualDNA != nil
                    ) {
                        preservation.setPreserved(
                            !preservation.isPreserved(category),
                            for: category
                        )
                    }
                }
            }

            if visualDNA == nil {
                Label(
                    "Analyze a reference and choose From Reference to activate these controls.",
                    systemImage: "info.circle"
                )
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            }

            PreservationConfigurationPreview(
                preservation: preservation,
                isEnabled: visualDNA != nil
            )
        }
        .padding(16)
        .background(VisualKitTheme.surface)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(VisualKitTheme.line, lineWidth: 1)
        }
    }
}

private struct PreservationControlChip: View {
    let category: VisualDNACategory
    let isSelected: Bool
    let isEnabled: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: isSelected ? "checkmark" : category.symbol)
                    .font(.caption.weight(.bold))
                    .frame(width: 16)

                Text(category.preservationTitle)
                    .font(.caption.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)

                Spacer(minLength: 0)
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 11)
            .frame(minHeight: 42)
            .background(
                isSelected
                    ? VisualKitTheme.deepInk
                    : VisualKitTheme.paper
            )
            .clipShape(RoundedRectangle(cornerRadius: 13, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 13, style: .continuous)
                    .stroke(
                        isSelected
                            ? VisualKitTheme.deepInk
                            : VisualKitTheme.line,
                        lineWidth: 1
                    )
            }
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1 : 0.48)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityLabel(
            "\(category.preservationTitle), \(isSelected ? "preserved from reference" : "allowed to change")"
        )
        .accessibilityHint(
            isEnabled
                ? "Double tap to \(isSelected ? "allow it to change" : "preserve it")"
                : "Analyze and select a reference look to enable preservation"
        )
    }
}

private struct PreservationConfigurationPreview: View {
    let preservation: PreservationSettings
    let isEnabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            PreservationConfigurationRow(
                title: "Preserved from reference",
                detail: isEnabled
                    ? "These characteristics guide the next image."
                    : "Select a saved look or reference Visual DNA to use these settings.",
                symbol: "checkmark.circle.fill",
                tint: VisualKitTheme.mint,
                categories: preservation.preservedCategories
            )

            Divider()

            PreservationConfigurationRow(
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

private struct PreservationConfigurationRow: View {
    let title: String
    let detail: String
    let symbol: String
    let tint: Color
    let categories: [VisualDNACategory]

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
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
