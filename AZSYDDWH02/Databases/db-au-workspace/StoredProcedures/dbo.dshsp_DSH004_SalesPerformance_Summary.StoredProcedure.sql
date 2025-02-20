USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH004_SalesPerformance_Summary]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[dshsp_DSH004_SalesPerformance_Summary]
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
--  Parameters:     @Date: EOM Date to for monthly calculations
--					@GroupCode: CB or BW
--					@ExcludedAlpha: Outlets to excluded from report, if null nothing excluded
--					@IncludedAlpha: Outlets to be included in the report, if blank everything included. Exclusions override Inclusions
--   
--  Change History: 20180827 - ME - Created 
--					20190807 - DM - Adjusted to be able to include or Exclude specific Alpha (for WDC)
--                  
/****************************************************************************************************/

--uncomment to debug

	DECLARE @Country NVARCHAR(10) = 'AU'

	set @Date = IsNull(@Date, GetDate()-1)

	DECLARE @StartDate DATE = DateAdd(day, 1, EOMonth(@Date, -1)) --(SELECT CAST(DATEADD(MM,-6,GETDATE()) AS DATE))
	DECLARE @EndDate DATE = EOMonth(@Date,0)--(SELECT CAST(GETDATE() AS DATE))

	select @StartDate = CASE WHEN @StartDate <= '20181001' THEN '20181001' ELSE @StartDate END

	if object_id('tempdb..#Calendar') is not null
		drop table #Calendar

	SELECT CAST([Date] AS DATE) AS [Date],	
		   CONVERT(varchar(10), [Date], 112) as DateSK,
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
		   o.OutletName	
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

	SELECT d.Date,		
		   o.OutletAlphaKey,	
		   o.AlphaCode,
		   o.OutletName,	   
		   SUM(t.BudgetAmount) AS BudgetAmount
	INTO #Target
	FROM #outlets o
	cross join #Calendar d
	left join [db-au-cba].[dbo].[factPolicyTarget] t
			ON t.AlphaCode = o.alphaCode  AND t.DateSK = d.DateSK
	WHERE CAST(d.Date AS DATE) BETWEEN @StartDate AND @EndDate
	GROUP BY d.Date,		
			o.OutletAlphaKey,	
			o.AlphaCode,
			o.OutletName
	
	CREATE CLUSTERED INDEX [IX_Date] ON #Target
	(
		[Date] ASC
	)
		
	SELECT   c.MonthEnd	
			,c.Date
			,c.isWeekDay
			,c.isHoliday
			,c.isWeekEnd
			,t.AlphaCode	AS [Alpha Code]				
			,t.OutletName	AS [Outlet Name]
			,t.BudgetAmount	AS [Target]
			,cy.PolicyCount AS [Policy Count]
			,cy.SellPrice	AS [Sell Price]
			,py.PolicyCount	AS [YAGO Policy Count]
			,py.SellPrice	AS [YAGO Sell Price]	
	FROM  #Target t
	INNER JOIN #Calendar c
		ON t.Date = c.Date
	OUTER APPLY (	SELECT   SUM(pts.NewPolicyCount)	AS PolicyCount	
							,SUM(pts.GrossPremium)	AS SellPrice
					FROM  [db-au-cba].dbo.penPolicy p						
					INNER JOIN [db-au-cba].dbo.penPolicyTransSummary pts
						ON pts.PolicyKey = p.PolicyKey		
					WHERE CAST(pts.PostingDate AS DATE) = t.Date	
						AND p.OutletAlphaKey = t.OutletAlphaKey 
						and P.PolicyKey not in (select PolicyKey from #RemovedPolicies)) cy

	OUTER APPLY (	SELECT   SUM(pts.NewPolicyCount)	AS PolicyCount	
							,SUM(pts.GrossPremium)	AS SellPrice
					FROM  [db-au-cba].dbo.penPolicy p						
					INNER JOIN [db-au-cba].dbo.penPolicyTransSummary pts
						ON pts.PolicyKey = p.PolicyKey		
					WHERE CAST(pts.YAGOPostingDate AS DATE) = t.Date
						AND p.OutletAlphaKey = t.OutletAlphaKey 
						and P.PolicyKey not in (select PolicyKey from #RemovedPolicies)) py
								
end		
GO
