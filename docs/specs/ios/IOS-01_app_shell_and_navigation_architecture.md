# IOS-01 — App Shell and Navigation Architecture

## Purpose
Establish the native iPhone app shell, dependency container, and four-tab root navigation model for the Aevora v1 client.

## Why it exists
Foundation iOS work needs one canonical app entry and one canonical tab model before feature-specific flows can be added without fragmenting navigation patterns.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/product/00_START_HERE.md`
- `docs/product/04_SECTION_CONTEXT_INDEX.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`
- `docs/specs/source-of-truth/ST-10_string_key_registry_copy_token_structure.md`
- `docs/specs/source-of-truth/ST-11_seed_data_fixture_pack.md`
- `docs/specs/source-of-truth/ST-12_acceptance_criteria_matrix.md`

## Output / canonical artifact
- XcodeGen project definition at `ios/project.yml`
- app entry at `ios/Aevora/AevoraApp.swift`
- dependency container at `ios/Aevora/App/AppEnvironment.swift`
- tab model at `ios/Aevora/App/Navigation/AppTab.swift`
- root tab shell at `ios/Aevora/App/Navigation/RootTabView.swift`
- placeholder roots for Today, World, Hearth, and Profile under `ios/Aevora/Features/`
- navigation tests in `ios/AevoraTests/AppNavigationTests.swift`
- operator notes in `ios/README.md`

## Repo adaptation
- Pack implementation home `apps/ios` is adapted to the canonical repo root `ios/`.
- Required read substitution: `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`.
- Required read substitution: `docs/product/foundation/02_v1_PRD.md` -> `docs/product/02_v1_PRD.md`.
- Required read substitution: `docs/product/foundation/06_Technical_Architecture_Spec.md` -> `docs/product/06_Technical_Architecture_Spec.md`.
- Required read substitution: `docs/product/foundation/08_Art_UI_System_Spec.md` -> `docs/product/08_Art_UI_System_Spec.md`.

## Edge cases
- The debug menu must remain gated to `DEBUG` builds so the shell does not leak internal tooling into release builds.
- Root navigation must stay portrait-first and lightweight so logging remains faster than world navigation.
- Shared status surfaces must overlay safely across all four root tabs without each tab re-implementing sync state.

## Acceptance criteria
- The project can be generated deterministically from `ios/project.yml`.
- The app boots through one root `AppEnvironment` and one `RootTabView`.
- The shell exposes exactly four root tabs: Today, World, Hearth, and Profile.
- Minimal tests prove the shell boots and tab selection changes through shared state.

## Validation
- `xcodegen generate --spec ios/project.yml`
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'`

## Explicit non-goals
- feature-complete Today, World, Hearth, or Profile screens
- onboarding, vows, or district gameplay logic
- iPad or landscape-first navigation composition
