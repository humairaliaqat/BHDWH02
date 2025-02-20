USE [db-au-star]
GO
/****** Object:  View [dbo].[v_ic_factOutletStatus]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[v_ic_factOutletStatus] 
as
with cte_movement as
(
    select 
        d.Date_SK,
        do.OutletSK,
        dd.DomainSK,
        t.OutletKey,
        ref.OutletReference,
        case
            when t.NewTradingStatus = 'Prospect' and isnull(r.PreviousStatus, '') <> 'Prospect' then 1
            when t.NewTradingStatus <> 'Prospect' and isnull(r.PreviousStatus, '') = 'Prospect' then -1
            else 0
        end ProspectMovement,
        case
            when t.NewTradingStatus = 'Stocked' and isnull(r.PreviousStatus, '') <> 'Stocked' then 1
            when t.NewTradingStatus <> 'Stocked' and isnull(r.PreviousStatus, '') = 'Stocked' then -1
            else 0
        end StockedMovement,
        case
            when t.NewTradingStatus in ('Stocks Withdrawn', 'Closed') and isnull(r.PreviousStatus, '') not in ('Stocks Withdrawn', 'Closed') then 1
            when t.NewTradingStatus not in ('Stocks Withdrawn', 'Closed') and isnull(r.PreviousStatus, '') in ('Stocks Withdrawn', 'Closed') then -1
            else 0
        end ClosedMovement,
        0 WithdrawnedMovement
    from
        [db-au-cba]..penOutletTradingHistory t
        cross apply
        (
            select top 1
                do.Country,
                do.OutletSK
            from
                [db-au-star]..dimOutlet do
            where
                do.isLatest = 'Y' and
                do.OutletKey = t.OutletKey
        ) do
        cross apply
        (
            select top 1 
                Date_SK
            from
                Dim_Date d
            where
                d.[Date] = convert(date, t.StatusChangeDate)
        ) d
        cross apply
        (
            select top 1 
                DomainSK
            from
                dimDomain dd
            where
                dd.CountryCode = do.Country
        ) dd
        cross apply
        (
            select 'Point in time' OutletReference
            union all
            select 'Latest alpha' OutletReference
        ) ref
        outer apply
        (
            select top 1 
                r.NewTradingStatus PreviousStatus
            from
                [db-au-cba]..penOutletTradingHistory r
            where
                r.OutletKey = t.OutletKey and
                r.StatusChangeDate < t.StatusChangeDate
            order by
                r.StatusChangeDate desc
        ) r

    union

    select 
        d.Date_SK,
        do.OutletSK,
        dd.DomainSK,
        do.OutletKey,
        ref.OutletReference,
        0 ProspectMovement,
        1 StockedMovement,
        0 WithdrawnedMovement,
        0 ClosedMovement
    from
        dimOutlet do
        cross apply
        (
            select top 1 
                Date_SK
            from
                Dim_Date d
            where
                d.[Date] = convert(date, do.CommencementDate)
        ) d
        cross apply
        (
            select top 1 
                DomainSK
            from
                dimDomain dd
            where
                dd.CountryCode = do.Country
        ) dd
        cross apply
        (
            select 'Point in time' OutletReference
            union all
            select 'Latest alpha' OutletReference
        ) ref

    where
        do.isLatest = 'Y' and
        do.TradingStatus = 'Stocked' and
        isnull(do.OutletKey, '') <> '' and
        not exists
        (
            select null
            from
                [db-au-cba]..penOutletTradingHistory oth
            where
                oth.OutletKey = do.OutletKey
        )

    union

    select 
        d.Date_SK,
        do.OutletSK,
        dd.DomainSK,
        do.OutletKey,
        ref.OutletReference,
        case
            when do.TradingStatus = 'Prospect' then 1
            else 0
        end ProspectMovement,
        0 StockedMovement,
        0 WithdrawnedMovement,
        case
            when do.TradingStatus in ('Closed', 'Stocks Withdrawn') then 1
            else 0
        end ClosedMovement
    from
        dimOutlet do
        cross apply
        (
            select top 1 
                Date_SK
            from
                Dim_Date d
            where
                d.[Date] = convert(date, do.LoadDate)
        ) d
        cross apply
        (
            select top 1 
                DomainSK
            from
                dimDomain dd
            where
                dd.CountryCode = do.Country
        ) dd
        cross apply
        (
            select 'Point in time' OutletReference
            union all
            select 'Latest alpha' OutletReference
        ) ref
    where
        do.isLatest = 'Y' and
        do.TradingStatus in ('Closed', 'Prospect', 'Stocks Withdrawn') and
        isnull(do.OutletKey, '') <> '' and
        not exists
        (
            select null
            from
                [db-au-cba]..penOutletTradingHistory oth
            where
                oth.OutletKey = do.OutletKey
        )
)
select 
    case
        when Date_SK < 20110101 then 20110101
        else Date_SK
    end Date_SK,
    OutletSK,
    DomainSK,
    OutletKey,
    OutletReference,
    ProspectMovement,
    StockedMovement,
    WithdrawnedMovement,
    ClosedMovement
from
    cte_movement
GO
