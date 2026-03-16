import Foundation

private final class LaunchContentBundleToken {}

struct LaunchContent: Codable {
    struct OriginFamily: Codable, Identifiable {
        let id: String
        let titleKey: String
        let summaryKey: String
        let starterNpcId: String
        let starterQuestOverlayKey: String
    }

    struct AvatarDefaults: Codable, Equatable {
        let silhouetteId: String
        let paletteId: String
        let accessoryIds: [String]
    }

    struct IdentityShell: Codable, Identifiable {
        let id: String
        let originFamilyId: String
        let displayNameKey: String
        let summaryKey: String
        let flavorOverlayKeys: [String]
        let defaultAvatar: AvatarDefaults?
    }

    struct DistrictStage: Codable, Equatable {
        let id: String
        let titleKey: String
        let sceneMoodKey: String
        let worldChangeKey: String
    }

    struct District: Codable, Identifiable {
        let id: String
        let titleKey: String
        let summaryKey: String
        let startStageId: String
        let restorationStages: [DistrictStage]
        let problemTemplateIds: [String]
    }

    struct NPC: Codable, Identifiable {
        let id: String
        let displayNameKey: String
        let summaryKey: String
        let districtId: String
        let dialogueSetKey: String
        let role: String
        let sceneAnchorId: String?
    }

    struct Chapter: Codable, Identifiable {
        let id: String
        let titleKey: String
        let summaryKey: String
        let entitlementGate: String
        let questIds: [String]
        let startingQuestId: String
        let tomorrowCtaKey: String
    }

    struct QuestTemplate: Codable, Identifiable {
        let id: String
        let titleKey: String
        let summaryKey: String
        let rewardTableId: String
        let restorationStageId: String
        let dialogueSetKey: String
    }

    struct StarterVowTemplate: Codable, Identifiable {
        struct Schedule: Codable, Equatable {
            let cadence: String
            let activeWeekdays: [String]
        }

        let id: String
        let titleKey: String
        let type: String
        let category: String
        let targetValue: Int
        let targetUnit: String
        let difficulty: String
        let applicableLifeAreas: [String]
        let blockerMatches: [String]
        let toneBias: [String]
        let schedule: Schedule
    }

    struct MagicalMoment: Codable, Identifiable {
        let id: String
        let titleKey: String
        let summaryKey: String
    }

    struct StarterArcDay: Codable, Equatable {
        let day: Int
        let questId: String
        let restorationStageId: String
        let worldMomentId: String
        let npcIdsVisible: [String]
        let tomorrowPromptKey: String
    }

    struct ChapterOneMilestone: Codable, Identifiable, Equatable {
        let id: String
        let startDay: Int
        let endDay: Int
        let questId: String
        let restorationStageId: String
        let worldMomentId: String
        let npcIdsVisible: [String]
        let tomorrowPromptKey: String
    }

    struct ItemDefinition: Codable, Identifiable {
        let id: String
        let nameKey: String
        let summaryKey: String?
        let bucket: String
        let rarity: String
        let slot: String?
        let applyMode: String?
    }

    struct ShopOffer: Codable, Identifiable {
        let id: String
        let itemDefinitionId: String
        let priceGold: Int
        let entitlementGate: String
        let vendorNpcId: String?
        let stockLimit: Int?
        let chapterGate: String?
        let repeatable: Bool?
    }

    let schemaVersion: String
    let originFamilies: [OriginFamily]
    let identityShells: [IdentityShell]
    let districts: [District]
    let npcs: [NPC]
    let chapters: [Chapter]
    let questTemplates: [QuestTemplate]
    let starterVowTemplates: [StarterVowTemplate]
    let magicalMoments: [MagicalMoment]
    let starterArcDays: [StarterArcDay]
    let chapterOneMilestones: [ChapterOneMilestone]
    let itemDefinitions: [ItemDefinition]
    let shopOffers: [ShopOffer]

    static var fallback: LaunchContent {
        let fallbackData = Data("""
        {
          "schemaVersion":"v1",
          "originFamilies":[{"id":"hearthkeeper","titleKey":"content.family.hearthkeeper.title","summaryKey":"content.family.hearthkeeper.summary","starterNpcId":"tovan_hearth","starterQuestOverlayKey":"content.family.hearthkeeper.overlay"}],
          "identityShells":[{"id":"idn_baker","originFamilyId":"hearthkeeper","displayNameKey":"content.identity.baker.name","summaryKey":"content.identity.baker.summary","flavorOverlayKeys":["content.identity.baker.overlay"],"defaultAvatar":{"silhouetteId":"silhouette_oven_apron","paletteId":"palette_ember_ochre","accessoryIds":["accessory_flour_wrap"]}}],
          "districts":[{"id":"ember_quay","titleKey":"content.district.ember_quay.title","summaryKey":"content.district.ember_quay.summary","startStageId":"dim","restorationStages":[{"id":"dim","titleKey":"content.district.ember_quay.stage.dim","sceneMoodKey":"content.district.ember_quay.mood.dim","worldChangeKey":"content.district.ember_quay.change.dim"},{"id":"stirring","titleKey":"content.district.ember_quay.stage.stirring","sceneMoodKey":"content.district.ember_quay.mood.stirring","worldChangeKey":"content.district.ember_quay.change.stirring"}],"problemTemplateIds":["starter_oven_crisis"]}],
          "npcs":[{"id":"tovan_hearth","displayNameKey":"content.npc.tovan_hearth.name","summaryKey":"content.npc.tovan_hearth.summary","districtId":"ember_quay","dialogueSetKey":"content.dialogue.tovan_hearth","role":"baker","sceneAnchorId":"oven_square"}],
          "chapters":[{"id":"starter_arc","titleKey":"content.chapter.starter_arc.title","summaryKey":"content.chapter.starter_arc.summary","entitlementGate":"free","questIds":["starter_day_1_arrival"],"startingQuestId":"starter_day_1_arrival","tomorrowCtaKey":"content.chapter.starter_arc.tomorrow"}],
          "questTemplates":[{"id":"starter_day_1_arrival","titleKey":"content.quest.starter_day_1.title","summaryKey":"content.quest.starter_day_1.summary","rewardTableId":"starter","restorationStageId":"stirring","dialogueSetKey":"content.dialogue.quest.day_1"}],
          "starterVowTemplates":[{"id":"vow_template_walk_10","titleKey":"content.vow.walk_10.title","type":"duration","category":"Physical","targetValue":10,"targetUnit":"minutes","difficulty":"gentle","applicableLifeAreas":["Physical"],"blockerMatches":[],"toneBias":["gentle","balanced"],"schedule":{"cadence":"daily","activeWeekdays":["mon","tue","wed","thu","fri","sat","sun"]}}],
          "magicalMoments":[{"id":"oven_glow","titleKey":"content.moment.oven_glow.title","summaryKey":"content.moment.oven_glow.summary"}],
          "starterArcDays":[{"day":1,"questId":"starter_day_1_arrival","restorationStageId":"stirring","worldMomentId":"oven_glow","npcIdsVisible":["tovan_hearth"],"tomorrowPromptKey":"content.tomorrow.day_1"}],
          "chapterOneMilestones":[],
          "itemDefinitions":[{"id":"ember_quay_token","nameKey":"content.item.ember_quay_token.name","summaryKey":"content.item.ember_quay_token.summary","bucket":"reward_token","rarity":"uncommon","slot":"keepsake","applyMode":"display"}],
          "shopOffers":[]
        }
        """.utf8)
        return try! JSONDecoder().decode(LaunchContent.self, from: fallbackData)
    }
}

enum LaunchContentLoadError: Error {
    case missingResource
}

struct LaunchContentLoader {
    func load(bundle: Bundle = .main) throws -> LaunchContent {
        let bundles = [bundle, Bundle(for: LaunchContentBundleToken.self)] + Bundle.allBundles + Bundle.allFrameworks
        let url = bundles.lazy.compactMap { $0.url(forResource: "launch-content.min.v1", withExtension: "json") }.first

        guard let url else {
            throw LaunchContentLoadError.missingResource
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(LaunchContent.self, from: data)
    }
}
