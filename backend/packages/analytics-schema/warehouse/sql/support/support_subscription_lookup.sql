select
  actor_id,
  local_date,
  event_name,
  occurred_at_utc,
  surface,
  payload
from stg_analytics_raw_events
where actor_id = '{{ actor_id }}'
  and event_name in (
    'paywall_viewed',
    'trial_started',
    'purchase_started',
    'purchase_completed',
    'subscription_restored',
    'subscription_canceled',
    'subscription_expired'
  )
order by occurred_at_utc desc;
