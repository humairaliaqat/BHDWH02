USE [db-au-star]
GO
/****** Object:  View [dbo].[vdimDuration]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vdimDuration]
as
select 
    *,
    case 
        when Duration < 0 then 'UNKNOWN'
        when Duration between 0 and 2 then '2 days'
        when Duration between 3 and 5 then '5 days'
        when Duration between 6 and 8 then '8 days'
        when Duration between 9 and 11 then '11 days'
        when Duration between 12 and 14 then '14 days'
        when Duration between 15 and 17 then '17 days'
        when Duration between 18 and 20 then '20 days'
        when Duration between 21 and 23 then '23 days'
        when Duration between 24 and 26 then '26 days'
        when Duration between 27 and 29 then '29 days'
        when Duration between 30 and 32 then '32 days'
        when Duration between 33 and 35 then '5 weeks'
        when Duration between 36 and 42 then '6 weeks'
        when Duration between 43 and 49 then '7 weeks' 
        when Duration between 50 and 56 then '8 weeks'
        when Duration between 57 and 63 then '9 weeks'
        when Duration between 64 and 70 then '10 weeks'
        when Duration between 71 and 92 then '3 months'
        when Duration between 93 and 123 then '4 months'
        when Duration between 124 and 153 then '5 months'
        when Duration between 154 and 183 then '6 months'
        when Duration between 184 and 213 then '7 months'
        when Duration between 214 and 243 then '8 months'
        when Duration between 244 and 274 then '9 months'
        when Duration between 275 and 304 then '10 months'
        when Duration between 305 and 335 then '11 months'
        else '12 months'
    end PricingDurationBand,
    case 
        when Duration < 0 then 999
        when Duration between 0 and 2 then 2
        when Duration between 3 and 5 then 5
        when Duration between 6 and 8 then 8
        when Duration between 9 and 11 then 11
        when Duration between 12 and 14 then 14
        when Duration between 15 and 17 then 17
        when Duration between 18 and 20 then 20
        when Duration between 21 and 23 then 23
        when Duration between 24 and 26 then 26
        when Duration between 27 and 29 then 29
        when Duration between 30 and 32 then 32
        when Duration between 33 and 35 then 35
        when Duration between 36 and 42 then 42
        when Duration between 43 and 49 then 49
        when Duration between 50 and 56 then 56
        when Duration between 57 and 63 then 63
        when Duration between 64 and 70 then 70
        when Duration between 71 and 92 then 92
        when Duration between 93 and 123 then 123
        when Duration between 124 and 153 then 153
        when Duration between 154 and 183 then 183
        when Duration between 184 and 213 then 213
        when Duration between 214 and 243 then 243
        when Duration between 244 and 274 then 274
        when Duration between 275 and 304 then 304
        when Duration between 305 and 335 then 335
        else 366
    end PricingDurationBandKey,
    min(Duration) over (partition by DurationBand) DurationBandKey,
    min(Duration) over (partition by ABSDurationBand) ABSDurationBandKey
from
    dimDuration
GO
