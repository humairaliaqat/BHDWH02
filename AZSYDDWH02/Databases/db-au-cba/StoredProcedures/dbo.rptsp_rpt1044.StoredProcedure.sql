USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rptsp_rpt1044]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[rptsp_rpt1044]
	@SDate date,
	@EDate date,
	@AbandonedQueueTime int = 20
AS
begin
	set nocount on
	--Uncomment to Debug
	--declare 
	--	@SDate date = '20181101',
	--	@EDate date = '20181130',
	--	@AbandonedQueueTime int = 20
	
	if object_id('tempdb..#Dates') is not null
		drop table #Dates

	select 'Custom' DateRange, @SDate StartDate, @EDate EndDate, C.Date
	into #Dates
	from Calendar C 
	WHERE C.Date between @SDate AND @EDate

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
	,CASE WHEN tc.CSQName in ('AU_CS_CBA_Existing_Claim','AU_CS_CBA_New_Claim','AU_CS_BW_Existing_Claim','AU_CS_BW_New_Claim') THEN 'Claims'
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
	from #Dates d 
	INNER JOIN [db-au-cba].[dbo].[vTelephonyCallData] as tc ON  tc.CallDate = d.Date
	where tc.Company IN ('Commonwealth Bank','BankWest')
	order by tc.CallDate 

	IF OBJECT_ID('tempdb..#Queues', 'U') IS NOT NULL 
		DROP TABLE #Queues;

	select 'Customer Service' as CallQueue
	into #Queues
	UNION ALL
	select 'Claims' as CallQueue
	UNION ALL
	select 'WTP' as CallQueue

	IF OBJECT_ID('tempdb..#Companies', 'U') IS NOT NULL 
	DROP TABLE #Companies;

	select 'Commonwealth Bank' as Company
	into #Companies
	union all 
	select'BankWest' as Company

	select	 P.StartDate
			,P.EndDate
			,P.Date
			,C.[Company]
			,Q.CallQueue
			,SUM(tc.CallsHandled) as [Calls Handled]
			,SUM(CASE WHEN tc.QueueTime <= @AbandonedQueueTime THEN 0 ELSE tc.CallsAbandoned END) as [Calls Abandoned]
			,Count(DISTINCT SessionID) as [Calls Presented]
			,SUM(IsNull(TalkTime,0) + IsNull(HoldTime,0) + IsNull(WorkTime,0)) as [Total Talk]
			,SUM(CallsHandled * QueueTime) as [Handled Queue Time]
			,SUM(CASE WHEN tc.QueueTime <= @AbandonedQueueTime THEN 0 ELSE QueueTime * CallsAbandoned END) as [Abandoned Queue Time]
			,SUM(CASE WHEN tc.QueueTime <= @AbandonedQueueTime THEN CallsAbandoned + CallsHandled ELSE 0 END) as [Calls in GOS]
	from #Dates p
	cross join #Queues Q
	cross join #Companies C
	left join #temp_call1 tc on p.Date = tc.Date AND Q.CallQueue = tc.CallQueue AND tc.Company = c.Company
	GROUP BY P.Date
			,Q.CallQueue
			,P.StartDate
			,P.EndDate
			,C.[Company]
	order by C.[Company], P.Date
end

GO
