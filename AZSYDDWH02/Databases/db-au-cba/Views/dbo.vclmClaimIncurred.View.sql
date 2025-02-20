USE [db-au-cba]
GO
/****** Object:  View [dbo].[vclmClaimIncurred]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










create view [dbo].[vclmClaimIncurred]
as
with cte_incurred as
(
    select
        ClaimKey,
        IncurredDate,
        sum(EstimateMovement) EstimateMovement,
        sum(PaymentMovement) PaymentMovement,
        sum(EstimateMovement + PaymentMovement) IncurredMovement,
        sum(Redundant) RedundantMovements,
        sum(New) NewMovements,
        sum(Reopened) ReopenedMovements
    from
        (
            select
                case
                    when EstimateCategory = 'Redundant' and EstimateMovement <> 0 then 1
                    when EstimateCategory = 'Deleted' and EstimateMovement <> 0 then 1
                    else 0
                end Redundant,
                case
                    when EstimateCategory = 'New' and EstimateMovement <> 0 then 1
                    else 0
                end New,
                case
                    when EstimateCategory = 'Reopened' and EstimateMovement <> 0 then 1
                    when EstimateCategory = 'Progress on Nil' and EstimateMovement > 0 then 1
                    else 0
                end Reopened,
                ClaimKey,
                EstimateDate IncurredDate,
                EstimateMovement,
                0 PaymentMovement
            from
                clmClaimEstimateMovement

            union all

            select
                0 Redundant,
                0 New,
                0 Reopened,
                ClaimKey,
                PaymentDate,
                0 EstimateMovement,
                PaymentMovement + RecoveryPaymentMovement PaymentMovement
            from
                clmClaimPaymentMovement

        ) ci
    group by
        ClaimKey,
        IncurredDate
)
select
    ClaimKey,
    FirstIncurredDate,
    datediff(d, FirstIncurredDate, IncurredDate) AbsoluteAge,
    datediff(d, FirstIncurredDate, isnull(PreviousDate, IncurredDate)) PreviousAbsoluteAge,
    IncurredDate,
    datediff(d, isnull(PreviousDate, IncurredDate), IncurredDate) IncurredAge,
    Estimate,
    Paid,
    IncurredValue,
    Estimate - EstimateMovement PreviousEstimate,
    Paid - PaymentMovement PreviousPaid,
    IncurredValue - IncurredMovement PreviousIncurred,
    EstimateMovement EstimateDelta,
    PaymentMovement PaymentDelta,
    IncurredMovement IncurredDelta,
    t.RedundantMovements,
    NewMovements,
    ReopenedMovements,
    r.RedundantMovements - t.RedundantMovements PreviousRedundantMovements
from
    cte_incurred t
    cross apply
    (
        select
            sum(EstimateMovement) Estimate,
            sum(PaymentMovement) Paid,
            sum(IncurredMovement) IncurredValue,
            sum(RedundantMovements) RedundantMovements
        from
            cte_incurred r
        where
            r.ClaimKey = t.ClaimKey and
            r.IncurredDate <= t.IncurredDate
    ) r
    outer apply
    (
        select
            max(IncurredDate) PreviousDate
        from
            cte_incurred r
        where
            r.ClaimKey = t.ClaimKey and
            r.IncurredDate < t.IncurredDate
    ) pd
    outer apply
    (
        select
            min(IncurredDate) FirstIncurredDate
        from
            cte_incurred r
        where
            r.ClaimKey = t.ClaimKey
    ) fd










GO
