import Foundation
import SwiftUI

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
    }
}
