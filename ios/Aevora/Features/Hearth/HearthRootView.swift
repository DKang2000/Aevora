import SwiftUI

struct HearthRootView: View {
    @EnvironmentObject private var environment: AppEnvironment

    var body: some View {
        NavigationStack {
            let store = environment.firstPlayableStore
            let storedItems = store.inventoryItems.filter { $0.status != "applied" }
            let appliedItems = store.inventoryItems.filter { $0.status == "applied" }

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(store.hearthState.title)
                        .font(.system(size: 34, weight: .bold, design: .rounded))

                    VStack(alignment: .leading, spacing: 10) {
                        Text(store.hearthState.summary)
                            .foregroundStyle(.secondary)
                        Text("Gold on hand: \(store.goldBalance)")
                            .font(.headline)
                        if store.hearthState.chapterClosureReady {
                            Text("The starter arc is complete. Chapter One keepsakes can now stay visible here.")
                                .font(.headline)
                        }
                    }
                    .padding(18)
                    .background(Color(red: 0.98, green: 0.96, blue: 0.92))
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                    VStack(alignment: .leading, spacing: 12) {
                        Text(store.copy.text("inventory.stored_title", fallback: "In your pack"))
                            .font(.headline)
                        if storedItems.isEmpty {
                            Text(store.copy.text("states.hearth.inventory_empty.title", fallback: "Your Hearth is still waiting for its first keepsake."))
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(storedItems) { item in
                                itemCard(item: item, buttonTitle: store.copy.text("inventory.apply_cta", fallback: "Place in Hearth")) {
                                    store.toggleItemApplied(item.id)
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text(store.copy.text("inventory.applied_title", fallback: "Already visible"))
                            .font(.headline)
                        if appliedItems.isEmpty {
                            Text("Place a prop or keepsake here to make your progress visible at home.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(appliedItems) { item in
                                itemCard(item: item, buttonTitle: store.copy.text("inventory.remove_cta", fallback: "Return to pack")) {
                                    store.toggleItemApplied(item.id)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Hearth")
        }
    }

    private func itemCard(item: InventoryItemState, buttonTitle: String, action: @escaping () -> Void) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(item.name)
                .font(.headline)
            Text(item.summary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text("\(item.bucket.capitalized) • \(item.rarity.capitalized)")
                .font(.footnote)
                .foregroundStyle(.secondary)
            Button(buttonTitle, action: action)
                .buttonStyle(.bordered)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.white.opacity(0.85))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
