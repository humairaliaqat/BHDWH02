USE [db-au-cba]
GO
/****** Object:  View [dbo].[rpt_DSH03_QuoteDetails_vw]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






CREATE view [dbo].[rpt_DSH03_QuoteDetails_vw] as 
	select	CAST(Q.QuoteDate as date) QuoteDateAEST, 
			po.GroupCode,
			po.OutletName,
			po.SubGroupName,
			IsNull(QD.Destination, D.Destination) as Destination, 
			QD.ISO2Code,
			QD.ISO3Code,
			IsNull(cp.ProductClassification, 'Unknown') ProductDisplayName,
			COUNT(DISTINCT Q.QuoteID) as QuoteCount,
			COUNT(DISTINCT CASE WHEN Q.isPurchased = 'true' THEN Q.QuoteID END)  as PurchasedCount
	from impQuotes Q
	JOIN penOutlet po on q.OutletAlphaKey = po.OutletAlphaKey AND po.OutletStatus = 'Current'
	left join impQuoteDestinations D ON Q.BIRowID = D.QuoteSK AND D.DestinationOrdered = 0
	outer apply
		(
				SELECT dest.Destination AS Destination,
					   coun.ISO2Code, coun.ISO3Code
				FROM
					( SELECT Destination,
							 Max(LoadID) AS LoadID
					  FROM   [dbo].[dimDestination]
					  GROUP  BY Destination) dest
				OUTER APPLY ( SELECT TOP 1 ISO2Code, ISO3Code
							  FROM [dbo].[dimDestination]
							  WHERE LoadID = dest.LoadID
								 AND Destination = dest.Destination) Coun
				where D.Destination = Coun.ISO3Code
		) QD
	outer apply (select top 1 ProductClassification, SaleType
				from [vPenPolicyPlanGroups]	 ppg
				join cdgProduct cP on ppg.ProductCode = cP.ProductCode 
				AND CASE cP.PlanCode 
						WHEN 'DMTS' THEN 'DSM' 
						WHEN 'DMTF' THEN 'DFM' 
						ELSE cP.PlanCode END = ppg.PlanCode
				where q.quoteProductID = cP.ProductID
				AND po.OutletAlphaKey = ppg.OutletAlphaKey
				) cp
	where QuoteDate >= '20181001'
	GROUP BY CAST(Q.QuoteDate as date), 
			 po.GroupCode,
			 po.OutletName,
			 po.SubGroupName,
			 IsNull(QD.Destination, D.Destination), 
			 QD.ISO2Code,
			 QD.ISO3Code,
			 cp.ProductClassification
	
	UNION ALL
	
	select	CAST(Q.CreateDate as date) QuoteDateAEST, 
			po.GroupCode,
			po.OutletName,
			po.SubGroupName,
			IsNull(QD.Destination, Q.Destination) as Destination, 
			QD.ISO2Code,
			QD.ISO3Code,
			IsNull(pppg.ProductClassification,'Unknown') ProductDisplayName,
			COUNT(DISTINCT Q.QuoteID) as QuoteCount,
			0 as Purchased--COUNT(DISTINCT CASE WHEN Q.isPurchased = 'true' THEN Q.QuoteID END)  as PurchasedCount
	from penQuote Q
	JOIN penOutlet po on Q.OutletAlphaKey = po.OutletAlphaKey AND po.OutletStatus = 'Current'
	outer apply
		(
				SELECT top 1 dest.Destination AS Destination,
					   coun.ISO2Code, coun.ISO3Code
				FROM
					( SELECT Destination,
							 Max(LoadID) AS LoadID
					  FROM   [dbo].[dimDestination]
					  GROUP  BY Destination) dest
				OUTER APPLY ( SELECT TOP 1 ISO2Code, ISO3Code
							  FROM [dbo].[dimDestination]
							  WHERE LoadID = dest.LoadID
								 AND Destination = dest.Destination) Coun
				where Q.Destination = dest.Destination
		) QD
	LEFT join [vPenPolicyPlanGroups] pppg 
			ON q.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
	where CreateDate >= '20181001'
	GROUP BY CAST(Q.CreateDate as date), 
			 po.GroupCode,
			 po.OutletName,
			 po.SubGroupName,
			 IsNull(QD.Destination, Q.Destination), 
			 QD.ISO2Code,
			 QD.ISO3Code,
			 pppg.ProductClassification




GO
