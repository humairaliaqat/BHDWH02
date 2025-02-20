USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH005_ClaimSummary_ClaimsReceived]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[dshsp_DSH005_ClaimSummary_ClaimsReceived]		
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
--  Description:    Return Claim data for certain period  
--
--  Parameters:     @SDate: Start date of period for dashboard. Format: YYYY-MM-DD eg. 2015-01-01
--					@EDate: End date of period for dashboard. Format: YYYY-MM-DD eg. 2015-01-01
--					@GroupCode: CB or BW
--					@ExcludedAlpha: Outlets to excluded from report, if null nothing excluded
--					@IncludedAlpha: Outlets to be included in the report, if blank everything included. Exclusions override Inclusions
--   
--  Change History: 20180523 - ME - Created 
--					20181015 - LL - outlet status missing
--					20190807 - DM - Adjusted to be able to include or Exclude specific Alpha (for WDC)
--                  
/****************************************************************************************************/

	--uncomment to debug
	--DECLARE 	@SDate datetime = '2018-07-01',
	--			@EDate datetime = '2019-06-30',
	--			@GroupCode varchar(2) = 'CB'

	DECLARE @Country NVARCHAR(10) = 'AU'

	DECLARE @StartDate DATE = IsNull(@SDate, DateAdd(day,1,EOMONTH(GetDate(),-1))) --(SELECT CAST(DATEADD(MM,-6,GETDATE()) AS DATE))
	DECLARE @EndDate DATE = IsNull(@EDate, DAteAdd(day,-1,GetDate()))--(SELECT CAST(GETDATE() AS DATE))

	if object_id('tempdb..#Country') is not null
		drop table #Country

	SELECT UPPER(dest.Destination) AS Destination,
		   coun.ISO2Code
	INTO #Country
	FROM
		( SELECT Destination,
			     Max(LoadID) AS LoadID
		  FROM   [db-au-cba].[dbo].[dimDestination]
		  GROUP  BY Destination) dest
	OUTER APPLY ( SELECT TOP 1 ISO2Code
				  FROM [db-au-cba].[dbo].[dimDestination]
				  WHERE LoadID = dest.LoadID
					 AND Destination = dest.Destination) Coun

	if object_id('tempdb..#Calendar') is not null
		drop table #Calendar

	SELECT CAST([Date] AS DATE) AS [Date],
		   CAST(EOMONTH([Date]) AS DATE) AS [MonthEnd]
	INTO #Calendar
	FROM [db-au-cba].[dbo].Calendar
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

	select        
		cl.ClaimKey, 
		cl.ClaimNo as [Claim Number],  
		o.OutletKey,
		o.SubGroupName,
		cld.ReceiptDate as [Received Date],
		case
			when cl.FirstNilDate is null then 0
			else 1
		end IsFinalised,
		convert(date, ce.EventDate) as [Event Date],
		loc.Destination as [Event Country],
		loc.ISO2Code,
		datediff(day,ce.EventDate,cl.ReceivedDate) as [Notification lag],
		cbb.BenefitCategory as [Benefit Category],				
		eh.FirstEstimateDate	as [First Estimate Date],
		eh.FirstEstimateValue	as [First Estimate Value],
		p.ProductDisplayName	as [Product]
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
		inner join #Calendar c on cld.ReceiptDate = c.Date
		inner join [db-au-cba].dbo.penPolicyTransaction pt on cl.PolicyTransactionKey = pt.PolicyTransactionKey
		inner join [db-au-cba].dbo.penPolicy p on pt.PolicyKey = p.PolicyKey
		inner join #outlets o on p.OutletAlphaKey = o.OutletAlphaKey
		inner join [db-au-cba].dbo.clmSection cs on cs.ClaimKey = cl.ClaimKey and cs.isDeleted = 0
		left join [db-au-cba].dbo.clmEvent ce on ce.EventKey = cs.EventKey
		left join #Country loc on loc.Destination = ce.EventCountryName
		left join [db-au-cba].[dbo].vclmBenefitCategory cbb on cbb.BenefitSectionKey = cs.BenefitSectionKey
		outer apply
		(
			select top 1
				EHCreateDate FirstEstimateDate,
				SUM(EHEstimateValue) over(partition by cs.ClaimKey, eh.EHCreateDate) FirstEstimateValue,
				EHCreatedBy FirstEstimateCreator
			from 
				[db-au-cba].dbo.clmEstimateHistory eh 
			where
				eh.SectionKey = cs.SectionKey
			order by 
				EHCreateDate
		) eh
END
		
GO
