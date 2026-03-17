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
    'widget_viewed',
    'widget_tapped',
    'live_activity_started',
    'live_activity_tapped',
    'notification_sent',
    'notification_opened',
    'shortcut_invoked'
  )
order by occurred_at_utc desc;
