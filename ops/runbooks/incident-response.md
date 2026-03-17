# Incident Response Runbook

## Trigger Classes
- restore purchase failures
- bad remote-config or content promotion
- asset-manifest mismatch
- notification or shortcut regression
- export/delete account failures

## First 15 Minutes
1. Confirm severity and affected surface.
2. Check the latest alerts and recent publish/promote actions.
3. Decide whether the issue is:
   - app/client only
   - backend/runtime only
   - publishing/config only
   - Apple/external dependency only
4. Freeze new promotions if publishing is involved.

## Common Responses
### Bad remote config
- re-promote the previous validated config candidate
- use environment override only as break-glass

### Bad content publish
- re-promote the previous validated content bundle
- do not try to patch authored content through remote config

### Account export/delete issue
- inspect via admin account summary
- prepare a support-safe export before destructive remediation

### Restore purchase issue
- confirm current subscription state
- review recent StoreKit notification handling and known external Apple gaps
