# IOS-08 — Networking Client + Sync Queue

## Purpose
Provide a typed API client, offline sync queue, and flush coordinator so local actions can be replayed safely against backend contracts.

## Why it exists
Offline-first logging is a core product rule. The client needs a resilient transport layer and replay queue before real vow, config, and analytics traffic can be trusted.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/ios/IOS-01_app_shell_and_navigation_architecture.md`
- `docs/specs/ios/IOS-07_local_persistence_layer_swiftdata.md`
- `docs/product/04_SECTION_CONTEXT_INDEX.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`

## Output / canonical artifact
- typed request/transport definitions in `ios/Aevora/Core/Networking/APIRequest.swift`
- request construction and decoding in `ios/Aevora/Core/Networking/APIClient.swift`
- error surface in `ios/Aevora/Core/Networking/APIError.swift`
- sync models in `ios/Aevora/Core/Sync/SyncOperation.swift`
- actor-backed queue in `ios/Aevora/Core/Sync/SyncQueue.swift`
- async flush coordinator in `ios/Aevora/Core/Sync/SyncCoordinator.swift`
- transport and replay tests in `ios/AevoraTests/Networking/APIClientTests.swift` and `ios/AevoraTests/Sync/SyncTests.swift`

## Repo adaptation
- Pack implementation home `apps/ios` is adapted to `ios/`.
- Required read substitution: `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`.
- Required read substitution: `docs/product/foundation/06_Technical_Architecture_Spec.md` -> `docs/product/06_Technical_Architecture_Spec.md`.

## Edge cases
- Replay order must stay stable across queued operations.
- Network availability checks must cross actor boundaries safely under Swift 6 isolation rules.
- Idempotency headers must be available to downstream completion and analytics uploads.

## Acceptance criteria
- A typed API client exists for ST-02-aligned request building and response decoding.
- A queue can hold offline operations, preserve order, and mark retryable failures.
- A coordinator can flush operations when network is available.
- Tests cover idempotency and replay-order behavior.

## Validation
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'`

## Explicit non-goals
- feature-specific API wrappers for every screen
- alternate payload contracts outside `ST-02`
- full conflict-resolution product flows beyond foundation replay behavior
