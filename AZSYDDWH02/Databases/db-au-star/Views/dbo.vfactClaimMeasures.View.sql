USE [db-au-star]
GO
/****** Object:  View [dbo].[vfactClaimMeasures]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vfactClaimMeasures] as
select *
from
    (
        select --top 100
            case
                when dcl.FirstNilDate < '2001-01-01' then '2000-01-01'
                when dcl.FirstNilDate is null then '3000-01-01'
                when dcl.FirstNilDate > getdate() then '3000-01-01'
                else dcl.FirstNilDate
            end AccountingDate,
            fc.UnderwritingDate,
            fc.DomainSK,
            fc.OutletSK,
            fc.AreaSK,
            fc.ProductSK,
            fc.ClaimSK,
            fc.ClaimEventSK,
            -1 BenefitSK,
            fc.AgeBandSK,
            fc.DurationSK,
            fc.PolicySK,
            fc.DestinationSK,
            0 ClaimOpened,
            0 ClaimReopened,
            0 ClaimClosed,
            1 FirstNil,
            0 FirstPaid
        from
            dimClaim dcl
            cross apply
            (
                select top 1 
                    case
                        when fc.UnderwritingDate < '2001-01-01' then '2000-01-01'
                        else fc.UnderwritingDate
                    end UnderwritingDate,
                    fc.DomainSK,
                    fc.OutletSK,
                    fc.AreaSK,
                    fc.ProductSK,
                    fc.ClaimSK,
                    fc.ClaimEventSK,
                    isnull(AgeBandSK, -1) AgeBandSK,
                    isnull(DurationSK, -1) DurationSK,
                    isnull(PolicySK, -1) PolicySK,
                    isnull(DestinationSK, -1) DestinationSK
                from
                    factClaimCount fc
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
                            pt.PolicyTransactionKey = fc.PolicyTransactionKey
                    ) pt
                where
                    fc.ClaimSK = dcl.ClaimSK
            ) fc
        where
            dcl.FirstNilDate is not null

        union all

        select --top 100
            case
                when dcl.FirstPaymentDate < '2001-01-01' then '2000-01-01'
                when dcl.FirstPaymentDate is null then '3000-01-01'
                when dcl.FirstPaymentDate > getdate() then '3000-01-01'
                else dcl.FirstPaymentDate
            end AccountingDate,
            fc.UnderwritingDate,
            fc.DomainSK,
            fc.OutletSK,
            fc.AreaSK,
            fc.ProductSK,
            fc.ClaimSK,
            fc.ClaimEventSK,
            -1 BenefitSK,
            fc.AgeBandSK,
            fc.DurationSK,
            fc.PolicySK,
            fc.DestinationSK,
            0 ClaimOpened,
            0 ClaimReopened,
            0 ClaimClosed,
            0 FirstNil,
            1 FirstPaid
        from
            dimClaim dcl
            cross apply
            (
                select top 1 
                    case
                        when fc.UnderwritingDate < '2001-01-01' then '2000-01-01'
                        else fc.UnderwritingDate
                    end UnderwritingDate,
                    fc.DomainSK,
                    fc.OutletSK,
                    fc.AreaSK,
                    fc.ProductSK,
                    fc.ClaimSK,
                    fc.ClaimEventSK,
                    isnull(AgeBandSK, -1) AgeBandSK,
                    isnull(DurationSK, -1) DurationSK,
                    isnull(PolicySK, -1) PolicySK,
                    isnull(DestinationSK, -1) DestinationSK
                from
                    factClaimCount fc
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
                            pt.PolicyTransactionKey = fc.PolicyTransactionKey
                    ) pt
                where
                    fc.ClaimSK = dcl.ClaimSK
            ) fc
        where
            dcl.FirstPaymentDate is not null

        union all

        select --top 100 
            case
                when ci.IncurredDate < '2001-01-01' then '2000-01-01'
                when ci.IncurredDate is null then '3000-01-01'
                when ci.IncurredDate > getdate() then '3000-01-01'
                else ci.IncurredDate
            end AccountingDate,
            fc.UnderwritingDate,
            fc.DomainSK,
            fc.OutletSK,
            fc.AreaSK,
            fc.ProductSK,
            fc.ClaimSK,
            fc.ClaimEventSK,
            -1 BenefitSK,
            fc.AgeBandSK,
            fc.DurationSK,
            fc.PolicySK,
            fc.DestinationSK,
            ci.NewCount ClaimOpened,
            ci.ReopenedCount ClaimReopened,
            ci.ClosedCount ClaimClosed,
            0 FirstNil,
            0 FirstPaid
        from
            [db-au-cba].dbo.vclmClaimIncurredIntraDay ci
            inner join [db-au-star].dbo.dimClaim dcl on
                dcl.ClaimKey = ci.ClaimKey
            cross apply
            (
                select top 1 
                    case
                        when fc.UnderwritingDate < '2001-01-01' then '2000-01-01'
                        else fc.UnderwritingDate
                    end UnderwritingDate,
                    fc.DomainSK,
                    fc.OutletSK,
                    fc.AreaSK,
                    fc.ProductSK,
                    fc.ClaimSK,
                    fc.ClaimEventSK,
                    isnull(AgeBandSK, -1) AgeBandSK,
                    isnull(DurationSK, -1) DurationSK,
                    isnull(PolicySK, -1) PolicySK,
                    isnull(DestinationSK, -1) DestinationSK
                from
                    factClaimCount fc
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
                            pt.PolicyTransactionKey = fc.PolicyTransactionKey
                    ) pt
                where
                    fc.ClaimSK = dcl.ClaimSK
            ) fc

    ) t
GO
