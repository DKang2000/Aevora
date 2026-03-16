import Foundation

#if canImport(AppIntents)
import AppIntents

struct AevoraVowEntity: AppEntity, Identifiable {
    static var typeDisplayRepresentation: TypeDisplayRepresentation {
        TypeDisplayRepresentation(name: "Aevora Vow")
    }

    static var defaultQuery: AevoraVowQuery {
        AevoraVowQuery()
    }

    let id: String
    let title: String

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: LocalizedStringResource(stringLiteral: title))
    }
}

struct AevoraVowQuery: EntityStringQuery {
    func entities(for identifiers: [AevoraVowEntity.ID]) async throws -> [AevoraVowEntity] {
        AutomationSurfacePersistence.load().activeVows
            .filter { identifiers.contains($0.id) }
            .map { AevoraVowEntity(id: $0.id, title: $0.title) }
    }

    func entities(matching string: String) async throws -> [AevoraVowEntity] {
        AutomationSurfacePersistence.load().activeVows
            .filter { $0.title.localizedCaseInsensitiveContains(string) }
            .map { AevoraVowEntity(id: $0.id, title: $0.title) }
    }

    func suggestedEntities() async throws -> [AevoraVowEntity] {
        AutomationSurfacePersistence.load().activeVows
            .map { AevoraVowEntity(id: $0.id, title: $0.title) }
    }
}

struct OpenTodayIntent: AppIntent {
    static var title: LocalizedStringResource { "Open Today" }
    static var openAppWhenRun: Bool { true }

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            AppIntentRouter.shared.open(.today)
        }
        return .result()
    }
}

struct OpenWorldIntent: AppIntent {
    static var title: LocalizedStringResource { "Open World" }
    static var openAppWhenRun: Bool { true }

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            AppIntentRouter.shared.open(.world)
        }
        return .result()
    }
}

struct OpenQuestJournalIntent: AppIntent {
    static var title: LocalizedStringResource { "Open Quest Journal" }
    static var openAppWhenRun: Bool { true }

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            AppIntentRouter.shared.open(.questJournal)
        }
        return .result()
    }
}

struct CompleteVowIntent: AppIntent {
    static var title: LocalizedStringResource { "Complete Vow" }
    static var openAppWhenRun: Bool { true }

    @Parameter(title: "Vow")
    var vow: AevoraVowEntity

    func perform() async throws -> some IntentResult {
        await MainActor.run {
            AppIntentRouter.shared.completeVow(id: vow.id)
        }
        return .result(dialog: IntentDialog("Marked \(vow.title) complete in Aevora."))
    }
}

struct AevoraShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: OpenTodayIntent(), phrases: ["Open Today in \(.applicationName)"], shortTitle: "Open Today")
        AppShortcut(intent: OpenWorldIntent(), phrases: ["Open the world in \(.applicationName)"], shortTitle: "Open World")
        AppShortcut(intent: OpenQuestJournalIntent(), phrases: ["Open the quest journal in \(.applicationName)"], shortTitle: "Quest Journal")
        AppShortcut(intent: CompleteVowIntent(), phrases: ["Complete a vow in \(.applicationName)"], shortTitle: "Complete Vow")
    }
}
#endif
