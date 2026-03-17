import XCTest
@testable import Aevora

@MainActor
final class AccountSurfaceStoreTests: XCTestCase {
    override func setUp() {
        super.setUp()
        let defaults = UserDefaults(suiteName: GlanceSurfacePersistence.suiteName) ?? .standard
        defaults.removeObject(forKey: GlanceSurfacePersistence.payloadKey)
        UserDefaults.standard.removeObject(forKey: "account.notification.permission.v1")
        UserDefaults.standard.removeObject(forKey: "account.healthkit.permission.v1")
        UserDefaults.standard.removeObject(forKey: "account.healthkit.last-sync.v1")
    }

    func testTrialStatePersistsAcrossStoreRebuild() {
        let environment = AppEnvironment(inMemory: true)
        let notificationManager = StubNotificationManager()
        let store = AccountSurfaceStore(
            repository: environment.repository,
            analyticsClient: environment.analyticsClient,
            remoteConfigClient: environment.remoteConfigClient,
            notificationManager: notificationManager,
            healthKitManager: StubHealthKitManager(),
            glanceSurfaceStore: GlanceSurfaceStore(),
            liveActivityCoordinator: LiveActivityCoordinator()
        )

        let coreLoop = environment.firstPlayableStore
        store.startTrial(using: coreLoop)

        let rebuilt = AccountSurfaceStore(
            repository: environment.repository,
            analyticsClient: environment.analyticsClient,
            remoteConfigClient: environment.remoteConfigClient,
            notificationManager: notificationManager,
            healthKitManager: StubHealthKitManager(),
            glanceSurfaceStore: GlanceSurfaceStore(),
            liveActivityCoordinator: LiveActivityCoordinator()
        )

        XCTAssertEqual(rebuilt.subscriptionState.tier, .trial)
        XCTAssertFalse(rebuilt.subscriptionState.trialEligible)
    }

    func testSyncPublishesGlancePayloadAndPremiumGating() async {
        let environment = AppEnvironment(inMemory: true)
        let notificationManager = StubNotificationManager(status: .authorized)
        let store = AccountSurfaceStore(
            repository: environment.repository,
            analyticsClient: environment.analyticsClient,
            remoteConfigClient: environment.remoteConfigClient,
            notificationManager: notificationManager,
            healthKitManager: StubHealthKitManager(),
            glanceSurfaceStore: GlanceSurfaceStore(),
            liveActivityCoordinator: LiveActivityCoordinator()
        )

        let coreLoop = environment.firstPlayableStore
        environment.accountSurfaceStore = store
        environment.firstPlayableStore.onStateChanged = { updatedStore in
            store.syncFromCoreLoop(updatedStore)
        }
        coreLoop.beginGuestMode()
        coreLoop.generateStarterRecommendations()
        coreLoop.finishOnboarding()
        store.purchase(tier: .premiumAnnual, using: coreLoop)
        store.syncFromCoreLoop(coreLoop)

        await waitForCondition {
            notificationManager.scheduledPlans.isEmpty == false
        }

        let payload = GlanceSurfacePersistence.load()
        XCTAssertEqual(payload.subscription.tier, .premiumAnnual)
        XCTAssertTrue(payload.liveActivity.isEnabled)
        XCTAssertEqual(payload.today.activeVowCount, coreLoop.activeVows.count)
        XCTAssertFalse(notificationManager.scheduledPlans.isEmpty)
    }

    func testDeleteAccountResetsCoreLoopAndSubscriptionState() {
        let environment = AppEnvironment(inMemory: true)
        let notificationManager = StubNotificationManager()
        let store = AccountSurfaceStore(
            repository: environment.repository,
            analyticsClient: environment.analyticsClient,
            remoteConfigClient: environment.remoteConfigClient,
            notificationManager: notificationManager,
            healthKitManager: StubHealthKitManager(),
            glanceSurfaceStore: GlanceSurfaceStore(),
            liveActivityCoordinator: LiveActivityCoordinator()
        )

        let coreLoop = environment.firstPlayableStore
        coreLoop.beginGuestMode()
        coreLoop.generateStarterRecommendations()
        coreLoop.finishOnboarding()
        store.startTrial(using: coreLoop)
        store.prepareExport(using: coreLoop)
        store.beginDeleteAccountFlow()

        store.deleteAccount(using: coreLoop)

        XCTAssertEqual(coreLoop.authMode, "guest")
        XCTAssertFalse(coreLoop.hasCompletedOnboarding)
        XCTAssertEqual(store.subscriptionState.tier, .free)
        XCTAssertFalse(store.isDeleteConfirmationPresented)
        XCTAssertNil(store.exportPreparedAt)
    }

    func testBeginDeleteFlowWarnsWhenNoExportPreviewExists() {
        let environment = AppEnvironment(inMemory: true)
        let store = AccountSurfaceStore(
            repository: environment.repository,
            analyticsClient: environment.analyticsClient,
            remoteConfigClient: environment.remoteConfigClient,
            notificationManager: StubNotificationManager(),
            healthKitManager: StubHealthKitManager(),
            glanceSurfaceStore: GlanceSurfaceStore(),
            liveActivityCoordinator: LiveActivityCoordinator()
        )

        store.beginDeleteAccountFlow()

        XCTAssertTrue(store.isDeleteConfirmationPresented)
        XCTAssertEqual(store.accountNotice, "Prepare an export preview before deleting so your current local state is visible.")
    }

    func testHealthKitConnectionImportsVerifiedCompletionWithoutRemovingManualPath() async {
        let environment = AppEnvironment(inMemory: true)
        let healthKitManager = StubHealthKitManager(
            status: .authorized,
            samples: [
                VerifiedHealthSample(
                    sourceEventID: "hk_evt_001",
                    domain: .workout,
                    localDate: DateFormatter.aevoraTestLocalDate.string(from: .now),
                    quantity: nil,
                    durationMinutes: 30
                )
            ]
        )
        let store = AccountSurfaceStore(
            repository: environment.repository,
            analyticsClient: environment.analyticsClient,
            remoteConfigClient: environment.remoteConfigClient,
            notificationManager: StubNotificationManager(),
            healthKitManager: healthKitManager,
            glanceSurfaceStore: GlanceSurfaceStore(),
            liveActivityCoordinator: LiveActivityCoordinator()
        )

        let coreLoop = environment.firstPlayableStore
        coreLoop.beginGuestMode()
        coreLoop.selectedLifeAreas = ["Physical"]
        coreLoop.generateStarterRecommendations()
        coreLoop.finishOnboarding()
        store.purchase(tier: .premiumMonthly, using: coreLoop)

        store.connectHealthKit(using: coreLoop)

        await waitForCondition {
            store.healthKitPermission == .authorized && coreLoop.matchingVerifiedVowID(for: .workout) != nil
        }

        XCTAssertEqual(store.healthKitPermission, .authorized)
        XCTAssertNotNil(coreLoop.matchingVerifiedVowID(for: .workout))
    }
}
