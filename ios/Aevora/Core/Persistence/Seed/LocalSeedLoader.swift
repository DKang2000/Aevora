import Foundation

struct SeedScenario: Identifiable, Equatable {
    let id: String
    let title: String
    let fixtureReferences: [String]
}

final class SeedScenarioLoader {
    func loadScenarios() -> [SeedScenario] {
        [
            SeedScenario(
                id: "new_user",
                title: "New User",
                fixtureReferences: [
                    "shared/contracts/fixtures/launch/user_free_new.json",
                    "shared/contracts/fixtures/launch/starter_plan_three_vows.json"
                ]
            ),
            SeedScenario(
                id: "rekindling",
                title: "Rekindling User",
                fixtureReferences: [
                    "shared/contracts/fixtures/launch/cooling_rekindle_example.json"
                ]
            ),
            SeedScenario(
                id: "premium_trial",
                title: "Premium Trial",
                fixtureReferences: [
                    "shared/contracts/fixtures/launch/user_trial_premium.json"
                ]
            )
        ]
    }
}
