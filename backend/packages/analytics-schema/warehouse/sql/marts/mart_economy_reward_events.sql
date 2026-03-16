select
  actor_id,
  local_date,
  count(*) filter (where event_name = 'resonance_awarded') as resonance_events,
  count(*) filter (where event_name = 'gold_awarded') as gold_events,
  count(*) filter (where event_name = 'reward_chest_opened') as reward_chest_opens
from stg_analytics_raw_events
group by actor_id, local_date;
