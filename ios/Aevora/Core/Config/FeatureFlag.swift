import Foundation

enum FeatureFlag: String, CaseIterable, Codable {
    case advancedWidgetsEnabled = "advanced_widgets_enabled"
    case liveActivitiesEnabled = "live_activities_enabled"
    case healthKitVerificationEnabled = "healthkit_verification_enabled"
    case chapterOnePremiumGateEnabled = "chapter_one_premium_gate_enabled"
}
