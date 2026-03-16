import Foundation
import UserNotifications

@MainActor
protocol NotificationManaging {
    func authorizationStatus() async -> NotificationPermissionSnapshot
    func requestAuthorization() async -> NotificationPermissionSnapshot
    func scheduleNotifications(using plan: NotificationPlan) async
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

    func scheduleNotifications(using plan: NotificationPlan) async {
        guard await authorizationStatus() == .authorized else {
            return
        }

        center.removePendingNotificationRequests(withIdentifiers: plan.items.map(\.id))

        for item in plan.items {
            var components = DateComponents()
            components.hour = item.deliveryHourLocal
            components.minute = item.deliveryMinuteLocal

            let content = UNMutableNotificationContent()
            content.title = item.title
            content.body = item.body
            content.userInfo = [
                "source": GlanceSurfaceDeepLinkSource.notification.rawValue,
                "destination": item.destination.rawValue,
                "vowId": item.vowID ?? ""
            ]

            let request = UNNotificationRequest(
                identifier: item.id,
                content: content,
                trigger: UNCalendarNotificationTrigger(dateMatching: components, repeats: true)
            )
            try? await center.add(request)
        }
    }
}

@MainActor
final class StubNotificationManager: NotificationManaging {
    var status: NotificationPermissionSnapshot
    private(set) var scheduledPlans: [NotificationPlan] = []

    init(status: NotificationPermissionSnapshot = .notDetermined) {
        self.status = status
    }

    func authorizationStatus() async -> NotificationPermissionSnapshot {
        status
    }

    func requestAuthorization() async -> NotificationPermissionSnapshot {
        status
    }

    func scheduleNotifications(using plan: NotificationPlan) async {
        scheduledPlans.append(plan)
    }
}
