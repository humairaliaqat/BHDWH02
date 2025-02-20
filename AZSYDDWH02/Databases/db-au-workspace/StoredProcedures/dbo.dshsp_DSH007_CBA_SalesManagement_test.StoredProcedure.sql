USE [db-au-workspace]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH007_CBA_SalesManagement_test]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





/****************************************************************************************************/
--  Name			:	dshsp_DSH007_CBA_SalesManagement
--  Description		:	Claims call data report
--  Author			:	Dane Murray
--  Date Created	:	20180817
--  Parameters		:	@ReportingPeriod, @StartDate, @EndDate
--  Change History	:	 
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[dshsp_DSH007_CBA_SalesManagement_test]
	@SDate date = null,
	@EDate date = null
AS
begin
	set nocount on;
	--Uncomment to Debug
	--DECLARE @SDate date = '20181001',
	--		@EDate date = '20181031'

	IF OBJECT_ID('tempdb..#temp_Intv', 'U') IS NOT NULL 
	  DROP TABLE #temp_Intv;
	IF OBJECT_ID('tempdb..#temp_call1', 'U') IS NOT NULL 
	  DROP TABLE #temp_call1;
	IF OBJECT_ID('tempdb..#temp_telephonydata', 'U') IS NOT NULL 
	  DROP TABLE #temp_telephonydata;

	DECLARE @StartDate DATE,
			@EndDate DATE

	SELECT  @EndDate = IsNull(@EDate, DATEADD(day,-1,getdate()))
	SELECT	@StartDate = IsNUll(@SDate, DATEADD(day,-30, @EndDate)) -- get last 30 days data
	
	select *
	INTO #temp_Intv
	from [db-au-cba].[dbo].fn_GenerateDateIntervals(15, @StartDate, @EndDate)	

	
	select *
	INTO #temp_telephonydata
	from [db-au-cba].[dbo].[vTelephonyCallData]

	select 
	tc.[SessionID]
	,tc.[AgentName]
	,tc.[Team]
	,tc.[ApplicationName]
	,tc.[Company]
	,tc.[CSQName]
	,tc.[CallDate]
	,tc.[CallStartDateTime]
	,tc.[CallEndDateTime]
	,tc.[Disposition]
	,tc.[OriginatorNumber]
	,tc.[DestinationNumber]
	,tc.[CalledNumber]
	,tc.[OrigCalledNumber]
	,tc.[CallsPresented]
	,tc.[CallsHandled]
	,tc.[CallsAbandoned]
	,tc.[RingTime]
	,tc.[TalkTime]
	,tc.[HoldTime]
	,tc.[WorkTime]
	,tc.[WrapUpTime]
	,tc.[QueueTime]
	,tc.[MetServiceLevel]
	,tc.[Transfer]
	,tc.[Redirect]
	,tc.[Conference]
	,tc.[RNA]
	,tc.[IncludeInCSDashboard]
	,it.time
	,it.CallDate as CallDate1
	,it.DayofWeekNum 
	,it.DayOfWeek
	,cast(it.time as time(0)) as Interval
	,DENSE_RANK() over(PARTITION BY tc.SessionId ORDER BY tc.callenddatetime DESC) AS DenseRank  
	,@StartDate AS ReportStartDate
	,@EndDate AS ReportEndDate
	into #temp_call1
	from #temp_Intv  as it 
	LEFT OUTER JOIN #temp_telephonydata as tc 
		ON  
		--20181001, LL, use the index Luke
		tc.CallStartDateTime >= it.CallDateTimeStart and
		tc.CallStartDateTime <  it.CallDateTimeEnd 
		AND tc.Company = 'Commonwealth Bank'
		and tc.CSQName NOT in ('AU_CS_CBA_Existing_Claim','AU_CS_CBA_New_Claim','CC_CBA_Group')
	order by tc.CallDate 

	--delete from #temp_call1 where DenseRank <> 1

	select 
	tc1.[SessionID]
	,tc1.[AgentName]
	,tc1.[Team]
	,tc1.[ApplicationName]
	,tc1.[Company]
	,tc1.[CSQName]
	,tc1.[CallDate]
	,tc1.[CallStartDateTime]
	,tc1.[CallEndDateTime]
	,tc1.[Disposition]
	,tc1.[OriginatorNumber]
	,tc1.[DestinationNumber]
	,tc1.[CalledNumber]
	,tc1.[OrigCalledNumber]
	,tc1.[CallsPresented]
	,tc1.[CallsHandled]
	,tc1.[CallsAbandoned]
	,tc1.[RingTime]
	,tc1.[TalkTime]
	,tc1.[HoldTime]
	,tc1.[WorkTime]
	,tc1.[WrapUpTime]
	,tc1.[QueueTime]
	,tc1.[MetServiceLevel]
	,tc1.[Transfer]
	,tc1.[Redirect]
	,tc1.[Conference]
	,tc1.[RNA]
	,tc1.[IncludeInCSDashboard]
	,tc1.time
	,tc1.CallDate1
	,tc1.DayofWeekNum 
	,tc1.DayOfWeek
	,tc1.Interval
	,tc1.ReportStartDate
	,tc1.ReportEndDate
	from #temp_call1 as tc1
	order by [CallStartDateTime]
end

GO
