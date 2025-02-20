USE [db-au-star]
GO
/****** Object:  View [dbo].[dimTransaction]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE view [dbo].[dimTransaction] as
select distinct
    convert(varchar(50), 'Policy') [Transaction],
    convert(varchar(50), TransactionType) TransactionType,
    convert(varchar(50), TransactionStatus) TransactionStatus
from
    factPolicyTransaction

union

select distinct
    convert(varchar(50), 'Claim Estimate') [Transaction],
    convert(varchar(50), EstimateGroup) TransactionType,
    convert(varchar(50), EstimateCategory) TransactionStatus
from
    factClaimEstimateMovement

union

select distinct
    convert(varchar(50), 'Claim Payment') [Transaction],
    convert(varchar(50), PaymentType) TransactionType,
    convert(varchar(50), PaymentStatus) TransactionStatus
from
    factClaimPaymentMovement
GO
