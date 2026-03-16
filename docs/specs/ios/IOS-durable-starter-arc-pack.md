# IOS Durable Starter Arc Pack

## Purpose
Turn the first-playable iOS path into a durable local-first starter arc that survives relaunches and makes days 2–7 materially visible on Today, World, Hearth, and reward surfaces.

## Why it exists
The day-one slice proved onboarding and the first magical moment, but not the return loop. The app needs durable local state, chapter progression, reward destinations, and humane return cues so the user can come back tomorrow with continuity intact.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`
- `docs/specs/ios/IOS-first-playable-core-loop-pack.md`
- `docs/specs/ux/UX-first-playable-core-loop-pack.md`
- `docs/specs/game-systems/GS-first-playable-core-loop-pack.md`

## Sections
### IOS-09 / IOS-11 / IOS-12 hardening
- The first-playable store now persists a durable local starter-arc snapshot through SwiftData.
- Completion history, chain state, ember state, and starter-arc day count survive store rebuilds.

### IOS-14 / IOS-15
- Today shows chapter objective, return prompts, and richer vow history context.
- Quest Journal exposes past/current/upcoming day beats with tomorrow-facing prompts.
- World continues to witness district progression through the full 7-day arc.

### IOS-17 / minimal IOS-18
- Hearth now acts as the minimal reward destination for props and earned starter-arc keepsakes.
- Inventory items surfaced here are limited to reward outputs needed for the arc.

### IOS-21 / IOS-29
- The primary return loop exposes reminder and witness prompt surfaces in-app.
- Core screens remain VoiceOver-friendly, reduced-motion-safe, and portrait-first.

## Output / canonical artifact
- Durable starter-arc state and surfaces under `ios/Aevora/`
- Starter-arc persistence coverage in `ios/AevoraTests/CoreLoop/FirstPlayableStoreTests.swift`

## Edge cases
- Offline completion still updates local state immediately.
- Rekindling reduces Embers but preserves continuity.
- The app can rebuild store state from persisted local snapshot after relaunch.

## Explicit non-goals
- Full StoreKit paywall flow
- Widget or Live Activity surfaces
- Full shop/settings/profile expansion
