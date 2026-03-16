# UX Chapter One Shop World Value Pack

## Purpose
Define how World, Hearth, Inventory, Shop, and dialogue surfaces expose Chapter One and the value loop while preserving the faster Today logging path.

## Why it exists
The next bundle adds value depth, but the product rule still stands: logging must stay faster than navigation. This pack keeps the new surfaces supportive and clear instead of turning them into friction.

## Inputs / dependencies
- `AGENTS.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/04_Game_Economy_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`
- `docs/specs/source-of-truth/ST-10_string_key_registry_copy_token_structure.md`

## Sections
### UX-16 — NPC dialogue interaction spec
- NPC interaction stays lightweight: move the avatar between small witness anchors, then open a dialogue sheet.
- Dialogue panels must always show a next useful action.
- If dialogue context is unavailable, use the `world.npc_dialogue_unavailable` state.

### UX-18 — Inventory spec
- Inventory lives in Hearth, not a separate tab.
- Default split: stored items versus applied items.
- Apply/remove is one tap and reflects immediately in Hearth.
- Empty state uses `hearth.inventory_empty`.

### UX-19 — Shop spec
- Shop opens as a focused sheet from World.
- Offers show item purpose, vendor, price, ownership/lock state, and affordability.
- Shop remains curated and short; no scrolling catalog wall.
- Offline purchase failure references `shop.offline` or `shop.purchase_failed`.

### Narrow consistency patches
- Today chapter card can display Chapter One preview/full notes.
- Quest Journal shows starter arc history plus Chapter One milestone ranges.
- World scene includes a compact promenade control rather than open-world navigation.
- Hearth explicitly reflects only applied items, not every owned item.

## Output / canonical artifact
- This UX pack
- iOS implementations under `ios/Aevora/Features`

## Edge cases
- Free preview gating must remain coherent without feeling like a dead end.
- Premium-visible offers can appear locked, but the free path still has spendable value.
- VoiceOver labels and touch targets remain required on promenade, dialogue, and shop controls.

## Explicit non-goals
- final art polish
- fifth navigation tab
- spreadsheet-style inventory management
