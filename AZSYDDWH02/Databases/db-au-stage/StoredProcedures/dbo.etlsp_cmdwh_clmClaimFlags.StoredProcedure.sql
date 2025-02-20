USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmClaimFlags]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_clmClaimFlags]
    @DateRange varchar(30),
    @StartDate date = null,
    @EndDate date = null

as
begin

--20160811, LL, release to prod
--20160902, LL, electroniccount and electronicflag out of sync
--20190328, LL, change clmevent join, make it unique on claim level

    set nocount on

	
merge into [db-au-cba].[dbo].[clmClaimTags] with(tablock) t  
using uldwh02.[db-au-cmdwh].[dbo].[clmClaimTags] s 
 on  s.ClaimKey = t.ClaimKey and
     s.BIRowID =t.BIRowID


 when matched and (
            t.Classification     =  s.Classification or
            t.ClassificationText        =  s.ClassificationText or
            t.UpdateTime                =  s.UpdateTime 
		 )
        then  
 

            update  
            set  
            t.Classification            =  s.Classification,
            t.ClassificationText        =  s.ClassificationText,
            t.UpdateTime                =  s.UpdateTime


		 
 when not matched by target then  

      insert 
	        (
			     BIRowID,
               ClaimKey,
               Classification,
               ClassificationText,
               UpdateTime
			)

		values( 
		    s.BIRowID,
            s.ClaimKey,
            s.Classification,
            s.ClassificationText,
            s.UpdateTime
  );


    if @DateRange <> '_User Defined'
        select
            @StartDate = StartDate,
            @EndDate = EndDate
        from
            [db-au-cba].dbo.vDateRange
        where
            DateRange = @DateRange

    if object_id('tempdb..#claimflags') is not null
        drop table #claimflags

    ;with 
    cte_mental as
    (
        select 
            ct.ClaimKey,
            ced.EventDescription,
            --MentalScore,
            --wc.WordCount,
            --w.WordCountWeight,
            --w.PerilWeight,
            MentalScore * w.WordCountWeight * w.PerilWeight MentalScore -- >= 0.1
        from
            [db-au-cba]..clmClaimTags ct with(nolock)
            cross apply
            (
                select top 1
                    ce.*
                from
                    [db-au-cba]..clmEvent ce with(nolock)
                where
                    ce.ClaimKey = ct.ClaimKey and
                    not exists
                    (
                        select
                            null
                        from
                            [db-au-cba]..clmAuditEvent cae with(nolock)
                        where
                            cae.EventKey = ce.EventKey and
                            cae.AuditAction = 'D'
                    )
                order by 
                    ce.CreateDate desc
            ) ce
            outer apply
            (
                select top 1 *
                from
                    [db-au-cba]..clmOnlineClaimEvent oce with(nolock)
                where
                    oce.ClaimKey = ct.ClaimKey
            ) oce
            outer apply
            (
                select
                    case
                        when ce.EventDesc = ce.PerilDesc then ''
                        else ce.EventDesc + '. ' 
                    end +
                    isnull([db-au-workspace].dbo.fn_cleanexcel(oce.Detail) + '. ', '') +
                    isnull([db-au-workspace].dbo.fn_cleanexcel(oce.AdditionalDetail) + '.', '') EventDescription
            ) ced
            cross apply
            (
                select 
                    count(ItemNumber) WordCount
                from
                    [db-au-cba].dbo.fn_DelimitedSplit8K(EventDescription, '') i
                where
                    i.Item <> ''
            ) wc
            cross apply
            (
                select 
                    convert(xml, replace(ct.ClassificationText, '"utf-8"', '"utf-16"')) ClassificationXML
            ) cx
            cross apply 
            (
                select top 1
                    cat.value('abs_relevance[1]', 'float') MentalScore
                from
                    ClassificationXML.nodes('/response/category_list/category') as cat(cat)
            ) cat
            cross apply
            (
                select
                    case
                        when WordCount <= 1 then 4
                        when WordCount <= 5 then 3
                        when WordCount <= 10 then 1.6
                        when WordCount <= 20 then 1.45
                        when WordCount <= 30 then 1.3
                        when WordCount <= 40 then 1.1
                        when WordCount <= 50 then 1
                        when WordCount <= 75 then 0.95
                        when WordCount <= 224 then 0.9
                        when WordCount <= 400 then 0.8
                        when WordCount <= 10000 then 0.7
                        else 0.05             
                    end WordCountWeight,
                    case
                        when ce.PerilCode = 'PHI' then 1.18
                        when ce.PerilCode = 'PHD' then 1.1
                        when ce.PerilCode = 'PHJ' then 1.075
                        when ce.PerilCode = 'AMC' then 1.03
                        when ce.PerilCode = 'AAC' then 1.03
                        when ce.PerilCode = 'DEN' then 1.03
                        when ce.PerilCode = 'PHP' then 1.03
                        when ce.PerilCode = 'OTH' then 1.005
                        when ce.PerilCode = 'RPH' then 1.005
                        when ce.PerilCode = 'HRA' then 1
                        when ce.PerilCode = 'TDL' then 1
                        when ce.PerilCode = 'SKI' then 0.5
                        when ce.PerilCode = 'DLA' then 0.225
                        when ce.PerilCode = 'LOI' then 0.225
                        when ce.PerilCode = 'NAT' then 0.225
                        when ce.PerilCode = 'STI' then 0.225
                        when ce.PerilCode = 'CCD' then 0.15
                        when ce.PerilCode = 'VEH' then 0.15
                        when ce.PerilCode = 'DAI' then 0.15
                        when ce.PerilCode = 'NCC' then 0.15
                        else 0.05
                    end PerilWeight
            ) w
        where
            ct.Classification = 'Mental Health'
    ),
    cte_tags as
    (
        select 
            ct.ClaimKey,
            case
                when ClassRank = 1 then cat.Classification
                else null
            end PrimaryCategory,
            case
                when ClassRank = 1 then cat.AbsoluteRelevance
                else 0
            end PrimaryCategoryScore,
            case
                when ClassRank = 2 then cat.Classification
                else null
            end SecondaryCategory,
            case
                when ClassRank = 2 then cat.AbsoluteRelevance
                else 0
            end SecondaryCategoryScore,
            case
                when ClassRank = 3 then cat.Classification
                else null
            end TertiaryCategory,
            case
                when ClassRank = 3 then cat.AbsoluteRelevance
                else 0
            end TertiaryCategoryScore
        from
            [db-au-cba]..clmClaimTags ct with(nolock)
            cross apply
            (
                select 
                    convert(xml, replace(ct.ClassificationText, '"utf-8"', '"utf-16"')) ClassificationXML
            ) cx
            cross apply 
            (
                select top 3
                    cat.value('code[1]', 'varchar(max)') Classification,
                    cat.value('abs_relevance[1]', 'float') AbsoluteRelevance,
                    cat.value('relevance[1]', 'float') Relevance,
                    row_number() over (order by cat.value('relevance[1]', 'float') desc) ClassRank
                from
                    ClassificationXML.nodes('/response/category_list/category') as cat(cat)
                order by
                    cat.value('relevance[1]', 'float') desc
            ) cat
        where
            ct.Classification = 'TAGS'
    )
    select --top 100
        cl.ClaimKey,
        ced.EventDescription,
        ced.EventLocation,
        ce.EventCountryName,
        flags.MentalHealthFlag,
        flags.LuggageFlag,
        flags.ElectronicsFlag,
        flags.CruiseFlag,
        flags.MopedFlag,
        flags.RentalCarFlag,
        flags.WinterSportFlag,
        flags.CrimeVictimFlag,
        flags.FoodPoisoningFlag,
        flags.AnimalFlag,
        case
            when rf.MedicalCostCount > 1 then 1
            when exists
            (
                select
                    null
                from
                    [db-au-cba]..clmSection cs with(nolock)
                    inner join [db-au-cba]..vclmBenefitCategory cb with(nolock) on
                        cb.BenefitSectionKey = cs.BenefitSectionKey
                where
                    cs.ClaimKey = cl.ClaimKey and
                    cb.OperationalBenefitGroup = 'Medical'
            ) then 1
            else 0
        end MedicalCostFlag,
        redflags.LocationRedFlag,
        redflags.LuggageRedFlag,
        redflags.SectionRedFlag,
        redflags.HighValueLuggageRedFlag,
        redflags.MultipleElectronicRedFlag,
        redflags.OnlyElectronicRedFlag,
        redflags.NoProofRedFlag,
        redflags.NoReportRedFlag,
        redflags.CrimeVictimRedFlag
    into #claimflags
    from
        [db-au-cba]..clmClaim cl with(nolock)
        cross apply
        (
            select top 1
                ce.*
            from
                [db-au-cba]..clmEvent ce with(nolock)
            where
                ce.ClaimKey = cl.ClaimKey and
                not exists
                (
                    select
                        null
                    from
                        [db-au-cba]..clmAuditEvent cae with(nolock)
                    where
                        cae.EventKey = ce.EventKey and
                        cae.AuditAction = 'D'
                )
            order by 
                ce.CreateDate desc
        ) ce
        outer apply
        (
            select top 1 *
            from
                [db-au-cba]..clmOnlineClaimEvent oce with(nolock)
            where
                oce.ClaimKey = cl.ClaimKey
        ) oce
        --inner join [db-au-cba]..clmEvent ce with(nolock) on
        --    ce.ClaimKey = cl.ClaimKey
        --left join [db-au-cba]..clmOnlineClaimEvent oce with(nolock) on
        --    oce.ClaimKey = cl.ClaimKey
        outer apply
        (
            select
                case
                    when ce.EventDesc = ce.PerilDesc then ''
                    else ce.EventDesc + '. ' 
                end +
                isnull([db-au-workspace].dbo.fn_cleanexcel(oce.Detail) + '. ', '') +
                isnull([db-au-workspace].dbo.fn_cleanexcel(oce.AdditionalDetail) + '.', '') EventDescription,
                isnull([db-au-workspace].dbo.fn_cleanexcel(oce.EventLocation), '') EventLocation
        ) ced
        outer apply
        (
            select top 1 
                MentalScore
            from
                cte_mental cmh
            where
                cmh.ClaimKey = cl.ClaimKey
        ) mh
        outer apply
        (
            select
                max(ct.PrimaryCategory) PrimaryCategory,
                max(ct.PrimaryCategoryScore) PrimaryCategoryScore,
                max(ct.SecondaryCategory) SecondaryCategory,
                max(ct.SecondaryCategoryScore) SecondaryCategoryScore,
                max(ct.TertiaryCategory) TertiaryCategory,
                max(ct.TertiaryCategoryScore) TertiaryCategoryScore
            from
                cte_tags ct
            where
                ct.ClaimKey = cl.ClaimKey
        ) tags
        outer apply
        (
            select 
                0.35 TagThreshold,
                0.1 ElectronicThreshold
        ) tt
        outer apply
        (
            select
                case
                    when mh.MentalScore >= 0.1 then 1
                    else 0
                end MentalHealthFlag,
                case
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
                    when tags.SecondaryCategoryScore > tt.ElectronicThreshold and tags.SecondaryCategory = 'ELECTRONICS' then 0
                    when tags.TertiaryCategoryScore > tt.ElectronicThreshold and tags.TertiaryCategory = 'ELECTRONICS' then 0
                    when tags.PrimaryCategoryScore > tt.TagThreshold and tags.PrimaryCategory = 'LUGGAGE' then 1
                    when tags.SecondaryCategoryScore > tt.TagThreshold and tags.SecondaryCategory = 'LUGGAGE' then 1
                    else 0
                end LuggageFlag,
                case
                    when tags.PrimaryCategoryScore > tt.ElectronicThreshold and tags.PrimaryCategory = 'ELECTRONICS' then 1
                    when tags.SecondaryCategoryScore > tt.ElectronicThreshold and tags.SecondaryCategory = 'ELECTRONICS' then 1
                    when tags.TertiaryCategoryScore > tt.ElectronicThreshold and tags.TertiaryCategory = 'ELECTRONICS' then 1
                    else 0
                end ElectronicsFlag,
                case
                    when tags.PrimaryCategoryScore > tt.TagThreshold and tags.PrimaryCategory = 'CRUISE' then 1
                    when tags.SecondaryCategoryScore > tt.TagThreshold and tags.SecondaryCategory = 'CRUISE' then 1
                    else 0
                end CruiseFlag,
                case
                    when ce.PerilCode = 'MCA' then 1
                    when tags.PrimaryCategoryScore > tt.TagThreshold and tags.PrimaryCategory = 'MOTOR' then 1
                    when tags.SecondaryCategoryScore > tt.TagThreshold and tags.SecondaryCategory = 'MOTOR' then 1
                    else 0
                end MopedFlag,
                case
                    when tags.PrimaryCategoryScore > tt.TagThreshold and tags.PrimaryCategory = 'CAR' then 1
                    when tags.SecondaryCategoryScore > tt.TagThreshold and tags.SecondaryCategory = 'CAR' then 1
                    else 0
                end RentalCarFlag,
                case
                    when tags.PrimaryCategoryScore > tt.TagThreshold and tags.PrimaryCategory = 'WINTER' then 1
                    when tags.SecondaryCategoryScore > tt.TagThreshold and tags.SecondaryCategory = 'WINTER' then 1
                    else 0
                end WinterSportFlag,
                case
                    when tags.PrimaryCategoryScore > tt.TagThreshold and tags.PrimaryCategory = 'MUGGING' then 1
                    when tags.SecondaryCategoryScore > tt.TagThreshold and tags.SecondaryCategory = 'MUGGING' then 1
                    else 0
                end CrimeVictimFlag,
                case
                    when tags.PrimaryCategoryScore > tt.TagThreshold and tags.PrimaryCategory = 'POISON' then 1
                    when tags.SecondaryCategoryScore > tt.TagThreshold and tags.SecondaryCategory = 'POISON' then 1
                    else 0
                end FoodPoisoningFlag,
                case
                    when tags.PrimaryCategoryScore > tt.TagThreshold and tags.PrimaryCategory in ('ANIMAL', 'INSECT') then 1
                    when tags.SecondaryCategoryScore > tt.TagThreshold and tags.SecondaryCategory in ('ANIMAL', 'INSECT') then 1
                    else 0
                end AnimalFlag
        ) flags
        outer apply
        (
            select
                case
                    when flags.LuggageFlag = 1 then 1
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
                (
                    select 
                        sum(isnull(occ.Amount, 0))
                    from
                        [db-au-cba]..clmOnlineClaimCosts occ with(nolock)
                    where   
                        occ.ClaimKey = cl.ClaimKey and
                        occ.ExpenseType in ('Luggage', 'Other') 
                ) HighValue,
                (
                    select 
                        count(occ.BIRowID)
                    from
                        [db-au-cba]..clmOnlineClaimCosts occ with(nolock)
                    where   
                        occ.ClaimKey = cl.ClaimKey and
                        occ.ExpenseType in ('Medical')
                ) MedicalCostCount,
                (
                    select 
                        count(occ.BIRowID)
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
                ) ElectronicCount,
                (
                    select 
                        count(occ.BIRowID)
                    from
                        [db-au-cba]..clmOnlineClaimCosts occ with(nolock)
                    where   
                        occ.ClaimKey = cl.ClaimKey and
                        occ.ExpenseType in ('Luggage') and
                        occ.ProofAttached = 0
                ) NoProofCount,
                (
                    select 
                        count(occ.BIRowID)
                    from
                        [db-au-cba]..clmOnlineClaimCosts occ with(nolock)
                    where   
                        occ.ClaimKey = cl.ClaimKey and
                        occ.ExpenseType in ('Luggage', 'Additional', 'Other') and
                        occ.ProofAttached = 0 and
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
                ) ElectronicNoProofCount,
                (
                    select 
                        count(occ.BIRowID) 
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
                ) NonElectronicCount
        ) rf
        outer apply
        (
            select top 1
                Continent
            from
                [db-au-star]..dimDestination co
            where
                co.Destination = ce.EventCountryName
        ) co
        outer apply
        (
            select 
                case
                    when isnull(rf.HighValue, 0) > 5000 then 1
                    else 0
                end HighValueLuggageRedFlag,
                case
                    when flags.ElectronicsFlag > 0 and rf.ElectronicCount >= 2 then 1
                    else 0
                end MultipleElectronicRedFlag,
                case
                    when flags.ElectronicsFlag > 0 and rf.ElectronicCount >= 1 and rf.NonElectronicCount = 0 then 1
                    else 0
                end OnlyElectronicRedFlag,
                case
                    when rf.NoProofCount >= 1 then 1
                    else 0
                end NoProofRedFlag,
                case
                    when 
                        isnull(cl.OnlineClaim, 0) = 1 and 
                        rf.LuggageFlag = 1 and
                        isnull(oce.LossAuthorityNotified, 0) = 0
                    then 1
                    else 0
                end NoReportRedFlag,
                case
                    when rf.LuggageFlag = 1 and flags.CrimeVictimFlag = 1 then 1
                    else 0
                end CrimeVictimRedFlag,
                case
                    when isnull(rf.HighValue, 0) > 5000 then 1
                    when flags.ElectronicsFlag > 0 and rf.ElectronicCount > 3 then 1
                    when rf.ElectronicNoProofCount > 1 then 1
                    when flags.ElectronicsFlag > 0 and rf.ElectronicCount > 2 and rf.NonElectronicCount = 0 then 1
                    when 
                        isnull(cl.OnlineClaim, 0) = 1 and 
                        rf.LuggageFlag = 1 and
                        isnull(oce.LossAuthorityNotified, 0) = 0
                    then 1
                    when rf.LuggageFlag = 1 and flags.CrimeVictimFlag = 1 then 1
                    else 0
                end LuggageRedFlag,
                case
                    --africa
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%africa%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%cameroon%' then 1

                    --balkan
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%bosnia%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%serbia%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%croatia%' then 1

                    --middle east
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%lebanon%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%afghanistan%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%uae%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%emirate%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%egypt%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%iran%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%iraq%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%syria%' then 1

                    --south asia
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%india%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%pakistan%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%bangladesh%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%sri%lanka%' then 1

                    --south east asia
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%cambodia%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%vietnam%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%indonesia%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%laos%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%philippines%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%thailand%' then 1

                    --south america
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%col_mbia%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%mexico%' then 1
                    when isnull(co.Continent, '') + isnull(ce.EventCountryName, '') + isnull(oce.EventLocation, '') like '%nicaragua%' then 1

                    else 0
                end LocationRedFlag,
                case
                    when 
                        exists
                        (
                            select
                                null
                            from
                                [db-au-cba]..clmSection cs
                            where
                                cs.ClaimKey = cl.ClaimKey and
                                (
                                    cs.SectionDescription like 'Accidental Death%' or
                                    cs.SectionDescription like 'Kidnap%' or
                                    cs.SectionDescription like 'Hijacking%' or
                                    cs.SectionDescription like 'Personal Liability%'
                                )
                        )
                    then 1
                    else 0
                end SectionRedFlag
        ) redflags
    where
        exists
        (
            select
                null
            from
                [db-au-cba]..clmClaimTags r
            where
                r.ClaimKey = cl.ClaimKey and
                --r.UpdateTime >= '2016-08-12 09:00:00'
                r.UpdateTime >= @StartDate and
                r.UpdateTime <  dateadd(day, 1, @EndDate)
        )

--select
--    COLUMN_NAME + ' ' + DATA_TYPE + isnull('(' + convert(varchar, CHARACTER_MAXIMUM_LENGTH) + ')', '') + ',',
--    COLUMN_NAME + ','
--from
--    tempdb.INFORMATION_SCHEMA.COLUMNS
--where
--    table_name like '#claimflags%'

    if object_id('[db-au-cba]..clmClaimFlags') is null
    begin

        create table [db-au-cba]..clmClaimFlags
        (
            BIRowID bigint identity(1,1) not null,
            ClaimKey varchar(40) not null,
            CustomerID bigint,
            EventDescription nvarchar(max),
            EventLocation nvarchar(max),
            EventCountryName nvarchar(45),
            MentalHealthFlag bit,
            LuggageFlag bit,
            ElectronicsFlag bit,
            CruiseFlag bit,
            MopedFlag bit,
            RentalCarFlag bit,
            WinterSportFlag bit,
            CrimeVictimFlag bit,
            FoodPoisoningFlag bit,
            AnimalFlag bit,
            MedicalCostFlag bit,
            LocationRedFlag bit,
            LuggageRedFlag bit,
            SectionRedFlag bit,
            MultipleClaimRedFlag bit,
            MultipleClaimDPIDRedFlag bit,
            HighValueLuggageRedFlag bit,
            MultipleElectronicRedFlag bit,
            OnlyElectronicRedFlag bit,
            NoProofRedFlag bit,
            NoReportRedFlag bit,
            CrimeVictimRedFlag bit
        )

        create clustered index idx_clmClaimFlags_BIRowID on [db-au-cba]..clmClaimFlags (BIRowID)
        create nonclustered index idx_clmClaimFlags_ClaimKey on [db-au-cba]..clmClaimFlags (ClaimKey) include 
            (
                CustomerID,
                EventDescription,
                EventLocation,
                EventCountryName,
                MentalHealthFlag,
                LuggageFlag,
                ElectronicsFlag,
                CruiseFlag,
                MopedFlag,
                RentalCarFlag,
                WinterSportFlag,
                CrimeVictimFlag,
                FoodPoisoningFlag,
                AnimalFlag,
                MedicalCostFlag,
                LocationRedFlag,
                LuggageRedFlag,
                SectionRedFlag,
                MultipleClaimRedFlag,
                HighValueLuggageRedFlag,
                MultipleElectronicRedFlag,
                OnlyElectronicRedFlag,
                NoProofRedFlag,
                NoReportRedFlag,
                CrimeVictimRedFlag
            )
        create nonclustered index idx_clmClaimFlags_CustomerID on [db-au-cba]..clmClaimFlags (CustomerID) include (ClaimKey)

    end

    delete 
    from
        [db-au-cba]..clmClaimFlags
    where
        ClaimKey in
        (
            select
                ClaimKey
            from
                #claimflags
        )

    insert into [db-au-cba]..clmClaimFlags with(tablock)
    (
        ClaimKey,
        EventDescription,
        EventLocation,
        EventCountryName,
        MentalHealthFlag,
        LuggageFlag,
        ElectronicsFlag,
        CruiseFlag,
        MopedFlag,
        RentalCarFlag,
        WinterSportFlag,
        CrimeVictimFlag,
        FoodPoisoningFlag,
        AnimalFlag,
        LocationRedFlag,
        LuggageRedFlag,
        SectionRedFlag,
        MedicalCostFlag,
        HighValueLuggageRedFlag,
        MultipleElectronicRedFlag,
        OnlyElectronicRedFlag,
        NoProofRedFlag,
        NoReportRedFlag,
        CrimeVictimRedFlag
    )
    select
        ClaimKey,
        EventDescription,
        EventLocation,
        EventCountryName,
        MentalHealthFlag,
        LuggageFlag,
        ElectronicsFlag,
        CruiseFlag,
        MopedFlag,
        RentalCarFlag,
        WinterSportFlag,
        CrimeVictimFlag,
        FoodPoisoningFlag,
        AnimalFlag,
        LocationRedFlag,
        LuggageRedFlag,
        SectionRedFlag,
        MedicalCostFlag,
        HighValueLuggageRedFlag,
        MultipleElectronicRedFlag,
        OnlyElectronicRedFlag,
        NoProofRedFlag,
        NoReportRedFlag,
        CrimeVictimRedFlag
    from
        #claimflags

       
end




GO
