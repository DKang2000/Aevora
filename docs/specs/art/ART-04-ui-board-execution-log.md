# ART-04 — UI Board Execution Log

## Purpose

Record the concrete execution step that turned the approved `ART-04` component-kit spec into deterministic board exports under `assets/art/ui-kit/`.

## Why this exists

`ART-04` was intentionally written as a canonical component definition first. This log captures the first repo-native export pass so downstream art execution stays reproducible and traceable to the token system instead of drifting into one-off board files.

## Inputs / dependencies

- `AGENTS.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/art/ART-01-visual-target-sheets-pack.md`
- `docs/specs/art/ART-01-visual-target-sheets-prompt-log.md`
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`
- `shared/tokens/aevora-v1-design-tokens.json`
- `docs/specs/art/ART-04-ui-component-art-kit.md`
- `docs/specs/art/ART-04-ui-component-prompt-pack.md`
- `ios/Aevora/Features/Today/TodayRootView.swift`
- `ios/Aevora/Features/World/WorldRootView.swift`
- `ios/Aevora/Features/Hearth/HearthRootView.swift`
- `ops/assets/art/generate_art_04_ui_kit.py`

## Output / canonical artifact

- Renderer:
  - `ops/assets/art/generate_art_04_ui_kit.py`
- Exported boards:
  - `assets/art/ui-kit/ART-04-01_core-chrome-board.png`
  - `assets/art/ui-kit/ART-04-02_today-components-board.png`
  - `assets/art/ui-kit/ART-04-03_modal-sheet-board.png`
  - `assets/art/ui-kit/ART-04-04_world-npc-shop-board.png`
  - `assets/art/ui-kit/ART-04-05_hearth-inventory-board.png`
  - `assets/art/ui-kit/ART-04-06_tab-icons-board.png`
  - `assets/art/ui-kit/ART-04-07_today-polished-pass.png`

## Renderer strategy

- External image generation was not required.
- The board set follows the same repo-native execution strategy proven in `ART-01`:
  - deterministic PIL rendering
  - manual text, spacing, and hierarchy
  - token-driven fills, gradients, and component chrome
- The renderer pulls actual style values from `shared/tokens/aevora-v1-design-tokens.json`.

## Invocation

From the repo root:

```bash
python3 ops/assets/art/generate_art_04_ui_kit.py
```

## Board coverage

- `ART-04-01_core-chrome-board.png`
  - headline cluster variants
  - button family
  - bottom-sheet shells
  - representative token callouts
- `ART-04-02_today-components-board.png`
  - chapter card states
  - reminder strip states
  - return-surface variants
  - vow-card states
  - stat row
  - district CTA row
- `ART-04-03_modal-sheet-board.png`
  - reward modal states
  - quest journal sheet
  - progress sheet
  - soft paywall preview
- `ART-04-04_world-npc-shop-board.png`
  - district card states
  - promenade or witness card
  - NPC dialogue panel
  - shop states
- `ART-04-05_hearth-inventory-board.png`
  - hearth summary panel
  - stored, applied, and locked item cards
  - premium empty-state panel
- `ART-04-06_tab-icons-board.png`
  - Today
  - World
  - Hearth
  - Inventory
  - Profile
  - primary silhouettes
  - refined variants
  - small-size read test
- `ART-04-07_today-polished-pass.png`
  - complete Today composition
  - embedded close-up zone for chapter-card fidelity
  - embedded close-up zone for vow-card and completion-button fidelity

## QA checklist

- Script runs cleanly from the repo root: **passed**
- Output directory is stable and reproducible: **passed**
- All seven required PNGs are created: **passed**
- All exported boards are portrait and `1536x2732`: **passed**
- No component on any board overlaps labels or crops important content: **passed**
- Token names used in labels or callouts match the JSON exactly: **passed**
- No machine-specific paths appear in docs, scripts, or labels: **passed**
- The polished Today pass is obviously derived from the approved `ART-01` direction: **passed**

## Token gaps or naming conflicts found

- No new token gaps were discovered during the board export pass.
- No new palette family was added.
- The existing canonical token names were sufficient for the board set.

## Edge cases checked

- Long-form Today card copy remained subordinate to the vow list.
- The success-state vow treatment stayed calm rather than neon.
- NPC dialogue and shop surfaces read as related but not identical.
- Empty Hearth and Inventory states remained warm instead of placeholder-cold.
- World support cards stayed secondary to the world-facing language.

## Explicit non-goals

- Swift token-consumption implementation in the app
- sprite production
- environment tilesets
- NPC bust or sprite generation
- animation or FX work
- rewriting product copy or UX flow structure
