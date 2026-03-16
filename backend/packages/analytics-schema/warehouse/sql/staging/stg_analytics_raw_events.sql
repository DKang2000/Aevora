select
  event_name,
  event_version,
  occurred_at_utc,
  local_date,
  coalesce(user_id, anonymous_device_id) as actor_id,
  session_id,
  surface,
  app_build,
  platform,
  payload
from analytics_raw_events;
