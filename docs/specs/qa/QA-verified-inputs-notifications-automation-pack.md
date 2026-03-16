# QA Verified Inputs, Notifications, and Automation Pack

## Purpose
Capture the launch-safe verification focus for reminders, verified inputs, shortcuts, widget/live-activity deep links, and entitlement refresh behavior.

## Why it exists
This bundle crosses local-first client state, backend authority, OS permissions, and monetization continuity. QA needs one canonical checklist so trust-breaking regressions are caught before launch.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/game-systems/GS-verified-inputs-notifications-automation-pack.md`
- `docs/specs/ios/IOS-verified-inputs-notifications-automation-pack.md`
- `docs/specs/backend/BE-verified-inputs-notifications-automation-pack.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`

## Automated focus
- Backend e2e: verified completion apply path, duplicate suppression, notification plan generation, subscription refresh, and StoreKit notification handling.
- iOS unit/navigation tests: HealthKit import flow, manual-plus-verified completion coexistence, notification deep-link routing, and shortcut-triggered completion wiring.
- Repo-wide validation still requires typecheck, tests, analytics validation, dataset validation, project generation, and simulator tests.

## Manual focus
- Notification education appears only after setup and after value has been shown.
- Denied notifications or denied HealthKit permission leave the Today loop fully usable.
- Verified badges feel informative rather than mandatory, and manual logging remains visibly available.
- Widget, Live Activity, notification, and shortcut returns all land on the correct surface without confusing tab/state jumps.

## Output / canonical artifact
- This QA pack
- Closeout evidence pack in `docs/foundation/VERIFIED_INPUTS_NOTIFICATIONS_AUTOMATION_CLOSEOUT_EVIDENCE_PACK.md`

## Explicit non-goals
- signed TestFlight proof
- live App Store sandbox purchase validation
- broad device-matrix performance sweep
