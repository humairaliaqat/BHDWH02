USE [db-au-workspace]
GO
/****** Object:  View [dbo].[live_dashboard_claims_closed_projected]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [dbo].[live_dashboard_claims_closed_projected] as
with 
cte_closed as
(
    select 
        [Hour],
        sum(TodayClosedCount) TodayClosedCount,
        sum(YTDAvgClosedCount) YTDAvgClosedCount
    from
        [db-au-workspace]..live_dashboard_claims_closed
    group by
        [Hour]
),
cte_trend as
(
    select 
        [Hour],
        r.TodayClosedCount,
        t.TodayClosedCount TodayVariance,
        r.YTDAvgClosedCount,
        t.YTDAvgClosedCount YTDVariance
    from
        cte_closed t
        outer apply
        (
            select 
                sum(TodayClosedCount) TodayClosedCount,
                sum(YTDAvgClosedCount) YTDAvgClosedCount
            from
                cte_closed r
            where
                r.[Hour] <= t.[Hour]
        ) r
),
cte_growth as
(
    select 
        [Hour],
        TodayClosedCount,
        TodayVariance,
        case
            when (TodayClosedCount - TodayVariance) = 0 then 0
            else TodayVariance / (TodayClosedCount - TodayVariance)
        end TodayGrowth,
        YTDAvgClosedCount,
        YTDVariance,
        case
            when (YTDAvgClosedCount - YTDVariance) = 0 then 0
            else YTDVariance / (YTDAvgClosedCount - YTDVariance)
        end YTDGrowth,
        YTDGrowthFactor,
        case
            when YTDGrowthFactor <> 0 then log(YTDGrowthFactor)
            else 0
        end GrowthFactor
    from
        cte_trend t
        cross apply
        (
            select
                case
                    when (YTDAvgClosedCount - YTDVariance) = 0 then 0
                    else 1 + (YTDVariance / (YTDAvgClosedCount - YTDVariance))
                end YTDGrowthFactor
        ) r
)
select 
    [Hour],
    datepart(hh, getdate()) CurrentHour,
    t.TodayClosedCount,
    t.YTDAvgClosedCount,
    case
        when [Hour] < datepart(hh, getdate()) then TodayClosedCount
--        else exp(GrowthFactorX) * PreviousHourClosed
        when TodayClosedCount > (PreviousHourClosed + Trend) then TodayClosedCount
        else PreviousHourClosed + Trend
    end ProjectedClosedCount,
    case
        when [Hour] < datepart(hh, getdate()) then 0
        else 1
    end Projected

    --exp(GrowthFactorX),
    --exp(GrowthFactorX) * t.TodayClosedCount
    --,
    --log(YTDGrowthFactor)
    --,
from
    cte_growth t
    outer apply
    (
        select 
            sum(GrowthFactor) GrowthFactorX
        from
            cte_growth r
        where
            r.YTDGrowth <> 0 and
            r.[Hour] >= datepart(hh, getdate()) and
            r.[Hour] <= t.[Hour]
    ) r
    outer apply
    (
        select top 1
            p.TodayClosedCount PreviousHourClosed
        from
            cte_growth p
        where
            p.[Hour] < t.[Hour] and
            p.[Hour] < datepart(hh, getdate())
        order by
            p.[Hour] desc
    ) p
    outer apply
    (
        select 
            sum(YTDVariance) Trend
        from
            cte_growth p
        where
            p.[Hour] >= datepart(hh, getdate()) and
            p.[Hour] <= t.[Hour]

    ) v






GO
