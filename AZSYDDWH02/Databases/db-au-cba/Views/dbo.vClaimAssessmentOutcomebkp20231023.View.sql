USE [db-au-cba]
GO
/****** Object:  View [dbo].[vClaimAssessmentOutcomebkp20231023]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[vClaimAssessmentOutcomebkp20231023] as
select --top 1000
    cl.ClaimKey,
    cl.ClaimNo,
    cl.CreateDate,
    cl.PolicyNo PolicyNumber,
    isnull(ci.Paid, 0) Paid,
    coalesce(coe.Detail, ce.EventDesc, '') EventDescription,
    isnull(coe.EventLocation, '') EventLocation,
    coalesce(coe.EventCountry, ce.EventCountryName, '') EventCountryName,
    case
        when idr.IDRStatus in ('Active', 'Diarised') then 'Under Review'
        when inv.InvestigationStatus in ('Active', 'Diarised') then 'Under Review'
        when idr.IDRStatus = 'Complete' and isnull(idr.IDROutcome, '') <> '' then idr.IDROutcome
        when inv.InvestigationStatus = 'Complete' and inv.InvestigationOutcome like '%fraud%' then 'Fraud detected'
        when inv.InvestigationStatus = 'Complete' and inv.InvestigationOutcome like '%withdrawn%' then 'Claim withdrawn'
        when e5.AssessmentOutcome = 'Under Excess' and isnull(FPPayments, 0) = 0 then 'Under Excess'
        when isnull(FPPayments, 0) > 0 then 'Approved'
        when e5.AssessmentOutcome = 'Deny' and isnull(FPPayments, 0) = 0 then 'Denied'
        when e5.AssessmentOutcome = 'Approve' and isnull(FPPayments, 0) = 0 and isnull(TPPayments, 0) = 0 then 'Denied'
        when e5.AssessmentOutcome = 'Approve' then 'Approved'
        when e5.AssessmentOutcome = 'No action required' and isnull(FPPayments, 0) + isnull(TPPayments, 0) > 0 then 'Approved'
        when e5.AssessmentOutcome = 'No action required' and isnull(FPPayments, 0) = 0 and isnull(TPPayments, 0) = 0 then 'Denied'
        when e5.CaseStatus = 'Complete' and isnull(FPPayments, 0) + isnull(TPPayments, 0) > 0 then 'Approved'
        when e5.CaseStatus = 'Complete' and isnull(FPPayments, 0) = 0 and isnull(TPPayments, 0) = 0 then 'Denied'
        when e5.CaseStatus in ('Active', 'Diarised') then 'Pending'
        when e5.CaseStatus = 'Rejected' then 'Merged to other claim'
        when cl.CreateDate < '2010-01-01' then 'Pre e5'
        when e5.AssessmentOutcome is null and isnull(FPPayments, 0) = 0 and isnull(TPPayments, 0) = 0 then 'No assessment'
        when e5.AssessmentOutcome is null and isnull(FPPayments, 0) + isnull(TPPayments, 0) > 0 then 'No assessment - Paid'
        when e5.CaseID is null then 'No assessment'
    end AssessmentOutcome,
    PrimaryClaimant,
    'http://e5.covermore.com/sites/CoverMore/AU/_layouts/15/e5/WorkProcessFrame.aspx?source=FindWork&id=' + convert(varchar(50), e5.Original_Work_ID) e5URL
from
    clmClaim cl with(nolock)
    outer apply
    (
        select top 1 
            ce.EventDesc,
            ce.EventCountryName
        from
            clmEvent ce
        where
            ce.ClaimKey = cl.ClaimKey
    ) ce
	left join [clmOnlineClaimEvent] coe on
                coe.ClaimKey = cl.ClaimKey
    --left join clmClaimFlags cf with(nolock) on
    --    cf.ClaimKey = cl.ClaimKey
    outer apply
    (
        select 
            sum(ci.PaymentDelta) Paid
        from
            vclmClaimIncurred ci with(nolock)
        where
            ci.ClaimKey = cl.ClaimKey
    ) ci
    outer apply
    (
        select top 1 
            cn.Firstname + ' ' + cn.Surname PrimaryClaimant
        from
            clmName cn
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
            AssessmentOutcome
        from
            e5Work w with(nolock)
            outer apply
            (
                select top 1
                    wa.AssessmentOutcomeDescription AssessmentOutcome
                from
                    e5WorkActivity wa with(nolock)
                where
                    wa.Work_ID = w.Work_ID and
                    wa.CategoryActivityName = 'Assessment Outcome' and
                    wa.CompletionDate is not null
                order by
                    wa.CompletionDate desc
            ) wa
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
            e5Work w with(nolock)
            outer apply
            (
                select top 1
                    wi.Name
                from
                    e5WorkActivity wa with(nolock)
                    inner join e5WorkActivityProperties wap with(nolock) on
                        wap.WorkActivity_ID = wa.ID and
                        wap.Property_ID = 'IDROutcome'
                    inner join e5WorkItems wi with(nolock) on
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
            e5Work w with(nolock)
            outer apply
            (
                select top 1
                    wi.Name
                from
                    e5WorkActivity wa with(nolock)
                    inner join e5WorkActivityProperties wap with(nolock) on
                        wap.WorkActivity_ID = wa.ID and
                        wap.Property_ID = 'InvestigationOutcome'
                    inner join e5WorkItems wi with(nolock) on
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
            clmPayment cp with(nolock)
            inner join clmName cn with(nolock) on
                cn.NameKey = cp.PayeeKey
        where
            cp.ClaimKey = cl.ClaimKey and
            cp.PaymentStatus in ('APPR', 'PAID')
    ) cp






GO
