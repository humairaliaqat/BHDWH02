USE [db-au-cba]
GO
/****** Object:  View [dbo].[vPenguinPolicyPremiums]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE view [dbo].[vPenguinPolicyPremiums]
/*
20140131, LS,   initial production use (universe migration)
                commented out metrics are for finance's GUG, disabled for now
20140205, LS,   performance consideration, all UW related definition moved to vPenguinPolicyUWPremiums
20140212, LS,   round commission to 2 decimal point (as in CRM)
20140228, LS,   fix NAP definition, should be - Agency Commission instead of - Net Agency Commission.
20140514, LS,   round sell price & unadjusted sell price to 2 decimal point
*/
as
select
    PolicyTransactionKey,
    pra.[Unadjusted Sell Price],
    pra.[Unadjusted GST on Sell Price],
    pra.[Unadjusted Stamp Duty on Sell Price],
    prb.[Unadjusted Sell Price (excl GST)],
    prb.[Unadjusted Premium],
    pra.[Unadjusted Agency Commission],
    pra.[Unadjusted GST on Agency Commission],
    pra.[Unadjusted Stamp Duty on Agency Commission],
    prb.[Unadjusted Agency Commission (excl GST)],
    prb.[Unadjusted Net Agency Commission],
    prc.[Unadjusted NAP],
    prc.[Unadjusted NAP (incl Tax)],
    prb.[Discount on Sell Price],
    pra.[Sell Price],
    pra.[GST on Sell Price],
    pra.[Stamp Duty on Sell Price],
    prb.[Sell Price (excl GST)],
    prb.[Premium],
    pra.[Agency Commission],
    pra.[GST on Agency Commission],
    pra.[Stamp Duty on Agency Commission],
    prb.[Agency Commission (excl GST)],
    prb.[Net Agency Commission],
    prc.[NAP],
    prc.[NAP (incl Tax)],
    pra.[Risk Nett]
from
    penPolicyTransSummary pt
    cross apply
    (
        select
            round(isnull(pt.UnAdjGrossPremium, 0), 2) as [Unadjusted Sell Price],
            isnull(pt.UnAdjTaxAmountGST, 0) as [Unadjusted GST on Sell Price],
            isnull(pt.UnAdjTaxAmountSD, 0) as [Unadjusted Stamp Duty on Sell Price],
            round(isnull(pt.UnAdjCommission, 0), 2) + round(isnull(pt.UnAdjGrossAdminFee, 0), 2) as [Unadjusted Agency Commission],
            round(isnull(pt.UnAdjTaxOnAgentCommissionGST, 0), 2) as [Unadjusted GST on Agency Commission],
            round(isnull(pt.UnAdjTaxOnAgentCommissionSD, 0), 2) as [Unadjusted Stamp Duty on Agency Commission],
            round(isnull(pt.GrossPremium, 0), 2) as [Sell Price],
            isnull(pt.TaxAmountGST, 0) as [GST on Sell Price],
            isnull(pt.TaxAmountSD, 0) as [Stamp Duty on Sell Price],
            round(isnull(pt.Commission, 0), 2) + round(isnull(pt.GrossAdminFee, 0), 2) as [Agency Commission],
            round(isnull(pt.TaxOnAgentCommissionGST, 0), 2) as [GST on Agency Commission],
            round(isnull(pt.TaxOnAgentCommissionSD, 0), 2) as [Stamp Duty on Agency Commission],
            isnull(pt.RiskNet, 0) as [Risk Nett]
    ) pra
    cross apply
    (
        select
            pra.[Unadjusted Sell Price] - pra.[Unadjusted GST on Sell Price] as [Unadjusted Sell Price (excl GST)],
            pra.[Unadjusted Sell Price] - pra.[Unadjusted GST on Sell Price] - [Unadjusted Stamp Duty on Sell Price] as [Unadjusted Premium],
            pra.[Unadjusted Agency Commission] - pra.[Unadjusted GST on Agency Commission] as [Unadjusted Agency Commission (excl GST)],
            pra.[Unadjusted Agency Commission] - pra.[Unadjusted GST on Agency Commission] - pra.[Unadjusted Stamp Duty on Agency Commission] as [Unadjusted Net Agency Commission],
            pra.[Sell Price] - pra.[GST on Sell Price] as [Sell Price (excl GST)],
            pra.[Sell Price] - pra.[GST on Sell Price] - [Stamp Duty on Sell Price] as [Premium],
            pra.[Agency Commission] - pra.[GST on Agency Commission] as [Agency Commission (excl GST)],
            pra.[Agency Commission] - pra.[GST on Agency Commission] - pra.[Stamp Duty on Agency Commission] as [Net Agency Commission],
            pra.[Unadjusted Sell Price] - pra.[Sell Price] as [Discount on Sell Price]
    ) prb
    cross apply
    (
        select
            prb.[Unadjusted Premium] - pra.[Unadjusted Agency Commission] as [Unadjusted NAP],
            pra.[Unadjusted Sell Price] - pra.[Unadjusted Agency Commission] as [Unadjusted NAP (incl Tax)],
            prb.[Premium] - pra.[Agency Commission] as [NAP],
            pra.[Sell Price] - pra.[Agency Commission] as [NAP (incl Tax)]
    ) prc






GO
