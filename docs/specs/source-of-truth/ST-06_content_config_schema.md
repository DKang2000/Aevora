# ST-06 — Content Config Schema

## Purpose
Define the structure of authored launch content so narrative, design, backend, and client code reference the same content model.

## Why it exists
Aevora’s launch footprint depends on authored content for identities, districts, NPCs, chapters, quests, shop offers, and reward references. This schema keeps content breadth stable while separating content from player state and runtime tuning.

## Inputs and dependencies
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/04_Game_Economy_Spec.md`
- `docs/product/05_Narrative_Content_Launch_Spec.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/world/WORLD_BIBLE_PRINCIPLES_SUMMARY.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`

## Scope
This section defines:
- authored content definitions for the launch footprint
- ID and localization-reference rules
- the boundary between content definitions and player-state snapshots

## Non-goals
- the full launch content pack
- runtime tuning knobs that belong in remote config
- player-owned progression state

## Content model sections
### Origin families
- four launch families:
  - `dawnbound`
  - `archivist`
  - `hearthkeeper`
  - `chartermaker`

### Identity shells
- ten launch identities grouped by origin family
- content defines flavor hooks and presentation references, not bespoke progression engines

### Districts
- launch district config stores restoration stages, problem-template references, and scene-entry hooks

### NPCs
- launch cast includes:
  - `maerin_vale`
  - `sera_quill`
  - `tovan_hearth`
  - `brigant_hal`
  - `ilya_fen`
  - `pollen`

### Chapters and quests
- content defines chapter IDs, quest templates, unlock conditions, reward references, and dialogue keys
- player progress lives in `ChapterState` and `QuestState`, not here

### Shops, items, rewards
- content defines item templates, offer bundles, rarity, and flavor metadata
- price values may reference remote-config-tuned knobs where appropriate

## ID rules
- content IDs are stable, lowercase snake_case strings
- IDs are never localized
- system copy and narrative copy resolve through keys, not inline prose blobs in the schema

## Localization and copy hooks
- content objects store references such as `titleKey`, `summaryKey`, and `dialogueSetKey`
- utility copy and narrative copy are separate namespaces

## Feature gating
- content may declare `entitlementGate`, `featureFlag`, or `chapterGate`
- gating metadata cannot introduce content outside the locked v1 launch footprint

## Boundary rules
- content config defines what exists
- remote config defines runtime tuning
- player state defines what the user has unlocked, completed, or owns

## Edge cases
- identity-specific flavor should be done with overlays and references, not separate mechanical quest systems
- shop offers may rotate or be flagged, but item definitions remain stable
- disabled content must fail safely rather than breaking chapter progression

## Versioning notes
- content config schema version is `v1`
- additive content sections are preferred
- changing an existing content ID is a breaking contract change

## Examples
- schema: `shared/contracts/content/content-config.v1.schema.json`
- minimal launch payload: `content/launch/launch-content.min.v1.json`

## Acceptance criteria
- all core authored launch objects have canonical homes
- content boundaries are separated from state and tuning
- identity flavor remains flavor-first, not mechanic-fragmenting
- the schema is sufficient for content, backend, and client teams to build against the same payload structure
