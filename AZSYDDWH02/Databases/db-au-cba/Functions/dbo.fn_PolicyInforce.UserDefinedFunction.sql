USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_PolicyInforce]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_PolicyInforce]
(
	@Country varchar(2),
	@StartDate date,
	@EndDate date
)
returns @output table
(
	MonthYear varchar(7),
	StartDate date,
	EndDate date,
	DepartReturn int,
	IssueReturn int
)
as
begin

	;with cte_dates as
	(
		select
			convert(varchar(7), c.Date, 120) MonthYear,
			min(c.Date) StartDate,
			max(c.Date) EndDate
		from Calendar c
		where c.Date between @StartDate and @EndDate
		group by   convert(varchar(7), c.Date, 120)
	)
	insert into @output
	select
		MonthYear,
		StartDate,
		EndDate,
		dbo.fn_countPolicyInforce_DepartureToReturn(@Country, StartDate, EndDate) DepRet,
		dbo.fn_countPolicyInforce_IssuedToReturn(@Country, StartDate, EndDate) IssRet
	from cte_dates


	return
	  
end

GO
