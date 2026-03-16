import Foundation
import UserNotifications

@MainActor
protocol NotificationManaging {
    func authorizationStatus() async -> NotificationPermissionSnapshot
    func requestAuthorization() async -> NotificationPermissionSnapshot
    func scheduleStarterArcNotifications(using payload: GlanceSurfacePayload) async
}

@MainActor
final class SystemNotificationManager: NotificationManaging {
    private let center: UNUserNotificationCenter

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func authorizationStatus() async -> NotificationPermissionSnapshot {
        let settings = await center.notificationSettings()
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return .authorized
        case .denied:
            return .denied
        case .notDetermined:
            return .notDetermined
        @unknown default:
            return .notDetermined
        }
    }

    func requestAuthorization() async -> NotificationPermissionSnapshot {
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .badge, .sound])
            return granted ? .authorized : .denied
        } catch {
            return .denied
        }
    }

    func scheduleStarterArcNotifications(using payload: GlanceSurfacePayload) async {
        guard await authorizationStatus() == .authorized else {
            return
        }

        center.removePendingNotificationRequests(withIdentifiers: ["starter-reminder", "starter-witness"])

        var reminderComponents = DateComponents()
        reminderComponents.hour = payload.today.reminderHour
        reminderComponents.minute = payload.today.reminderMinute

        let reminderContent = UNMutableNotificationContent()
        reminderContent.title = "Today's vow reminder"
        reminderContent.body = "Open Aevora and keep your cadence moving."
        reminderContent.userInfo = ["source": GlanceSurfaceDeepLinkSource.notification.rawValue]

        let reminderRequest = UNNotificationRequest(
            identifier: "starter-reminder",
            content: reminderContent,
            trigger: UNCalendarNotificationTrigger(dateMatching: reminderComponents, repeats: true)
        )

        var witnessComponents = DateComponents()
        witnessComponents.hour = 20
        witnessComponents.minute = 0

        let witnessContent = UNMutableNotificationContent()
        witnessContent.title = "The district is waiting"
        witnessContent.body = payload.today.witnessPrompt
        witnessContent.userInfo = ["source": GlanceSurfaceDeepLinkSource.notification.rawValue]

        let witnessRequest = UNNotificationRequest(
            identifier: "starter-witness",
            content: witnessContent,
            trigger: UNCalendarNotificationTrigger(dateMatching: witnessComponents, repeats: true)
        )

        try? await center.add(reminderRequest)
        try? await center.add(witnessRequest)
    }
}

@MainActor
final class StubNotificationManager: NotificationManaging {
    var status: NotificationPermissionSnapshot
    private(set) var scheduledPayloads: [GlanceSurfacePayload] = []

    init(status: NotificationPermissionSnapshot = .notDetermined) {
        self.status = status
    }

    func authorizationStatus() async -> NotificationPermissionSnapshot {
        status
    }

    func requestAuthorization() async -> NotificationPermissionSnapshot {
        status
    }

    func scheduleStarterArcNotifications(using payload: GlanceSurfacePayload) async {
        scheduledPayloads.append(payload)
    }
}
