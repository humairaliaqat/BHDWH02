USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_dashboard_claim_support_tat]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[rptsp_dashboard_claim_support_tat]
--with execute as 'covermore\appbobj'
--20240622, SB, As part of claims Uplift(E5 classic to E5 connect) source details and User details were updated according to respective joins (CHG0039218).
as
begin

    if object_id('tempdb..#activecases') is not null
        drop table #activecases

    select
        w.Id Work_ID,
        wt.Name WorkType,
        w.Reference,
        cl.ClaimNo,
        w.CreationDate,
        us.AssignedUser
    into #activecases
    from
        [covermoresql.e5workflow.com,60500].[e5_Content_CMCBA].dbo.Work w with(nolock)
        inner join [covermoresql.e5workflow.com,60500].[e5_Content_CMCBA].dbo.Category2 wt with(nolock)  on
            wt.Id = w.Category2_Id
        cross apply
        (
            select top 1
                wp.PropertyValue ClaimNo
            from
                [covermoresql.e5workflow.com,60500].[e5_Content_CMCBA].dbo.WorkProperty wp with(nolock)
            where
                wp.Work_Id = w.Id and
                wp.Property_Id = 'ClaimNumber' and
                wp.PropertyValue is not null and
                wp.PropertyValue <> ''
        ) cl
		outer apply  --Userdetails added as part of Claims uplift (CHG0039218): SB
        (
            select top 1
                u.UserName collate database_default AssignedUser
            from
                [covermoresql.e5workflow.com,60500].[e5_Content_CMCBA].dbo.[User] u
            where
                u.Id = w.AssignedUser
        ) us
    where
        wt.Name = 'claim' and
        w.Status_Id = 1 and
        w.Category1_Id = 2 /*AU*/

    --select *
    --from
    --    #activecases

    if object_id('tempdb..#events') is not null
        drop table #events

    select
        w.Original_Work_Id Work_ID,
        EventDate,
        we.StatusName,
        EventUser,
        Detail,
        EventName
    into #events
    from
        [db-au-cba]..e5WorkEvent we with(nolock)
        inner join [db-au-cba]..e5Work w with(nolock) on
            w.Work_ID = we.Work_ID
    where
        EventDate < dateadd(day, -1, convert(date, getdate())) and
        w.Original_Work_ID in
        (
            select
                r.Work_ID
            from
                #activecases r
        ) and
        EventName in ('Changed Work Status', 'Merged Work', 'Saved Work') and
        w.Country = 'AU'

    insert into #events
    select
        Work_ID,
        EventDate,
        s.Name collate database_default Status,
        ue.EventUser collate database_default EventUser,
        Detail,
        case
            when Event_Id = 100 then 'Changed Work Status'
            when Event_Id = 800 then 'Merged Work'
            when Event_Id = 401 then 'Saved Work'
        end EventName
    from
        [covermoresql.e5workflow.com,60500].[e5_Content_CMCBA].dbo.WorkEvent we with(nolock)
        inner join [covermoresql.e5workflow.com,60500].[e5_Content_CMCBA].dbo.Status s with(nolock)  on
            s.Id = we.Status_Id
		outer apply  --Userdetails added as part of Claims uplift (CHG0039218): SB
        (
            select top 1
                u.UserName collate database_default EventUser
            from
                [covermoresql.e5workflow.com,60500].[e5_Content_CMCBA].dbo.[User] u
            where
                u.Id = we.EventUser
        ) ue
    where
        EventDate >= dateadd(day, -1, convert(date, getdate())) and
        Event_Id in (100, 800, 401)

    create nonclustered index idx on #events (Work_ID, EventDate desc) include (StatusName, EventUser, Detail, EventName)

	--DROP TABLE [db-au-workspace].dbo.e5TAT
	if not exists (select * from sysobjects where name='e5TAT' and xtype='U')
	create table [db-au-workspace].dbo.e5TAT
	(
		ClaimNo varchar(50) NULL,
		Reference int NULL,
		WorkType varchar(50) NULL,
		CreationDate datetime NULL,
		StatusChangeDate datetime,
		AssignedUser varchar(255) NULL,
		TAT int NULL,
		CurrentEstimate decimal(10,2) NULL
	)
 else
	Truncate Table [db-au-workspace].dbo.e5TAT

  --DROP TABLE [db-au-workspace].dbo.e5TAT
  --delete from [db-au-workspace].dbo.e5TAT

    insert into [db-au-workspace].dbo.e5TAT
    (
        ClaimNo,
        Reference,
        WorkType,
        CreationDate,
        StatusChangeDate,
        AssignedUser,
        TAT,
        CurrentEstimate
    )
	
    select
        convert(varchar,w.ClaimNo),
        w.Reference,
        w.WorkType,
        w.CreationDate,
        [TICS Reference Date] StatusChangeDate,
        --convert(varchar(max),isnull(DisplayName, 'Unassigned')) AssignedUser,
		isnull(DisplayName, 'Unassigned') AssignedUser,
        case
            when [Time in current status] >= 10 then 10
            else [Time in current status]
        end TAT
		,
        --convert(varchar(max),isnull(ci.Estimate, 0)) CurrentEstimate
		isnull(ci.Estimate, 0) CurrentEstimate
    from
        #activecases w
        outer apply
        (
            select top 1
                we.EventDate [Status Change Date]
            from
                #events we
                outer apply
                (
                    select top 1
                        pwe.StatusName PreviousStatus
                    from
                        #events pwe
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
            select top 1
                we.EventDate [Last Status Change],
                we.Detail [Last Status Detail],
                case
                    when exists
                    (
                        select
                            null
                        from
                            #events mwe
                        where
                            mwe.Work_Id = w.Work_ID and
                            mwe.EventName = 'Merged Work' and
                            mwe.EventDate > we.EventDate and
                            mwe.EventDate < cws.[Status Change Date]

                            --migration events
                            and not
                            (
                                mwe.EventDate >= '2015-10-03' and
                                mwe.EventDate <  '2015-10-04' and
                                mwe.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
                            )

                    ) then 1
                    else 0
                end [Merged]
            from
                #events we
                outer apply
                (
                    select top 1
                        pwe.StatusName PreviousStatus
                    from
                        #events pwe
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
                ) and
                we.EventDate < cws.[Status Change Date] and
                we.StatusName <> isnull(PreviousStatus, '')

                --migration events
                and not
                (
                    we.EventDate >= '2015-10-03' and
                    we.EventDate <  '2015-10-04' and
                    we.EventUser in ('Dataract e5 Exchange Service', 'e5 Launch Service')
                )
            order by
                we.EventDate desc
        ) lsc
        outer apply
        (
            select top 1
                SLAStartDate
            from
                [db-au-cba]..e5Work rw with(nolock)
            where
                rw.Original_Work_ID = w.Work_ID
        ) rw
        outer apply
        (
            select
                case
                    when lsc.[Last Status Detail] = 'Diarised - Referred for Medical Review' then lsc.[Last Status Change]
                    when lsc.[Last Status Detail] = 'Diarised - Referred to Medical' then lsc.[Last Status Change]
                    when lsc.Merged = 1 then isnull(rw.SLAStartDate, cws.[Status Change Date])
                    else isnull(cws.[Status Change Date], w.CreationDate)
                end [TICS Reference Date]
        ) rd
        outer apply
        (
            select
                datediff(day, [TICS Reference Date], getdate()) -
                (
                    select
                        count(d.[Date])
                    from
                        [db-au-cba]..Calendar d with(nolock)
                    where
                        d.[Date] >= [TICS Reference Date] and
                        d.[Date] <  dateadd(day, 1, convert(date, getdate())) and
                        (
                            d.isHoliday = 1 or
                            d.isWeekEnd = 1
                        )
                ) [Time in current status]
        ) tics
        outer apply
        (
            select top 1
                DisplayName
            from
                [db-au-cba]..usrLDAP l with(nolock)
            where
                l.UserName = replace(w.AssignedUser collate database_default, 'covermore\', '')
        ) l
        outer apply
        (
            select 
                sum(ci.EstimateDelta) Estimate
            from
                [db-au-cba]..vclmClaimIncurred ci with(nolock)
            where
                ci.ClaimKey = 'AU-' + convert(varchar, w.ClaimNo)
        ) ci

end





GO
