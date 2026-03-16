import SwiftUI
import SwiftData

@main
struct AevoraApp: App {
    @StateObject private var environment = AppEnvironment()

    var body: some Scene {
        WindowGroup {
            RootTabView(environment: environment)
                .environmentObject(environment)
        }
        .modelContainer(environment.persistenceController.container)
    }
}
