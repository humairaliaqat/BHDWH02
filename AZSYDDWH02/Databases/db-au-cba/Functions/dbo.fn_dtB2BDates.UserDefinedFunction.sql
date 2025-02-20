USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtB2BDates]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_dtB2BDates]()
returns 
@output table 
(
  ReportingMonth varchar(20),
  ReportingYear varchar(20),
  StartDate date,
  EndDate date
)
as
begin

  declare @years table (YearRange varchar(20))
  declare @months table (MonthRange varchar(20))

  insert into @years
  select 'Current Year' YearRange
  union all
  select convert(varchar, datepart(year, dateadd(year, -1, getdate())))
  union all
  select convert(varchar, datepart(year, dateadd(year, -2, getdate())))

  insert into @months
  select 'Last Month' MonthRange
  union all
  select 'Current Month' 
  union all
  select 'January'
  union all
  select 'February'
  union all
  select 'March'
  union all
  select 'April'
  union all
  select 'May'
  union all
  select 'June'
  union all
  select 'July'
  union all
  select 'August'
  union all
  select 'September'
  union all
  select 'October'
  union all
  select 'November'
  union all
  select 'December'    

  insert into @output 
  select 
    MonthRange ReportingMonth,
    YearRange ReportingYear,
    case
      when MonthRange = 'Current Month' then convert(varchar(3), getdate(), 107)
      when MonthRange = 'Last Month' then convert(varchar(3), dateadd(month, -1, getdate()), 107)
      else left(MonthRange, 3)
    end + ' 01 ' +
    case
      when YearRange = 'Current Year' then convert(varchar, datepart(year, getdate()))
      else YearRange
    end StartDate,
    getdate() EndDate
  from 
    @months,
    @years
  
  update @output
  set EndDate = dateadd(day, -1, dateadd(month, 1, StartDate))
  
  insert into @output 
  select 
    'All' ReportingMonth,
    'All' ReportingYear,
    '2000-01-01' StartDate,
    convert(date, getdate()) EndDate
    
  insert into @output 
  select 
    'All' ReportingMonth,
    YearRange ReportingYear,
    case
      when YearRange = 'Current Year' then convert(varchar, datepart(year, getdate()))
      else YearRange
    end + '-01-01' StartDate,
    dateadd(
      day,
      -1,
      dateadd(
        year,
        1,
        case
          when YearRange = 'Current Year' then convert(varchar, datepart(year, getdate()))
          else YearRange
        end + '-01-01' 
      )
    ) EndDate
  from @years

  return
  
end

GO
