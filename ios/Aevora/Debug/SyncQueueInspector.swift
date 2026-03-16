import SwiftUI

struct SyncQueueInspector: View {
    let operations: [SyncOperation]

    var body: some View {
        List(operations) { operation in
            VStack(alignment: .leading, spacing: 4) {
                Text(operation.operationType.rawValue)
                    .font(.headline)
                Text(operation.endpointPath)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
