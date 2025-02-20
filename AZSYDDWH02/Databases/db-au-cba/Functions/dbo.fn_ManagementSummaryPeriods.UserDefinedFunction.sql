USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_ManagementSummaryPeriods]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Dane Murray
-- Create date: 08-Aug-2019
-- Description:	Returns the periods used for the Management Summary reports
-- =============================================
CREATE FUNCTION [dbo].[fn_ManagementSummaryPeriods]
(	
	@Date datetime
)
RETURNS TABLE 
AS
RETURN 
(
	select
		'Last Week' as DateRange,
		StartDate = [db-au-cba].dbo.fn_dtLastWeekStart(@Date),
		EndDate = [db-au-cba].dbo.fn_dtLastWeekEnd(@Date)
	UNION
	select
		'Month-To-Date' as DateRange,
		StartDate = [db-au-cba].dbo.fn_dtMTDStart(DateAdd(day,1,@Date)),
		EndDate = [db-au-cba].dbo.fn_dtMTDEnd(DateAdd(day,1,@Date))
	UNION
	select
		'Fiscal Year-To-Date' as DateRange,
		StartDate = [db-au-cba].dbo.fn_dtYTDFiscalStart(DateAdd(day,1,@Date)),
		EndDate = [db-au-cba].dbo.fn_dtYTDFiscalEnd(DateAdd(day,1,@Date))
)
GO
