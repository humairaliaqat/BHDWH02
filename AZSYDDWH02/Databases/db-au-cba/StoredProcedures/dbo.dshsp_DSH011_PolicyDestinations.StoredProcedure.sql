USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH011_PolicyDestinations]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[dshsp_DSH011_PolicyDestinations]
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

	if object_id('tempdb..#Policies') is not null
		drop table #Policies

	select  
		o.SubGroupName,
		C.Date,
		P.ProductCode,
		d.Destination,
		Case 
			when crm.CRMUserID <> '' AND ip.cbaChannelID IS NULL then 'CM Phone' 
			when crm.CRMUserID =  '' AND ip.cbaChannelID IS NULL then 'CBA Web'
			when ip.cbaChannelID = 'CBAAPP' THEN 'CBA App'
			when ip.cbaChannelID = 'CBANB' THEN 'CBA NetBank'
			ELSE 'CBA Web' 
		END as ChannelSource,
		SUM(pts.BasePolicyCount) as BasePolicyCount
	into #Policies
	from #Outlets o
	inner join dbo.penPolicy p on o.OutletAlphaKey = p.OutletAlphaKey
	inner join dbo.penPolicyTransSummary pts on pts.PolicyKey = p.PolicyKey
	inner join Calendar c on CAST(pts.PostingDate as Date) = c.Date
	outer apply ( 
		select  LTRIM(RTRIM(item)) as Destination, ItemNumber
		from dbo.fn_DelimitedSplit8K(p.MultiDestination, ';')
		) d
	outer apply(
		select top 1
			isnull(crm.CRMUserID,'') CRMUserID
		From
			[db-au-cba].dbo.penPolicyTransSummary crm
		where
			crm.PolicyKey = p.PolicyKey
		order by
			crm.PolicyTransactionID
	) crm
	left join [db-au-cba].dbo.impPolicies ip on p.PolicyKey = ip.PolicyKey
	where pts.TransactionType = 'BASE'
	and c.date >= (select min(PeriodStart) from #Periods)
	and c.Date <= (select max(PeriodEnd) from #Periods)
	GROUP BY 
		o.SubGroupName,
		C.Date,
		P.ProductCode,
		d.Destination,
		Case 
			when crm.CRMUserID <> '' AND ip.cbaChannelID IS NULL then 'CM Phone' 
			when crm.CRMUserID =  '' AND ip.cbaChannelID IS NULL then 'CBA Web'
			when ip.cbaChannelID = 'CBAAPP' THEN 'CBA App'
			when ip.cbaChannelID = 'CBANB' THEN 'CBA NetBank'
			ELSE 'CBA Web' 
		END

	select x.Period, p.Destination, p.ProductCode, p.SubGroupName, p.ChannelSource, SUM(p.BasePolicyCount) as PolicyCount
	from #Policies p
	join #Periods x on p.Date between x.PeriodStart and x.PeriodEnd
	GROUP BY x.Period, p.Destination, p.ProductCode, p.SubGroupName, p.ChannelSource
END
GO
