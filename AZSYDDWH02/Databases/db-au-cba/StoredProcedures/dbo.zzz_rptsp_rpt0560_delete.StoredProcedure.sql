USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[zzz_rptsp_rpt0560_delete]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[zzz_rptsp_rpt0560_delete]
    @ReportingPeriod varchar(30),
    @StartDate date = null,
    @EndDate date = null,
    @HistoricPeriod varchar(30) = 'Last 6 Months',
    @HistoricStartDate date = null,
    @HistoricEndDate date = null,
    @Summary bit = 1
    
as
begin
/****************************************************************************************************/
--  Name:           dbo.rptsp_rpt0560
--  Author:         Leo
--  Date Created:   20140604
--  Description:    Returns assessment performance compared to historic average.
--  Parameters:     
--                  @ReportingPeriod, valid date range of measured assessment performance
--                  @StartDate, optional start of measured assessment performance
--                  @EndDate, optional end of measured assessment performance
--                  @HistoricPeriod, valid date range of historical performance
--                  @HistoricStartDate, optional start of historical performance
--                  @HistoricEndDate, optional end of historical performance
--                  
--  Change History: 
--                  20140604 - LS - Created
--                  20140606 - LS - change status detail to status code in live data
--                                  replace blank last status with Active
--                  20140728 - LS - reverted, don't include diarised for medical review
--                  20150227 - LS - prioritise the non deleted LDAP accounts
--                  20151207 - LS - only for AU
--                  20160726 - LL - integer conversion error, claim number contains .
--                  20160907 - LL - point this to BHDWH02
--                  20160531 - LL - point to BHDWH03\SNAPSHOT
--					20190817 - LT - updated to point to new e5 database server
--                  20191122 - EV - Copied from ULDWH02 - was missing
--					20191126 - EV - Replaced this line ''server=ULSQLGOLD04\e5;database=e5_Content;Trusted_Connection=yes;'',
--									with ''server=Ule5sql01par01\e5;database=e5_Content;Trusted_Connection=yes;'',
/****************************************************************************************************/

--debug
--declare
--    @ReportingPeriod varchar(30),
--    @StartDate date,
--    @EndDate date,
--    @HistoricPeriod varchar(30),
--    @HistoricStartDate date,
--    @HistoricEndDate date,
--    @Summary bit
--select
--    @ReportingPeriod = 'Yesterday',
--    @StartDate = null,
--    @EndDate = null,
--    @HistoricPeriod = 'Last 6 Months',
--    @HistoricStartDate = null,
--    @HistoricEndDate = null,
--    @Summary = 1

    set nocount on
    
    declare @sql varchar(max)
    
    /* get reporting dates */
    if @ReportingPeriod <> '_User Defined'
        select 
            @StartDate = StartDate, 
            @EndDate = EndDate
        from 
            vDateRange
        where 
            DateRange = @ReportingPeriod
    
    if @HistoricPeriod <> '_User Defined'
        select 
            @HistoricStartDate = StartDate, 
            @HistoricEndDate = EndDate
        from 
            vDateRange
        where 
            DateRange = @HistoricPeriod

    if object_id('tempdb..#measured') is not null
        drop table #measured
        
    if object_id('tempdb..#historic') is not null
        drop table #historic

    create table #measured
    (
        ClaimNumber int,
        LastStatus nvarchar(200),
        CompletionUser nvarchar(100),
        CompletionDate datetime,
        AssessmentOutcome nvarchar(200)
    )
            
    create table #historic
    (
        ClaimNumber int,
        LastStatus nvarchar(200),
        CompletionUser nvarchar(100),
        CompletionDate datetime,
        AssessmentOutcome nvarchar(200)
    )
            
    /* historical */
    insert into #historic
    (
        ClaimNumber,
        LastStatus,
        CompletionUser,
        CompletionDate,
        AssessmentOutcome
    )
    select 
        try_convert(int, w.ClaimNumber) ClaimNumber,
        isnull(LastStatus, 'Active') LastStatus,
        wa.CompletionUser,
        wa.CompletionDate,
        wi.Code AssessmentOutcome
    from
        e5WorkActivity wa
        inner join e5Work w on
            w.Work_ID = wa.Work_ID
        inner join e5WorkItems wi on
            wi.ID = wa.AssessmentOutcome
        outer apply
        (
            select top 1 
                StatusName LastStatus
            from
                e5WorkEvent we
            where
                we.Work_Id = w.Work_ID and
                we.EventName = 'Changed Work Status' and
                we.EventDate >= wa.CompletionDate
            order by
                we.EventDate
        ) we
    where
        w.Country = 'AU' and
        wa.CompletionDate >= @HistoricStartDate and
        wa.CompletionDate <  dateadd(day, 1, @HistoricEndDate) and
        wa.CategoryActivityName = 'Assessment Outcome' and
        w.ClaimKey is not null
            
    --reverted, don't include diarised for medical review
    --union
        
    --select 
    --    convert(int, w.ClaimNumber) ClaimNumber,
    --    'Medical Review' LastStatus,
    --    we.EventUser CompletionUser,
    --    we.EventDate CompletionDate,
    --    we.Detail AssessmentOutcome
    --from
    --    e5WorkEvent we
    --    inner join e5Work w on
    --        w.Work_ID = we.Work_ID
    --where
    --    we.EventName = 'Changed Work Status' and
    --    we.StatusName = 'Diarised' and
    --    we.Detail = 'Diarised - Referred for Medical Review' and
    --    we.EventDate >= @HistoricStartDate and
    --    we.EventDate <  dateadd(day, 1, @HistoricEndDate)
        

    /* measured assessment */
    set @sql =
        '
        select
            ClaimNumber,
            LastStatus,
            CompletionUser,
            CompletionDate,
            AssessmentOutcome
        from
            openrowset(
                ''SQLNCLI'', 
                ''server=Ule5sql01par01;database=e5_Content;Trusted_Connection=yes;'',
                ''
                set fmtonly off
                select 
                    wcp.ClaimNumber,
                    isnull(LastStatus, ''''Active'''') LastStatus,
                    wa.CompletionUser,
                    wa.CompletionDate,
                    li.Code AssessmentOutcome
                from
                    WorkActivity wa with(nolock)
                    inner join CategoryActivity ca with(nolock) on
                        ca.Id = wa.CategoryActivity_Id
                    inner join Work w with(nolock) on
                        w.Id = wa.Work_Id
			        cross apply
			        (
				        select top 1
					        try_convert(int, replace(convert(varchar(max), PropertyValue), ''''.'''', '''''''')) ClaimNumber
				        from
					        WorkProperty wp with(nolock)
				        where
					        wp.Work_Id = w.Id and
					        Property_Id = ''''ClaimNumber''''
			        ) wcp
                    left join WorkActivityProperty wap with(nolock) on
                        wap.Work_Id = w.Id and
                        wap.WorkActivity_Id = wa.Id and
                        wap.Property_Id like ''''%outcome%''''
                    left join ListItem li with(nolock) on
                        li.Id = wap.PropertyValue
                    outer apply
                    (
                        select top 1 
                            s.Code LastStatus
                        from
                            WorkEvent we with(nolock)
                            inner join [Status] s with(nolock) on
                                s.Id = we.Status_Id
                        where
                            we.Work_Id = w.Id and
                            we.Event_Id = 100 and
                            we.EventDate >= wa.CompletionDate
                        order by
                            we.Id
                    ) we
                where
                    w.Category1_Id = 2 and
                    ca.Name = ''''Assessment Outcome'''' and
                    wa.CompletionDate >= ''''' + convert(varchar(10), @StartDate, 120) + ''''' and
                    wa.CompletionDate <  ''''' + convert(varchar(10), dateadd(day, 1, @EndDate), 120) + ''''' and
                    wcp.ClaimNumber is not null
                ''
            )
        '

        --reverted, don't include diarised for medical review
        --union
                    
        --select 
        --    wcp.ClaimNumber,
        --    ''''Medical Review'''' LastStatus,
        --    we.EventUser CompletionUser,
        --    we.EventDate CompletionDate,
        --    we.Detail AssessmentOutcome
        --from
        --    WorkEvent we
        --    inner join Work w on
        --        w.Id = we.Work_Id
        --    inner join WorkCustomProperty wcp on
        --        w.Id = wcp.Work_Id
        --where
        --    we.Event_Id = 100 and
        --    we.Status_Id = 2 and
        --    we.Detail = ''''Diarised - Referred for Medical Review'''' and
        --    we.EventDate >= ''''' + convert(varchar(10), @StartDate, 120) + ''''' and
        --    we.EventDate <  ''''' + convert(varchar(10), dateadd(day, 1, @EndDate), 120) + ''''' and
        --    wcp.ClaimNumber is not null

            
    --print @sql
    insert into #measured
    (
        ClaimNumber,
        LastStatus,
        CompletionUser,
        CompletionDate,
        AssessmentOutcome
    )
    exec (@sql)

    update m
    set
        m.CompletionUser = l.DisplayName
    from
        #measured m
        outer apply
        (
            select top 1
                DisplayName
            from
                usrLDAP l
            where
                l.UserName = replace(m.CompletionUser, 'COVERMORE\', '')
            order by 
                case
                    when DeleteDateTime is null then 0
                    else 1
                end                 
        ) l
    
    if @Summary = 1
    begin

        create index idx on #measured (CompletionDate) include (ClaimNumber)
        create index idx on #historic (CompletionDate) include (ClaimNumber)
        
        ;with cte_hour as
        (
            select distinct
                convert(time, convert(varchar(2), CompletionDate, 14) + ':00:00') HourGroup
            from 
                #measured
                
            union
            
            select distinct
                convert(time, convert(varchar(2), CompletionDate, 14) + ':00:00') HourGroup
            from 
                #historic
        ),
        cte_historicofficer as
        (
            select 
                convert(date, CompletionDate) DateGroup,
                count(distinct CompletionUser) OfficerCount
            from
                #historic
            group by
                convert(date, CompletionDate)
        ),
        cte_measuredofficer as
        (
            select 
                convert(date, CompletionDate) DateGroup,
                count(distinct CompletionUser) OfficerCount
            from
                #measured
            group by
                convert(date, CompletionDate)
        )
        select 
            left(HourGroup, 5) HourGroup,
            HistoricClaimCount,
            HistoricDays,
            case
                when HistoricDays = 0 then 0
                else HistoricClaimCount / HistoricDays
            end AvgHistoricClaimCount,
            case
                when HistoricDays = 0 then 0
                else HistoricOfficerCount / HistoricDays
            end HistoricAvgOfficerCount,
            HistoricWDClaimCount,
            HistoricWeekDays,
            case
                when HistoricWeekDays = 0 then 0
                else HistoricWDClaimCount / HistoricWeekDays
            end AvgHistoricWDClaimCount,
            case
                when HistoricWeekDays = 0 then 0
                else HistoricWDOfficerCount / HistoricWeekDays
            end HistoricAvgWDOfficerCount,
            MeasuredClaimCount,
            MeasuredDays,
            case
                when MeasuredDays = 0 then 0
                else MeasuredClaimCount / MeasuredDays
            end AvgMeasuredClaimCount,
            case
                when MeasuredDays = 0 then 0
                else MeasuredOfficerCount / MeasuredDays
            end AvgOfficerCount
        from
            cte_hour h
            outer apply
            (
                select 
                    count(ClaimNumber) HistoricClaimCount
                from
                    #historic hi
                where
                    convert(time, convert(varchar(2), hi.CompletionDate, 14) + ':00:00') <= h.HourGroup
            ) hi
            outer apply
            (
                select 
                    count(distinct convert(date, hi.CompletionDate)) HistoricDays
                from
                    #historic hi
            ) hid
            outer apply
            (
                select
                    sum(OfficerCount) HistoricOfficerCount
                from
                    cte_historicofficer
            ) ho
            outer apply
            (
                select
                    sum(OfficerCount) HistoricWDOfficerCount
                from
                    cte_historicofficer o
                    inner join Calendar d on
                        d.[Date] = convert(date, o.DateGroup) and
                        d.isWeekDay = 1 and
                        d.isHoliday = 0
            ) hob
            outer apply
            (
                select 
                    count(ClaimNumber) HistoricWDClaimCount
                from
                    #historic hi
                    inner join Calendar d on
                        d.[Date] = convert(date, hi.CompletionDate) and
                        d.isWeekDay = 1 and
                        d.isHoliday = 0
                where
                    convert(time, convert(varchar(2), hi.CompletionDate, 14) + ':00:00') <= h.HourGroup
            ) hib
            outer apply
            (
                select 
                    count(distinct convert(date, hi.CompletionDate)) HistoricWeekDays
                from
                    #historic hi
                    inner join Calendar d on
                        d.[Date] = convert(date, hi.CompletionDate) and
                        d.isWeekDay = 1 and
                        d.isHoliday = 0
            ) hibd
            outer apply
            (
                select 
                    count(ClaimNumber) MeasuredClaimCount
                from
                    #measured m
                where
                    convert(time, convert(varchar(2), m.CompletionDate, 14) + ':00:00') <= h.HourGroup
            ) m
            outer apply
            (
                select 
                    count(distinct convert(date, m.CompletionDate)) MeasuredDays
                from
                    #measured m
            ) md
            outer apply
            (
                select
                    sum(OfficerCount) MeasuredOfficerCount
                from
                    cte_measuredofficer
            ) mo
        order by 1
    
    end

    else
    begin
    
        select
            'Historical' Category,
            ClaimNumber,
            LastStatus,
            CompletionUser,
            CompletionDate,
            AssessmentOutcome
        from
            #historic
            
        union all
        
        select
            'Measured' Category,
            ClaimNumber,
            LastStatus,
            CompletionUser,
            CompletionDate,
            AssessmentOutcome
        from
            #measured
            
    end    

end
GO
