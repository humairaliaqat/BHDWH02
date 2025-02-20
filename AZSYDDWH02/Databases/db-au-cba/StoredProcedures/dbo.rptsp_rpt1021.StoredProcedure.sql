USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_rpt1021]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


Create PROCEDURE [dbo].[rptsp_rpt1021]
  @ReportingPeriod VARCHAR(30)
, @StartDate DATETIME
, @EndDate DATETIME
AS

/****************************************************************************************************/
--  Name			:	rptsp_rpt1021
--  Description		:	RPT1021 - CBA Ex-Gratia Payments
--  Author			:	Yi Yang
--  Date Created	:	20180924
--  Description		:	CBA Ex-Gratia Payments
--  Parameters		:	@ReportingPeriod, @StartDate, @EndDate
--  Change History	:	20180924 - YY - new report

/****************************************************************************************************/

SET NOCOUNT ON

---- uncomments to debug
--DECLARE @ReportingPeriod VARCHAR(30)
--, @StartDate DATETIME
--, @EndDate DATETIME
--select @ReportingPeriod = '_User Defined'
--, @StartDate = '2018-07-01'
--, @EndDate = '2018-10-01'
-- uncomments to debug


--get reporting dates
DECLARE @rptStartDate DATETIME, @rptEndDate DATETIME
IF @ReportingPeriod = '_User Defined'
	SELECT @rptStartDate = @StartDate, @rptEndDate = @EndDate
ELSE
    SELECT @rptStartDate = StartDate, @rptEndDate = EndDate
    FROM [db-au-cmdwh]..vDateRange
    where DateRange = @ReportingPeriod


-- Get ex-gratia payments info where paid as "Revovery"
select 
	cn1.FirstName,
	cn1.Surname,
	cp1.ClaimNo,
	cp1.PaymentStatus,
	cp1.CreatedDate,
	cp1.PaymentAmount,
	rcvr.Payer
from 
	clmPayment cp1 
	inner join clmName cn1 on
        cn1.NameKey = cp1.PayeeKey
	cross apply
	( 
	select 
		cp.ClaimKey,
		cp.ClaimNo,
		cp.PaymentAmount,
		cp.PaymentStatus, 
		cn.Firstname + ' ' + cn.Surname as [Payer]
	from
		clmPayment cp
		inner join clmName cn on
			cn.NameKey = cp.PayeeKey
	where
   		(cn.Surname like '%gratia%' or
		cn.Firstname like '%gratia%')
		and cp.PaymentStatus = 'RECY'
	) rcvr
	where 
		rcvr.ClaimKey = cp1.ClaimKey and
		rcvr.PaymentAmount = -1 * cp1.PaymentAmount and
		cp1.CreatedDate >= @rptStartDate and 
		cp1.CreatedDate < dateadd(d,1,@rptEndDate) and
		cp1.PaymentStatus = 'PAID'

GO
