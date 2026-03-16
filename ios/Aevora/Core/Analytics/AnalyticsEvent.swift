import Foundation

enum AnalyticsEventName: String, CaseIterable, Codable {
    case appOpened = "app_opened"
    case sessionStarted = "session_started"
    case onboardingCompleted = "onboarding_completed"
    case firstMagicalMomentViewed = "first_magical_moment_viewed"
    case vowCompleted = "vow_completed"
    case worldSceneOpened = "world_scene_opened"
    case paywallViewed = "paywall_viewed"
}

struct AnalyticsEvent: Equatable {
    let name: AnalyticsEventName
    let surface: String
    let properties: [String: String]
}
