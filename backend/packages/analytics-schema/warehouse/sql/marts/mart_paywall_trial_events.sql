select
  actor_id,
  local_date,
  count(*) filter (where event_name = 'paywall_viewed') as paywall_views,
  count(*) filter (where event_name = 'trial_started') as trials_started,
  count(*) filter (where event_name = 'purchase_completed') as purchases_completed
from stg_analytics_raw_events
group by actor_id, local_date;
