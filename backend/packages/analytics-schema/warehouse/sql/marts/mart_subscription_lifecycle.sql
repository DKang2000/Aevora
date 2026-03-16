select
  actor_id,
  local_date,
  count(*) filter (where event_name = 'subscription_restored') as restores,
  count(*) filter (where event_name = 'subscription_renewed') as renewals,
  count(*) filter (where event_name = 'subscription_canceled') as cancellations,
  count(*) filter (where event_name = 'subscription_expired') as expirations
from stg_analytics_raw_events
group by actor_id, local_date;
