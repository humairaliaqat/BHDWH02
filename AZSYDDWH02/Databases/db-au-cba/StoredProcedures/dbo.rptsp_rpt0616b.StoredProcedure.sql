USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_rpt0616b]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[rptsp_rpt0616b]  
    @SuperGroup nvarchar(4000) = 'All',
    @Group nvarchar(4000) = 'All',
    @ReportingPeriod varchar(30),
    @StartDate date = null,
    @EndDate date = null

as
Begin


--20160120, PZ, T21740, Created
--20160211, PZ, T22114, add "Same Period Last Year" data and new dimension "Period" for Year on Year comparison



--uncomment to debug
--declare 
--    @SuperGroup nvarchar(4000),
--    @Group nvarchar(4000),
--    @ReportingPeriod varchar(30),
--    @StartDate date,
--    @EndDate date
--	--@i int
--select 
--    @SuperGroup = 'All',
--    @Group = 'All',
--    @ReportingPeriod = '_User Defined', 
--    @StartDate = '2015-09-01', 
--    @EndDate = '2015-11-28'
----------------------



set nocount on
                                    
declare 
	@i int = 1,
    @rptStartDate datetime,
    @rptEndDate datetime,
	@rptStartDate_LY datetime,
    @rptEndDate_LY datetime,
	@p nvarchar(10)

--get reporting dates
    if @ReportingPeriod = '_User Defined'
        select 
            @rptStartDate = @StartDate,
            @rptEndDate = @EndDate,
			@rptStartDate_LY = dateadd(YEAR,-1,@StartDate),
			@rptEndDate_LY = dateadd(YEAR,-1,@EndDate)
            
    else
        select 
            @rptStartDate = StartDate, 
            @rptEndDate = EndDate,
			@rptStartDate_LY = dateadd(YEAR,-1,StartDate),
			@rptEndDate_LY = dateadd(YEAR,-1,EndDate)
        from 
            vDateRange
        where 
            DateRange = @ReportingPeriod


IF OBJECT_ID('tempdb..#temp_a') IS NOT NULL DROP TABLE #temp_a
IF OBJECT_ID('tempdb..#temp_month') IS NOT NULL DROP TABLE #temp_month
IF OBJECT_ID('tempdb..#temp_month1') IS NOT NULL DROP TABLE #temp_month1
IF OBJECT_ID('tempdb..#temp_outcome') IS NOT NULL DROP TABLE #temp_outcome
CREATE TABLE #temp_outcome 
(
	[RPT Start Date] datetime, 
	[RPT End Date] datetime, 
	[Month] nvarchar(10),  
	[Reference Type] nvarchar(20),
	[Closing Active Count] int, 
	[Period] nvarchar(10),
	[Period Begin] datetime,
	[Period End] datetime,
	[Is Period Begin] int,
	[Is Period End] int
)


-- Get the begin and end date for each calender month in the selected period
select
	aa.[YM],
	[Month Begin] = aa.[Month Begin],
	[Month End] = aa.[Month End],
	aa.[Period],
	[X] = ROW_NUMBER() over (order by aa.[Month Begin])
into #temp_month
from
	(--aa
	select distinct
		[YM] = c.CurMonthStart,
		[Month Begin] = case
						when @rptStartDate > c.CurMonthStart
							then @rptStartDate
						else c.CurMonthStart
				end,
		[Month End] = case
							when @rptEndDate < c.CurMonthEnd
								then @rptEndDate
							else c.CurMonthEnd
					end,
		[Period] = 'Current'
	from dbo.Calendar c
	where
		c.[Date] between @rptStartDate and @rptEndDate

	union all

	select distinct
		[YM] = c.CurMonthStart,
		[Month Begin] = case
						when @rptStartDate_LY > c.CurMonthStart
							then @rptStartDate_LY
						else c.CurMonthStart
				end,
		[Month End] = case
							when @rptEndDate_LY < c.CurMonthEnd
								then @rptEndDate_LY
							else c.CurMonthEnd
					end,
		[Period] = 'Previous'
	from dbo.Calendar c
	where
		c.[Date] between @rptStartDate_LY and @rptEndDate_LY
	)as aa



select
	m.*,
	tm.[Period End],
	tm1.[Period Begin],
	[Is Period Begin] = case when m.[Month Begin] = tm1.[Period Begin] then 1 else 0 end,
	[Is Period End] = case when m.[Month End] = tm.[Period End] then 1 else 0 end
into #temp_month1
from #temp_month m
outer apply -- Get the period end
	(
	select
		max(tm.[Month End]) as [Period End],
		tm.Period
	from #temp_month tm 
	where
	m.Period = tm.Period
	group by
		tm.Period
	) as tm
outer apply -- Get the period Begin
	(
	select
		min(tm1.[Month Begin]) as [Period Begin],
		tm1.Period
	from #temp_month tm1
	where
	m.Period = tm1.Period
	group by
		tm1.Period
	) as tm1



select 
	[Reference Type] = case when w.GroupType = 'New' then 'Complaints' else 'IDR' end,
	w.Reference,
	we.StatusName,
	we.EventDate,
	w.CreationDate,
	w.CompletionDate
into #temp_a
from e5work w
inner join e5WorkEvent we on w.Work_ID = we.Work_ID 
where
	isnull(w.Country, 'AU') = 'AU' and
	w.WorkType = 'Complaints' 
	and w.GroupType in ('NEW', 'IDR')
	and 
		(
		we.EventName = 'Changed Work Status' 
		or
		(
			we.EventName = 'Saved Work' and
			we.EventUser in ('e5 Launch Service', 'svc-e5-prd-services')
		)
		) 




While (@i <= (select count(*) from #temp_month1))

Begin
			set @rptStartDate = (select m.[Month Begin] from #temp_month1 m where m.X = @i)
			set @rptEndDate = (select m.[Month End] from #temp_month1 m where m.X = @i)
			set @p = (select m.[Period] from #temp_month1 m where m.X = @i)
						
			;with c as -- Closing Balance
			(
			select
			[Start Date] = @rptStartDate,
			[End Date] = @rptEndDate,
			zz0.*,
			c.[Latest Event Date],
			[Closing Active Count] = case when zz0.StatusName in ('Active','Diarised','Launch') then 1 else 0 end
			from #temp_a zz0
			outer apply
				(
				select
				[Latest Event Date] = max(c.EventDate)
				from #temp_a  c
				where
					c.Reference = zz0.Reference
					and cast(c.EventDate as date) <= @rptEndDate
				) as c
			where
				c.[Latest Event Date] = zz0.EventDate
			)

			
			insert into #temp_outcome

			select
				[RPT Start Date] = @rptStartDate,
				[RPT End Date] = @rptEndDate,
				[Month] = (select cast(m.YM as date) from #temp_month1 m where m.X = @i),
				c.[Reference Type],
				[Closing Active Count] = sum(c.[Closing Active Count]),
				[Period] = @p,
				[Period Begin] = (select m.[Period Begin] from #temp_month1 m where m.X = @i),
				[Period End] = (select m.[Period End] from #temp_month1 m where m.X = @i),
				[Is Period Begin] = (select m.[Is Period Begin] from #temp_month1 m where m.X = @i),
				[Is Period End] = (select m.[Is Period End] from #temp_month1 m where m.X = @i)
			from e5Work w
			left join c on w.Reference = c.Reference
			Left join penOutlet o on w.AgencyCode = o.AlphaCode and w.Country = o.CountryKey and o.OutletStatus = 'current'
			where
				c.[Reference Type] is not null
				and
				(
				@SuperGroup = 'All' or
				o.SuperGroupName in
					(select 
							Item
					from dbo.fn_DelimitedSplit8K(@SuperGroup, ',')
					)
				) 
				and
				(
				@Group = 'All' or
				o.GroupName in
					(
						select 
							Item
						from dbo.fn_DelimitedSplit8K(@Group, ',')
					)
				)
			group by
				c.[Reference Type]

			set @i = @i + 1
End


select * from #temp_outcome

end
GO
