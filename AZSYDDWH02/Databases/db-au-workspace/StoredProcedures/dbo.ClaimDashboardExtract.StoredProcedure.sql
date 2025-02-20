USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[ClaimDashboardExtract]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[ClaimDashboardExtract]
    @Month date

as
begin

    --declare @month date
    declare @sql varchar(max)
    declare @fyperiod varchar(7)
    declare @icube 
        table 
        (
            [Section] varchar(100),
            [Pre First Nil Count] float,
            [Pre First Nil Payment] float,
            [Pre First Nil Avg Payment] float,
            [Post First Nil Avg Payment] float,
            [Claim Payment] float,
            [Claim Estimate Closing] float,
            [Avg Claim Value] float
        )
    declare @output 
        table
        (
            Period date,
            [Metric Group] varchar(255),
            [Metric Sub Group] varchar(255),
            [Metric Name] varchar(255),
            Value float
        )

    set nocount on

    --set @month = '2016-07-01'
    set @month = convert(date, convert(varchar(8), @month, 120) + '01')

    select 
        @fyperiod = left(SUNPeriod, 4) + '-' + right(SUNPeriod, 2)
    from
        [db-au-cba]..Calendar
    where
        [Date] = @month


    /*insurance cube - start*/

    set @sql =
    '
    select
        *
    from
        openquery(
            INSURANCECUBECBA,
            ''
            with
            member [Measures].[Total Claim Payment] as [Measures].[Claim Payment] - [Measures].[Claim Recovery]
            select 
	            (
		            [Benefit].[Operational Benefit Hierarchy].children 
	            ) on rows,
	            (
		            {
                        [Measures].[Pre First Nil Count],
			            [Measures].[Pre First Nil Payment],
			            [Measures].[Pre First Nil Avg Payment],
			            [Measures].[Post First Nil Avg Payment],
			            [Measures].[Total Claim Payment],
			            [Measures].[Claim Payment Estimate Closing],
                        [Measures].[Avg Claim Value]
		            }
	            ) on columns  
            from 
                [Insurance Cube CBA] 
            where 
                (
                    [Domain].[Country Code].&[AU],
                    [Date].[Fiscal Year Month].&[' + @fyperiod + ']
                )
            ''
        )
    '

    insert into @icube
    exec (@sql)

    set @sql =
    '
    select
        ''Total'',
        *
    from
        openquery(
            INSURANCECUBECBA,
            ''
            with
            member [Measures].[Total Claim Payment] as [Measures].[Claim Payment] - [Measures].[Claim Recovery]
            select 
	            (
		            {
                        [Measures].[Pre First Nil Count],
			            [Measures].[Pre First Nil Payment],
			            [Measures].[Pre First Nil Avg Payment],
			            [Measures].[Post First Nil Avg Payment],
			            [Measures].[Total Claim Payment],
			            [Measures].[Claim Payment Estimate Closing],
                        [Measures].[Avg Claim Value]
		            }
	            ) on columns  
            from 
                [Insurance Cube CBA] 
            where 
                (
                    [Domain].[Country Code].&[AU],
                    [Date].[Fiscal Year Month].&[' + @fyperiod + ']
                )
            ''
        )
    '

    insert into @icube
    exec (@sql)

    --select *
    --from
    --    @icube




    /*insurance cube - end*/

    /*shared data - start*/
    /*claim state, will be reused in many parts below*/
    if object_id('tempdb..#movement') is not null
        drop table #movement

    select
        cim.ClaimKey,
        sum
        (
            case
                when cim.IncurredDate < @month then cim.EstimateDelta
                else 0
            end
        ) OpeningEstimate,
        sum(cim.EstimateDelta) ClosingEstimate,
        sum
        (
            case
                when cim.IncurredDate < @month then cim.NewCount + cim.ReopenedCount - cim.ClosedCount
                else 0
            end
        ) ActiveOpening,
        sum(NewCount + ReopenedCount - ClosedCount) ActiveClosing,
        sum(
            case
                when cim.IncurredDate >= @month then cim.NewCount
                else 0
            end
        ) [New Claims],
        sum(
            case
                when cim.IncurredDate >= @month then cim.ReopenedCount
                else 0
            end
        ) [Re-Opened Claims],
        sum(
            case
                when cim.IncurredDate >= @month then cim.ClosedCount
                else 0
            end
        ) [Closed Claims],
        cast(null as nvarchar(100)) WorkType,
        0 IndiaTeam,
        0 Denied,
        0 OnlineClaim,
        0 TeleClaim,
        0 IncurredValueClosing
    into #movement
    from
        [db-au-cba]..clmClaimIntradayMovement cim with(nolock)
    where
        cim.ClaimKey like 'AU%' and
        cim.IncurredDate < dateadd(month, 1, @month)
    group by
        ClaimKey

    update cl
    set
        cl.IndiaTeam = isnull(l.IndiaTeam, 0),
        cl.Denied = isnull(d.Denied, 0),
        cl.WorkType = isnull(w.GroupType, '')
    from
        #movement cl
        outer apply
        (
            select top 1
                w.Work_ID,
                w.AssignedUser,
                w.GroupType
            from
                [db-au-cba]..e5Work w with(nolock)
            where
                w.ClaimKey = cl.ClaimKey and
                w.WorkType = 'Claim' and
                w.CreationDate < dateadd(month, 1, @month)
        ) w
        outer apply
        (
	        select top 1
		        1 IndiaTeam
	        from
		        [db-au-cba]..usrLDAP l with(nolock)
	        where
		        l.DisplayName = w.AssignedUser and
                l.Company like 'Trawel%'
        ) l
        outer apply
        (
            select top 1
                1 Denied
            from 
                [db-au-cba]..e5WorkActivity wa with(nolock) 
            where
                wa.Work_ID = w.Work_ID and
                wa.CategoryActivityName = 'Assessment Outcome' and
                (
                    wa.AssessmentOutcomeDescription like '%deni%' or
                    wa.AssessmentOutcomeDescription like '%deny%'
                ) and
                wa.completionDate >= @month and
                wa.CompletionDate <  dateadd(month, 1, @month)
        ) d
    --where
    --    [Closed Claims] > 0

    update cl
    set
        cl.IncurredValueClosing = isnull(ci.IncurredValue, 0)
    from
        #movement cl
        cross apply
        (
            select top 1
                IncurredValue
            from
                [db-au-cba]..vclmClaimIncurred ci with(nolock)
            where
                ci.ClaimKey = cl.ClaimKey and
                ci.IncurredDate < dateadd(month, 1, @month)
        ) ci
    where
        [New Claims] > 0 or
        ActiveOpening > 0 or
        [Closed Claims] > 0

    /*shared data - end*/


    /*claims value - start*/
    insert into @output
    select 
        @month Period,
        'Key Metrics' [Metric Group],
        'Claims Paid' [Metric Sub Group],
        'Claims Paid' [Metric Name],
        [Claim Payment] Value
    from
        @icube t
    where
        t.Section = 'Total'

    insert into @output
    select 
        @month Period,
        'Key Metrics' [Metric Group],
        'Claims Paid' [Metric Sub Group],
        'Paid - ' + s.Section [Metric Name],
        sum([Claim Payment]) Value
    from
        @icube t
        cross apply
        (
            select
                case
                    when Section = 'Unknown' then 'Other'
                    else Section
                end Section
        ) s
    where
        t.Section <> 'Total'
    group by
        s.Section

  insert into @output
    select 
        @month Period,
        'Key Metrics' [Metric Group],
        'Closing Estimate' [Metric Sub Group],
        'Closing Estimate Balance' [Metric Name],
        [Claim Estimate Closing] Value
    from
        @icube t
    where
        t.Section = 'Total'

    insert into @output
    select 
        @month Period,
        'Key Metrics' [Metric Group],
        'Closing Estimate' [Metric Sub Group],
        'Estimate Balance - ' + s.Section [Metric Name],
        sum([Claim Estimate Closing]) Value
    from
        @icube t
        cross apply
        (
            select
                case
                    when Section = 'Unknown' then 'Other'
                    else Section
                end Section
        ) s
    where
        t.Section <> 'Total'
    group by
        s.Section

    insert into @output
    select 
        @month Period,
        'Key Metrics' [Metric Group],
        'Claims Value' [Metric Sub Group],
        'Incurred Balance' [Metric Name],
        [Claim Payment] + [Claim Estimate Closing] Value
    from
        @icube t
    where
        t.Section = 'Total'

    /*claims value - end*/


    /*claims count - start*/

    /*active claim opening balance*/
    insert into @output
    select 
        @month Period,
        'Key Metrics' [Metric Group],
        'Active Claims' [Metric Sub Group],
        'Opening Balance' [Metric Name],
        count(Claimkey) Value
    from
        #movement
    where
        ActiveOpening > 0

    /*active e5 breakdown*/
    insert into @output
    select 
        @month Period,
        'Key Metrics' [Metric Group],
        'Active Claims' [Metric Sub Group],
        '% of ' + StatusName + ' Claims' [Metric Name],
        case
            when sum(ClaimCount) over () = 0 then 0
            else ClaimCount * 1.00 / sum(ClaimCount) over ()
        end Value
    from
        (
            select 
                we.StatusName,
                count(ClaimKey) ClaimCount
            from
                #movement t
                cross apply
                (
                    select top 1
                        w.Work_ID
                    from
                        [db-au-cba]..e5Work w with(nolock)
                    where
                        w.ClaimKey = t.ClaimKey and
                        w.WorkType like '%claim%' and
                        w.WorkType not like '%audit%'
                ) w
                cross apply
                (
                    select top 1
                        StatusName
                    from
                        [db-au-cba]..e5WorkEvent we with(nolock)
                    where
                        we.EventDate < @month and
                        we.Work_ID = w.Work_ID
                    order by
                        we.EventDate desc
                ) we
            where
                t.ActiveClosing > 0 and
                we.StatusName in ('Active', 'Diarised')
            group by
                we.StatusName
        ) t

    /*active claim movement*/
    insert into @output
    select 
        @month Period,
        'Key Metrics' [Metric Group],
        'Active Claims' [Metric Sub Group],
        [Metric Name],
        Value
    from
        (
            select 
                sum([New Claims]) [New Claims],
                sum([Re-Opened Claims]) [Re-Opened Claims],
                sum([Closed Claims]) [Closed Claims]
            from
                #movement
        ) t
        unpivot
        (
            Value for [Metric Name] in
            (
                [New Claims],
                [Re-Opened Claims],
                [Closed Claims]
            )
        ) u

    /*active claim closing balance*/
    insert into @output
    select 
        @month Period,
        'Key Metrics' [Metric Group],
        'Active Claims' [Metric Sub Group],
        'Closing Balance' [Metric Name],
        count(Claimkey) Value
    from
        #movement
    where
        ActiveClosing > 0


    /*claims count - end*/

    /*workforce - start*/
    insert into @output
    select 
        @month Period,
        'Key Metrics' [Metric Group],
        'Workforce' [Metric Sub Group],
        'Working Days' [Metric Name],
        count([Date]) Value
    from
        [db-au-cba]..Calendar d
    where
        d.[Date] >= @month and
        d.[Date] <  dateadd(month, 1, @month) and
        not
        (
            isHoliday = 1 or
            isWeekEnd = 1
        )

    /*FTE*/
    insert into @output
    select 
        @month Period,
        'Key Metrics' [Metric Group],
        'Workforce' [Metric Sub Group],
        'Claims closed per FTE' [Metric Name],
        case
            when isnull(f.FTE, 0) = 0 then 0
            else isnull(cc.[Closed Claims] / f.FTE, 0)
        end Value
    from
        (
            select
                sum(-GLAmount) FTE
            from
                [db-au-cba]..glTransactions gl with(nolock)
                inner join [db-au-cba]..Calendar d with(nolock) on
                    d.SUNPeriod = gl.Period
            where
                gl.ScenarioCode = 'A' and
                gl.BusinessUnit = 'IAU' and
                gl.DepartmentCode = '24' and
                gl.AccountCode = 'M0003' and
                d.[Date] = @month
        ) f
        inner join 
        (
            select 
                sum([Closed Claims]) [Closed Claims]
            from
                #movement
        ) cc on 1 = 1


    /*TAT*/
    ;with
    cte_turnaround
    as
    (
        select 
            isnull(l.Team, 'AU') Team,
            w.Reference,
            datediff(day, isnull(FirstActiveDate, w.CreationDate), TurnAroundDate) * 1.0 -
            (
                select
                    count(d.[Date])
                from
                    [db-au-cba]..Calendar d with(nolock)
                where
                    d.[Date] >= isnull(FirstActiveDate, w.CreationDate) and
                    d.[Date] <  dateadd(day, 1, convert(date, TurnAroundDate)) and
                    (
                        d.isHoliday = 1 or
                        d.isWeekEnd = 1
                    )
            ) TurnAroundTime
        from
            [db-au-cba]..e5Work w with(nolock)
            outer apply
            (
                --check for e5 Launch Service straight to Diarised (onlince claim bug)
                select top 1 
                    els.StatusName,
                    els.EventDate
                from
                    [db-au-cba]..e5WorkEvent els with(nolock)
                where
                    els.Work_Id = w.Work_ID
                order by
                    els.EventDate
            ) els
            outer apply
            (
                --use first active if it's a botch online launch
                select top 1 
                    EventDate FirstActiveDate
                from
                    [db-au-cba]..e5WorkEvent fa with(nolock)
                where
                    fa.Work_Id = w.Work_ID and
                    fa.EventName in ('Changed Work Status', 'Merged Work', 'Saved Work') and
                    fa.StatusName = 'Active' and
                    (
                        fa.EventUser <> 'e5 Launch Service' or
                        fa.EventDate >= dateadd(day, 1, convert(date, els.EventDate))
                    ) and
                    els.StatusName = 'Diarised'
                order by
                    fa.EventDate
            ) fa
            outer apply
            (
                select top 1 
                    we.EventDate TurnAroundDate
                from
                    [db-au-cba]..e5WorkEvent we with(nolock)
                where
                    we.Work_Id = w.Work_ID and
                    we.EventDate > isnull(FirstActiveDate, w.CreationDate) and
                    we.EventUser <> 'e5 Launch Service' and
                    we.EventName = 'Changed Work Status' and
                    we.StatusName <> 'Active'
                order by
                    we.EventDate
            ) we
            outer apply
            (
	            select top 1
		            'India' Team
	            from
		            [db-au-cba]..usrLDAP l with(nolock)
	            where
		            l.DisplayName = w.AssignedUser and
                    l.Company like 'Trawel%'
            ) l
        where
            w.WorkType = 'Claim' and
            isnull(FirstActiveDate, w.CreationDate) >= @month and
            isnull(FirstActiveDate, w.CreationDate) <  dateadd(month, 1, @month) and
            we.TurnAroundDate is not null
    ),
    cte_team
    as
    (
        select 
            Team,
            count(Reference) CaseCount,
            sum(isnull(TurnAroundTime, 0)) TurnAroundTime
        from
            cte_turnaround
        group by
            Team
    )
    insert into @output
    select
        @month Period,
        'Key Metrics' [Metric Group],
        'Workforce' [Metric Sub Group],
        [Metric Name],
        Value
    from
        (
            select 
                case
                    when sum(CaseCount) = 0 then 0
                    else sum(TurnAroundTime) / sum(CaseCount)
                end [Average Turnaround Time],
                case
                    when sum(case when Team = 'AU' then CaseCount else 0 end) = 0 then 0
                    else sum(case when Team = 'AU' then TurnAroundTime else 0 end) / sum(case when Team = 'AU' then CaseCount else 0 end)
                end [Average Turnaround Time - AU],
                case
                    when sum(case when Team = 'India' then CaseCount else 0 end) = 0 then 0
                    else sum(case when Team = 'India' then TurnAroundTime else 0 end) / sum(case when Team = 'India' then CaseCount else 0 end)
                end [Average Turnaround Time - India]
            from
                cte_team
        ) t
        unpivot
        (
            Value for [Metric Name] in
            (
                [Average Turnaround Time],
                [Average Turnaround Time - AU],
                [Average Turnaround Time - India]
            )
        ) u

    /*workforce - end*/


    /*mix - start*/
    insert into @output
    select 
        @month Period,
        'Mix' [Metric Group],
        'Fast Track' [Metric Sub Group],
        'Fast Track Claim Closed by India' [Metric Name],
        count(*) Value
    from
        #movement
    where
        WorkType = 'Fast Track' and
        [Closed Claims] > 0 and
        IndiaTeam = 1

    insert into @output
    select 
        @month Period,
        'Mix' [Metric Group],
        'Fast Track' [Metric Sub Group],
        'New Claims with End-of-Month <=$1000' [Metric Name],
        count(*) Value
    from
        #movement
    where
        [New Claims] > 0 and
        IncurredValueClosing <= 1000

    insert into @output
    select 
        @month Period,
        'Mix' [Metric Group],
        'Fast Track' [Metric Sub Group],
        'Existing Claims (Opening Balance) with End-of-Month <=$1000' [Metric Name],
        count(*) Value
    from
        #movement
    where
        ActiveOpening > 0 and
        IncurredValueClosing <= 1000

    insert into @output
    select 
        @month Period,
        'Mix' [Metric Group],
        'Fast Track' [Metric Sub Group],
        'Claims <=$1000' [Metric Name],
        count(*) Value
    from
        #movement
    where
        (
            [New Claims] > 0 or
            ActiveOpening > 0 
        ) and
        IncurredValueClosing <= 1000

    insert into @output
    select 
        @month Period,
        'Mix' [Metric Group],
        'Fast Track' [Metric Sub Group],
        'Fast Tracks Completed by India - % of total <=$1000 Claims' [Metric Name],
        case
            when dn.ClaimCount = 0 then 0
            else ft.FTClosed * 1.00 / dn.ClaimCount
        end Value
    from
        (
            select
                count(*) FTClosed
            from
                #movement
            where
                WorkType = 'Fast Track' and
                [Closed Claims] > 0 and
                IndiaTeam = 1
        ) ft
        inner join
        (
            select 
                count(*) ClaimCount
            from
                #movement
            where
                [New Claims] > 0 and
                IncurredValueClosing <= 1000
        ) dn on 1 = 1

    insert into @output
    select 
        @month Period,
        'Mix' [Metric Group],
        'Fast Track' [Metric Sub Group],
        'Fast Tracks Completed by India - % of total New Claims' [Metric Name],
        case
            when dn.ClaimCount = 0 then 0
            else ft.FTClosed * 1.00 / dn.ClaimCount
        end Value
    from
        (
            select
                count(*) FTClosed
            from
                #movement
            where
                WorkType = 'Fast Track' and
                [Closed Claims] > 0 and
                IndiaTeam = 1
        ) ft
        inner join
        (
            select 
                count(*) ClaimCount
            from
                #movement
            where
                [New Claims] > 0
        ) dn on 1 = 1

    insert into @output
    select 
        @month Period,
        'Mix' [Metric Group],
        'Claims Registered' [Metric Sub Group],
        [Metric Name],
        Value
    from
        (
            select 
                convert(float, sum(1)) [Total Claim Registered],
                convert(float, sum(isnull(ocl.isOnline, 0))) [Claim Registered Online],
                convert(float, sum(isnull(ocl.isTeleClaim, 0.00))) [TeleClaim Registered],
                convert(float, sum(isnull(ocl.isOnline, 0)) * 1.00 / sum(1)) [% of Online Claims],
                convert(
                    float, 
                    case
                        when sum(isnull(ocl.isOnline, 0)) = 0 then 0
                        else sum(isnull(ocl.isTeleClaim, 0)) * 1.00 / sum(isnull(ocl.isOnline, 0))
                    end 
                ) [% of TeleClaims of Online Claims]
            from
                [db-au-cba]..clmClaim cl with(nolock)
                outer apply
                (
                    select top 1 
                        1 isOnline,
                        case
                            when OnbehalfEmail like '%@travelinsurancepartners.%' then 1
                            when OnbehalfEmail like '%@covermore.%' then 1
                            when OnbehalfEmail <> '' then 0
                            when exists
                            (
                                select
                                    null
                                from
                                    [db-au-cba]..e5Work w with(nolock)
                                    inner join [db-au-cba]..e5WorkProperties wp with(nolock) on
                                        wp.Work_ID = w.Work_ID and
                                        wp.Property_ID = 'ClaimType'
                                    inner join [db-au-cba]..e5WorkItems wi with(nolock) on
                                        wi.ID = convert(int, wp.PropertyValue)
                                where
                                    w.claimkey = ocl.ClaimKey and
                                    w.worktype = 'claim' and
                                    wi.Name = 'teleclaim'
                            ) then 1
              when l.isTeleOfficer = 1 then 1
                            else 0
                        end isTeleClaim
                    from
                        [db-au-cba]..clmOnlineClaim ocl with(nolock)
                        outer apply
                        (
                            select 
                                max
                                (
                                    case
                                        when lh.Department like 'claim%' then 1
                                        when lh.JobTitle like 'claim%' then 1
                                        when l.Department like 'claim%' then 1
                                        when l.JobTitle like 'claim%' then 1
                                        else 0
                                    end 
                                ) isTeleOfficer
                            from
                                [db-au-cba]..usrLDAP l with(nolock)
                                outer apply
                                (
                                    select top 1 
                                        lh.Department,
                                        lh.JobTitle
                                    from
                                        [db-au-cba]..usrLDAPHistory lh with(nolock)
                                    where
                                        lh.UserID = l.UserID and
                                        lh.CreateDateTime < dateadd(day, 1, convert(date, ocl.CreateDateTime))
                                    order by
                                        lh.CreateDateTime desc
                                ) lh
                            where
                                l.username = ocl.ConsultantName
                        ) l
                    where
                        ocl.ClaimKey = cl.ClaimKey
                ) ocl
            where
                cl.CountryKey = 'AU' and
                cl.CreateDate >= @month and
                cl.CreateDate <  dateadd(month, 1, @month)
        ) t
        unpivot
        (
            Value for [Metric Name] in
            (
                [Total Claim Registered],
                [Claim Registered Online],
                [TeleClaim Registered],
                [% of Online Claims],
                [% of TeleClaims of Online Claims]
            )
        ) u

    /*mix - end*/

    /*segment - start*/
    if object_id('tempdb..#settlement') is not null
        drop table #settlement

    select 
        isnull(cb.Section, 'Other') Section,
        ClaimKey,
        SectionKey,
        SettlementLag
    into #settlement
    from
        (
            select
                cl.ClaimKey,
                cs.SectionKey,
                datediff(day, cl.ReceivedDate, cl.FirstNilDate) + 1 SettlementLag
            from
                [db-au-cba]..clmClaim cl with(nolock)
                inner join [db-au-cba]..clmSection cs with(nolock) on
                    cs.ClaimKey = cl.ClaimKey
                left join [db-au-cba]..clmClaimPaymentMovement cpm with(nolock) on
                    cpm.ClaimKey = cl.ClaimKey and
                    cpm.SectionKey = cs.SectionKey and
                    cpm.FirstPayment = 1
            where
                cl.ClaimKey like 'AU%' and
                cl.FirstNilDate >= @month and
                cl.FirstNilDate <  dateadd(month, 1, @month) and
                cl.FirstNilDate < isnull(cpm.PaymentDate, dateadd(month, 1, @month))

            union all

            select
                cl.ClaimKey,
                cpm.SectionKey,
                datediff(day, cl.ReceivedDate, cpm.PaymentDate) + 1 SettlementLag
            from
                [db-au-cba]..clmClaim cl with(nolock)
                inner join [db-au-cba]..clmClaimPaymentMovement cpm with(nolock) on
                    cpm.ClaimKey = cl.ClaimKey
                left join [db-au-cba]..clmSection cs with(nolock) on
                    cs.SectionKey = cpm.SectionKey
            where
                cl.ClaimKey like 'AU%' and
                cpm.FirstPayment = 1 and
                cpm.PaymentDate >= @month and
                cpm.PaymentDate <  dateadd(month, 1, @month) and
                cpm.PaymentDate <= isnull(cl.FirstNilDate, cpm.PaymentDate)
        ) r
        outer apply
        (
            select top 1 
                cb.OperationalBenefitGroup Section
            from
                (
                    select top 1 
                        BenefitSectionKey
                    from
                        [db-au-cba]..clmSection cs with(nolock)
                    where
                        cs.SectionKey = r.SectionKey

                    union all

                    select top 1 
                        BenefitSectionKey
                    from
                        [db-au-cba]..clmAuditSection cas with(nolock)
                    where
                        cas.SectionKey = r.SectionKey and
                        cas.AuditDateTime < dateadd(month, 1, @month)
                ) cs
                inner join [db-au-cba]..vclmBenefitCategory cb with(nolock) on
                    cb.BenefitSectionKey = cs.BenefitSectionKey
        ) cb

    insert into @output
    select 
        @month Period,
        'Segment' [Metric Group],
        'Settlement' [Metric Sub Group],
        'Settlement Days (avg)' [Metric Name],
        case
            when count(Claimkey) = 0 then 0
            else sum(SettlementLag) * 1.00 / count(Claimkey)
        end Value
    from
        (
            select 
                ClaimKey,
                min(SettlementLag) SettlementLag
            from
                #settlement
            group by
                ClaimKey
        ) t

    insert into @output
    select 
        @month Period,
        'Segment' [Metric Group],
        'Settlement' [Metric Sub Group],
        'Settlement Days (avg) - ' + Section [Metric Name],
        case
            when count(Sectionkey) = 0 then 0
            else sum(SettlementLag) * 1.00 / count(Sectionkey)
        end Value
    from
        #settlement
    group by
        Section

    insert into @output
    select 
        @month Period,
        'Segment' [Metric Group],
        'Settlement' [Metric Sub Group],
        'Settlement Days (95% avg)' [Metric Name],
        case
            when count(Claimkey) = 0 then 0
            else sum(SettlementLag) * 1.00 / count(Claimkey)
        end Value
    from
        (
            select 
                ClaimKey,
                min(SettlementLag) SettlementLag
            from
                (
                    select top 95 percent
                        *
                    from
                        #settlement
                    order by
                        SettlementLag
                ) t
            group by
                ClaimKey
        ) t

    insert into @output
    select 
        @month Period,
        'Segment' [Metric Group],
        'Settlement' [Metric Sub Group],
        'Settlement Days (95% avg) - ' + Section [Metric Name],
        case
            when count(Sectionkey) = 0 then 0
            else sum(SettlementLag) * 1.00 / count(Sectionkey)
        end Value
    from
        (
            select top 95 percent
                *
            from
                #settlement
            order by
                SettlementLag
        ) t
    group by
        Section

    insert into @output
    select 
        @month Period,
        'Segment' [Metric Group],
        'Claims Size' [Metric Sub Group],
        'First Closure Payment' [Metric Name],
        [Pre First Nil Payment] Value
    from
        @icube t
    where
        Section = 'Total'

    insert into @output
    select 
        @month Period,
        'Segment' [Metric Group],
        'Claims Size' [Metric Sub Group],
        'First Closure Count' [Metric Name],
        [Pre First Nil Count] Value
    from
        @icube t
    where
        Section = 'Total'

    insert into @output
    select 
        @month Period,
        'Segment' [Metric Group],
        'Claims Size' [Metric Sub Group],
        'Avg Claim Size at First Closure' [Metric Name],
        [Pre First Nil Avg Payment] Value
    from
        @icube t
    where
        Section = 'Total'

    insert into @output
    select 
        @month Period,
        'Segment' [Metric Group],
        'Claims Size' [Metric Sub Group],
        'Avg Claim Size at First Closure - ' + s.Section [Metric Name],
        sum([Pre First Nil Payment]) /
        sum([Pre First Nil Count]) Value
    from
        @icube t
        cross apply
        (
            select
                case
                    when Section = 'Unknown' then 'Other'
                    else Section
                end Section
        ) s
    where
        t.Section <> 'Total'
    group by
        s.Section

    insert into @output
    select 
        @month Period,
        'Segment' [Metric Group],
        'Claims Size' [Metric Sub Group],
        'Avg Re-Open Payment Value' [Metric Name],
        [Post First Nil Avg Payment] Value
    from
        @icube t
    where
        Section = 'Total'

    insert into @output
    select 
        @month Period,
        'Segment' [Metric Group],
        'Claims Size' [Metric Sub Group],
        'Total average First Closure and Re-Open Payment Value' [Metric Name],
        [Pre First Nil Avg Payment] + [Post First Nil Avg Payment] Value
    from
        @icube t
    where
        Section = 'Total'

    /*segment - end*/

    /*customer - start*/

    insert into @output
    select 
        @month Period,
        'Customer' [Metric Group],
        'Denial' [Metric Sub Group],
        [Metric Name],
        Value
    from
        (
            select 
                convert(float, sum([Denied])) [Claims Denied],
                convert(
                    float, 
                    case
                        when sum([Closed Claims]) = 0 then 0.00
                        else sum([Denied]) * 1.00 / sum([Closed Claims]) 
                    end 
                ) [Denial Rate]
            from
                #movement
        ) t
        unpivot
        (
            Value for [Metric Name] in
            (
                [Claims Denied],
                [Denial Rate]
            )
        ) u

    insert into @output
    select
        @month Period,
        'Customer' [Metric Group],
        'Complaints' [Metric Sub Group],
        [Metric Name] + ' - New Cases' [Metric Name],
        Value
    from
        (
            select 
                sum
                (
                    case
                        when w.GroupType = 'NEW' then 1
                        else 0
                    end
                ) Complaint,
                sum
                (
                    case
                        when w.GroupType = 'IDR' then 1
                        else 0
                    end
                ) [Internal Dispute Resolution],
                sum
                (
                    case
                        when isnull(wp.isEDR, '0') = '0' then 0
                        else 1
                    end
                ) [External Dispute Resolution]
            from
                [db-au-cba]..e5Work w
                outer apply
                (
                    select top 1 
                        convert(varchar, PropertyValue) isEDR
                    from
                        [db-au-cba]..e5WorkProperties wp
                    where
                        wp.Work_ID = w.Work_ID and
                        wp.Property_ID = 'EDRReferral'
                ) wp
            where
                w.Country = 'AU' and
                w.WorkType = 'Complaints' and
                w.CreationDate >= @month and
                w.CreationDate <  dateadd(month, 1, @month)
        ) t
        unpivot
        (
            Value for [Metric Name] in
            (
                Complaint,
                [Internal Dispute Resolution],
                [External Dispute Resolution]
            )
        ) u



    /*breach .. damn, this is hard due to shitty e5 data*/
    if object_id('tempdb..#activeatstart') is not null
        drop table #activeatstart

    select
        w.Work_ID,
        w.CreationDate
    into #activeatstart
    from
        [db-au-cba]..e5Work w with(nolock)
        cross apply
        (
            select top 1
                we.StatusName
            from
                [db-au-cba]..e5WorkEvent_v3 we with(nolock,index(idx_e5WorkEvent_v3_WorkID))
            where
                we.Work_ID = w.Work_ID and
                we.EventName <> 'Closed Work' and
                we.EventDate >= dateadd(month, -3, @month) and --let's be pragmatic, if it's more than 3 months it's likely to be e5 crap .. err, i mean bug
                we.EventDate < @month
            order by
                we.EventDate desc
        ) we
    where
        w.ClaimKey like 'AU%' and
        w.WorkType = 'Claim' and
        w.CreationDate < @month and
        we.StatusName = 'Active'

    if object_id('tempdb..#breached') is not null
        drop table #breached

    select 
        w.Work_ID
    into #breached
    from
        #activeatstart w
        outer apply
        (
            select 
                max(we.EventDate) LastNonActive
            from
                [db-au-cba]..e5WorkEvent we with(nolock)
            where
                we.Work_ID = w.Work_ID and
                we.StatusName <> 'Active' and
                we.EventDate < @month
        ) lna
        cross apply
        (
            select 
                min(we.EventDate) LastActive
            from
                [db-au-cba]..e5WorkEvent we with(nolock)
            where
                we.Work_ID = w.Work_ID and
                we.StatusName = 'Active' and
                we.EventDate < @month and
                we.EventDate > isnull(lna.LastNonActive, w.CreationDate)
        ) la
        cross apply
        (
            select 
                max(Interval) BreachDate
            from
                (
                    select top 11
                        c.[Date] Interval
                    from 
                        [db-au-cba]..Calendar c with(nolock)
                    where
                        c.[Date] > la.LastActive and
                        not
                        (
                            c.isHoliday = 1 or
                            c.isWeekEnd = 1
                        )
                    order by
                        c.[Date]
                ) t
        ) bd
    where
        LastActive is not null and
        not exists
        (
            select
                null
            from
                [db-au-cba]..e5WorkEvent r with(nolock)
            where
                r.Work_ID = w.Work_ID and
                r.StatusName <> 'Active' and
                r.EventDate >= la.LastActive and
                r.EventDate <  bd.BreachDate
        )

    insert into #breached
    select --top 100
        w.Work_ID
        --,
        --w.Reference,
        --we.EventDate,
        --bd.BreachDate
    from
        [db-au-cba]..e5Work w with(nolock)
        inner join [db-au-cba]..e5WorkEvent_v3 we with(nolock,index(idx_e5WorkEvent_v3_WorkID)) on
            we.Work_ID = w.Work_ID
        cross apply
        (
            select 
                max(Interval) BreachDate
            from
                (
                    select top 11
                        c.[Date] Interval
                    from 
                        [db-au-cba]..Calendar c with(nolock)
                    where
                        c.[Date] > we.EventDate and
                        not
                        (
                            c.isHoliday = 1 or
                            c.isWeekEnd = 1
                        )
                    order by
                        c.[Date]
                ) t
        ) bd
    where
        w.ClaimKey like 'AU%' and
        w.WorkType = 'Claim' and
        we.EventDate >= @month and
        w.CreationDate < dateadd(day, -10, dateadd(month, 1, @month)) and --don't bother checking the tail, leave it to next month 
        we.EventDate <  dateadd(day, -10, dateadd(month, 1, @month)) and 
        bd.BreachDate < dateadd(month, 1, @month) and
        we.EventName in ('Changed Work Status', 'Completed Task') and
        we.StatusName = 'Active' and
        not exists
        (
            select
                null
            from
                [db-au-cba]..e5WorkEvent_v3 r with(nolock,index(idx_e5WorkEvent_v3_WorkID))
            where
                r.Work_ID = w.Work_ID and
                r.StatusName <> 'Active' and
                r.EventDate >= we.EventDate and
                r.EventDate <  bd.BreachDate
        )

    insert into @output
    select
        @month Period,
        'Customer' [Metric Group],
        'Complaints' [Metric Sub Group],
        'No of Claims Outside of 10 days' [Metric Name],
        count(distinct Work_ID) Value
    from
        #breached


    /*customer - end*/

    if object_id('tempdb..##claimdashboardextract') is not null --nested insert exec workaround
        drop table ##claimdashboardextract

    select *
    into ##claimdashboardextract
    from
        @output

    select *
    from
        @output

end



GO
