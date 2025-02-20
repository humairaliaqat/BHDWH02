USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GenerateDates]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_GenerateDates]
(
  @StartDate date,
  @EndDate date
)
returns @output table ([Date] date)
as
begin

/*
  -- recursive cte limited to 100 iteration .. boooo
  ;with cte_dates as
  (
    select @StartDate [Date]
    union all
    select dateadd(day, 1, [Date])
    from cte_dates
    where [Date] < @EndDate
  )
  insert into @output
  select [Date]
  from cte_dates
*/

  while @StartDate <= @EndDate
  begin
    insert into @output values (@StartDate)
    
    set @StartDate = dateadd(day, 1, @StartDate)
    
  end
  
  return 
  
end

GO
