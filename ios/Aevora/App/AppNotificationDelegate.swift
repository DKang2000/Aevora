import Foundation
import UIKit
import UserNotifications

extension Notification.Name {
    static let aevoraOpenNotificationURL = Notification.Name("aevora.open.notification.url")
}

final class AppNotificationDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }

    nonisolated func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse
    ) async {
        let userInfo = response.notification.request.content.userInfo
        let sourceRaw = userInfo["source"] as? String ?? GlanceSurfaceDeepLinkSource.notification.rawValue
        let destinationRaw = userInfo["destination"] as? String ?? AppDeepLinkDestination.today.rawValue
        let vowID = (userInfo["vowId"] as? String).flatMap { $0.isEmpty ? nil : $0 }
        let source = GlanceSurfaceDeepLinkSource(rawValue: sourceRaw) ?? .notification
        let destination = AppDeepLinkDestination(rawValue: destinationRaw) ?? .today
        let url = AppDeepLink.url(source: source, destination: destination, vowID: vowID)
        NotificationCenter.default.post(name: .aevoraOpenNotificationURL, object: url)
    }
}
