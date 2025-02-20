USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH005_ClaimSummary_ClaimsFinalised]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[dshsp_DSH005_ClaimSummary_ClaimsFinalised]		
	@SDate date = null,
	@EDate date = null,
	@GroupCode varchar(2) = 'CB',
	@ExcludedAlpha varchar(100) = null,
	@IncludedAlpha varchar(100) = null	
as
BEGIN
	SET NOCOUNT ON									
/****************************************************************************************************/
--  Name:           CBA_ClaimSummary
--  Author:         ME
--  Date Created:   20180821
--  Description:    Return Finalised Claim data for certain period  
--
--  Parameters:     @SDate: Start date of period for dashboard. Format: YYYY-MM-DD eg. 2015-01-01
--					@EDate: End date of period for dashboard. Format: YYYY-MM-DD eg. 2015-01-01
--					@GroupCode: CB or BW
--					@ExcludedAlpha: Outlets to excluded from report, if null nothing excluded
--					@IncludedAlpha: Outlets to be included in the report, if blank everything included. Exclusions override Inclusions
--   
--  Change History: 20180523 - ME - Created 
--					20190807 - DM - Adjusted to be able to include or Exclude specific Alpha (for WDC)
--                  
/****************************************************************************************************/

--uncomment to debug
	--DECLARE 	@SDate datetime = '2019-08-01',
	--			@EDate datetime = '2019-08-18',
	--			@GroupCode varchar(2) = 'CB',
	--			@ExcludedAlpha varchar(100) = 'CBA0120,CBA0050,CBN0006',
	--			@IncludedAlpha varchar(100) = null	

	DECLARE @Country NVARCHAR(10) = 'AU'

	DECLARE @StartDate DATE = IsNull(@SDate, DateAdd(day,1,EOMONTH(GetDate(),-1))) --(SELECT CAST(DATEADD(MM,-6,GETDATE()) AS DATE))
	DECLARE @EndDate DATE = IsNull(@EDate, DateAdd(day,-1,GetDate()))--(SELECT CAST(GETDATE() AS DATE))
	print @StartDate
	print @EndDate

	select  @ExcludedAlpha = NullIf(@ExcludedAlpha,''),
			@IncludedAlpha = NullIf(@IncludedAlpha,'')

	if object_id('tempdb..#Country') is not null
		drop table #Country

	SELECT UPPER(dest.Destination) AS Destination,
			Coun.ABSArea,
		   coun.ISO2Code
	INTO #Country
	FROM
		( SELECT Destination,
			     Max(LoadID) AS LoadID
		  FROM   [db-au-cba].[dbo].[dimDestination]
		  GROUP  BY Destination) dest
	OUTER APPLY ( SELECT TOP 1 ISO2Code, IsNull(ABSArea,'UNKNOWN') ABSArea
				  FROM [db-au-cba].[dbo].[dimDestination]
				  WHERE LoadID = dest.LoadID
					 AND Destination = dest.Destination) Coun

	if object_id('tempdb..#Calendar') is not null
		drop table #Calendar

	SELECT CAST([Date] AS DATE) AS [Date],
		   CAST(EOMONTH([Date]) AS DATE) AS [MonthEnd]
	INTO #Calendar
	FROM [db-au-cba].dbo.Calendar
	WHERE [Date] BETWEEN @StartDate AND @EndDate

	CREATE CLUSTERED INDEX [IX_Date] ON #Calendar
	(
		[Date] ASC
	)

	if object_id('tempdb..#outlets') is not null
		drop table #outlets

	select o.OutletAlphaKey,	
		   o.AlphaCode,
		   o.OutletName,
		   o.OutletKey,
		   o.SubGroupName
	into #outlets	   
	from [db-au-cba].[dbo].penOutlet o
	join [db-au-cba].[dbo].fn_DelimitedSplit8K(@IncludedAlpha,',') s on o.AlphaCode = IsNull(s.item, o.AlphaCode)
	where 
		o.GroupCode = @GroupCode
	AND o.countryKey = @Country
	AND o.OutletStatus = 'Current'
	AND o.AlphaCode not in (
			select item
			from [db-au-cba].[dbo].fn_DelimitedSplit8K(@ExcludedAlpha,',')
			where item is not null)
	
	;with
	Results as
	(
		select        
			cl.ClaimKey, 
			cl.ClaimNo as [Claim Number],  
			cl.OutletKey,
			cld.ReceiptDate as [Received Date],
			case
				when cl.FirstNilDate is null then 0
				else 1
			end IsFinalised,
			convert(date, ce.EventDate) as [Event Date],
			IsNull(loc.Destination, 'UNKNOWN') as [Event Country],
			IsNull(loc.ABSArea, 'UNKNOWN') as [Event Area],
			loc.ISO2Code,
			datediff(day,ce.EventDate,cld.ReceiptDate) as [Notification lag],
			cbb.BenefitCategory as [Benefit Category],
			ci.Paid as [Paid Recovered Payment],
			ci.IncurredValue as [Claim Value],
			cl.FirstNilDate	as [First Nil Date],
			cl.FinalisedDate as [Finalised Date],
			ca.AssessmentOutcome as [Assessment Outcome],
			datediff(day,cld.ReceiptDate,cl.FinalisedDate)	as [Claim Finalised Age],
			CASE 
				WHEN datediff(day,cld.ReceiptDate,cl.FinalisedDate) <= 10 THEN CAST(datediff(day,cld.ReceiptDate,cl.FinalisedDate) as varchar)
				WHEN datediff(day,cld.ReceiptDate,cl.FinalisedDate) BETWEEN 11 AND 15 THEN '11 - 15'
				WHEN datediff(day,cld.ReceiptDate,cl.FinalisedDate) BETWEEN 16 AND 20 THEN '16 - 20'
				WHEN datediff(day,cld.ReceiptDate,cl.FinalisedDate) BETWEEN 21 AND 30 THEN '21 - 30'
				WHEN datediff(day,cld.ReceiptDate,cl.FinalisedDate) BETWEEN 31 AND 40 THEN '31 - 40'
				WHEN datediff(day,cld.ReceiptDate,cl.FinalisedDate) BETWEEN 41 AND 50 THEN '41 - 50'
				WHEN datediff(day,cld.ReceiptDate,cl.FinalisedDate) BETWEEN 51 AND 60 THEN '51 - 60'
				WHEN datediff(day,cld.ReceiptDate,cl.FinalisedDate) BETWEEN 61 AND 70 THEN '61 - 70'
				WHEN datediff(day,cld.ReceiptDate,cl.FinalisedDate) BETWEEN 71 AND 80 THEN '71 - 80'
				WHEN datediff(day,cld.ReceiptDate,cl.FinalisedDate) BETWEEN 81 AND 90 THEN '81 - 90'
				WHEN datediff(day,cld.ReceiptDate,cl.FinalisedDate) >= 91 THEN '91+'
			END as [Claim Finalised Age Band],
			datediff(day,cld.ReceiptDate,cl.FirstNilDate) as [Claim First Nil Age],
			p.ProductDisplayName	as [Product],
			o.SubGroupName
		from 
			[db-au-cba].dbo.clmClaim cl
			cross apply
			(
				select
					CAST(case
						when cl.ReceivedDate is null then cl.CreateDate
						when cl.ReceivedDate > dateadd(day, 1, convert(date, cl.CreateDate)) then cl.CreateDate
						else cl.ReceivedDate
					end as Date) ReceiptDate
			) cld
			inner join #Calendar c on
				CAST(cl.FirstNilDate as date) = c.Date
			inner join [db-au-cba].[dbo].penPolicyTransaction pt on cl.PolicyTransactionKey = pt.PolicyTransactionKey
			inner join [db-au-cba].[dbo].penPolicy p on pt.PolicyKey = p.PolicyKey
			inner join #outlets o on p.OutletAlphaKey = o.OutletAlphaKey
			inner join [db-au-cba].dbo.vClaimAssessmentOutcome ca on
				ca.ClaimKey = cl.ClaimKey
			inner join [db-au-cba].dbo.clmSection cs on
				cs.ClaimKey = cl.ClaimKey
				and 
				cs.isDeleted = 0
			left join [db-au-cba].dbo.clmEvent ce on
				ce.EventKey = cs.EventKey
			left join #Country loc	on
				loc.Destination = ce.EventCountryName
			left join [db-au-cba]..vclmBenefitCategory cbb on
				cbb.BenefitSectionKey = cs.BenefitSectionKey
			outer apply (
				select TOP 1 IncurredValue,  Paid Paid
				from [db-au-cba].dbo.vclmClaimSectionIncurred ci 
				where ci.SectionKey = cs.SectionKey
				AND ci.IncurredDate <= @EDate
				ORDER BY ci.IncurredDate desc
			) ci
	),
	ClaimResults as 
	(
		select ClaimKey, SubGroupName, SUM([Claim Value]) as ClaimValue
		from Results
		group by ClaimKey, SubGroupName
	),
	Quartiles AS
	(
		SELECT distinct SubGroupName,
		Percentile_Cont(0.25) WITHIN GROUP(Order By ClaimValue) OVER(PARTITION BY SubGroupName) As Q1,
		Percentile_Cont(0.50) WITHIN GROUP(Order By ClaimValue) OVER(PARTITION BY SubGroupName) As Median,
		Percentile_Cont(0.75) WITHIN GROUP(Order By ClaimValue) OVER(PARTITION BY SubGroupName) As Q3,
		Max(ClaimValue) OVER (PARTITION BY SubGroupName) as Maximum,
		Min(ClaimValue) OVER (PARTITION BY SubGroupName) as Minimum,
		Avg(ClaimValue) OVER (PARTITION BY SubGroupName) as Average
		FROM ClaimResults
		where ClaimValue > 1
	),
	IQR AS
	(
		SELECT *,(Q3-Q1) as IQR
		FROM Quartiles
	)
	SELECT 
		r.*, 
		Q.Q1,
		Q.Median,
		Q.Q3,
		Q.Minimum,
		Q.Maximum,
		Q.Average,
		Q.IQR
	from Results r
	LEFT JOIN IQR Q on r.SubGroupName = q.SubGroupName
END
GO
