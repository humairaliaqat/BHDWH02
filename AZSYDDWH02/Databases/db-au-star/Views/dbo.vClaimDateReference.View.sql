USE [db-au-star]
GO
/****** Object:  View [dbo].[vClaimDateReference]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[vClaimDateReference] as
select --top 1000
    [Claim Date Reference],
    'Movement Date' [Payment Date Reference],
    '0000-00-00' PDR,
    ClaimSK,
    ReferenceDate,
    RefSK
from
    (
        select 
            'Receipt Date' [Claim Date Reference],
            ClaimSK,
            ReceiptDate ReferenceDate,
            'RC' + convert(varchar(max), ClaimSK) RefSK
        from
            dimClaim

        union all

        select 
            'Register Date' [Claim Date Reference],
            ClaimSK,
            RegisterDate ReferenceDate,
            'RG' + convert(varchar(max), ClaimSK) RefSK
        from
            dimClaim

        union all

        --select 
        --    'Loss Date' [Claim Date Reference],
        --    ClaimSK,
        --    EventDate ReferenceDate,
        --    'EV' + convert(varchar(max), ClaimSK) RefSK
        --from
        --    dimClaim

        --union all

        select 
            'First Nil Date' [Claim Date Reference],
            ClaimSK,
            FirstNilDate ReferenceDate,
            'FN' + convert(varchar(max), ClaimSK) RefSK
        from
            dimClaim

        union all

        select 
            'First Payment Date' [Claim Date Reference],
            ClaimSK,
            FirstPaymentDate ReferenceDate,
            'FP' + convert(varchar(max), ClaimSK) RefSK
        from
            dimClaim
    ) t
--where
--    claimsk = 14

union all 

select 
    'Payment Date'  [Claim Date Reference],
    'Last Modified Date' [Payment Date Reference],
    convert(varchar(10), LastModifiedDate, 120) PDR,
    ClaimSK,
    LastModifiedDate ReferenceDate,
    'LMD' + convert(varchar(max), ClaimSK) + convert(varchar(10), LastModifiedDate, 120) RefSK
from
    dimClaim cl
    cross apply
    (
        select distinct
            convert(date, cp.ModifiedDate) LastModifiedDate
        from
            [db-au-cba]..clmPayment cp
        where
            cp.ClaimKey = cl.ClaimKey
    ) cp
    --cross apply [db-au-cba].dbo.fn_DelimitedSplit8K('Receipt Date,Register Date,Loss Date,First Nil Date,First Payment Date', ',') dr
--where
--    claimsk = 14

GO
