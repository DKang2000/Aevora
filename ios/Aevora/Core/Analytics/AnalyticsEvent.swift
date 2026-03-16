import Foundation

enum AnalyticsEventName: String, CaseIterable, Codable {
    case appOpened = "app_opened"
    case sessionStarted = "session_started"
    case onboardingStarted = "onboarding_started"
    case onboardingStepCompleted = "onboarding_step_completed"
    case originFamilySelected = "origin_family_selected"
    case identitySelected = "identity_selected"
    case avatarCreated = "avatar_created"
    case starterVowRecommended = "starter_vow_recommended"
    case starterVowAccepted = "starter_vow_accepted"
    case starterVowEdited = "starter_vow_edited"
    case onboardingCompleted = "onboarding_completed"
    case firstMagicalMomentViewed = "first_magical_moment_viewed"
    case vowCompleted = "vow_completed"
    case dayCompletedFirstVow = "day_completed_first_vow"
    case resonanceAwarded = "resonance_awarded"
    case goldAwarded = "gold_awarded"
    case districtProgressed = "district_progressed"
    case worldSceneOpened = "world_scene_opened"
    case widgetViewed = "widget_viewed"
    case widgetTapped = "widget_tapped"
    case liveActivityStarted = "live_activity_started"
    case liveActivityTapped = "live_activity_tapped"
    case notificationPromptViewed = "notification_prompt_viewed"
    case notificationPermissionResult = "notification_permission_result"
    case notificationOpened = "notification_opened"
    case paywallViewed = "paywall_viewed"
    case trialStarted = "trial_started"
    case purchaseStarted = "purchase_started"
    case purchaseCompleted = "purchase_completed"
    case purchaseFailed = "purchase_failed"
    case subscriptionRestored = "subscription_restored"
    case subscriptionCanceled = "subscription_canceled"
    case subscriptionExpired = "subscription_expired"
}

struct AnalyticsEvent: Equatable {
    let name: AnalyticsEventName
    let surface: String
    let properties: [String: String]
}
