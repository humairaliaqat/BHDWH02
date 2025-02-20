USE [db-au-workspace]
GO
/****** Object:  View [dbo].[live_dashboard_claims_backlog_estimate]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE  view [dbo].[live_dashboard_claims_backlog_estimate] as
with
cte_netclosed as
(
    select 
        --sum(TodayClosedCount),
        --sum(TodayReopenedCount),
        --sum(TodayNewCount),
        sum(TodayNetClosedCount) NetClosed
    from
        [db-au-workspace]..live_dashboard_claims_closed
    where
        CaseOfficer <> 'YTD Average'
),
cte_target as
(
    select 
        tt.[Target TAT],
        isnull(BackLog, 0) BackLog
    from
        (
            select 9 [Target TAT]
            union all
            select 8 [Target TAT]
            union all
            select 7 [Target TAT]
            union all
            select 6 [Target TAT]
            union all
            select 5 [Target TAT]
            union all
            select 4 [Target TAT]
        ) tt
        outer apply
        (
            select 
                sum(TATCount) BackLog
            from
                [db-au-workspace]..live_dashboard_claims_tat t
            where
                t.TAT > tt.[Target TAT] and
                t.WorkType = 'Claim'
        ) t
)
select 
    [Target TAT],
    BackLog,
    NetClosed,
    case
        when BackLog = 0 then 'No backlog to process'
        when isnull(nc.NetClosed, 0) = 0 then 'Unable to determine estimate'
        when isnull(nc.NetClosed, 0) < 0 then 'Negative [Net Close], backlog will increase'
        when convert(int, DayEstimate) <= 1 then convert(varchar, convert(int, DayEstimate)) + ' day to clear backlog'
        else convert(varchar, convert(int, DayEstimate)) + ' days to clear backlog'
    end Estimate
from
    cte_target t
    inner join cte_netclosed nc on 
        1 = 1
    cross apply
    (
        select
            case
                when isnull(nc.NetClosed, 0) = 0 then 0
                else BackLog / nc.NetClosed
            end DayEstimate
    ) e


GO
