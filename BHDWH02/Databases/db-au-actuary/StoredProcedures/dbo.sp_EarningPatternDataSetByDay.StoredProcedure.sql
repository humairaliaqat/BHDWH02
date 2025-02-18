USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [dbo].[sp_EarningPatternDataSetByDay]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[sp_EarningPatternDataSetByDay]		@DateRange varchar(30),
															@StartDate varchar(10),
															@EndDate varchar(10)
as

SET NOCOUNT ON

										
/****************************************************************************************************/
--  Name:           sp_EarningPatternDataSetByDay
--  Author:         Saurabh Date
--  Date Created:   20161207
--  Description:    This stored procedure inserts data into [db-au-actuary].[dbo].[EarningPatternsDataSetByDay] using [db-au-actuary].dbo.DWHDataSetSummary policies as data source.
--
--  Parameters:     @ReportingPeriod: standard date range or _User Defined
--					@StartDate: if _User Defined. Format: YYYY-MM-DD eg. 2015-01-01
--					@EndDate: if_User Defined. Format: YYYY-MM-DD eg. 2015-01-01
--   
--  Change History: 20161207 - SD - Created
--                  
/****************************************************************************************************/

--uncomment to debug
/*
declare @DateRange varchar(30)
declare @StartDate varchar(10)
declare @EndDate varchar(10)
select @DateRange = '_User Defined', @StartDate = '2014-07-01', @EndDate = '2014-07-31'
*/

declare @rptStartDate date
declare @rptEndDate date

--get reporting dates
if @DateRange = '_User Defined'
	select @rptStartDate = @StartDate,
		   @rptEndDate = @EndDate
else
	select @rptStartDate = StartDate, 
		   @rptEndDate = EndDate
	from [db-au-cmdwh].dbo.vDateRange
	where DateRange = @DateRange


IF OBJECT_ID('[db-au-workspace].dbo.tmp_Combination') IS NOT NULL DROP TABLE [db-au-workspace].dbo.tmp_Combination

--Creating temp table to store all the user required combinations to define pre and post departure split
Create Table [db-au-workspace].dbo.tmp_Combination
	(
		Name char(1),
		LeadTimeMinValue Int,
		LeadTimeMaxValue Int,
		TripLengthMinValue Int,
		TripLengthMaxValue Int,
		PreDeparturePct Int,
		PostDeparturePct Int
	)

Insert Into [db-au-workspace].dbo.tmp_Combination
	(Name, LeadTimeMinValue, LeadTimeMaxValue, TripLengthMinValue, TripLengthMaxValue, PreDeparturePct, PostDeparturePct)
Values
	('a', 0, 16, 0, 6, 28, 72),
	('b', 0, 16, 7, 11, 16, 84),
	('c', 0, 16, 12, 22, 11, 89),
	('d', 0, 16, 23, null, 6, 94),
	('e', 17, 53, 0, 6, 41, 59),
	('f', 17, 53, 7, 11, 26, 74),
	('g', 17, 53, 12, 22, 18, 82),
	('h', 17, 53, 23, null, 10, 90),
	('i', 54, 120, 0, 6, 50, 50),
	('j', 54, 120, 7, 11, 33, 67),
	('k', 54, 120, 12, 22, 24, 76),
	('l', 54, 120, 23, null, 13, 87),
	('m', 121, null, 0, 6, 56, 44),
	('n', 121, null, 7, 11, 37, 63),
	('o', 121, null, 12, 22, 29, 71),
	('p', 121, null, 23, null, 18, 82)

IF OBJECT_ID('[db-au-workspace].dbo.tmp_Temp1') IS NOT NULL DROP TABLE [db-au-workspace].dbo.tmp_Temp1

--Creating temp table to define and store pre and post departure pattern selection data
select
	ds.[Base Policy No] as PolicyNumber,
	case when ds.[Trip Type] = 'AMT' then 'Annual Multi Trip' else ds.[Trip Type] end as TripType,
	ds.[Issue Date] as IssueDate,
	ds.[Departure Date] as TripStart,
	ds.[Return Date] as TripEnd,
	DateDiff(day, ds.[Issue Date], ds.[Departure Date]) [Lead Time], 
	(DateDiff(Day, ds.[Departure Date], ds.[Return Date]) + 1 ) [Trip Length],
	Case When ds.[Trip Type] in ('Annual Multi Trip','AMT') Then '9' Else DeparturePct.PreDeparturePct End [PreDeparturePct],
	Case When ds.[Trip Type] in ('Annual Multi Trip','AMT') Then '91' Else DeparturePct.PostDeparturePct End [PostDeparturePct],
	Case 
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(day, ds.[Issue Date], ds.[Departure Date]) >= 0 
			and DateDiff(day, ds.[Issue Date], ds.[Departure Date]) <= 16
		Then
			'1st Pattern'
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(day, ds.[Issue Date], ds.[Departure Date]) >= 17 
			and DateDiff(day, ds.[Issue Date], ds.[Departure Date]) <= 53
		Then
			'2nd Pattern'
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(day, ds.[Issue Date], ds.[Departure Date]) >= 54 
			and DateDiff(day, ds.[Issue Date], ds.[Departure Date]) <= 120
		Then
			'3rd Pattern'
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(day, ds.[Issue Date], ds.[Departure Date]) >= 121 
		Then
			'4th Pattern'
		When
			ds.[Trip Type] in ('Annual Multi Trip','AMT')
		Then
			'9th Pattern'
	End [PreDeparturePercentileBand],
	Case 
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(Day, ds.[Departure Date], ds.[Return Date]) >= 0 
			and DateDiff(Day, ds.[Departure Date], ds.[Return Date]) <= 6
		Then
			'5th Pattern'
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(Day, ds.[Departure Date], ds.[Return Date]) >= 7 
			and DateDiff(Day, ds.[Departure Date], ds.[Return Date]) <= 11
		Then
			'6th Pattern'
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(Day, ds.[Departure Date], ds.[Return Date]) >= 12
			and DateDiff(Day, ds.[Departure Date], ds.[Return Date]) <= 22
		Then
			'7th Pattern'
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(Day, ds.[Departure Date], ds.[Return Date]) >= 23
		Then
			'8th Pattern'
		When
			ds.[Trip Type] in ('Annual Multi Trip','AMT')
		Then
			'10th Pattern'
	End [PostDeparturePercentileBand],
	--Sum(ppt.GrossPremium) [SellPrice], --Removed Sell Price, now using Premium value
	--Sum(isnull(ds.[Premium],0)) [Premium],
	Sum(datediff(day,ds.[Issue Date],ds.[Return Date])+1) [Trip Duration],
	--As user requested, keeping AMT Pre-Departure percentage as 15%, for Single trips it will get caluclated in run time
	Sum((isnull(Convert(float,datediff(day,ds.[Issue Date],ds.[Return Date])+1),0))*(Case When ds.[Trip Type] in ('Annual Multi Trip','AMT') Then '9' Else DeparturePct.PreDeparturePct End)/100) [PreDepartureTripDuration],
	--As user requested, keeping AMT Post-Departure percentage as 85%, for Single trips it will get caluclated in run time
	Sum((isnull(Convert(float,datediff(day,ds.[Issue Date],ds.[Return Date])+1),0))*(Case When ds.[Trip Type] in ('Annual Multi Trip','AMT') Then '91' Else DeparturePct.PostDeparturePct End)/100) [PostDepartureTripDuration]
Into
	[db-au-workspace].dbo.tmp_Temp1
From
	[db-au-actuary].dbo.DWHDataSetSummary ds
	Outer Apply
		(
			select 
				c.PreDeparturePct,
				c.PostDeparturePct
			From
				[db-au-workspace].dbo.tmp_Combination c
			Where
				c.LeadTimeMinValue <= DateDiff(day, ds.[Issue Date], ds.[Departure Date]) and
				(
				c.LeadTimeMaxValue >= DateDiff(day, ds.[Issue Date], ds.[Departure Date])
				or
				c.LeadTimeMaxValue is null
				) and
				c.TripLengthMinValue <= DateDiff(Day, ds.[Departure Date], ds.[Return Date]) and
				(
				c.TripLengthMaxValue >= DateDiff(Day, ds.[Departure Date], ds.[Return Date])
				or
				c.TripLengthMaxValue is null
				)
		) DeparturePct
Where	
	ds.[Trip Type] in ('AMT','Single Trip') and
	ds.[Issue Date] >= @rptStartDate and
	ds.[Issue Date] < dateadd(d,1,@rptEndDate)
Group By
	ds.[Base Policy No],
	case when ds.[Trip Type] = 'AMT' then 'Annual Multi Trip' else ds.[Trip Type] end,
	ds.[Issue Date],
	ds.[Departure Date],
	ds.[Return Date],
	DateDiff(day, ds.[Issue Date], ds.[Departure Date]),
	DateDiff(Day, ds.[Departure Date], ds.[Return Date]),
	Case When ds.[Trip Type] in ('Annual Multi Trip','AMT') Then '9' Else DeparturePct.PreDeparturePct End,
	Case When ds.[Trip Type] in ('Annual Multi Trip','AMT') Then '91' Else DeparturePct.PostDeparturePct End,
	Case 
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(day, ds.[Issue Date], ds.[Departure Date]) >= 0 
			and DateDiff(day, ds.[Issue Date], ds.[Departure Date]) <= 16
		Then
			'1st Pattern'
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(day, ds.[Issue Date], ds.[Departure Date]) >= 17 
			and DateDiff(day, ds.[Issue Date], ds.[Departure Date]) <= 53
		Then
			'2nd Pattern'
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(day, ds.[Issue Date], ds.[Departure Date]) >= 54 
			and DateDiff(day, ds.[Issue Date], ds.[Departure Date]) <= 120
		Then
			'3rd Pattern'
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(day, ds.[Issue Date], ds.[Departure Date]) >= 121 
		Then
			'4th Pattern'
		When
			ds.[Trip Type] in ('Annual Multi Trip','AMT')
		Then
			'9th Pattern'
	End,
	Case 
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(Day, ds.[Departure Date], ds.[Return Date]) >= 0 
			and DateDiff(Day, ds.[Departure Date], ds.[Return Date]) <= 6
		Then
			'5th Pattern'
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(Day, ds.[Departure Date], ds.[Return Date]) >= 7 
			and DateDiff(Day, ds.[Departure Date], ds.[Return Date]) <= 11
		Then
			'6th Pattern'
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(Day, ds.[Departure Date], ds.[Return Date]) >= 12
			and DateDiff(Day, ds.[Departure Date], ds.[Return Date]) <= 22
		Then
			'7th Pattern'
		When 
			ds.[Trip Type] = 'Single Trip' and
			DateDiff(Day, ds.[Departure Date], ds.[Return Date]) >= 23
		Then
			'8th Pattern'
		When
			ds.[Trip Type] in ('Annual Multi Trip','AMT')
		Then
			'10th Pattern'
	End


IF OBJECT_ID('[db-au-workspace].dbo.tmp_Pattern') IS NOT NULL DROP TABLE [db-au-workspace].dbo.tmp_Pattern

--This temp table stores data for pre and post departure pattern index wise Premium
select 
	t.PolicyNumber,
	t.TripType,
	t.IssueDate,
	t.TripStart,
	t.TripEnd,
	'Pre Departure' [DepartureState],
	t.[PreDeparturePercentileBand] [Percentileband],
	t.PreDeparturePct [Departure State Percentage],
	--Round(100.00/(Case When t.[Lead Time] = 0 Then 1 Else t.[Lead Time] End),2) [Departure per Day Percentage],
	Round(100.00/(Case When t.[Lead Time] <> 0 Then t.[Lead Time] else 1 End),2) [Departure per Day Percentage],	
	t.[Lead Time], 
	t.[Trip Length],
	t.[Trip Duration],
	t.[PreDepartureTripDuration] [DepartureTripDuration],
	e.PatternType,
	e.PatternIndex,
	e.PatternPercentage,
	(e.PatternPercentage * t.PreDeparturePct / 100 ) [OverallPatternPercentage],
	(t.[PreDepartureTripDuration] * e.PatternPercentage) [Pattern TripDuration]
Into
	[db-au-workspace].dbo.tmp_Pattern
from 
	[db-au-workspace].dbo.tmp_Temp1 t
	Inner Join [db-au-actuary].[dbo].[EarningPatternsMappingByDay] e
		on t.TripType = e.TripType
			and t.[PreDeparturePercentileBand] = e.Percentileband

Union

select 
	t.PolicyNumber,
	t.TripType,
	t.IssueDate,
	t.TripStart,
	t.TripEnd,
	'Post Departure' [DepartureState],
	t.[PostDeparturePercentileBand] [Percentileband],
	t.PostDeparturePct [Departure State Percentage],
	--Round(100.00/((Case When t.[Trip Length] = 0 Then 1 Else t.[Trip Length] End) + 1), 2) [Departure per Day Percentage],
	Round(100.00/((Case When t.[Trip Length] = 0 then 1
					    when t.[Trip Length] = -1 then 1
						else t.[Trip Length] 
					End) + 1), 2) [Departure per Day Percentage],
	t.[Lead Time], 
	t.[Trip Length],
	t.[Trip Duration],
	t.[PostDepartureTripDuration] [DepartureTripDuration],
	e.PatternType,
	e.PatternIndex,
	e.PatternPercentage,
	(e.PatternPercentage * t.PostDeparturePct / 100 )[OverallPatternPercentage],
	(t.[PostDepartureTripDuration] * e.PatternPercentage) [Pattern TripDuration]
from 
	[db-au-workspace].dbo.tmp_Temp1 t
	Inner Join [db-au-actuary].[dbo].[EarningPatternsMappingByDay] e
		on t.TripType = e.TripType
			and t.[PostDeparturePercentileBand] = e.Percentileband


IF OBJECT_ID('[db-au-workspace].dbo.tmp_PreDepartureDates') IS NOT NULL DROP TABLE [db-au-workspace].dbo.tmp_PreDepartureDates

--Calculating Pre Departure dates
Select 
	t.PolicyNumber,
	t.TripType,
	DateName(mm, c.date) [PreDepartureMonth],
	Month(c.Date) [PreDepartureMonthNumber],
	Year(c.Date) [PreDepartureYear],
	Round(Sum(PerDayPct.[Departure per Day Percentage]),0) [Pct Value]
Into
	[db-au-workspace].dbo.tmp_PreDepartureDates
from 
	[db-au-cmdwh].dbo.Calendar c
	inner join [db-au-workspace].dbo.tmp_Temp1 t
		On c.date >= Convert(date,IssueDate) and 
		c.date <= (Case When [Lead Time] = 0 Then Convert(date,IssueDate) Else DateAdd(Day, [Lead Time], Convert(date,IssueDate)) End)
	Outer apply
	(
		Select
			distinct [Departure per Day Percentage]
		From
			[db-au-workspace].dbo.tmp_Pattern p
		Where 
			p.PolicyNumber = t.PolicyNumber and
			p.[DepartureState] = 'Pre Departure'
	) PerDayPct
Group By
	t.PolicyNumber,
	t.TripType,
	DateName(mm, c.date),
	Month(c.Date),
	Year(c.Date)

IF OBJECT_ID('[db-au-workspace].dbo.tmp_PostDepartureDates') IS NOT NULL DROP TABLE [db-au-workspace].dbo.tmp_PostDepartureDates

--Calculating Post Departure dates
Select 
	t.PolicyNumber,
	t.TripType,
	DateName(mm, c.date) [PostDepartureMonth],
	Month(c.Date) [PostDepartureMonthNumber],
	Year(c.Date) [PostDepartureYear],
	Round(Sum(PerDayPct.[Departure per Day Percentage]),0) [Pct Value]
Into
	[db-au-workspace].dbo.tmp_PostDepartureDates
from 
	[db-au-cmdwh].dbo.Calendar c
	inner join [db-au-workspace].dbo.tmp_Temp1 t
		On c.date >= convert(date,TripStart) and c.date <= Convert(date,TripEnd)
	Outer apply
	(
		Select
			distinct [Departure per Day Percentage]
		From
			[db-au-workspace].dbo.tmp_Pattern p
		Where 
			p.PolicyNumber = t.PolicyNumber and
			p.[DepartureState] = 'Post Departure'
	) PerDayPct

Group By
	t.PolicyNumber,
	t.TripType,
	DateName(mm, c.date),
	Month(c.Date),
	Year(c.Date)
Order By
	Year(c.Date),
	Month(c.Date)

IF OBJECT_ID('[db-au-workspace].dbo.tmp_TempPreDepartureDates') IS NOT NULL DROP TABLE [db-au-workspace].dbo.tmp_TempPreDepartureDates

--Intermediate Pre Departure temp data to calculate Pattern End index
select 
	predep1.PolicyNumber,
	predep1.TripType,
	predep1.PreDepartureMonth, 
	predep1.PreDepartureMonthNumber, 
	predep1.PreDepartureYear, 
	predep1.[Pct Value],
	Sum(predep2.[Pct Value]) [PatternEndIndex]
Into
	[db-au-workspace].dbo.tmp_TempPreDepartureDates
from
	[db-au-workspace].dbo.tmp_PreDepartureDates predep1
	inner join [db-au-workspace].dbo.tmp_PreDepartureDates predep2 
		on convert(datetime, (predep1.PreDepartureMonth + ' ' + Convert(varchar, predep1.PreDepartureYear)), 120) >= convert(datetime, (predep2.PreDepartureMonth + ' ' + Convert(varchar, predep2.PreDepartureYear)), 120) and
		predep1.PolicyNUmber = predep2.PolicyNumber
Group By 
	predep1.PolicyNumber,
	predep1.TripType,
	predep1.PreDepartureMonth, 
	predep1.PreDepartureMonthNumber,
	predep1.PreDepartureYear, 
	predep1.[Pct Value]
order By 
	predep1.PreDepartureMonthNumber


IF OBJECT_ID('[db-au-workspace].dbo.tmp_TempPostDepartureDates') IS NOT NULL DROP TABLE [db-au-workspace].dbo.tmp_TempPostDepartureDates

--Intermediate Post Departure temp data to calculate Pattern End index
select 
	postdep1.PolicyNumber,
	postdep1.TripType,
	postdep1.PostDepartureMonth, 
	postdep1.PostDepartureMonthNumber, 
	postdep1.PostDepartureYear, 
	postdep1.[Pct Value],
	Sum(postdep2.[Pct Value]) [PatternEndIndex]
Into
	[db-au-workspace].dbo.tmp_TempPostDepartureDates
from
	[db-au-workspace].dbo.tmp_PostDepartureDates postdep1
	inner join [db-au-workspace].dbo.tmp_PostDepartureDates postdep2 
		on convert(datetime, (postdep1.PostDepartureMonth + ' ' + Convert(varchar, postdep1.PostDepartureYear)), 120) >= convert(datetime, (postdep2.PostDepartureMonth + ' ' + Convert(varchar, postdep2.PostDepartureYear)), 120) and
		postdep1.PolicyNUmber = postdep2.PolicyNumber
Group By 
	postdep1.PolicyNumber,
	postdep1.TripType,
	postdep1.PostDepartureMonth, 
	postdep1.PostDepartureMonthNumber,
	postdep1.PostDepartureYear, 
	postdep1.[Pct Value]
order By 
	postdep1.PostDepartureMonthNumber


IF OBJECT_ID('[db-au-workspace].dbo.tmp_PreDeparturePatternRange') IS NOT NULL DROP TABLE [db-au-workspace].dbo.tmp_PreDeparturePatternRange

--Finding Pre Departure pattern index range for each record
select 
	tpred.PolicyNumber,
	tpred.TripType,
	tpred.PreDepartureMonth,
	tpred.PreDepartureMonthNumber,
	tpred.PreDepartureYear,
	Case
		When (tpred.PatternEndIndex - tpred.[Pct Value]) = 0 Then  0
		Else (tpred.PatternEndIndex - tpred.[Pct Value]) + 1
	End [PatternStartIndex],
	Case
		When tpred.PreDepartureMonthNUmber = Month(tt.TripStart)
			and tpred.PreDepartureYear = Year(tt.TripStart)
		Then 100
		Else PatternEndIndex
	End [PatternEndIndex]
Into
	[db-au-workspace].dbo.tmp_PreDeparturePatternRange
from 
	[db-au-workspace].dbo.tmp_TempPreDepartureDates tpred
	inner join [db-au-workspace].dbo.tmp_Temp1 tt
		on tpred.PolicyNumber = tt.PolicyNumber
order by 
	tpred.PreDepartureMonthNumber,
	tpred.PreDepartureYear

IF OBJECT_ID('[db-au-workspace].dbo.tmp_PostDeparturePatternRange') IS NOT NULL DROP TABLE [db-au-workspace].dbo.tmp_PostDeparturePatternRange

--Finding Post Departure pattern index range for each record
select 
	tpostd.PolicyNumber,
	tpostd.TripType,
	tpostd.PostDepartureMonth,
	tpostd.PostDepartureMonthNumber,
	tpostd.PostDepartureYear,
	Case
		When (tpostd.PatternEndIndex - tpostd.[Pct Value]) = 0 Then  0
		Else (tpostd.PatternEndIndex - tpostd.[Pct Value]) + 1
	End [PatternStartIndex],
	Case
		When tpostd.PostDepartureMonthNUmber = Month(tt.TripEnd)
			and tpostd.PostDepartureYear = Year(tt.TripEnd)
		Then 100
		Else PatternEndIndex
	End PatternEndIndex
Into
	[db-au-workspace].dbo.tmp_PostDeparturePatternRange
from 
	[db-au-workspace].dbo.tmp_TempPostDepartureDates tpostd
	Inner join [db-au-workspace].dbo.tmp_Temp1 tt
		on tpostd.PolicyNumber = tt.PolicyNumber
order by 
	tpostd.PostDepartureMonthNumber,
	tpostd.PostDepartureYear



--Final results combining pre and post departure data
insert [db-au-actuary].[dbo].[EarningPatternsDataSetByDay] with(tablockx)
(
	PolicyNumber,
	TripType,
	DepartureState,
	[Month],
	PatternStartIndex,
	PatternEndIndex,
	Premium
)
Select
	predp.PolicyNumber,
	predp.TripType,
	'Pre Departure' [DepartureState],
	convert(datetime, (predp.PreDepartureMonth + ' ' + convert(varchar,predp.PreDepartureYear)), 120) [Month],
	predp.PatternStartIndex,
	predp.PatternEndIndex,
	pp.[Trip Duration]
From
	[db-au-workspace].dbo.tmp_PreDeparturePatternRange predp
	Outer Apply
	(
		Select
			Sum(p.[Pattern TripDuration]) [Trip Duration]
		From
			[db-au-workspace].dbo.tmp_Pattern p
		Where
			p.PolicyNumber = predp.PolicyNumber and
			p.TripType = predp.TripType and
			p.PatternIndex >= predp.PatternStartIndex and
			p.PatternIndex <= predp.PatternEndIndex and
			p.DepartureState = 'Pre Departure'
	) pp

Union

Select
	postdp.PolicyNumber,
	postdp.TripType,
	'Post Departure' [DepartureState],
	convert(datetime, (postdp.PostDepartureMonth + ' ' + Convert(varchar, postdp.PostDepartureYear)), 120) [Month],
	postdp.PatternStartIndex,
	postdp.PatternEndIndex,
	pp.[Trip Duration]
From
	[db-au-workspace].dbo.tmp_PostDeparturePatternRange postdp
	Outer Apply
	(
		Select
			Sum(p.[Pattern TripDuration]) [Trip Duration]
		From
			[db-au-workspace].dbo.tmp_Pattern p
		Where
			p.PolicyNumber = postdp.PolicyNumber and
			p.TripType = postdp.TripType and
			p.PatternIndex >= postdp.PatternStartIndex and
			p.PatternIndex <= postdp.PatternEndIndex and
			p.DepartureState = 'Post Departure'
	) pp


--drop temp tables
drop table [db-au-workspace].dbo.tmp_Combination
drop table [db-au-workspace].dbo.tmp_Temp1
drop table [db-au-workspace].dbo.tmp_Pattern
drop table [db-au-workspace].dbo.tmp_PreDepartureDates
drop table [db-au-workspace].dbo.tmp_PostDepartureDates
drop table [db-au-workspace].dbo.tmp_TempPreDepartureDates
drop table [db-au-workspace].dbo.tmp_TempPostDepartureDates
drop table [db-au-workspace].dbo.tmp_PreDeparturePatternRange
drop table [db-au-workspace].dbo.tmp_PostDeparturePatternRange
GO
