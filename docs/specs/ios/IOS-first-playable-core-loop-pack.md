# IOS First Playable Core Loop Pack

## Purpose
Define the first-playable iOS implementation surfaces that sit on top of the foundation shell, sync queue, analytics layer, and SwiftData boundary.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/ios/IOS-01_app_shell_and_navigation_architecture.md`
- `docs/specs/ios/IOS-07_local_persistence_layer_swiftdata.md`
- `docs/specs/ios/IOS-08_networking_client_sync_queue.md`
- `docs/specs/ios/IOS-26_remote_config_feature_flags_client.md`
- `docs/specs/ios/IOS-27_analytics_instrumentation_layer.md`
- `docs/specs/ios/IOS-28_crash_reporting_structured_client_logging.md`
- `docs/specs/ios/IOS-30_offline_banners_sync_conflict_ui.md`
- `docs/specs/ios/IOS-32_internal_debug_menu_seed_dev_utilities.md`
- `docs/specs/ux/UX-first-playable-core-loop-pack.md`
- `docs/specs/game-systems/GS-first-playable-core-loop-pack.md`
- `docs/specs/narrative/NC-first-playable-core-loop-pack.md`

## Sections
### IOS-02 — Sign in with Apple + guest mode + account linking
- Guest mode is the first guaranteed path.
- Sign in with Apple is available at entry and as a later linking action.
- Linking preserves locally authored vows and starter-arc state.

### IOS-03 — Onboarding implementation
- Onboarding is a gated full-screen flow shown until the profile reaches `completed`.
- Progress persists locally between launches.
- Analytics instrument onboarding start, step completion, family selection, identity selection, and onboarding completion.

### IOS-04 — Identity and avatar setup implementation
- Family, identity, and avatar setup share one coordinated state model so starter-vow recommendations can use the chosen tone and identity immediately.
- Avatar editing remains intentionally shallow: name, palette, silhouette, accessory accent.

### IOS-05 — Starter vow recommendation implementation
- Recommendations are generated locally from launch content plus onboarding answers.
- The user may edit category, title, type, target, cadence, and reminder before confirming.

### IOS-09 — Vow CRUD module
- Starter and manual vows share the same local model and quick-edit sheet.
- Active-vow cap enforcement happens in the UI using cached entitlement state before later server reconciliation.

### IOS-11 — Today screen implementation
- Today is the default landing surface after onboarding.
- It renders chapter context, vow cards, quick-log controls, quest progress, and chain/ember summaries from local-first state.

### IOS-12 — Quick logging + partial progress interactions
- Binary logs are one tap.
- Count and duration logs use a compact stepper sheet and save immediately to local state plus the sync queue.
- Offline acknowledgements use the shared sync status store.

### IOS-13 — Reward presentation flows
- Reward presentation is modal and brief.
- It communicates numbers first, then the world consequence, then offers a CTA into World or tomorrow’s next quest beat.

### IOS-14 — Quest journal + chapter state views
- Today hosts the compact chapter card.
- Quest Journal expands into the 7-day beat list without becoming a separate navigation stack root.

### IOS-15 — World tab container (SwiftUI + SpriteKit)
- SpriteKit is scoped to the compact district witness scene.
- SwiftUI owns NPC witness cards, stage labels, and accessibility overlays.

### IOS-29 — Accessibility support
- VoiceOver labels, reduced-motion presentation, and non-color state indicators are wired into onboarding, Today, reward, and World flows from the start.

## Output / canonical artifact
- This pack
- New first-playable feature code under `ios/Aevora/Features/`

## Edge cases
- Local-first completion cannot block on the world tab or backend reachability.
- If bundle content cannot load, the app falls back to safe starter defaults and logs the miss.
- Sync conflict presentation stays shared instead of feature-local.

## Explicit non-goals
- StoreKit purchase implementation
- widgets, Live Activities, notifications, or HealthKit
- deeper Hearth/profile surfaces beyond what the first-playable loop needs
