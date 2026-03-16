# IOS-30 — Offline Banners + Sync / Conflict UI

## Purpose
Expose shared offline and sync-state UI so local-first behavior is visible and trustworthy across the app shell.

## Why it exists
Users need clear feedback when actions are queued, syncing, or blocked by connectivity. Hidden offline behavior would make the product feel unreliable even when the queue is working correctly.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/ios/IOS-08_networking_client_sync_queue.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`

## Output / canonical artifact
- connectivity monitor in `ios/Aevora/Core/Sync/ConnectivityMonitor.swift`
- shared status store in `ios/Aevora/Shared/Status/SyncStatusStore.swift`
- offline banner view in `ios/Aevora/Shared/Status/OfflineBannerView.swift`
- conflict entry surface in `ios/Aevora/Shared/Status/SyncConflictView.swift`
- status tests in `ios/AevoraTests/Status/StatusTests.swift`

## Repo adaptation
- Pack implementation home `apps/ios` is adapted to `ios/`.
- Required read substitution: `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`.

## Edge cases
- Offline banners must be shared rather than duplicated in feature roots.
- Conflict UI remains a minimal entry point until feature-specific merge flows exist.
- The status store must reconcile connectivity state and queued-count state without each feature owning its own polling logic.

## Acceptance criteria
- Connectivity state can be observed centrally.
- Banner state resolves among hidden, offline, syncing, and conflict conditions.
- Root navigation overlays the shared status surface.
- Tests cover offline and queued-sync transitions.

## Validation
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'`

## Explicit non-goals
- inventing new UI states outside `ST-09`
- full merge UX for every conflictable feature
- per-screen network status implementations
