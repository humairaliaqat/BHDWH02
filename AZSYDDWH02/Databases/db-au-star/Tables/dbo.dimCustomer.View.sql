USE [db-au-star]
GO
/****** Object:  View [dbo].[dimCustomer]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[dimCustomer]
as
select --top 2000 
    '-1' CustomerID,
    -1 CurrentAge,
    'UNKNOWN' AgeBand,
    --mp.LastName,
    'UNKNOWN' Gender,
    'UNKNOWN' Suburb,
    'UNKNOWN' State,
    -1 PolicyCount,
    'UNKNOWN' PolicyCountBand,
    -1 PolicyCountBandKey

--union all

--select --top 2000 
--    mp.PartyID CustomerID,
--    --PartyName CustomerName,
--    --FirstName,
--    a.CurrentAge,
--    dab.AgeBand,
--    --mp.LastName,
--    isnull(mp.Gender, 'UNKNOWN') Gender,
--    isnull(mp.Suburb, 'UNKNOWN') Suburb,
--    isnull(mp.State, 'UNKNOWN') State,
--    mpp.PolicyCount,
--    case
--        when mpp.PolicyCount < 5 then convert(varchar, mpp.PolicyCount)
--        when mpp.PolicyCount < 11 then '5-10'
--        when mpp.PolicyCount < 26 then '11-25'
--        else '25+'
--    end PolicyCountBand,
--    case
--        when mpp.PolicyCount < 5 then mpp.PolicyCount
--        when mpp.PolicyCount < 11 then 5
--        when mpp.PolicyCount < 26 then 11
--        else 26
--    end PolicyCountBandKey
--from
--    [db-au-workspace]..mdmParty mp with(nolock)
--    cross apply
--    (
--        select
--            case
--                when DOB is null then -1
--                else
--                    floor(
--                        (
--                            datediff(month, DOB, getdate()) -
--                            case
--                                when datepart(day, DOB) < datepart(day, getdate()) then 1
--                                else 0
--                            end
--                        ) /
--                        12
--                    )
--            end CurrentAge
--    ) a
--    outer apply
--    (
--        select 
--            count(mpp.PolicyKey) PolicyCount
--        from
--            [db-au-workspace]..mdmPolicy mpp
--        where
--            mpp.PartyID = mp.PartyID
--    ) mpp
--    outer apply
--    (
--        select top 1 
--            dab.AgeBand
--        from
--            [db-au-star]..dimAgeBand dab
--        where
--            dab.Age = CurrentAge
--    ) dab
--order by
--    mpp.PolicyCount desc

GO
