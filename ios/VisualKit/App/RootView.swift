import SwiftUI

struct RootView: View {
    @EnvironmentObject private var appState: AppState

    var body: some View {
        TabView(selection: $appState.selectedTab) {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Label("Home", systemImage: "house")
            }
            .tag(AppTab.home)

            NavigationStack {
                CreateView()
            }
            .tabItem {
                Label("Create", systemImage: "wand.and.stars")
            }
            .tag(AppTab.create)

            NavigationStack {
                CreationsView()
            }
            .tabItem {
                Label("Gallery", systemImage: "photo.on.rectangle.angled")
            }
            .tag(AppTab.creations)

            NavigationStack {
                StylesView()
            }
            .tabItem {
                Label("Saved Styles", systemImage: "bookmark")
            }
            .tag(AppTab.styles)

            NavigationStack {
                SettingsView()
            }
            .tabItem {
                Label("Settings", systemImage: "gearshape")
            }
            .tag(AppTab.settings)
        }
        .tint(VisualKitTheme.coral)
    }
}
