import SwiftUI

struct WorldRootView: View {
    @EnvironmentObject private var environment: AppEnvironment
    @State private var selectedNPC: SelectedNPC?
    @State private var isShopPresented = false

    var body: some View {
        NavigationStack {
            let store = environment.firstPlayableStore

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(store.copy.text("world.headline", fallback: "World"))
                        .font(.system(size: 34, weight: .bold, design: .rounded))

                    WorldSceneContainer(state: store.districtState, anchorID: store.currentWorldAnchorID)

                    districtCard(store: store)
                    promenadeCard(store: store)
                    npcSection(store: store)
                    shopCard(store: store)
                }
                .padding()
            }
            .navigationTitle("World")
            .sheet(item: $selectedNPC) { selectedNPC in
                NPCDialogueSheet(store: store, npcID: selectedNPC.id)
            }
            .sheet(isPresented: $isShopPresented) {
                ShopSheet(store: store)
            }
        }
    }

    private func districtCard(store: FirstPlayableStore) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(store.districtState.stageTitle)
                .font(.title3.bold())
            Text("Day \(store.chapterState.currentDay) of \(store.chapterState.chapterLength) in \(store.chapterState.title)")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
            Text(store.districtState.moodText)
                .foregroundStyle(.secondary)
            Text(store.districtState.worldChangeText)
            ProgressView(value: store.districtState.problemProgressPercent)
                .tint(Color(red: 0.89, green: 0.55, blue: 0.25))
            Text(store.districtState.problemTitle)
                .font(.headline)
            Text(store.districtState.problemSummary)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            if store.chapterState.statusNote.isEmpty == false {
                Text(store.chapterState.statusNote)
                    .font(.footnote)
                    .foregroundStyle(Color(red: 0.45, green: 0.24, blue: 0.13))
            }
        }
        .padding(18)
        .background(Color(red: 0.98, green: 0.96, blue: 0.92))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func promenadeCard(store: FirstPlayableStore) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Walk the quay")
                .font(.headline)
            Text("Move your avatar between small witness points. Listening stays optional, but the district feels more inhabited when you do.")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            HStack(spacing: 10) {
                ForEach(store.worldAnchors) { anchor in
                    Button {
                        store.moveAvatar(to: anchor.id)
                    } label: {
                        VStack(spacing: 6) {
                            Text(anchor.title)
                                .font(.footnote.weight(.semibold))
                            Text("\(anchor.npcIDs.count) witness\(anchor.npcIDs.count == 1 ? "" : "es")")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(store.currentWorldAnchorID == anchor.id ? Color(red: 0.93, green: 0.82, blue: 0.67) : Color.white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(18)
        .background(Color(red: 0.95, green: 0.93, blue: 0.89))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }

    private func npcSection(store: FirstPlayableStore) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Witnesses nearby")
                .font(.headline)

            let anchorNPCs = store.worldAnchors.first(where: { $0.id == store.currentWorldAnchorID })?.npcIDs ?? []
            if anchorNPCs.isEmpty {
                Text(store.copy.text("states.world.npc_dialogue_unavailable.title", fallback: "That witness thread is not ready yet."))
                    .foregroundStyle(.secondary)
                    .padding(.vertical, 8)
            } else {
                ForEach(anchorNPCs, id: \.self) { npcID in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(store.npcName(for: npcID))
                            .font(.headline)
                        Text(store.npcSummary(for: npcID))
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Button(store.copy.text("world.npc_cta", fallback: "Listen")) {
                            store.track(.npcInteractionStarted, surface: "world", properties: ["npc_id": npcID])
                            selectedNPC = SelectedNPC(id: npcID)
                        }
                        .buttonStyle(.bordered)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.85))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                }
            }
        }
    }

    private func shopCard(store: FirstPlayableStore) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(store.copy.text("shop.headline", fallback: "Quarter Market"))
                        .font(.headline)
                    Text("Gold: \(store.goldBalance)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Button(store.copy.text("shop.open_cta", fallback: "Open market")) {
                    store.track(.shopOpened, surface: "world", properties: ["chapter_id": store.chapterState.chapterID])
                    isShopPresented = true
                }
                .buttonStyle(.borderedProminent)
                .disabled(store.completionDayCount < 7)
                .tint(Color(red: 0.45, green: 0.24, blue: 0.13))
            }

            Text(store.completionDayCount < 7 ? "The market opens after the oven rekindles." : "Spend Gold on a small curated set of props and keepsakes that make your progress visible.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .background(Color(red: 0.98, green: 0.96, blue: 0.92))
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
    }
}

private struct SelectedNPC: Identifiable {
    let id: String
}

private struct NPCDialogueSheet: View {
    let store: FirstPlayableStore
    let npcID: String
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 18) {
                Text(store.npcName(for: npcID))
                    .font(.title2.bold())
                Text(store.dialogueLine(for: npcID))
                    .font(.body)
                VStack(alignment: .leading, spacing: 8) {
                    Text(store.copy.text("dialogue.current_objective_title", fallback: "What this changes"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(store.districtState.problemSummary)
                    Text(store.copy.text("dialogue.next_action_title", fallback: "Next useful action"))
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Text(store.nextActionText(for: npcID))
                }
                Spacer()
                Button(store.copy.text("dialogue.dismiss_cta", fallback: "Back to district")) {
                    store.track(.npcDialogueCompleted, surface: "world", properties: ["npc_id": npcID, "chapter_id": store.chapterState.chapterID])
                    dismiss()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color(red: 0.45, green: 0.24, blue: 0.13))
            }
            .padding()
            .navigationTitle(store.copy.text("dialogue.headline", fallback: "Witness"))
        }
    }
}

private struct ShopSheet: View {
    let store: FirstPlayableStore
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Text("Gold available: \(store.goldBalance)")
                        .font(.headline)
                }

                ForEach(store.availableShopOffers) { offer in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(offer.itemName)
                                    .font(.headline)
                                Text(offer.itemSummary)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(offer.priceGold) Gold")
                                .font(.footnote.weight(.semibold))
                        }

                        Text("Sold by \(store.npcName(for: offer.vendorNpcID))")
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        if offer.isLocked {
                            Text(offer.isOwned ? store.copy.text("shop.owned_label", fallback: "Owned") : store.copy.text("shop.locked_label", fallback: "Unlocks deeper in Chapter One"))
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.secondary)
                        }

                        Button(store.copy.text("shop.buy_cta", fallback: "Buy with Gold")) {
                            store.purchaseOffer(offer.id)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(offer.isLocked || !offer.canAfford)
                        .tint(Color(red: 0.45, green: 0.24, blue: 0.13))
                    }
                    .padding(.vertical, 6)
                }
            }
            .navigationTitle(store.copy.text("shop.headline", fallback: "Quarter Market"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
