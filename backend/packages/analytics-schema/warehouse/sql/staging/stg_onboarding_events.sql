select
  actor_id,
  local_date,
  occurred_at_utc,
  event_name,
  surface
from stg_analytics_raw_events
where event_name in (
  'onboarding_started',
  'onboarding_step_viewed',
  'onboarding_step_completed',
  'onboarding_completed',
  'first_magical_moment_viewed'
);
