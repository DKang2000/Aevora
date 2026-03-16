select
  actor_id,
  min(case when event_name = 'onboarding_started' then occurred_at_utc end) as onboarding_started_at,
  min(case when event_name = 'onboarding_completed' then occurred_at_utc end) as onboarding_completed_at,
  min(case when event_name = 'first_magical_moment_viewed' then occurred_at_utc end) as first_magical_moment_at
from stg_onboarding_events
group by actor_id;
