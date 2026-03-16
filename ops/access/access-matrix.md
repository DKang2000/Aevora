# Access Matrix

| Surface | Founder | CTO | iOS Lead | Backend Lead | Product Lead | On-call Engineer |
| --- | --- | --- | --- | --- | --- | --- |
| Repo admin settings | approve | approve | none | none | none | none |
| Merge to `main` | approve | approve | review | review | review | none |
| `.github/workflows/*` edits | review | approve | review | review | none | none |
| `ios/` source | review | review | approve | none | none | none |
| `backend/` source | review | review | none | approve | none | none |
| `shared/contracts/` | review | approve | review | review | none | none |
| GitHub environment secrets | none | approve | none | none | none | none |
| Monitoring config | none | approve | review | review | none | approve |
| App Store Connect / TestFlight | approve | approve | operate | none | none | none |
| Emergency production access | approve | approve | none | none | none | operate |

## Notes
- `approve` means accountable owner for granting or changing access.
- `review` means normal code review or contribution access, not environment administration.
- `operate` means day-to-day use of a system without being the default owner for permission changes.
- Replace role labels or GitHub handles when the actual team roster is finalized.
