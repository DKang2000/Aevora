import Foundation

enum AevoraAssetSurface: String, CaseIterable, Identifiable {
    case onboarding
    case avatar
    case today
    case reward
    case npc
    case world
    case hearth
    case inventory
    case shop
    case brand
    case marketing

    var id: String { rawValue }
}

struct AevoraAssetSlot: Hashable, Identifiable, RawRepresentable, Codable {
    let rawValue: String

    init(rawValue: String) {
        self.rawValue = rawValue
    }

    var id: String { rawValue }

    static let onboardingPromiseCards = AevoraAssetSlot(rawValue: "onboarding.promise.card.family")
    static let onboardingProblemSolutionCards = AevoraAssetSlot(rawValue: "onboarding.problemSolution.card.family")
    static let onboardingFamilySelectionCards = AevoraAssetSlot(rawValue: "onboarding.familySelection.card.family")
    static let onboardingIdentitySelectionCards = AevoraAssetSlot(rawValue: "onboarding.identitySelection.card.family")
    static let onboardingMagicalMomentHero = AevoraAssetSlot(rawValue: "onboarding.magicMoment.hero")
    static let onboardingPaywallSupporting = AevoraAssetSlot(rawValue: "onboarding.paywall.supporting.family")
    static let avatarBaseBodyFrame = AevoraAssetSlot(rawValue: "avatar.base.bodyFrame.family")
    static let avatarBaseBustAnchor = AevoraAssetSlot(rawValue: "avatar.base.bustAnchor.family")
    static let npcBust = AevoraAssetSlot(rawValue: "npc.bust.family")
    static let npcVendorBust = AevoraAssetSlot(rawValue: "npc.vendor.bust.family")
    static let worldTilesetCyrane = AevoraAssetSlot(rawValue: "world.tileset.cyrane.family")
    static let worldDistrictAccent = AevoraAssetSlot(rawValue: "world.district.accent.family")
    static let worldSignage = AevoraAssetSlot(rawValue: "world.signage.family")
    static let districtRepairState = AevoraAssetSlot(rawValue: "district.repairState.family")
    static let hearthEnvironmentBase = AevoraAssetSlot(rawValue: "hearth.environment.base.family")
    static let hearthDecor = AevoraAssetSlot(rawValue: "hearth.decor.family")
    static let itemIcon = AevoraAssetSlot(rawValue: "item.icon.family")
    static let cosmeticIcon = AevoraAssetSlot(rawValue: "cosmetic.icon.family")
    static let shopCardArt = AevoraAssetSlot(rawValue: "shop.cardArt.family")
    static let rewardFX = AevoraAssetSlot(rawValue: "fx.reward.family")
    static let worldRepairFX = AevoraAssetSlot(rawValue: "fx.worldRepair.family")
    static let chapterCard = AevoraAssetSlot(rawValue: "card.chapter.family")
    static let rewardCard = AevoraAssetSlot(rawValue: "card.reward.family")
    static let promoCard = AevoraAssetSlot(rawValue: "card.promo.family")
}

struct AevoraAssetSlotFamily: Identifiable, Hashable, Equatable {
    let id: String
    let sectionId: String
    let betaCritical: Bool
    let surfaces: Set<AevoraAssetSurface>
}

struct AevoraAssetRegistry {
    private struct Seed: Codable {
        struct Pack: Codable {
            let sectionId: String
            let betaCritical: Bool
            let slotFamilies: [String]
        }

        let schemaVersion: String
        let notes: String
        let packs: [Pack]
    }

    let families: [AevoraAssetSlotFamily]
    private let familyLookup: [String: AevoraAssetSlotFamily]

    init(families: [AevoraAssetSlotFamily]) {
        self.families = families.sorted { lhs, rhs in
            if lhs.sectionId == rhs.sectionId {
                return lhs.id < rhs.id
            }
            return lhs.sectionId < rhs.sectionId
        }
        familyLookup = Dictionary(uniqueKeysWithValues: self.families.map { ($0.id, $0) })
    }

    static func load() -> AevoraAssetRegistry {
        for bundle in candidateBundles {
            if let url = bundle.url(forResource: "aevora-v1-asset-slot-families.seed", withExtension: "json"),
               let data = try? Data(contentsOf: url),
               let seed = try? JSONDecoder().decode(Seed.self, from: data) {
                return registry(from: seed)
            }
        }

        return registry(from: fallbackSeed)
    }

    var allSlots: [AevoraAssetSlot] {
        families.map { AevoraAssetSlot(rawValue: $0.id) }
    }

    func family(for slot: AevoraAssetSlot) -> AevoraAssetSlotFamily? {
        familyLookup[slot.rawValue]
    }

    func slots(for surface: AevoraAssetSurface) -> [AevoraAssetSlot] {
        families
            .filter { $0.surfaces.contains(surface) }
            .map { AevoraAssetSlot(rawValue: $0.id) }
    }

    func betaCriticalSlots(for surface: AevoraAssetSurface? = nil) -> [AevoraAssetSlot] {
        families
            .filter { family in
                family.betaCritical && (surface == nil || family.surfaces.contains(surface!))
            }
            .map { AevoraAssetSlot(rawValue: $0.id) }
    }

    private static var candidateBundles: [Bundle] {
        var bundles: [Bundle] = [Bundle.main, Bundle(for: AevoraAssetBundleMarker.self)]
        if let allFrameworks = Bundle.allFrameworks.first {
            bundles.append(allFrameworks)
        }
        var seen = Set<ObjectIdentifier>()
        return bundles.filter { seen.insert(ObjectIdentifier($0)).inserted }
    }

    private static func registry(from seed: Seed) -> AevoraAssetRegistry {
        let families = seed.packs.flatMap { pack in
            pack.slotFamilies.map { familyID in
                AevoraAssetSlotFamily(
                    id: familyID,
                    sectionId: pack.sectionId,
                    betaCritical: pack.betaCritical,
                    surfaces: surfaces(for: familyID)
                )
            }
        }
        return AevoraAssetRegistry(families: families)
    }

    private static func surfaces(for familyID: String) -> Set<AevoraAssetSurface> {
        if familyID.hasPrefix("brand.") || familyID.hasPrefix("icon.") {
            return [.brand]
        }
        if familyID.hasPrefix("onboarding.") {
            return [.onboarding]
        }
        if familyID.hasPrefix("avatar.") || familyID.hasPrefix("identity.") {
            return [.avatar, .hearth]
        }
        if familyID.hasPrefix("npc.") {
            return [.npc, .world, .shop]
        }
        if familyID.hasPrefix("world.") || familyID.hasPrefix("district.") || familyID.hasPrefix("prop.") {
            return [.world, .hearth]
        }
        if familyID.hasPrefix("hearth.") {
            return [.hearth]
        }
        if familyID.hasPrefix("item.") || familyID.hasPrefix("cosmetic.") {
            return [.inventory, .shop, .hearth]
        }
        if familyID.hasPrefix("shop.") {
            return [.shop]
        }
        if familyID.hasPrefix("fx.") {
            return [.reward, .today, .world]
        }
        if familyID.hasPrefix("card.chapter") {
            return [.today]
        }
        if familyID.hasPrefix("card.reward") {
            return [.reward, .today]
        }
        if familyID.hasPrefix("card.promo") {
            return [.today, .shop]
        }
        if familyID.hasPrefix("marketing.") {
            return [.marketing]
        }
        return [.world]
    }

    private static let fallbackSeed = Seed(
        schemaVersion: "draft-prebeta-v1",
        notes: "Fallback slot-family registry for pre-beta placeholder runtime.",
        packs: [
            .init(sectionId: "ART-02", betaCritical: true, slotFamilies: ["brand.mark.primary", "brand.mark.mono", "icon.app.1024", "icon.app.iosMasked"]),
            .init(sectionId: "ART-05", betaCritical: true, slotFamilies: ["onboarding.promise.card.family", "onboarding.problemSolution.card.family", "onboarding.familySelection.card.family", "onboarding.identitySelection.card.family", "onboarding.magicMoment.hero", "onboarding.paywall.supporting.family"]),
            .init(sectionId: "ART-06", betaCritical: true, slotFamilies: ["avatar.base.bodyFrame.family", "avatar.base.skinTone.family", "avatar.base.bustAnchor.family"]),
            .init(sectionId: "ART-07", betaCritical: true, slotFamilies: ["avatar.hair.shape.family", "avatar.hair.color.family", "avatar.accessory.family", "avatar.paletteAccent.family"]),
            .init(sectionId: "ART-08", betaCritical: true, slotFamilies: ["identity.outfit.variant.family"]),
            .init(sectionId: "ART-09", betaCritical: true, slotFamilies: ["npc.bust.family", "npc.bust.expression.family", "npc.vendor.bust.family"]),
            .init(sectionId: "ART-10", betaCritical: false, slotFamilies: ["npc.sprite.idle.family", "npc.sprite.interact.family"]),
            .init(sectionId: "ART-11", betaCritical: true, slotFamilies: ["world.tileset.cyrane.family", "world.district.accent.family", "world.signage.family"]),
            .init(sectionId: "ART-12", betaCritical: true, slotFamilies: ["hearth.environment.base.family", "hearth.decor.family", "hearth.state.family"]),
            .init(sectionId: "ART-13", betaCritical: true, slotFamilies: ["prop.oven.family", "prop.lantern.family", "prop.canal.family", "prop.archive.family", "prop.stall.family", "prop.charterSeal.family"]),
            .init(sectionId: "ART-14", betaCritical: true, slotFamilies: ["district.repairState.family"]),
            .init(sectionId: "ART-15", betaCritical: true, slotFamilies: ["item.icon.family", "cosmetic.icon.family", "shop.cardArt.family"]),
            .init(sectionId: "ART-16", betaCritical: false, slotFamilies: ["fx.reward.family", "fx.sparkle.family", "fx.worldRepair.family"]),
            .init(sectionId: "ART-17", betaCritical: false, slotFamilies: ["animation.character.family"]),
            .init(sectionId: "ART-18", betaCritical: false, slotFamilies: ["animation.environment.family"]),
            .init(sectionId: "ART-19", betaCritical: false, slotFamilies: ["card.chapter.family", "card.reward.family", "card.promo.family"]),
            .init(sectionId: "ART-20", betaCritical: false, slotFamilies: ["marketing.screenshot.family", "marketing.preview.family"])
        ]
    )
}
