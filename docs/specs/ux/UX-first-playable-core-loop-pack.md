# UX First Playable Core Loop Pack

## Purpose
Lock the first-playable free-path UX from entry through the first magical moment and the 7-day starter arc so iOS, backend, content, and QA build one utility-first journey.

## Why it exists
The foundation shell is in place, but the core loop still needs canonical flow, surface hierarchy, and recovery behavior before feature code can safely deepen beyond placeholders.

## Inputs / dependencies
- `AGENTS.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/05_Narrative_Content_Launch_Spec.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`
- `docs/specs/source-of-truth/ST-10_string_key_registry_copy_token_structure.md`

## Sections
### UX-01 — Global information architecture + tab navigation spec
- Purpose: Keep Today as the utility-first landing surface while World stays the emotional witness layer.
- Canonical flow: `Today`, `World`, `Hearth`, `Profile`.
- Default post-onboarding landing: `Today`.
- Cross-surface rule: vow logging is always available from Today without requiring navigation into World.
- Acceptance criteria: tab order is stable, Today owns the fastest completion path, World never blocks habit utility.
- Non-goals: restructuring the four-tab shell or adding a fifth launch tab.

### UX-03 — Onboarding flow spec
- Flow: promise cards -> optional Apple sign-in / continue as guest -> goals -> life areas -> blocker -> daily load -> tone -> family -> identity -> avatar basics -> starter vows -> first magical moment -> soft paywall preview -> Today.
- Pacing budget: target under four minutes, cut optionality before adding more steps.
- Recovery: onboarding progress persists locally; network loss never ejects the user from guest-mode onboarding.
- Acceptance criteria: no dead ends, no premium gate before the first magical moment, guest mode remains valid.

### UX-04 — Identity selection spec
- Step 1: select one of four origin families with plain-language framing and one mythic accent line.
- Step 2: select one of ten identity shells within the chosen family.
- Free-path rule: the user may choose any one launch identity; premium breadth is deferred to later identity switching and Chapter One depth.
- Acceptance criteria: all 4 families and all 10 shells are visible on the first playable path.

### UX-05 — Avatar setup spec
- Fields: name, pronouns optional, silhouette, palette, accessory accent.
- Constraint: keep the avatar setup to one screen with immediate preview.
- Defaulting: prefill a starter silhouette per family so the user can continue without opening customizers.
- Acceptance criteria: avatar setup can be completed in under 30 seconds and remains skippable except for a name.

### UX-06 — Starter vow recommendation flow spec
- Input sources: selected life areas, blocker, tone mode, daily load, family flavor.
- Recommendation rules: default to 3 vows, include at least one low-friction vow, never recommend more than one duration-heavy vow by default, prefer minimum viable consistency over aspirational overload.
- User controls: accept all, edit inline, replace one recommendation, or add a custom vow.
- Acceptance criteria: a believable starter set of 3 vows is reachable without manual creation.

### UX-07 — First magical moment spec
- Trigger: the first successfully logged vow in the same onboarding session.
- Sequence: reward modal -> brief witness narration -> visible Ember Quay change -> tomorrow-return prompt.
- Core requirement: world consequence must be visible in the same session as the first kept vow.
- Acceptance criteria: the user sees a concrete world-state change before any monetization offer.

### UX-08 — Paywall + trial flow spec
- Placement: informational soft paywall sheet appears after the first magical moment and may be dismissed.
- Free-path framing: primary value is “keep building your world”; secondary action keeps the free path.
- Scope note: this pack defines placement, copy intent, and free-path continuity only. StoreKit and entitlement implementation follow in the next bundle.
- Acceptance criteria: the free path continues immediately after dismissing the offer.

### UX-09 — Today screen spec
- Layout priority: chapter/date header -> vow list -> quick-log controls -> quest card -> chain/ember strip -> CTA into World.
- Quick-log rule: binary completion in one tap; count and duration completion in two taps or fewer.
- Empty state: if no active vows exist, Today offers starter vow creation before any world affordance.
- Acceptance criteria: Today remains the default home surface and makes logging visibly faster than navigating elsewhere.

### UX-10 — Add / edit / archive vow flow spec
- Add/edit surfaces use one sheet with inline fields for title, category, type, target, cadence, and reminder.
- Archive is reversible only through re-creation in this bundle; history remains visible in reporting later.
- Cap handling: if the free active-vow cap is reached, the flow offers edit/archive instead of dead-ending.
- Acceptance criteria: the user can accept starter vows, edit a recommendation, or archive an active vow without losing history.

### UX-12 — Quick-log interaction spec
- Binary vows: direct tap toggles completion and immediately shows reward feedback.
- Count/duration vows: first tap opens a compact progress sheet, second tap confirms the amount.
- Offline behavior: Today acknowledges the log immediately and surfaces that sync is queued when needed.
- Acceptance criteria: quick logging never requires entering the vow detail screen.

### UX-13 — Chapter card + quest journal spec
- Today card shows active chapter title, current day beat, and one next action.
- Quest journal expands into the 7-day starter arc day list with completed/current/upcoming states.
- The chapter card owns the “return tomorrow” prompt once day-one completion is done.
- Acceptance criteria: day-one quest progress and the 7-day arc are legible without lore-heavy jargon.

### UX-14 — Reward modal + level-up + chest spec
- Reward modal always shows utility-first numbers first: Resonance, Gold, and the world consequence summary.
- First session variant emphasizes “your world responds” over inventory depth.
- Level-up presentation may stack into the reward modal rather than opening a second full-screen blocker.
- Acceptance criteria: same-session reward feedback is immediate and skippable.

### UX-15 — World screen spec
- Composition: compact portrait district scene, tappable NPC witness cards, current district restoration stage, and one highlighted consequence callout.
- Motion rule: the scene is lightweight and supportive; logging never depends on it.
- First playable content: Ember Quay only, with stage changes from dim -> stirring -> rebuilding -> rekindled.
- Acceptance criteria: the first completion visibly changes the world tab.

### UX-25 — Loading / empty / error / offline UX spec
- Bind to `ST-09` state IDs rather than inventing feature-local recovery copy.
- Non-blocking principle: cached content or local state is preferred over blank failure surfaces.
- Humane language: sync issues and misses are framed as recoverable system states, never personal failure.
- Acceptance criteria: onboarding, Today, reward, and world states all have a graceful offline/degraded path.

### UX-27 — Accessibility annotations for primary flows
- VoiceOver labels are required for onboarding answers, identity options, quick-log buttons, reward summaries, and world witness CTAs.
- Reduced-motion path swaps large scene movement for fades/highlights.
- Color is never the only indicator for completion, cooling, or rekindled state.
- Acceptance criteria: the first playable path remains understandable with VoiceOver and reduced motion enabled.

## Output / canonical artifact
- This spec pack
- Expanded launch content and copy in `content/launch/`

## Edge cases
- Apple sign-in failure falls back cleanly to guest mode.
- Dismissing the soft paywall must not reset onboarding or vows.
- World state may render from local cache if content or sync is unavailable.

## Explicit non-goals
- StoreKit purchase implementation
- widgets, Live Activities, or HealthKit flows
- Hearth, inventory, or shop depth beyond the first-playable loop
