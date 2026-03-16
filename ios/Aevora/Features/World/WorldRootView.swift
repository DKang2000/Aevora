import SwiftUI

struct WorldRootView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("World")
                    .font(.largeTitle.bold())
                Text("The world remains the emotional reward surface.")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("World")
        }
    }
}
