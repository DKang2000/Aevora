# Environment Matrix

| Environment | Primary use | Backend config source | iOS config source | Remote config/content source | Data policy | Parity rule |
| --- | --- | --- | --- | --- | --- | --- |
| `dev` | Local development and fixture-driven debugging | local `.env` derived from `backend/apps/api/.env.example` | local Xcode config placeholders in `ios/Config/` | bundled defaults plus local/mock service data | synthetic data only | may use local services but must preserve contract shapes |
| `staging` | Integration validation, QA, and release candidates | hosted secret manager + GitHub environments | staging signing/config assets outside repo | staging remote config/content payloads | synthetic or scrubbed internal data only | must mirror production feature toggles, APIs, and observability shapes |
| `prod` | Customer-facing runtime | hosted secret manager + GitHub environments | production signing/config assets outside repo | production remote config/content payloads | production data under least-privilege access | highest fidelity baseline for entitlement, config, and logging behavior |

## Ownership
- Backend runtime and hosted config: engineering
- iOS signing and distribution config: engineering + release owner
- Content and remote config payload approval: product/design/content with engineering guardrails
- Secret rotation and access audits: engineering leads
