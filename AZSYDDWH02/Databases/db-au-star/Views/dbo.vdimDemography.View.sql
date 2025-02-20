USE [db-au-star]
GO
/****** Object:  View [dbo].[vdimDemography]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE view [dbo].[vdimDemography] as
select --top 100
    PolicySK,
    PolicyKey, 
    CustomerID, 
    case when isnull(RiskProfile, '') = '' then 'UNKNOWN' else RiskProfile end as RiskProfile, 
    'UNKNOWN' as EmailDomain, 
    --case when isnull(EmailDomain, '') = '' then 'UNKNOWN' else EmailDomain end as EmailDomain, 
    case when isnull(AgeGroup, '') = '' then 'UNKNOWN' else AgeGroup end as AgeGroup, 
    case when isnull(ProductPreference, '') = '' then 'UNKNOWN' else ProductPreference end as ProductPreference, 
    case when isnull(ChannelPreference, '') = '' then 'UNKNOWN' else ChannelPreference end as ChannelPreference, 
    'UNKNOWN' as BrandAffiliation,
    --case when isnull(TravelPattern, '') = '' then 'UNKNOWN' else TravelPattern end as BrandAffiliation,
    case when isnull(BrandAffiliation, '') = '' then 'UNKNOWN' else BrandAffiliation end as TravelPattern, 
    case when isnull(TravelGroup, '') = '' then 'UNKNOWN' else TravelGroup end as TravelGroup, 
    case when isnull(DestinationGroup, '') = '' then 'UNKNOWN' else DestinationGroup end as DestinationGroup, 
    case when isnull(LocationProfile, '') = '' then 'UNKNOWN' else LocationProfile end as LocationProfile, 
    case when isnull(OwnershipProfile, '') = '' then 'UNKNOWN' else OwnershipProfile end as OwnershipProfile, 
    isnull(SuburbRank, 0) as SuburbRank, 

    ----cleanup non AU/NZ
    --case
    --    when left(PolicyKey, 2) not in ('AU', 'NZ') then 'UNKNOWN'
    --    when 
    --        not exists
    --        (
    --            select
    --                null
    --            from
    --                [db-au-cba]..usrsuburbprofile r
    --            where
    --                r.CountryDomain = left(PolicyKey, 2) and
    --                r.Suburb = ltrim(rtrim(dd.Suburb))
    --        ) then 'UNKNOWN'
    --    else ltrim(rtrim(Suburb))
    --end Suburb,
    --case
    --    when left(PolicyKey, 2) not in ('AU', 'NZ') then 'UNKNOWN' 
    --    when 
    --        not exists
    --        (
    --            select
    --                null
    --            from
    --                [db-au-cba]..usrsuburbprofile r
    --            where
    --                r.CountryDomain = left(PolicyKey, 2) and
    --                r.PostCode = ltrim(rtrim(dd.PostCode))
    --        ) then 'UNKNOWN'
    --    else ltrim(rtrim(dd.PostCode))
    --end PostCode,
    --'UNKNOWN' State

    case when isnull(Suburb, '') = '' then 'UNKNOWN' else Suburb end as Suburb, 
    case when isnull(PostCode, '') = '' then 'UNKNOWN' else PostCode end as PostCode, 
    case when isnull(State, '') = '' then 'UNKNOWN' else State end as State

from
    dimDemography dd with(nolock)
    
where
    PolicySK is not null




GO
