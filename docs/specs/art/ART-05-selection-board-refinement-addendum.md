# ART-05A — Family / Identity Selection Board Refinement Addendum

**Section ID:** `ART-05A`  
**Status:** Canonical refinement addendum  
**Canonical repo targets:**
- `docs/specs/art/ART-05-selection-board-refinement-addendum.md`
- `ops/assets/art/generate_art_05_onboarding_kit.py`
- `assets/art/onboarding-kit/ART-05-04_family-selection-board.png`
- `assets/art/onboarding-kit/ART-05-05_identity-selection-board.png`
- `docs/specs/art/ART-05-selection-board-refinement-log.md`

## Purpose

Tighten the weakest two boards in the current `ART-05` pack so family and identity selection language is visually specific at a glance, even when the supporting copy is skipped.

## Why this exists

The current onboarding board pack is strong on promise, carousel, utility surfaces, starter-vow framing, and magical-moment/paywall sequencing. The family and identity boards still read too much like well-styled survey cards. This addendum sharpens those two boards without reopening the rest of `ART-05`.

## Inputs / dependencies

- `AGENTS.md`
- `docs/AGENT_BRIEF_TEMPLATE.md`
- `docs/SOURCE_OF_TRUTH_INDEX.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/ux/UX-first-playable-core-loop-pack.md`
- `docs/specs/art/ART-01-visual-target-sheets-pack.md`
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`
- `docs/specs/art/ART-04-ui-component-art-kit.md`
- `docs/specs/art/ART-05-onboarding-illustration-card-set.md`
- `docs/specs/art/ART-05-onboarding-board-execution-log.md`
- `shared/tokens/aevora-v1-design-tokens.json`
- `ops/assets/art/generate_art_05_onboarding_kit.py`
- `assets/art/onboarding-kit/ART-05-04_family-selection-board.png`
- `assets/art/onboarding-kit/ART-05-05_identity-selection-board.png`

## Brief

Revise only the two selection boards so each card communicates a distinct role visually within one second.

### Family board requirements

Each of the four family cards must include:
- one silhouette or bust-shape fragment
- one prop cue
- one material/accent strip or inset
- one selected-state treatment that stays obvious without neon or gamey glow

Required family cues:
- `Dawnbound`: shield, tabard, standard, civic defense
- `Archivist`: satchel, scroll, lens, sigil, archive read
- `Hearthkeeper`: apron, peel, basket, steam, domestic craft
- `Chartermaker`: ledger, seal, coat, measured mercantile read

### Identity board requirements

Upgrade at least four mixed-family identity cards so they read like actual identity shells rather than generic option tiles.

Required identity cues:
- outer-shape changes differ card-to-card
- prop accents do visible work
- selected state remains obvious
- premium-ready breadth may be hinted, but the free-path choice remains fully available

### Renderer rules

- Keep the deterministic PIL pipeline.
- Keep `1536x2732` portrait exports.
- Keep repo-relative paths only.
- Do not introduce a second art language.
- Do not rely on copy alone to express distinction.
- Do not add dense full-character paintings; use compact readable fragments.

## Acceptance criteria

This addendum is complete when:
- `ART-05-04_family-selection-board.png` and `ART-05-05_identity-selection-board.png` are rerendered
- each family reads as distinct at a glance through shape + prop + material, not just accent color
- each identity card has a more specific silhouette/prop package than a generic survey card
- selection state remains obvious and iPhone-native
- the boards stay visually coherent with the rest of `ART-05`
- a short refinement log records what changed and why

## Explicit non-goals

- do not reopen the other five `ART-05` boards
- do not redesign onboarding flow logic here
- do not add avatar customization production art here
- do not turn selection cards into mini posters or MMO class cards
