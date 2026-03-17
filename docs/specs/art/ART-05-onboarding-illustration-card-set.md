# ART-05 — Onboarding Illustration + Card Set

**Section ID:** `ART-05`  
**Status:** Canonical for repo insertion  
**Canonical repo targets:**
- `docs/specs/art/ART-05-onboarding-illustration-card-set.md`
- `docs/specs/art/ART-05-onboarding-prompt-pack.md`
- `docs/specs/art/ART-05-onboarding-board-execution-log.md`
- `ops/assets/art/generate_art_05_onboarding_kit.py`
- `assets/art/onboarding-kit/ART-05-01_promise-cards-board.png`
- `assets/art/onboarding-kit/ART-05-02_problem-solution-carousel-board.png`
- `assets/art/onboarding-kit/ART-05-03_goals-tone-utility-board.png`
- `assets/art/onboarding-kit/ART-05-04_family-selection-board.png`
- `assets/art/onboarding-kit/ART-05-05_identity-selection-board.png`
- `assets/art/onboarding-kit/ART-05-06_starter-vow-and-quest-preview-board.png`
- `assets/art/onboarding-kit/ART-05-07_first-magical-moment-and-soft-paywall-board.png`

## Purpose

Turn the locked onboarding thesis into a concrete visual kit that guides implementation polish and any later external art exploration without reopening onboarding flow design.

## Why this exists

`ART-01` locked the thesis. `ART-03` locked tokens. `ART-04` locked reusable chrome and component language. The next gap is onboarding: the flow exists in app code, but it still relies on generic treatment and hard-coded styling. `ART-05` gives the repo one canonical onboarding board pack before deeper SwiftUI polish.

## Inputs / dependencies

- `AGENTS.md`
- `docs/AGENT_BRIEF_TEMPLATE.md`
- `docs/SOURCE_OF_TRUTH_INDEX.md`
- `docs/product/Aevora_V1_Master_Build_Register.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/ux/UX-first-playable-core-loop-pack.md`
- `docs/specs/art/ART-01-visual-target-sheets-pack.md`
- `docs/specs/art/ART-01-visual-target-sheets-prompt-log.md`
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`
- `docs/specs/art/ART-04-ui-component-art-kit.md`
- `docs/specs/art/ART-04-ui-component-prompt-pack.md`
- `shared/tokens/aevora-v1-design-tokens.json`
- `ios/Aevora/Features/Onboarding/OnboardingRootView.swift`
- `ios/Aevora/Features/Rewards/RewardModalView.swift`
- `ios/Aevora/Features/Quest/QuestJournalSheet.swift`

## Output / canonical artifact

1. This spec as the visual lock for onboarding board coverage and intent.
2. `docs/specs/art/ART-05-onboarding-prompt-pack.md` for optional later model-assisted exploration.
3. `ops/assets/art/generate_art_05_onboarding_kit.py` as the deterministic repo-native renderer.
4. Seven portrait boards under `assets/art/onboarding-kit/`.

## Scope boundary

### In scope

- welcome promise treatment
- problem/solution carousel art direction
- utility-safe onboarding answer surfaces
- family and identity selection card language
- starter-vow and quest-preview treatment
- first magical moment still-frame guidance
- soft paywall preview that preserves free-path trust
- deterministic repo-native export workflow

### Out of scope

- changing onboarding flow logic
- changing onboarding questions or paywall timing
- long RPG character creation
- final motion design or magical-moment animation
- brand mark or app icon work
- deeper world, avatar, or NPC production assets
- final production SwiftUI implementation

## Visual rules

### Core emotional rule

Onboarding must not feel like a survey. It should feel like:
1. being seen,
2. choosing a path,
3. receiving a believable first plan,
4. witnessing the first flicker of change.

### System rules

- Stay portrait-first and iPhone-native.
- Utility outranks lore density.
- Premium-native UI, not faux game HUD.
- Lore belongs in props, scene glimpses, sigils, materials, and microcopy accents.
- Use approved `ART-03` token roles for warmth, hierarchy, and completion cues.
- Scene fragments should feel like Cyrane and Ember Quay, not a generic fantasy village.

## Board list

### `ART-05-01_promise-cards-board.png`
Purpose: establish the emotional value proposition immediately.

Required content:
- one hero promise card
- two companion reassurance cards
- one continue treatment that does not overpower Apple sign-in

Acceptance bar:
- immediate trust and value clarity
- no cluttered lore
- premium-native hierarchy rather than promo-banner noise

### `ART-05-02_problem-solution-carousel-board.png`
Purpose: visualize why Aevora works.

Required content:
- boring trackers do not stick
- one bad day should not erase you
- progress should feel visible

Acceptance bar:
- one clear message per card
- readable icon or scene accent
- cards do not depend on tiny copy

### `ART-05-03_goals-tone-utility-board.png`
Purpose: show how question surfaces inherit the system without turning into blank survey UI.

Required content:
- one multi-select grid state
- one single-choice card state
- one segmented load-choice state
- one footer CTA row

Acceptance bar:
- still feels like Aevora
- answers remain clearly tappable
- no gamey decoration that slows comprehension

### `ART-05-04_family-selection-board.png`
Purpose: lock the family card language.

Required content:
- Dawnbound
- Archivist
- Hearthkeeper
- Chartermaker

Acceptance bar:
- each family reads differently within one second
- silhouette, prop, and material differences do the work
- cards still read as touchable iPhone surfaces

### `ART-05-05_identity-selection-board.png`
Purpose: lock the identity-shell selection treatment inside the family system.

Required content:
- at least four identity cards from mixed families
- one selected state
- one non-selected premium-ready state that does not imply gating now

Acceptance bar:
- identity cards feel distinct without becoming tiny posters
- selected state is obvious without neon outlines

### `ART-05-06_starter-vow-and-quest-preview-board.png`
Purpose: show the bridge from diagnosis to believable starter plan.

Required content:
- starter vow stack
- replace or edit affordance treatment
- quest-preview card or quest-journal teaser
- one minimum-viable-consistency cue

Acceptance bar:
- recommendations feel humane and plausible
- hierarchy is calmer than Today
- quest preview feels inviting, not blocking

### `ART-05-07_first-magical-moment-and-soft-paywall-board.png`
Purpose: lock the emotional proof beat and the follow-on offer.

Required content:
- one first magical moment frame
- one reward or witness beat
- one soft paywall preview with explicit free-path secondary action

Acceptance bar:
- world consequence is visible in the same board
- premium offer feels invitational, not punitive
- free path remains clearly available

## Repo-native execution model

Use the same fallback strategy proven in `ART-01` and `ART-04` when no external image client is configured:

- deterministic PIL renderer
- manual composition
- token-driven fills, gradients, and hierarchy
- human-readable execution log
- no machine-specific absolute paths

## Renderer requirements

The renderer must:
- read from `shared/tokens/aevora-v1-design-tokens.json`
- write to `assets/art/onboarding-kit/`
- export all boards at `1536x2732`
- be invokable from the repo root with:

```bash
python3 ops/assets/art/generate_art_05_onboarding_kit.py
```

- avoid machine-specific input paths
- keep labels and component bodies from overlapping

## Review / signoff gate

`ART-05` is approved when:
- all seven boards exist
- every board reads cleanly at portrait size
- onboarding feels emotionally warm but utility-first
- family and identity surfaces are more distinct than generic survey cards
- the magical moment board proves visible world response before paywall
- the soft paywall board preserves trust and free-path continuity
- renderer invocation and output paths are documented in the execution log

## Explicit non-goals

- do not add a second art language for onboarding
- do not introduce faux parchment-scroll UI
- do not turn onboarding into a cinematic storyboard detached from implementation
- do not build final animated magical-moment assets here
