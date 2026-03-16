import Foundation

#if canImport(ActivityKit)
import ActivityKit
#endif

enum SubscriptionTierSnapshot: String, Codable, Equatable {
    case free
    case trial
    case premiumMonthly = "premium_monthly"
    case premiumAnnual = "premium_annual"
}

enum BillingStateSnapshot: String, Codable, Equatable {
    case active
    case gracePeriod = "grace_period"
    case billingRetry = "billing_retry"
    case expired
}

enum NotificationPermissionSnapshot: String, Codable, Equatable {
    case notDetermined
    case authorized
    case denied
}

struct LocalSubscriptionSnapshot: Codable, Equatable {
    var tier: SubscriptionTierSnapshot
    var billingState: BillingStateSnapshot
    var trialEligible: Bool
    var expiresAt: String?
    var restoreTier: SubscriptionTierSnapshot?

    static let free = LocalSubscriptionSnapshot(
        tier: .free,
        billingState: .active,
        trialEligible: true,
        expiresAt: nil,
        restoreTier: nil
    )

    var hasPremiumBreadth: Bool {
        switch tier {
        case .free:
            return billingState == .gracePeriod || billingState == .billingRetry
        case .trial, .premiumMonthly, .premiumAnnual:
            return billingState != .expired
        }
    }

    var widgetAccess: String {
        hasPremiumBreadth ? "advanced" : "basic"
    }
}

struct TodayGlanceSnapshot: Codable, Equatable {
    var dayTitle: String
    var chapterTitle: String
    var districtStageTitle: String
    var activeVowCount: Int
    var completedVowCount: Int
    var topChainLength: Int
    var reminderHour: Int
    var reminderMinute: Int
    var witnessPrompt: String
}

struct LiveActivityGlanceSnapshot: Codable, Equatable {
    var isEnabled: Bool
    var chapterTitle: String
    var districtStageTitle: String
    var progressPercent: Int
    var activeVowCount: Int
}

struct GlanceSurfacePayload: Codable, Equatable {
    var generatedAt: String
    var today: TodayGlanceSnapshot
    var liveActivity: LiveActivityGlanceSnapshot
    var subscription: LocalSubscriptionSnapshot
    var notificationPermission: NotificationPermissionSnapshot

    static let placeholder = GlanceSurfacePayload(
        generatedAt: "2026-03-16T00:00:00Z",
        today: TodayGlanceSnapshot(
            dayTitle: "Day 1",
            chapterTitle: "The Ember That Returned",
            districtStageTitle: "Dim",
            activeVowCount: 3,
            completedVowCount: 0,
            topChainLength: 0,
            reminderHour: 8,
            reminderMinute: 0,
            witnessPrompt: "Return tomorrow. Ember Quay has started listening."
        ),
        liveActivity: LiveActivityGlanceSnapshot(
            isEnabled: false,
            chapterTitle: "The Ember That Returned",
            districtStageTitle: "Dim",
            progressPercent: 0,
            activeVowCount: 3
        ),
        subscription: .free,
        notificationPermission: .notDetermined
    )
}

enum GlanceSurfaceDeepLinkSource: String, Codable {
    case basicWidget = "basic_widget"
    case premiumWidget = "premium_widget"
    case liveActivity = "live_activity"
    case notification = "notification"
}

enum GlanceSurfacePersistence {
    static let suiteName = "group.com.aevora.shared"
    static let payloadKey = "glance.surface.payload.v1"

    static func defaults() -> UserDefaults {
        UserDefaults(suiteName: suiteName) ?? .standard
    }

    static func load() -> GlanceSurfacePayload {
        let defaults = defaults()
        guard let data = defaults.data(forKey: payloadKey),
              let payload = try? JSONDecoder().decode(GlanceSurfacePayload.self, from: data) else {
            return .placeholder
        }

        return payload
    }

    static func save(_ payload: GlanceSurfacePayload) {
        guard let data = try? JSONEncoder().encode(payload) else {
            return
        }

        let defaults = defaults()
        defaults.set(data, forKey: payloadKey)
    }

    static func deepLinkURL(for source: GlanceSurfaceDeepLinkSource) -> URL {
        URL(string: "aevora://open?source=\(source.rawValue)")!
    }
}

#if canImport(ActivityKit)
struct AevoraStarterArcAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var districtStageTitle: String
        var progressPercent: Int
        var activeVowCount: Int
    }

    var chapterTitle: String
}
#endif
