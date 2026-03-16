# IOS-07 — Local Persistence Layer (SwiftData)

## Purpose
Map the locked local storage contract into a SwiftData-backed persistence layer that the iOS client can depend on for offline-first behavior.

## Why it exists
The app needs on-device durability for session snapshots, vows, sync queue state, district progress, subscriptions, and remote config without allowing feature code to talk to SwiftData directly.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/ios/IOS-01_app_shell_and_navigation_architecture.md`
- `docs/product/04_SECTION_CONTEXT_INDEX.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-11_seed_data_fixture_pack.md`
- `docs/specs/source-of-truth/ST-12_acceptance_criteria_matrix.md`

## Output / canonical artifact
- SwiftData container bootstrapping in `ios/Aevora/Core/Persistence/PersistenceController.swift`
- local models in `ios/Aevora/Core/Persistence/Models/LocalModels.swift`
- repository boundary in `ios/Aevora/Core/Persistence/Repositories/LocalRepositories.swift`
- seed loader hook in `ios/Aevora/Core/Persistence/Seed/LocalSeedLoader.swift`
- round-trip tests in `ios/AevoraTests/Persistence/PersistenceTests.swift`

## Repo adaptation
- Pack implementation home `apps/ios` is adapted to `ios/`.
- Required read substitution: `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`.
- Required read substitution: `docs/product/foundation/02_v1_PRD.md` -> `docs/product/02_v1_PRD.md`.
- Required read substitution: `docs/product/foundation/06_Technical_Architecture_Spec.md` -> `docs/product/06_Technical_Architecture_Spec.md`.

## Edge cases
- In-memory containers must remain available for deterministic tests.
- Repository APIs stay `@MainActor` so SwiftUI-facing code uses one safe persistence boundary.
- Remote-config cache persistence must tolerate empty payloads and rehydration without becoming a second source of truth for server authority.

## Acceptance criteria
- The persistence controller boots with the locked v1 local entities.
- Repository methods cover the core local records needed by the current foundation shell.
- Tests verify save/load behavior for at least vows and remote-config cache.
- Seed-loading hooks exist for future fixture hydration work.

## Validation
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'`

## Explicit non-goals
- full CRUD flows for every feature module
- divergence from `ST-03`
- making the device store authoritative over backend truth
