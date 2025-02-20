USE [db-au-star]
GO
/****** Object:  View [dbo].[vdimClaim]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE view [dbo].[vdimClaim]
as
select --top 1000
    cl.ClaimSK,
    cl.ClaimKey,
    cl.PolicyTransactionKey,
    cl.ClaimNo,
    cl.DevelopmentDay,
    case
        when cl.ReceiptDate < '2001-01-01' then '2000-01-01'
        else cl.ReceiptDate
    end ReceiptDate,
    cl.RegisterDate,
    case
        when cl.EventDate < '2001-01-01' then '2000-01-01'
        else cl.EventDate
    end EventDate,
    case
        when cl.FirstNilDate < '2001-01-01' then '2000-01-01'
        else cl.FirstNilDate
    end FirstNilDate,
    cl.LastNilDate,
    case
        when cl.FirstPaymentDate < '2001-01-01' then '2000-01-01'
        else cl.FirstPaymentDate
    end FirstPaymentDate,
    cl.LastPaymentDate,
    cl.LodgementType,
    cl.OnlineLodgementType,
    cl.CustomerCareType,
    cl.WorkType,
    cl.WorkGroupType,
    cl.WorkStatus,
    cl.TimeInStatus,
    cl.AbsoluteAge,
    case
        when cl.AbsoluteAge <= 14 then '< 14'
        when cl.AbsoluteAge <= 30 then '15 - 30'
        when cl.AbsoluteAge <= 60 then '31 - 60'
        when cl.AbsoluteAge <= 90 then '61 - 90'
        else '91+'
    end AbsoluteAgeBand,
    case
        when cl.AbsoluteAge <= 14 then 14
        when cl.AbsoluteAge <= 30 then 30
        when cl.AbsoluteAge <= 60 then 60
        when cl.AbsoluteAge <= 90 then 90
        else 91
    end AbsoluteAgeBandKey,
    cl.Assignee,
    cl.ReopenCount,
    cl.DiarisedCount,
    cl.ReassignCount,
    cl.DeclinedCount,
    cl.FirstNilLag,
    cl.FirstPaymentLag,
    cl.LastPaymentLag,
    cl.CreateBatchID,
    cl.UpdateBatchID,
    cl.OtherClaimsOnPolicy,
    isnull(ci.LastIncurredValue, 0) LastIncurredValue,
    case
        when isnull(ci.LastIncurredValue, 0) <= 1000 then '0 - 1K'
        when isnull(ci.LastIncurredValue, 0) <= 5000 then '1 - 5K'
        when isnull(ci.LastIncurredValue, 0) <= 15000 then '5 - 15K'
        when isnull(ci.LastIncurredValue, 0) <= 25000 then '15K - 25K'
        when isnull(ci.LastIncurredValue, 0) <= 75000 then '25K - 75K'
        when isnull(ci.LastIncurredValue, 0) <= 200000 then '75K - 200K'
        when isnull(ci.LastIncurredValue, 0) <= 500000 then '200K - 500K'
        else '+500K'
    end LastIncurredBand,
    case
        when isnull(ci.LastIncurredValue, 0) <= 1000 then 1500
        when isnull(ci.LastIncurredValue, 0) <= 5000 then 5000
        when isnull(ci.LastIncurredValue, 0) <= 15000 then 15000
        when isnull(ci.LastIncurredValue, 0) <= 25000 then 25000
        when isnull(ci.LastIncurredValue, 0) <= 75000 then 75000
        when isnull(ci.LastIncurredValue, 0) <= 200000 then 200000
        when isnull(ci.LastIncurredValue, 0) <= 500000 then 500000
        else 500001
    end LastIncurredBandKey,
    case
        when pcna.PrimaryClaimantAgeAtClaim is null then -1
        when pcna.PrimaryClaimantAgeAtClaim < 0 then -1
        when pcna.PrimaryClaimantAgeAtClaim > 130 then -1
        else pcna.PrimaryClaimantAgeAtClaim
    end PrimaryClaimantAgeAtClaim,
    isnull(mac.MAClassification, 'Other') MAClassification
from
    dimClaim cl
    outer apply
    (
        select 
            sum(IncurredDelta) LastIncurredValue
        from
            [db-au-cba]..vclmClaimIncurred ci
        where
            ci.ClaimKey = cl.ClaimKey
    ) ci
    outer apply
    (
        select top 1
            cn.DOB PrimaryDOB
        from
            [db-au-cba]..clmName cn
        where
            cn.ClaimKey = cl.ClaimKey and
            cn.isPrimary = 1
    ) pcn
    outer apply
    (
        select
            case
                when pcn.PrimaryDOB is null then -1
                else
                    floor(
                        (
                            datediff(month, pcn.PrimaryDOB, cl.RegisterDate) -
                            case
                                when datepart(day, cl.RegisterDate) < datepart(day, pcn.PrimaryDOB) then 1
                                else 0
                            end
                        ) /
                        12
                    )
            end PrimaryClaimantAgeAtClaim
    ) pcna
    outer apply
    (
        select
            case
                when 
                    exists
                    ( 
                        select
                            null
                        from
                            [db-au-cba]..clmClaim rcl with(nolock)
                            inner join [db-au-cba]..cbCase cc with(nolock) on
                                cc.CaseKey = rcl.CaseKey
                        where
                            rcl.ClaimKey = cl.ClaimKey and
                            (
                                cc.CaseType like 'Repat%' 
                            )
                    )
                then 'Repatriation'
                when 
                    exists
                    (
                        select
                            null
                        from
                            [db-au-cba]..clmClaim rcl with(nolock)
                            inner join [db-au-cba]..cbCase cc with(nolock) on
                                cc.CaseKey = rcl.CaseKey
                        where
                            rcl.ClaimKey = cl.ClaimKey and
                            (
                                cc.CaseType like 'Evacuation%' or
                                exists
                                (
                                    select
                                        null
                                    from
                                        [db-au-cba]..cbNote cn with(nolock)
                                    where
                                        cn.CaseKey = cc.CaseKey and
                                        cn.NoteType like 'EVAC%'
                                )
                            )
                    )
                then 'Evacuation'
                when 
                    exists
                    ( 
                        select
                            null
                        from
                            [db-au-cba]..clmClaim rcl with(nolock)
                            inner join [db-au-cba]..cbCase cc with(nolock) on
                                cc.CaseKey = rcl.CaseKey
                        where
                            rcl.ClaimKey = cl.ClaimKey and
                            (
                                cc.CaseType like 'Inpatient%' or
                                (
                                    cc.CaseType like 'Complex%' and
                                    cc.Protocol like 'Medical%'
                                ) or
                                exists
                                (
                                    select
                                        null
                                    from
                                        [db-au-cba]..cbNote cn with(nolock)
                                    where
                                        cn.CaseKey = cc.CaseKey and
                                        cn.NoteType like 'MEDICAL%'
                                )
                            )
                    )
                then 'Inpatient'
                when 
                    exists
                    ( 
                        select
                            null
                        from
                            [db-au-cba]..clmClaim rcl with(nolock)
                            inner join [db-au-cba]..cbCase cc with(nolock) on
                                cc.CaseKey = rcl.CaseKey
                        where
                            rcl.ClaimKey = cl.ClaimKey and
                            (
                                cc.CaseType like 'Outpatient%' or
                                (
                                    cc.CaseType like 'Simple%' and
                                    cc.Protocol like 'Medical%'
                                )
                            )
                    )
                then 'Outpatient'
                else 'Other'
            end MAClassification
    ) mac


GO
