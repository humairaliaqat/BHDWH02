USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH004_SalesPerformance_Detail_test]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[dshsp_DSH004_SalesPerformance_Detail_test]
	@Date date = null,		
	@GroupCode varchar(2) = 'CB',
	@ExcludedAlpha varchar(100) = null,
	@IncludedAlpha varchar(100) = null							
as
BEGIN
SET NOCOUNT ON

										
/****************************************************************************************************/
--  Name:           CBA_SalesPerformance
--  Author:         ME
--  Date Created:   20180827
--  Description:    Return Sales data for certain period  
--
--  Parameters:     @Date: EOM Date to for monthly calculations
--					@GroupCode: CB or BW
--					@ExcludedAlpha: Outlets to excluded from report, if null nothing excluded
--					@IncludedAlpha: Outlets to be included in the report, if blank everything included. Exclusions override Inclusions
--   
--  Change History: 20180827 - ME - Created
--					20190807 - DM - Adjusted to be able to include or Exclude specific Alpha (for WDC) 
--                  
/****************************************************************************************************/

--uncomment to debug

	DECLARE @Country NVARCHAR(10) = 'AU'

	set @Date = IsNull(@Date, GetDate()-1)

	DECLARE @StartDate DATE = DateAdd(day, 1, EOMonth(@Date, -1)) 
	DECLARE @EndDate DATE = IsNull(@Date, GetDate()-1)

	select @StartDate = CASE WHEN @StartDate <= '20181001' THEN '20181001' ELSE @StartDate END
	select  @ExcludedAlpha = NullIf(@ExcludedAlpha,''),
			@IncludedAlpha = NullIf(@IncludedAlpha,'')

	SELECT CAST([Date] AS DATE) AS [Date],		  		   
		   isWeekDay,
		   isHoliday,
		   isWeekEnd,
		   CAST(EOMONTH([Date]) AS DATE) AS [MonthEnd]
	INTO #Calendar
	FROM [db-au-cba].dbo.Calendar
	WHERE [Date] BETWEEN @StartDate AND @EndDate

	CREATE CLUSTERED INDEX [IX_Date] ON #Calendar
	(
		[Date] ASC
	)

	SELECT	o.SuperGroupName	as [Super Group],
			o.GroupName	as [Group],
			o.SubGroupName	as [Sub Group],
			o.BDMName       AS BDM,
			o.AlphaCode     AS [Alpha Code],
			o.OutletName    AS [Outlet Name],	
			o.Channel,	
			o.OutletAlphaKey,
			o.OutletKey,
			o.SubGroupName
    INTO #Outlets
	FROM   [db-au-cba].dbo.penOutlet o	
	join [db-au-cba].[dbo].fn_DelimitedSplit8K(@IncludedAlpha,',') s on o.AlphaCode = IsNull(s.item, o.AlphaCode)
	WHERE  o.CountryKey = @Country			
		AND o.OutletStatus = 'Current'			
		AND o.GroupCode = @GroupCode
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
				[Alpha Code]
	) 

	select PolicyKey
	into #RemovedPolicies
	from [db-au-cba].dbo.penPolicyTransSummary
	where outletalphakey='AU-CM7-CBA0010'
	group by PolicyKey
	having min(postingdate) < '20181001'

	SELECT   po.OutletKey
			,c.Date
			,po.[Outlet Name]
			,po.[Alpha Code]			
			,c.isWeekDay
			,c.isWeekEnd
			,c.isHoliday
			,po.SubGroupName
			,pppg.ProductClassification as ProductDisplayName
			,pppg.SaleType ProductClassification
			,SUM(pts.NewPolicyCount)	AS PolicyCount	
			,SUM(pts.GrossPremium)	AS SellPrice	
			,SUM(pts.Commission)	AS Commission
			,SUM(pts.BasePremium)	AS BasePremimum
	INTO #CY
	FROM  #Outlets po
	INNER JOIN [db-au-cba].dbo.penPolicy p						
		ON p.OutletAlphaKey = po.OutletAlphaKey
	INNER JOIN [db-au-cba].dbo.penPolicyTransSummary pts
		ON pts.PolicyKey = p.PolicyKey	
	INNER JOIN #Calendar c		
		ON CAST(pts.PostingDate AS DATE) = c.Date	
	inner JOIN [db-au-cba].dbo.[vPenPolicyPlanGroups] pppg 
		ON p.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
	where P.PolicyKey not in (select PolicyKey from #RemovedPolicies)
	GROUP BY po.[Outlet Name]
			,po.[Alpha Code]
			,po.OutletKey
			,c.Date
			,c.isWeekDay
			,c.isWeekEnd
			,c.isHoliday
			,po.SubGroupName
			,p.PlanDisplayName
			,p.ProductDisplayName
			,pppg.ProductClassification
			,pppg.SaleType

	CREATE CLUSTERED INDEX [IX_Date] ON #CY
	(
		[Date] ASC
	)
	CREATE NONCLUSTERED INDEX [IX_OutletKey] ON #CY
	(
		[OutletKey] ASC

	)
	INCLUDE ( 		
				[Alpha Code]				
	) 

	SELECT   po.OutletKey
			,c.Date
			,po.[Outlet Name]
			,po.[Alpha Code]			
			,c.isWeekDay
			,c.isWeekEnd
			,c.isHoliday
			,po.SubGroupName
			,pppg.ProductClassification as ProductDisplayName
			,pppg.SaleType ProductClassification
			,SUM(pts.NewPolicyCount)	AS PolicyCount	
			,SUM(pts.GrossPremium)	AS SellPrice	
			,SUM(pts.Commission)	AS Commission
			,SUM(pts.BasePremium)	AS BasePremimum
	INTO #PY
	FROM  #Outlets po
	INNER JOIN [db-au-cba].dbo.penPolicy p						
		ON p.OutletAlphaKey = po.OutletAlphaKey
	INNER JOIN [db-au-cba].dbo.penPolicyTransSummary pts
		ON pts.PolicyKey = p.PolicyKey	
	INNER JOIN #Calendar c		
		ON CAST(pts.YAGOPostingDate AS DATE) = c.Date	
	inner JOIN [db-au-cba].dbo.[vPenPolicyPlanGroups] pppg 
		ON p.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
	where P.PolicyKey not in (select PolicyKey from #RemovedPolicies)
	GROUP BY po.[Outlet Name]
			,po.[Alpha Code]
			,po.OutletKey
			,c.Date
			,c.isWeekDay
			,c.isWeekEnd
			,c.isHoliday
			,po.SubGroupName
			,p.PlanDisplayName
			,p.ProductDisplayName
			,pppg.ProductClassification
			,pppg.SaleType

	CREATE CLUSTERED INDEX [IX_Date] ON #PY
	(
		[Date] ASC
	)
	CREATE NONCLUSTERED INDEX [IX_OutletKey] ON #PY
	(
		[OutletKey] ASC

	)
	INCLUDE ( 		
				[Alpha Code]				
	) 

	SELECT   po.OutletKey
			,c.Date
			,po.[Outlet Name]
			,po.[Alpha Code]			
			,c.isWeekDay
			,c.isWeekEnd
			,c.isHoliday
			,po.SubGroupName
			,cp.ProductClassification ProductDisplayName
			,'Whitelabel' ProductClassification
			,COUNT(q.QuoteID)	as QuoteCount
	INTO #CYQ
	FROM  #Outlets po
	INNER JOIN [db-au-cba].dbo.impQuotes q						
		ON q.OutletAlphaKey = po.OutletAlphaKey
	INNER JOIN #Calendar c		
		ON q.QuoteDate = c.Date	
	cross apply (select top 1 ProductClassification
			from [db-au-cba].dbo.[vPenPolicyPlanGroups]	 ppg
			join [db-au-cba].dbo.cdgProduct cP on ppg.ProductCode = cP.ProductCode 
			AND CASE cP.PlanCode 
					WHEN 'DMTS' THEN 'DSM' 
					WHEN 'DMTF' THEN 'DFM' 
					ELSE cP.PlanCode END = ppg.PlanCode
			where q.quoteProductID = cP.ProductID
			AND po.OutletAlphaKey = ppg.OutletAlphaKey
			) cp
	where po.SubGroupName = 'CBA Whitelabel'
	GROUP BY po.OutletKey
			,c.Date
			,po.[Outlet Name]
			,po.[Alpha Code]			
			,c.isWeekDay
			,c.isWeekEnd
			,c.isHoliday	
			,po.SubGroupName
			,cp.ProductClassification 
	
	CREATE CLUSTERED INDEX [IX_Date] ON #CYQ
	(
		[Date] ASC
	)
	CREATE NONCLUSTERED INDEX [IX_OutletKey] ON #CYQ
	(
		[OutletKey] ASC

	)
	INCLUDE ( 		
				[Alpha Code]				
	) 

	SELECT   po.OutletKey
			,c.Date
			,po.[Outlet Name]
			,po.[Alpha Code]			
			,c.isWeekDay
			,c.isWeekEnd
			,c.isHoliday
			,po.SubGroupName
			,cp.ProductClassification ProductDisplayName
			,'Whitelabel' ProductClassification
			,COUNT(q.QuoteID)	as QuoteCount
	INTO #PYQ
	FROM  #Outlets po
	INNER JOIN [db-au-cba].dbo.impQuotes q						
		ON q.OutletAlphaKey = po.OutletAlphaKey
	INNER JOIN #Calendar c		
		ON q.YAGOQuoteDate  = c.Date
	cross apply (select top 1 ProductClassification
			from [db-au-cba].dbo.[vPenPolicyPlanGroups]	 ppg
			join [db-au-cba].dbo.cdgProduct cP on ppg.ProductCode = cP.ProductCode 
			AND CASE cP.PlanCode 
					WHEN 'DMTS' THEN 'DSM' 
					WHEN 'DMTF' THEN 'DFM' 
					ELSE cP.PlanCode END = ppg.PlanCode
			where q.quoteProductID = cP.ProductID
			AND po.OutletAlphaKey = ppg.OutletAlphaKey
			) cp
	where po.SubGroupName = 'CBA Whitelabel'
	GROUP BY po.OutletKey
			,c.Date
			,po.[Outlet Name]
			,po.[Alpha Code]			
			,c.isWeekDay
			,c.isWeekEnd
			,c.isHoliday
			,po.SubGroupName
			,cp.ProductClassification
	
	CREATE CLUSTERED INDEX [IX_Date] ON #PYQ
	(
		[Date] ASC
	)
	CREATE NONCLUSTERED INDEX [IX_OutletKey] ON #PYQ
	(
		[OutletKey] ASC

	)
	INCLUDE ( 		
				[Alpha Code]				
	) 

	SELECT	 DISTINCT 
			 OutletKey
			,Date
			,[Outlet Name]
			,[Alpha Code]			
			,isWeekDay
			,isWeekEnd
			,isHoliday	
			,SubGroupName
			,ProductDisplayName
			,ProductClassification
	INTO #Base
	FROM #CY
	UNION
	SELECT	 DISTINCT
			 OutletKey
			,Date
			,[Outlet Name]
			,[Alpha Code]			
			,isWeekDay
			,isWeekEnd
			,isHoliday	
			,SubGroupName
			,ProductDisplayName
			,ProductClassification
	FROM #PY
	UNION
	SELECT	 DISTINCT
			 OutletKey
			,Date
			,[Outlet Name]
			,[Alpha Code]			
			,isWeekDay
			,isWeekEnd
			,isHoliday	
			,SubGroupName
			,ProductDisplayName
			,ProductClassification
	FROM #CYQ
	UNION
	SELECT	 DISTINCT
			 OutletKey
			,Date
			,[Outlet Name]
			,[Alpha Code]			
			,isWeekDay
			,isWeekEnd
			,isHoliday	
			,SubGroupName
			,ProductDisplayName
			,ProductClassification
	FROM #PYQ

	CREATE CLUSTERED INDEX [IX_Date] ON #Base
	(
		[Date] ASC
	)
	CREATE NONCLUSTERED INDEX [IX_OutletKey] ON #Base
	(
		[OutletKey] ASC

	)
	INCLUDE ( 		
				[Alpha Code]				
	) 

	SELECT   b.OutletKey
			,b.Date
			,b.[Outlet Name]
			,b.[Alpha Code]			
			,b.isWeekDay
			,b.isWeekEnd
			,b.isHoliday	
			,b.SubGroupName
			,b.ProductDisplayName
			,b.ProductClassification
			,cyp.PolicyCount AS [Policy Count]
			,cyp.SellPrice AS [Sell Price]
			,cyp.Commission	AS [Commission]
			,cyp.BasePremimum	AS [Base Premium]
			,pyp.PolicyCount AS [YAGO Policy Count]
			,pyp.SellPrice AS [YAGO Sell Price]
			,pyp.Commission	AS [YAGO Commission]
			,pyp.BasePremimum	AS [YAGO Base Premium]
			,cyq.QuoteCount	AS [Quote Count]
			,pyq.QuoteCount	AS [YAGO Quote Count]
	FROM #Base b
	LEFT JOIN #CY cyp
		ON	b.OutletKey = cyp.OutletKey
		AND b.Date = cyp.Date
		AND b.ProductClassification = cyp.ProductClassification
		AND b.ProductDisplayName = cyp.ProductDisplayName
	LEFT JOIN #PY pyp
		ON	b.OutletKey = pyp.OutletKey
		AND b.Date = pyp.Date
		AND b.ProductClassification = pyp.ProductClassification
		AND b.ProductDisplayName = pyp.ProductDisplayName
	LEFT JOIN #CYQ cyq
		ON	b.OutletKey = cyq.OutletKey
		AND b.Date = cyq.Date
		--AND b.ProductClassification = cyq.ProductClassification
		AND b.ProductDisplayName = cyq.ProductDisplayName
	LEFT JOIN #PYQ pyq
		ON	b.OutletKey = pyq.OutletKey
		AND b.Date = pyq.Date
		--AND b.ProductClassification = pyq.ProductClassification
		AND b.ProductDisplayName = pyq.ProductDisplayName
END

GO
