# Verified Inputs, Notifications, and Automation Closeout Evidence Pack

Date: 2026-03-16
Scope: notification education and reminder planning, local notification deep links, narrow HealthKit verified inputs, App Intents / Shortcuts, and entitlement reconciliation hardening

## `<VERIFIED_INPUTS_NOTIFICATIONS_AUTOMATION> complete`

Canonical artifact:
- `docs/specs/ux/UX-verified-inputs-notifications-automation-pack.md`
- `docs/specs/ios/IOS-verified-inputs-notifications-automation-pack.md`
- `docs/specs/backend/BE-verified-inputs-notifications-automation-pack.md`
- `docs/specs/game-systems/GS-verified-inputs-notifications-automation-pack.md`
- `docs/specs/qa/QA-verified-inputs-notifications-automation-pack.md`
- `shared/contracts/api/aevora-v1.openapi.yaml`

Supporting files created/updated:
- `backend/apps/api/src/core-loop/core-loop.service.ts`
- `backend/apps/api/src/core-loop/core-loop.types.ts`
- `backend/apps/api/src/progression/progression.controller.ts`
- `backend/apps/api/src/subscription/subscription.controller.ts`
- `backend/apps/api/src/subscription/subscription.module.ts`
- `backend/apps/api/src/subscription/subscription-webhook.controller.ts`
- `backend/apps/api/test/core-loop.e2e-spec.ts`
- `backend/apps/api/test/core-loop.postgres.e2e-spec.ts`
- `ios/Aevora/App/AppDeepLink.swift`
- `ios/Aevora/App/AppNotificationDelegate.swift`
- `ios/Aevora/App/AppEnvironment.swift`
- `ios/Aevora/Core/Automation/`
- `ios/Aevora/Core/Health/`
- `ios/Aevora/Core/Notifications/`
- `ios/Aevora/Features/Account/AccountSurfaceStore.swift`
- `ios/Aevora/Features/CoreLoop/FirstPlayableStore.swift`
- `ios/Aevora/Features/Profile/ProfileRootView.swift`
- `ios/Aevora/Features/Today/TodayRootView.swift`
- `ios/AevoraTests/Account/AccountSurfaceStoreTests.swift`
- `ios/AevoraTests/AppNavigationTests.swift`
- `ios/AevoraTests/CoreLoop/FirstPlayableStoreTests.swift`
- `content/launch/copy/en/core.v1.json`

Validation run:
- `jq empty content/launch/copy/en/core.v1.json` — pass
- `corepack pnpm typecheck` — pass
- `corepack pnpm test` — pass
- `corepack pnpm --filter @aevora/api validate:analytics` — pass
- `corepack pnpm --filter @aevora/api validate:datasets` — pass
- `xcodegen generate --spec ios/project.yml` — pass
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'` — pass

Key decisions:
- Keep reminders sparse and derived from the existing vow/chapter model instead of building a new reminder subsystem.
- Treat HealthKit verification as narrow, additive, and premium-gated while preserving manual logging everywhere.
- Route notifications and shortcuts through the same deep-link and completion pathways already used by the app shell.
- Preserve server-authoritative entitlement outcomes while keeping the client local-first and offline-capable.

Conflicts or assumptions:
- HealthKit imports remain a narrow deterministic stub on device/runtime until richer query depth is intentionally added.
- StoreKit server notification handling is deterministic and launch-safe, but it is not yet a full receipt-verification or App Store sandbox proof stack.

Downstream sections unblocked:
- final launch-readiness hardening around recovery, compliance, and publishing proof
- later signed TestFlight and App Store sandbox validation
- final widget / Live Activity polish without changing the underlying data model

Anything still missing:
- full App Store sandbox / receipt-verification depth
- signed TestFlight proof with Apple/App Store Connect secrets configured
- broad device-matrix and cold-start hardening sweep
