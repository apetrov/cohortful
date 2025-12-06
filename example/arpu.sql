        with R as (
            select app, uuid, bid_date, timestamp, extra_args__payout from dashboard.int_conversions 
            where bid_date > '{t0}' and payload__tag = '{tag}'
        ),
        I as (
           select uuid, timestamp as installed_at , payload__tag, app 
           from installs where extra_args__goal_id = '0' and payload__tag = '{tag}' and bid_date > '{t0}'
        ),
        RI as (
            select *,toDate(timestamp) - toDate(installed_at) as dt  from R left join I on I.uuid = R.uuid
        ),
        RI_agg as (
            select uuid, sum(extra_args__payout) as advertiser_revenue  from RI where dt <= {t}  group by 1
        ),
        IR as (
            select I.uuid, I.installed_at, I.payload__tag, I.app, coalesce(RI_agg.advertiser_revenue,0) as advertiser_revenue from I left join RI_agg on I.uuid = RI_agg.uuid
        )
        select * from IR
;
