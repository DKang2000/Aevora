# GS First Playable Core Loop Pack

## Purpose
Define the mechanical rules for starter vows, day-one rewards, chain/ember behavior, and district restoration so the first playable loop stays data-driven and consistent across iOS and backend.

## Inputs / dependencies
- `AGENTS.md`
- `docs/product/04_Game_Economy_Spec.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`

## Sections
### GS-01 — Vow data/rules spec
- Vow types: `binary`, `count`, `duration`.
- Required fields for the first playable loop: title, category, type, target, cadence, reminder, difficulty band.
- Difficulty bands: `gentle`, `standard`, `stretch`. Starter recommendations default to `gentle` or `standard`.

### GS-02 — Vow schedule rules spec
- Starter vows use local-day recurring schedules.
- Supported launch cadences in this loop: daily, weekdays, custom weekdays.
- Same-day edits apply to future logs, not previously reconciled completion facts.

### GS-03 — Completion rules for yes/no, count, duration
- Binary: complete when the user confirms completion once.
- Count: complete when submitted quantity meets or exceeds target.
- Duration: complete when submitted minutes meet or exceed target.
- Over-completion is capped at 120% reward value.

### GS-04 — Partial progress rules
- Count and duration vows support partial progress.
- Once a user logs any valid non-zero progress, the minimum reward floor is 30% of base rewards.
- Multiple same-day progress updates resolve to one day-level result for UX while keeping immutable event history backend-side.

### GS-05 — Immediate reward rules
- Every completion grants Resonance, Gold, and one visible world consequence summary.
- First vow completed each day adds +2 Gold.
- Same-day witness return may add the witness bonus later, but day-one proof must already feel meaningful before the user visits World.

### GS-06 — Resonance formula
- Base Resonance: binary 10, count 10, duration 12.
- Difficulty multiplier: gentle 0.8, standard 1.0, stretch 1.5.
- Partial completion scales proportionally with the 30% minimum floor.
- Chain milestone bonus applies after base reward calculation.

### GS-07 — Gold formula
- Base Gold: binary 5, count 5, duration 6.
- First vow completed today: +2 Gold.
- All planned vows completed today: +5 Gold.

### GS-08 — Level curve and rank thresholds
- Use the locked cumulative Resonance thresholds from the economy spec for ranks 1–15.
- Day-one target: a typical user levels up at least once after completing one or two starter vows.
- Server remains authoritative for rank changes.

### GS-09 — Chain system rules
- A chain counts consecutive scheduled-day completions for one vow.
- Non-scheduled days never break the chain.
- Track current chain, best chain, and status markers for UI.

### GS-10 — Ember state rules
- Free cap: 2 Embers.
- Cooling begins after one missed scheduled occurrence.
- Ember state is user-level for available inventory and vow-level for most recent cooling marker.

### GS-11 — Rekindling rules
- First playable default: if the user returns within 72 hours of a cooling state and has an Ember available, the system may consume one Ember to preserve continuity and mark the vow as rekindled.
- If no Ember is available or the window expires, the chain breaks but heat degrades rather than resetting identity.
- This bundle does not add a separate Ember spending screen.

### GS-12 — Daily completion state model
- States: `not_started`, `in_progress`, `completed`, `perfect_day`, `cooling`, `rekindled`.
- Today uses the day-level result, not raw event history, for fast clarity.

### GS-13 — 7-day starter arc logic
- The starter arc advances on unique local days with at least one completed vow.
- Day 1 triggers the first magical moment and moves Ember Quay to `stirring`.
- Days 2–6 advance quests, dialogue, and district repair visibility.
- Day 7 resolves `The Ember That Returned` and moves Ember Quay to `rekindled`.

### GS-16 — District restoration state machine
- Stages: `dim` -> `stirring` -> `rebuilding` -> `rekindled`.
- Transition inputs: starter-arc progress day, same-session first magical moment, and cumulative quest advancement.
- World presentation reads the current stage; it never infers stage from ad hoc UI booleans.

### GS-21 — Free vs premium gating rules
- Free active-vow cap: 3.
- Premium breadth deferred in this bundle: 7 active vows, deeper Chapter One, advanced witness surfaces, and expanded expression.
- Premium does not bypass completion requirements, chain rules, or world progression logic.

## Output / canonical artifact
- This systems pack
- Expanded remote-config defaults and launch content payloads

## Edge cases
- Offline completions remain valid and reconcile later.
- Entitlement downgrade affects future breadth, never historical completions or already-earned rewards.
- Starter-arc progression is driven by unique completion days, not raw completion count spam.

## Explicit non-goals
- deep item economy balancing
- premium Chapter One tuning
- shop or inventory mechanical depth beyond starter reward references
