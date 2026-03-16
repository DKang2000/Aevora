# Aevora Analytics + Event Taxonomy
**Version:** 1.0  
**Status:** Locked before production implementation  
**Date:** 2026-03-14  

## 1. Measurement philosophy
Aevora should not optimize for shallow engagement.  
We care about:
- meaningful behavior,
- repeated return,
- emotional payoff,
- monetization that does not break trust.

## 2. North-star metric
**Meaningful Progress Days per Weekly Active User (MPD/WAU)**

### Definition
A Meaningful Progress Day occurs when, on a given local calendar day, a user:
1. completes at least one planned vow, and  
2. sees at least one in-game consequence tied to that completion.

This is the heartbeat of the product.

## 3. Primary KPI stack
### Retention
- D1 retention
- D7 retention
- D30 retention
- 7-day arc completion rate
- 30-day chapter continuation rate

### Behavior
- average active vows per retained user
- average completions per active day
- perfect day rate
- rekindle usage rate
- widget usage rate
- world witness rate

### Monetization
- paywall view rate
- trial start rate
- trial conversion rate
- subscriber retention
- ARPU / ARPPU
- free-to-paid upgrade timing

### Quality
- crash-free session rate
- sync failure rate
- dropped event rate
- notification opt-in rate
- HealthKit permission acceptance rate

## 4. Event naming convention
### Format
Use **snake_case** and action-oriented names.

Examples:
- `onboarding_started`
- `vow_created`
- `vow_completed`
- `district_progressed`

### Rules
- past tense or action-complete naming
- one event per meaningful user action
- no ambiguous “clicked_button”
- use dedicated events rather than overloaded generic event names

## 5. Common event properties
Every event should include:
- `user_id`
- `anonymous_id`
- `event_time_utc`
- `local_date`
- `time_zone`
- `app_version`
- `build_number`
- `release_channel`
- `device_model`
- `os_version`
- `subscription_state`
- `origin_family`
- `identity_shell`
- `experiment_assignments`
- `session_id`

## 6. Identity and segmentation properties
Important segmentation dimensions:
- onboarding tone (`gentle`, `balanced`, `driven`)
- blocker type
- starter vow count chosen
- free vs premium
- source of completion (`manual`, `healthkit`, `shortcut`, etc.)
- user tenure day bucket
- country / locale
- cohort week

## 7. Event catalog
### 7.1 Acquisition / app lifecycle
#### `app_installed`
Fire:
first launch after install

#### `app_opened`
Fire:
every foreground open

Properties:
- source (`direct`, `notification`, `widget`, `live_activity`, `deep_link`)

#### `session_started`
Fire:
new session start

#### `session_ended`
Fire:
session timeout / background end

Properties:
- duration_seconds

### 7.2 Onboarding
#### `onboarding_started`
#### `onboarding_step_viewed`
Properties:
- `step_name`
- `step_index`

#### `onboarding_step_completed`
Properties:
- `step_name`
- `answers`

#### `origin_family_selected`
Properties:
- `family_id`

#### `identity_selected`
Properties:
- `identity_id`

#### `avatar_created`
Properties:
- selected cosmetic basics

#### `starter_vow_recommended`
Properties:
- recommendation metadata

#### `starter_vow_accepted`
Properties:
- vow template id

#### `starter_vow_edited`
Properties:
- changed fields

#### `onboarding_completed`
Properties:
- total time
- total vows created

#### `first_magical_moment_viewed`
Properties:
- scene id
- whether it was interactive

### 7.3 Habit / vow management
#### `vow_created`
Properties:
- vow_type
- user-facing category
- tags
- schedule pattern
- target_value
- difficulty_band

#### `vow_edited`
Properties:
- changed_fields

#### `vow_archived`
Properties:
- reason

#### `vow_deleted`
Properties:
- age_days

#### `reminder_enabled`
Properties:
- reminder_time
- vow_id

### 7.4 Completion and consistency
#### `vow_started`
For count/duration vows when user begins but has not yet completed.

#### `vow_progress_updated`
Properties:
- progress_value
- progress_pct

#### `vow_completed`
Properties:
- vow_type
- completion_source
- progress_pct
- chain_length_before
- chain_length_after
- ember_used (bool)
- same_day_witness_eligible (bool)

#### `day_completed_first_vow`
Fire:
first completed vow of local day

#### `all_planned_vows_completed`
Properties:
- total_planned
- total_completed

#### `vow_missed`
Properties:
- vow_id
- hours_since_due

#### `vow_rekindled`
Properties:
- vow_id
- time_since_miss_hours

### 7.5 Progression
#### `resonance_awarded`
Properties:
- amount
- source
- multiplier_breakdown

#### `gold_awarded`
Properties:
- amount
- source

#### `level_up`
Properties:
- new_level

#### `witness_mark_earned`
Properties:
- mark_id
- mark_category

### 7.6 World and narrative
#### `world_scene_opened`
Properties:
- district_id
- scene_variant

#### `npc_interaction_started`
Properties:
- npc_id

#### `npc_dialogue_completed`
Properties:
- npc_id
- dialogue_id

#### `district_progressed`
Properties:
- district_id
- progress_before
- progress_after
- cause

#### `problem_damage_dealt`
Properties:
- problem_id
- amount

#### `chapter_started`
Properties:
- chapter_id

#### `chapter_milestone_reached`
Properties:
- chapter_id
- milestone_id

#### `chapter_completed`
Properties:
- chapter_id
- days_since_start

### 7.7 Economy and inventory
#### `reward_chest_opened`
Properties:
- chest_type
- item_count

#### `item_awarded`
Properties:
- item_id
- rarity
- source

#### `shop_opened`
Properties:
- shop_id

#### `shop_item_viewed`
Properties:
- item_id

#### `shop_purchase_completed`
Properties:
- item_id
- price_gold
- balance_after

### 7.8 Widgets / Live Activities / system surfaces
#### `widget_viewed`
Approximate based on deep link / refresh context where available

#### `widget_tapped`
Properties:
- widget_kind

#### `live_activity_started`
Properties:
- activity_kind

#### `live_activity_tapped`
Properties:
- activity_kind

#### `shortcut_invoked`
Properties:
- action_name

### 7.9 Notifications
#### `notification_prompt_viewed`
Properties:
- prompt_context

#### `notification_permission_result`
Properties:
- granted (bool)

#### `notification_sent`
Properties:
- campaign_name
- trigger_type

#### `notification_opened`
Properties:
- campaign_name
- delay_minutes

### 7.10 HealthKit / integration
#### `healthkit_prompt_viewed`
#### `healthkit_permission_result`
Properties:
- data_types_requested
- granted_types

#### `verified_completion_imported`
Properties:
- source_type
- normalized_vow_id

### 7.11 Monetization
#### `paywall_viewed`
Properties:
- placement
- variant
- entitlements_shown

#### `trial_started`
Properties:
- plan
- offer_id

#### `purchase_started`
Properties:
- sku
- price_local

#### `purchase_completed`
Properties:
- sku
- plan
- trial_included

#### `purchase_failed`
Properties:
- sku
- error_class

#### `subscription_restored`
#### `subscription_renewed`
#### `subscription_canceled`
#### `subscription_expired`

### 7.12 Future social (instrument now if feature-flagged)
#### `friend_invite_sent`
#### `friend_invite_accepted`
#### `group_challenge_joined`
#### `group_challenge_completed`

## 8. Derived metrics
### Activation
User is activated when they:
- complete onboarding,
- create at least 3 vows,
- complete at least 1 vow,
- witness at least 1 in-game consequence.

### 7-day arc completion
User reaches the main value proof of v1.

### Return-with-recovery rate
% of users who miss and later return within 72 hours.

### Utility-to-delight ratio
Measure:
- Today screen sessions
- World scene sessions
Healthy outcome is not 50/50. Today should remain the most-used tab.

## 9. Dashboards
### Executive dashboard
- WAU / MAU
- MPD / WAU
- D1 / D7 / D30
- trial starts
- conversion
- chapter completion
- crash-free rate

### Product dashboard
- onboarding funnel
- vow creation funnel
- first magical moment rate
- witness return rate
- day 1 → day 7 drop points

### Economy dashboard
- RP earned/day
- Gold earned/spent
- item rarity distribution
- shop open vs purchase rate
- ember earn/use rates

### Growth dashboard
- acquisition source
- paywall conversion by source
- trial conversion by source
- seasonality and campaign lift

## 10. Experimentation framework
### Required experiment dimensions
- paywall placement
- trial wording
- recommended vow count
- onboarding order
- reminder cadence
- witness prompt timing
- economy tuning

### Experiment rules
- stable assignment per user
- experiment metadata on all core events
- no overlapping experiments on same primary KPI without coordination

## 11. Data quality rules
- client retries failed events
- server de-duplicates by event_id
- timestamps recorded client-side and server-side
- event schema version field required
- no silent event renames
- data contracts owned jointly by product and engineering

## 12. Privacy and ethical boundaries
- do not infer mental health diagnoses
- do not use sensitive journaling content as analytics payload
- avoid collecting freeform text unless clearly needed and handled carefully
- support deletion requests cleanly
- avoid manipulative re-engagement segmentation

## 13. Red flags to watch
- high onboarding completion but low first-magical-moment view
- high vow creation but low witness rate
- strong D1 but weak D7
- high paywall view with low trust sentiment
- heavy widget taps but low completion
- high world visits with low actual vow completion (novelty without behavior change)

## 14. Success thresholds for v1 beta
These are directional, not investor-deck vanity targets:
- onboarding completion > 55%
- activation > 35%
- first 7-day arc completion > 20% of activated users
- D7 retention > strong niche-app baseline
- meaningful progress days rising week over week in retained cohort

## 15. Definition of done
Analytics is done when:
- every critical funnel step is measurable,
- metrics match product philosophy,
- product, design, and engineering all trust the event data,
- the team can answer “where does delight break?” without guessing.

