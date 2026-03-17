with user_day as (
  select
    local_date,
    actor_id,
    count(*) as total_events,
    count(*) filter (where event_name = 'onboarding_completed') as onboarding_completed_events,
    count(*) filter (where event_name = 'first_magical_moment_viewed') as first_magical_moment_events,
    count(*) filter (where event_name = 'day_completed_first_vow') as activated_day_events,
    count(*) filter (where event_name = 'paywall_viewed') as paywall_events,
    count(*) filter (where event_name in ('trial_started', 'purchase_completed')) as monetized_events
  from stg_analytics_raw_events
  group by local_date, actor_id
)
select
  local_date,
  count(distinct actor_id) as active_users,
  count(distinct actor_id) filter (where onboarding_completed_events > 0) as onboarding_completed_users,
  count(distinct actor_id) filter (where first_magical_moment_events > 0) as first_magical_moment_users,
  count(distinct actor_id) filter (where activated_day_events > 0) as activated_users,
  count(distinct actor_id) filter (where paywall_events > 0) as paywall_exposed_users,
  count(distinct actor_id) filter (where monetized_events > 0) as monetized_users
from user_day
group by local_date;
