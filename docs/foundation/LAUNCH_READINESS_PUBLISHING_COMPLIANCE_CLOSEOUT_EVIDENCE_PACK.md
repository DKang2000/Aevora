# Launch Readiness, Publishing, and Compliance Closeout Evidence Pack

## Bundle summary
This bundle finishes the last major non-art launch-readiness pass for Aevora v1. It adds guarded admin publishing surfaces, support-safe account export/delete hardening, launch dashboard/reporting SQL, iOS account-surface safety improvements, operator runbooks, and App Store/privacy/support documentation without broadening locked v1 scope.

## Backend / Ops / Account lifecycle / Publishing
`BE-21 / BE-22 / BE-24 / OPS-07 / OPS-08 / OPS-09 complete`

Canonical artifact: `docs/specs/backend/BE-launch-readiness-publishing-compliance-pack.md`

Supporting files created/updated:
- `docs/specs/ops/OPS-launch-readiness-publishing-compliance-pack.md`
- `backend/apps/api/src/admin/*`
- `backend/apps/api/src/runtime-config/runtime-config.service.ts`
- `backend/apps/api/src/content/content.service.ts`
- `backend/apps/api/src/account/account.controller.ts`
- `backend/apps/api/src/core-loop/core-loop.service.ts`
- `backend/apps/api/scripts/validate-runtime-config-release.ts`
- `backend/apps/api/scripts/validate-content-release.ts`
- `backend/apps/api/scripts/validate-asset-manifest.ts`
- `shared/contracts/assets/asset-version-manifest.v1.schema.json`
- `shared/contracts/api/aevora-v1.openapi.yaml`
- `ops/assets/README.md`
- `ops/assets/manifests/launch-assets.v1.json`
- `ops/publishing/README.md`
- `ops/publishing/remote-config.md`
- `ops/publishing/content.md`
- `ops/publishing/assets.md`

Validation run:
- `corepack pnpm --filter @aevora/api typecheck`
- `corepack pnpm --filter @aevora/api test`
- `corepack pnpm --filter @aevora/api validate:remote-config-release`
- `corepack pnpm --filter @aevora/api validate:content-release`
- `corepack pnpm --filter @aevora/api validate:asset-manifest`
- `ruby -e "require 'yaml'; YAML.load_file('shared/contracts/api/aevora-v1.openapi.yaml')"`

Key decisions:
- kept launch admin as guarded API routes instead of creating a second admin app
- made publish/promote state file-backed and repo-path constrained
- kept asset ingestion placeholder-safe through a manifest contract rather than inventing a fake CDN implementation
- enriched account export/delete responses instead of inventing a new lifecycle API family

Conflicts or assumptions:
- promoted release state is file-backed for launch readiness and not yet a full multi-environment control plane
- export remains support-safe and summary-oriented rather than a full legal fulfillment pipeline

Downstream sections unblocked:
- `IOS-20`
- `IOS-31`
- `DATA-05`
- `DATA-06`
- `DATA-07`
- `DATA-08`
- `DATA-09`
- `DATA-13`
- `OPS-06`
- `OPS-11`
- `QA-17`
- `QA-19`
- `QA-20`
- `QA-21`
- `QA-22`

Anything still missing:
- signed TestFlight promotion proof still depends on Apple signing/App Store Connect secrets
- App Store sandbox / receipt-verification depth remains an external operational gap

## Data dashboards and reporting
`DATA-05 / DATA-06 / DATA-07 / DATA-08 / DATA-09 / DATA-13 complete`

Canonical artifact: `docs/specs/data/DATA-launch-readiness-dashboard-pack.md`

Supporting files created/updated:
- `backend/packages/analytics-schema/warehouse/README.md`
- `backend/packages/analytics-schema/warehouse/sql/marts/mart_activation_kpis.sql`
- `backend/packages/analytics-schema/warehouse/sql/marts/mart_onboarding_conversion_daily.sql`
- `backend/packages/analytics-schema/warehouse/sql/marts/mart_subscription_conversion_daily.sql`
- `backend/packages/analytics-schema/warehouse/sql/marts/mart_retention_cohorts.sql`
- `backend/packages/analytics-schema/warehouse/sql/marts/mart_economy_health_daily.sql`
- `backend/packages/analytics-schema/warehouse/sql/support/support_account_lookup.sql`
- `backend/packages/analytics-schema/warehouse/sql/support/support_subscription_lookup.sql`
- `backend/packages/analytics-schema/warehouse/sql/support/support_reward_audit.sql`
- `backend/packages/analytics-schema/warehouse/sql/support/support_return_surface_lookup.sql`

Validation run:
- `corepack pnpm --filter @aevora/api validate:analytics`
- `corepack pnpm --filter @aevora/api validate:datasets`
- `corepack pnpm typecheck`
- `corepack pnpm test`

Key decisions:
- extended the existing tool-neutral warehouse scaffold instead of introducing warehouse-vendor config
- kept economy health metrics count-based and event-derived to avoid inventing non-canonical payload parsing
- created support lookup SQL as query templates, not a support dashboard product

Conflicts or assumptions:
- no SQL linter or warehouse runtime exists in-repo, so validation remains schema/event/dataset oriented
- production-scale retention interpretation still depends on real volume after beta usage begins

Downstream sections unblocked:
- beta KPI review
- launch support investigation
- monetization continuity checks
- economy watch and reward-inflation review

Anything still missing:
- no production scheduler/orchestration for marts in this repo
- no experiment-assignment framework expansion beyond current event metadata

## iOS, QA, compliance, and runbooks
`IOS-20 / IOS-31 / QA-12 / QA-14 / QA-15 / QA-17 / QA-19 / QA-20 / QA-21 / QA-22 / OPS-06 / OPS-11 complete`

Canonical artifact: `docs/specs/ios/IOS-launch-readiness-account-hardening-pack.md`

Supporting files created/updated:
- `docs/specs/qa/QA-launch-readiness-compliance-pack.md`
- `docs/specs/ops/OPS-launch-readiness-runbooks-pack.md`
- `ios/Aevora/Features/Account/AccountSurfaceStore.swift`
- `ios/Aevora/Features/Profile/ProfileRootView.swift`
- `ios/AevoraTests/Account/AccountSurfaceStoreTests.swift`
- `docs/operations/app-store-metadata-pack.md`
- `docs/operations/privacy-policy.md`
- `docs/operations/terms-of-service.md`
- `docs/operations/support-site-pack.md`
- `docs/operations/app-privacy-nutrition-label.md`
- `docs/operations/age-rating-disclosure.md`
- `docs/operations/launch-faq-and-macros.md`
- `docs/operations/launch-qa-matrix.md`
- `ops/runbooks/backup-restore.md`
- `ops/runbooks/incident-response.md`
- `ops/runbooks/hotfix.md`

Validation run:
- `xcodegen generate --spec ios/project.yml`
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'`
- `corepack pnpm typecheck`
- `corepack pnpm test`
- `ruby -e "require 'yaml'; YAML.load_file('.github/workflows/testflight.yml')"`

Key decisions:
- hardened delete into a reviewed confirmation flow while preserving local-first reset behavior
- kept export preview local-first on device and documented backend deletion/export as support/ops surfaces
- put submission/legal/support copy into existing `docs/operations/` and runbooks into `ops/runbooks/`

Conflicts or assumptions:
- privacy policy and terms are launch-ready technical drafts and still need final legal review
- signed TestFlight and App Store Connect questionnaire submission are external to this repo

Downstream sections unblocked:
- internal beta handoff
- launch support prep
- App Store metadata/compliance assembly
- incident and hotfix response drills

Anything still missing:
- final legal sign-off
- final App Store Connect questionnaire entry
- final screenshot assets (`QA-18`)

## Integrated validation summary
- `corepack pnpm typecheck` succeeded
- `corepack pnpm test` succeeded
- `corepack pnpm --filter @aevora/api typecheck` succeeded
- `corepack pnpm --filter @aevora/api test` succeeded
- `corepack pnpm --filter @aevora/api validate:analytics` succeeded
- `corepack pnpm --filter @aevora/api validate:datasets` succeeded
- `corepack pnpm --filter @aevora/api validate:remote-config-release` succeeded
- `corepack pnpm --filter @aevora/api validate:content-release` succeeded
- `corepack pnpm --filter @aevora/api validate:asset-manifest` succeeded
- `xcodegen generate --spec ios/project.yml` succeeded
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'` succeeded
- `.github/workflows/testflight.yml` YAML parse succeeded
- `shared/contracts/api/aevora-v1.openapi.yaml` YAML parse succeeded

## Remaining operational-only gaps
- no signed TestFlight dry run was executed because Apple signing and App Store Connect secrets are not configured in this environment
- no full App Store sandbox / receipt-verification proof was executed in this environment
- privacy policy and terms still need final legal review outside the repo
- App Store Connect metadata, age rating, and nutrition-label forms still require manual entry during submission

## Deferred to art stage
- `QA-18` App Store screenshots / preview assets
- `ART-01` through `ART-19` production art, environment assets, item art, FX, animation, and polished marketing visuals
- final visual integration pass tied to produced assets

## Next likely bundle
The next likely bundle is the first art-production bundle. Priority should start with:
- `ART-01` visual target sheets
- `ART-02` brand mark and app icon direction
- `ART-03` color, typography, and design token kit
- `ART-04` UI component art kit
- `ART-05` onboarding illustration/card set
- then the highest-leverage production assets for the already-built launch surfaces (`ART-06` onward)
