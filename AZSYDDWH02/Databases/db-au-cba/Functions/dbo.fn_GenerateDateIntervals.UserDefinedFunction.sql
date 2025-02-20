USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GenerateDateIntervals]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dane Murray
-- Create date: 20181004
-- Description:	To Generate a table for X Interval Periods between a date range
-- =============================================
CREATE FUNCTION [dbo].[fn_GenerateDateIntervals] 
(	
	@Interval int, --minutes between 1 and 60
	@StartDate Date,
	@EndDate Date
)
RETURNS @results TABLE (
	[time] datetime,
	CallDate date,
	[CallDateTimeStart] datetime,
	[CallDateTimeEnd] datetime,
	[DayofWeekNum] int,
	[DayofWeek] varchar(10)
)
AS
begin
	Declare	@start int = 0,
		@end int = 24 * (60 / @Interval) -1;

	with NumberSequence( Number ) as
	(
		Select @start as Number
			union all
		Select Number + 1
			from NumberSequence
			where Number < @end
	)
	insert into @results
	select	DateAdd(minute, number * 15, '19000101') as [time], 
			C.Date as [CallDate], 
			DateAdd(minute, number * 15, C.Date) as [CallDateTimeStart], 
			DateAdd(minute, (number +1) * 15, C.Date) as [CallDateTimeEnd], 
			datepart(dw, C.Date) as [DayofWeekNum], 
			case datepart(dw, C.Date) 
					when  1 THEN   'Sunday'
					when  2 THEN   'Monday'
					when  3 THEN   'Tuesday'
					when  4 THEN   'Wednesday'
					WHEN  5 THEN   'Thursday'
					WHEN  6 THEN   'Friday'
					WHEN  7 THEN   'Saturday'
				END  [DayofWeek]
	from Calendar c
	cross join NumberSequence s
	where c.Date between @StartDate AND @EndDate
	order by 2,1

	return
END
GO
