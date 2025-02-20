USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH003_QuoteTravellerAgeBands]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[dshsp_DSH003_QuoteTravellerAgeBands] 
	@StartDate date = null,
	@EndDate date = null,
	@GroupCode varchar(2) = 'CB',
	@ExcludedAlpha varchar(100) = null,
	@IncludedAlpha varchar(100) = null	
as
begin
/****************************************************************************************************/
--  Name:           DSH003 - CBA - Dashboard - Channel Summary
--  Author:         Dane Murray
--  Date Created:   20180731
--  Description:    Quote Data by Destination 
--
--  Parameters:     @StartDate: Format: YYYY-MM-DD eg. 2015-01-01
--					@EndDate: Format: YYYY-MM-DD eg. 2015-01-01
--					@GroupCode: CB or BW
--					@ExcludedAlpha: Outlets to excluded from report, if null nothing excluded
--					@IncludedAlpha: Outlets to be included in the report, if blank everything included. Exclusions override Inclusions
--   
--  Change History: 20180523 - DM - Created 
--					20190807 - DM - Adjusted to be able to include or Exclude specific Alpha (for WDC)
--                  
/****************************************************************************************************/
	SET NOCOUNT ON; 

	DECLARE @Country nvarchar(10) = 'AU';

	if object_id('tempdb..#Outlets') is not null
		drop table #Outlets

	SELECT	o.SuperGroupName,
			o.GroupName,
			o.SubGroupName,
			o.BDMName,
			o.AlphaCode,
			o.OutletName,
			o.Channel,
			o.OutletAlphaKey,
			o.OutletKey,
			o.GroupCode
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
	from[db-au-cba].[dbo]. impQuotes Q
	left JOIN #Outlets po on q.OutletAlphaKey = po.OutletAlphaKey 
	left JOIN [db-au-cba].[dbo].impQuoteTravellers T ON Q.BIRowID = T.QuoteSK
	LEFT join [db-au-cba].[dbo].dimAgeBand A ON t.age = A.Age AND t.isPlaceholderAge = 'false'
	left join [db-au-cba].[dbo].impQuoteDestinations D ON Q.BIRowID = D.QuoteSK AND D.DestinationOrdered = 0
	outer apply
		(
				SELECT dest.Destination AS Destination,
					   coun.ISO2Code, coun.ISO3Code
				FROM
					( SELECT Destination,
							 Max(LoadID) AS LoadID
					  FROM   [db-au-cba].[dbo].[dimDestination]
					  GROUP  BY Destination) dest
				OUTER APPLY ( SELECT TOP 1 ISO2Code, ISO3Code
							  FROM [db-au-cba].[dbo].[dimDestination]
							  WHERE LoadID = dest.LoadID
								 AND Destination = dest.Destination) Coun
				where D.Destination = Coun.ISO3Code
		) QD
	outer apply (select top 1 ProductClassification, SaleType
				from [db-au-cba].[dbo].[vPenPolicyPlanGroups]	 ppg
				join [db-au-cba].[dbo].cdgProduct cP on ppg.ProductCode = cP.ProductCode 
				AND CASE cP.PlanCode 
						WHEN 'DMTS' THEN 'DSM' 
						WHEN 'DMTF' THEN 'DFM' 
						ELSE cP.PlanCode END = ppg.PlanCode
				where q.quoteProductID = cP.ProductID
				AND po.OutletAlphaKey = ppg.OutletAlphaKey
				) cp
	where QuoteDate >= '20181001'
		and CAST(q.QuoteDate as Date) >= @StartDate
		and CAST(q.QuoteDate as Date) <= @EndDate
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
	from [db-au-cba].[dbo].penQuote Q
	left join [db-au-cba].[dbo].penQuoteCustomer T on Q.QuoteCountryKey = T.QuoteCountryKey
	LEFT join [db-au-cba].[dbo].dimAgeBand A ON t.age = A.Age 
	outer apply
		(
				SELECT top 1 dest.Destination AS Destination,
					   coun.ISO2Code, coun.ISO3Code
				FROM
					( SELECT Destination,
							 Max(LoadID) AS LoadID
					  FROM  [db-au-cba].[dbo].[dimDestination]
					  GROUP  BY Destination) dest
				OUTER APPLY ( SELECT TOP 1 ISO2Code, ISO3Code
							  FROM [db-au-cba].[dbo].[dimDestination]
							  WHERE LoadID = dest.LoadID
								 AND Destination = dest.Destination) Coun
				where Q.Destination = dest.Destination
		) QD
	JOIN #Outlets po on Q.OutletAlphaKey = po.OutletAlphaKey
	LEFT join [db-au-cba].[dbo].[vPenPolicyPlanGroups] pppg 
			ON q.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
	where CreateDate >= '20181001'
		and CAST(q.CreateDate as Date) >= @StartDate
		and CAST(q.CreateDate as Date) <= @EndDate
END
GO
