import SwiftUI

struct OfflineBannerView: View {
    @ObservedObject var store: SyncStatusStore

    var body: some View {
        switch store.bannerState {
        case .hidden:
            EmptyView()
        case .offline:
            banner(text: "Offline. Logs stay local until the connection returns.")
        case .syncing(let count):
            banner(text: "Syncing \(count) queued updates.")
        case .conflict:
            banner(text: "A sync conflict needs review.")
        }
    }

    private func banner(text: String) -> some View {
        Text(text)
            .font(.footnote.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.thinMaterial)
            .clipShape(Capsule())
            .padding(.top, 8)
    }
}
