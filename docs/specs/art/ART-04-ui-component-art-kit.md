# ART-04 — UI Component Art Kit

**Section ID:** `ART-04`  
**Status:** Canonical for repo insertion  
**Canonical repo targets:**  
- `docs/specs/art/ART-04-ui-component-art-kit.md`
- `docs/specs/art/ART-04-ui-component-prompt-pack.md`

## Purpose

Translate the approved `ART-01` target sheets and the `ART-03` token layer into a reusable component art kit for Aevora’s launch surfaces, with one polished Today pass defined as the first proof of system coherence for downstream execution.

## Why this exists

`ART-01` says what Aevora should feel like. `ART-03` says which primitives and semantic tokens carry that feeling. `ART-04` turns both into reusable UI components and ornamental micro-assets so implementation does not devolve into ad hoc card-by-card styling.

## Inputs / dependencies

- `AGENTS.md`
- `docs/AGENT_BRIEF_TEMPLATE.md`
- `docs/SOURCE_OF_TRUTH_INDEX.md`
- `docs/product/Aevora_V1_Master_Build_Register.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/art/ART-01-visual-target-sheets-pack.md`
- `docs/specs/art/ART-01-visual-target-sheets-prompt-log.md`
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`
- `shared/tokens/aevora-v1-design-tokens.json`
- `ios/Aevora/Features/Today/TodayRootView.swift`
- `ios/Aevora/Features/World/WorldRootView.swift`
- `ios/Aevora/Features/Hearth/HearthRootView.swift`

## Output / canonical artifact

1. This component-kit spec.
2. The companion prompt pack.
3. A downstream component-board export list for later execution under `assets/art/ui-kit/`.
4. A downstream polished Today composition target defined here but not produced in this task.

## Scope boundary

In scope:
- premium-native UI component styling
- manual composition rules
- component state inventory
- art-board definitions for Today, World support cards, Hearth, NPC dialogue, inventory, shop, tab icons, and sheets or modals
- ornamental micro-assets that support the UI without replacing readable controls
- one polished Today screen spec as proof of system coherence for later execution

Out of scope:
- sprite production
- avatar system production
- tilesets, props, FX, or animation packs beyond tiny UI-adjacent ornamental effects
- rewriting UX flows
- turning AI output into literal final text-heavy UI screenshots
- generating PNG boards in this task

## Global rules

1. **Manual UI composition is required.**  
   Real interface text, hierarchy, spacing, and control layout stay manually composed.

2. **AI assistance is optional and narrow.**  
   Use prompts only for material studies, sigil motifs, icon silhouettes, or tiny ornamental layers. Do not accept raw generated UI text as final UI.

3. **Portrait iPhone first.**  
   Components must read at phone scale, not only when zoomed on desktop.

4. **Utility outranks fantasy chrome.**  
   If a decorative flourish slows scan speed, remove or reduce it.

5. **One visual priority per primary surface.**  
   Today = utility clarity. World = one focal neighborhood plus readable support cards. Hearth = avatar and home reward warmth.

## Component family inventory

## 1. Core chrome and scaffolding

### A. Screen headline cluster
Must include:
- large rounded headline
- quiet supporting line
- room for chapter, day, or state metadata

States:
- standard
- chapter-aware
- world-state-aware

### B. Section eyebrow
Must include:
- caption-weight semantic label
- low ornament ceiling
- works on parchment and dark shell

### C. Button family
Required variants:
- primary warm CTA
- secondary bordered CTA
- tertiary quiet text CTA
- destructive CTA
- disabled CTA

Rules:
- buttons must read as tappable in under a second
- label should remain center-weighted even with icon or trailing chevron

### D. Bottom-sheet shell
Required variants:
- compact progress sheet
- medium reward sheet
- medium paywall preview
- NPC or shop support sheet

Rules:
- shell chrome can be premium, but copy body remains plain and readable
- detents should feel airy, not card-stack cluttered

## 2. Today component family

Grounding in current surface inventory:
- headline cluster
- chapter card
- reminder strip
- return surfaces card
- vow-card list
- stat row
- district CTA row
- progress sheet
- reward modal
- soft paywall preview

### A. Chapter card
Must show:
- eyebrow
- chapter title
- objective title
- summary
- progress bar
- optional status note
- secondary CTA

States:
- baseline
- chapter in motion
- chapter nearly complete
- chapter complete or celebratory

Token anchors:
- `gradient.chapter.primary`
- `color.action.progress`
- `color.text.primary`
- `radius.xl`

### B. Reminder strip
Must show:
- compact stacked reminders
- low-emphasis parchment backing
- fast scan rhythm

States:
- one item
- multiple items
- empty or hidden

### C. Return surfaces card
Must show:
- notification education variant
- HealthKit education variant
- witness-surface premium messaging variant

States:
- free
- eligible
- premium-active
- hidden

### D. Vow card
Must show:
- title
- metadata line
- optional completion badge
- status label
- progress bar
- last-kept line
- main action button

Required states:
- binary idle
- binary complete
- count or duration idle
- count or duration in progress
- count or duration complete
- disabled after completion

Rules:
- completion state uses Moss Green calmly, not neon celebration
- active state uses Dawn Gold and Ember Copper warmth without looking monetized

### E. Stat chip row
Must show:
- Chains
- Embers
- Gold
- Rank

Rules:
- chips read as status, not CTA
- equal visual weight with clear numerals

### F. District CTA row
Must show:
- “see the district respond” style transition CTA
- optional keepsake note
- tomorrow prompt support copy

## 3. Modal and sheet family

### A. Reward modal
Must show:
- headline
- summary
- one or more reward lines
- strong primary CTA
- warmth halo or reward emphasis

States:
- level-up
- reward chest
- chapter completion
- simple success

### B. Quest journal sheet
Must show:
- chapter heading
- current day marker
- short narrative block
- scrollable content region
- close affordance

### C. Progress sheet
Must show:
- large progress value
- primary save CTA
- compact detent-safe spacing

### D. Soft paywall preview
Must show:
- premium headline
- body copy
- trial, monthly, annual, restore, and continue-free actions

Rules:
- premium should feel richer, not predatory
- no gaudy fantasy gold overload

## 4. World support component family

Grounding in current surface inventory:
- world headline cluster
- district card
- promenade or witness card
- NPC section
- NPC dialogue sheet
- shop card
- shop sheet

### A. District card
Must show:
- stage title
- day or chapter metadata
- mood text
- world-change text
- repair progress
- problem title and summary
- optional status note

States:
- before repair
- mid repair
- visibly improved
- chapter resolved

### B. Promenade or witness card
Must show:
- short invitation to walk or witness
- one supporting line
- optional accent icon or tiny sigil

### C. NPC dialogue panel
Must show:
- bust zone or bust placeholder
- name
- role
- dialogue copy
- response CTA or CTAs
- optional affinity or quest-state cue

States:
- neutral
- quest available
- vendor
- restoration reaction

Rules:
- panel shell may use moon-indigo depth
- dialogue body must remain parchment-readable

### D. Shop card and item tile
Must show:
- item name
- summary
- rarity or bucket
- price
- purchase or owned state

States:
- affordable
- unaffordable
- owned
- featured

## 5. Hearth and inventory family

Grounding in current surface inventory:
- hearth headline
- hearth summary panel
- stored item list
- applied item list
- empty states

### A. Hearth summary panel
Must show:
- title
- summary
- gold on hand
- optional chapter-complete notice

### B. Pack item card
Must show:
- item name
- summary
- bucket or rarity
- apply action

States:
- stored
- applied
- locked
- newly earned

### C. Empty-state panel
Must show:
- calm premium empty-state language
- room for a future keepsake visual
- no cold placeholder-box feeling

## 6. Tab icon family

Required icons:
- Today
- World
- Hearth
- Inventory or Pack if surfaced separately
- Profile or Stats

Rules:
- silhouette-first
- readable at small size
- fantasy framing is subtle
- no pixel-pure micro-detail

## Polished Today proof deliverable

Create one portrait Today screen composition in the downstream art-execution phase that proves the kit works end-to-end.

Must include:
- headline cluster
- chapter card
- reminder strip
- return surfaces card
- at least three vow cards with different states
- stat row
- district CTA row
- one visible success-state moment

Must not include:
- fake generated app text
- desktop-density layout
- over-framed fantasy borders on every component
- unexplained color departures from `ART-03`

Target export for downstream execution:
- portrait board at `1536x2732`
- at least two 1:1 or near-1:1 crops showing card and material fidelity at realistic viewing size

## Downstream export checklist

These are future downstream execution targets, not deliverables in this task:

1. `ART-04-01_core-chrome-board.png`
2. `ART-04-02_today-components-board.png`
3. `ART-04-03_modal-sheet-board.png`
4. `ART-04-04_world-npc-shop-board.png`
5. `ART-04-05_hearth-inventory-board.png`
6. `ART-04-06_tab-icons-board.png`
7. `ART-04-07_today-polished-pass.png`

## Edge cases

- Long vow titles cannot break button alignment or card rhythm.
- Dense chapter summary text cannot make the chapter card feel heavier than the vow list.
- World support cards must not compete with the world scene itself.
- Empty Hearth, shop, and inventory states should still feel premium and alive.
- Vendor and NPC dialogue panels must feel related, but not identical if one is transactional and one is narrative.

## Acceptance criteria

- Every major UI component already visible in Today, World, and Hearth has a corresponding art-kit definition.
- The kit uses `ART-03` token names instead of one-off visual instructions.
- The prompt pack, if used, stays scoped to ornamental or material generation rather than text-heavy UI generation.
- One polished Today composition is defined precisely enough for downstream execution without reopening `ART-01`.
- The kit is sufficiently precise that implementation or Figma composition can proceed without revisiting the visual thesis.

## Explicit non-goals

- world map expansion
- avatar body or outfit production
- NPC sprite production
- repair FX or environment animation
- payment strategy or pricing changes
- rewriting the current SwiftUI surface inventory
