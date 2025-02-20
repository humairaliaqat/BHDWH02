USE [db-au-cba]
GO
/****** Object:  View [dbo].[vclmClaimIncurredIntraDay]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create view [dbo].[vclmClaimIncurredIntraDay]
as
select
    *
from
    clmClaimIntradayMovement
--select
--    ClaimKey,
--    --RowNum,
--    FirstIncurredDate,
--    datediff(d, FirstIncurredDate, IncurredDate) AbsoluteAge,
--    datediff(d, FirstIncurredDate, isnull(PreviousDate, IncurredDate)) PreviousAbsoluteAge,
--    IncurredDate,
--    IncurredTime,
--    datediff(d, isnull(PreviousDate, IncurredDate), IncurredDate) IncurredAge,
--    Estimate,
--    Paid,
--    IncurredValue,
--    Estimate - EstimateMovement PreviousEstimate,
--    Paid - PaymentMovement PreviousPaid,
--    IncurredValue - IncurredMovement PreviousIncurred,
--    EstimateMovement EstimateDelta,
--    PaymentMovement PaymentDelta,
--    IncurredMovement IncurredDelta,
--    case
--        --the first incurred movement is an open
--        when FirstMovement = 1 then 1
--        else 0
--    end NewCount,
--    case
--        --the first incurred movement is an open, thus it's not a reopen
--        when FirstMovement = 1 then 0
--        --if new estimate is now positive from previous estimate that's 0 and there has been negative estimate movement (i.e. closed) then it's a reopen
--        when
--            Estimate > 0 and
--            (Estimate - EstimateMovement) = 0 and
--            exists
--            (
--                select
--                    null
--                from
--                    clmClaimIncurredMovement r
--                where
--                    r.ClaimKey = t.ClaimKey and
--                    r.IncurredDate <= t.IncurredDate and
--                    r.IncurredTime < t.IncurredTime and
--                    r.EstimateMovement < 0
--            )
--        then 1
--        --if the estimate is 0 and there's no estimate movement on the day, the first payment of the day is a reopen (to be closed at the same time), as long as it's not an open
--        when
--            Estimate = 0 and
--            not exists
--            (
--                select
--                    null
--                from
--                    clmClaimIncurredMovement r
--                where
--                    r.ClaimKey = t.ClaimKey and
--                    r.IncurredDate = t.IncurredDate and
--                    r.EstimateMovement <> 0
--            ) and
--            PaymentMovement > 0 and
--            FirstMovement = 0 and
--            FirstMovementInDay = 1
--        then 1
--        else 0
--    end ReopenedCount,
--    case
--        --estimate movement to 0 or below from non 0 estimate is a close
--        when Estimate <= 0 and (Estimate - EstimateMovement) <> 0 then 1
--        --if the estimate is 0 and there's no estimate movement on the day, the first payment of the day is a reopen (to be closed at the same time), as long as it's not an open
--        when
--            Estimate = 0 and
--            not exists
--            (
--                select
--                    null
--                from
--                    clmClaimIncurredMovement r
--                where
--                    r.ClaimKey = t.ClaimKey and
--                    r.IncurredDate = t.IncurredDate and
--                    r.EstimateMovement <> 0
--            ) and
--            PaymentMovement > 0 and
--            FirstMovement = 0 and
--            FirstMovementInDay = 1
--        then 1
--        --if there's only 1 record ever and it's been a while and estimate = 0 then it's a close
--        when
--            Estimate = 0 and
--            IncurredDate < dateadd(month, -4, getdate()) and
--            count(IncurredDate) over (partition by ClaimKey) = 1
--        then 1
--        --if it's an old record with no positive estimate movement, the first one (open) is also a close
--        when
--            not exists
--            (
--                select
--                    null
--                from
--                    clmClaimIncurredMovement r
--                where
--                    r.ClaimKey = t.ClaimKey and
--                    r.EstimateMovement > 0
--            ) and
--            IncurredDate < dateadd(month, -4, getdate()) and
--            FirstMovement = 1
--        then 1
--        else 0
--    end ClosedCount
--from
--    clmClaimIncurredMovement t
--    cross apply
--    (
--        select
--            (EstimateMovement + PaymentMovement) IncurredMovement
--    ) i
--    cross apply
--    (
--        select
--            sum(EstimateMovement) Estimate,
--            sum(PaymentMovement) Paid,
--            sum(EstimateMovement + PaymentMovement) IncurredValue
--        from
--            clmClaimIncurredMovement r
--        where
--            r.ClaimKey = t.ClaimKey and
--            r.IncurredDate <= t.IncurredDate and
--            r.IncurredTime <= t.IncurredTime
--    ) r
--    outer apply
--    (
--        select
--            max(IncurredDate) PreviousDate
--        from
--            clmClaimIncurredMovement r
--        where
--            r.ClaimKey = t.ClaimKey and
--            r.IncurredDate < t.IncurredDate and
--            r.IncurredTime < t.IncurredTime
--    ) pd
--    outer apply
--    (
--        select
--            min(IncurredDate) FirstIncurredDate
--        from
--            clmClaimIncurredMovement r
--        where
--            r.ClaimKey = t.ClaimKey
--    ) fd


GO
