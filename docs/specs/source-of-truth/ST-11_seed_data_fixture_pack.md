# ST-11 — Seed Data / Fixture Pack

## Purpose
Define the canonical launch fixtures used by iOS, backend, analytics, design, and QA to validate the source-of-truth layer.

## Why it exists
Stable fixtures reduce guessing. They let teams build against representative users, vows, world state, rewards, entitlements, config, and analytics events without each team inventing its own sample data.

## Inputs and dependencies
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/04_Game_Economy_Spec.md`
- `docs/product/05_Narrative_Content_Launch_Spec.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-03_client_local_storage_schema.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `docs/specs/source-of-truth/ST-06_content_config_schema.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`
- `docs/specs/source-of-truth/ST-09_error_empty_offline_state_catalog.md`
- `docs/specs/source-of-truth/ST-10_string_key_registry_copy_token_structure.md`

## Scope
This section defines:
- the required launch fixture set
- fixture naming and versioning rules
- traceability back to source-of-truth sections

## Non-goals
- production content packs
- breadth beyond the locked launch footprint

## Required fixture set
- new free user
- premium trial user
- three-vow starter plan
- one binary vow
- one count vow
- one duration vow
- same-day completion chain example
- cooling and rekindle example
- first magical moment world state
- partially restored district state
- shop and inventory snapshot
- remote config defaults snapshot
- example analytics events

## Fixture rules
- fixture files use stable lowercase snake_case names
- all fixture IDs must be deterministic and readable
- fixtures should validate more than one downstream section where possible
- each fixture must map back to the ST sections it exercises

## Versioning notes
- manifest and fixture pack version is `v1`
- if a fixture shape changes materially, update the manifest and traceability mapping in the same change

## Examples
- manifest: `shared/contracts/fixtures/launch/dev-seed-manifest.v1.json`
- fixture files: `shared/contracts/fixtures/launch/*.json`

## Acceptance criteria
- all critical launch scenarios have representative fixtures
- fixtures align with the canonical contracts and content boundaries
- manifest traceability is clear enough for QA and implementation teams to reuse the same data
