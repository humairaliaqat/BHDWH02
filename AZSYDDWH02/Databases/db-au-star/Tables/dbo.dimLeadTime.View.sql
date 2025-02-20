USE [db-au-star]
GO
/****** Object:  View [dbo].[dimLeadTime]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE view [dbo].[dimLeadTime] as
with 
cte_base as
(
    select 1 Num
    union all select 1
    union all select 1
    union all select 1
    union all select 1
    union all select 1
    union all select 1
    union all select 1
    union all select 1
    union all select 1
),
cte_thousand as
(
    select 
        row_number() over (order by a.Num) LeadTime
    from
        cte_base a,
        cte_base b,
        cte_base c,
        (
            select 1 Multiplier
            union
            select 2
        ) d
),
cte_leadtime as
(
    select 
        -1 LeadTime

    union all

    select 
        0 LeadTime

    union all

    select 
        LeadTime
    from
        cte_thousand
)
select 
    convert(int, lt.LeadTime) LeadTimeSK,
    case
        when lt.LeadTime < 0 then 'Unknown'
        when lt.LeadTime between 0 and 27 then 'Pricing group 1'
        when lt.LeadTime between 28 and 56 then 'Pricing group 2'
        when lt.LeadTime between 57 and 92 then 'Pricing group 3'
        when lt.LeadTime between 93 and 213 then 'Pricing group 4'
        when lt.LeadTime between 214 and 359 then 'Pricing group 5'
        else 'Pricing group 6'
    end LeadTimeGroup,
    case
        when lt.LeadTime < 0 then 999
        when lt.LeadTime between 0 and 27 then 27
        when lt.LeadTime between 28 and 56 then 56
        when lt.LeadTime between 57 and 92 then 92
        when lt.LeadTime between 93 and 213 then 213
        when lt.LeadTime between 214 and 359 then 359
        else 360
    end LeadTimeGroupKey,
    case
        when lt.LeadTime < 0 then 'Unknown'
        when lt.LeadTime between 0 and 2 then '2 days'
        when lt.LeadTime between 3 and 5 then '5 days'
        when lt.LeadTime between 6 and 8 then '8 days'
        when lt.LeadTime between 9 and 11 then '11 days'
        when lt.LeadTime between 12 and 14 then '14 days'
        when lt.LeadTime between 15 and 17 then '17 days'
        when lt.LeadTime between 18 and 20 then '20 days'
        when lt.LeadTime between 21 and 27 then '4 weeks'
        when lt.LeadTime between 28 and 35 then '5 weeks'
        when lt.LeadTime between 36 and 42 then '6 weeks'
        when lt.LeadTime between 43 and 49 then '7 weeks' 
        when lt.LeadTime between 50 and 56 then '8 weeks'
        when lt.LeadTime between 57 and 63 then '9 weeks'
        when lt.LeadTime between 64 and 70 then '10 weeks'
        when lt.LeadTime between 71 and 92 then '11 weeks'
        when lt.LeadTime between 93 and 123 then '3 months'
        when lt.LeadTime between 124 and 153 then '4 months'
        when lt.LeadTime between 154 and 183 then '5 months'
        when lt.LeadTime between 184 and 213 then '6 months'
        when lt.LeadTime between 214 and 243 then '7 months'
        when lt.LeadTime between 244 and 274 then '8 months'
        when lt.LeadTime between 275 and 304 then '9 months'
        when lt.LeadTime between 305 and 335 then '10 months'
        when lt.LeadTime between 336 and 359 then '11 months'
        when lt.LeadTime between 360 and 366 then '12 months'
        else 'Greater than 12 months'
    end LeadTimeBand,
    case
        when lt.LeadTime < 0 then 999
        when lt.LeadTime between 0 and 2 then 2
        when lt.LeadTime between 3 and 5 then 5
        when lt.LeadTime between 6 and 8 then 8
        when lt.LeadTime between 9 and 11 then 11
        when lt.LeadTime between 12 and 14 then 14
        when lt.LeadTime between 15 and 17 then 17
        when lt.LeadTime between 18 and 20 then 20
        when lt.LeadTime between 21 and 27 then 27
        when lt.LeadTime between 28 and 35 then 35
        when lt.LeadTime between 36 and 42 then 42
        when lt.LeadTime between 43 and 49 then 49
        when lt.LeadTime between 50 and 56 then 56
        when lt.LeadTime between 57 and 63 then 63
        when lt.LeadTime between 64 and 70 then 70
        when lt.LeadTime between 71 and 92 then 92
        when lt.LeadTime between 93 and 123 then 123
        when lt.LeadTime between 124 and 153 then 153
        when lt.LeadTime between 154 and 183 then 183
        when lt.LeadTime between 184 and 213 then 213
        when lt.LeadTime between 214 and 243 then 243
        when lt.LeadTime between 244 and 274 then 274
        when lt.LeadTime between 275 and 304 then 304
        when lt.LeadTime between 305 and 335 then 335
        when lt.LeadTime between 336 and 359 then 359
        when lt.LeadTime between 360 and 366 then 366
        else 367
    end LeadTimeBandKey
from 
    cte_leadtime lt








GO
