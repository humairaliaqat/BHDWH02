USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH006_CBA_ClaimsManagement_GOS]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


/****************************************************************************************************/
--  Name			:	dshsp_DSH006_CBA_ClaimsManagement_GOS
--  Description		:	Claims call data report
--  Author			:	Dane Murray
--  Date Created	:	20180928
--  Parameters		:	@StartDate, @EndDate
--  Change History	:	 
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[dshsp_DSH006_CBA_ClaimsManagement_GOS]
	@SDate date = null,
	@EDate date = null
AS
begin

set nocount on

	IF OBJECT_ID('tempdb..#temp_Intv', 'U') IS NOT NULL 
	  DROP TABLE #temp_Intv;
	IF OBJECT_ID('tempdb..#temp_call1', 'U') IS NOT NULL 
	  DROP TABLE #temp_call1;

	DECLARE @StartDate DATE,
			@EndDate DATE

	SELECT  @EndDate = IsNull(@EDate, DATEADD(day,-1,getdate()))
	SELECT	@StartDate = IsNUll(@SDate, DATEADD(day,-30, @EndDate)) -- get last 30 days data
	
	select *
	INTO #temp_Intv
	from dbo.fn_GenerateDateIntervals(15, @StartDate, @EndDate)	

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
	,it.time
	,it.CallDate as CallDate1
	,it.DayofWeekNum 
	,it.DayOfWeek
	,cast(it.time as time(0)) as Interval
	,DENSE_RANK() over(PARTITION BY tc.SessionId ORDER BY tc.callenddatetime DESC) AS DenseRank  
	into #temp_call1
	from #temp_Intv  as it 
	LEFT OUTER JOIN [db-au-cba].[dbo].[vTelephonyCallData] as tc 
		ON  
		--20181001, LL, use the index Luke
		tc.CallStartDateTime >= it.CallDateTimeStart and
		tc.CallStartDateTime <  it.CallDateTimeEnd
		AND tc.Company = 'Commonwealth Bank'
		and tc.CSQName in ('AU_CS_CBA_Existing_Claim','AU_CS_CBA_New_Claim')
	order by tc.CallDate 

	--delete from #temp_call1 where DenseRank <> 1

	select  Z.KPI as KPI, 
			X.Path, 
			Z.Value,
			Z.Handled,
			Z.TotalCalls
	from 
	(
		select 1 as Path
		union 
		select 360 as path
	) X
	cross join (
		select 'KPI' as KPI, 
				0.8 as Value,
				0.0 as Handled,
				0.0 as TotalCalls
		union 
		select 'Actual' as KPI, 
				CAST(SUM(CASE WHEN QueueTime <= 20 then CallsPresented else 0 END) as float)  / nullif(cast(COUNT(DISTINCT SessionID ) as float),0) as Value,
				CAST(SUM(CASE WHEN QueueTime <= 20 then CallsHandled else 0 END) as float) as Handled,
				CAST(COUNT(DISTINCT SessionID ) as  float) as TotalCalls
			from (
		select	sessionID,
				QueueTime,
				CallDate,
				CallsPresented,
				CallsHandled
		from #temp_call1 as tc
		) as tc_data
	) Z
end 
GO
