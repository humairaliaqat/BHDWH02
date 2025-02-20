USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH003_ChannelSummary]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[dshsp_DSH003_ChannelSummary]
	@StartDate date = null,
	@EndDate date = null,
	@GroupCode varchar(2) = 'CB',
	@ExcludedAlpha varchar(100) = null,
	@IncludedAlpha varchar(100) = null	
as 
begin
/****************************************************************************************************/
--  Name:           DSH002 - CBA - Dashboard - Channel Summary
--  Author:         Dane Murray
--  Date Created:   20180731
--  Description:    Data by day for Quote and Policies  
--
--  Parameters:     @StartDate: if _User Defined. Format: YYYY-MM-DD eg. 2015-01-01
--					@EndDate: if_User Defined. Format: YYYY-MM-DD eg. 2015-01-01
--					@GroupCode: CB or BW
--					@ExcludedAlpha: Outlets to excluded from report, if null nothing excluded
--					@IncludedAlpha: Outlets to be included in the report, if blank everything included. Exclusions override Inclusions
--   
--  Change History: 20180523 - DM - Created 
--					20190807 - DM - Adjusted to be able to include or Exclude specific Alpha (for WDC)
--                  
/****************************************************************************************************/
	--DEBUG -- Uncomment to Debug
	--DECLARE 	
	--	@StartDate date = '20181001',
	--	@EndDate date = '20181004',
	--	@GroupCode varchar(2) = 'CB'

	SET NOCOUNT ON; 

	DECLARE @Country nvarchar(10) = 'AU';

	if object_id('tempdb..#Periods') is not null
		drop table #Periods

	if object_id('tempdb..#Outlets') is not null
		drop table #Outlets

	select *
	into #Periods
	from [db-au-cba].dbo.UDF_ReportingPeriods(@StartDate, @EndDate, DEFAULT)

	CREATE CLUSTERED INDEX [IX_Date] ON #Periods
	(
		[Date] ASC
	)

	select @ExcludedAlpha = NullIf(@ExcludedAlpha,''),
			@IncludedAlpha = NullIf(@IncludedAlpha,'')

	SELECT	o.SuperGroupName,
			o.GroupName,
			o.SubGroupName	,
			o.BDMName       ,
			o.AlphaCode     ,
			o.OutletName    ,	
			o.Channel,	
			o.OutletAlphaKey,
			o.OutletKey
    INTO #Outlets
	FROM   [db-au-cba].dbo.penOutlet o	
	join [db-au-cba].[dbo].fn_DelimitedSplit8K(@IncludedAlpha,',') s on o.AlphaCode = IsNull(s.item, o.AlphaCode)
	WHERE  o.CountryKey = @Country			
		AND o.OutletStatus = 'Current'			
		AND o.GroupCode = @GroupCode
		AND o.SubGroupName not in ('CBA NAC Base','Bankwest NAC Base')
		AND o.AlphaCode not in (
				select item
				from [db-au-cba].[dbo].fn_DelimitedSplit8K(@ExcludedAlpha,',')
				where item is not null)

	CREATE CLUSTERED INDEX [IX_OutletKey] ON #Outlets
	(
		[OutletKey] ASC	
	)
	CREATE NONCLUSTERED INDEX [IX_OutletAlphaKey] ON #Outlets
	(
		[OutletAlphaKey] ASC

	)
	INCLUDE ( 	[OutletKey],	
				AlphaCode
	) 


	if object_id('tempdb..#Results') is not null
		drop table #Results
	
	if object_id('tempdb..#PolicyData') is not null
		drop table #PolicyData
	
	if object_id('tempdb..#QuoteData') is not null
		drop table #QuoteData

	if object_id('tempdb..#RemovedPolicies') is not null
		drop table #RemovedPolicies

	select PolicyKey
	into #RemovedPolicies
	from [db-au-cba].dbo.penPolicyTransSummary
	group by PolicyKey
	having min(PostingDate) < '20181001'

	--Policy Data
	SELECT   po.OutletAlphaKey
			,C.Date
			,pppg.ProductClassification ProductDisplayName
			,pppg.SaleType ProductClassification
			,SUM(pts.BasePolicyCount)	AS PolicyCount
	INTO #PolicyData
	FROM  #Outlets po
	INNER JOIN [db-au-cba].dbo.penPolicy p						
		ON p.OutletAlphaKey = po.OutletAlphaKey
	INNER JOIN [db-au-cba].dbo.penPolicyTransSummary pts
		ON pts.PolicyKey = p.PolicyKey	
	INNER JOIN (select distinct Date from #Periods ) c		
		ON CAST(pts.PostingDate AS DATE) = c.Date	
	LEFT JOIN [db-au-cba].dbo.[vPenPolicyPlanGroups] pppg 
		ON p.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
	where P.PolicyKey not in (select PolicyKey from #RemovedPolicies)
	GROUP BY  po.OutletAlphaKey
			,C.Date
			,pppg.ProductClassification 
			,pppg.SaleType
	
	--Quote Data
	;WITH QD as (
		SELECT   po.OutletAlphaKey
				,C.Date
				,cp.ProductClassification ProductDisplayName
				,cp.SaleType ProductClassification
				,COUNT(q.QuoteID)	as QuoteCount
		FROM  #Outlets po
		INNER JOIN [db-au-cba].dbo.impQuotes q						
			ON q.OutletAlphaKey = po.OutletAlphaKey
		INNER JOIN (select distinct Date from #Periods ) c		
			ON q.QuoteDate = c.Date
		outer apply (select top 1 ProductClassification, SaleType
				from [db-au-cba].dbo.[vPenPolicyPlanGroups]	 ppg
				join [db-au-cba].dbo.cdgProduct cP on ppg.ProductCode = cP.ProductCode 
				AND CASE cP.PlanCode 
						WHEN 'DMTS' THEN 'DSM' 
						WHEN 'DMTF' THEN 'DFM' 
						ELSE cP.PlanCode END = ppg.PlanCode
				where q.quoteProductID = cP.ProductID
				AND po.OutletAlphaKey = ppg.OutletAlphaKey
				) cp
		where q.Quotedate >= '20181001'
		GROUP BY po.OutletAlphaKey
				,C.Date	
				,cp.ProductClassification 
				,cp.SaleType
		UNION ALL
		SELECT   po.OutletAlphaKey
				,C.Date
				,pppg.ProductClassification ProductDisplayName
				,pppg.SaleType ProductClassification
				,COUNT(q.QuoteID)	as QuoteCount
		FROM  #Outlets po
		INNER JOIN [db-au-cba].dbo.penQuote q						
			ON q.OutletAlphaKey = po.OutletAlphaKey
		INNER JOIN (select distinct Date from #Periods ) c		
			ON q.CreateDate = c.Date
		LEFT join [db-au-cba].dbo.[vPenPolicyPlanGroups] pppg 
			ON q.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
		where q.CreateDate >= '20181001'
		GROUP BY po.OutletAlphaKey
				,C.Date
				,pppg.ProductClassification 
				,pppg.SaleType
		)
	select   OutletAlphaKey
			,Date
			,ProductDisplayName
			,ProductClassification
			,SUM(QuoteCount) as QuoteCount
	into #QuoteData
	from QD
	GROUP By OutletAlphaKey
			,Date
			,ProductDisplayName
			,ProductClassification

	select	
		C.PeriodText,
		C.Date,
		C.PeriodStartDate,
		C.PeriodEndDate,
		C.PeriodDateNum,
		C.SortOrder,
		po.SubGroupName, 
		po.OutletName, 
		po.OutletAlphaKey,
		pppg.ProductClassification as ProductDisplayName,
		pd.PolicyCount, 
		qd.QuoteCount QuoteCount
	INTO #Results
	from #Outlets po
	cross join #Periods c
	cross apply (
		SELECT DISTINCT OutletAlphaKey,ProductClassification, SaleType from [db-au-cba].dbo.vPenPolicyPlanGroups x where po.OutletAlphaKey = x.OutletAlphaKey
		UNION ALL
		SELECT po.OutletAlphaKey, 'Unknown', 'Unknown'
		)pppg 
	LEFT JOIN #PolicyData pd 
		on po.OutletAlphaKey = pd.OutletAlphaKey 
		AND IsNull(pd.ProductClassification,'Unknown') = pppg.SaleType 
		AND IsNull(pd.ProductDisplayName,'Unknown') = pppg.ProductClassification
		AND c.Date = pd.Date
	LEFT JOIN #QuoteData qd 
		on po.OutletAlphaKey = qd.OutletAlphaKey
		and IsNull(qd.ProductClassification,'Unknown') = pppg.SaleType
		and IsNull(qd.ProductDisplayName,'Unknown') = pppg.ProductClassification
		and c.Date = qd.Date

	select 
		'Summary' as DataType,
		PeriodText,
		PeriodStartDate,
		PeriodEndDate,
		SortOrder,
		OutletAlphaKey,
		--PeriodDateNum,
		SubGroupName,
		OutletName,
		ProductDisplayName,
		SUM(PolicyCount) as PolicyCount,
		SUM(QuoteCount) as QuoteCount
	INTO #SummaryResults
	from #Results
	GROUP BY PeriodText,PeriodStartDate,PeriodEndDate, SortOrder,OutletAlphaKey, SubGroupName, OutletName, ProductDisplayName

	--select * from #SummaryResults

	insert into #SummaryResults
	select 
		'Summary' DataType,
		'Current Period Variance' as PeriodText,
		null,
		null,
		null,
		R.OutletAlphaKey,
		R.SubGroupName, 
		R.OutletName, 
		R.ProductDisplayName,
		SUM(R.PolicyCount) - SUM(R2.PolicyCount) as PolicyCount, 
		SUM(R.QuoteCount)  - SUM(R2.QuoteCount)  as QuoteCount
	from #Results R
	LEFT JOIN #Results R2 on R.PeriodDateNum = R2.PeriodDateNum AND R.OutletAlphaKey = R2.OutletAlphaKey
	where R.PeriodText = 'Current Period'
	AND R2.PeriodText = 'Last Year at Current Period'
	GROUP BY R.PeriodText, R.OutletAlphaKey, R.SubGroupName, R.OutletName, R.ProductDisplayName

	select * from #SummaryResults order by DataType, PeriodStartDate

end

GO
