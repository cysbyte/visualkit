import SwiftUI

struct TemplateSelector: View {
    let templates: [Template]
    @Binding var selection: Template

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 12) {
                    ForEach(templates) { template in
                        TemplateCard(
                            template: template,
                            isSelected: selection.id == template.id
                        ) {
                            selection = template
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .contentMargins(.trailing, VisualKitTheme.horizontalPadding, for: .scrollContent)

            TemplateSelectionSummary(template: selection)
        }
    }
}

struct TemplateCard: View {
    let template: Template
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                ZStack(alignment: .topTrailing) {
                    LinearGradient(
                        colors: [
                            VisualKitTheme.color(for: template.accent),
                            VisualKitTheme.deepInk
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )

                    Image(systemName: template.thumbnail)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.92))

                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3.weight(.bold))
                            .foregroundStyle(.white)
                            .padding(10)
                    }
                }
                .frame(height: 92)

                VStack(alignment: .leading, spacing: 5) {
                    Text(template.name)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.82)

                    Text(template.category.title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)

                    if !template.styleSummary.isEmpty {
                        Text(template.styleSummary)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                }
                .padding(12)
            }
            .frame(width: 180, alignment: .leading)
            .background(VisualKitTheme.surface)
            .clipShape(RoundedRectangle(cornerRadius: VisualKitTheme.cardRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: VisualKitTheme.cardRadius, style: .continuous)
                    .stroke(
                        isSelected ? VisualKitTheme.coral : VisualKitTheme.line,
                        lineWidth: isSelected ? 2 : 1
                    )
            }
            .shadow(
                color: isSelected ? VisualKitTheme.coral.opacity(0.14) : .clear,
                radius: 10,
                y: 4
            )
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityLabel("\(template.name) template")
        .accessibilityHint(
            isSelected
                ? "Selected. \(template.description)"
                : "Select this template. \(template.description)"
        )
    }
}

private struct TemplateSelectionSummary: View {
    let template: Template

    var body: some View {
        ViewThatFits(in: .horizontal) {
            horizontalSummary
            verticalSummary
        }
        .padding(14)
        .visualkitSurface(cornerRadius: 16)
        .accessibilityElement(children: .combine)
    }

    private var horizontalSummary: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "wand.and.stars")
                .font(.headline.weight(.semibold))
                .foregroundStyle(VisualKitTheme.coral)
                .frame(width: 32, height: 32)
                .background(VisualKitTheme.coral.opacity(0.12), in: Circle())

            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(template.name)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.primary)

                    Text("•")
                        .foregroundStyle(.secondary)

                    Text("Recommended \(template.recommendedAspectRatio.rawValue)")
                        .font(.caption.weight(.semibold).monospacedDigit())
                        .foregroundStyle(.secondary)
                }

                Text(template.description)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Text(template.styleSummary.isEmpty ? "Template direction is included in the full prompt." : template.styleSummary)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(VisualKitTheme.coral)
            }
        }
    }

    private var verticalSummary: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: "wand.and.stars")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(VisualKitTheme.coral)
                    .frame(width: 32, height: 32)
                    .background(VisualKitTheme.coral.opacity(0.12), in: Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text(template.name)
                        .font(.subheadline.weight(.bold))
                    Text("Recommended \(template.recommendedAspectRatio.rawValue)")
                        .font(.caption.weight(.semibold).monospacedDigit())
                        .foregroundStyle(.secondary)
                }
            }

            Text(template.description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            Text(template.styleSummary.isEmpty ? "Template direction is included in the full prompt." : template.styleSummary)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(VisualKitTheme.coral)
        }
    }
}
