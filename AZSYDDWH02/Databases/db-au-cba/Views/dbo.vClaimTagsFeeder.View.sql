USE [db-au-cba]
GO
/****** Object:  View [dbo].[vClaimTagsFeeder]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [dbo].[vClaimTagsFeeder]
as
select --top 1000
    cl.ClaimKey,
    --cl.Onlineclaim,
    --ce.PerilDesc,
    --flags.*
    replace(PerilDesc, 'OTHER', 'OTHERPERIL') + '. ' Peril,
    EventDescription
from
    [db-au-cba]..clmClaim cl with(nolock)
    inner join [db-au-cba]..clmEvent ce with(nolock) on
        ce.ClaimKey = cl.ClaimKey
    left join [db-au-cba]..clmOnlineClaimEvent oce with(nolock) on
        oce.ClaimKey = cl.ClaimKey
    outer apply
    (
        select
            case
                when ce.PerilCode = 'SKI' then 1 --ski
                when ce.PerilCode = 'SNB' then 1 --snowboarding
                else 0
            end SnowFlag,
            case
                when ce.PerilCode = 'VEH' then 1 --hire vehicle
                when exists
                (
                    select 
                        null
                    from
                        [db-au-cba]..clmOnlineClaimCosts occ with(nolock)
                    where   
                        occ.ClaimKey = cl.ClaimKey and
                        occ.ExpenseType = 'Rental Car'
                ) then 1
                else 0
            end RentalFlag,
            case
                when ce.PerilCode = 'LOI' then 1 --lost item
                when ce.PerilCode = 'STI' then 1 --stolen item
                when ce.PerilCode = 'DAI' then 1 --damaged item
                when ce.PerilCode = 'CIV' then 1 --checkedin valuables
                when exists
                (
                    select 
                        null
                    from
                        [db-au-cba]..clmOnlineClaimCosts occ with(nolock)
                    where   
                        occ.ClaimKey = cl.ClaimKey and
                        occ.ExpenseType = 'Luggage'
                ) then 1
                else 0
            end LuggageFlag,
            case
                when exists
                (
                    select 
                        null
                    from
                        [db-au-cba]..clmOnlineClaimCosts occ with(nolock)
                    where   
                        occ.ClaimKey = cl.ClaimKey and
                        occ.ExpenseType in ('Luggage', 'Additional', 'Other') and
                        (
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%electronic%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%camera%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%dslr%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%laptop%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%notebook%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%mobile%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%ipad%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%ipod%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%tablet%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%samsung%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%galaxy%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%phone%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%android%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%canon%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%fuji%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%pentax%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%sony%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%toshiba%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%dell%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%lcd%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%screen%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%lens%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%macbook%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%gopro%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%charger%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%battery%' or
                            (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) like '%gps%'
                        )
                ) then 1
                else 0
            end ElectronicLuggageFlag,
            case
                when exists
                (
                    select 
                        null
                    from
                        [db-au-cba]..clmOnlineClaimCosts occ with(nolock)
                    where   
                        occ.ClaimKey = cl.ClaimKey and
                        occ.ExpenseType = 'Luggage' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%electronic%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%camera%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%dslr%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%laptop%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%notebook%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%mobile%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%ipad%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%ipod%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%tablet%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%samsung%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%galaxy%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%phone%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%android%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%canon%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%fuji%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%pentax%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%sony%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%toshiba%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%dell%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%lcd%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%screen%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%lens%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%macbook%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%gopro%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%charger%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%battery%' and
                        (isnull(occ.CostReason, '') + isnull(occ.CostDescription, '')) not like '%gps%'
                ) then 1
                else 0
            end NonElectronicLuggageFlag
    ) flags
    outer apply
    (
        select
            case
                when flags.SnowFlag = 1 then ''
                when flags.RentalFlag = 1 then 'Hire Vehicle. '
                else ''
            end +
            case
                when flags.RentalFlag = 1 then ''
                when flags.SnowFlag = 1 then 'Snow Sport. '
                else ''
            end +
            case
                when flags.SnowFlag = 1 then ''
                when flags.RentalFlag = 1 then ''
                when flags.LuggageFlag = 1 then 'Luggage Related. '
                else ''
            end +
            case
                when flags.SnowFlag = 1 then ''
                when flags.RentalFlag = 1 then ''
                when flags.ElectronicLuggageFlag = 1 then 'Electronics. '
                else ''
            end +
            case
                when flags.SnowFlag = 1 then ''
                when flags.RentalFlag = 1 then ''
                when flags.NonElectronicLuggageFlag = 1 then 'NonElec. '
                else ''
            end flagged
    ) f
    outer apply
    (
        select
            [db-au-workspace].dbo.[fn_cleanexcel]
            (
                isnull(f.flagged, '') + 
                isnull(replace(PerilDesc, 'OTHER', 'OTHERPERIL') + '. ', '') +
                case
                    when ce.EventDesc = ce.PerilDesc then ''
                    else isnull(ce.EventDesc + '. ', '')
                end +
                isnull(oce.Detail, '') + '. ' + 
                isnull(oce.AdditionalDetail, '') + '. ' + 
                isnull(oce.EventLocation, '')
            ) EventDescription
    ) ed
where
    cl.CreateDate >= '2005-07-01' and
    (
        cl.ClaimKey in
        (
            select 
                ClaimKey
            from
                clmAuditEvent
            where
                AuditDateTime >= dateadd(day, -3, convert(date, getdate()))
        ) or
        not exists
        (
            select 
                null
            from
                [db-au-cba]..clmClaimTags ct
            where
                ct.ClaimKey = cl.ClaimKey and
                ct.Classification = 'TAGS'
        ) or
        not exists
        (
            select 
                null
            from
                [db-au-cba]..clmClaimTags ct
            where
                ct.ClaimKey = cl.ClaimKey and
                ct.Classification = 'Mental Health'
        --) or
        --not exists
        --(
        --    select 
        --        null
        --    from
        --        clmClaimTags ct
        --    where
        --        ct.ClaimKey = cl.ClaimKey and
        --        ct.Classification = 'TOPICS'
        )
    )


--temporary
--and
--    (
--        EventDescription like '%iphone%' or
--        EventDescription like '%ipad%' or
--        EventDescription like '%ipod%' or
--        EventDescription like '%mobile_phone%' or
--        EventDescription like '%camera%' or
--        EventDescription like '%laptop%' or
--        EventDescription like '%phone_damage%' or
--        EventDescription like '%damaged_phone%' or
--        EventDescription like '%nokia%'
--    ) 



--    cl.CountryKey = 'AU'

--and cl.claimno = 852145











GO
