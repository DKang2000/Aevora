select
  local_date,
  count(distinct actor_id) filter (where event_name in ('resonance_awarded', 'gold_awarded', 'item_awarded')) as rewarded_users,
  count(*) filter (where event_name = 'resonance_awarded') as resonance_awards,
  count(*) filter (where event_name = 'gold_awarded') as gold_awards,
  count(*) filter (where event_name = 'item_awarded') as item_awards,
  count(*) filter (where event_name = 'shop_purchase_completed') as shop_purchases,
  count(*) filter (where event_name = 'reward_chest_opened') as reward_chest_opens,
  count(*) filter (where event_name = 'district_progressed') as district_progressions
from stg_analytics_raw_events
group by local_date;
