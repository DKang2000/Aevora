select
  actor_id,
  min(local_date) as first_seen_local_date,
  max(local_date) as last_seen_local_date,
  count(*) as total_events,
  count(*) filter (where event_name = 'onboarding_completed') as onboarding_completed_events,
  count(*) filter (where event_name = 'vow_completed') as vow_completed_events,
  count(*) filter (where event_name in ('trial_started', 'purchase_completed', 'subscription_restored')) as monetization_events
from stg_analytics_raw_events
where actor_id = '{{ actor_id }}'
group by actor_id;
