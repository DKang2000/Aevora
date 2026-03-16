# Secret Inventory Template

| Secret name | Used by | Environment scope | Owner | Rotation expectation | Injection path | Notes |
| --- | --- | --- | --- | --- | --- | --- |
| `DATABASE_URL` | API service, migrations | dev / staging / prod | backend owner | on credential change or incident | env var | local uses untracked `.env`; hosted uses secret manager |
| `APPLE_SIGN_IN_CLIENT_SECRET` | auth flows | staging / prod | iOS + backend owners | quarterly or on incident | runtime secret store | never committed to repo |
| `STOREKIT_SHARED_SECRET_OR_EQUIVALENT` | subscription validation | staging / prod | backend owner | quarterly or on incident | runtime secret store | placeholder until billing service is implemented |
| `ANALYTICS_API_KEY` | analytics forwarding | staging / prod | data owner | on provider rotation schedule | GitHub environment + runtime secret store | not required for local console mode |
| `OBSERVABILITY_DSN` | logging/crash export | staging / prod | engineering owner | on provider rotation schedule | GitHub environment + runtime secret store | local dev defaults to console |
| `REMOTE_CONFIG_SERVICE_TOKEN` | config publishing | staging / prod | platform owner | quarterly or on incident | CI secret + hosted secret store | protect write access separately from read access |
