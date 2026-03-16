import Foundation

@MainActor
final class ConnectivityMonitor: ObservableObject {
    @Published var isOnline = true

    func setOnline(_ isOnline: Bool) {
        self.isOnline = isOnline
    }
}
