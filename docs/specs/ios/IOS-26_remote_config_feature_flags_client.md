# IOS-26 — Remote Config + Feature Flags Client

## Purpose
Implement a typed remote-config loader with safe feature-flag accessors and local override hooks for development.

## Why it exists
The client must remain tunable without App Store releases, while keeping view code free from stringly-typed config lookups and one-off fallback logic.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/ios/IOS-01_app_shell_and_navigation_architecture.md`
- `docs/product/04_SECTION_CONTEXT_INDEX.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-12_acceptance_criteria_matrix.md`

## Output / canonical artifact
- feature-flag enum in `ios/Aevora/Core/Config/FeatureFlag.swift`
- typed config model in `ios/Aevora/Core/Config/TypedRemoteConfig.swift`
- loader and fallback behavior in `ios/Aevora/Core/Config/RemoteConfigClient.swift`
- bootstrap defaults in `ios/Aevora/Support/Config/remote-config-defaults.json`
- config tests in `ios/AevoraTests/Config/RemoteConfigClientTests.swift`

## Repo adaptation
- Pack implementation home `apps/ios` is adapted to `ios/`.
- Required read substitution: `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`.
- Required read substitution: `docs/product/foundation/06_Technical_Architecture_Spec.md` -> `docs/product/06_Technical_Architecture_Spec.md`.

## Edge cases
- Missing or malformed defaults must fail predictably rather than silently producing partial config.
- Override behavior must remain local-only and subordinate to production server-driven config rules.
- Main-actor isolation must remain explicit because config reads feed SwiftUI state.

## Acceptance criteria
- Default config parses into a typed model aligned with `ST-05`.
- Feature flags can be queried through a typed enum.
- Local override support exists for debug tooling.
- Tests cover valid config, invalid config, and flag resolution behavior.

## Validation
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'`

## Explicit non-goals
- a third-party feature flag SDK
- hard-coded product tuning values in view files
- live remote fetch orchestration beyond the foundation loader boundary
