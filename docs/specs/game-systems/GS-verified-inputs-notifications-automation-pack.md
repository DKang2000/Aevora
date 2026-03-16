# GS Verified Inputs, Notifications, and Automation Pack

## Purpose
Canonicalize the launch-safe reconciliation rules for verified completions, sparse reminder delivery, and entitlement authority.

## Why it exists
This bundle touches areas where duplicate events or mixed authority can quietly damage trust. The systems rules need to stay explicit so manual logging remains primary while verified inputs and entitlement updates remain safe.

## Inputs / dependencies
- `AGENTS.md`
- `docs/specs/source-of-truth/ST-01_canonical_domain_model.md`
- `docs/specs/source-of-truth/ST-02_api_contract_pack_openapi_or_equivalent.md`
- `docs/specs/source-of-truth/ST-04_event_taxonomy_contract.md`
- `docs/specs/source-of-truth/ST-07_subscription_entitlement_matrix.md`
- `docs/specs/source-of-truth/ST-08_permission_matrix.md`

## Sections
### GS-22 — Verified completion reconciliation
- Manual logging remains the primary completion path; verified inputs are additive.
- A verified source event can only apply to a vow when the source domain and vow shape have an explicit launch-safe mapping.
- `sourceEventId` is globally idempotent within the player runtime snapshot.
- If a manual completion already satisfied the vow/day, the verified import may still label the completion as verified, but it cannot award duplicate rewards.

### GS-22 — Reminder and witness precedence
- Reminder generation is derived from the canonical vow schedule plus current chain/chapter state.
- The launch-safe plan caps at four items: vow reminder(s), witness prompt, streak-risk prompt, and chapter-ready prompt.
- When OS notification delivery is denied, reminder logic quiets at the system boundary while the in-app return surfaces remain active.

### GS-22 — Entitlement reconciliation
- Server-authoritative subscription outcomes outrank stale local cache.
- Restore, refresh, renewal, billing retry, and expiry must all recompute chapter and district access immediately.
- Premium expands breadth only; it never replaces the free-path core loop or bypasses earned progression.

### GS-22 — Shortcut and automation consistency
- App Intents and shortcuts must route into the same vow, chapter, and reward systems as the in-app Today surface.
- Automation surfaces cannot mint separate completion records or bypass the sync queue.

## Output / canonical artifact
- This systems pack
- Updated backend and iOS implementations for verified-input, reminder, and entitlement reconciliation

## Edge cases
- Duplicate StoreKit server notifications must converge on the same subscription state.
- A user may downgrade or expire after previously using verified inputs; historical rewards remain intact.
- Shortcut-triggered completion must still obey the same duplicate/day-complete safeguards as manual completion.

## Explicit non-goals
- anti-cheat expansion beyond launch-safe idempotency and reconciliation
- server-driven push optimization
- speculative wearable automation rules
