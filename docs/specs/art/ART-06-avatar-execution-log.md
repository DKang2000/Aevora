# ART-06 — Avatar Execution Log

## Purpose

Record the deterministic execution step that turns the approved `ART-06` avatar base-system spec into repo-native board exports under `assets/art/avatar-kit/`.

## Why this exists

`ART-06` closes the visual gap between the current onboarding avatar draft and the next iOS surface pass. This log keeps the renderer reproducible, grounded in the existing token system, and explicit about any debt left for later avatar expansion work.

## Inputs / dependencies

- `AGENTS.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/art/ART-01-visual-target-sheets-pack.md`
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`
- `docs/specs/art/ART-04-ui-component-art-kit.md`
- `docs/specs/art/ART-05-onboarding-illustration-card-set.md`
- `docs/specs/art/ART-06-avatar-base-system.md`
- `docs/specs/art/ART-06-avatar-prompt-pack.md`
- `shared/tokens/aevora-v1-design-tokens.json`
- `content/launch/launch-content.min.v1.json`
- `ops/assets/art/generate_art_06_avatar_kit.py`

## Output / canonical artifact

- Renderer:
  - `ops/assets/art/generate_art_06_avatar_kit.py`
- Exported boards:
  - `assets/art/avatar-kit/ART-06-01_base-frame-silhouette-board.png`
  - `assets/art/avatar-kit/ART-06-02_head-hair-skin-anchor-board.png`
  - `assets/art/avatar-kit/ART-06-03_palette-material-application-board.png`
  - `assets/art/avatar-kit/ART-06-04_onboarding-avatar-preview-board.png`
  - `assets/art/avatar-kit/ART-06-05_hearth-avatar-preview-board.png`

## Renderer strategy

- External image generation was not required.
- The pass follows the repo-native export pattern already used for prior board packs:
  - deterministic Pillow rendering
  - token-driven surfaces, gradients, borders, and text colors
  - launch-content-backed silhouette and palette IDs
- The renderer preserves the existing avatar draft IDs by reading the launch content payload instead of inventing a new schema.

## Invocation

From the repo root:

```bash
python3 ops/assets/art/generate_art_06_avatar_kit.py
```

## Board coverage

- `ART-06-01_base-frame-silhouette-board.png`
  - four base body-frame silhouettes
  - neutral standing read
  - bust crops and label rows
- `ART-06-02_head-hair-skin-anchor-board.png`
  - starter skin-tone matrix
  - hair silhouette set
  - face readability proof
  - accessory anchor callout
- `ART-06-03_palette-material-application-board.png`
  - repeated silhouette across launch palettes
  - cloth / trim / neutral swatches
  - combination warning strip
- `ART-06-04_onboarding-avatar-preview-board.png`
  - one-screen avatar preview treatment
  - silhouette selector affordances
  - palette swatches
  - minimal accessory note
- `ART-06-05_hearth-avatar-preview-board.png`
  - low-collection Hearth hero treatment
  - more-settled Hearth hero treatment
  - preserved inventory-row relationship

## Validation

```bash
python3 -m py_compile ops/assets/art/generate_art_06_avatar_kit.py
python3 ops/assets/art/generate_art_06_avatar_kit.py
sips -g pixelWidth -g pixelHeight assets/art/avatar-kit/*.png
```

## Validation results

- Renderer compiles cleanly under the repo Python runtime: **passed**
- Renderer completes successfully from the repo root: **passed**
- All five required PNGs are created: **passed**
- All exported boards are portrait and `1536x2732`: **passed**
- Visual spot-check review confirms readable hierarchy and no obvious annotation overlap on the exported set: **passed by inspection**
- The onboarding board stays one-screen and utility-first rather than drifting into a long creator: **passed by composition**
- The Hearth board reads as avatar + home witness while keeping inventory rows intact: **passed by composition**

## Token gaps or naming conflicts found

- No new token family was required for this pass.
- Existing `ART-03` surfaces, gradients, border roles, and action colors were sufficient for the board set.
- No migration note was required because the renderer preserved the current launch avatar IDs already present in `launch-content.min.v1.json`.

## Intentionally deferred debt

- The board set does not attempt `ART-07` customization breadth or `ART-08` identity outfit variants.
- Hair, skin, and accessory treatments are still launch-light presentation anchors rather than a full modular avatar pipeline.
- The renderer proves the visual system direction, not a production sprite sheet or animation workflow.

## Explicit non-goals

- onboarding flow redesign
- monetization or entitlement changes
- avatar schema expansion
- sprite or animation production
- housing-editor expansion in Hearth
