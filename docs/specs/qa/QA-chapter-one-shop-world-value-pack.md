# QA Chapter One Shop World Value Pack

## Purpose
Capture the automated and manual verification focus for Chapter One handoff, district restoration readability, shop spend correctness, inventory application, and narrative consistency.

## Why it exists
This bundle spans contracts, backend state, local-first client state, and visible narrative/UI output. QA needs one canonical checklist so regressions are caught in the same frame as the feature work.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/game-systems/GS-chapter-one-shop-world-value-pack.md`
- `docs/specs/ios/IOS-chapter-one-shop-world-value-pack.md`
- `docs/specs/backend/BE-chapter-one-shop-world-value-pack.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`

## Automated focus
- Backend e2e: starter-arc to Chapter One preview transition, shop-offer read, shop purchase, inventory durability.
- iOS unit tests: Chapter One preview state, shop purchase spend, inventory apply/remove reflection in Hearth.
- Existing repo-wide typecheck/test flows remain required.

## Manual focus
- World promenade remains optional and readable in portrait.
- Dialogue panels clarify the next useful action.
- Locked premium shop breadth does not block the free path.
- Hearth shows a strong empty state before items are applied.
- Copy stays consistent across Today, World, Quest Journal, Hearth, and shop.

## Output / canonical artifact
- This QA pack
- Closeout evidence pack in `docs/foundation/CHAPTER_ONE_SHOP_WORLD_VALUE_CLOSEOUT_EVIDENCE_PACK.md`

## Explicit non-goals
- App Store screenshot generation
- TestFlight signed proof
- HealthKit or notification delivery suites
