USE [db-au-star]
GO
/****** Object:  View [dbo].[v_ic_dimEvent]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[v_ic_dimEvent] as
select top 100 
    ce.CountryKey,
    ce.ClaimKey,
    ce.EventID,

    case
        when ce.EventDate < '2001-01-01' then '2000-01-01'
        when ce.EventDate is null then cl.CreateDate
        when ce.EventDate < convert(date, cl.PolicyIssuedDate) then convert(date, cl.PolicyIssuedDate)
        when ce.EventDate > dateadd(day, 1, convert(date, cl.CreateDate)) then cl.CreateDate
        else ce.EventDate
    end LossDate,

    coalesce(oce.PerilCode, ce.PerilCode, 'OTH') PerilCode,
    coalesce(oce.PerilDescription, ce.PerilDesc, 'OTHER') Peril,
    coalesce(oce.EventCountry, ce.EventCountryName, '') EventCountry,
    case
        when ce.CatastropheCode in ('CC', 'REC') then ''
        else isnull(ce.CatastropheCode, '') 
    end CatastropheCode,
    case
        when ce.CatastropheCode in ('CC', 'REC') then ''
        else isnull(ce.CatastropheShortDesc, '') 
    end Catastrophe
from
    [db-au-cba].dbo.clmEvent ce with(nolock)
    inner join [db-au-cba].dbo.clmClaim cl with(nolock) on
        cl.ClaimKey = ce.ClaimKey
    outer apply
    (
        select top 1 *
        from
            [db-au-cba].dbo.clmOnlineClaimEvent oce
        where
            oce.ClaimKey = ce.ClaimKey
        order by
            abs(datediff(day, oce.EventDateTime, ce.EventDate))
    ) oce
where
    ce.CountryKey <> ''
order by
    cl.CreateDate desc
GO
