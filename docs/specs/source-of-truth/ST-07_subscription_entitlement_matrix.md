# ST-07 — Subscription Entitlement Matrix

## Purpose
Define exactly what free, trial, and paid users can access in v1.

## Why it exists
Monetization ambiguity creates product drift, accidental premium leakage, and broken expectations across iOS, backend, and QA. This section locks the canonical entitlement boundaries for launch.

## Inputs and dependencies
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/04_Game_Economy_Spec.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`

## Scope
This section defines:
- free tier access
- trial behavior
- premium monthly and annual access
- restore, grace-period, and continuity behavior

## Non-goals
- pricing copy
- App Store merchandising assets
- lifetime purchase support

## Canonical access tiers
- `free`
- `trial`
- `premium_monthly`
- `premium_annual`

## Entitlement rules
### Free
- active vow cap: `3`
- selectable identity access: one chosen launch identity at a time
- story access: full 7-day starter arc and limited Chapter One
- witness surfaces: basic widget only
- logging: manual logging only
- stats/history: basic progress stats only
- world breadth: basic world state and starter reward/cosmetic breadth

### Trial
- same access as premium while active
- expires automatically into free unless converted

### Premium monthly and annual
- active vow cap: `7`
- identity access: all ten launch identities and deeper customization
- story access: full Chapter One
- witness surfaces: advanced widgets and Live Activities
- integrations: HealthKit verification
- stats/history: deeper insights and progression history
- breadth: expanded housing, inventory, and cosmetic options

## Premium boundaries
Premium can expand breadth and expression. Premium cannot:
- auto-complete vows
- buy Chains
- buy permanent progression superiority outside the behavior loop
- bypass daily completion requirements

## Continuity rules
- entitlements belong to the canonical user account and persist through guest-to-account linking
- restore purchase rehydrates `SubscriptionState`; it does not recreate local progress
- during StoreKit billing grace period, premium access remains available while billing is in retry
- when grace or retry ends without recovery, access drops to free for future breadth-only gates while historical progress remains intact

## Edge cases
- guest user starts a trial, then links an account: trial continuity must survive the link
- entitlement downgrade cannot invalidate already-earned rewards or cosmetics
- locked premium-only vow breadth prevents creating extra active vows, but already completed historical data remains visible

## Versioning notes
- matrix version is `v1`
- new premium breadth can be added only if it does not violate locked v1 scope

## Examples
- machine-readable matrix: `shared/contracts/entitlements/entitlement-matrix.v1.json`

## Acceptance criteria
- every launch access question has a canonical answer
- free, trial, and premium monthly/annual behavior are aligned
- the premium boundary preserves the core behavior loop
- restore and downgrade behavior are explicit enough for iOS, backend, and QA
