import SwiftUI

struct RootTabView: View {
    @ObservedObject var environment: AppEnvironment

    var body: some View {
        TabView(selection: $environment.selectedTab) {
            TodayRootView()
                .tabItem { Label(AppTab.today.title, systemImage: AppTab.today.systemImage) }
                .tag(AppTab.today)

            WorldRootView()
                .tabItem { Label(AppTab.world.title, systemImage: AppTab.world.systemImage) }
                .tag(AppTab.world)

            HearthRootView()
                .tabItem { Label(AppTab.hearth.title, systemImage: AppTab.hearth.systemImage) }
                .tag(AppTab.hearth)

            ProfileRootView()
                .tabItem { Label(AppTab.profile.title, systemImage: AppTab.profile.systemImage) }
                .tag(AppTab.profile)
        }
        .overlay(alignment: .top) {
            OfflineBannerView(store: environment.syncStatusStore)
        }
        .sheet(isPresented: $environment.isDebugMenuPresented) {
            DebugMenuRootView(
                seedScenarioLoader: environment.seedScenarioLoader,
                featureFlagOverrideStore: environment.featureFlagOverrideStore,
                syncQueue: environment.syncQueue
            )
        }
        .toolbar {
#if DEBUG
            ToolbarItem(placement: .topBarTrailing) {
                Button("Debug") {
                    environment.isDebugMenuPresented = true
                }
            }
#endif
        }
    }
}
