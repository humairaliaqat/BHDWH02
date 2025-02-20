USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_rpt1057]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/****************************************************************************************************/
--  Name			:	rptsp_rpt1057
--  Description		:	Claims Dashboard
--  Author			:	Yi Yang
--  Date Created	:	20190328
--  Parameters		:	@ReportingPeriod, @StartDate, @EndDate
--  Change History	:	
/****************************************************************************************************/

CREATE PROCEDURE [dbo].[rptsp_rpt1057]

AS

begin
    set nocount on
---- uncomments to debug
DECLARE @ReportingPeriod VARCHAR(30)
, @StartDate DATETIME
, @EndDate DATETIME
SELECT @ReportingPeriod =  '_User Defined'
, @StartDate = dateadd(day, 1, EOMONTH(DATEADD(day, -1, convert(date, GETDATE())), -7))		 
, @EndDate = DATEADD(day, -1, convert(date, GETDATE()))									 
-- uncomments to debug

select 
	o.SuperGroupName,
	c.ClaimNo,  
	convert(date, c.CreateDate) as ClaimRegisterDate, 
	c.FirstNilDate as ClaimFirstNilDate, 
	datediff(day, c.CreateDate, c.FirstNilDate) as CalendarDaysBetween,
	datediff(day, c.CreateDate, c.FirstNilDate) -
    (
        select
            count(d.[Date])
        from
            Calendar d
        where
            d.[Date] >= CreateDate and
            d.[Date] <  dateadd(day, 1, convert(date, FirstNilDate)) and
            (
                d.isHoliday = 1 or
                d.isWeekEnd = 1
            )
    ) [BusinessDaysBetween]

from 
	clmClaim as c
	join penOutlet as o on (o.OutletKey = c.OutletKey and o.OutletStatus = 'Current')

where 
	c.CountryKey = 'AU'
	and 
		(c.FirstNilDate between @StartDate and @EndDate
		or 
		c.FirstNilDate between dateadd(year, -1, @StartDate) and dateadd(year, -1, @EndDate)
		)
	and c.CreateDate >= '2011-01-01'
order by ClaimRegisterDate

end

GO
