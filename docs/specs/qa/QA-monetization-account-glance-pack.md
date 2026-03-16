# QA Monetization, Account, and Glance Pack

## Purpose
Define the release-confidence slice for monetization continuity, Postgres-backed backend authority, and out-of-app return surfaces.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/backend/BE-monetization-account-glance-pack.md`
- `docs/specs/ios/IOS-monetization-account-glance-pack.md`
- `docs/specs/ux/UX-monetization-account-glance-pack.md`
- `docs/specs/data/DATA-07_subscription_conversion_reporting.md`
- `docs/specs/data/DATA-08_retention_and_return_surface_reporting.md`

## Sections
### QA-05 / QA-06 / QA-08
- Validate migrations plus runtime continuity against reachable Postgres.
- Validate trial start, purchase, restore, downgrade, and relaunch continuity.
- Validate guest-to-account link preservation after trial start.

### QA-10 / QA-11
- Validate free widget availability, premium widget gating, and Live Activity gating.
- Validate notification education timing, permission results, reminder scheduling, and re-entry handling.

### QA-14 / QA-15
- Validate analytics coverage for paywall exposure, subscription lifecycle, widget/live activity interactions, and reminder outcomes.
- Validate cold start, relaunch, and local-delete regressions against the starter-arc store.

## Output / canonical artifact
- This pack
- Backend and iOS automated coverage already landed in the repo

## Edge cases
- Restore can return `restored: false` without surfacing a broken state.
- Widget/install packaging must stay valid for simulator and device runs.
- Free-path dismissal of the paywall must not reset onboarding or progress.

## Explicit non-goals
- full App Store sandbox purchase testing
- release-manager signoff workflow
