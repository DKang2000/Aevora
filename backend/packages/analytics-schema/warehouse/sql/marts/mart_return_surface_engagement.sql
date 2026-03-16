select
  actor_id,
  local_date,
  count(*) filter (where event_name = 'widget_viewed') as widget_views,
  count(*) filter (where event_name = 'widget_tapped') as widget_taps,
  count(*) filter (where event_name = 'live_activity_started') as live_activities_started,
  count(*) filter (where event_name = 'live_activity_tapped') as live_activity_taps,
  count(*) filter (where event_name = 'notification_prompt_viewed') as notification_prompts_viewed,
  count(*) filter (where event_name = 'notification_permission_result') as notification_permission_results,
  count(*) filter (where event_name = 'notification_opened') as notification_opens
from stg_analytics_raw_events
group by actor_id, local_date;
