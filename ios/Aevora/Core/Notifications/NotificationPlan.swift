import Foundation

struct NotificationPlanItem: Identifiable, Equatable {
    let id: String
    let kind: Kind
    let title: String
    let body: String
    let deliveryHourLocal: Int
    let deliveryMinuteLocal: Int
    let destination: AppDeepLinkDestination
    let vowID: String?

    enum Kind: String, Equatable {
        case vowReminder = "vow_reminder"
        case witnessPrompt = "witness_prompt"
        case streakRisk = "streak_risk"
        case chapterReady = "chapter_ready"
    }
}

struct NotificationPlan: Equatable {
    let generatedAt: Date
    let items: [NotificationPlanItem]
}
