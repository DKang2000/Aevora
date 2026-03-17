select
  local_date,
  count(distinct actor_id) filter (where event_name = 'onboarding_started') as onboarding_started_users,
  count(distinct actor_id) filter (where event_name = 'origin_family_selected') as origin_selected_users,
  count(distinct actor_id) filter (where event_name = 'identity_selected') as identity_selected_users,
  count(distinct actor_id) filter (where event_name = 'starter_vow_accepted') as starter_vow_accepted_users,
  count(distinct actor_id) filter (where event_name = 'onboarding_completed') as onboarding_completed_users,
  count(distinct actor_id) filter (where event_name = 'first_magical_moment_viewed') as first_magical_moment_users
from stg_analytics_raw_events
group by local_date;
