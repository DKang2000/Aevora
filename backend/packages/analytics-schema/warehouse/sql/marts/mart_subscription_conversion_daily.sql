select
  local_date,
  count(distinct actor_id) filter (where event_name = 'paywall_viewed') as paywall_viewers,
  count(distinct actor_id) filter (where event_name = 'trial_started') as trial_starters,
  count(distinct actor_id) filter (where event_name = 'purchase_started') as purchase_starters,
  count(distinct actor_id) filter (where event_name = 'purchase_completed') as purchase_completers,
  count(distinct actor_id) filter (where event_name = 'subscription_restored') as restored_subscribers,
  count(distinct actor_id) filter (where event_name = 'subscription_canceled') as cancellations,
  count(distinct actor_id) filter (where event_name = 'subscription_expired') as expirations
from stg_analytics_raw_events
group by local_date;
