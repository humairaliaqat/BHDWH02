USE [db-au-star]
GO
/****** Object:  View [dbo].[vfactClaimPaymentMovement]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO









CREATE view [dbo].[vfactClaimPaymentMovement] as
select --top 10
    BIRowID, 
    case
        when AccountingDate < '2001-01-01' then '2000-01-01'
        when AccountingDate > getdate() then UnderwritingDate
        else AccountingDate
    end AccountingDate,
    case
        when UnderwritingDate < '2001-01-01' then '2000-01-01'
        else UnderwritingDate
    end UnderwritingDate,
    case
        when DevelopmentDay > 11688 then 11688
        else DevelopmentDay
    end DevelopmentDay, 
    LossDevelopmentDay,
    DomainSK, 
    OutletSK, 
    AreaSK, 
    ProductSK, 
    ClaimSK, 
    ClaimEventSK, 
    BenefitSK, 
    ClaimKey, 
    PolicyTransactionKey, 
    SectionKey, 
    ClaimSizeType,
    isnull(dcp.PaymentKey, '-1') PaymentKey,
    PaymentStatus, 
    PaymentType, 
    PaymentMovement, 
    RecoveryMovement, 
    CreateBatchID, 
    'Claim Payment' [Transaction], 
    -RecoveryMovement FlippedRecoveryMovement,
    isnull(AgeBandSK, -1) AgeBandSK,
    isnull(DurationSK, -1) DurationSK,
    isnull(PolicySK, -1) PolicySK,
    isnull(DestinationSK, -1) DestinationSK,
    case
        when dcl.FirstNilDate is null then PaymentMovement + RecoveryMovement
        when dcl.FirstNilDate > convert(date, getdate()) then PaymentMovement + RecoveryMovement
        when t.AccountingDate < dateadd(day, 1, convert(date, dcl.FirstNilDate)) then PaymentMovement + RecoveryMovement
        else 0
    end PreFirstNilPayment,
    case
        when dcl.FirstNilDate is null then 0
        when dcl.FirstNilDate > convert(date, getdate()) then 0
        when t.AccountingDate < dateadd(day, 1, convert(date, dcl.FirstNilDate)) then 0
        else PaymentMovement + RecoveryMovement
    end PostFirstNilPayment,
    case
        when dcl.FirstNilDate is null then ClaimSK
        when dcl.FirstNilDate > convert(date, getdate()) then ClaimSK
        when t.AccountingDate < dateadd(day, 1, convert(date, dcl.FirstNilDate)) then ClaimSK
        else null
    end PreFirstNilCount,
    case
        when dcl.FirstNilDate is null then null
        when dcl.FirstNilDate > convert(date, getdate()) then null
        when t.AccountingDate < dateadd(day, 1, convert(date, dcl.FirstNilDate)) then null
        else ClaimSK
    end PostFirstNilCount
from
    factClaimPaymentMovement t
    outer apply
    (
        select top 1 
            dcl.FirstNilDate,
            dcl.EventDate,
            dcl.RegisterDate
        from
            dimClaim dcl
        where
            dcl.ClaimKey = t.ClaimKey
    ) dcl
    outer apply
    (
        select top 1
            AgeBandSK,
            DurationSK,
            PolicySK,
            DestinationSK
        from
            factPolicyTransaction pt
        where
            pt.PolicyTransactionKey = t.PolicyTransactionKey
    ) pt
    outer apply
    (
        select top 1 
            dcp.PaymentKey
        from
            dimClaimPayment dcp
        where
            dcp.PaymentKey = t.PaymentKey
    ) dcp
    outer apply
    (
        select
            convert(
                bigint,
                case
                    when datediff(day, convert(date, isnull(dcl.EventDate, dcl.RegisterDate)), t.AccountingDate) < 0 then 0
                    when datediff(day, convert(date, isnull(dcl.EventDate, dcl.RegisterDate)), t.AccountingDate) > 11688 then 11688
                    else datediff(day, convert(date, isnull(dcl.EventDate, dcl.RegisterDate)), t.AccountingDate)
                end 
            ) LossDevelopmentDay
    ) ldd





GO
