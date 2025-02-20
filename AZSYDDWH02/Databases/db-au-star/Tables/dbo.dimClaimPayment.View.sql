USE [db-au-star]
GO
/****** Object:  View [dbo].[dimClaimPayment]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE view [dbo].[dimClaimPayment] as
select 
    cast('-1' as varchar(100)) PaymentKey, 
    cast('3000-01-01' as date) PaymentDate, 
    cast('UNKNOWN' as varchar(30)) PaymentStatus,
    cast('UNKNOWN' as varchar(30)) PaymentPartyType

union

select 
    cp.PaymentKey, 
    case
        when convert(date, isnull(cp.ModifiedDate, '3000-01-01')) < '2001-01-01' then '2000-01-01'
        when convert(date, isnull(cp.ModifiedDate, '3000-01-01')) > getdate() then convert(date, cp.CreatedDate)
        else convert(date, isnull(cp.ModifiedDate, '3000-01-01'))
    end PaymentDate, 
    cast(cp.PaymentStatus as varchar(30)) PaymentStatus,
    cast(
        case
            when isnull(cn.isThirdParty, 0) = 0 then 'First party'
            else 'Third party'
        end 
        as varchar(30)
    ) PaymentPartyType
from
    [db-au-cba].dbo.clmPayment cp
    left join [db-au-cba].dbo.clmName cn on
        cn.NameKey = cp.PayeeKey
where
    cp.CreatedDate < convert(date, dateadd(day, 1, getdate()))

union

select distinct 
    cpm.PaymentKey, 
    case
        when convert(date, isnull(cpm.PaymentDate, '3000-01-01')) < '2001-01-01' then '2000-01-01'
        when convert(date, isnull(cpm.PaymentDate, '3000-01-01')) > getdate() then convert(date, cp.CreatedDate)
        else convert(date, isnull(cpm.PaymentDate, '3000-01-01'))
    end PaymentDate, 
    cast('DEL' as varchar(30)) PaymentStatus,
    cast(
        case
            when isnull(cap.isThirdParty, 0) = 0 then 'First party'
            else 'Third party'
        end 
        as varchar(30)
    ) PaymentPartyType
from
    [db-au-cba].dbo.clmClaimPaymentMovement cpm 
    left join [db-au-cba].dbo.clmPayment cp on 
        cp.PaymentKey = cpm.PaymentKey
    outer apply
    (
        select top 1 
            cn.isThirdParty
        from
            [db-au-cba].dbo.clmAuditPayment cap
            left join [db-au-cba].dbo.clmName cn on
                cn.NameKey = cap.PayeeKey
        where
            cap.PaymentKey = cpm.PaymentKey
        order by
            AuditDateTime desc
    ) cap
where
    cp.PaymentKey is null and
    cpm.PaymentDate < convert(date, dateadd(day, 1, getdate()))



GO
