USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH011_QuoteDetails]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[dshsp_DSH011_QuoteDetails]
	@StartDate date,
	@FYStart int = 10,
	@GroupCode varchar(2) = 'CB',
	@ExcludedAlpha varchar(100) = null,
	@IncludedAlpha varchar(100) = null
as
begin
	set nocount on;
	--DECLARE @StartDate date = '2019-08-20',
	--		@FYStart int = 10,
	--		@GroupCode varchar(2) = 'CB',
	--		@ExcludedAlpha varchar(100) = null,
	--		@IncludedAlpha varchar(100) = null

	DECLARE @Country nvarchar(10) = 'AU';

	if object_id('tempdb..#Periods') is not null
		drop table #Periods

	select * 
	into #Periods
	from dbo.fn_CBAFYDatePeriods(@StartDate, 10) dp

	if object_id('tempdb..#Outlets') is not null
		drop table #Outlets

	SELECT	o.SubGroupName,
			o.OutletAlphaKey
	into #Outlets
	from [db-au-cba].dbo.penOutlet o
	join [db-au-cba].[dbo].fn_DelimitedSplit8K(@IncludedAlpha,',') s on o.AlphaCode = IsNull(s.item, o.AlphaCode)
	where 
		o.GroupCode = @GroupCode
	AND o.countryKey = @Country
	AND o.OutletStatus = 'Current'
	AND o.AlphaCode not in (
			select item
			from [db-au-cba].[dbo].fn_DelimitedSplit8K(@ExcludedAlpha,',')
			where item is not null)

	declare @MinDate date,
			@MaxDate date

	select  @MinDate = min(PeriodStart),
			@MaxDate = max(PeriodEnd)
	from #Periods

	if object_id('tempdb..#QuoteData') is not null
		drop table #QuoteData

	;WITH QD as (
		SELECT   po.OutletAlphaKey
				,C.Date
				,cp.ProductClassification ProductName
				,po.SubGroupName
				,CASE when q.cbaChannelID = 'CBAAPP' THEN 'CBA App'
					when q.cbaChannelID = 'CBANB' THEN 'CBA NetBank'
					ELSE 'CBA Web' END as Channel
				,COUNT(q.QuoteID)	as QuoteCount
		FROM  #Outlets po
		INNER JOIN [db-au-cba].dbo.impQuotes q ON q.OutletAlphaKey = po.OutletAlphaKey
		inner join Calendar c on CAST(q.QuoteDate as date) = c.Date
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
		where cast(q.Quotedate as date) >= @MinDate
		and cast(q.Quotedate as date) <= @MaxDate
		GROUP BY po.OutletAlphaKey
				,C.Date	
				,cp.ProductClassification 
				,po.SubGroupName
				,CASE when q.cbaChannelID = 'CBAAPP' THEN 'CBA App'
					when q.cbaChannelID = 'CBANB' THEN 'CBA NetBank'
					ELSE 'CBA Web' END
		UNION ALL
		SELECT   po.OutletAlphaKey
				,C.Date
				,pppg.ProductClassification ProductName
				,po.SubGroupName
				,'CM Phone'
				,COUNT(q.QuoteID)	as QuoteCount
		FROM  #Outlets po
		INNER JOIN [db-au-cba].dbo.penQuote q						
			ON q.OutletAlphaKey = po.OutletAlphaKey
		inner join Calendar c on CAST(q.CreateDate as date) = c.Date
		LEFT join [db-au-cba].dbo.[vPenPolicyPlanGroups] pppg 
			ON q.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
		where cast(q.CreateDate as date) >= @MinDate
		and cast(q.CreateDate as date) <= @MaxDate
		GROUP BY po.OutletAlphaKey
				,C.Date
				,pppg.ProductClassification 
				,po.SubGroupName
		)
	select   Date
			,ProductName
			,SubGroupName
			,Channel
			,SUM(QuoteCount) as QuoteCount
	into #QuoteData
	from QD
	GROUP By Date
			,ProductName
			,SubGroupName
			,Channel

	select x.Period, p.*
	from #Periods x 
	left join #QuoteData p on p.Date between x.PeriodStart and x.PeriodEnd
END
GO
