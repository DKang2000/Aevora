with first_seen as (
  select actor_id, min(local_date) as cohort_date
  from stg_analytics_raw_events
  group by actor_id
),
activity as (
  select distinct actor_id, local_date
  from stg_analytics_raw_events
)
select
  first_seen.cohort_date,
  activity.local_date as activity_date,
  count(distinct activity.actor_id) as retained_users,
  count(distinct first_seen.actor_id) over (partition by first_seen.cohort_date) as cohort_size
from first_seen
join activity on activity.actor_id = first_seen.actor_id
group by first_seen.cohort_date, activity.local_date;
