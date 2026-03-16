# ST-12 — Acceptance Criteria Matrix

## Purpose
Define the pass/fail gate for the source-of-truth layer before downstream implementation proceeds.

## Why it exists
The ST layer is only useful if teams can verify that its contracts are complete, consistent, and safe to build against. This matrix provides the merge gate for that readiness.

## Inputs and dependencies
- `AGENTS.md`
- `docs/product/00_START_HERE.md`
- `docs/product/01_Product_Thesis.md`
- `docs/product/02_v1_PRD.md`
- `docs/product/03_Onboarding_Paywall_Spec.md`
- `docs/product/04_Game_Economy_Spec.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/product/07_Analytics_Event_Taxonomy.md`
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
- `docs/specs/source-of-truth/ST-11_seed_data_fixture_pack.md`

## Scope
This section defines:
- section-level acceptance criteria
- consumer-specific readiness checks
- source-of-truth definition of done
- unresolved-gap reporting rules

## Non-goals
- generic full-product QA planning
- rewriting upstream ST sections

## Definition of done for the ST layer
The source-of-truth layer is done when:
- every ST section has one canonical human-readable spec
- every required machine-readable artifact exists
- naming is consistent across sections
- fixture coverage validates the critical launch scenarios
- no unresolved contradiction broadens v1 scope silently

## Pass/fail rules
- fail if a required artifact path is missing
- fail if two sections define the same behavior inconsistently
- fail if a contract introduces out-of-scope systems
- fail if machine-readable examples contradict the prose contract

## Current unresolved gaps
- none

## Examples
- machine-readable matrix: `shared/contracts/acceptance/acceptance-matrix.v1.json`

## Acceptance criteria
- every ST section has explicit, traceable acceptance rules
- each downstream consumer can identify what is safe to build against
- unresolved gaps are called out directly rather than hidden
