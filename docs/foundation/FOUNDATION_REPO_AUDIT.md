# Foundation Repo Audit

## Purpose
Record the current repository state before foundation implementation begins so bundle execution can reuse coherent existing roots without introducing competing structures.

## Inputs
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/04_SECTION_CONTEXT_INDEX.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `/Users/donghokang/Downloads/Aevora_Foundation_Implementation_Codex_Pack/docs/FI_SHARED_CONTEXT.md`
- `/Users/donghokang/Downloads/Aevora_Foundation_Implementation_Codex_Pack/docs/FI_EXECUTION_ORDER.md`
- `/Users/donghokang/Downloads/Aevora_Foundation_Implementation_Codex_Pack/docs/FI_OUTPUT_MAP.md`
- `/Users/donghokang/Downloads/Aevora_Foundation_Implementation_Codex_Pack/docs/foundation_bundle_manifest.yaml`
- `/Users/donghokang/Downloads/Aevora_Foundation_Implementation_Codex_Pack/prompts/00A_FOUNDATION_REPO_AUDIT_PROMPT.md`

## Audit answers
### 1. JS/TS workspace manager
- No executable repo-wide JS/TS workspace manager is present.
- No root `package.json`, `pnpm-workspace.yaml`, `yarn.lock`, `package-lock.json`, `turbo.json`, or `nx.json` was found.
- Adopt pack default: `pnpm workspaces`.

### 2. Backend framework or service skeleton
- No executable backend framework bootstrap is present.
- The canonical backend root already exists at `backend/`.
- The implementation home from the pack should be adapted from `services/api` to `backend/apps/api`.
- Adopt pack default for implementation: `NestJS`.

### 3. ORM or migration system
- No executable ORM or migration system is present.
- The canonical backend data roots already exist at `backend/migrations` and `backend/packages`.
- Adopt pack default for implementation: `Prisma` with Postgres migrations under the existing backend root.

### 4. iOS project, workspace, or generator
- No executable iOS project, Xcode workspace, Swift package, or project generator is present.
- The canonical iOS root already exists at `ios/`.
- The implementation home from the pack should be adapted from `apps/ios` to `ios/`.
- Adopt pack default for implementation: `XcodeGen`.

### 5. CI workflows
- GitHub Actions already exists at `.github/workflows/ci-placeholder.yml`.
- The current workflow is only a placeholder and does not yet implement real validation or deployment.
- Keep pack default: `GitHub Actions`.

### 6. ST machine-readable artifacts present and parseable
- Present and parseable:
  - `shared/contracts/domain-model/aevora-domain-model.v1.yaml`
  - `shared/contracts/api/aevora-v1.openapi.yaml`
  - `shared/contracts/client-local-storage/aevora-local-store.v1.schema.json`
  - `shared/contracts/events/event-catalog.v1.yaml`
  - `shared/contracts/events/schemas/*.json`
  - `shared/contracts/remote-config/remote-config.v1.schema.json`
  - `shared/contracts/remote-config/defaults/launch-defaults.v1.json`
  - `shared/contracts/content/content-config.v1.schema.json`
  - `shared/contracts/entitlements/entitlement-matrix.v1.json`
  - `shared/contracts/permissions/permission-matrix.v1.json`
  - `shared/contracts/localization/string-key-registry.v1.json`
  - `shared/contracts/ui-states/state-catalog.v1.json`
  - `shared/contracts/acceptance/acceptance-matrix.v1.json`
  - launch content under `content/launch/`

### 7. Default assumptions adopted versus overridden
#### Adopted
- `pnpm workspaces`
- `NestJS`
- `Prisma`
- `XcodeGen`
- `GitHub Actions`

#### Overridden by repo structure
- Pack implementation home `apps/ios` -> repo canonical root `ios/`
- Pack implementation home `services/api` -> repo canonical root `backend/apps/api`
- Pack shared-contract assumption `packages/contracts` -> repo canonical root `shared/contracts`
- Pack backend shared-code assumption `packages/*` -> repo canonical root `backend/packages`
- Pack data implementation home `packages/analytics-schema` -> repo roots `backend/packages` for executable code and `shared/contracts/events` for shared event schemas

### 8. Conflicts between current repo structure and expected implementation homes
- The pack expects `apps/ios` and `services/api`; the repo already reserves `ios/` and `backend/` as canonical homes.
- The pack references `packages/contracts`; this repo already uses `shared/contracts` as the canonical shared-contract root.
- The pack references source docs that do not exist under the same paths in this repo. Use these substitutions:
  - `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`
  - `docs/product/foundation/02_v1_PRD.md` -> `docs/product/02_v1_PRD.md`
  - `docs/product/foundation/06_Technical_Architecture_Spec.md` -> `docs/product/06_Technical_Architecture_Spec.md`
  - `docs/product/foundation/08_Art_UI_System_Spec.md` -> `docs/product/08_Art_UI_System_Spec.md`

## Canonical implementation homes for this repo
- Backend service code: `backend/apps/api/`
- Backend shared packages: `backend/packages/`
- Backend migration history: `backend/migrations/`
- iOS app and tests: `ios/`
- Shared machine-readable contracts: `shared/contracts/`
- Infra and ops artifacts: `infra/` and `.github/workflows/`
- Canonical section docs:
  - `docs/specs/backend/`
  - `docs/specs/data/`
  - `docs/specs/ios/`
  - `docs/specs/ops/`

## Conclusions
- The repository already has coherent top-level roots and canonical contract locations.
- Foundation implementation should reuse those roots instead of creating parallel trees from pack defaults.
- Default tooling choices from the foundation pack remain valid where executable scaffolding is still missing.
