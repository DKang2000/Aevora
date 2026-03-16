# OPS-12 — Access Control / Admin Roles

## Purpose
Define the minimum viable access model for repo ownership, CI, environments, monitoring, and App Store operational surfaces.

## Why it exists
Multiple humans and agents now touch the same repo and build systems. Least-privilege ownership needs to be written down before operational sprawl becomes the default.

## Inputs / dependencies
- `docs/foundation/FOUNDATION_REPO_AUDIT.md`
- `docs/specs/backend/BE-23_security_rate_limiting_audit_logging.md`
- `docs/specs/ops/OPS-04_secrets_management.md`
- `docs/product/04_SECTION_CONTEXT_INDEX.md`
- `docs/product/06_Technical_Architecture_Spec.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`

## Output / canonical artifact
- ownership file at `.github/CODEOWNERS`
- access guide at `ops/access/README.md`
- role matrix at `ops/access/access-matrix.md`

## Repo adaptation
- GitHub-native ownership is recorded under `.github/CODEOWNERS`, which matches the foundation pack expectation.
- Required read substitution: `docs/product/05_REPO_ROUTING_MAP.md` -> `docs/product/04_SECTION_CONTEXT_INDEX.md`.
- Required read substitution: `docs/product/foundation/06_Technical_Architecture_Spec.md` -> `docs/product/06_Technical_Architecture_Spec.md`.

## Edge cases
- Placeholder owner handles must be replaced before branch protection is enforced in a hosted repo.
- Emergency access needs a written revocation path, not just tribal knowledge.
- Repo access, environment secrets, and App Store Connect rights should remain narrower than day-to-day contribution rights.

## Acceptance criteria
- A small role model exists for repo, CI, environment, monitoring, and release access.
- CODEOWNERS reflects canonical repo roots.
- Access docs describe least-privilege expectations, offboarding, and emergency access handling.

## Validation
- CODEOWNERS references real repo paths.
- Access docs reference current workflow and ops paths in this repo.

## Explicit non-goals
- a product admin UI
- an overbuilt enterprise IAM program
- speculative permission tiers outside the current v1 operating needs
