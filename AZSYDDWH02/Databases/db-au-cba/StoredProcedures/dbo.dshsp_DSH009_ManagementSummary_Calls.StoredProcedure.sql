USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH009_ManagementSummary_Calls]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[dshsp_DSH009_ManagementSummary_Calls]
	@Date date,
	@AbandonedQueueTime int = 20
AS
begin
	set nocount on
	--Uncomment to Debug
	--declare 
	--	@Date date = '20181031',
	--	@AbandonedQueueTime int = 20
	
	if object_id('tempdb..#periods') is not null
		drop table #periods

	if object_id('tempdb..#DateRange') is not null
		drop table #DateRange

	select
		'Last Week' as DateRange,
		StartDate = dbo.fn_dtLastWeekStart(@Date),
		EndDate = dbo.fn_dtLastWeekEnd(@Date)
	into #DateRange
	UNION
	select
		'Month-To-Date' as DateRange,
		StartDate = dbo.fn_dtMTDStart(DateAdd(day,1,@Date)),
		EndDate = dbo.fn_dtMTDEnd(DateAdd(day,1,@Date))
	UNION
	select
		'Fiscal Year-To-Date' as DateRange,
		StartDate = dbo.fn_dtYTDFiscalStart(DateAdd(day,1,@Date)),
		EndDate = dbo.fn_dtYTDFiscalEnd(DateAdd(day,1,@Date))

	select D.DateRange, D.StartDate, D.EndDate, C.Date
	into #periods
	from #DateRange D
	JOIN Calendar C ON C.Date between D.StartDate AND D.EndDate

	if object_id('tempdb..#DDates') is not null
		drop table #DDates

	select DISTINCT Date
	into #DDates
	from #periods

	IF OBJECT_ID('tempdb..#temp_call1', 'U') IS NOT NULL 
	  DROP TABLE #temp_call1;

	select 
	d.Date
	,tc.[SessionID]
	,tc.[AgentName]
	,tc.[Team]
	,tc.[ApplicationName]
	,tc.[Company]
	,tc.[CSQName]
	,CASE WHEN tc.CSQName in ('AU_CS_BW_Existing_Claim','AU_CS_BW_New_Claim') THEN 'Claims'
		  WHEN tc.CSQName in ('CC_CBA_Group') THEN 'WTP'
		  else 'Customer Service' END as CallQueue
	,tc.[CallDate]
	,tc.[Disposition]
	,tc.[CallsPresented]
	,tc.[CallsHandled]
	,tc.[CallsAbandoned]
	,tc.[RingTime]
	,tc.[TalkTime]
	,tc.[HoldTime]
	,tc.[WorkTime]
	,tc.[WrapUpTime]
	,tc.[QueueTime]
	,DENSE_RANK() over(PARTITION BY tc.SessionId ORDER BY tc.callenddatetime DESC) AS DenseRank  
	into #temp_call1
	from #DDates d 
	INNER JOIN [db-au-cba].[dbo].[vTelephonyCallData] as tc ON  tc.CallDate = d.Date
	where tc.Company = 'BankWest'
	order by tc.CallDate 


	IF OBJECT_ID('tempdb..#Queues', 'U') IS NOT NULL 
		DROP TABLE #Queues;

	select 'Customer Service' as CallQueue
	into #Queues
	UNION ALL
	select 'Claims' as CallQueue
	UNION ALL
	select 'WTP' as CallQueue

	select	 P.DateRange
			,P.StartDate
			,P.EndDate
			,Q.CallQueue
			,SUM(tc.CallsHandled) as [Calls Handled]
			,SUM(CASE WHEN tc.QueueTime <= @AbandonedQueueTime THEN 0 ELSE tc.CallsAbandoned END) as [Calls Abandoned]
			,Count(DISTINCT SessionID) as [Calls Presented]
			,SUM(IsNull(TalkTime,0) + IsNull(HoldTime,0) + IsNull(WorkTime,0)) as [Total Talk]
			,SUM(CallsHandled * QueueTime) as [Handled Queue Time]
			,SUM(CASE WHEN tc.QueueTime <= @AbandonedQueueTime THEN 0 ELSE QueueTime * CallsAbandoned END) as [Abandoned Queue Time]
			,SUM(CASE WHEN tc.QueueTime <= @AbandonedQueueTime THEN CallsAbandoned + CallsHandled ELSE 0 END) as [Calls in GOS]
	from #periods p
	cross join #Queues Q
	left join #temp_call1 tc on p.Date = tc.Date AND Q.CallQueue = tc.CallQueue
	GROUP BY P.DateRange
			,Q.CallQueue
			,P.StartDate
			,P.EndDate
	order by P.DateRange
end

GO
