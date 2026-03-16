import Foundation
import SwiftUI
import Combine

@MainActor
final class AppEnvironment: ObservableObject {
    @Published var selectedTab: AppTab = .today
    @Published var isDebugMenuPresented = false

    let persistenceController: PersistenceController
    let repository: SwiftDataRepository
    let connectivityMonitor: ConnectivityMonitor
    let syncQueue: SyncQueue
    let syncCoordinator: SyncCoordinator
    let syncStatusStore: SyncStatusStore
    let featureFlagOverrideStore: FeatureFlagOverrideStore
    let remoteConfigClient: RemoteConfigClient
    let analyticsClient: AnalyticsClient
    let logger: StructuredLogger
    let crashReporter: CrashReporter
    let seedScenarioLoader: SeedScenarioLoader
    var firstPlayableStore: FirstPlayableStore
    let glanceSurfaceStore: GlanceSurfaceStore
    let liveActivityCoordinator: LiveActivityCoordinator
    let notificationManager: NotificationManaging
    var accountSurfaceStore: AccountSurfaceStore
    private var childStoreCancellables: Set<AnyCancellable> = []

    init(inMemory: Bool = false) {
        let overrideStore = FeatureFlagOverrideStore()
        persistenceController = PersistenceController(inMemory: inMemory)
        repository = SwiftDataRepository(modelContext: persistenceController.mainContext)
        connectivityMonitor = ConnectivityMonitor()
        syncQueue = SyncQueue()
        logger = StructuredLogger()
        crashReporter = DevelopmentCrashReporter(logger: logger)
        featureFlagOverrideStore = overrideStore
        remoteConfigClient = RemoteConfigClient(
            defaultsLoader: {
                let url = Bundle.main.url(forResource: "remote-config-defaults", withExtension: "json")
                if let url {
                    return try Data(contentsOf: url)
                }

                return Data("""
                {"schemaVersion":"v1","featureFlags":{},"economy":{},"onboarding":{},"paywall":{},"reminders":{},"widgets":{},"liveActivities":{},"chapterGating":{}}
                """.utf8)
            },
            overrideProvider: { flag in
                overrideStore.value(for: flag)
            }
        )
        analyticsClient = AnalyticsClient(
            queue: syncQueue,
            metadataProvider: AnalyticsMetadataProvider(),
            validator: AnalyticsValidator()
        )
        let monitor = connectivityMonitor
        syncCoordinator = SyncCoordinator(
            apiClient: APIClient(baseURL: URL(string: "https://example.invalid")!),
            queue: syncQueue,
            isNetworkAvailable: { await MainActor.run { monitor.isOnline } }
        )
        syncStatusStore = SyncStatusStore(connectivityMonitor: connectivityMonitor, syncQueue: syncQueue)
        seedScenarioLoader = SeedScenarioLoader()
        glanceSurfaceStore = GlanceSurfaceStore()
        liveActivityCoordinator = LiveActivityCoordinator()
        notificationManager = SystemNotificationManager()
        firstPlayableStore = FirstPlayableStore(
            repository: repository,
            syncQueue: syncQueue,
            analyticsClient: analyticsClient,
            syncStatusStore: syncStatusStore
        )
        accountSurfaceStore = AccountSurfaceStore(
            repository: repository,
            analyticsClient: analyticsClient,
            remoteConfigClient: remoteConfigClient,
            notificationManager: notificationManager,
            glanceSurfaceStore: glanceSurfaceStore,
            liveActivityCoordinator: liveActivityCoordinator
        )
        firstPlayableStore.onStateChanged = { [weak self] store in
            self?.accountSurfaceStore.syncFromCoreLoop(store)
        }
        wireChildStores()
        accountSurfaceStore.syncFromCoreLoop(firstPlayableStore)
    }

    func handleOpenURL(_ url: URL) {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let source = components.queryItems?.first(where: { $0.name == "source" })?.value else {
            return
        }

        let eventName: AnalyticsEventName
        switch source {
        case GlanceSurfaceDeepLinkSource.liveActivity.rawValue:
            eventName = .liveActivityTapped
            selectedTab = .world
        case GlanceSurfaceDeepLinkSource.notification.rawValue:
            eventName = .notificationOpened
            selectedTab = .today
        case GlanceSurfaceDeepLinkSource.premiumWidget.rawValue:
            eventName = .widgetTapped
            selectedTab = .profile
        default:
            eventName = .widgetTapped
            selectedTab = .today
        }

        Task {
            try? await analyticsClient.track(AnalyticsEvent(name: eventName, surface: "glance", properties: ["source": source]))
        }
    }

    private func wireChildStores() {
        childStoreCancellables.removeAll()

        firstPlayableStore.objectWillChange
            .sink { [weak self] in self?.objectWillChange.send() }
            .store(in: &childStoreCancellables)

        accountSurfaceStore.objectWillChange
            .sink { [weak self] in self?.objectWillChange.send() }
            .store(in: &childStoreCancellables)
    }
}
