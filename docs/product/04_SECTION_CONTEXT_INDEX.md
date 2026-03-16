# Section Context Index

This file maps build-register sections to their primary source docs in the current repo layout.

## Assignment index
The canonical assignment list is `docs/product/Aevora_V1_Master_Build_Register.md`.

## Section-to-doc mapping
- `ST-*`: `docs/specs/source-of-truth/` plus the relevant locked product docs in `docs/product/`
- `UX-*`: primarily `docs/product/02_v1_PRD.md`, `docs/product/03_Onboarding_Paywall_Spec.md`, `docs/product/08_Art_UI_System_Spec.md`
- `GS-*`: primarily `docs/product/04_Game_Economy_Spec.md`
- `NC-*`: primarily `docs/product/05_Narrative_Content_Launch_Spec.md`
- `ART-*`: primarily `docs/product/08_Art_UI_System_Spec.md` and `docs/product/05_Narrative_Content_Launch_Spec.md`
- `IOS-*`, `BE-*`, `OPS-*`, `QA-*`: primarily `docs/product/06_Technical_Architecture_Spec.md`, then add section-specific source docs
- `DATA-*`: primarily `docs/product/07_Analytics_Event_Taxonomy.md` and `docs/product/06_Technical_Architecture_Spec.md`

## Canonical repo roots
- iOS implementation root: `ios/`
- backend implementation root: `backend/apps/api/`
- backend executable shared packages: `backend/packages/`
- canonical machine-readable contracts: `shared/contracts/`
- ops and workflow artifacts: `ops/` and `.github/workflows/`

## Repo-first substitutions
- pack-default `apps/ios` routes to `ios/`
- pack-default `services/api` routes to `backend/apps/api/`
- pack-default `packages/contracts` routes to `shared/contracts/`
- pack-default `packages/analytics-schema` routes to `backend/packages/analytics-schema/` for executable code while shared event truth remains under `shared/contracts/events/`
- external references to `docs/product/05_REPO_ROUTING_MAP.md` should use this file in this repo

## Rule
Do not assign a section from its short title alone. Pair the section ID with `AGENTS.md`, the relevant source docs, and a brief from `docs/AGENT_BRIEF_TEMPLATE.md`.
