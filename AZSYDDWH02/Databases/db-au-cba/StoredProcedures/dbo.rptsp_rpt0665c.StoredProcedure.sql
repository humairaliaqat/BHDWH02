USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_rpt0665c]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[rptsp_rpt0665c]    
    @DateRange varchar(30),
    @StartDate datetime = null,
    @EndDate datetime = null

as

SET NOCOUNT ON

/****************************************************************************************************/
--  Name:           dbo.rptsp_rpt0665c
--  Author:         Saurabh Date
--  Date Created:   20151102
--  Description:    This stored procedure returns completed medical review details
--  Parameters:     @ReportingPeriod: Value is valid date range
--                  @StartDate: Enter if @ReportingPeriod = _User Defined. YYYY-MM-DD eg. 2010-01-01
--                  @EndDate: Enter if @ReportingPeriod = _User Defined. YYYY-MM-DD eg. 2010-01-01
--  Change History: 20151102 - SD - Created
--                  20151109 - SD - Changes Absolute Age calculation, calculating age of medical review now
--					20151119 - SD - Addition of Completion Business Days column
--                  20151203 - LS - check null EventUser
--					20160620 - SD - Changes requested by Grame Stemmett, Addition of new columns for Received Date, Due Date, Last Medical review completion date, First Medical Review Received Date, Total number of Medical reviews received, Total Medical review completion business days and Average medical review completion business days
--					20160915 - SD - Added Last Diarised Reason
/****************************************************************************************************/


--uncomment to debug
/*
declare @DateRange varchar(30)
declare @StartDate varchar(10)
declare @EndDate varchar(10)
select @DateRange = 'Last 7 Days', @StartDate = '2015-09-01', @EndDate = '2015-09-30'
*/

    declare @rptStartDate datetime
    declare @rptEndDate datetime

    /* get reporting dates */
    if @DateRange = '_User Defined'
        select @rptStartDate = @StartDate,
            @rptEndDate = @EndDate
    else
        select    @rptStartDate = StartDate, 
            @rptEndDate = EndDate
        from    dbo.vDateRange
        where    DateRange = @DateRange;


    select 
        isnull(w.AssignedUser, 'Unassigned') [Assigned User],
        isnull(w.CompletionUser, 'Unassigned') [Completion User],
        w.StatusName [Status],
        convert(date, w.CompletionDate) [Completion Date],
        w.ClaimNumber [Claim Number],
        w.WorkType [Work Type],
        w.GroupType [Group Type],
        [Customer Name],
        case
        when convert(date, w.CreationDate) = convert(date, w.CompletionDate) then 1
        else datediff(day, convert(date, w.CreationDate), convert(date, w.CompletionDate))
        end [Absolute Age],
		(wdays.ActiveBusinessDays + wdays.DiarisedBusinessDays) [Completion Business Days],
        isnull(cep.[Current Estimate], 0) [Current Estimate],
        case
            when isnull(ce.[Customer Care Case], '') = '' then 'N/A'
            else ce.[Customer Care Case]
        end [Customer Care Case],
        isnull(ce.EventDesc, '') [Claim Description],
        w.Reference [e5 Reference],
        cl.PolicyNo [Policy Number],
        o.GroupName [Client],
        @rptStartDate [RPTStartDate],
        @rptEndDate [RPTEndDate],
	convert(date, w.CreationDate) [Date Received],
	convert(date, w.SLAExpiryDate) [Due Date],
	max(convert(date, w.CompletionDate)) Over (Partition By w.ClaimNumber) [Last MR Completion Date],
	Min(convert(date, w.CreationDate)) Over (Partition By w.ClaimNumber) [First MR Received Date],
	Count(w.Reference)  Over (Partition By w.ClaimNumber) [Total Number of MR Received],
	Sum((wdays.ActiveBusinessDays + wdays.DiarisedBusinessDays)) Over (Partition By w.ClaimNumber) [Total MR Completion Business Days],
	Round(Avg((Convert(float,wdays.ActiveBusinessDays) + convert(float,wdays.DiarisedBusinessDays))) Over (Partition By w.ClaimNumber), 1) [Average MR Completion Business Days],
	[Diarised Reason],
	dr.[Diarised Count]
    from
        e5Work_v3 w
        inner join clmClaim cl on
            cl.ClaimKey = w.ClaimKey
        cross apply
        (
            select
                case
                    when cl.ReceivedDate is null then cl.CreateDate
                    when cl.ReceivedDate > dateadd(day, 1, convert(date, cl.CreateDate)) then cl.CreateDate
                    else cl.ReceivedDate
                end ReceiptDate
        ) crd
        left join penOutlet o on
            o.OutletKey = cl.OutletKey and
            o.OutletStatus = 'Current'
        outer apply
        (
            select top 1 
                convert(varchar, CaseID) [Customer Care Case],
                EventDesc
            from
                clmEvent ce
            where
                ce.ClaimKey = cl.ClaimKey
        ) ce
        outer apply
        (
            select top 1 
                case
                    when isnull(cn.Title, '') <> '' then cn.Title + ' '
                    else ''
                end +
                case
                    when isnull(cn.Firstname, '') <> '' then cn.Firstname + ' '
                    else ''
                end +
                case
                    when isnull(cn.Surname, '') <> '' then cn.Surname
                    else ''
                end [Customer Name]
            from
                clmName cn
            where
                cn.ClaimKey = cl.ClaimKey
            order by
                cn.isPrimary desc
        ) cn
        outer apply
        (
            select top 1
                we.EventDate [Status Change Date]
            from
                e5WorkEvent_v3 we
                outer apply
                (
                    select top 1 
                        pwe.StatusName PreviousStatus
                    from
                        e5WorkEvent_v3 pwe
                    where
                        pwe.Work_ID = w.Work_ID and
                        pwe.EventDate < we.EventDate
                    order by
                        pwe.EventDate desc
                ) pwe
            where
                we.Work_Id = w.Work_ID and
                (
                    we.EventName = 'Changed Work Status' 
                    or
                    (
                        we.EventName = 'Saved Work' and
                        we.EventUser in ('e5 Launch Service', 'svc-e5-prd-services')
                    )
                ) 

                --migration events
                and not
                (
                    we.EventDate >= '2015-10-03' and
                    we.EventDate <  '2015-10-04' and
                    we.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
                ) and
                we.StatusName <> isnull(PreviousStatus, '')

            order by
                we.EventDate desc
        ) cws
        outer apply
        (
            select 
                sum(EstimateValue) [Current Estimate],
                sum(RecoveryEstimateValue) [Recovery Estimate],
                sum(isnull([Current Payment], 0)) [Current Payment]
            from
                clmSection cs
                outer apply
                (
                    select 
                        sum(PaymentAmount) [Current Payment]
                    from
                        clmPayment cp 
                    where
                        cp.ClaimKey = cl.ClaimKey and
                        cp.SectionKey = cs.SectionKey and
                        cp.isDeleted = 0 and
                        cp.PaymentStatus = 'PAID'
                ) cp
            where
                cs.ClaimKey = cl.ClaimKey and
                cs.isDeleted = 0
        ) cep
		outer apply
		(
        select 
            sum(
                case
                    when we.StatusName = 'Active' then datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate())))
                    else 0
                end
            ) ActiveDays,
            sum(
                case
                    when we.StatusName = 'Diarised' then datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate())))
                    else 0
                end
            ) DiarisedDays,
            sum(
                case
                    when we.StatusName = 'Active' then datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate()))) - OffDays
                    else 0
                end
            ) ActiveBusinessDays,
            sum(
                case
                    when we.StatusName = 'Diarised' then datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate()))) - OffDays
                    else 0
                end
            ) DiarisedBusinessDays
        from
            e5WorkEvent we
            outer apply
            (
                select top 1
                    r.EventDate NextChangeDate
                from
                    e5WorkEvent r
                where
                    r.Work_Id = w.Work_ID and
                    r.EventDate > we.EventDate and
                    (
                        (
                            r.EventName in ('Changed Work Status', 'Merged Work') and
                            isnull(r.EventUser, r.EventUserID) not in ('e5 Launch Service', 'svc-e5-prd-services')
                        )
                        or
                        (
                            r.EventName = 'Saved Work' and
                            r.EventUser in ('e5 Launch Service', 'svc-e5-prd-services')
                        )
                    )
                order by
                    r.EventDate
            ) nwe
            outer apply
            (
                select 
                    count(d.[Date]) OffDays
                from
                    Calendar d
                where
                    d.[Date] >= convert(date, we.EventDate) and
                    d.[Date] <  convert(date, isnull(nwe.NextChangeDate, getdate())) and
                    (
                        d.isHoliday = 1 or
                        d.isWeekEnd = 1
                    )
            ) phd
        where
            we.Work_ID = w.Work_ID and
            (
                (
                    we.EventName in ('Changed Work Status', 'Merged Work') and
                    isnull(we.EventUser, we.EventUserID) not in ('e5 Launch Service', 'svc-e5-prd-services')
                )
                or
                (
                    we.EventName = 'Saved Work' and
                    we.EventUser in ('e5 Launch Service', 'svc-e5-prd-services')
                )
            ) and
            we.StatusName in ('Active', 'Diarised')
		) wdays
		Outer apply -- Finding Diarised Reason
		(
			Select Top 1
				Case 
					When d.Detail like 'Diarised%' Then SubString(d.Detail,12,Len(d.Detail))
					Else d.Detail
				End [Diarised Reason]
			From
				e5WorkEvent d
			Where 
				d.Work_ID = (select ie.Work_ID from e5Work ie where ie.Reference = w.Reference)
				and d.EventName = 'Changed Work Status'
				and d.StatusName = 'Diarised'
			Order by
				d.EventDate Desc
		) DiarisedReason
		Outer apply -- Finding Diarised Count
		(
			select 
				count(we2.ID) [Diarised Count]
			from
				e5WorkEvent we2
			where
				we2.Work_Id = (select ie2.Work_ID from e5Work ie2 where ie2.Reference = w.Reference) and
				(
					we2.EventName = 'Changed Work Status'
				) and
				we2.StatusName = 'Diarised'

				--migration events
				and not
				(
					we2.EventDate >= '2015-10-03' and
					we2.EventDate <  '2015-10-04' and
					we2.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
				)
		) dr
    where
        w.WorkType='Medical Review' and
        w.StatusName='Complete' and
	w.Country='AU' and 
	w.ClaimNumber in (select ClaimNumber from e5work where convert(varchar(10),convert(date, CompletionDate),120) between  convert(varchar(10),@rptStartDate,120) and convert(varchar(10),@rptEndDate,120)  and WorkType = 'Medical Review' and StatusName = 'Complete' and Country = 'AU')
GO
