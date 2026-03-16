select
  actor_id,
  local_date,
  count(*) as total_events,
  count(*) filter (where event_name = 'vow_completed') as vow_completed_events,
  count(*) filter (where event_name = 'world_scene_opened') as world_scene_open_count
from stg_analytics_raw_events
group by actor_id, local_date;
