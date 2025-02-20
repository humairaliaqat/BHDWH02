USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH010_PolicyTravellerDestinations]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[dshsp_DSH010_PolicyTravellerDestinations]
	@TripStart date = null,		
	@TripEnd date = null,
	@GroupCode varchar(2) = 'CB',
	@ExcludedAlpha varchar(100) = null,
	@IncludedAlpha varchar(100) = null
as
BEGIN
SET NOCOUNT ON
		
	DECLARE @Country NVARCHAR(10) = 'AU'
	--, @GroupCode varchar(2) = 'CB'

	select @TripStart = CASE WHEN @TripStart <= '20181001' THEN '20181001' ELSE @TripStart END
	select  @ExcludedAlpha = NullIf(@ExcludedAlpha,''),
			@IncludedAlpha = NullIf(@IncludedAlpha,'')

	SELECT CAST([Date] AS DATE) AS [Date],		  		   
		   isWeekDay,
		   isHoliday,
		   isWeekEnd,
		   CAST(EOMONTH([Date]) AS DATE) AS [MonthEnd]
	INTO #Calendar
	FROM [db-au-cba].dbo.Calendar
	WHERE [Date] BETWEEN @TripStart AND @TripEnd

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
	group by PolicyKey
	having min(postingdate) < '20181001'

	select	PO.[Outlet Name], 
			P.policykey, 
			P.PolicyNumber, 
			p.MultiDestination, 
			P.TripStart, 
			P.TripEnd, 
			IsNull(d.Destination, x.Item) as Destination, 
			d.ISO2Code, 
			d.ISO3Code, 
			pt.TravellerCount, 
			pppg.ProductClassification as ProductDisplayName,
			pppg.SaleType ProductClassification
	from [db-au-cba].dbo.penPolicy P
	join #Outlets po on p.OutletAlphaKey = po.OutletAlphaKey
	inner JOIN [db-au-cba].dbo.[vPenPolicyPlanGroups] pppg ON p.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
	cross apply [db-au-cba].dbo.[fn_DelimitedSplit8K](p.MultiDestination, ';') x 
	outer apply (
		select top 1 d.Destination, D.ISO2Code, D.ISO3Code
		from [db-au-cba].dbo.DimDestination d 
		where d.Destination = LTRIM(RTRIM(x.Item))
		order by loaddate desc) d
	outer apply (
		select COUNT(*) as TravellerCount
		from [db-au-cba].dbo.penPolicyTraveller pt
		where p.PolicyKey = pt.PolicyKey
		) pt
	where p.StatusDescription = 'Active'
	and p.TripType = 'Single Trip'
	and not exists (select 1 from #RemovedPolicies z where P.policyKey = z.Policykey)
	and exists (select 1 from #Calendar c where c.Date between p.TripStart and p.TripEnd)
END
GO
