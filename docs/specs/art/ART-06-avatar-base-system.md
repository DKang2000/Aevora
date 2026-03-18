# ART-06 — Avatar Base System

**Section ID:** `ART-06`  
**Status:** Repo-ready execution spec  
**Canonical repo targets:**
- `docs/specs/art/ART-06-avatar-base-system.md`
- `docs/specs/art/ART-06-avatar-prompt-pack.md`
- `docs/specs/art/ART-06-avatar-execution-log.md`
- `ops/assets/art/generate_art_06_avatar_kit.py`
- `assets/art/avatar-kit/ART-06-01_base-frame-silhouette-board.png`
- `assets/art/avatar-kit/ART-06-02_head-hair-skin-anchor-board.png`
- `assets/art/avatar-kit/ART-06-03_palette-material-application-board.png`
- `assets/art/avatar-kit/ART-06-04_onboarding-avatar-preview-board.png`
- `assets/art/avatar-kit/ART-06-05_hearth-avatar-preview-board.png`

## Purpose
Lock the visual base system for launch avatars so onboarding, Hearth, and later identity/outfit work can use one readable silhouette-and-palette language without turning v1 into a deep character creator.

## Why this exists
`ART-05` closed onboarding boards and `IOS-03` now closes the step sequence, but the live avatar step still reads mostly as name + pronouns + text labels for silhouette and palette. `ART-06` is the next visual system gap between a finished onboarding flow and a finished identity/hearth loop.

## Inputs / dependencies
- `AGENTS.md`
- `docs/AGENT_BRIEF_TEMPLATE.md`
- `docs/SOURCE_OF_TRUTH_INDEX.md`
- `docs/product/Aevora_V1_Master_Build_Register.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/art/ART-01-visual-target-sheets-pack.md`
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`
- `docs/specs/art/ART-04-ui-component-art-kit.md`
- `docs/specs/art/ART-05-onboarding-illustration-card-set.md`
- `shared/tokens/aevora-v1-design-tokens.json`
- `ios/Aevora/Features/CoreLoop/FirstPlayableStore.swift`
- `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`
- `ios/Aevora/Features/Hearth/HearthRootView.swift`

## Output / canonical artifact
1. This spec as the visual lock for the avatar base system.
2. `docs/specs/art/ART-06-avatar-prompt-pack.md` for optional later model-assisted exploration.
3. `ops/assets/art/generate_art_06_avatar_kit.py` as the deterministic repo-native renderer.
4. Five portrait boards under `assets/art/avatar-kit/`.
5. `docs/specs/art/ART-06-avatar-execution-log.md` recording invocation, validation, and any unresolved debt.

## Scope boundary
### In scope
- limited base body-frame system for launch avatars
- silhouette and posture rules that read clearly on portrait iPhone
- starter head / hair / skin anchor rules for first-run avatar selection
- palette application rules for launch avatar materials and trims
- one onboarding-friendly preview treatment
- one Hearth-friendly preview treatment
- deterministic repo-native board generation

### Out of scope
- full 10-identity outfit variants
- large accessory catalog
- combat gear systems
- walk/run/idle animation
- paper-doll equipment management
- inventory-driven cosmetic application logic
- external model bake-off or sprite export

## Hard product constraints
- Keep avatar setup **fast**: one screen, one preview, no long creator detour.
- Use the locked v1 customization scope only: limited body frames, skin tones, hair styles/colors, outfit palette accents, simple accessory slot.
- Readability outranks ornament. If a silhouette does not read in one second on iPhone portrait, simplify it.
- Civilian roles matter as much as martial roles. Do not let every avatar feel combat-forward by default.
- Preserve current onboarding draft IDs unless a migration note is written explicitly.

## Current implementation facts to preserve
- `OnboardingAvatarDraft` currently stores `displayName`, `pronouns`, `silhouetteId`, `paletteId`, and `accessoryIds`.
- Current default seed values are:
  - `silhouette_oven_apron`
  - `palette_ember_ochre`
  - `accessory_flour_wrap`
- `OnboardingRootView` currently treats avatar setup as a fast one-screen surface.

## Board list
### `ART-06-01_base-frame-silhouette-board.png`
**Purpose:** lock the base body-frame language.

**Required content:**
- 4 limited launch-ready base silhouettes
- standing neutral pose
- one smaller portrait bust crop per silhouette
- label row with silhouette IDs

**Acceptance bar:**
- silhouettes read instantly without tiny detail
- none feel off-brand or hyper-anime
- civilian and scholarly shapes hold equal dignity beside martial-adjacent ones

### `ART-06-02_head-hair-skin-anchor-board.png`
**Purpose:** lock what changes at the head/face level during launch customization.

**Required content:**
- starter skin-tone matrix
- starter hair-shape set
- at least one example showing how face readability survives small portrait scale
- accessory anchor zone indication

**Acceptance bar:**
- tones feel human and varied without muddy compression
- hair silhouettes stay readable at small size
- face area remains legible on phone without requiring tiny eye detail

### `ART-06-03_palette-material-application-board.png`
**Purpose:** define how avatar palettes apply across cloth, trim, and neutral materials.

**Required content:**
- launch palette swatches
- one silhouette repeated across multiple palette treatments
- trim / cloth / neutral callouts
- one warning strip of combinations to avoid

**Acceptance bar:**
- palette shifts feel intentional, not like random recolors
- warmth and mythic-civic tone remain intact
- no premium-looking option should become gaudy or metallic-overloaded

### `ART-06-04_onboarding-avatar-preview-board.png`
**Purpose:** show how avatar selection reads in first-run onboarding.

**Required content:**
- one full avatar preview card
- selector affordances for silhouette and palette
- optional accessory row treatment
- display-name placement that works with long and short names

**Acceptance bar:**
- still feels fast and utility-first
- preview is clearly visual, not just a text label dump
- no long creator vibe

### `ART-06-05_hearth-avatar-preview-board.png`
**Purpose:** show how the chosen avatar sits inside the Hearth reward surface.

**Required content:**
- avatar preview paired with Hearth summary language
- one empty-state / low-collection variant
- one more-settled variant
- clear balance between avatar and home/customization cues

**Acceptance bar:**
- Hearth reads as avatar + home/customization, not inventory-only
- avatar remains readable without crowding item cards
- reward-surface warmth is preserved

## Visual rules
- Premium-native UI, not faux RPG HUD.
- Warm mythic-civic materials: parchment neutrals, ember copper accents, indigo depth, moss/restoration hints.
- Simple shapes first; texture second.
- Silhouette changes should do more work than micro-detail.
- Palette should support identity expression without reopening `ART-08` outfit work.
- Avoid over-dark grim fantasy, over-cute chibi drift, or desktop-RPG density.

## Edge cases
- empty or long display name
- no accessory equipped
- reduced-motion or accessibility-first users who still need clear preview hierarchy
- color combinations that reduce readability against Hearth or onboarding surfaces
- future ART-07 expansion without breaking `ART-06` IDs

## Acceptance criteria
- Five portrait boards render cleanly at `1536x2732`.
- Board language stays consistent with `ART-01` through `ART-05`.
- The system supports the current onboarding draft fields without schema changes.
- The output makes the next iOS pass obvious: replace text-only preview in onboarding and add a real avatar presence to Hearth.
- No board implies a deep paper-doll or equipment-management system that v1 does not have.

## Explicit non-goals
- Do not redesign onboarding flow.
- Do not invent new avatar schema beyond the current launch draft needs.
- Do not bundle identity outfit variants from `ART-08` into this pass.
- Do not add motion specs here.
- Do not turn the Hearth into a full housing editor.
