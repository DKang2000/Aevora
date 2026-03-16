# ST-08 — Permission Matrix

## Purpose
Define when the app requests sensitive capabilities, why the user should grant them, and how the product behaves if they do not.

## Why it exists
Permission timing affects trust, activation, and platform compliance. This section keeps notifications, HealthKit, Apple identity, witness surfaces, and restore flows aligned with the utility-first product promise.

## Inputs and dependencies
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/product/07_Analytics_Event_Taxonomy.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`

## Scope
This section defines:
- capability requests and gating behavior
- trigger timing
- prerequisite user value
- fallback behavior on denial
- re-prompt strategy

## Non-goals
- App Store privacy-policy copy
- capabilities outside locked v1 scope

## Capability matrix
### Notifications
- request only after onboarding setup is complete and value is clear
- never request before the first setup is finished
- value proposition: reminders for chosen vows and timely witness moments
- denial fallback: reminders remain configurable in-app but disabled at the OS level

### HealthKit
- ask only in context for a relevant verified-input vow or settings/integrations flow
- never ask during the first minute of onboarding
- value proposition: optional verification for narrow supported domains
- denial fallback: manual logging remains fully available

### Sign in with Apple
- optional at initial setup because guest mode exists
- required context: user chooses to register, restore, or link
- fallback: remain in guest mode until the user opts in

### Purchase restore
- available from paywall and account/subscription settings
- no separate permission dialog, but it is a user-initiated capability flow

### Widgets and Live Activities
- no explicit OS permission prompt beyond platform install flows
- gate by entitlement and platform availability
- denial/unavailable fallback: Today screen remains the primary surface

### App Intents / Shortcuts
- expose only after core setup is complete
- fallback: user continues via the app UI

## Re-prompt strategy
- no nag loops
- re-education happens from relevant settings or context surfaces after value is demonstrated
- if the user denies a capability, record the state and offer a settings deep-link when appropriate

## Edge cases
- HealthKit denied after a verified vow is configured: keep the vow active and allow manual completions
- notifications denied after reminders were configured: preserve reminder preferences locally and surface OS-disabled state clearly
- entitlement downgrade disables advanced witness surfaces without re-requesting other permissions

## Versioning notes
- permission matrix version is `v1`
- timing and value rules must stay aligned with onboarding and settings UX specs

## Examples
- machine-readable matrix: `shared/contracts/permissions/permission-matrix.v1.json`

## Acceptance criteria
- every v1 capability with trust or platform implications has a canonical request policy
- notification and HealthKit timing rules match the locked onboarding constraints
- denial fallback never blocks the manual behavior loop
- the matrix is specific enough for implementation, copy, and QA
