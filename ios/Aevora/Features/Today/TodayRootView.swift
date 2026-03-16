import SwiftUI

struct TodayRootView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Today")
                    .font(.largeTitle.bold())
                Text("Fast vow logging stays primary in the shell.")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Today")
        }
    }
}
