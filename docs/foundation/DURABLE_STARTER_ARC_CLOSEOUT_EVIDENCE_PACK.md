# Durable Starter Arc Closeout Evidence Pack

Date: 2026-03-16
Scope: BE durable starter-arc hardening, IOS durable starter-arc surfaces, starter-arc retention specs, targeted QA validation

## Purpose
Record the current landed state of the durable starter-arc bundle against the repo’s canonical roots and the next-build execution brief.

## Validation evidence used in this pack
- `corepack pnpm --filter @aevora/api typecheck` — pass
- `corepack pnpm --filter @aevora/api test -- core-loop.e2e-spec.ts` — pass
- `DATABASE_URL='postgresql://aevora:aevora@localhost:5432/aevora_test?schema=public' corepack pnpm --filter @aevora/api prisma:validate` — pass
- `xcodegen generate --spec ios/project.yml` — pass
- `xcodebuild test -project ios/Aevora.xcodeproj -scheme Aevora -destination 'platform=iOS Simulator,name=iPhone 17' -only-testing:AevoraTests/FirstPlayableStoreTests` — pass

## Landed outcomes
- Backend core-loop state now survives relaunch through a durable store instead of process-local maps, while preserving existing ST-02 route shapes.
- Prisma schema and migration coverage were extended for level, ember, chain, and inventory durability.
- Backend starter-arc coverage now explicitly validates relaunch continuity and day-seven arc completion.
- iOS first-playable state now persists a durable local starter-arc snapshot through SwiftData.
- Today, Quest Journal, World, Reward, Hearth, and Inventory surfaces now expose day-by-day starter-arc continuity rather than a day-one-only loop.
- iOS starter-arc tests now validate persistence round-trip and multi-day progression continuity.

## Remaining known gaps
- Runtime backend validation in this environment still uses the durable file-backed store path; local Postgres was not reachable at `localhost:5432`, so Prisma-backed runtime execution could not be exercised end-to-end here.
- Full notification permission / OS scheduling flow is still narrower than the bundle brief; the current implementation exposes in-app reminder and witness prompt surfaces plus starter reminder metadata.
- Full iOS test suite was not rerun in this closeout pass; targeted starter-arc tests were executed.

## Smallest next canonical patch
- Activate the Prisma-backed runtime path once a reachable local/staging Postgres is available, then rerun backend integration coverage against that storage mode.
- Expand the narrow reminder surface into true local notification scheduling and permission education without broadening into widgets or Live Activities.

## Recommended next bundle
- Monetization + Witness Surfaces, after Prisma runtime activation and starter-arc reminder hardening are validated.
