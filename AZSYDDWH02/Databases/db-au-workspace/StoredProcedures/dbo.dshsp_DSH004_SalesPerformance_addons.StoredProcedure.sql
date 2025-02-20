USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH004_SalesPerformance_addons]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[dshsp_DSH004_SalesPerformance_addons]
	@Date date = null,	
	@GroupCode varchar(2) = 'CB',
	@ExcludedAlpha varchar(100) = null,
	@IncludedAlpha varchar(100) = null	
as
begin
SET NOCOUNT ON

										
/****************************************************************************************************/
--  Name:           CBA_SalesPerformance
--  Author:         ME
--  Date Created:   20180827
--  Description:    Return Sales data for certain period  
--
--  Parameters:     @Date: EOM Date to for monthly calculations1-01
--					@GroupCode: CB or BW
--					@ExcludedAlpha: Outlets to excluded from report, if null nothing excluded
--					@IncludedAlpha: Outlets to be included in the report, if blank everything included. Exclusions override Inclusions
--   
--  Change History: 20180829 - ME - Created 
--					20180925 - DM-  Adjusted to use GroupCode and also move to AZSYDDWH03
--					20181015 - LL - outlet status missing
--					20190807 - DM - Adjusted to be able to include or Exclude specific Alpha (for WDC)
--                  
/****************************************************************************************************/

--uncomment to debug
	--DECLARE @Date date = null
	
	DECLARE @Country NVARCHAR(10) = 'AU'

	set @Date = IsNull(@Date, GetDate()-1)

	DECLARE @StartDate DATE = DateAdd(day, 1, EOMonth(@Date, -1)) --(SELECT CAST(DATEADD(MM,-6,GETDATE()) AS DATE))
	DECLARE @EndDate DATE = @Date--EOMonth(@Date,0)--(SELECT CAST(GETDATE() AS DATE))

	select @StartDate = CASE WHEN @StartDate <= '20181001' THEN '20181001' ELSE @StartDate END

	if object_id('tempdb..#Calendar') is not null
		drop table #Calendar

	SELECT CAST([Date] AS DATE) AS [Date],		  		   
		   isWeekDay,
		   isHoliday,
		   isWeekEnd,
		   CAST(EOMONTH([Date]) AS DATE) AS [MonthEnd]
	INTO #Calendar
	FROM [db-au-cba].dbo.Calendar
	WHERE [Date] BETWEEN @StartDate AND @EndDate

	CREATE CLUSTERED INDEX [IX_Date] ON #Calendar
	(
		[Date] ASC
	)

	if object_id('tempdb..#outlets') is not null
		drop table #outlets

	select o.OutletAlphaKey,	
		   o.AlphaCode,
		   o.OutletName,
		   o.SubGroupName
	into #outlets	   
	from [db-au-cba].[dbo].penOutlet o
	join [db-au-cba].[dbo].fn_DelimitedSplit8K(@IncludedAlpha,',') s on o.AlphaCode = IsNull(s.item, o.AlphaCode)
	where 
		o.GroupCode = @GroupCode
	AND o.countryKey = @Country
	AND o.OutletStatus = 'Current'
	AND o.AlphaCode not in (
			select item
			from [db-au-cba].[dbo].fn_DelimitedSplit8K(@ExcludedAlpha,',')
			where item is not null)

	select PolicyKey
	into #RemovedPolicies
	from [db-au-cba].dbo.penPolicyTransSummary
	group by PolicyKey
	having min(postingdate) < '20181001'
				
	SELECT   c.MonthEnd	
			,c.Date
			,po.SubGroupName
			,po.OutletName
			,pta.AddOnGroup	as [Add-On Group]
			,pppg.ProductClassification as ProductDisplayName
			,sum(pt.BasepolicyCount) as PolicyCount
			,sum(pt.AddonPolicyCount + pt.BasePolicyCount)	as [Add-on Count]
			,SUM(pta.GrossPremium) as [Add-on Gross Premium]
	FROM  #Calendar c   
    inner join [db-au-cba].dbo.penPolicyTransSummary pt on
		c.Date = cast(pt.PostingDate as date)
	inner join #outlets po on
		pt.OutletAlphaKey = po.OutletAlphaKey
    inner join [db-au-cba].dbo.penPolicyTransAddOn pta on
        pta.PolicyTransactionKey = pt.PolicyTransactionKey	
	INNER JOIN [db-au-cba].dbo.penPolicy p						
		ON pt.PolicyKey = p.PolicyKey
	inner JOIN [db-au-cba].dbo.[vPenPolicyPlanGroups] pppg 
		ON p.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
	where P.PolicyKey not in (select PolicyKey from #RemovedPolicies)
	group by c.MonthEnd
			,c.Date
			,po.SubGroupName
			,po.OutletName
			,pta.AddOnGroup
			,pppg.ProductClassification

END

GO
