import SwiftUI

struct WorldRootView: View {
    @EnvironmentObject private var environment: AppEnvironment

    var body: some View {
        NavigationStack {
            let store = environment.firstPlayableStore

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(store.copy.text("world.headline", fallback: "World"))
                        .font(.system(size: 34, weight: .bold, design: .rounded))

                    WorldSceneContainer(state: store.districtState)

                    VStack(alignment: .leading, spacing: 8) {
                        Text(store.districtState.stageTitle)
                            .font(.title3.bold())
                        Text(store.districtState.moodText)
                            .foregroundStyle(.secondary)
                        Text(store.districtState.worldChangeText)
                        Text("Starter arc day \(store.chapterState.currentDay) of 7")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                    .padding(18)
                    .background(Color(red: 0.98, green: 0.96, blue: 0.92))
                    .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Witnesses")
                            .font(.headline)
                        ForEach(store.districtState.visibleNPCIDs, id: \.self) { npcID in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(store.npcName(for: npcID))
                                    .font(.headline)
                                Text(store.npcSummary(for: npcID))
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(14)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white.opacity(0.8))
                            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("World")
        }
    }
}
