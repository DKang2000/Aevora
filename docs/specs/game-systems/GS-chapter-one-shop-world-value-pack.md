# GS Chapter One Shop World Value Pack

## Purpose
Define the launch-safe Chapter One shell, district restoration extension, item/shop rules, and reward audit rules that turn Gold and world progress into a meaningful ongoing loop after the 7-day starter arc.

## Why it exists
The starter arc proves the first magical moment, but the product promise also requires a believable continuation where the city stays reactive, rewards remain useful, and premium breadth has visible value without replacing the free path.

## Inputs / dependencies
- `AGENTS.md`
- `docs/product/04_Game_Economy_Spec.md`
- `docs/product/05_Narrative_Content_Launch_Spec.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`

## Sections
### GS-14 — 30-day Chapter One logic
- Chapter One begins immediately after Day 7 resolves `The Ember That Returned`.
- The launch shell is one 30-day arc expressed as five six-day milestones.
- Premium and trial receive the full 30-day path.
- Free users receive a coherent seven-day Chapter One preview, then hold at `preview_capped` without losing rewards already earned.

### GS-15 — Problem template rules
- Launch keeps one reusable civic-repair template: visible rhythm loss followed by public trust repair.
- The starter arc uses `starter_oven_crisis`.
- Chapter One uses `market_memory_crisis`.
- Problem state is always surfaced in plain-language utility terms on Today, World, Quest Journal, and Hearth.

### GS-16 — District restoration state machine
- Ember Quay continues beyond `rekindled` into `market_waking`, `market_mended`, `lantern_garden`, and `festival_ready`.
- The district stage is driven from chapter milestone state, not ad hoc scene booleans.
- Free preview users stop progressing the district after the preview cap unless they upgrade.

### GS-18 — Inventory item types + rarity rules
- Launch buckets remain `reward_token`, `prop`, `cosmetic`, and `chapter_reward`.
- Launch rarity remains `common`, `uncommon`, and `rare`.
- Items may be `stored` or `applied`; applied props/cosmetics surface in Hearth.
- Item slots are `display`, `attire`, or `keepsake`.

### GS-19 — Shop offer rules
- Shop offers are curated, small, and content-driven.
- Offers declare `vendorNpcId`, `stockLimit`, `chapterGate`, `entitlementGate`, and `repeatable`.
- Gold spend is only valid when the user has sufficient balance, remaining stock, and the gate is satisfied.
- Launch shop breadth stays narrow: one free-path curated set plus one premium-visible cosmetic.

### GS-20 — Reward grant audit rules
- Completion rewards, chapter milestone items, and shop purchases all write an auditable ledger entry.
- Shop purchases reduce current Gold balance and produce an owned inventory item in the same canonical write.
- Chapter milestone rewards remain earned through behavior; premium never buys progression superiority.

## Output / canonical artifact
- This systems pack
- Updated launch content and shared fixture payloads
- Extended chapter, district, inventory, and shop behavior in backend and iOS

## Edge cases
- Free preview users keep already-earned Chapter One items after downgrade or lapse.
- Duplicate shop purchases are blocked for non-repeatable offers.
- Offline-capable clients may queue purchase intent, but the authoritative buy still resolves through the canonical shop purchase route.

## Explicit non-goals
- post-launch chapters
- combat-tree expansion
- final art or asset-pipeline generation
