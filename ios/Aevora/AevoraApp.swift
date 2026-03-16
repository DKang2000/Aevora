import SwiftUI
import SwiftData

@main
struct AevoraApp: App {
    @UIApplicationDelegateAdaptor(AppNotificationDelegate.self) private var notificationDelegate
    @StateObject private var environment = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            RootTabView(environment: environment)
                .environmentObject(environment)
                .onOpenURL { url in
                    environment.handleOpenURL(url)
                }
                .onReceive(NotificationCenter.default.publisher(for: .aevoraOpenNotificationURL)) { notification in
                    if let url = notification.object as? URL {
                        environment.handleOpenURL(url)
                    }
                }
        }
        .modelContainer(environment.persistenceController.container)
    }
}
