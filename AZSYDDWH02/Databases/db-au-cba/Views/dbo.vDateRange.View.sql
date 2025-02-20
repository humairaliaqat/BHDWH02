USE [db-au-cba]
GO
/****** Object:  View [dbo].[vDateRange]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[vDateRange]
as

select
  '_User Defined' as DateRange,
  StartDate = convert(datetime,'1900-01-01 00:00:00'),
  EndDate = convert(datetime,'9999-12-31 00:00:00')

union all
  
select
  'Current Fiscal Month' as DateRange,
  StartDate = dbo.fn_dtCurFiscalMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtCurFiscalMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Current Fiscal Quarter' as DateRange,
  StartDate = dbo.fn_dtCurFiscalQuarterStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtCurFiscalQuarterEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Current Fiscal Year' as DateRange,
  StartDate = dbo.fn_dtCurFiscalYearStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtCurFiscalYearEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Current Month' as DateRange,
  StartDate = dbo.fn_dtCurMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtCurMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Current Quarter' as DateRange,
  StartDate = dbo.fn_dtCurQuarterStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtCurQuarterEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Current Year' as DateRange,
  StartDate = dbo.fn_dtCurYearStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtCurYearEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'First Half Fiscal Year' as DateRange,
  StartDate = dbo.fn_dtCurFiscalYearStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastYearEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'First 15 Days of Next Month' as DateRange,
  StartDate = dbo.fn_dtFirst15DaysOfNextMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtFirst15DaysOfNextMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))
    
union  

select
  'Last 7 Days' as DateRange,
  StartDate = dbo.fn_dtLast7DaysStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast7DaysEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 14 Days' as DateRange,
  StartDate = dbo.fn_dtLast14DaysStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast14DaysEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 21 Days' as DateRange,
  StartDate = dbo.fn_dtLast21DaysStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast21DaysEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 15 Days of Month' as DateRange,
  StartDate = dbo.fn_dtLast15DaysOfMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast15DaysOfMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 15 Business Days' as DateRange,
  StartDate = dbo.fn_AddWorkDays(convert(datetime,convert(varchar(10),getdate(),120)),-15),
  EndDate = dbo.fn_AddWorkDays(convert(datetime,convert(varchar(10),getdate(),120)),-1)
  
union  

select
	'Last 2 Business Days' as DateRange,
	StartDate = dbo.fn_AddWorkDays(convert(datetime,convert(varchar(10),getdate(),120)),-2),
	EndDate = dbo.fn_AddWorkDays(convert(datetime,convert(varchar(10),getdate(),120)),-2)

union

select
	'Last 2 Days to Yesterday' as DateRange,
	StartDate = convert(datetime,convert(varchar(10),dateadd(day,-2,getdate()),120)),
	EndDate = convert(datetime,convert(varchar(10),dateadd(day,-1,getdate()),120))
	
union

select
  'Last 30 Days' as DateRange,
  StartDate = dbo.fn_dtLast30DaysStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast30DaysEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 30 Business Days' as DateRange,
  StartDate = dbo.fn_AddWorkDays(convert(datetime,convert(varchar(10),getdate(),120)),-30),
  EndDate = convert(datetime,convert(varchar(10),dateadd(d,0,getdate()),120))
  
union


select
  'Last Friday-To-Sunday' as DateRange,
  StartDate = dbo.fn_dtLastFriToSunStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastFriToSunEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Friday-To-Now' as DateRange,
  StartDate = dbo.fn_dtLastFriToSunStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = convert(datetime, convert(varchar(10),getdate(),120))

union

select
  'Last Saturday-To-Friday' as DateRange,
  StartDate = dbo.fn_dtLastSatToFriStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastSatToFriEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
	'Last Thursday-To-Wednesday' as DateRange,
	StartDate = [dbo].[fn_dtLastThuToWedStart](convert(datetime,convert(varchar(10),getdate(),120))),
	EndDate = [dbo].[fn_dtLastThuToWedEnd](convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Fiscal Month' as DateRange,
  StartDate = dbo.fn_dtLastFiscalMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastFiscalMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Fiscal Month-To-Date' as DateRange,
  StartDate = dbo.fn_dtLastFiscalMTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastFiscalMTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union 

select
  'Last Fiscal Quarter' as DateRange,
  StartDate = dbo.fn_dtLastFiscalQuarterStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastFiscalQuarterEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Fiscal Year' as DateRange,
  StartDate = dbo.fn_dtLastFiscalYearStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastFiscalYearEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Month' as DateRange,
  StartDate = dbo.fn_dtLastMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Quarter' as DateRange,
  StartDate = dbo.fn_dtLastQuarterStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastQuarterEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Week' as DateRange,
  StartDate = dbo.fn_dtLastWeekStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastWeekEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Year' as DateRange,
  StartDate = dbo.fn_dtLastYearStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastYearEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Year Current Fiscal Month' as DateRange,
  StartDate = dbo.fn_dtLYCurFiscalMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLYCurFiscalMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Year Current Month' as DateRange,
  StartDate = dbo.fn_dtLYCurMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLYCurMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Year Fiscal Year-To-Date' as DateRange,
  StartDate = dbo.fn_dtLYFiscalYTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLYFiscalYTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Year Year-To-Date' as DateRange,
  StartDate = dbo.fn_dtLYYTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLYYTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Year Month-To-Date' as DateRange,
  StartDate = dbo.fn_dtLYMTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLYMTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Year Quarter-To-Date' as DateRange,
  StartDate = dbo.fn_dtLYQTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLYQTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Year Quarter' as DateRange,
  StartDate = dbo.fn_dtLYQuarterStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLYQuarterEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Year Week' as DateRange,
  StartDate = dbo.fn_dtLYWeekStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLYWeekEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last Year Last Week' as DateRange,
  StartDate = dbo.fn_dtLYLastWeekStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLYLastWeekEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union 

select
  'Last Year Last Month' as DateRange,
  StartDate = dbo.fn_dtLYLastMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLYLastMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last January' as DateRange,
  StartDate = dbo.fn_dtLastJanStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastJanEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last February' as DateRange,
  StartDate = dbo.fn_dtLastFebStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastFebEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last March' as DateRange,
  StartDate = dbo.fn_dtLastMarStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastMarEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last April' as DateRange,
  StartDate = dbo.fn_dtLastAprStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastAprEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last May' as DateRange,
  StartDate = dbo.fn_dtLastMayStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastMayEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last June' as DateRange,
  StartDate = dbo.fn_dtLastJunStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastJunEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last July' as DateRange,
  StartDate = dbo.fn_dtLastJulStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastJulEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last August' as DateRange,
  StartDate = dbo.fn_dtLastAugStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastAugEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last September' as DateRange,
  StartDate = dbo.fn_dtLastSepStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastSepEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last October' as DateRange,
  StartDate = dbo.fn_dtLastOctStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastOctEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last November' as DateRange,
  StartDate = dbo.fn_dtLastNovStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastNovEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last December' as DateRange,
  StartDate = dbo.fn_dtLastDecStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastDecEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last Weekend' as DateRange,
  StartDate = dbo.fn_dtLastWeekendStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastWeekendEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Week-To-Date' as DateRange,
  StartDate = dbo.fn_dtWTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtWTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Month-To-Date' as DateRange,
  StartDate = dbo.fn_dtMTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtMTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Month-To-Now' as DateRange,
  StartDate = dbo.fn_dtMTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = convert(datetime,convert(varchar(10),getdate(),120))

union

select
  'Quarter-To-Date' as DateRange,
  StartDate = dbo.fn_dtQTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtQTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Year-To-Date' as DateRange,
  StartDate = dbo.fn_dtYTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtYTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Fiscal Year-To-Date' as DateRange,
  StartDate = dbo.fn_dtYTDFiscalStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtYTDFiscalEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'FYTD To Last Month' as DateRange,
  StartDate = dbo.fn_dtYTDFiscalStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last FYTD To Last Month' as DateRange,
  StartDate = [dbo].[fn_dtLYFiscalYTDStart](convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = [dbo].[fn_dtLYLastMonthEnd](convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Next Week' as DateRange,
  StartDate = dbo.fn_dtNextWeekStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtNextWeekEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Next Month' as DateRange,
  StartDate = dbo.fn_dtNextMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtNextMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union


select
  'Next Quarter' as DateRange,
  StartDate = dbo.fn_dtNextQuarterStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtNextQuarterEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Next Year' as DateRange,
  StartDate = dbo.fn_dtNextYearStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtNextYearEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Next Fiscal Year' as DateRange,
  StartDate = dbo.fn_dtNextFiscalYearStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtNextFiscalYearEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Next 7 Days' as DateRange,
  StartDate = dbo.fn_dtNext7DaysStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtNext7DaysEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Next 14 Days' as DateRange,
  StartDate = dbo.fn_dtNext14DaysStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtNext14DaysEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Next 15 Business Days' as DateRange,
  StartDate = convert(datetime,convert(varchar(10),dateadd(d,1,getdate()),120)),
  EndDate = dbo.fn_AddWorkDays(convert(datetime,convert(varchar(10),getdate(),120)),15)
  
union

select
  'Next 30 Days' as DateRange,
  StartDate = dbo.fn_dtNext30DaysStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtNext30DaysEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Next 30 Business Days' as DateRange,
  StartDate = convert(datetime,convert(varchar(10),dateadd(d,1,getdate()),120)),
  EndDate = dbo.fn_AddWorkDays(convert(datetime,convert(varchar(10),getdate(),120)),30)
  
union  

select
  'Today' as DateRange,
  StartDate = convert(datetime,convert(varchar(10),getdate(),120)),
  EndDate = convert(datetime,convert(varchar(10),getdate(),120))

union

select
  'Yesterday' as DateRange,
  StartDate = convert(datetime,convert(varchar(10),dateadd(d,-1,getdate()),120)),
  EndDate = convert(datetime,convert(varchar(10),dateadd(d,-1,getdate()),120))

union

select
  'Yesterday-To-Now' as DateRange,
  StartDate = convert(datetime,convert(varchar(10),dateadd(d,-1,getdate()),120)),
  EndDate = convert(datetime, convert(varchar(10),getdate(),120))
  
union
  
select
  'Tomorrow' as DateRange,
  StartDate = convert(datetime,convert(varchar(10),dateadd(d,1,getdate()),120)),
  EndDate = convert(datetime,convert(varchar(10),dateadd(d,1,getdate()),120))    

union

select
  'FYTD From Last November' as DateRange,
  StartDate = dbo.fn_dtLastNovStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = convert(datetime,convert(varchar(10),dateadd(d,-1,getdate()),120))

union

select
  'Last 30-15 Business Days' as DateRange,
  StartDate = dbo.fn_AddWorkDays(convert(datetime,convert(varchar(10),getdate(),120)),-30),
  EndDate = dbo.fn_AddWorkDays(convert(datetime,convert(varchar(10),getdate(),120)),-15)

union

select
  'Last 1 Year' as DateRange,
  StartDate = convert(datetime,convert(varchar(10),dateadd(year,-1,getdate()),120)),
  EndDate = convert(datetime,convert(varchar(10),dateadd(day,-1,getdate()),120))

union

select
  'Last 2 Year' as DateRange,
  StartDate = dbo.fn_dtLast2YearStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast2YearEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 2 Year Current FMonth' as DateRange,
  StartDate = dbo.fn_dtL2YCurFiscalMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtL2YCurFiscalMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 2 Year Current Month' as DateRange,
  StartDate = dbo.fn_dtL2YCurMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtL2YCurMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 2 Year Fiscal YTD' as DateRange,
  StartDate = dbo.fn_dtL2YFiscalYTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtL2YFiscalYTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 2 Year Year-To-Date' as DateRange,
  StartDate = dbo.fn_dtL2YYTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtL2YYTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 2 Year Month-To-Date' as DateRange,
  StartDate = dbo.fn_dtL2YMTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtL2YMTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 2 Year Quarter-To-Date' as DateRange,
  StartDate = dbo.fn_dtL2YQTDStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtL2YQTDEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 2 Year Quarter' as DateRange,
  StartDate = dbo.fn_dtL2YQuarterStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtL2YQuarterEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 2 Year Week' as DateRange,
  StartDate = dbo.fn_dtL2YWeekStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtL2YWeekEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 2 Year Last Week' as DateRange,
  StartDate = dbo.fn_dtL2YLastWeekStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtL2YLastWeekEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union 

select
  'Last 2 Year Last Month' as DateRange,
  StartDate = dbo.fn_dtL2YLastMonthStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtL2YLastMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 2 Fiscal Year' as DateRange,
  StartDate = dbo.fn_dtLast2FiscalYearStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast2FiscalYearEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union

select
  'Last 3 Month To Date' as DateRange,
  StartDate = dbo.fn_dtLast3MonthToDateStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast3MonthToDateEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 12 Months' as DateRange,
  StartDate = convert(datetime, convert(varchar(7), dateadd(month, -12, getdate()), 120) + '-01'),
  EndDate = dateadd(day, -1, convert(varchar(7), getdate(), 120) + '-01')

union

select
  'Last 6 Months' as DateRange,
  StartDate = dbo.fn_dtLast6MonthsStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast6MonthsEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Last 2 Months' as DateRange,
  StartDate = dbo.fn_dtLast2MonthsStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast2MonthsEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union


select
  'Last 3 Months' as DateRange,
  StartDate = dbo.fn_dtLast3MonthsStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast3MonthsEnd(convert(datetime,convert(varchar(10),getdate(),120)))
  
union
  
select
  'Last 3 Fiscal Year' as DateRange,
  StartDate = dbo.fn_dtLast3FiscalYearStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast3FiscalYearEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Date -3 weeks' as DateRange,
  StartDate = dateadd(week, -3, convert(varchar(10), getdate(), 120)),
  EndDate = dateadd(week, -3, convert(varchar(10), getdate(), 120))

union

select
  'Date +4 weeks' as DateRange,
  StartDate = dateadd(week, 4, convert(varchar(10), getdate(), 120)),
  EndDate = dateadd(week, 4, convert(varchar(10), getdate(), 120))

union

select
  'Date +6 weeks' as DateRange,
  StartDate = dateadd(week, 6, convert(varchar(10), getdate(), 120)),
  EndDate = dateadd(week, 6, convert(varchar(10), getdate(), 120))

union

select
  'Date +10 days' as DateRange,
  StartDate = dateadd(day,10,convert(varchar(10),getdate(),120)),
  EndDate = dateadd(day,10,convert(varchar(10),getdate(),120))
  
union

select
  'Next 3 Months' as DateRange,
  StartDate = dbo.fn_dtNext3MonthsStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtNext3MonthsEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Next 2 Months' as DateRange,
  StartDate = dbo.fn_dtNext2MonthsStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtNext2MonthsEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union 

select
  'Last 2 Months To Date' as DateRange,
  StartDate = dbo.fn_dtLast2MonthToDateStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLast2MonthToDateEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'GLA AU Start to Yesterday' as DateRange,
  StartDate = convert(datetime,'2009-07-01 00:00:00'),
  EndDate = convert(datetime,convert(varchar(10),dateadd(d,-1,getdate()),120))

union

select
  'ZURICH AU Start to Yesterday' as DateRange,
  StartDate = convert(datetime,'2017-06-01 00:00:00'),
  EndDate = convert(datetime,convert(varchar(10),dateadd(d,-1,getdate()),120))

union

select
  'Date +30 days' as DateRange,
  StartDate = dateadd(day,30,convert(varchar(10),getdate(),120)),
  EndDate = dateadd(day,30,convert(varchar(10),getdate(),120))

union

--Added to cater RPT0857 report schedule to run for last 3 months start to last month end
select
  'Last 3 Months to Last Month' as DateRange,
  StartDate = dbo.fn_dtLast3MonthsStart(convert(datetime,convert(varchar(10),getdate(),120))),
  EndDate = dbo.fn_dtLastMonthEnd(convert(datetime,convert(varchar(10),getdate(),120)))

union

select
  'Date +14 days' as DateRange,
  StartDate = dateadd(day,14,convert(varchar(10),getdate(),120)),
  EndDate = dateadd(day,14,convert(varchar(10),getdate(),120))


union

select
	'Last Hour' as DateRange,
	StartDate = convert(datetime,convert(varchar(14),dateadd(hour,-1,getdate()),120)+'00:00'),
	EndDate = convert(datetime,convert(varchar(14),dateadd(hour,0,getdate()),120)+'00:00')
	
	union

select
	'Last Hour and Current Hour' as DateRange,
	StartDate = convert(datetime,convert(varchar(14),dateadd(hour,-1,getdate()),120)+'00:00'),
	EndDate = convert(datetime,convert(varchar(14),dateadd(hour,1,getdate()),120)+'00:00')


GO
