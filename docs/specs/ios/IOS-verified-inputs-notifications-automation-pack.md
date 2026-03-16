# IOS Verified Inputs, Notifications, and Automation Pack

## Purpose
Ship the remaining launch-critical iPhone utility surfaces: local reminder scheduling, notification handling, narrow HealthKit verification, and App Intents / Shortcuts.

## Why it exists
The app already delivers the core promise in-app. This pack makes Aevora reliable outside the app shell by letting users return from reminders, verify a small set of real-world inputs, and complete the fastest useful actions from system surfaces.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`
- `docs/specs/ios/IOS-monetization-account-glance-pack.md`

## Sections
### IOS-10 / IOS-21 — Reminder scheduling and notification handling
- `AccountSurfaceStore` builds a local notification plan from active vows, witness cadence, cooling-chain risk, and chapter-ready state.
- Notification scheduling remains local-first and permission-aware through `NotificationManager`.
- Notification payloads deep-link into `Today`, `World`, or `Quest Journal` through `AppNotificationDelegate`, `AppDeepLink`, and `AppEnvironment`.

### IOS-24 — HealthKit integration
- HealthKit support remains narrow and explicit through `SystemHealthKitManager`.
- Supported domains are `workout`, `steps`, and `sleep`, but only vow/domain combinations with a safe launch mapping may import verified completions.
- Verified completions annotate existing vow progress; they do not replace manual logging or create a second completion model.

### IOS-25 — App Intents / Shortcuts
- App Intents expose `Open Today`, `Open World`, `Open Quest Journal`, and `Complete Vow`.
- `AutomationSurfaceStore` publishes the current active-vow snapshot into the app group so shortcuts resolve the same vow list the app is using.
- Shortcut completion routes back into `FirstPlayableStore` and the same local-first sync queue.

### IOS-22 / IOS-23 hardening
- Glance payload generation, Live Activity coordination, and deep-link routing all reuse one canonical destination model.
- `SharedGlance` now includes the `shortcut` deep-link source so shortcut invocations remain traceable and do not collide with widget/notification analytics.

### Narrow IOS-31 hardening
- Account state now persists HealthKit permission status, last verified-input sync time, and the last generated notification plan.
- On relaunch, notification scheduling reconciles the real OS notification permission before deciding whether to deliver reminders.

## Output / canonical artifact
- This iOS pack
- Implementation under `ios/Aevora/App`, `ios/Aevora/Core`, `ios/Aevora/Features/Account`, and `ios/Aevora/Features/CoreLoop`
- iOS proof in `ios/AevoraTests/Account/AccountSurfaceStoreTests.swift`, `ios/AevoraTests/AppNavigationTests.swift`, and `ios/AevoraTests/CoreLoop/FirstPlayableStoreTests.swift`

## Edge cases
- Notification delivery denial degrades to in-app education and settings routing.
- HealthKit imports must suppress duplicate source events and must not double-award rewards on a day already completed manually.
- Shortcut actions must remain valid for guest users and offline-first state.

## Explicit non-goals
- general background-import infrastructure
- Apple Watch integration
- alternative shortcut-only logging models
