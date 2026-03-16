import SwiftUI

struct DebugMenuRootView: View {
    let seedScenarioLoader: SeedScenarioLoader
    @ObservedObject var featureFlagOverrideStore: FeatureFlagOverrideStore
    let syncQueue: SyncQueue

    @State private var operations: [SyncOperation] = []

    var body: some View {
        NavigationStack {
            List {
                Section("Scenarios") {
                    ForEach(seedScenarioLoader.loadScenarios()) { scenario in
                        VStack(alignment: .leading) {
                            Text(scenario.title)
                            Text(scenario.fixtureReferences.joined(separator: ", "))
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                    }
                }

                Section("Feature Flags") {
                    ForEach(FeatureFlag.allCases, id: \.self) { flag in
                        Toggle(flag.rawValue, isOn: Binding(
                            get: { featureFlagOverrideStore.value(for: flag) ?? false },
                            set: { featureFlagOverrideStore.set($0, for: flag) }
                        ))
                    }
                }

                Section("Sync Queue") {
                    SyncQueueInspector(operations: operations)
                }
            }
            .navigationTitle("Debug")
            .task {
                operations = await syncQueue.pendingOperations()
            }
        }
    }
}
