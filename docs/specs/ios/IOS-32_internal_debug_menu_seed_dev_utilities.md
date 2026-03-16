# IOS-32 — Internal Debug Menu + Seed / Dev Utilities

## Purpose
Create DEBUG-only local tooling for seed scenarios, feature-flag overrides, and sync inspection.

## Why it exists
Foundation delivery is faster and safer when the team can inspect queue state, load seed references, and toggle local flags without introducing production shortcuts.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/ios/IOS-01_app_shell_and_navigation_architecture.md`
- `docs/specs/ios/IOS-07_local_persistence_layer_swiftdata.md`
- `docs/specs/ios/IOS-26_remote_config_feature_flags_client.md`
- `docs/specs/source-of-truth/ST-11_seed_data_fixture_pack.md`

## Output / canonical artifact
- debug root surface in `ios/Aevora/Debug/DebugMenuRootView.swift`
- seed scenario loader in `ios/Aevora/Debug/SeedScenarioLoader.swift`
- local flag overrides in `ios/Aevora/Debug/FeatureFlagOverrideStore.swift`
- sync queue inspection surface in `ios/Aevora/Debug/SyncQueueInspector.swift`
- debug tests in `ios/AevoraTests/Debug/DebugTests.swift`

## Repo adaptation
- Pack implementation home `apps/ios` is adapted to `ios/`.
- Required read substitution: `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`.

## Edge cases
- Debug entry points must stay behind `#if DEBUG`.
- Fixture references should point back to canonical shared contract locations rather than copied local data.
- Local overrides must be explicit and reversible so they do not masquerade as server-driven config.

## Acceptance criteria
- A DEBUG-only menu can be opened from the root shell.
- Seed scenario references can be listed for local testing.
- Feature-flag overrides can round-trip locally.
- Sync queue state can be inspected from one internal surface.

## Validation
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'`

## Explicit non-goals
- shipping debug utilities in release builds
- hidden production backdoors
- custom seed content outside the canonical `ST-11` fixture references
