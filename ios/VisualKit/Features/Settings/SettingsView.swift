import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        List {
            Section("Workspace") {
                SettingsRow(
                    title: "Account",
                    detail: "Managed by VisualKit",
                    symbol: "person.crop.circle"
                )
                SettingsRow(
                    title: "Notifications",
                    detail: "Generation updates",
                    symbol: "bell"
                )
            }

            Section("Creation") {
                SettingsRow(
                    title: "Prompt control",
                    detail: "Templates and styles stay separate",
                    symbol: "text.quote"
                )
                SettingsRow(
                    title: "Private uploads",
                    detail: "Images are uploaded with temporary links",
                    symbol: "lock.shield"
                )
            }

            Section("About") {
                SettingsRow(
                    title: "API connection",
                    detail: appState.isUsingRemoteAPI ? "Connected to VisualKit API" : "Local mock mode",
                    symbol: "bolt.horizontal.circle"
                )
                SettingsRow(
                    title: "Build",
                    detail: "Development",
                    symbol: "hammer"
                )
            }
        }
        .scrollContentBackground(.hidden)
        .background(VisualKitTheme.paper)
        .navigationTitle("Settings")
    }
}

private struct SettingsRow: View {
    let title: String
    let detail: String
    let symbol: String

    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .foregroundStyle(.primary)
                Text(detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        } icon: {
            Image(systemName: symbol)
                .foregroundStyle(VisualKitTheme.coral)
        }
        .accessibilityElement(children: .combine)
    }
}
