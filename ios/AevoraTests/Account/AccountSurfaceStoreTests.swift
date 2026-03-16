import XCTest
@testable import Aevora

@MainActor
final class AccountSurfaceStoreTests: XCTestCase {
    override func setUp() {
        super.setUp()
        let defaults = UserDefaults(suiteName: GlanceSurfacePersistence.suiteName) ?? .standard
        defaults.removeObject(forKey: GlanceSurfacePersistence.payloadKey)
        UserDefaults.standard.removeObject(forKey: "account.notification.permission.v1")
    }

    func testTrialStatePersistsAcrossStoreRebuild() {
        let environment = AppEnvironment(inMemory: true)
        let notificationManager = StubNotificationManager()
        let store = AccountSurfaceStore(
            repository: environment.repository,
            analyticsClient: environment.analyticsClient,
            remoteConfigClient: environment.remoteConfigClient,
            notificationManager: notificationManager,
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
            glanceSurfaceStore: GlanceSurfaceStore(),
            liveActivityCoordinator: LiveActivityCoordinator()
        )

        XCTAssertEqual(rebuilt.subscriptionState.tier, .trial)
        XCTAssertFalse(rebuilt.subscriptionState.trialEligible)
    }

    func testSyncPublishesGlancePayloadAndPremiumGating() {
        let environment = AppEnvironment(inMemory: true)
        let notificationManager = StubNotificationManager(status: .authorized)
        let store = AccountSurfaceStore(
            repository: environment.repository,
            analyticsClient: environment.analyticsClient,
            remoteConfigClient: environment.remoteConfigClient,
            notificationManager: notificationManager,
            glanceSurfaceStore: GlanceSurfaceStore(),
            liveActivityCoordinator: LiveActivityCoordinator()
        )

        let coreLoop = environment.firstPlayableStore
        coreLoop.beginGuestMode()
        coreLoop.generateStarterRecommendations()
        coreLoop.finishOnboarding()
        store.purchase(tier: .premiumAnnual, using: coreLoop)
        store.syncFromCoreLoop(coreLoop)

        let payload = GlanceSurfacePersistence.load()
        XCTAssertEqual(payload.subscription.tier, .premiumAnnual)
        XCTAssertTrue(payload.liveActivity.isEnabled)
        XCTAssertEqual(payload.today.activeVowCount, coreLoop.activeVows.count)
    }

    func testDeleteAccountResetsCoreLoopAndSubscriptionState() {
        let environment = AppEnvironment(inMemory: true)
        let notificationManager = StubNotificationManager()
        let store = AccountSurfaceStore(
            repository: environment.repository,
            analyticsClient: environment.analyticsClient,
            remoteConfigClient: environment.remoteConfigClient,
            notificationManager: notificationManager,
            glanceSurfaceStore: GlanceSurfaceStore(),
            liveActivityCoordinator: LiveActivityCoordinator()
        )

        let coreLoop = environment.firstPlayableStore
        coreLoop.beginGuestMode()
        coreLoop.generateStarterRecommendations()
        coreLoop.finishOnboarding()
        store.startTrial(using: coreLoop)

        store.deleteAccount(using: coreLoop)

        XCTAssertEqual(coreLoop.authMode, "guest")
        XCTAssertFalse(coreLoop.hasCompletedOnboarding)
        XCTAssertEqual(store.subscriptionState.tier, .free)
    }
}
