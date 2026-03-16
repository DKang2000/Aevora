# ST-01 — Canonical Domain Model

## Purpose
Define the locked v1 object model so iOS, backend, content, analytics, and QA use the same canonical entities, identifiers, and state boundaries.

## Why it exists
Aevora fails if vows, progression, districts, subscriptions, and analytics all name or shape the same concepts differently. This spec locks the shared nouns before transport, storage, UI states, or fixtures are built.

## Inputs and dependencies
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/04_SECTION_CONTEXT_INDEX.md`
- `docs/product/01_Product_Thesis.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/04_Game_Economy_Spec.md`
- `docs/product/05_Narrative_Content_Launch_Spec.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/world/WORLD_BIBLE_PRINCIPLES_SUMMARY.md`

## Scope
This section defines:
- the locked v1 entities and relationships
- identifier, ownership, and lifecycle rules
- current-state versus event-history boundaries
- the split between system nouns and lore-flavored labels

## Non-goals
- database tables
- SwiftData models
- endpoint design
- out-of-scope social or multiplayer objects

## Canonical system nouns
Use these nouns in contracts and persistence unless a later source-of-truth contract narrows them further:
- `User`
- `Profile`
- `Avatar`
- `OriginFamily`
- `IdentityShell`
- `Vow`
- `VowSchedule`
- `VowCompletionEvent`
- `RewardGrant`
- `LevelState`
- `ChainState`
- `EmberState`
- `ChapterState`
- `QuestState`
- `DistrictState`
- `InventoryItem`
- `ShopOffer`
- `NotificationPreference`
- `SourceConnection`
- `SubscriptionState`
- `ExperimentAssignment`

## User-facing label rule
- System contracts use clear nouns like `Vow`, `RewardGrant`, and `SubscriptionState`.
- User-facing copy may layer lore such as Chains, Embers, Resonance, or Hearth.
- Lore terms must not replace contract nouns where ambiguity would hurt implementation.

## Entity catalog
### User
- owner of all player state
- one current auth mode: `guest` or `registered`
- one current `SubscriptionState`
- one current `Profile`

### Profile
- user identity choices and utility preferences
- stores selected `IdentityShell`, tone mode, timezone, and onboarding state
- owns zero or more `ExperimentAssignment` objects

### Avatar
- cosmetic representation of the user
- stores appearance choices only, not progression rules

### OriginFamily
- mechanical family bucket: `dawnbound`, `archivist`, `hearthkeeper`, `chartermaker`
- used to group identities and flavor bonuses

### IdentityShell
- flavor-first wrapper for player identity
- exactly ten launch identities:
  - Dawnbound: `knight`, `paladin`, `ranger`
  - Archivist: `mage`, `scholar`
  - Hearthkeeper: `farmer`, `baker`, `cafe_keeper`
  - Chartermaker: `merchant`, `charterlord`
- changes presentation and flavor, not the core progression engine

### Vow
- the canonical recurring habit/goal definition
- type is one of `binary`, `count`, `duration`
- lifecycle: `draft` -> `active` -> `archived`
- active-vow cap is enforced by `SubscriptionState`, not hard-coded in the client object

### VowSchedule
- recurrence and reminder metadata for a `Vow`
- stores local-time behavior and reminder preference

### VowCompletionEvent
- immutable event representing manual or verified progress against one vow on one local day
- source is one of `manual`, `healthkit`
- may represent `partial` or `complete` progress

### RewardGrant
- immutable server-authoritative reward outcome
- references the event or action that caused it
- can grant Resonance, Gold, Embers delta, world progression, item awards, or cosmetic unlocks

### LevelState
- current rank and progression totals
- tracks current rank, current-rank progress, and lifetime Resonance

### ChainState
- streak-like continuity for a vow
- stores current length, best length, cooled status, and last qualified completion day

### EmberState
- recovery buffer for missed days
- stores available Embers, heat, and most recent rekindling/cooling markers

### ChapterState
- player progress through the 7-day starter arc and Chapter One shell
- one current active chapter at a time

### QuestState
- state for daily, weekly, or chapter tasks
- references content-defined quest templates

### DistrictState
- state of the launch district restoration arc
- stores restoration stage, current problem template, and visibility markers for the world scene

### InventoryItem
- an owned item instance or stack
- category examples: cosmetic, prop, reward token

### ShopOffer
- a purchasable offer defined by content and gated by entitlements, progression, or feature flags

### NotificationPreference
- reminder and system-notification settings at the user level

### SourceConnection
- capability link to an external source such as HealthKit
- stores authorization state, supported domains, and last sync metadata

### SubscriptionState
- the single canonical record of the player’s entitlement state
- launch access tiers: `free`, `trial`, `premium_monthly`, `premium_annual`
- may expose transient billing states such as `grace_period` and `billing_retry`

### ExperimentAssignment
- user assignment to a named experiment bucket
- influences presentation and tuning only; never bypasses locked entitlement or behavior rules

## Relationship model
- `User` 1:1 `Profile`
- `User` 1:1 `Avatar`
- `User` 1:1 `SubscriptionState`
- `User` 1:many `Vow`
- `Vow` 1:1 `VowSchedule`
- `Vow` 1:many `VowCompletionEvent`
- `User` 1:many `RewardGrant`
- `User` 1:many `InventoryItem`
- `User` 1:many `QuestState`
- `User` 1:many `ChapterState`
- `User` 1:many `ExperimentAssignment`
- `User` 1:many `SourceConnection`
- `Profile` 1:1 selected `IdentityShell`
- `IdentityShell` many:1 `OriginFamily`

## Identifier strategy
- All canonical IDs are stable strings, not user-facing names.
- Recommended prefixes:
  - `usr_`
  - `pro_`
  - `ava_`
  - `fam_`
  - `idn_`
  - `vow_`
  - `vce_`
  - `rwd_`
  - `chp_`
  - `qst_`
  - `dst_`
  - `itm_`
  - `sho_`
  - `sub_`
  - `exp_`
- Content definition IDs are globally stable across clients and backend.
- User-generated object IDs must be collision-safe offline.

## Ownership and authority boundaries
- Client is local-first for `Vow` edits and completion intent.
- Server is authoritative for:
  - `RewardGrant`
  - `SubscriptionState`
  - anti-cheat-sensitive progression outcomes
  - remote config and feature-gated behavior
- Content definitions live outside player state.
- Entitlement rules do not live as arbitrary booleans on `Profile` or `Vow`.

## Lifecycle and state boundaries
- `Vow`, `Profile`, and `Avatar` are current-state objects.
- `VowCompletionEvent` and `RewardGrant` are immutable event objects.
- `LevelState`, `ChainState`, `EmberState`, `ChapterState`, and `DistrictState` are derived current-state snapshots that can be recomputed from events plus content rules.
- `SourceConnection` stores authorization and sync metadata, not imported raw HealthKit payloads.

## Invariants
- One user has exactly one current `SubscriptionState`.
- One profile has at most one selected identity shell at a time.
- Active-vow limits come from entitlements: free cap `3`, premium cap `7`.
- Logging writes locally first; sync and reward resolution can happen later.
- Manual logging is always valid in v1; verified logging is additive.
- Reward authority belongs to the server, even when the client previews likely outcomes.
- Premium cannot auto-complete vows, buy Chains, or bypass the behavior loop.
- District and chapter content are limited to the Cyrane / Dawnmarch launch footprint in v1.

## Edge cases
- Guest user upgrades to registered account: preserve all user-owned state under the same canonical user identity where possible.
- Archived vow with historical completions: keep events and rewards; do not destroy history.
- Multiple same-day progress updates: store as separate events or a resolved operation sequence, but expose one canonical day-level result per vow for UX.
- Offline completion followed by entitlement downgrade: completion remains valid; premium-only breadth changes affect future access, not historical facts.

## Versioning notes
- This domain model is versioned as `v1`.
- Additive fields are preferred over renames.
- Renaming an entity requires updates to every dependent source-of-truth section in the same change set.

## Examples
Supporting examples live in `shared/contracts/domain-model/examples/`:
- new user
- configured vow
- completion event
- reward grant
- chapter state snapshot
- subscription state snapshot

## Acceptance criteria
- Every locked v1 system object maps to one canonical noun here.
- Relationships are clear enough for API, local storage, analytics, and content contracts to build without guessing.
- System nouns stay plain-language even when user-facing copy uses lore.
- No out-of-scope social or multiplayer objects are introduced.
