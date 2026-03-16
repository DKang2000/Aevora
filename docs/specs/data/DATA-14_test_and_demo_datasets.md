# DATA-14 — Test and Demo Datasets

## Purpose
Provide a compact synthetic scenario pack for backend seeding, analytics validation, QA, and future iOS debug loading.

## Why it exists
The shared fixture pack is canonical, but foundation implementation also needs scenario-level datasets that group those fixtures into realistic user states. This section adds four launch-useful demo datasets and a seed manifest.

## Inputs / dependencies
- `docs/specs/source-of-truth/ST-11_seed_data_fixture_pack.md`
- `shared/contracts/fixtures/launch/`
- `backend/packages/analytics-schema/datasets/`

## Output / canonical artifact
- scenario datasets in `backend/packages/analytics-schema/datasets/`
- seed manifest in `backend/apps/api/prisma/seed/seed-manifest.json`
- dataset validation script in `backend/apps/api/scripts/validate-datasets.ts`

## Included scenarios
- new user
- in-progress starter arc user
- lapsed/rekindling user
- subscribed user

## Acceptance criteria
- All datasets are synthetic and parse cleanly.
- Scenario files are machine-readable and reusable across backend, data, and future iOS debug tooling.
- Validation exists for the dataset pack.

## Explicit non-goals
- real user data
- a large fixture library beyond the minimum useful launch scenarios
- irreversible seeding behavior
