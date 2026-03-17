# ART-05A — Selection Board Refinement Log

## Purpose

Record the focused refinement pass that strengthened the family and identity selection boards inside the existing `ART-05` onboarding pack.

## Why this exists

The original `ART-05` export established layout and sequencing well, but the selection boards were still too text-dependent. This log captures the renderer changes that made silhouette, prop, and material cues carry more of the selection language.

## Inputs / dependencies

- `AGENTS.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/art/ART-05-onboarding-illustration-card-set.md`
- `docs/specs/art/ART-05-selection-board-refinement-addendum.md`
- `shared/tokens/aevora-v1-design-tokens.json`
- `ops/assets/art/generate_art_05_onboarding_kit.py`

## Output / canonical artifact

- Updated renderer:
  - `ops/assets/art/generate_art_05_onboarding_kit.py`
- Updated boards:
  - `assets/art/onboarding-kit/ART-05-04_family-selection-board.png`
  - `assets/art/onboarding-kit/ART-05-05_identity-selection-board.png`

## Renderer strategy

- Keep the existing deterministic PIL export pipeline and the established `ART-05` board framing.
- Replace generic survey-card ornament with compact visual fragments that do more identity work:
  - silhouette mass
  - prop cue
  - material inset or accent strip
- Preserve warm, premium-native card treatment and obvious selected-state clarity without adding neon glow or poster-like illustration density.

## What changed

### Family board

- Added a dedicated visual package to each family card:
  - silhouette fragment
  - prop fragment
  - material inset or accent strip
- Strengthened selected-state treatment with clearer border focus and selected chip placement.
- Reduced dependence on descriptive copy for distinctiveness.

### Identity board

- Gave each showcased identity a more specific silhouette and prop package.
- Increased outer-shape variation card-to-card.
- Preserved an obvious selected state without turning cards into class posters.
- Kept the premium-ready breadth note secondary to the free-path choice.

## Validation

- `python3 -m py_compile ops/assets/art/generate_art_05_onboarding_kit.py`
- `python3 ops/assets/art/generate_art_05_onboarding_kit.py`
- spot-check review of updated `ART-05-04` and `ART-05-05` exports

## Validation results

- Renderer compiles cleanly after the selection-card refactor: **passed**
- Updated family board now differentiates `Dawnbound`, `Archivist`, `Hearthkeeper`, and `Chartermaker` through shape, prop, and material cues rather than accent color alone: **passed by inspection**
- Updated identity board now gives `Knight`, `Scholar`, `Baker`, and `Merchant` more distinct shell language while keeping the free-path choice clear: **passed by inspection**
- Selection state remains obvious and iPhone-native on both boards: **passed by inspection**

## Non-goals

- rerendering unrelated onboarding boards for stylistic experimentation
- adding full illustrated character art
- changing onboarding flow structure or entitlement framing
