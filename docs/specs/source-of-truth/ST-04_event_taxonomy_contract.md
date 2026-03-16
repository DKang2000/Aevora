# ST-04 — Event Taxonomy Contract

## Purpose
Define the canonical analytics event contract so product, growth, backend, iOS, and QA measure the same real behaviors.

## Why it exists
The launch product depends on trustworthy onboarding, completion, retention, economy, and monetization signals. This contract locks names, required properties, privacy boundaries, and versioning before dashboards or instrumentation ship.

## Inputs and dependencies
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/01_Product_Thesis.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/product/07_Analytics_Event_Taxonomy.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`

## Scope
This section defines:
- event naming rules
- common event properties
- grouped event schemas for core launch flows
- deduplication and retry expectations

## Non-goals
- dashboard implementation
- warehouse modeling details
- speculative social event families beyond locked placeholders

## Event naming rule
- snake_case event names
- event names describe user or system actions, not UI labels
- versioning is tracked in event metadata, not by renaming the core event

## Required common properties
- `event_name`
- `event_version`
- `occurred_at_utc`
- `local_date`
- `user_id` or anonymous device identifier
- `session_id`
- `surface`
- `app_build`
- `platform`
- `experiment_assignments`

## Privacy boundaries
- never include freeform journaling or note text
- never include sensitive HealthKit raw payloads
- never derive or log mental-health judgments from missed vows

## Core event groups
### App lifecycle
- `app_installed`
- `app_opened`
- `session_started`
- `session_ended`

### Onboarding
- `onboarding_started`
- `onboarding_step_viewed`
- `onboarding_step_completed`
- `origin_family_selected`
- `identity_selected`
- `avatar_created`
- `starter_vow_recommended`
- `starter_vow_accepted`
- `starter_vow_edited`
- `onboarding_completed`
- `first_magical_moment_viewed`

### Habit and completion
- `vow_created`
- `vow_edited`
- `vow_archived`
- `vow_deleted`
- `reminder_enabled`
- `vow_started`
- `vow_progress_updated`
- `vow_completed`
- `day_completed_first_vow`
- `all_planned_vows_completed`
- `vow_missed`
- `vow_rekindled`

### Progression and world
- `resonance_awarded`
- `gold_awarded`
- `level_up`
- `witness_mark_earned`
- `world_scene_opened`
- `npc_interaction_started`
- `npc_dialogue_completed`
- `district_progressed`
- `problem_damage_dealt`
- `chapter_started`
- `chapter_milestone_reached`
- `chapter_completed`

### Commerce and system surfaces
- `reward_chest_opened`
- `item_awarded`
- `shop_opened`
- `shop_item_viewed`
- `shop_purchase_completed`
- `widget_viewed`
- `widget_tapped`
- `live_activity_started`
- `live_activity_tapped`
- `shortcut_invoked`
- `notification_prompt_viewed`
- `notification_permission_result`
- `notification_sent`
- `notification_opened`
- `healthkit_prompt_viewed`
- `healthkit_permission_result`
- `verified_completion_imported`
- `paywall_viewed`
- `trial_started`
- `purchase_started`
- `purchase_completed`
- `purchase_failed`
- `subscription_restored`
- `subscription_renewed`
- `subscription_canceled`
- `subscription_expired`

## Anonymous vs authenticated rules
- use anonymous device/session identifiers before account creation
- preserve attribution continuity when a guest account becomes registered
- do not duplicate conversion events during guest-to-account linking

## Local date and time rules
- `occurred_at_utc` is the ingestion-safe timestamp
- `local_date` captures the user’s local habit day for habit and reward logic
- events involving vow completion must include both

## Deduplication and retry
- idempotent client-generated events must carry a stable `event_id` or `client_request_id`
- retried ingestion cannot create duplicate completion, reward, or purchase events
- analytics ingestion may return `202` and de-duplicate server-side

## Versioning notes
- event catalog version is `v1`
- additive optional properties are preferred
- breaking property changes require a schema version bump and explicit migration note

## Examples
Supporting machine-readable files live in `shared/contracts/events/`.

## Acceptance criteria
- all high-value launch behaviors have canonical event names
- common properties are stable across event groups
- privacy boundaries are explicit
- the contract is detailed enough for iOS instrumentation, ingestion validation, and QA event checks
