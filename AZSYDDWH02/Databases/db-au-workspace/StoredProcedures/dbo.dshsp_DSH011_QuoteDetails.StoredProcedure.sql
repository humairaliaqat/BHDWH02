USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH011_QuoteDetails]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[dshsp_DSH011_QuoteDetails]
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

	-- Policy Data
	if object_id('tempdb..#RemovedPolicies') is not null
		drop table #RemovedPolicies

	select DISTINCT PolicyKey
	into #RemovedPolicies
	from [db-au-cba].dbo.penPolicyTransSummary
	group by PolicyKey
	having min(PostingDate) < '20181001'

	declare @MinDate date,
			@MaxDate date

	select  @MinDate = min(PeriodStart),
			@MaxDate = max(PeriodEnd)
	from #Periods

	if object_id('tempdb..#Policies') is not null
		drop table #Policies

	select
		o.SubGroupName,
		C.Date,
		P.policyKey,
		pptg.TravelGroup [TravelGroup],
		P.ProductCode,
		CASE pts.TransactionType WHEN 'BASE' THEN 'Base' ELSE 'Adjustment' END as TransactionType,
		Case 
			when crm.CRMUserID <> '' AND ip.cbaChannelID IS NULL then 'CM Phone' 
			when crm.CRMUserID =  '' AND ip.cbaChannelID IS NULL then 'CBA Web'
			when ip.cbaChannelID = 'CBAAPP' THEN 'CBA App'
			when ip.cbaChannelID = 'CBANB' THEN 'CBA NetBank'
			ELSE 'CBA Web' 
		END as ChannelSource,
		pts.BasePolicyCount,
		pts.GrossPremium,
		pts.Commission + pts.GrossAdminFee as Commission,
		ab.ABSAgeBand
	into #Policies
	from #Outlets o
	inner join dbo.penPolicy p on o.OutletAlphaKey = p.OutletAlphaKey
	inner join dbo.penPolicyTransSummary pts on pts.PolicyKey = p.PolicyKey
	inner join Calendar c on pts.PostingDate = c.Date
	inner join dbo.vPenPolicyTravellerGroup pptg on p.PolicyKey = pptg.PolicyKey
	outer apply(
		select top 1
			isnull(Convert(varchar(50),crm.CRMUserID),'') CRMUserID
		From
			[db-au-cba].dbo.penPolicyTransSummary crm
		where
			crm.PolicyKey = p.PolicyKey
		order by
			crm.PolicyTransactionID
	) crm
	left join [db-au-cba].dbo.impPolicies ip on p.PolicyKey = ip.PolicyKey
	outer apply (
		select top 1 ABSAgeBand
		from penPolicyTraveller t
		join dimAgeBand a on t.Age = a.Age
		where t.PolicyKey = pts.PolicyKey
		and t.isPrimary = 1	
	) ab
	where P.PolicyKey not in (select PolicyKey from #RemovedPolicies)
	and c.date >= @MinDate
	and c.Date <= @MaxDate

	select x.Period, p.*
	from #Periods x 
	left join #Policies p on p.Date between x.PeriodStart and x.PeriodEnd
END
GO
