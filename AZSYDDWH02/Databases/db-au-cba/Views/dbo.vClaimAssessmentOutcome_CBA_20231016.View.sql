USE [db-au-cba]
GO
/****** Object:  View [dbo].[vClaimAssessmentOutcome_CBA_20231016]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE   view [dbo].[vClaimAssessmentOutcome_CBA_20231016] as        
select        
    cl.ClaimKey,        
    cl.ClaimNo,        
    cl.CreateDate,        
    cl.PolicyNo PolicyNumber,        
    isnull(ci.Paid, 0) Paid,        
    coalesce(cf.EventDescription, ce.EventDesc, '') EventDescription,        
    isnull(cf.EventLocation, '') EventLocation,        
    coalesce(cf.EventCountryName, ce.EventCountryName, '') EventCountryName,        
    case        
        when idr.IDRStatus in ('Active', 'Diarised') then 'Under Review'        
        when inv.InvestigationStatus in ('Active', 'Diarised') then 'Under Review'        
        when idr.IDRStatus = 'Complete' and isnull(idr.IDROutcome, '') <> '' then idr.IDROutcome        
        when inv.InvestigationStatus = 'Complete' and inv.InvestigationOutcome like '%fraud%' then 'Fraud detected'        
        when inv.InvestigationStatus = 'Complete' and inv.InvestigationOutcome like '%withdrawn%'         
  or e5.AssessmentOutcome = 'Claim Withdrawn' then 'Claim Withdrawn'        
        when e5.AssessmentOutcome = 'Under Excess' and isnull(FPPayments, 0) = 0 then 'Under Excess'        
        when isnull(FPPayments, 0) > 0 then 'Approved'        
        when e5.AssessmentOutcome = 'Deny' and isnull(FPPayments, 0) = 0 then 'Denied'        
        when e5.AssessmentOutcome = 'Approve' and isnull(FPPayments, 0) = 0 and isnull(TPPayments, 0) = 0 then 'Denied'        
        when e5.AssessmentOutcome = 'Approve' then 'Approved'        
        when e5.AssessmentOutcome = 'No action required' and isnull(FPPayments, 0) + isnull(TPPayments, 0) > 0 then 'Approved'        
        when e5.AssessmentOutcome = 'No action required' and isnull(FPPayments, 0) = 0 and isnull(TPPayments, 0) = 0 then 'Denied'        
        when e5.CaseStatus = 'Complete' and isnull(FPPayments, 0) + isnull(TPPayments, 0) > 0 then 'Approved'        
  -- Added 3 new AssessmentOutcome cases per INC0221634         
  when e5.AssessmentOutcome = 'Claim Under Excess' then 'Claim Under Excess'        
  --when e5.AssessmentOutcome = 'Claim Withdrawn' then 'Claim Withdrawn'        
  when e5.AssessmentOutcome = 'Partial Approval and Denial' then 'Partial Approval and Denial'        
        
        when e5.CaseStatus = 'Complete' and isnull(FPPayments, 0) = 0 and isnull(TPPayments, 0) = 0 then 'Denied'        
        when e5.CaseStatus in ('Active', 'Diarised') then 'Pending'        
        when e5.CaseStatus = 'Rejected' then 'Merged to other claim'        
        when cl.CreateDate < '2010-01-01' then 'Pre e5'        
        when e5.AssessmentOutcome is null and isnull(FPPayments, 0) = 0 and isnull(TPPayments, 0) = 0 then 'No assessment'        
        when e5.AssessmentOutcome is null and isnull(FPPayments, 0) + isnull(TPPayments, 0) > 0 then 'No assessment - Paid'        
        when e5.CaseID is null then 'No assessment'        
        
    end AssessmentOutcome,        
 --- start INC0221634  test        
 e5.VulnerableCustomerType as 'Vulnerable Customer Information',           
 e5.PrimaryDenialReason as 'Primary Denial Reason',         
 e5.SecondaryDenialReason as 'Secondary Denial Reason',        
 e5.TertiaryDenialReason as 'Tertiary Denial Reason',        
 e5.RespondComplaintLodged as 'Respond Complaint Lodged',        
 e5.ClaimWithdrawalReason as 'Claim Withdrawal Reason',        
 e5.FTG as 'FTG Applied',  
 e5.IndemnityDecision as 'Indemnity Decision',
    PrimaryClaimant,        
    'http://e5.covermore.com/sites/CoverMore/AU/_layouts/15/e5/WorkProcessFrame.aspx?source=FindWork&id=' + convert(varchar(50), e5.Original_Work_ID) e5URL        
from        
    [db-au-cba].[dbo].[clmClaim] cl with(nolock)        
    outer apply        
    (        
        select top 1         
            ce.EventDesc,        
            ce.EventCountryName        
        from        
            [db-au-cba].[dbo].[clmEvent] ce        
        where        
            ce.ClaimKey = cl.ClaimKey        
    ) ce        
    left join [db-au-cba].[dbo].[clmClaimFlags] cf with(nolock) on        
        cf.ClaimKey = cl.ClaimKey        
    outer apply        
    (        
        select         
            sum(ci.PaymentDelta) Paid        
        from        
            [db-au-cba].[dbo].vclmClaimIncurred ci with(nolock)        
        where        
            ci.ClaimKey = cl.ClaimKey        
    ) ci        
    outer apply        
    (        
        select top 1         
            cn.Firstname + ' ' + cn.Surname PrimaryClaimant        
        from        
            [db-au-cba].[dbo].clmName cn        
        where        
            cn.ClaimKey = cl.ClaimKey and        
            cn.isPrimary = 1        
    ) pcn        
    outer apply        
    (        
        select top 1         
            w.Work_ID CaseID,        
            w.Original_Work_ID,        
            w.Reference CaseReference,        
            w.StatusName CaseStatus,        
            AssessmentOutcome,        
------- start INC0221634  test        
        
 (select top 1 wi.Name from [db-au-cba].[dbo].e5WorkItems_v3 wi where wi.Domain = wi.Domain and wi.ID = wp.VulnerableCustomerType) as VulnerableCustomerType,        
 (select top 1 wi.Name from [db-au-cba].[dbo].e5WorkItems_v3 wi where wi.Domain = wi.Domain and wi.ID = wp.PrimaryDenialReason) as PrimaryDenialReason,        
 (select top 1 wi.Name from [db-au-cba].[dbo].e5WorkItems_v3 wi where wi.Domain = wi.Domain and wi.ID = wp.SecondaryDenialReason) as SecondaryDenialReason,        
 (select top 1 wi.Name from [db-au-cba].[dbo].e5WorkItems_v3 wi where wi.Domain = wi.Domain and wi.ID = wp.TertiaryDenialReason) as TertiaryDenialReason,        
 (select top 1 wi.Name from [db-au-cba].[dbo].e5WorkItems_v3 wi where wi.Domain = wi.Domain and wi.ID = wp.RespondComplaintLodged) as RespondComplaintLodged,        
 (select top 1 wi.Name from [db-au-cba].[dbo].e5WorkItems_v3 wi where wi.Domain = wi.Domain and wi.ID = wp.ClaimWithdrawalReason) as ClaimWithdrawalReason,       
 (select top 1 wi.Name from [db-au-cba].[dbo].e5WorkItems_v3 wi where wi.Domain = wi.Domain and wi.ID = wp.FTG) as FTG,
 (select top 1 wi.Name from [db-au-cba].[dbo].e5WorkItems_v3 wi where wi.Domain = wi.Domain and wi.ID = wp.IndemnityDecision) as IndemnityDecision
 ------- end INC0221634  test            
  from        
            [db-au-cba].[dbo].e5Work w with(nolock)        
            outer apply        
            (        
                select top 1        
                    wa.AssessmentOutcomeDescription AssessmentOutcome        
                from        
                    [db-au-cba].[dbo].e5WorkActivity wa with(nolock)        
                where        
                    wa.Work_ID = w.Work_ID and        
                    wa.CategoryActivityName = 'Assessment Outcome' and        
                    wa.CompletionDate is not null        
                order by        
                    wa.CompletionDate desc        
            ) wa        
------- start INC0221634  test        
    outer apply         
 (        
 select        
   max(case when Property_ID = 'VulnerableCustomerType' then try_convert(int, PropertyValue) else null end ) VulnerableCustomerType,        
   max(case when Property_ID = 'PrimaryDenialReason' then try_convert(int, PropertyValue) else null end ) PrimaryDenialReason,        
   max(case when Property_ID = 'SecondayDenialReason' then try_convert(int, PropertyValue) else null end ) SecondaryDenialReason,        
   max(case when Property_ID = 'TertiaryDenialReason' then try_convert(int, PropertyValue) else null end ) TertiaryDenialReason,        
   max(case when Property_ID = 'RespondComplaintLodged' then try_convert(int, PropertyValue) else null end ) RespondComplaintLodged,        
   max(case when Property_ID = 'ClaimWithdrawalReason' then try_convert(int, PropertyValue) else null end ) ClaimWithdrawalReason,      
   max(case when Property_ID = 'FTG' then try_convert(int, PropertyValue) else null end ) FTG,
   max(case when Property_ID = 'IndemnityDecision' then try_convert(int, PropertyValue) else null end ) IndemnityDecision
        from        
            [db-au-cba].[dbo].e5WorkProperties_v3 wp        
        where        
            wp.Work_ID = w.Work_ID and        
            wp.Property_ID in        
            (        
        
   'VulnerableCustomerType',        
    'PrimaryDenialReason',        
    'SecondayDenialReason',        
    'TertiaryDenialReason',        
    'RespondComplaintLodged',        
    'ClaimWithdrawalReason',      
    'FTG',
	'IndemnityDecision'       
            )        
   ) wp        
------- end INC0221634  test        
        
        where        
            w.ClaimKey = cl.ClaimKey and        
            w.WorkType = 'Claim'        
        order by        
            w.CreationDate desc        
    ) e5        
        
    outer apply        
    (        
        select top 1        
            w.StatusName IDRStatus,        
            w.Reference IDRReference,        
            w.Work_ID IDRID,        
            wa.Name IDROutcome        
        from        
            [db-au-cba].[dbo].e5Work w with(nolock)        
            outer apply        
            (        
                select top 1        
                    wi.Name        
                from        
                    [db-au-cba].[dbo].e5WorkActivity wa with(nolock)        
                    inner join [db-au-cba].[dbo].e5WorkActivityProperties wap with(nolock) on        
                        wap.WorkActivity_ID = wa.ID and        
                        wap.Property_ID = 'IDROutcome'        
                    inner join [db-au-cba].[dbo].e5WorkItems wi with(nolock) on        
                        wi.ID = wap.PropertyValue        
                where        
                    wa.Work_ID = w.Work_ID and        
                    wa.CategoryActivityName = 'IDR Outcome' and        
                    wa.CompletionDate is not null        
                order by        
                    wa.CompletionDate desc        
            ) wa        
        where        
            w.ClaimKey = cl.ClaimKey and        
            WorkType = 'Complaints' and        
            GroupType = 'IDR'        
        order by        
            CreationDate desc        
    ) idr        
    outer apply        
    (        
        select top 1        
            w.StatusName InvestigationStatus,        
            w.Reference InvestigationReference,        
            w.Work_ID InvestigationID,        
            wa.Name InvestigationOutcome        
        from        
            [db-au-cba].[dbo].e5Work w with(nolock)        
            outer apply        
            (        
                select top 1        
                    wi.Name        
                from        
                    [db-au-cba].[dbo].e5WorkActivity wa with(nolock)        
                    inner join [db-au-cba].[dbo].e5WorkActivityProperties wap with(nolock) on        
                        wap.WorkActivity_ID = wa.ID and        
                        wap.Property_ID = 'InvestigationOutcome'        
                    inner join [db-au-cba].[dbo].e5WorkItems wi with(nolock) on        
                        wi.ID = wap.PropertyValue        
                where        
                    wa.Work_ID = w.Work_ID and        
                    wa.CategoryActivityName = 'Investigation Outcome' and        
                    wa.CompletionDate is not null        
                order by        
                    wa.CompletionDate desc        
            ) wa        
        where        
            w.ClaimKey = cl.ClaimKey and        
            WorkType = 'Investigation'        
        order by        
            CreationDate desc        
    ) inv        
    outer apply        
    (        
        select         
            sum        
            (        
                case        
                    when isnull(cn.isThirdParty, 0) = 0 then cp.PaymentAmount        
                    else 0        
                end         
            ) FPPayments,        
            sum        
            (        
                case        
                    when isnull(cn.isThirdParty, 0) = 1 then cp.PaymentAmount        
                    else 0        
                end         
            ) TPPayments        
        from        
            [db-au-cba].[dbo].clmPayment cp with(nolock)        
            inner join [db-au-cba].[dbo].clmName cn with(nolock) on        
                cn.NameKey = cp.PayeeKey        
        where        
            cp.ClaimKey = cl.ClaimKey and        
            cp.PaymentStatus in ('APPR', 'PAID')        
    ) cp 
GO
