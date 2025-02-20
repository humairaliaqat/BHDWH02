USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH002_SalesByProduct2]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE procedure [dbo].[dshsp_DSH002_SalesByProduct2]
	@StartDate date = null,
	@EndDate date = null,
	@GroupCode varchar(2) = 'CB'
as 
begin
	/****************************************************************************************************/
	--  Name:           CBA - Dashboard - Sales by Product
	--  Author:         Saurabh Date
	--  Date Created:   20180822
	--  Description:    Data by day for Policies  
	--
	--  Parameters:     @DateRange: standard date range or _User Defined
	--					@StartDate: if _User Defined. Format: YYYY-MM-DD eg. 2015-01-01
	--					@EndDate: if_User Defined. Format: YYYY-MM-DD eg. 2015-01-01
	--   
	--  Change History: 20180822 - SD - Created 
	--                  
	/****************************************************************************************************/
	--DEBUG -- Uncomment to Debug
	--DECLARE 	
	--	@StartDate date = '20181001',
	--	@EndDate date = '20181031',
	--	@GroupCode varchar(2) = 'CB'


	SET NOCOUNT ON; 
	DECLARE @Country NVARCHAR(10) = 'AU'

	DECLARE @Start DATE = IsNull(@StartDate, DateAdd(day,1,EOMONTH(GetDate(),-1))) --(SELECT CAST(DATEADD(MM,-6,GETDATE()) AS DATE))
	DECLARE @End DATE = IsNull(@EndDate, DAteAdd(day,-1,GetDate()))--(SELECT CAST(GETDATE() AS DATE))
	

	if object_id('tempdb..#Periods') is not null
		drop table #Periods

	select 
		*
	into 
		#Periods
	from 
		dbo.UDF_ReportingPeriods(@Start, @End, DEFAULT)
	where PeriodText <> 'History Periods'

	if object_id('tempdb..#DDates') is not null
		drop table #DDates

	select DISTINCT Date
	INTO #DDates
	from #Periods

	if object_id('tempdb..#RemovedPolicies') is not null
		drop table #RemovedPolicies

	select PolicyKey
	into #RemovedPolicies
	from penPolicyTransSummary
	group by PolicyKey
	having min(PostingDate) < '20181001'

	if object_id('tempdb..#Outlets') is not null
		drop table #Outlets

	select	
		po.OutletAlphaKey,
		po.SuperGroupName,
		po.GroupCode,
		po.GroupName,
		po.SubGroupName,
		po.AlphaCode,
		po.OutletName
	into #Outlets
	from  penOutlet po
	where po.GroupCode = @GroupCode 
	and po.OutletStatus = 'Current'

	if object_id('tempdb..#Policies') is not null
		drop table #Policies

	select  O.OutletAlphaKey,
			d.Date,
			P.policyKey,
			P.UniquePlanID,
			pptg.TravelGroup [TravelGroup],
			P.ProductCode,
			CASE pts.TransactionType WHEN 'BASE' THEN 'Base' ELSE 'Adjustment' END as TransactionType,
			Case when crm.CRMUserID <> '' then 'CM Phone' ELSE 'CBA Web' END as ChannelSource,
			pts.BasePolicyCount,
			pts.GrossPremium,
			ppp.Premium,
			pts.Commission + pts.GrossAdminFee as Commission,
			ppp.[Agency Commission (excl GST)] as CommissionExGST
	into #Policies
	from #outlets o
	inner join penPolicy p on o.OutletAlphaKey = p.OutletAlphaKey
	inner join penPolicyTransSummary pts on pts.PolicyKey = p.PolicyKey
	inner join vPenguinPolicyPremiums ppp on pts.PolicyTransactionKey = ppp.PolicyTransactionKey
	inner join #DDates d on pts.PostingDate = d.Date
	inner join vPenPolicyTravellerGroup pptg on p.PolicyKey = pptg.PolicyKey
	outer apply(
		select top 1
			isnull(Convert(varchar(50),crm.CRMUserID),'') CRMUserID
		From
			penPolicyTransSummary crm
		where
			crm.PolicyKey = p.PolicyKey
		order by
			crm.PolicyTransactionID desc
	) crm
	where not exists (select PolicyKey from #RemovedPolicies r where p.PolicyKey = r.PolicyKey)

	if object_id('tempdb..#Results') is not null
		drop table #Results

	;with FullData as (
		select 
			o.OutletAlphaKey,
			o.SuperGroupName,
			o.GroupCode,
			o.GroupName,
			o.SubGroupName,
			o.AlphaCode,
			o.OutletName,
			C.PeriodText,
			C.Date,
			C.PeriodStartDate,
			C.PeriodEndDate,
			C.PeriodDateNum,
			ppg.SaleType SaleType, 
			ppg.ProductClassification,
			ppg.UniquePlanID,
			X.TravelGroup, 
			X.TransactionType, 
			X.ChannelSource
		from #Outlets o
		inner join vPenPolicyPlanGroups ppg on o.OutletAlphaKey = ppg.OutletAlphaKey
		cross join #Periods c	
		cross join (select distinct TravelGroup, TransactionType, ChannelSource from #Policies) X
	)
	select	
		d.PeriodText,
		d.Date,
		d.PeriodStartDate,
		d.PeriodEndDate,
		d.PeriodDateNum,
		d.SuperGroupName,
		d.GroupCode,
		d.GroupName,
		d.SubGroupName,
		d.SaleType SaleType,
		d.AlphaCode,
		d.OutletName, 
		d.ProductClassification [ProductName],
		d.UniquePlanID,
		d.TravelGroup,
		d.TransactionType,
		d.ChannelSource,
		sum(isnull(pp.BasePolicyCount,0)) [PolicyCount],
		sum(isnull(pp.GrossPremium,0)) [SellPrice],
		sum(isnull(pp.Commission,0)) [Commission],
		SUM(isNull(pp.Premium,0)) [SellPriceExGST],
		sum(isnull(pp.CommissionExGST,0)) CommissionExGST
	INTO #Results
	from 
		FullData d 
		left join #Policies pp
			on d.OutletAlphaKey = pp.OutletAlphaKey
			AND d.UniquePlanID = pp.UniquePlanID
			AND d.Date = pp.Date
			AND d.TravelGroup = pp.TravelGroup
			and d.TransactionType = pp.TransactionType
			and d.ChannelSource = pp.ChannelSource
	Group By
		d.PeriodText,
		d.Date,
		d.PeriodStartDate,
		d.PeriodEndDate,
		d.PeriodDateNum,
		d.SuperGroupName,
		d.GroupCode,
		d.GroupName,
		d.SubGroupName,
		d.SaleType,
		d.AlphaCode,
		d.OutletName, 
		pp.ProductCode,
		d.ProductClassification,
		d.UniquePlanID,
		d.TravelGroup,
		d.TransactionType,
		d.ChannelSource
		
	if object_id('tempdb..#SummaryResults') is not null
		drop table #SummaryResults

	select 
		'Summary' as DataType,
		PeriodText,
		PeriodStartDate,
		PeriodEndDate,
		SuperGroupName,
		GroupCode,
		GroupName,
		SubGroupName,
		SaleType,
		AlphaCode,
		OutletName, 
		ProductName,
		TravelGroup,
		UniquePlanID,
		TransactionType,
		ChannelSource,
		sum(PolicyCount) [PolicyCount],
		sum(SellPrice) [SellPrice],
		sum(Commission) [Commission],
		SUM(isNull([SellPriceExGST],0)) [SellPriceExGST],
		sum(isnull(CommissionExGST,0)) CommissionExGST
	INTO 
		#SummaryResults
	from 
		#Results
	GROUP BY
		PeriodText,
		PeriodStartDate,
		PeriodEndDate,
		SuperGroupName,
		GroupCode,
		GroupName,
		SubGroupName,
		SaleType,
		AlphaCode,
		OutletName, 
		ProductName,
		TravelGroup,
		UniquePlanID,
		TransactionType,
		ChannelSource

	insert into 
		#SummaryResults
	select 
		'Summary' DataType,
		'Current Period Variance' as PeriodText,
		null,
		null,
		R.SuperGroupName,
		R.GroupCode,
		R.GroupName,
		R.SubGroupName,
		R.SaleType,
		R.AlphaCode,
		R.OutletName, 
		R.ProductName, 
		R.TravelGroup,
		R.UniquePlanId,
		R.TransactionType,
		R.ChannelSource,
		sum(R.PolicyCount)- sum(R2.PolicyCount) [PolicyCount],
		sum(R.SellPrice)- sum(R2.SellPrice) [SellPrice],
		sum(R.Commission) - sum(R2.Commission) [Commission],
		sum(R.[SellPriceExGST])- sum(R2.[SellPriceExGST]) [SellPriceExGST],
		sum(R.CommissionExGST) - sum(R2.CommissionExGST) CommissionExGST
	from 
		#Results R
		LEFT JOIN #Results R2 
			on		R.SaleType = R2.SaleType
				and R.AlphaCode = R2.AlphaCode
				and R.UniquePlanID = R2.UniquePlanID
				and R.TravelGroup = R2.TravelGroup
				AND R.PeriodDateNum = R2.PeriodDateNum
				and IsNull(R.ChannelSource,'') = IsNull(R2.ChannelSource,'')
				AND R.TransactionType = R2.TransactionType
	where 
		R.PeriodText = 'Current Period'
		AND R2.PeriodText = 'Last Year at Current Period'
	GROUP BY 
		R.PeriodText, 
		R.SuperGroupName,
		R.GroupCode,
		R.GroupName,
		R.SubGroupName,
		R.SaleType,
		R.AlphaCode,
		R.OutletName, 
		R.ProductName,
		R.TravelGroup,
		R.UniquePlanId,
		R.TransactionType,
		R.ChannelSource

	select 
		* 
	from 
		#SummaryResults
END
GO
