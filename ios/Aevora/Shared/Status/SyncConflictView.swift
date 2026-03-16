import SwiftUI

struct SyncConflictView: View {
    let message: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Sync Conflict")
                .font(.headline)
            Text(message)
                .foregroundStyle(.secondary)
            Button("Keep Local for Now") {}
                .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}
