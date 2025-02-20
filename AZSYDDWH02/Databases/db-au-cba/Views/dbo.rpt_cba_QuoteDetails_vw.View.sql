USE [db-au-cba]
GO
/****** Object:  View [dbo].[rpt_cba_QuoteDetails_vw]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[rpt_cba_QuoteDetails_vw] as 
	select	CAST(Q.QuoteDate as date) QuoteDateAEST, 
			po.GroupCode,
			po.OutletName,
			po.SubGroupName,
			IsNull(QD.Destination, D.Destination) as Destination, 
			QD.ISO2Code,
			QD.ISO3Code,
			COUNT(DISTINCT Q.QuoteID) as QuoteCount,
			COUNT(DISTINCT CASE WHEN Q.isPurchased = 'true' THEN Q.QuoteID END)  as PurchasedCount
	from impQuotes Q
	left join impQuoteDestinations D ON Q.BIRowID = D.QuoteSK AND D.DestinationOrdered = 0
	outer apply
		(
				SELECT UPPER(dest.Destination) AS Destination,
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
	JOIN penOutlet po on Q.issuerAffiliateCode = po. AlphaCode AND po.OutletStatus = 'Current'
	where QuoteDate is not null
	GROUP BY CAST(Q.QuoteDate as date), 
			 po.GroupCode,
			 po.OutletName,
			 po.SubGroupName,
			 IsNull(QD.Destination, D.Destination), 
			 QD.ISO2Code,
			 QD.ISO3Code
GO
