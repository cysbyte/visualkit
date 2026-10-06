import SwiftUI
import UIKit

struct StyleEditorView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var appState: AppState
    @State private var draft: SavedStyle
    let onSave: (SavedStyle) -> Void

    @State private var addingCategory: VisualDNACategory?
    @State private var newAttribute = ""

    init(style: SavedStyle, onSave: @escaping (SavedStyle) -> Void) {
        _draft = State(initialValue: style)
        self.onSave = onSave
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    preview
                    nameField
                    attributes
                }
                .padding(20)
                .padding(.bottom, 30)
            }
            .scrollIndicators(.hidden)
            .background(VisualKitTheme.paper.ignoresSafeArea())
            .navigationTitle("Edit Style")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        let trimmedName = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
                        guard !trimmedName.isEmpty else { return }
                        draft.name = trimmedName
                        onSave(draft)
                        dismiss()
                    }
                    .fontWeight(.semibold)
                    .disabled(draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
            .alert(
                "Add Attribute",
                isPresented: Binding(
                    get: { addingCategory != nil },
                    set: { if !$0 { addingCategory = nil } }
                )
            ) {
                TextField("Attribute", text: $newAttribute)
                Button("Cancel", role: .cancel) {}
                Button("Add") {
                    guard let addingCategory else { return }
                    draft.dna.add(newAttribute, to: addingCategory)
                    newAttribute = ""
                    self.addingCategory = nil
                }
            } message: {
                Text("Add a characteristic to \(addingCategory?.title ?? "this category").")
            }
        }
    }

    private var preview: some View {
        Group {
            if let data = draft.previewImage, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
            } else if let previewImageURL = draft.previewImageURL {
                RemoteImageView(
                    url: previewImageURL,
                    refreshURL: previewRefreshURL
                )
            } else {
                PalettePreview(colors: draft.dna.palette)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 170)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
    }

    private var previewRefreshURL: (() async throws -> URL)? {
        guard let assetID = draft.previewAssetID else { return nil }
        return { try await appState.backend.downloadURL(for: assetID).downloadURL }
    }

    private var nameField: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Style name")
                .font(.title3.weight(.bold))
            TextField("Name your style", text: $draft.name)
                .textInputAutocapitalization(.words)
                .submitLabel(.done)
                .padding(14)
                .background(VisualKitTheme.surface)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .visualkitHairline(cornerRadius: 14)
        }
    }

    private var attributes: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Visual DNA")
                    .font(.title3.weight(.bold))
                Spacer()
                Text("\(draft.dna.attributeCount) traits")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }

            ForEach(VisualDNACategory.preservationOrder) { category in
                attributeGroup(category)
            }
        }
    }

    private func attributeGroup(_ category: VisualDNACategory) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: category.symbol)
                    .foregroundStyle(VisualKitTheme.coral)
                Text(category.title)
                    .font(.subheadline.weight(.bold))
                Spacer()
                Button {
                    newAttribute = ""
                    addingCategory = category
                } label: {
                    Image(systemName: "plus")
                        .font(.caption.weight(.bold))
                        .frame(width: 28, height: 28)
                        .background(VisualKitTheme.coral.opacity(0.12), in: Circle())
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Add \(category.title) attribute")
            }

            if draft.dna.values(for: category).isEmpty {
                Text("No characteristics")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(draft.dna.values(for: category)) { value in
                    HStack(spacing: 8) {
                        TextField(
                            "Characteristic",
                            text: Binding(
                                get: {
                                    draft.dna.values(for: category)
                                        .first(where: { $0.id == value.id })?.value ?? ""
                                },
                                set: {
                                    draft.dna.edit(value, as: $0, in: category)
                                }
                            )
                        )
                        .padding(10)
                        .background(VisualKitTheme.paper)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .visualkitHairline(cornerRadius: 12)

                        Button {
                            draft.dna.remove(value, from: category)
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(.secondary)
                        }
                        .buttonStyle(.plain)
                        .accessibilityLabel("Remove \(value.value)")
                    }
                }
            }
        }
        .padding(14)
        .visualkitSurface()
    }
}
