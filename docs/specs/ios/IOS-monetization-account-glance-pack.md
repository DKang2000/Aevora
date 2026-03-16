# IOS Monetization, Account, and Glance Pack

## Purpose
Ship the iPhone-side monetization and return-surface spine for the starter arc without violating the free-path promise.

## Why it exists
The first magical moment now exists, but the product still needed a real soft paywall, durable subscription/account state, and out-of-app witness surfaces so the return loop extends beyond the app shell.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`
- `docs/specs/ios/IOS-durable-starter-arc-pack.md`

## Sections
### IOS-02 / IOS-06 / IOS-20 / IOS-31
- The soft paywall stays dismissible and appears only after the first magical moment.
- Subscription, restore, downgrade, guest-link, export, and delete actions are coordinated through `AccountSurfaceStore`.
- Subscription state persists across store rebuilds and relaunches.

### IOS-21 / IOS-22 / IOS-23
- Notification education and local reminder orchestration live alongside the starter arc instead of in a disconnected settings-only flow.
- A free Today widget is always available.
- Premium breadth unlocks the deeper widget and Live Activity witness surfaces.

### Optional narrow IOS-25
- Deep-link handling for widget, Live Activity, and notification return paths is present without broadening into a full Shortcuts feature set.

## Output / canonical artifact
- Monetization/account/glance implementation under `ios/Aevora/`, `ios/AevoraWidgets/`, and `ios/SharedGlance/`
- iOS validation in `ios/AevoraTests/Account/AccountSurfaceStoreTests.swift`

## Edge cases
- Deleting the local account resets starter-arc state and glance payloads.
- Free users continue to receive the core widget without premium witness breadth.
- Notification permission denial degrades safely to in-app return cues.

## Explicit non-goals
- App Store product configuration
- deep widget family expansion
- HealthKit verification
