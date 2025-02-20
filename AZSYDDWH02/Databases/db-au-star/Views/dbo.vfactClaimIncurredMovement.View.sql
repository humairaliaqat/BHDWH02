USE [db-au-star]
GO
/****** Object:  View [dbo].[vfactClaimIncurredMovement]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO








CREATE view [dbo].[vfactClaimIncurredMovement]
as
select 
    BIRowID,
    'Movement Date' [Payment Date Reference],
    '0000-00-00' PDR,
    ClaimSK,
    dr.Item [Claim Date Reference],
    OutletSK,
    ar.Item  OutletReference,
    Date_SK,
    DomainSK,
    AreaSK,
    ProductSK,
    ClaimEventSK,
    BenefitSK,
    ClaimKey,
    PolicyTransactionKey,
    SectionKey,
    MovementDate,
    ClaimMovementCategory,
    PaymentKey,
    PaymentStatus,
    PaymentType,
    PaymentMonthType,
    PayeeType,
    PayeeSegment,
    ThirdPartyLocation,
    GoodService,
    AuthoredBy,
    ApprovedBy,
    FirstPaymentLag,
    PaymentLag,
    FirstRecoveryLag,
    PaymentMovement,
    LastModifiedDate,
    LastPaidAmount,
    LastRecoveryAmount,
    EstimateGroup,
    EstimateCategory,
    EstimateMovement,
    LastEstimate,
    LastRecoveryEstimate
from
    factClaimIncurredMovement ci
    --cross apply [db-au-cmdwh].dbo.fn_DelimitedSplit8K('Receipt Date,Register Date,Loss Date,First Nil Date,Last Nil Date,First Payment Date,Last Payment Date', ',') dr
    --cross apply [db-au-cmdwh].dbo.fn_DelimitedSplit8K('Point in time,Latest alpha', ',') ar
    cross apply 
    (
        select 'Receipt Date' Item
        union all
        select 'Register Date' Item
        union all
        --select 'Loss Date' Item
        --union all
        select 'First Nil Date' Item
        union all
        select 'First Payment Date' Item
    ) dr
    cross apply 
    (
        select 'Point in time' Item
        --union all
        --select 'Latest alpha' Item
    ) ar
--where
--    Date_SK >= 20110701
    --Date_SK between 20110701 and 20150630

union all

select 
    BIRowID,
    'Last Modified Date' [Payment Date Reference],
    convert(varchar(10), LastModifiedDate, 120) PDR,
    ClaimSK,
    'Payment Date' [Claim Date Reference],
    OutletSK,
    ar.Item  OutletReference,
    Date_SK,
    DomainSK,
    AreaSK,
    ProductSK,
    ClaimEventSK,
    BenefitSK,
    ClaimKey,
    PolicyTransactionKey,
    SectionKey,
    MovementDate,
    ClaimMovementCategory,
    PaymentKey,
    PaymentStatus,
    PaymentType,
    PaymentMonthType,
    PayeeType,
    PayeeSegment,
    ThirdPartyLocation,
    GoodService,
    AuthoredBy,
    ApprovedBy,
    FirstPaymentLag,
    PaymentLag,
    FirstRecoveryLag,
    PaymentMovement,
    LastModifiedDate,
    LastPaidAmount,
    LastRecoveryAmount,
    EstimateGroup,
    EstimateCategory,
    EstimateMovement,
    LastEstimate,
    LastRecoveryEstimate
from
    factClaimIncurredMovement ci
    --cross apply [db-au-cmdwh].dbo.fn_DelimitedSplit8K('Point in time,Latest alpha', ',') ar
    cross apply 
    (
        select 'Point in time' Item
        --union all
        --select 'Latest alpha' Item
    ) ar
where
    --Date_SK >= 20110701 and
    LastModifiedDate >= '2011-07-01' and
--    Date_SK between 20110701 and 20150630 and
    convert(varchar(10), LastModifiedDate, 120) <> '3000-01-01' and
    PaymentKey is not null 










GO
