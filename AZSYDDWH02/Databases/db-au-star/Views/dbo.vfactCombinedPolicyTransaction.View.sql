USE [db-au-star]
GO
/****** Object:  View [dbo].[vfactCombinedPolicyTransaction]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[vfactCombinedPolicyTransaction]
as

--leisure
select --top 100 
    pt.BIRowID,

    pt.AgeBandSK,
    pt.AreaSK,
    pt.ConsultantSK,
    --insert customer segment here
    pt.DateSK,
    pt.DestinationSK,
    pt.DomainSK,
    pt.DurationSK,
    pt.LeadTime LeadTimeSK,
    pt.OutletSK,

    pt.PolicySK,
    --insert policy addon here

    pt.ProductSK,
    pt.PromotionSK,
    ref.OutletReference,
    pt.TransactionTypeStatusSK,

    pt.DepartureDate DepartureDateSK,
    pt.ReturnDate ReturnDateSK,
    pt.PolicyIssueDate IssueDateSK,
    pt.UnderwriterCode,

    pt.isExpo,
    pt.isPriceBeat,
    pt.isAgentSpecial,

    pt.RiskNet,
    pt.Premium,
    pt.BookPremium,
    pt.SellPrice,
    pt.NetPrice,
    pt.PremiumSD,
    pt.PremiumGST,
    pt.Commission,
    pt.CommissionSD,
    pt.CommissionGST,
    pt.PremiumDiscount,
    pt.AdminFee,
    pt.AgentPremium,
    pt.UnadjustedSellPrice,
    pt.UnadjustedNetPrice,
    pt.UnadjustedCommission,
    pt.UnadjustedAdminFee,

    pt.PolicyCount,
    pt.ExtensionPolicyCount,
    pt.CancelledPolicyCount,
    pt.CANXPolicyCount,
    pt.DomesticPolicyCount,
    pt.InternationalPolicyCount,
    pt.InboundPolicyCount,
    
    pt.TravellersCount,
    pt.AdultsCount,
    pt.ChildrenCount,
    pt.ChargedAdultsCount,
    pt.DomesticTravellersCount,
    pt.DomesticAdultsCount,
    pt.DomesticChildrenCount,
    pt.DomesticChargedAdultsCount,
    pt.InboundTravellersCount,
    pt.InboundAdultsCount,
    pt.InboundChildrenCount,
    pt.InboundChargedAdultsCount,
    pt.InternationalTravellersCount,
    pt.InternationalAdultsCount,
    pt.InternationalChildrenCount,
    pt.InternationalChargedAdultsCount,

    pt.LeadTime,
    pt.Duration,
    pt.CancellationCover

from
    dbo.factPolicyTransaction pt
    cross apply
    (
        select 'Point in time' OutletReference
        union all
        select 'Latest alpha' OutletReference
    ) ref

where
    pt.DateSK >= 20150101
GO
