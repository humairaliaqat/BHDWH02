USE [db-au-workspace]
GO
/****** Object:  View [COVERMORE\dmurray].[vCBAQuotes]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [COVERMORE\dmurray].[vCBAQuotes] as 
WITH
outlets as (
	SELECT SubGroupName, OutletName, OutletAlphaKey, OutletKey, CompanyKey
	from [db-au-cba].dbo.penOutlet
	WHERE OutletStatus = 'Current'
	and GroupCode = 'CB'
)
, QD as (
		SELECT   po.OutletAlphaKey
				,c.Date
				,C.CurWeekEnd
				,cp.ProductClassification ProductName
				,cp.SaleType ProductClassification
				,COUNT(q.QuoteID)	as QuoteCount
		FROM  outlets po
		INNER JOIN [db-au-cba].dbo.impQuotes q ON q.OutletAlphaKey = po.OutletAlphaKey
		INNER JOIN [db-au-cba].dbo.Calendar c ON q.QuoteDate = c.Date
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
				,c.Date
				,C.CurWeekEnd
				,cp.ProductClassification 
				,cp.SaleType
		UNION ALL
		SELECT   po.OutletAlphaKey
				,c.Date
				,C.CurWeekEnd
				,pppg.ProductClassification ProductName
				,pppg.SaleType ProductClassification
				,COUNT(q.QuoteID)	as QuoteCount
		FROM  outlets po
		INNER JOIN [db-au-cba].dbo.penQuote q						
			ON q.OutletAlphaKey = po.OutletAlphaKey
		INNER JOIN [db-au-cba].dbo.Calendar c ON q.CreateDate = c.Date
		LEFT join [db-au-cba].dbo.[vPenPolicyPlanGroups] pppg 
			ON q.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
		where q.CreateDate >= '20181001'
		GROUP BY po.OutletAlphaKey
				,c.Date
				,C.CurWeekEnd
				,pppg.ProductClassification 
				,pppg.SaleType
		)
	select   OutletAlphaKey
			,Date
			,CurWeekEnd
			,ProductName
			,ProductClassification
			,SUM(QuoteCount) as QuoteCount
	from QD
	GROUP By OutletAlphaKey
			,Date
			,CurWeekEnd
			,ProductName
			,ProductClassification
GO
