USE [db-au-cba]
GO
/****** Object:  View [dbo].[rpt_DSH03_QuoteTravellerAgeBands]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[rpt_DSH03_QuoteTravellerAgeBands] as
	select	CAST(Q.QuoteDate as date) as QuoteDate,
			po.GroupCode,
			po.OutletName,
			po.SubGroupName,
			T.QuoteSK, 
			T.PrimaryTraveller, 
			A.AgeBand, 
			A.ABSAgeBand,
			Q.isPurchased,
			QD.Destination, 
			QD.ISO2Code,
			QD.ISO3Code,
			IsNull(cp.ProductClassification, 'Unknown') as ProductDisplayName
	from impQuotes Q
	left JOIN penOutlet po on q.OutletAlphaKey = po.OutletAlphaKey AND po.OutletStatus = 'Current'
	left JOIN impQuoteTravellers T ON Q.BIRowID = T.QuoteSK
	LEFT join dimAgeBand A ON t.age = A.Age AND t.isPlaceholderAge = 'false'
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
	union all
	select	CAST(Q.CreateDate as date) as QuoteDate,
			po.GroupCode,
			po.OutletName,
			po.SubGroupName,
			T.QuoteID, 
			T.IsPrimary, 
			A.AgeBand, 
			A.ABSAgeBand,
			0 isPurchased,
			QD.Destination, 
			QD.ISO2Code,
			QD.ISO3Code,
			IsNull(pppg.ProductClassification, 'Unknown') as ProductDisplayName
	from penQuote Q
	left join penQuoteCustomer T on Q.QuoteCountryKey = T.QuoteCountryKey
	LEFT join dimAgeBand A ON t.age = A.Age 
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
	JOIN penOutlet po on Q.OutletAlphaKey = po.OutletAlphaKey AND po.OutletStatus = 'Current'
	LEFT join [vPenPolicyPlanGroups] pppg 
			ON q.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
	where CreateDate >= '20181001'

GO
