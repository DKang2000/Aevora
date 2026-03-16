# Monetization, Account, and Glance Closeout Evidence Pack

Date: 2026-03-16
Scope: soft paywall, trial/purchase/restore/downgrade continuity, account/settings surfaces, free and premium glanceable return surfaces, analytics/QA scaffolding

## `<MONETIZATION_ACCOUNT_GLANCE> complete`

Canonical artifact:
- `docs/specs/backend/BE-monetization-account-glance-pack.md`
- `docs/specs/ios/IOS-monetization-account-glance-pack.md`
- `docs/specs/ux/UX-monetization-account-glance-pack.md`
- `docs/specs/qa/QA-monetization-account-glance-pack.md`
- `docs/specs/data/DATA-07_subscription_conversion_reporting.md`
- `docs/specs/data/DATA-08_retention_and_return_surface_reporting.md`
- `shared/contracts/api/aevora-v1.openapi.yaml`

Supporting files created/updated:
- `backend/apps/api/src/subscription/`
- `backend/apps/api/src/account/`
- `backend/apps/api/src/glance/`
- `backend/apps/api/src/core-loop/core-loop.service.ts`
- `ios/Aevora/Features/Account/AccountSurfaceStore.swift`
- `ios/Aevora/Core/Glance/`
- `ios/Aevora/Core/Notifications/`
- `ios/AevoraWidgets/`
- `backend/packages/analytics-schema/warehouse/sql/marts/`

Validation run:
- `corepack pnpm typecheck` — pass
- `corepack pnpm test` — pass
- `corepack pnpm --filter @aevora/api typecheck` — pass
- `corepack pnpm --filter @aevora/api test` — pass
- `DATABASE_URL='postgresql://donghokang@localhost:5432/aevora_test?schema=public' corepack pnpm --filter @aevora/api prisma:validate` — pass
- `DATABASE_URL='postgresql://donghokang@localhost:5432/aevora_test?schema=public' corepack pnpm --filter @aevora/api migrate:deploy` — pass
- `DATABASE_URL='postgresql://donghokang@localhost:5432/aevora_test?schema=public' corepack pnpm --filter @aevora/api test:postgres` — pass
- `corepack pnpm --filter @aevora/api validate:analytics` — pass
- `corepack pnpm --filter @aevora/api validate:datasets` — pass
- `xcodegen generate --spec ios/project.yml` — pass
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17'` — pass

Key decisions:
- Keep the soft paywall informative and dismissible after the first magical moment.
- Let the backend remain authoritative for entitlement state while keeping the current local-first client loop responsive.
- Gate deeper witness breadth, not the base starter path, behind premium entitlement.
- Stay pre-art-stage and rely on placeholder widget/presentation assets where needed.

Conflicts or assumptions:
- Delete/export remain minimum viable continuity surfaces rather than full compliance workflows.
- StoreKit breadth is intentionally thin; the bundle models purchase lifecycle coherently without broadening commerce scope.

Downstream sections unblocked:
- QA-10 / QA-11 widget and notification regression work
- later HealthKit/App Intents hardening bundle
- beta-ready monetization and return-loop validation

Anything still missing:
- Full App Store sandbox billing verification
- Signed TestFlight proof with Apple secrets configured
- Art-final monetization and widget visual polish
