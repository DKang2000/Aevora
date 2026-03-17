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
    'vow_completed',
    'resonance_awarded',
    'gold_awarded',
    'item_awarded',
    'reward_chest_opened',
    'district_progressed',
    'chapter_milestone_reached'
  )
order by occurred_at_utc desc;
