import SwiftUI

struct HearthRootView: View {
    @EnvironmentObject private var environment: AppEnvironment

    static func heroConfiguration(for store: FirstPlayableStore) -> AvatarPreviewConfiguration {
        store.hearthAvatarPreviewConfiguration
    }

    static let heroAssetSlots: [AevoraAssetSlot] = [.hearthEnvironmentBase, .hearthDecor, .avatarBaseBustAnchor]

    static func slot(for item: InventoryItemState) -> AevoraAssetSlot {
        item.bucket == "cosmetic" ? .cosmeticIcon : .itemIcon
    }

    var body: some View {
        NavigationStack {
            let store = environment.firstPlayableStore
            let assetResolver = environment.assetResolver
            let storedItems = store.inventoryItems.filter { $0.status != "applied" }
            let appliedItems = store.inventoryItems.filter { $0.status == "applied" }
            let heroConfiguration = Self.heroConfiguration(for: store)
            let heroAssetResolutions = assetResolver.resolve(slots: Self.heroAssetSlots)

            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text(store.hearthState.title)
                        .font(AevoraTokens.Typography.displayLarge)

                    AvatarPreviewCard(
                        configuration: heroConfiguration,
                        style: .hearth,
                        assetResolutions: heroAssetResolutions
                    )

                    VStack(alignment: .leading, spacing: 10) {
                        Text("Gold on hand: \(store.goldBalance)")
                            .font(AevoraTokens.Typography.headline)
                        if store.hearthState.chapterClosureReady {
                            Text("The starter arc is complete. Chapter One keepsakes can now stay visible here.")
                                .font(AevoraTokens.Typography.headline)
                        }
                    }
                    .padding(18)
                    .background(AevoraTokens.Color.surface.cardPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.lg, style: .continuous))

                    VStack(alignment: .leading, spacing: 12) {
                        Text(store.copy.text("inventory.stored_title", fallback: "In your pack"))
                            .font(AevoraTokens.Typography.headline)
                        AevoraAssetAccentView(
                            resolution: assetResolver.resolve(.itemIcon),
                            title: "Inventory icon family",
                            subtitle: "Stored keepsakes keep one logical slot family while placeholder icons stand in."
                        )
                        if storedItems.isEmpty {
                            Text(store.copy.text("states.hearth.inventory_empty.title", fallback: "Your Hearth is still waiting for its first keepsake."))
                                .font(AevoraTokens.Typography.subheadline)
                                .foregroundStyle(AevoraTokens.Color.text.secondary)
                        } else {
                            ForEach(storedItems) { item in
                                itemCard(
                                    item: item,
                                    resolution: assetResolver.resolve(Self.slot(for: item)),
                                    buttonTitle: store.copy.text("inventory.apply_cta", fallback: "Place in Hearth")
                                ) {
                                    store.toggleItemApplied(item.id)
                                }
                            }
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text(store.copy.text("inventory.applied_title", fallback: "Already visible"))
                            .font(AevoraTokens.Typography.headline)
                        AevoraAssetAccentView(
                            resolution: assetResolver.resolve(.hearthDecor),
                            title: "Hearth decor slot",
                            subtitle: "Applied keepsakes remain visible through one decor family hook."
                        )
                        if appliedItems.isEmpty {
                            Text("Place a prop or keepsake here to make your progress visible at home.")
                                .font(AevoraTokens.Typography.subheadline)
                                .foregroundStyle(AevoraTokens.Color.text.secondary)
                        } else {
                            ForEach(appliedItems) { item in
                                itemCard(
                                    item: item,
                                    resolution: assetResolver.resolve(Self.slot(for: item)),
                                    buttonTitle: store.copy.text("inventory.remove_cta", fallback: "Return to pack")
                                ) {
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

    private func itemCard(
        item: InventoryItemState,
        resolution: AevoraAssetResolution,
        buttonTitle: String,
        action: @escaping () -> Void
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            AevoraAssetAccentView(
                resolution: resolution,
                title: "Item art slot",
                subtitle: resolution.logicalPath
            )
            Text(item.name)
                .font(AevoraTokens.Typography.headline)
            Text(item.summary)
                .font(AevoraTokens.Typography.subheadline)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
            Text("\(item.bucket.capitalized) • \(item.rarity.capitalized)")
                .font(AevoraTokens.Typography.footnote)
                .foregroundStyle(AevoraTokens.Color.text.secondary)
            Button(buttonTitle, action: action)
                .buttonStyle(.bordered)
                .tint(AevoraTokens.Color.action.primaryFill)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(AevoraTokens.Color.surface.cardElevated)
        .clipShape(RoundedRectangle(cornerRadius: AevoraTokens.Radius.sm, style: .continuous))
    }
}
