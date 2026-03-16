# ST-10 — String Key Registry / Copy Token Structure

## Purpose
Define the canonical naming and token structure for utility copy, system states, rewards, onboarding, and content-linked references.

## Why it exists
Aevora needs one shared namespace so iOS, content, backend-driven surfaces, and QA all resolve the same keys without copy drift or lore overuse in critical flows.

## Inputs and dependencies
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/01_Product_Thesis.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/05_Narrative_Content_Launch_Spec.md`
- `docs/world/WORLD_BIBLE_PRINCIPLES_SUMMARY.md`
- `docs/specs/source-of-truth/ST-06_content_config_schema.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`

## Scope
This section defines:
- namespace strategy
- interpolation and pluralization rules
- the split between system copy and content-linked copy
- starter utility-string coverage for launch

## Non-goals
- full narrative script authoring
- fully localized language packs

## Namespace strategy
- `onboarding.*`
- `today.*`
- `vow.*`
- `world.*`
- `hearth.*`
- `inventory.*`
- `shop.*`
- `dialogue.*`
- `profile.*`
- `settings.*`
- `paywall.*`
- `notifications.*`
- `healthkit.*`
- `shortcuts.*`
- `rewards.*`
- `states.*`
- `actions.*`
- `content.*`

## Rules
- keys are lowercase snake_case segments joined with dots
- utility/system strings use plain English first
- optional flavor variants may exist as separate keys; they must not replace the utility default
- content-linked narrative and dialogue keys live under `content.*`
- error and state catalog keys must align with `ST-09`

## Interpolation and pluralization
- interpolation tokens use `{token_name}`
- pluralized strings use separate keys such as `.one` and `.other`
- user-entered data must never be required for a key to remain intelligible

## Fallback behavior
- if a requested key is missing, fall back to the nearest stable utility key in the same namespace
- if no safe fallback exists, surface a non-lore generic string and log the miss

## Edge cases
- rewards can have utility and flavor variants, but the utility variant remains canonical for first-time UX
- content IDs and copy keys are separate; changing one must not force the other

## Versioning notes
- registry version is `v1`
- renaming a key is a breaking change unless both old and new keys are supported during migration

## Examples
- key registry: `shared/contracts/localization/string-key-registry.v1.json`
- starter utility tokens: `content/launch/copy/en/core.v1.json`

## Acceptance criteria
- every critical v1 namespace has a canonical home
- error and action keys align with the state catalog
- content-linked narrative keys stay separate from system keys
- utility copy remains plain-language and non-shaming
