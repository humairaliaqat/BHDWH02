USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_rpt0611a]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[rptsp_rpt0611a]
as
begin
--20150914, LS, merge v3
--20151006, LS, remove v2
--20151006, LS, claim.net measures: left join the e5 data and use last estimate creator if it doesn't exists (NZ pre-e5 claims)
--20151008, LS, claim.net measures: treat incurred on absolute age 0 to be new claim, not reopened claim
--20151110, LS, claim.net measures: get latest work assignment, avoid duplicate records due to multiple work cases
--20151119, LS, claim.net measures: check estimate category movements to pick up claims opened and closed in the same day, consider this as closed
--              claim.net measures: check estimate category movements to pick up closed claims with new sections, consider this as reopened
--  not approved by user, changes above reverted
--20151127, LS, claim.net measures: check estimate category movements to pick up claims opened and closed in the same day, consider this as closed
--                                  counter balance the reopen
--20160318, LT, INC0005453, #v3WorkTypes can produce multiple rows of the same AssignedUser. When this table is joined in #v3combined, it produces duplication of metrics (eg. Completed number is doubled, Reopened number is doubled)
--				Fixed the duplication in #v3WorkTypes
--20160429, LS, bug fix on full outer joins, impact on Calls data & New/Diarised Claims
--              their temp tables were not referenced in AssignedUser & Date coalesces
--20160429, LS, add SuperGroup to output
--              due to the nature of the call data it's not broken down to supergroup

    set nocount on
    
    declare
        @start date,
        @end date

    select 
        @start = StartDate,
        @end = EndDate
    from
        [db-au-cba]..vDateRange
    where
        DateRange = 'Month-To-Date'

    if object_id('tempdb..#v3denial') is not null
        drop table #v3denial
        
    select 
        w.Country,
        isnull(o.SuperGroupName, '') SuperGroupName,
        coalesce(pw.AssignedUser, w.AssignedUser, 'Unassigned') AssignedUser,
        convert(date, wa.CompletionDate) [Date],
        count(distinct isnull(pw.ClaimNumber, w.ClaimNumber)) Declines
    into #v3denial
    from
        [db-au-cba]..e5WorkActivity wa
        inner join [db-au-cba]..e5WorkItems wi on
            wi.ID = wa.AssessmentOutcome
        inner join [db-au-cba]..e5Work w on
            w.Work_ID = wa.Work_ID
        inner join [db-au-cba]..clmClaim cl on
            cl.ClaimKey = w.ClaimKey
        outer apply
        (
            select top 1 
                o.SuperGroupName
            from
                [db-au-cba]..penOutlet o
            where
                o.OutletStatus = 'Current' and
                o.OutletKey = cl.OutletKey
        ) o
        left join [db-au-cba]..e5Work pw on
            pw.Work_ID = w.Parent_ID
    where
        w.WorkType like '%claim%' and
        wa.CompletionDate >= @start and
        wa.CompletionDate <  dateadd(day, 1, @end) and
        CategoryActivityName = 'Assessment Outcome' and
        wa.AssessmentOutcomeDescription = 'Deny'
    group by
        w.Country,
        isnull(o.SuperGroupName, ''),
        coalesce(pw.AssignedUser, w.AssignedUser, 'Unassigned'),
        convert(date, wa.CompletionDate)

    if object_id('tempdb..#v3worktypesTemp') is not null
        drop table #v3worktypesTemp

	select 
		w.Country,
        isnull(o.SuperGroupName, '') SuperGroupName,
		coalesce(pw.AssignedUser, w.AssignedUser, 'Unassigned') AssignedUser,
		convert(date, w.CreationDate) [Date],
		count(
			distinct
			case
				when w.WorkType = 'Complaints' and w.GroupType = 'New' then isnull(pw.ClaimNumber, w.ClaimNumber)
				else null
			end
		) Complaints,
		0 IDR,
		count(
			distinct
			case
				when w.WorkType = 'Phone Call' and w.GroupType = 'Call Back' then isnull(pw.ClaimNumber, w.ClaimNumber)
				else null
			end
		) CallBack
	into #v3worktypesTemp
	from
		[db-au-cba]..e5Work w
        inner join [db-au-cba]..clmClaim cl on
            cl.ClaimKey = w.ClaimKey
        outer apply
        (
            select top 1 
                o.SuperGroupName
            from
                [db-au-cba]..penOutlet o
            where
                o.OutletStatus = 'Current' and
                o.OutletKey = cl.OutletKey
        ) o
		left join [db-au-cba]..e5Work pw on
			pw.Work_ID = w.Parent_ID
	where
		w.CreationDate >= @start and
		w.CreationDate <  dateadd(day, 1, @end) and
		(
			(
				w.WorkType = 'Complaints' and
				w.GroupType = 'New'
			) or
			(
				w.WorkType = 'Phone Call' and
				w.GroupType = 'Call Back'
                
			)
		)
	group by
		w.Country,
        isnull(o.SuperGroupName, ''),
		coalesce(pw.AssignedUser, w.AssignedUser, 'Unassigned'),
		convert(date, w.CreationDate)

    insert into #v3worktypesTemp
    select 
        w.Country,
        isnull(o.SuperGroupName, '') SuperGroupName,
        w.CreationUser AssignedUser,
        convert(date, w.CreationDate) [Date],
        0 Complaints,
        count(
            distinct
            case
                when w.WorkType = 'Complaints' and w.GroupType like '%IDR%' then w.ClaimNumber
                else null
            end
        ) IDR,
        0 CallBack
    from
        [db-au-cba]..e5Work w
        inner join [db-au-cba]..clmClaim cl on
            cl.ClaimKey = w.ClaimKey
        outer apply
        (
            select top 1 
                o.SuperGroupName
            from
                [db-au-cba]..penOutlet o
            where
                o.OutletStatus = 'Current' and
                o.OutletKey = cl.OutletKey
        ) o
    where
        w.CreationDate >= @start and
        w.CreationDate <  dateadd(day, 1, @end) and
        w.WorkType = 'Complaints' and
        w.GroupType like '%IDR%'
    group by
        w.Country,
        isnull(o.SuperGroupName, ''),
        w.CreationUser,
        convert(date, w.CreationDate)

    if object_id('tempdb..#v3worktypes') is not null
        drop table #v3worktypes

    select 
		a.Country,
        a.SuperGroupName,
		a.AssignedUser,
		a.[Date],
		sum(a.Complaints) as Complaints,
		sum(a.IDR) as IDR,
		sum(a.CallBack) as CallBack
	into #v3worktypes
	from #v3worktypestemp a
	group by
		a.Country,
        a.SuperGroupName,
		a.AssignedUser,
		a.[Date]

    if object_id('tempdb..#v3paymentmade') is not null
        drop table #v3paymentmade

    select 
        w.Country,
        isnull(o.SuperGroupName, '') SuperGroupName,
        isnull(w.AssignedUser, 'Unassigned') AssignedUser,
        convert(date, cp.CreatedDate) [Date],
        sum(cp.PaymentAmount) PaymentMade
    into #v3paymentmade
    from
        [db-au-cba]..clmPayment cp
        inner join [db-au-cba]..clmClaim cl on
            cl.ClaimKey = cp.ClaimKey
        inner join [db-au-cba]..e5Work w on
            w.ClaimKey = cl.ClaimKey
        outer apply
        (
            select top 1 
                o.SuperGroupName
            from
                [db-au-cba]..penOutlet o
            where
                o.OutletStatus = 'Current' and
                o.OutletKey = cl.OutletKey
        ) o
    where
        w.WorkType like '%claim%' and
        cp.isDeleted = 0 and
        cp.CreatedDate >= @start and
        cp.CreatedDate <  dateadd(day, 1, @end)
    group by
        w.Country,
        isnull(o.SuperGroupName, ''),
        w.AssignedUser,
        convert(date, cp.CreatedDate)

    if object_id('tempdb..#v3sofraw') is not null
        drop table #v3sofraw

    select 
        cl.CountryKey Country,
        isnull(o.SuperGroupName, '') SuperGroupName,
        cl.ClaimKey,
        convert(date, LastEstimateDate) [Date],
        isnull(Paid, 0) Paid,
        isnull(FirstEstimate, 0) FirstEstimate
    into #v3sofraw
    from
        [db-au-cba]..clmClaim cl
        cross apply
        (
            select 
                sum(isnull(LastEstimate, 0)) LastEstimate,
                max(LastEstimateDate) LastEstimateDate
            from
                [db-au-cba]..clmSection cs
                cross apply
                (
                    select top 1 
                        eh.EHEstimateValue LastEstimate,
                        convert(date, eh.EHCreateDate) LastEstimateDate
                    from
                        [db-au-cba]..clmEstimateHistory eh
                    where
                        eh.SectionKey = cs.SectionKey
                    order by
                        eh.EHCreateDate desc
                ) eh
            where
                cs.isDeleted = 0 and
                cs.ClaimKey = cl.ClaimKey
        ) cle
        outer apply
        (
            select 
                sum(cp.PaymentAmount) Paid
            from
                [db-au-cba]..clmPayment cp
            where
                cp.ClaimKey = cl.ClaimKey and
                cp.isDeleted = 0 and
                cp.PaymentStatus = 'PAID'
        ) p
        cross apply
        (
            select 
                sum(isnull(FirstEstimate, 0)) FirstEstimate
            from
                [db-au-cba]..clmSection cs
                cross apply
                (
                    select top 1 
                        eh.EHEstimateValue FirstEstimate
                    from
                        [db-au-cba]..clmEstimateHistory eh
                    where
                        eh.SectionKey = cs.SectionKey and
                        eh.EHEstimateValue <> 0
                    order by
                        eh.EHCreateDate 
                ) eh
            where
                cs.isDeleted = 0 and
                cs.ClaimKey = cl.ClaimKey
        ) cfe
        outer apply
        (
            select top 1 
                o.SuperGroupName
            from
                [db-au-cba]..penOutlet o
            where
                o.OutletStatus = 'Current' and
                o.OutletKey = cl.OutletKey
        ) o
    where
        isnull(LastEstimate, 0) = 0 and
        LastEstimateDate >= @start and
        LastEstimateDate <  dateadd(day, 1, @end)

    if object_id('tempdb..#v3sof') is not null
        drop table #v3sof

    select 
        w.Country,
        cl.SuperGroupName,
        isnull(w.AssignedUser, 'Unassigned') AssignedUser,
        [Date],
        sum(Paid) Paid,
        sum(FirstEstimate) FirstEstimate
    into #v3sof
    from
        #v3sofraw cl
        inner join [db-au-cba]..e5Work w on
            w.ClaimKey = cl.ClaimKey
    where
        w.WorkType like '%claim%'
    group by
        w.Country,
        cl.SuperGroupName,
        isnull(w.AssignedUser, 'Unassigned'),
        [Date]

    if object_id('tempdb..#v3e5ncc') is not null
        drop table #v3e5ncc
        
    select 
        w.Country,
        isnull(o.SuperGroupName, '') SuperGroupName,
        isnull(AssignedUser, 'Unassigned') AssignedUser,
        convert(date, we.EventDate) [Date],
        count(
            distinct 
            case
                when we.StatusName = 'Active' then null
                else cl.ClaimNo
            end 
        ) e5Completed,
        sum(
            case
                when we.StatusName = 'Active' then 0
                else ce.Estimate
            end 
        ) e5CompletedValue,
        count(
            distinct
            case
                when we.StatusName = 'Complete' then null
                else cl.ClaimNo
            end 
        ) e5Reopened,
        sum(
            case
                when we.StatusName = 'Complete' then 0
                else ce.Estimate
            end 
        ) e5ReopenedValue
    into #v3e5ncc
    from
        [db-au-cba]..e5Work w
        inner join [db-au-cba]..clmClaim cl on
            cl.ClaimKey = w.ClaimKey
        outer apply
        (
            select top 1 
                o.SuperGroupName
            from
                [db-au-cba]..penOutlet o
            where
                o.OutletStatus = 'Current' and
                o.OutletKey = cl.OutletKey
        ) o
        inner join [db-au-cba]..e5WorkEvent we on
            we.Work_Id = w.Work_ID
        cross apply
        (
            select top 1
                r.StatusName PreviousStatus
            from
                [db-au-cba]..e5WorkEvent r
            where
                r.Work_Id = w.Work_ID and
                r.EventDate < we.EventDate
            order by 
                r.EventDate desc
        ) r
        outer apply
        (
            select 
                sum(isnull(EHEstimateValue, 0)) Estimate
            from
                [db-au-cba]..clmSection cs
                outer apply
                (
                    select top 1 
                        ceh.EHEstimateValue
                    from
                        [db-au-cba]..clmEstimateHistory ceh
                    where
                        ceh.SectionKey = cs.SectionKey and
                        ceh.EHCreateDate < dateadd(day, 1, convert(date, we.EventDate)) --last estimate on event date, track completed cases, must be 0
                    order by
                        ceh.EHCreateDate desc
                ) ceh
            where
                cs.ClaimKey = cl.ClaimKey and
                cs.isDeleted = 0
        ) ce
    where
        w.WorkType like '%claim%' and
        we.EventDate >= @start and
        we.EventDate <  dateadd(day, 1, @end) and
        we.EventName in ('Changed Work Status', 'Merged Work') and
        (
            (
                we.StatusName = 'Active' and
                r.PreviousStatus = 'Complete'
            ) or
            (
                we.StatusName = 'Complete' and
                r.PreviousStatus = 'Active'
            )
        )
    group by
        w.Country,
        isnull(o.SuperGroupName, ''),
        isnull(AssignedUser, 'Unassigned'),
        convert(date, we.EventDate)
        
        
    if object_id('tempdb..#v3ncc') is not null
        drop table #v3ncc
        
    select 
        cl.CountryKey Country,
        isnull(o.SuperGroupName, '') SuperGroupName,
        coalesce(AssignedUser, EHCreatedBy, 'Unassigned') AssignedUser,
        convert(date, IncurredDate) [Date],
        count(
            distinct
            case
                when ci.Estimate = 0 and (ci.PreviousEstimate <> 0 or ci.RedundantMovements > 0) then cl.ClaimKey
                else null
            end 
        ) Completed,
        count(
            distinct
            case
                when ci.NewMovements > 0 and (ci.PreviousAbsoluteAge > 0 or ci.PreviousRedundantMovements > 0) then cl.ClaimKey
                when ci.ReopenedMovements > 0 and (ci.PreviousAbsoluteAge > 0 or ci.PreviousRedundantMovements > 0) then cl.ClaimKey
                when ci.Estimate <> 0 then cl.ClaimKey
                else null
            end 
        ) Reopened
    into #v3ncc
    from
        [db-au-cba]..clmClaim cl
        outer apply
        (
            select top 1 
                o.SuperGroupName
            from
                [db-au-cba]..penOutlet o
            where
                o.OutletStatus = 'Current' and
                o.OutletKey = cl.OutletKey
        ) o
        outer apply
        (
            select top 1
                w.AssignedUser
            from
                [db-au-cba]..e5Work w
            where
                w.WorkType like '%claim%' and
                w.ClaimKey = cl.ClaimKey and
                w.CreationDate < dateadd(day, 1, @end)
            order by
                w.CreationDate desc
        ) w
        inner join [db-au-cba]..vclmClaimIncurred ci on
            ci.ClaimKey = cl.ClaimKey
        outer apply
        (
            select top 1 
                EHCreatedBy
            from
                [db-au-cba]..clmEstimateHistory ceh
            where
                ceh.ClaimKey = cl.ClaimKey and
                ceh.EHCreateDate < dateadd(day, 1, ci.IncurredDate)
            order by
                ceh.EHCreateDate desc
        ) ceh
    where
        IncurredDate >= @start and
        IncurredDate <  dateadd(day, 1, @end) and
        (
            --closed
            (
                ci.Estimate = 0 and
                (
                    ci.PreviousEstimate <> 0 or
                    ci.RedundantMovements > 0
                )
            ) or
            --reopened
            (
                ci.Estimate <> 0 and
                ci.PreviousEstimate = 0 and
                ci.AbsoluteAge > 0 and
                ci.PreviousAbsoluteAge > 0
            ) 
        )
    group by
        cl.CountryKey,
        isnull(o.SuperGroupName, ''),
        coalesce(AssignedUser, EHCreatedBy, 'Unassigned'),
        convert(date, IncurredDate)
        
    if object_id('tempdb..#v3calls') is not null
        drop table #v3calls
        
    ;with 
    cte_in as
    (
        select 
            AgentName,
            convert(date, cd.CallStartDateTime) [Date],
            sum(cd.CallsHandled) CallsHandled
        from
            [db-au-cba]..cisCallData cd
            inner join [db-au-cba]..cisAgent a on
                a.AgentKey = cd.AgentKey
        where
            cd.CallStartDateTime >= @start and
            cd.CallStartDateTime <  dateadd(day, 1, @end)
        group by
            AgentName,
            convert(date, cd.CallStartDateTime)
    ),
    cte_out as
    (
        select 
            AgentName,
            convert(date, cd.CallStartDateTime) [Date],
            count(cd.BIRowID) CallsMade
        from
            [db-au-cba]..cisOutboundCallData cd
            inner join [db-au-cba]..cisAgent a on
                a.AgentKey = cd.AgentKey
        where
            cd.CallStartDateTime >= @start and
            cd.CallStartDateTime <  dateadd(day, 1, @end)
        group by
            AgentName,
            convert(date, cd.CallStartDateTime)
    ),
    cte_ready as
    (
        select 
            a.AgentName,
            convert(date, EventDateTime) [Date],
            sum(EventDuration) / 3600.0 OnReady,
            case
                when d.isWeekDay = 1 and d.isHoliday = 0 then 5.5
                else 0
            end MinOnReady
        from
            [db-au-cba]..cisAgentState cas
            inner join [db-au-cba]..cisAgent a on
                a.AgentKey = cas.AgentKey
            inner join [db-au-cba]..Calendar d on
                d.[Date] = convert(date, EventDateTime)
        where
            cas.EventDateTime >= @start and
            cas.EventDateTime <  dateadd(day, 1, @end) and
            cas.EventDescription not in ('Not Ready', 'Logout')
        group by
            AgentName,
            convert(date, EventDateTime),
            d.isWeekDay,
            d.isHoliday
    )
    select 
        coalesce(i.AgentName, o.AgentName) AssignedUser,
        '' SuperGroupName,
        coalesce(i.[Date], o.[Date]) [Date],
        sum(isnull(CallsHandled, 0)) InboundCalls,
        sum(isnull(CallsMade, 0)) OutboundCalls,
        sum(isnull(OnReady, 0)) OnReady,
        sum(isnull(MinOnReady, 0)) MinOnReady
    into #v3calls
    from
        cte_in i
        full outer join cte_out o on
            o.AgentName = i.AgentName and
            o.[Date] = i.[Date]
        full outer join cte_ready r on
            r.AgentName = i.AgentName and
            r.[Date] = i.[Date]
    group by
        coalesce(i.AgentName, o.AgentName),
        coalesce(i.[Date], o.[Date])
        
    if object_id('tempdb..#v3newclaim') is not null
        drop table #v3newclaim
    
    select 
        w.Country,
        isnull(o.SuperGroupName, '') SuperGroupName,
        isnull(AssignedUser, 'Unassigned') AssignedUser,
        convert(date, cl.CreateDate) [Date],
        count(cl.ClaimKey) NewClaim,
        sum(isnull(ce.Estimate, 0)) NewClaimValue
    into #v3newclaim
    from
        [db-au-cba]..clmClaim cl
        outer apply
        (
            select top 1 
                o.SuperGroupName
            from
                [db-au-cba]..penOutlet o
            where
                o.OutletStatus = 'Current' and
                o.OutletKey = cl.OutletKey
        ) o
        inner join [db-au-cba]..e5Work w on
            w.ClaimKey = cl.ClaimKey
        outer apply
        (
            select 
                sum(isnull(EHEstimateValue, 0)) Estimate
            from
                [db-au-cba]..clmSection cs
                outer apply
                (
                    select top 1 
                        ceh.EHEstimateValue
                    from
                        [db-au-cba]..clmEstimateHistory ceh
                    where
                        ceh.SectionKey = cs.SectionKey and
                        ceh.EHCreateDate < dateadd(day, 1, convert(date, cl.CreateDate))
                    order by
                        ceh.EHCreateDate desc
                ) ceh
            where
                cs.ClaimKey = cl.ClaimKey and
                cs.isDeleted = 0
        ) ce
    where
        w.WorkType like '%claim%' and
        cl.CreateDate >= @start and
        cl.CreateDate <  dateadd(day, 1, @end)
    group by
        w.Country,
        isnull(o.SuperGroupName, ''),
        isnull(AssignedUser, 'Unassigned'),
        convert(date, cl.CreateDate)

    if object_id('tempdb..#v3diarisedclaim') is not null
        drop table #v3diarisedclaim
        
    select 
        w.Country,
        isnull(o.SuperGroupName, '') SuperGroupName,
        isnull(AssignedUser, 'Unassigned') AssignedUser,
        convert(date, we.EventDate) [Date],
        count(distinct w.ClaimKey) DiarisedClaim,
        sum(isnull(ce.Estimate, 0)) DiarisedClaimValue
    into #v3diarisedclaim
    from
        [db-au-cba]..e5WorkEvent we
        inner join [db-au-cba]..e5Work w on
            w.Work_ID = we.Work_Id
        inner join [db-au-cba]..clmClaim cl on
            cl.ClaimKey = w.ClaimKey
        outer apply
        (
            select top 1 
                o.SuperGroupName
            from
                [db-au-cba]..penOutlet o
            where
                o.OutletStatus = 'Current' and
                o.OutletKey = cl.OutletKey
        ) o
        outer apply
        (
            select 
                sum(isnull(EHEstimateValue, 0)) Estimate
            from
                [db-au-cba]..clmSection cs
                outer apply
                (
                    select top 1 
                        ceh.EHEstimateValue
                    from
                        [db-au-cba]..clmEstimateHistory ceh
                    where
                        ceh.SectionKey = cs.SectionKey and
                        ceh.EHCreateDate < we.EventDate
                    order by
                        ceh.EHCreateDate desc
                ) ceh
            where
                cs.ClaimKey = w.ClaimKey and
                cs.isDeleted = 0
        ) ce
    where
        w.WorkType like '%claim%' and
        we.EventName = 'Changed Work Status' and
        we.StatusName = 'Diarised' and
        we.EventDate >= @start and
        we.EventDate <  dateadd(day, 1, @end)
    group by
        w.Country,
        isnull(o.SuperGroupName, ''),
        isnull(AssignedUser, 'Unassigned'),
        convert(date, we.EventDate)
        
        
    if object_id('tempdb..#v3combined') is not null
        drop table #v3combined

    select 
        isnull(Country, 'AU') Country,
        isnull(SuperGroupName, '') SuperGroupName,
        isnull(AssignedUser, 'Unassigned') AssignedUser,
        [Date],
        isnull(Declines, 0) Declines,
        0 Complaints,
        0 IDR,
        0 CallBack,
        0 PaymentMade,
        0 Paid,
        0 FirstEstimate,
        0 InboundCalls,
        0 OutboundCalls,
        0 OnReady,
        0 MinOnReady,
        0 e5Completed,
        0 e5CompletedValue,
        0 e5Reopened,
        0 e5ReopenedValue,
        0 Completed,
        0 Reopened,
        0 NewClaim,
        0 NewClaimValue,
        0 DiarisedClaim,
        0 DiarisedClaimValue
    into #v3combined
    from
        #v3denial

    insert into #v3combined
    select 
        isnull(Country, 'AU') Country,
        isnull(SuperGroupName, '') SuperGroupName,
        isnull(AssignedUser, 'Unassigned') AssignedUser,
        [Date],
        0 Declines,
        isnull(Complaints, 0) Complaints,
        isnull(IDR, 0) IDR,
        isnull(CallBack, 0) CallBack,
        0 PaymentMade,
        0 Paid,
        0 FirstEstimate,
        0 InboundCalls,
        0 OutboundCalls,
        0 OnReady,
        0 MinOnReady,
        0 e5Completed,
        0 e5CompletedValue,
        0 e5Reopened,
        0 e5ReopenedValue,
        0 Completed,
        0 Reopened,
        0 NewClaim,
        0 NewClaimValue,
        0 DiarisedClaim,
        0 DiarisedClaimValue
    from
        #v3worktypes

    insert into #v3combined
    select 
        isnull(Country, 'AU') Country,
        isnull(SuperGroupName, '') SuperGroupName,
        isnull(AssignedUser, 'Unassigned') AssignedUser,
        [Date],
        0 Declines,
        0 Complaints,
        0 IDR,
        0 CallBack,
        isnull(PaymentMade, 0) PaymentMade,
        0 Paid,
        0 FirstEstimate,
        0 InboundCalls,
        0 OutboundCalls,
        0 OnReady,
        0 MinOnReady,
        0 e5Completed,
        0 e5CompletedValue,
        0 e5Reopened,
        0 e5ReopenedValue,
        0 Completed,
        0 Reopened,
        0 NewClaim,
        0 NewClaimValue,
        0 DiarisedClaim,
        0 DiarisedClaimValue
    from
        #v3paymentmade

    insert into #v3combined
    select 
        isnull(Country, 'AU') Country,
        isnull(SuperGroupName, '') SuperGroupName,
        isnull(AssignedUser, 'Unassigned') AssignedUser,
        [Date],
        0 Declines,
        0 Complaints,
        0 IDR,
        0 CallBack,
        0 PaymentMade,
        isnull(Paid, 0) Paid,
        isnull(FirstEstimate, 0) FirstEstimate,
        0 InboundCalls,
        0 OutboundCalls,
        0 OnReady,
        0 MinOnReady,
        0 e5Completed,
        0 e5CompletedValue,
        0 e5Reopened,
        0 e5ReopenedValue,
        0 Completed,
        0 Reopened,
        0 NewClaim,
        0 NewClaimValue,
        0 DiarisedClaim,
        0 DiarisedClaimValue
    from
        #v3sof

    insert into #v3combined
    select 
        isnull(Country, 'AU') Country,
        isnull(SuperGroupName, '') SuperGroupName,
        isnull(AssignedUser, 'Unassigned') AssignedUser,
        [Date],
        0 Declines,
        0 Complaints,
        0 IDR,
        0 CallBack,
        0 PaymentMade,
        0 Paid,
        0 FirstEstimate,
        0 InboundCalls,
        0 OutboundCalls,
        0 OnReady,
        0 MinOnReady,
        isnull(e5Completed, 0) e5Completed,
        isnull(e5CompletedValue, 0) e5CompletedValue,
        isnull(e5Reopened, 0) e5Reopened,
        isnull(e5ReopenedValue, 0) e5ReopenedValue,
        0 Completed,
        0 Reopened,
        0 NewClaim,
        0 NewClaimValue,
        0 DiarisedClaim,
        0 DiarisedClaimValue
    from
        #v3e5ncc
        
    insert into #v3combined
    select 
        isnull(Country, 'AU') Country,
        isnull(SuperGroupName, '') SuperGroupName,
        isnull(AssignedUser, 'Unassigned') AssignedUser,
        [Date],
        0 Declines,
        0 Complaints,
        0 IDR,
        0 CallBack,
        0 PaymentMade,
        0 Paid,
        0 FirstEstimate,
        0 InboundCalls,
        0 OutboundCalls,
        0 OnReady,
        0 MinOnReady,
        0 e5Completed,
        0 e5CompletedValue,
        0 e5Reopened,
        0 e5ReopenedValue,
        isnull(Completed, 0) Completed,
        isnull(Reopened, 0) Reopened,
        0 NewClaim,
        0 NewClaimValue,
        0 DiarisedClaim,
        0 DiarisedClaimValue
    from
        #v3ncc

    insert into #v3combined
    select 
        isnull(Country, 'AU') Country,
        isnull(SuperGroupName, '') SuperGroupName,
        isnull(AssignedUser, 'Unassigned') AssignedUser,
        [Date],
        0 Declines,
        0 Complaints,
        0 IDR,
        0 CallBack,
        0 PaymentMade,
        0 Paid,
        0 FirstEstimate,
        0 InboundCalls,
        0 OutboundCalls,
        0 OnReady,
        0 MinOnReady,
        0 e5Completed,
        0 e5CompletedValue,
        0 e5Reopened,
        0 e5ReopenedValue,
        0 Completed,
        0 Reopened,
        isnull(NewClaim, 0) NewClaim,
        isnull(NewClaimValue, 0) NewClaimValue,
        0 DiarisedClaim,
        0 DiarisedClaimValue
    from
        #v3newclaim

    insert into #v3combined
    select 
        isnull(Country, 'AU') Country,
        isnull(SuperGroupName, '') SuperGroupName,
        isnull(AssignedUser, 'Unassigned') AssignedUser,
        [Date],
        0 Declines,
        0 Complaints,
        0 IDR,
        0 CallBack,
        0 PaymentMade,
        0 Paid,
        0 FirstEstimate,
        0 InboundCalls,
        0 OutboundCalls,
        0 OnReady,
        0 MinOnReady,
        0 e5Completed,
        0 e5CompletedValue,
        0 e5Reopened,
        0 e5ReopenedValue,
        0 Completed,
        0 Reopened,
        0 NewClaim,
        0 NewClaimValue,
        isnull(DiarisedClaim, 0) DiarisedClaim,
        isnull(DiarisedClaimValue, 0) DiarisedClaimValue
    from
        #v3diarisedclaim

    insert into #v3combined
    select 
        'AU' Country,
        '' SuperGroupName,
        isnull(c.AssignedUser, 'Unassigned') AssignedUser,
        c.[Date],
        0 Declines,
        0 Complaints,
        0 IDR,
        0 CallBack,
        0 PaymentMade,
        0 Paid,
        0 FirstEstimate,
        isnull(InboundCalls, 0) InboundCalls,
        isnull(OutboundCalls, 0) OutboundCalls,
        isnull(OnReady, 0) OnReady,
        isnull(MinOnReady, 0) MinOnReady,
        0 e5Completed,
        0 e5CompletedValue,
        0 e5Reopened,
        0 e5ReopenedValue,
        0 Completed,
        0 Reopened,
        0 NewClaim,
        0 NewClaimValue,
        0 DiarisedClaim,
        0 DiarisedClaimValue
    from
        #v3calls c

    insert into #v3combined
    select 
        'AU' Country,
        '' SuperGroupName,
        'Unassigned' AssignedUser,
        d.[Date],
        0 Declines,
        0 Complaints,
        0 IDR,
        0 CallBack,
        0 PaymentMade,
        0 Paid,
        0 FirstEstimate,
        0 InboundCalls,
        0 OutboundCalls,
        0 OnReady,
        0 MinOnReady,
        0 e5Completed,
        0 e5CompletedValue,
        0 e5Reopened,
        0 e5ReopenedValue,
        0 Completed,
        0 Reopened,
        0 NewClaim,
        0 NewClaimValue,
        0 DiarisedClaim,
        0 DiarisedClaimValue
    from
        [db-au-cba]..vDateRange dr
        inner join [db-au-cba]..Calendar d on
            d.[Date] between dr.StartDate and dr.EndDate
    where
        DateRange = 'Month-to-date'
        
    insert into #v3combined
    select 
        'NZ' Country,
        '' SuperGroupName,
        'Unassigned' AssignedUser,
        d.[Date],
        0 Declines,
        0 Complaints,
        0 IDR,
        0 CallBack,
        0 PaymentMade,
        0 Paid,
        0 FirstEstimate,
        0 InboundCalls,
        0 OutboundCalls,
        0 OnReady,
        0 MinOnReady,
        0 e5Completed,
        0 e5CompletedValue,
        0 e5Reopened,
        0 e5ReopenedValue,
        0 Completed,
        0 Reopened,
        0 NewClaim,
        0 NewClaimValue,
        0 DiarisedClaim,
        0 DiarisedClaimValue
    from
        [db-au-cba]..vDateRange dr
        inner join [db-au-cba]..Calendar d on
            d.[Date] between dr.StartDate and dr.EndDate
    where
        DateRange = 'Month-to-date'

    --merge

    select 
        Country,
        SuperGroupName,
        AssignedUser,
        TeamLeader,
        TimePeriod,
        sum(Declines) Declines,
        sum(Complaints) Complaints,
        sum(IDR) IDR,
        sum(CallBack) CallBack,
        sum(PaymentMade) PaymentMade,
        sum(Paid) Paid,
        sum(FirstEstimate) FirstEstimate,
        sum(InboundCalls) InboundCalls,
        sum(OutboundCalls) OutboundCalls,
        sum(OnReady) OnReady,
        sum(MinOnReady) MinOnReady,
        sum(e5Completed) e5Completed,
        sum(e5CompletedValue) e5CompletedValue,
        sum(e5Reopened) e5Reopened,
        sum(e5ReopenedValue) e5ReopenedValue,
        sum(Completed) Completed,
        sum(Reopened) Reopened,
        sum(NewClaim) NewClaim,
        sum(NewClaimValue) NewClaimValue,
        sum(DiarisedClaim) DiarisedClaim,
        sum(DiarisedClaimValue) DiarisedClaimValue
    from
        #v3combined t
        cross apply
        (
            select 
                DateRange TimePeriod,
                StartDate,
                EndDate
            from
                [db-au-cba]..vDateRange
            where
                DateRange in ('Yesterday', 'Week-to-date', 'Month-to-date')
        ) d
        outer apply
        (
            select top 1 
                tl.DisplayName TeamLeader
            from
                [db-au-workspace]..usrLDAPTeam utl
                inner join [db-au-cba]..usrLDAP u on
                    u.UserID = utl.UserID
                inner join [db-au-cba]..usrLDAP tl on
                    tl.UserID = utl.TeamLeaderID
            where
                u.DisplayName = t.AssignedUser
        ) tl
    where
        t.[Date] >= d.StartDate and
        t.[Date] <  dateadd(day, 1, d.EndDate)
    group by
        Country,
        SuperGroupName,
        AssignedUser,
        TeamLeader,
        TimePeriod

end


GO
