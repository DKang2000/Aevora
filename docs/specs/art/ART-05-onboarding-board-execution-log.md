# ART-05 — Onboarding Board Execution Log

## Purpose

Record the deterministic execution step that turned the approved `ART-05` onboarding art spec into repo-native board exports under `assets/art/onboarding-kit/`.

## Why this exists

`ART-05` is written as a canonical visual target first. This log makes the export pass reproducible, traceable to the token system, and safe for later onboarding polish work without drifting into one-off mockups.

## Inputs / dependencies

- `AGENTS.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/05_Narrative_Content_Launch_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/ux/UX-first-playable-core-loop-pack.md`
- `docs/specs/art/ART-01-visual-target-sheets-pack.md`
- `docs/specs/art/ART-01-visual-target-sheets-prompt-log.md`
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`
- `docs/specs/art/ART-04-ui-component-art-kit.md`
- `docs/specs/art/ART-04-ui-component-prompt-pack.md`
- `docs/specs/art/ART-05-onboarding-illustration-card-set.md`
- `docs/specs/art/ART-05-onboarding-prompt-pack.md`
- `shared/tokens/aevora-v1-design-tokens.json`
- `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`
- `ios/Aevora/Features/Rewards/RewardModalView.swift`
- `ios/Aevora/Features/Quest/QuestJournalSheet.swift`
- `ops/assets/art/generate_art_05_onboarding_kit.py`

## Output / canonical artifact

- Renderer:
  - `ops/assets/art/generate_art_05_onboarding_kit.py`
- Exported boards:
  - `assets/art/onboarding-kit/ART-05-01_promise-cards-board.png`
  - `assets/art/onboarding-kit/ART-05-02_problem-solution-carousel-board.png`
  - `assets/art/onboarding-kit/ART-05-03_goals-tone-utility-board.png`
  - `assets/art/onboarding-kit/ART-05-04_family-selection-board.png`
  - `assets/art/onboarding-kit/ART-05-05_identity-selection-board.png`
  - `assets/art/onboarding-kit/ART-05-06_starter-vow-and-quest-preview-board.png`
  - `assets/art/onboarding-kit/ART-05-07_first-magical-moment-and-soft-paywall-board.png`

## Renderer strategy

- External image generation was not required.
- The board set follows the repo-native export strategy already proven in `ART-01` and `ART-04`:
  - deterministic PIL rendering
  - manual text, spacing, and hierarchy
  - token-driven fills, gradients, and chrome
- The renderer reads style values from `shared/tokens/aevora-v1-design-tokens.json`.

## Invocation

From the repo root:

```bash
python3 ops/assets/art/generate_art_05_onboarding_kit.py
```

## Board coverage

- `ART-05-01_promise-cards-board.png`
  - hero promise card
  - reassurance cards
  - continue treatment
- `ART-05-02_problem-solution-carousel-board.png`
  - three problem/solution carousel cards
  - small scene and icon accents
- `ART-05-03_goals-tone-utility-board.png`
  - multi-select answer grid
  - blocker single-choice state
  - daily-load segmented state
  - footer CTA row
- `ART-05-04_family-selection-board.png`
  - four family cards
  - silhouette and prop accents
  - selected-state treatment
- `ART-05-05_identity-selection-board.png`
  - mixed-family identity cards
  - selected state
  - premium-ready but ungated supporting card
- `ART-05-06_starter-vow-and-quest-preview-board.png`
  - starter vow stack
  - replace/edit affordances
  - quest teaser and minimum-viable-consistency cue
- `ART-05-07_first-magical-moment-and-soft-paywall-board.png`
  - first magical moment frame
  - reward/witness summary
  - soft paywall preserving the free path

## QA checklist

- Script runs cleanly from the repo root: **passed**
- Output directory is stable and reproducible: **passed**
- All seven required PNGs are created: **passed**
- All exported boards are portrait and `1536x2732`: **passed**
- No labels overlap component bodies: **passed on spot-check review**
- No machine-specific paths appear in docs, scripts, or labels: **passed by inspection**
- The magical moment board shows world consequence before premium framing: **passed by composition**

## Token gaps or naming conflicts found

- No new token gaps were identified during spec and renderer authoring.
- No new palette family was introduced.
- Existing `ART-03` gradients, surfaces, text roles, border roles, and radii were sufficient for this board set.

## Edge cases checked

- Promise and reassurance cards keep utility clarity ahead of ornament.
- Family and identity boards prioritize silhouette and prop language over tiny detail.
- The starter-vow board keeps quest framing secondary to believable vow setup.
- The first magical moment board preserves a clear free-path action in the offer area.

## Explicit non-goals

- Swift onboarding implementation changes beyond token alignment
- animated magical-moment assets
- avatar or NPC production art
- pricing or entitlement changes
