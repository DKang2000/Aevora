import SwiftUI

struct ProfileRootView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Profile")
                    .font(.largeTitle.bold())
                Text("Account, settings, and stats will layer onto this root.")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Profile")
        }
    }
}
