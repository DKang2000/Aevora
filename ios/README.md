# iOS

This folder is the canonical home for the native iPhone client, widgets, Live Activities, and supporting configuration.

## Foundation shell
- Xcode project generation is owned by `ios/project.yml` via XcodeGen.
- App source lives under `ios/Aevora/`.
- Unit tests live under `ios/AevoraTests/`.

## Common commands
- Generate the project: `xcodegen generate --spec ios/project.yml`
- Build or test after generation with `xcodebuild`

## Primary upstream sources
- `docs/specs/ios/IOS-01_app_shell_and_navigation_architecture.md`
- `docs/specs/ios/IOS-07_local_persistence_layer_swiftdata.md`
- `docs/specs/ios/IOS-08_networking_client_sync_queue.md`
- `docs/specs/ios/IOS-26_remote_config_feature_flags_client.md`
- `docs/specs/ios/IOS-27_analytics_instrumentation_layer.md`
- `docs/specs/ios/IOS-28_crash_reporting_structured_client_logging.md`
- `docs/specs/ios/IOS-30_offline_banners_sync_conflict_ui.md`
- `docs/specs/ios/IOS-32_internal_debug_menu_seed_dev_utilities.md`
- `shared/contracts/`

## Guardrail
The client implements product truth. It does not become the source of truth for schemas, scope, or entitlement rules.
