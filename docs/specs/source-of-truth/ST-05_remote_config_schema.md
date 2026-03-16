# ST-05 — Remote Config Schema

## Purpose
Define the runtime-tunable config surface for launch behavior that can change without an app release.

## Why it exists
Aevora needs one controlled place for feature flags, economy knobs, onboarding and paywall variants, reminder timing, and witness-surface tuning. Without this contract, the client and backend would drift into ad hoc flags and duplicated constants.

## Inputs and dependencies
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/04_Game_Economy_Spec.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`

## Scope
This section defines:
- feature-flag structure
- economy tuning keys
- onboarding and paywall runtime switches
- reminder and witness-surface knobs
- safe precedence and fallback behavior

## Non-goals
- narrative or chapter content payloads
- secrets or operational credentials
- per-user state

## Remote config versus content config
- Remote config controls behavior and tuning.
- Content config defines authored launch content such as identities, NPCs, chapters, quests, districts, offers, and dialogue references.
- Narrative text and content breadth do not belong in remote config.

## Precedence rules
1. bundled app defaults
2. last-known-good cached remote config
3. fresh remote config override

If a fetched config is invalid, stale beyond policy, or missing a required top-level section, the client falls back to the last-known-good config and records the failure for telemetry.

## Canonical sections
### `featureFlags`
- gates launch-safe feature toggles
- examples:
  - `advanced_widgets_enabled`
  - `live_activities_enabled`
  - `healthkit_verification_enabled`
  - `chapter_one_premium_gate_enabled`

### `economy`
- tuning knobs derived from the economy spec
- examples:
  - `free_active_vow_cap`
  - `premium_active_vow_cap`
  - `binary_base_resonance`
  - `count_base_resonance`
  - `duration_base_resonance`
  - `chain_bonus_percent_by_milestone`
  - `embers_cap`
  - `over_completion_reward_cap_percent`

### `onboarding`
- starter-vow and pacing variants
- examples:
  - `starter_vow_recommendation_count`
  - `first_magical_moment_variant`
  - `soft_paywall_trigger`

### `paywall`
- launch monetization behavior
- examples:
  - `trial_days`
  - `annual_plan_enabled`
  - `monthly_plan_enabled`
  - `headline_variant`
  - `body_theme_variant`

### `reminders`
- reminder and witness-prompt behavior
- examples:
  - `default_reminder_hour_local`
  - `max_daily_reminders`
  - `reward_reveal_delay_seconds`

### `widgets`
- widget refresh and presentation tuning

### `liveActivities`
- availability and heartbeat behavior for Live Activities

### `chapterGating`
- gating switches for starter arc and Chapter One access

## Fallback behavior
- if remote config fetch fails on first launch, the bundled app defaults win
- if cached config exists and is still within TTL, use it immediately
- invalid remote values do not partially override a valid cached section

## Edge cases
- premium entitlement changes while config is stale: entitlement rules still win
- remote config can disable optional verified-input or witness surfaces, but it cannot break manual logging
- feature flags must not widen v1 scope beyond the locked product spine

## Versioning notes
- schema version is `v1`
- new fields must be additive
- removed or repurposed fields require coordinated contract and client updates

## Examples
- schema: `shared/contracts/remote-config/remote-config.v1.schema.json`
- launch defaults: `shared/contracts/remote-config/defaults/launch-defaults.v1.json`

## Acceptance criteria
- remote config cleanly separates runtime tuning from authored content
- fallback and precedence behavior is explicit
- all important launch knobs have canonical homes
- manual logging remains safe even if remote config is unavailable
