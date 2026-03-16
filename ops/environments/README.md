# Environment Templates

This directory defines the environment matrix and non-secret templates for Aevora foundation work.

## Canonical references
- `docs/specs/ops/OPS-01_dev_staging_prod_environments.md`
- `docs/specs/ops/OPS-04_secrets_management.md`
- `docs/specs/source-of-truth/ST-05_remote_config_schema.md`

## Guardrails
- Never commit real secrets.
- Environment-specific runtime tuning should come from remote config and content delivery, not hard-coded branches in app logic.
