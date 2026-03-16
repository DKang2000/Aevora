# ST-09 — Error / Empty / Offline State Catalog

## Purpose
Define the canonical failure, empty, loading, degraded, and offline states for the launch product.

## Why it exists
Humane recovery behavior is part of the product promise. This catalog keeps onboarding, Today, world, subscription, and settings flows from handling absence or failure in contradictory ways.

## Inputs and dependencies
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/01_Product_Thesis.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`

## Scope
This section defines:
- state IDs and triggers
- user-facing intent and recovery actions
- blocking versus non-blocking behavior
- humane tone rules for recovery states

## Non-goals
- final screen layout
- complete localized copy

## Tone rules
- never shame the user for missed days
- never frame sync issues as personal failure
- use plain English first and optional mythic flavor second
- recovery actions should always feel actionable and calm

## State families
### Onboarding and auth
- network unavailable during onboarding
- Apple sign-in failed
- guest-link conflict

### Today and vow logging
- no active vows configured
- completion queued offline
- completion reconciliation conflict
- active-vow cap reached

### World and rewards
- world state loading
- world state degraded from cache
- reward grant pending reconciliation

### Monetization and permissions
- paywall data unavailable
- purchase restore failed
- notification permission denied
- HealthKit permission denied

### Settings and account
- delete account export pending
- account unlink unsupported in current state

## Required state fields
- `stateId`
- `surface`
- `category`
- `severity`
- `blocking`
- `trigger`
- `messageKey`
- `recoveryActionKey`
- `analyticsEvent`

## Edge cases
- a user can still log manually while offline or while HealthKit is denied
- premium downgrade can lock breadth but cannot invalidate historical rewards
- if cached world state exists, prefer degraded cached rendering over a blank failure screen

## Versioning notes
- state catalog version is `v1`
- new states can be added additively
- reusing a state ID for a different meaning is a breaking change

## Examples
- machine-readable state catalog: `shared/contracts/ui-states/state-catalog.v1.json`

## Acceptance criteria
- every critical v1 surface has a defined recovery or empty-state path
- blocking versus non-blocking behavior is explicit
- the catalog preserves the anti-shame product tone
- iOS, backend, copy, and QA can all refer to the same state IDs
