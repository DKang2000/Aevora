# ART-03 — Color, Typography, and Design Token Kit

**Section ID:** `ART-03`  
**Status:** Canonical for repo insertion  
**Canonical repo targets:**  
- `docs/specs/art/ART-03-color-typography-design-token-kit.md`  
- `shared/tokens/aevora-v1-design-tokens.json`

## Purpose

Turn the approved `ART-01` visual thesis into one canonical token system so the iPhone UI can stop relying on hard-coded visual decisions and downstream art work can inherit one consistent language.

## Why this exists

`ART-01` locked the look. `ART-03` turns that look into reusable primitives and semantic roles for implementation, polished screen composition, and downstream component art. Without this layer, every screen risks drifting into slightly different parchment, accent, radius, hierarchy, and component behavior.

## Inputs / dependencies

- `AGENTS.md`
- `docs/AGENT_BRIEF_TEMPLATE.md`
- `docs/SOURCE_OF_TRUTH_INDEX.md`
- `docs/product/Aevora_V1_Master_Build_Register.md`
- `docs/product/08_Art_UI_System_Spec.md`
- `docs/specs/art/ART-01-visual-target-sheets-pack.md`
- `docs/specs/art/ART-01-visual-target-sheets-prompt-log.md`
- `ios/Aevora/Features/Today/TodayRootView.swift`
- `ios/Aevora/Features/World/WorldRootView.swift`
- `ios/Aevora/Features/Hearth/HearthRootView.swift`

## Output / canonical artifact

1. This spec as the human-readable lock for token intent, naming, and usage.
2. `shared/tokens/aevora-v1-design-tokens.json` as the machine-readable token source.

## Scope boundary

In scope:
- color primitives
- semantic color roles
- typography roles
- spacing, radius, stroke, elevation, and tap-target primitives
- gradient tokens needed by the approved chapter and reward language
- semantic mapping for Today, World, Hearth, NPC dialogue, inventory, shop, and reward surfaces

Out of scope:
- icon illustration production
- sprite or environment asset generation
- motion and haptics as a full system
- PNG component-board exports
- a Swift token access layer
- a second source of truth outside `shared/tokens/`

## Token naming model

Use three layers only:

1. **Primitive tokens**  
   Example: `color.parchmentStone.050`, `color.emberCopper.700`

2. **Semantic tokens**  
   Example: `color.surface.cardPrimary`, `color.text.secondary`, `color.action.primaryFill`

3. **Component aliases**  
   Example: `component.today.chapterCard.background`, `component.today.vowCard.progress.complete`

Do not skip straight from component styling to arbitrary one-off literals.

## Canonical token path rule

- Token names in this spec and in `shared/tokens/aevora-v1-design-tokens.json` must match exactly.
- Canonical references use dot-path naming such as `gradient.chapter.primary` and `color.action.progress`.
- Do not mix alternate naming styles such as `chapterPrimary` or `color.semantic.action.progress`.

## Core color primitives

### 1. Parchment Stone
Used for primary light surfaces, calm cards, and soft structural backgrounds.

| Token | Hex | Usage |
|---|---|---|
| `color.parchmentStone.050` | `#FAF5EB` | primary cards, light hero panels |
| `color.parchmentStone.100` | `#F2EDE3` | secondary cards, strips, stat chips |
| `color.parchmentStone.200` | `#E6DCCF` | borders, section breaks, disabled fills |
| `color.parchmentStone.300` | `#CDBEAC` | stronger border or backing accents |

### 2. Dawn Gold
Used for progress, meaningful hope, chapter emphasis, and positive focus.

| Token | Hex | Usage |
|---|---|---|
| `color.dawnGold.300` | `#F0CF7A` | warm highlights, chapter glow edges |
| `color.dawnGold.500` | `#D9A647` | progress emphasis, selected highlights |
| `color.dawnGold.700` | `#A87925` | dense gold text accent, strong trim only |

### 3. Ember Copper
Used for warmth, action emphasis, reward charge, and tactile active states.

| Token | Hex | Usage |
|---|---|---|
| `color.emberCopper.300` | `#E7A46C` | warm fills, subtle reward backing |
| `color.emberCopper.500` | `#E38C40` | primary warm accent, active progress, reward glow |
| `color.emberCopper.700` | `#733D21` | primary button fill, dense active CTA, status note |

### 4. Moon Indigo
Used for depth, night atmosphere, overlays, and world-facing mystery.

| Token | Hex | Usage |
|---|---|---|
| `color.moonIndigo.300` | `#5C6788` | softened atmospheric fill |
| `color.moonIndigo.500` | `#2E3654` | secondary dark surfaces |
| `color.moonIndigo.700` | `#1D2338` | major dark shell or dialogue chrome |
| `color.moonIndigo.900` | `#111522` | deepest world backdrop or high-contrast depth tone |

### 5. Moss Green
Used for completion calm, restoration, and “the city is healing” states.

| Token | Hex | Usage |
|---|---|---|
| `color.mossGreen.300` | `#9CC193` | gentle restoration tint |
| `color.mossGreen.500` | `#3D7A4F` | success fill or completion badge |
| `color.mossGreen.700` | `#285438` | success text on light surfaces |

### 6. Ash Plum
Used for uncanny, dissonant, wrong-feeling states.

| Token | Hex | Usage |
|---|---|---|
| `color.ashPlum.300` | `#A28AA3` | light uncanny wash |
| `color.ashPlum.500` | `#6B536E` | dissonance panel or icon accent |
| `color.ashPlum.700` | `#47364A` | strongest wrong-state backing |

### 7. Signal Red
Used only for warnings, destructive actions, and failure emphasis.

| Token | Hex | Usage |
|---|---|---|
| `color.signalRed.500` | `#B53A32` | warning label, destructive CTA |
| `color.signalRed.700` | `#7F201C` | stronger destructive emphasis |

## Semantic color roles

### Text
| Token | Hex | Notes |
|---|---|---|
| `color.text.primary` | `#1F1B17` | default readable text on parchment surfaces |
| `color.text.secondary` | `#5C554D` | support copy, metadata, quiet labels |
| `color.text.tertiary` | `#8A8177` | placeholders, low-emphasis helper text |
| `color.text.inverse` | `#F9F5ED` | text on moon-indigo shells |
| `color.text.success` | `#285438` | completion labels |
| `color.text.warning` | `#7F201C` | warnings and destructive copy |

### Surfaces
| Token | Hex | Notes |
|---|---|---|
| `color.surface.app` | `#F7F3EC` | root light canvas |
| `color.surface.cardPrimary` | `#FAF5EB` | default card |
| `color.surface.cardSecondary` | `#F2EDE3` | secondary surface or strip |
| `color.surface.cardElevated` | `#FFF9F0` | reward callouts or high-emphasis cards |
| `color.surface.darkShell` | `#1D2338` | dark shell, NPC chrome, deep world overlays |
| `color.surface.disabled` | `#E6DCCF` | disabled surface |

### Borders and separators
| Token | Hex | Notes |
|---|---|---|
| `color.border.subtle` | `#DDD3C7` | quiet separators |
| `color.border.default` | `#CDBEAC` | default border |
| `color.border.focus` | `#D9A647` | selected or focused border |
| `color.border.success` | `#3D7A4F` | completion border |
| `color.border.warning` | `#B53A32` | destructive or failure border |

### Actions
| Token | Hex | Notes |
|---|---|---|
| `color.action.primaryFill` | `#733D21` | tactile main action |
| `color.action.primaryText` | `#F9F5ED` | text on primary action |
| `color.action.secondaryFill` | `#F2EDE3` | bordered or secondary actions |
| `color.action.secondaryText` | `#1F1B17` | text on secondary action |
| `color.action.progress` | `#D9A647` | standard progress fill |
| `color.action.reward` | `#E38C40` | reward or celebration fill |

### State
| Token | Hex | Notes |
|---|---|---|
| `color.state.successFill` | `#3D7A4F` | completed vow fill |
| `color.state.successWash` | `#EAF4E8` | success background |
| `color.state.warningFill` | `#B53A32` | warning state |
| `color.state.dissonantFill` | `#6B536E` | uncanny state |
| `color.state.lockedWash` | `#EEE7DC` | locked or unavailable content |

## Gradient tokens

| Token | Stops | Usage |
|---|---|---|
| `gradient.chapter.primary` | `#F5E6CF` -> `#EDD1AB` | chapter card background |
| `gradient.reward.warm` | `#F0CF7A` -> `#E38C40` | reward modal highlight or reward header |
| `gradient.world.deep` | `#2E3654` -> `#111522` | world shell or dark hero strip |
| `gradient.restoration.soft` | `#EAF4E8` -> `#F5E6CF` | repair-state or recovery contexts |

## Typography lock

Use platform-native typography, with display text in rounded system styling and everything else in standard system UI styling. No pixel fonts for body copy. No lore serif in controls.

| Token | Family / style | Size | Weight | Line height intent | Usage |
|---|---|---:|---|---|---|
| `type.display.large` | system rounded | 34 | bold | ~40 | screen hero headline |
| `type.display.medium` | system rounded | 28 | bold | ~34 | card hero or major sheet titles |
| `type.title.card` | system | 20 | bold | ~24 | card title |
| `type.headline` | system | 17 | semibold | ~22 | section title or row lead |
| `type.body` | system | 17 | regular | ~22 | default body copy |
| `type.subheadline` | system | 15 | regular | ~20 | metadata or secondary paragraph |
| `type.footnote` | system | 13 | regular | ~18 | helper copy |
| `type.caption` | system | 12 | semibold | ~16 | eyebrows, chips, metadata |
| `type.button` | system | 17 | semibold | ~22 | button labels |

Rules:
- sentence case for almost everything
- eyebrows may use semibold caption styling, but not ornamental all-caps spam
- stylized fantasy display treatment is reserved for chapter moments, splash states, and promo surfaces only

## Spacing, radius, stroke, elevation, and tap targets

### Spacing
| Token | Value |
|---|---:|
| `space.4` | 4 |
| `space.8` | 8 |
| `space.12` | 12 |
| `space.14` | 14 |
| `space.18` | 18 |
| `space.20` | 20 |
| `space.24` | 24 |
| `space.32` | 32 |

### Radius
| Token | Value |
|---|---:|
| `radius.sm` | 18 |
| `radius.md` | 22 |
| `radius.lg` | 24 |
| `radius.xl` | 26 |
| `radius.pill` | 999 |

### Stroke
| Token | Value |
|---|---:|
| `stroke.hairline` | 1 |
| `stroke.default` | 1.5 |
| `stroke.strong` | 2 |

### Elevation
| Token | Description |
|---|---|
| `elevation.none` | flat parchment or transparent |
| `elevation.card` | subtle y-offset plus soft blur for premium-native cards |
| `elevation.modal` | deeper blur and lift for sheets and modals |
| `elevation.reward` | warm glow plus shadow for reward surfaces |

### Tap targets
| Token | Value |
|---|---:|
| `tap.minimum` | 44 |
| `tap.comfortable` | 48 |

## Component alias mapping

### Today
- `component.today.chapterCard.background` = `gradient.chapter.primary`
- `component.today.chapterCard.progress` = `color.action.progress`
- `component.today.vowCard.background` = `color.surface.cardPrimary`
- `component.today.vowCard.progress.default` = `color.action.progress`
- `component.today.vowCard.progress.complete` = `color.state.successFill`
- `component.today.primaryButton.fill` = `color.action.primaryFill`
- `component.today.primaryButton.text` = `color.action.primaryText`
- `component.today.statChip.background` = `color.surface.cardSecondary`
- `component.today.reminderStrip.background` = `color.surface.cardSecondary`
- `component.today.returnSurfaceCard.background` = `color.surface.cardSecondary`

### World
- `component.world.sceneChrome.deep` = `gradient.world.deep`
- `component.world.districtCard.background` = `color.surface.cardPrimary`
- `component.world.promenadeCard.background` = `color.surface.cardSecondary`
- `component.world.repairAccent` = `gradient.restoration.soft`
- `component.world.npcHighlight` = `color.emberCopper.300`

### Hearth
- `component.hearth.panel.background` = `color.surface.cardPrimary`
- `component.hearth.itemTile.background` = `color.surface.cardElevated`
- `component.hearth.itemTile.border` = `color.border.default`

### NPC dialogue, shop, and inventory
- `component.npcDialogue.shell` = `color.surface.darkShell`
- `component.npcDialogue.body` = `color.surface.cardPrimary`
- `component.shop.card` = `color.surface.cardPrimary`
- `component.inventory.tile` = `color.surface.cardPrimary`
- `component.inventory.ownedBadge` = `color.mossGreen.500`

## Accessibility and usage guardrails

- Body-copy contrast should remain at least AA against its background.
- Do not use `Signal Red` as a generic accent.
- Completion must pair color with label or icon, not color alone.
- Use `Moon Indigo` for framing and depth, not to make the interface feel heavier than the task.
- Buttons must look tappable in under a second; if ornament slows recognition, remove ornament.
- Never reintroduce pixel fonts into utility copy.

## Edge cases

- Dark-shell dialogue panels still need readable inverse text and parchment content areas.
- Success and warning states may appear next to each other on Today; their fills must remain distinct without looking equally urgent.
- Reward states should feel warmer and brighter than chapter states, but not gaudy.
- Empty Hearth, inventory, and shop states should remain premium and calm, not look unfinished.

## Acceptance criteria

- The machine-readable token file and this spec agree on token names and values.
- The token file covers the full core palette roles from the locked art spec.
- The token system is sufficient to restyle current Today, World, and Hearth surfaces without inventing new palette families.
- `ART-04` can consume this token kit without reopening `ART-01`.
- No machine-specific file paths or external-tool assumptions appear in the canonical token spec.

## Explicit non-goals

- defining sprite palette swaps
- choosing a marketing font stack
- inventing a dark mode for v1
- solving motion or haptic behavior beyond naming shared visual primitives
- designing App Store art, icon work, or logo work
