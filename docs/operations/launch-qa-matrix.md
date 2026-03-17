# Launch QA Matrix

## Device Coverage
- iPhone SE-size class: verify onboarding, Today quick log, Profile account flows, and compressed copy wrapping.
- Standard iPhone size class: verify all primary flows and widget/live-activity interactions.
- Large Pro Max / Plus-size class: verify portrait spacing, world presentation, and reward modal composition.

## Performance Checks
- cold launch to Today on a seeded returning account
- cold launch to onboarding on a fresh install
- quick-log interaction from Today in 1 to 2 taps
- world tab open and return to Today
- widget/live-activity snapshot refresh after a completion

## Crash and Recovery Checks
- relaunch after queued sync operations are pending
- relaunch from notification deep link
- relaunch after verified-input refresh attempt
- relaunch after local delete/reset
- relaunch after restore/downgrade state change

## Submission-Adjacent Checks
- notification permission education copy is calm and non-blocking
- HealthKit denial path preserves manual logging
- restore purchase failure path remains recoverable
- delete-account state is reviewed before destructive action
