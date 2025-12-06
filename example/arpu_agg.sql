with arpu_source as (
    select *
    from read_parquet('arpu.pq')
),
app_level as (
    select
        app,
        count(*) as n,
        sum(advertiser_revenue) as cohort_revenue,
        stddev_pop(advertiser_revenue) as revenue_std
    from arpu_source
    group by app
)
select
    app,
    n,
    cohort_revenue,
    revenue_std,
    cohort_revenue / n as arpu
from app_level
order by app;
