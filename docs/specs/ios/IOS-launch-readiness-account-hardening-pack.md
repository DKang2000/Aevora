# IOS Launch Readiness Account Hardening Pack

## Purpose
Harden the existing Profile/account surface so launch testers have a clearer export/delete path without breaking the app’s local-first and offline-capable posture.

## Why it exists
The monetization/account bundle already introduced restore, downgrade, export preview, and local delete state. Launch readiness needs the account surface to be safer and clearer: export should be visible before delete, delete should be explicitly confirmed, and support guidance should point to the backend export/delete lifecycle instead of treating the local reset as the full compliance story.

## Inputs / dependencies
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`
- `docs/specs/ios/IOS-monetization-account-glance-pack.md`
- `docs/specs/backend/BE-launch-readiness-publishing-compliance-pack.md`

## Output / canonical artifact
- `ios/Aevora/Features/Account/AccountSurfaceStore.swift`
- `ios/Aevora/Features/Profile/ProfileRootView.swift`
- `ios/AevoraTests/Account/AccountSurfaceStoreTests.swift`

## Hardening changes
- Export preview now records when it was prepared so the user sees that the snapshot exists before deleting.
- Delete becomes a reviewed confirmation flow in the Profile screen instead of a one-tap destructive action.
- Account copy now distinguishes:
  - local device reset
  - backend/support export path
  - linked/subscribed deletion follow-up expectations

## Edge cases
- A user can still clear local state while offline.
- The export preview remains local-first and summary-only; it does not imply backend export delivery from the client.
- Delete confirmation resets after the destructive action completes or the user cancels.

## Acceptance criteria
- The account screen exposes export, delete review, and support guidance clearly.
- Delete is no longer a one-tap destructive action.
- Existing local-first reset behavior stays intact.
- Unit coverage exists for delete-flow state and export preparation state.

## Explicit non-goals
- full authenticated backend account-deletion networking from the client
- support ticket submission UI
- App Store receipt or account-linking architecture changes beyond the existing bundle
