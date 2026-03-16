import SwiftUI

struct HearthRootView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Hearth")
                    .font(.largeTitle.bold())
                Text("Home and restoration surfaces will live here.")
                    .foregroundStyle(.secondary)
            }
            .padding()
            .navigationTitle("Hearth")
        }
    }
}
