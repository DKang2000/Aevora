import SwiftUI

struct HearthRootView: View {
    @EnvironmentObject private var environment: AppEnvironment

    var body: some View {
        NavigationStack {
            let store = environment.firstPlayableStore

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(store.hearthState.title)
                        .font(.system(size: 34, weight: .bold, design: .rounded))

                    VStack(alignment: .leading, spacing: 10) {
                        Text(store.hearthState.summary)
                            .foregroundStyle(.secondary)
                        if store.hearthState.chapterClosureReady {
                            Text("The Ember That Returned is complete. Your earned keepsakes now live here.")
                                .font(.headline)
                        }
                    }
                    .padding(18)
                    .background(Color(red: 0.98, green: 0.96, blue: 0.92))
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Inventory")
                            .font(.headline)
                        if store.inventoryItems.isEmpty {
                            Text("Rewards and props you earn during the starter arc will gather here.")
                                .foregroundStyle(.secondary)
                        } else {
                            ForEach(store.inventoryItems) { item in
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.name)
                                        .font(.headline)
                                    Text("\(item.bucket.capitalized) • \(item.rarity.capitalized)")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(14)
                                .background(Color.white.opacity(0.85))
                                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                            }
                        }
                    }

                    if !store.hearthState.unlockedPropNames.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Visible at home")
                                .font(.headline)
                            ForEach(store.hearthState.unlockedPropNames, id: \.self) { prop in
                                Text(prop)
                                    .padding(.vertical, 6)
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Hearth")
        }
    }
}
