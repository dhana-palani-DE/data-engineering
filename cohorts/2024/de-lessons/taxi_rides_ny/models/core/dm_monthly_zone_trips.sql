{{ config(materialized='table')}}

with trips_data as (
    select 
        tripid, 
        service_type, 
        pickup_datetime, 
        dropoff_datetime, 
        pickup_zone,
        pickup_borough,
        dropoff_zone, 
        dropoff_borough
    from {{ ref('fact_trips') }}
    union all
    select 
        tripid, 
        service_type, 
        pickup_datetime, 
        dropoff_datetime, 
        pickup_zone,
        pickup_borough,
        dropoff_zone, 
        dropoff_borough
    from {{ ref('fact_fhv_trips') }}
)
select 
    pickup_zone,
    {{ dbt.date_trunc("month", "pickup_datetime") }} as trip_pickup_month, 
    {{ dbt.date_trunc("month", "dropoff_datetime") }} as trip_dropoff_month, 
    service_type, 
    dropoff_zone, 

    -- Additional calculations
    count(tripid) as total_monthly_trips,

    from trips_data
    group by 1,2,3,4,5
