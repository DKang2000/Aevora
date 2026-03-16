# IOS Chapter One Shop World Value Pack

## Purpose
Implement the iPhone client surfaces that make Chapter One, NPC witness interaction, inventory application, and curated shopping feel real while keeping Today as the fastest action path.

## Why it exists
The local-first client already carries onboarding and the starter arc. This pack extends the same snapshot pattern into the next value loop without introducing a new root, a new persistence model, or open-world sprawl.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/ux/UX-chapter-one-shop-world-value-pack.md`
- `docs/specs/game-systems/GS-chapter-one-shop-world-value-pack.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`

## Sections
### IOS-16 — Avatar movement + NPC interaction system
- World adds three compact promenade anchors inside the existing district scene.
- Avatar position is lightweight, placeholder-safe, and separate from logging.
- NPC interaction opens a sheet with dialogue plus a next-action summary.

### IOS-18 — Inventory implementation
- Inventory remains in Hearth and splits stored versus applied items.
- Applying an item immediately changes Hearth-visible props.

### IOS-19 — Shop implementation
- World opens a curated market sheet with affordability, vendor, and lock-state feedback.
- Purchases update local-first state immediately and queue canonical sync intent.

### Narrow hardening
- Today chapter card supports Chapter One notes and ongoing Gold visibility.
- Quest Journal shows starter arc history plus Chapter One milestones.
- World scene reflects district phases and the avatar anchor.

## Output / canonical artifact
- This iOS pack
- Updated features under `ios/Aevora/Features`
- Unit-test coverage in `ios/AevoraTests`

## Edge cases
- Existing snapshots from the starter-arc bundle decode forward safely.
- Free preview users still receive coherent Chapter One witness copy.
- Reduced-motion users keep clarity without needing scene movement.

## Explicit non-goals
- final art generation
- HealthKit
- App Intents
- speculative open-world traversal
