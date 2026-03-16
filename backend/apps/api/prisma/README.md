# Prisma Schema

This schema is the executable relational baseline for Aevora foundation work.

## Canonical inputs
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`
- `docs/specs/data/DATA-01_canonical_relational_database_schema.md`

## Notes
- The schema keeps server-authoritative entities in Postgres and avoids duplicating authored content that already lives under `content/` and `shared/contracts/`.
- Soft delete is currently modeled only where user-edited breadth benefits from historical retention, such as `Vow.deletedAt`.
- Future migrations should be added under `backend/migrations/` once `DATA-02` is implemented.
