# UX Verified Inputs, Notifications, and Automation Pack

## Purpose
Define how reminder prompts, witness returns, verified-input education, and shortcuts accelerate the core loop without turning Aevora into a settings-heavy utility.

## Why it exists
The core loop, monetization, and Chapter One value surfaces are now in place. This pack ensures the launch utility layer is clear, sparse, and supportive so users can return quickly, trust what was verified, and never lose the manual path.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`
- `docs/specs/source-of-truth/ST-10_string_key_registry_copy_token_structure.md`
- `docs/specs/ux/UX-monetization-account-glance-pack.md`

## Sections
### UX-22 — Notification education and prompt timing
- Notification education appears only after onboarding is complete and the user has already seen value in Today or a reward/witness beat.
- Reminder delivery stays sparse: per-vow reminder, evening witness prompt, streak-risk prompt, and next-chapter prompt are the only launch-safe categories.
- Notification taps must deep-link directly into `Today`, `World`, or `Quest Journal`; they never land on a generic home shell first.
- If OS delivery is off, the app explains that in-app return cues still exist and routes the user to system settings only from contextual education or settings.

### Narrow UX-21 patch — Permission education
- HealthKit permission education appears only when the user has premium breadth and a relevant Physical/Rest-style vow pattern that can plausibly match a supported verified domain.
- HealthKit copy must state that verification is narrow, optional, and additive to manual logging.
- Notification and HealthKit denial states use plain utility language, not lore framing.

### Narrow UX-23 / UX-24 patch — Witness surface trust
- Widget and Live Activity witness surfaces must reflect the same chapter/day/progress state as Today and World.
- Return surfaces may be glanceable, but they cannot become a more complete task surface than Today.

### NC-13 — Copy additions
- Notification copy stays warm and direct: reminder, witness, streak-risk, and chapter-ready states should sound supportive rather than urgent.
- Verified-input badges use short labeling such as `Verified`; explanatory copy must mention manual fallback.
- Shortcut labels must mirror the app surfaces exactly: `Open Today`, `Open World`, `Open Quest Journal`, and `Complete Vow`.

## Output / canonical artifact
- This UX pack
- Launch copy additions under `content/launch/copy/en/core.v1.json`
- iOS implementations under `ios/Aevora/Features/Today`, `ios/Aevora/Features/Profile`, and automation/notification wiring under `ios/Aevora/Core`

## Edge cases
- Notification permission denial cannot block the free path or hide Today logging.
- Verified-input education must not appear for free users or for vow shapes that cannot be verified safely.
- Shortcut actions must still work for guest users and must not imply account linking is required.

## Explicit non-goals
- Apple Watch or lock-screen-only task completion models
- broad reminder preference matrices
- lore-heavy permission copy
