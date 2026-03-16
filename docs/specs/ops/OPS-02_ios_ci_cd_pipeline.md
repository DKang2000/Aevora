# OPS-02 — iOS CI / CD Pipeline

## Purpose
Define the automated validation path for the native iPhone app, from project generation through test execution.

## Why it exists
The iOS shell now has a deterministic XcodeGen path and a passing unit test suite. CI needs to enforce that path so project generation drift or Swift 6 regressions fail before merge.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/ios/IOS-01_app_shell_and_navigation_architecture.md`
- `docs/product/04_SECTION_CONTEXT_INDEX.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`

## Output / canonical artifact
- GitHub Actions workflow at `.github/workflows/ios-ci.yml`
- operator notes at `ops/ci/ios/README.md`

## Repo adaptation
- GitHub Actions remains the canonical CI system because the repo already contains workflow infrastructure.
- Required read substitution: `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`.
- Required read substitution: `docs/product/foundation/06_Technical_Architecture_Spec.md` -> `docs/product/06_Technical_Architecture_Spec.md`.

## Edge cases
- CI must generate the project from `ios/project.yml` instead of trusting a checked-in `.xcodeproj`.
- The simulator destination may need periodic updates as hosted Xcode images roll forward.
- Workflow secrets must remain optional for CI validation; signing is delegated to TestFlight workflow handling.

## Acceptance criteria
- Pull requests and pushes touching the iOS client trigger project generation and tests on macOS runners.
- Workflow documentation lists runner assumptions, commands, and failure surfaces.
- The CI path fails loudly on XcodeGen or `xcodebuild test` failure.

## Validation
- Workflow YAML parses successfully.
- Local reference command: `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'`

## Explicit non-goals
- embedding Apple credentials in CI
- skipping project generation in favor of hand-maintained Xcode state
- TestFlight publishing details, which belong to `OPS-10`
