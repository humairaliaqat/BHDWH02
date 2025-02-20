USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[dshsp_DSH008_ManagementSummary_Test007]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO






/****************************************************************************************************/
--  Name			:	dshsp_DSH008_ManagementSummary
--  Description		:	Management Summary data report
--  Author			:	Dane Murray
--  Date Created	:	20181030
--  Parameters		:	@Date, 
--						@ExcludedAlpha: Outlets to excluded from report, if null nothing excluded
--						@IncludedAlpha: Outlets to be included in the report, if blank everything included. Exclusions override Inclusions
--
--  Change History	:	 
--					20190219 - DM - Adjusted logic for Channel Source Counts.
--					20190329 - DM - Adjusted logic Claim Incurred Values and included Online Claim submissions
--					20190807 - DM - Adjusted to be able to include or Exclude specific Alpha (for WDC)
/****************************************************************************************************/
CREATE proc [dbo].[dshsp_DSH008_ManagementSummary_Test007] 
	@Date date,
	@ExcludedAlpha varchar(100) = null,
	@IncludedAlpha varchar(100) = null
as
begin	
	set nocount on;
	--Uncomment to Debug
	--Declare @date date = '20190630'

	

	DECLARE @GroupCode varchar(10) = 'CB',
			@Country nvarchar(10) = 'AU';
			

	if object_id('tempdb..#periods') is not null
		drop table #periods

	if object_id('tempdb..#DateRange') is not null
		drop table #DateRange

	select * 
	into #DateRange
	from [db-au-cba].dbo.fn_ManagementSummaryPeriods(@Date) x

	select D.DateRange, D.StartDate, D.EndDate, C.Date
	into #periods
	from #DateRange D
	JOIN [db-au-cba].dbo.Calendar C  with(nolock) ON C.Date between D.StartDate AND D.EndDate

	if object_id('tempdb..#DDates') is not null
		drop table #DDates

	select DISTINCT Date
	into #DDates
	from #periods

	if object_id('tempdb..#Outlets') is not null
		drop table #Outlets

	select @ExcludedAlpha = NullIf(@ExcludedAlpha,''),
			@IncludedAlpha = NullIf(@IncludedAlpha,'')

	SELECT	o.SubGroupName, 
			o.OutletName, 
			o.OutletAlphaKey, 
			o.OutletKey, 
			o.CompanyKey
	into #Outlets
	from [db-au-cba].dbo.penOutlet o with(nolock)
	join [db-au-cba].[dbo].fn_DelimitedSplit8K(@IncludedAlpha,',') s on o.AlphaCode = IsNull(s.item, o.AlphaCode)
	where 
		o.GroupCode = @GroupCode
	AND o.countryKey = @Country
	AND o.OutletStatus = 'Current'
	AND o.AlphaCode not in (
			select item
			from [db-au-cba].[dbo].fn_DelimitedSplit8K(@ExcludedAlpha,',')
			where item is not null)

	CREATE NONCLUSTERED INDEX IX_1 ON #Outlets (OutletAlphaKey)	
if object_id('tempdb..#t') is not null
		drop table #t
select  ProductClassification, SaleType,
CASE cP.PlanCode 
						WHEN 'DMTS' THEN 'DSM' 
						WHEN 'DMTF' THEN 'DFM' 
						ELSE cP.PlanCode END PlanCode,
				 cP.ProductID,
				ppg.OutletAlphaKey
				into #t
				from [db-au-cba].dbo.[vPenPolicyPlanGroups]	 ppg with(nolock)
				join [db-au-cba].dbo.cdgProduct cP with(nolock) on ppg.ProductCode = cP.ProductCode 
	-- Quote Data
	if object_id('tempdb..#QuoteData') is not null
		drop table #QuoteData

if object_id('tempdb..#QD') is not null
		drop table #QD

	---;WITH QD as (
		SELECT   po.OutletAlphaKey
				,C.Date
				,cp.ProductClassification ProductName
				,cp.SaleType ProductClassification
				,COUNT(q.QuoteID)	as QuoteCount
		into #QD
	--	select count(1)
		FROM  #Outlets po
		INNER JOIN [db-au-cba].dbo.impQuotes q with(nolock) ON q.OutletAlphaKey = po.OutletAlphaKey
		INNER JOIN #DDates c ON q.QuoteDate = c.Date
	--	where q.Quotedate >= '20240101'
		outer apply (select top 1 ProductClassification, SaleType
				from #t t
				where q.quoteProductID = t.ProductID
				AND po.OutletAlphaKey = t.OutletAlphaKey
				) cp
		where q.Quotedate >= '20240101'
		GROUP BY po.OutletAlphaKey
				,C.Date	
				,cp.ProductClassification 
				,cp.SaleType
		UNION ALL
		SELECT   po.OutletAlphaKey
				,C.Date
				,pppg.ProductClassification ProductName
				,pppg.SaleType ProductClassification
				,COUNT(q.QuoteID)	as QuoteCount
		FROM  #Outlets po
		INNER JOIN [db-au-cba].dbo.penQuote q	with(nolock)					
			ON q.OutletAlphaKey = po.OutletAlphaKey
		INNER JOIN #DDates c ON q.CreateDate = c.Date
		LEFT join [db-au-cba].dbo.[vPenPolicyPlanGroups] pppg with(nolock)
			ON q.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
		where q.CreateDate >= '20240101'
		GROUP BY po.OutletAlphaKey
				,C.Date
				,pppg.ProductClassification 
				,pppg.SaleType
		
	select   OutletAlphaKey
			,Date
			,ProductName
			,ProductClassification
			,SUM(QuoteCount) as QuoteCount
	into #QuoteData
	from  #QD
	GROUP By OutletAlphaKey
			,Date
			,ProductName
			,ProductClassification

	-- Policy Data
	if object_id('tempdb..#RemovedPolicies') is not null
		drop table #RemovedPolicies

	select PolicyKey
	into #RemovedPolicies
	from [db-au-cba].dbo.penPolicyTransSummary with(nolock)
	group by PolicyKey
	having min(PostingDate) < '20240101'

	CREATE NONCLUSTERED INDEX IX_1 ON #RemovedPolicies (PolicyKey)
	if object_id('tempdb..#PolicyData') is not null
		drop table #PolicyData

	SELECT   po.OutletAlphaKey
			,C.Date
			,pppg.ProductClassification ProductName
			,pppg.SaleType ProductClassification
			,SUM(pts.BasePolicyCount)	AS PolicyCount
			,SUM(pts.TravellersCount) as TravellersCount
			,SUM(pts.GrossPremium) as GrossPremium
			,SUM(pta.AddonGrossPremium) as AddonGrossPremium
			,SUM(pts.Commission + pts.GrossAdminFee) as Commission
			,SUM(pta.AddonCount) as AddonCount
			,SUM(Case when crm.CRMUserID <> '' AND ip.cbaChannelID IS NULL then pts.BasePolicyCount END) as CMPhoneChannelSource
			,SUM(Case when crm.CRMUserID = '' AND ip.cbaChannelID IS NULL then pts.BasePolicyCount END) as CBAOnlineChannelSource
			,SUM(Case when ip.cbaChannelID = 'CBAAPP' then pts.BasePolicyCount END) as CBAAppSource
			,SUM(Case when ip.cbaChannelID = 'CBANB' then pts.BasePolicyCount END) as CBANBSource
	INTO #PolicyData
	--select COUNT(1)
	FROM  #Outlets po
	INNER JOIN [db-au-cba].dbo.penPolicy p	with(nolock)					
		ON p.OutletAlphaKey = po.OutletAlphaKey
	INNER JOIN [db-au-cba].dbo.penPolicyTransSummary pts with(nolock)
		ON pts.PolicyKey = p.PolicyKey	
	INNER JOIN #DDates C		
		ON CAST(pts.PostingDate AS DATE) = c.Date	
	LEFT JOIN [db-au-cba].dbo.[vPenPolicyPlanGroups] pppg with(nolock)
		ON p.UniquePlanID = pppg.UniquePlanId AND po.OutletAlphaKey = pppg.OutletAlphaKey
	outer apply (
		select SUM(pta.GrossPremium) as AddonGrossPremium,
				SUM(ptx.BasePolicyCount + ptx.AddonPolicyCount) as AddonCount
		from [db-au-cba].dbo.penPolicyTransAddOn pta with(nolock)
		join [db-au-cba].dbo.penPolicyTransSummary ptx with(nolock) on pta.PolicyTransactionKey = ptx.PolicyTransactionKey
		where pts.PolicyTransactionKey = pta.PolicyTransactionKey
	) pta
	outer apply
	(
		select top 1
			isnull(Convert(varchar(50),crm.CRMUserID),'') CRMUserID
		From
			[db-au-cba].dbo.penPolicyTransSummary crm with(nolock)
		where
			crm.PolicyKey = p.PolicyKey
		order by
			crm.IssueDate --base policy
	) crm
	left join [db-au-cba].dbo.impPolicies ip with(nolock) on p.PolicyKey = ip.PolicyKey
	left join #RemovedPolicies rp on p.PolicyKey=rp.PolicyKey
	where rp.PolicyKey is null
	--where P.PolicyKey not in (select PolicyKey from #RemovedPolicies)
	GROUP BY  po.OutletAlphaKey
			,C.Date
			,pppg.ProductClassification 
			,pppg.SaleType

	-- Claims Data
	if object_id('tempdb..#ClaimsData') is not null
		drop table #ClaimsData

		if object_id('tempdb..#t2') is not null
		drop table #t2

if object_id('tempdb..#claims_cte') is not null
		drop table #claims_cte

		select  IncurredValue,  Paid Paid,SectionKey ,IncurredDate 
		into #t2
		from [db-au-cba].dbo.vclmClaimSectionIncurred ci with(nolock)		
		where ci.IncurredDate <= @Date
		ORDER BY ci.IncurredDate desc
	--;with claims as (
		select cl.ClaimKey, cld.ReceiptDate
		into #claims_cte
		from [db-au-cba].dbo.clmClaim cl with(nolock)
		cross apply
        (
            select
                CAST(case
                    when cl.ReceivedDate is null then cl.CreateDate
                    when cl.ReceivedDate > dateadd(day, 1, convert(date, cl.CreateDate)) then cl.CreateDate
                    else cl.ReceivedDate
                end as Date) ReceiptDate
        ) cld
		inner join #DDates c on cld.ReceiptDate = c.Date
		union 
		select cl.ClaimKey, cld.ReceiptDate
		from [db-au-cba].dbo.clmClaim cl with(nolock)
		cross apply
        (
            select
                CAST(case
                    when cl.ReceivedDate is null then cl.CreateDate
                    when cl.ReceivedDate > dateadd(day, 1, convert(date, cl.CreateDate)) then cl.CreateDate
                    else cl.ReceivedDate
                end as Date) ReceiptDate
        ) cld
		inner join #DDates c on cl.FirstNilDate = c.Date

		if object_id('tempdb..#e5we') is not null
		drop table #e5we

	select Work_ID,EventDate,StatusName,EventUser,EventUserID,EventName
	into #e5we
		 from [db-au-cba].dbo.e5WorkEvent r with(nolock)
where 
						(
							(
								r.EventName in ('Changed Work Status', 'Merged Work') and
								isnull(r.EventUser, r.EventUserID) not in ('e5 Launch Service', 'svc-e5-prd-services')
							)
							or
							(
								--e5 Launch Service may cause a case to have total (Active Days + Diarised Days) > Absolute Age
								--this is due to [Saved Work] events with multiple [Status] occuring in same timestamp to ms
								--part of known issue revolving online claims in e5 v2
								r.EventName = 'Saved Work' and
								r.EventUser in ('e5 Launch Service', 'svc-e5-prd-services')
							)
						)
 
	select        
		cl.ClaimKey, 
		cl.ClaimNo as [Claim Number],  
		cl.OnlineClaim,
		o.OutletAlphaKey,
		o.SubGroupName,
		x.ReceiptDate as [Received Date],
		convert(date, ce.EventDate) as [Event Date],
		datediff(day,ce.EventDate,x.ReceiptDate) as [Notification lag],
		ci.IncurredValue as [Claim Value],					
		eh.FirstEstimateValue as [First Estimate Value],
		eh.FirstEstimateDate [First Estimate Date],
		pppg.ProductClassification	as ProductName,
		pppg.SaleType as ProductClassification,
		ca.AssessmentOutcome,
		case
			when cl.FirstNilDate is null then 0
			else 1
		end IsFinalised,
		case
			when cl.FirstNilDate is not null then 0
			else 1
		end IsPending,
		FirstNilDate,
		datediff(day, x.ReceiptDate, cl.FirstNilDate) as [Claim Finalised Age],
		ci.Paid,
		e5.ClaimActivityCount,
		e5.ActiveBusinessDays,
		e5.ActiveEvents,
		CASE WHEN IsNull(e5.ActiveEventTurnAroundDays,0) = 0 THEN 0 else CAST(e5.ActiveBusinessDays as float)/ CAST(e5.ActiveEventTurnAroundDays as float) end ClaimAvgTurnAroundTime
	into #ClaimsData
	
--select COUNT(1)
	from #claims_cte x
	join [db-au-cba].dbo.clmClaim cl with(nolock) on x.ClaimKey = cl.ClaimKey
	inner join [db-au-cba].dbo.penPolicyTransSummary pts with(nolock) on cl.PolicyTransactionKey = pts.PolicyTransactionKey
	inner join [db-au-cba].dbo.penPolicy p with(nolock) on pts.PolicyKey = p.PolicyKey
	inner join #Outlets o on p.OutletAlphaKey = o.OutletAlphaKey
	outer apply (
		select min(EventDate) as EventDate
		from [db-au-cba].dbo.clmEvent ce with(nolock)
		where ce.ClaimKey = cl.ClaimKey
	) ce
	left join [db-au-cba].dbo.[vPenPolicyPlanGroups] pppg with(nolock)
		ON p.UniquePlanID = pppg.UniquePlanId AND o.OutletAlphaKey = pppg.OutletAlphaKey
	left join [db-au-cba].dbo.vClaimAssessmentOutcome ca with(nolock) on ca.ClaimKey = cl.ClaimKey
	inner join [db-au-cba].dbo.clmSection cs with(nolock) on x.ClaimKey = cs.ClaimKey and cs.isDeleted = 0
	outer apply (
		select TOP 1 IncurredValue,  Paid Paid
		from #t2 ci 
		where ci.SectionKey = cs.SectionKey		
		ORDER BY ci.IncurredDate desc
	) ci
	outer apply
	(
		select top 1
			EHCreateDate FirstEstimateDate,
			SUM(EHEstimateValue) over(partition by cs.ClaimKey, eh.EHCreateDate) FirstEstimateValue
		from 
			[db-au-cba].dbo.clmEstimateHistory eh with(nolock)
		where
			eh.SectionKey = cs.SectionKey
		order by 
			EHCreateDate
	) eh
	outer apply (
		select	SUM(wa.ClaimActivityCount) as ClaimActivityCount,
				SUM(wdays.ActiveBusinessDays) as ActiveBusinessDays,
				SUM(wdays.ActiveEvents) as ActiveEvents,
				SUM(wdays.ActiveEventTurnAroundDays) as ActiveEventTurnAroundDays
		from [db-au-cba].dbo.e5Work w with(nolock)
		outer apply(
			select COUNT(*) as ClaimActivityCount
				from [db-au-cba].dbo.e5WorkActivity wa with(nolock)
				where w.Work_id  = wa.Work_ID			
			) wa
		outer apply
		(
			select
				sum(
					case
						when we.StatusName = 'Active' then datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate())))
						else 0
					end
				) ActiveDays,
				sum(
					case
						when we.StatusName = 'Diarised' then datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate())))
						else 0
					end
				) DiarisedDays,
				sum(
					case
						when we.StatusName = 'Active' then datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate()))) - OffDays
						else 0
					end
				) ActiveBusinessDays,
				sum(
					case
						when we.StatusName = 'Diarised' then datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate()))) - OffDays
						else 0
					end
				) DiarisedBusinessDays,
				sum(
					case
						when we.StatusName = 'Active' then 1
						else 0
					end
				) ActiveEvents,
				SUM(
					case
						when we.StatusName = 'Active' AND datediff(day, convert(date, we.EventDate), convert(date, isnull(nwe.NextChangeDate, getdate()))) - OffDays > 0 THEN 
							1
						else 0
					end 
				) ActiveEventTurnAroundDays
			from #e5we we
			---	[db-au-cba].dbo.e5WorkEvent we with(nolock)
				outer apply
				(
					select top 1
						r.EventDate NextChangeDate    
					from #e5we r
					--	[db-au-cba].dbo.e5WorkEvent r with(nolock)
					where
						r.Work_Id = w.Work_ID and
						r.EventDate > we.EventDate 
					order by
						r.EventDate
				) nwe
				outer apply
				(
					select
						count(d.[Date]) OffDays
					from
						[db-au-cba].dbo.Calendar d  with(nolock)
					where
						d.[Date] >= convert(date, we.EventDate) and
						d.[Date] <  convert(date, isnull(nwe.NextChangeDate, getdate())) and
						(
							d.isHoliday = 1 or
							d.isWeekEnd = 1
						)
				) phd
			where
				we.Work_ID = w.Work_ID and
				(
					(
						we.EventName in ('Changed Work Status', 'Merged Work') and
						isnull(we.EventUser, we.EventUserID) not in ('e5 Launch Service', 'svc-e5-prd-services')
					)
					or
					(
						we.EventName = 'Saved Work' and
						we.EventUser in ('e5 Launch Service', 'svc-e5-prd-services')
					)
				) and
				we.StatusName in ('Active', 'Diarised')
		) wdays
		where w.ClaimKey = cl.ClaimKey
		AND w.WorkType = 'Claim'
	) e5

	--select * from #ClaimsData
	

	if object_id('tempdb..#ResultGroups') is not null
		drop table #ResultGroups

	select p.DateRange, p.Date, po.SubGroupName, po.OutletName, po.OutletAlphaKey, pppg.ProductName, pppg.ProductClassification
	into #ResultGroups
	from #Outlets po
	cross join #periods p
	cross apply (
		SELECT DISTINCT OutletAlphaKey,ProductClassification as ProductName, SaleType as ProductClassification 
		from [db-au-cba].dbo.vPenPolicyPlanGroups x  with(nolock)
		where po.OutletAlphaKey = x.OutletAlphaKey
		UNION ALL
		SELECT po.OutletAlphaKey, 'Unknown', 'Unknown'
		) pppg

	if object_id('tempdb..#Results') is not null
		drop table #Results

	select	RG.DateRange, 
			RG.Date, 
			RG.SubGroupName, 
			RG.OutletName, 
			RG.OutletAlphaKey, 
			RG.ProductName, 
			RG.ProductClassification, 
			QD.QuoteCount,
			PD.PolicyCount, 
			PD.TravellersCount, 
			PD.GrossPremium, 
			PD.AddonGrossPremium, 
			PD.Commission,
			PD.AddonCount,
			PD.CMPhoneChannelSource,
			PD.CBAOnlineChannelSource,
			PD.CBAAppSource,
			PD.CBANBSource,
			CR.[First Estimate Value],
			CR.ClaimCount,
			CR.[Notification lag],
			CR.[Claim Value],
			CR.[Online Claims],
			CF.FinalisedClaimCount,
			CF.ApprovedCount,
			CF.DeniedCount,
			CF.FraudDetectedCount,
			CF.OtherCount,
			CF.PaidAmount,
			CF.MaximumPaid,
			CF.[Claim Finalised Age],
			CR.ClaimActivityCount,
			CF.FinalisedClaimActivityCount,
			CF.ActiveBusinessDays,
			CF.ActiveEvents,
			CF.ClaimAvgTurnAroundTime
	into #Results
	from #ResultGroups RG
	LEFT JOIN #QuoteData QD ON RG.Date = QD.Date
		AND RG.OutletAlphaKey = QD.OutletAlphaKey
		AND RG.ProductName = IsNull(QD.ProductName, 'Unknown')
		AND RG.ProductClassification = IsNull(QD.ProductClassification, 'Unknown')
	left join #PolicyData PD on RG.Date = PD.Date
			AND RG.OutletAlphaKey = PD.OutletAlphaKey
			AND RG.ProductName = IsNull(PD.ProductName, 'Unknown')
			AND RG.ProductClassification = IsNull(PD.ProductClassification, 'Unknown')
	outer apply
		(select SUM([First Estimate Value]) [First Estimate Value],
				COUNT(DISTINCT ClaimKey) as ClaimCount,
				sum([Notification lag]) as [Notification lag],
				sum([Claim Value]) as [Claim Value],
				sum(ClaimActivityCount) as ClaimActivityCount,
				COUNT(DISTINCT CASE WHEN CR.OnlineClaim = 1 THEN Cr.ClaimKey END) as [Online Claims]
		from #ClaimsData CR
		WHERE RG.Date = CR.[Received Date]
			and RG.OutletAlphaKey = CR.OutletAlphaKey
			AND RG.ProductName = IsNull(CR.ProductName, 'Unknown')
			AND RG.ProductClassification = IsNull(CR.ProductClassification, 'Unknown')) CR
	outer apply
		(select COUNT(DISTINCT ClaimKey) as FinalisedClaimCount,
				sum([Claim Finalised Age]) as [Claim Finalised Age],
				COUNT(DISTINCT CASE WHEN AssessmentOutcome = 'Approved' and IsFinalised = 1 THEN ClaimKey END) as ApprovedCount,
				COUNT(DISTINCT CASE WHEN AssessmentOutcome = 'Denied' and IsFinalised = 1 THEN ClaimKey END) as DeniedCount,
				COUNT(DISTINCT CASE WHEN AssessmentOutcome = 'Fraud detected' and IsFinalised = 1 THEN ClaimKey END) as FraudDetectedCount,
				COUNT(DISTINCT CASE WHEN AssessmentOutcome NOT IN ('Approved','Denied','Fraud detected') and IsFinalised = 1 THEN ClaimKey END) as OtherCount,
				--SUM(CASE AssessmentOutcome WHEN 'Approved' THEN IsFinalised else 0 END) as ApprovedCount,
				--SUM(CASE AssessmentOutcome WHEN 'Denied' THEN IsFinalised else 0 END) as DeniedCount,
				--SUM(CASE AssessmentOutcome WHEN 'Fraud detected' THEN IsFinalised else 0 END) as FraudDetectedCount,
				--SUM(CASE WHEN AssessmentOutcome NOT IN ('Approved','Denied','Fraud detected') THEN IsFinalised else 0 END) as OtherCount,
				sum(paid) as PaidAmount,
				max(x.totalPaid) as MaximumPaid,
				sum(ClaimActivityCount) as FinalisedClaimActivityCount,
				sum(cr.ActiveBusinessDays) ActiveBusinessDays,
				sum(cr.ActiveEvents) as ActiveEvents,
				SUM(cr.ClaimAvgTurnAroundTime) as ClaimAvgTurnAroundTime
		from #ClaimsData CR
		outer apply (
			select sum(paid) as totalPaid
			from #ClaimsData x
			where cr.ClaimKey = x.ClaimKey
		) x
		WHERE RG.Date = CR.FirstNilDate
			and RG.OutletAlphaKey = CR.OutletAlphaKey
			AND RG.ProductName = IsNull(CR.ProductName, 'Unknown')
			AND RG.ProductClassification = IsNull(CR.ProductClassification, 'Unknown')) CF

truncate table [dbo].Tableau_performance
insert into [dbo].Tableau_performance

	select *  
	from #Results
	order by DateRange, Date

	end




GO
