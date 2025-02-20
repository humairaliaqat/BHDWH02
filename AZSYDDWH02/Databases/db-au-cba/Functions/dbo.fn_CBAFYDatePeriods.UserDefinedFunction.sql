USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CBAFYDatePeriods]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fn_CBAFYDatePeriods]
(	
	@EntryDate DATETIME,
	@FFYStartMonth INT
)
RETURNS @output table
(
	[Period] varchar(10),
	[PeriodStart] date,
	[PeriodEnd] date
)
AS
BEGIN
	DECLARE	 @StartDate DATETIME
		,@EndDate DATETIME

	SET @StartDate = DATEADD(dd, 0, DATEDIFF(dd, 0, DATEADD(mm, - (((12 + DATEPART(m, @EntryDate)) - @FFYStartMonth)%12), @EntryDate) - datePart(d,DATEADD(mm, - (((12 + DATEPART(m, @EntryDate)) - @FFYStartMonth )%12),@EntryDate )) + 1 ))  
	SET @EndDate = EOMONTH(@StartDate,11)

	select @EndDate = CASE WHEN @EndDate > @EntryDate THEN @EntryDate ELSE @EndDate END

	insert into @output
	SELECT 'FYTD' as Period, @StartDate, @EndDate
	UNION ALL
	SELECT 'Quarter 4' as Period, [dbo].[fn_dtCurQuarterStart](DateAdd(month,-9,@EndDate)), [dbo].[fn_dtCurQuarterEnd](DateAdd(month,-9,@EndDate))
	UNION ALL
	SELECT 'Quarter 3' as Period, [dbo].[fn_dtCurQuarterStart](DateAdd(month,-6,@EndDate)), [dbo].[fn_dtCurQuarterEnd](DateAdd(month,-6,@EndDate))
	UNION ALL
	SELECT 'Quarter 2' as Period, [dbo].[fn_dtCurQuarterStart](DateAdd(month,-3,@EndDate)), [dbo].[fn_dtCurQuarterEnd](DateAdd(month,-3,@EndDate))
	UNION ALL
	SELECT 'Quarter 1' as Period, [dbo].[fn_dtCurQuarterStart](@EndDate), [dbo].[fn_dtCurQuarterEnd](@EndDate)

	update @output
	set PeriodEnd = @EntryDate
	where PeriodEnd > @EntryDate
	and PeriodStart <= @EntryDate

	delete from @output where PeriodStart < '2018-10-01'

	return
END
GO
