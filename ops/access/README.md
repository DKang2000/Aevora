# Access Control

## Purpose
Keep the v1 repo, environments, and release systems on a least-privilege footing.

## Scope
- repo ownership and review coverage through `.github/CODEOWNERS`
- GitHub Actions workflow ownership
- environment secret administration
- monitoring and incident access
- App Store Connect and TestFlight operations

## Operating rules
- Replace placeholder GitHub handles in `.github/CODEOWNERS` before enforcing protections.
- Keep production environment secret administration narrower than general merge access.
- Remove access as part of offboarding on the same day credentials are revoked.
- Use emergency elevation only when an incident or release blocker cannot be resolved through normal ownership paths.

## Canonical matrix
- `ops/access/access-matrix.md`
