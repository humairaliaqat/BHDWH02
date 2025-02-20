USE [db-au-star]
GO
/****** Object:  View [dbo].[vfactPolicyTransaction]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  
CREATE view [dbo].[vfactPolicyTransaction] as  
select   
    pt.BIRowID,  
    pt.DateSK,  
    pt.DomainSK,  
    pt.OutletSK,  
    pt.PolicySK,  
    pt.ConsultantSK,  
    pt.PaymentSK,  
    pt.AreaSK,  
    pt.DestinationSK,  
    pt.DurationSK,  
    pt.ProductSK,  
    pt.AgeBandSK,  
    pt.PromotionSK,  
    pt.TransactionTypeStatusSK,  
    pt.IssueDate,  
	  case  
        when p.DepartureDateSK < '2001-01-01' then '2001-01-01'  
        when p.DepartureDateSK > convert(varchar(10), convert(varchar(4), year(getdate()) + 4) + '-12-31') then convert(varchar(10), convert(varchar(4), year(getdate()) + 4) + '-12-31')  
        else p.DepartureDateSK  
    end DepartureDateSK,  
    case  
        when p.ReturnDateSK < '2001-01-01' then '2001-01-01'  
        when p.ReturnDateSK > convert(varchar(10), convert(varchar(4), year(getdate()) + 4) + '-12-31') then convert(varchar(10), convert(varchar(4), year(getdate()) + 4) + '-12-31')  
        else p.ReturnDateSK  
    end ReturnDateSK,  
    pt.PostingDate,  
    pt.PolicyTransactionKey,  
    pt.TransactionNumber,  
    pt.TransactionType,  
    pt.TransactionStatus,  
    pt.isExpo,  
    pt.isPriceBeat,  
    pt.isAgentSpecial,  
    pt.BonusDays,  
    pt.isClientCall,  
    pt.AllocationNumber,  
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
    --pt.PolicyCount,  
	Case when pt.TransactionType='Base' and  pt.TransactionStatus='Active' then 1 else 0   -  pt.CancelledPolicyCount end as   PolicyCount,  --Revised logic as per CHGXXXX        
    pt.AddonPolicyCount,  
    pt.ExtensionPolicyCount,  
    ISNULL(pt.CancelledPolicyCount,0) as CancelledPolicyCount,				--ADDED UNDER CHGXXXX       
	ISNULL(pt.CancelledTransactionCount,0) as CancelledTransactionCount,      --ADDED UNDER CHGXXXX       
    pt.CancelledAddonPolicyCount,  
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
    pt.LuggageCount,  
    pt.MedicalCount,  
    pt.MotorcycleCount,  
    pt.RentalCarCount,  
    pt.WintersportCount,  
    pt.AttachmentCount,  
    pt.EMCCount,  
    pt.LoadDate,  
    pt.LoadID,  
    pt.updateDate,  
    pt.updateID,  
    ref.OutletReference,  
      
    pt.LeadTime,  
    pt.Duration,  
    pt.CancellationCover,  
    p.PolicyKey,  
    pt.DepartureDate TripStart,  
    pt.ReturnDate TripEnd,  
    pt.PolicyIssueDate,  
    pt.UnderwriterCode  
from   
    factpolicytransaction as pt  
	 cross apply  
    (  
        select   dp.PolicyKey,
            convert(date, p.TripStart) DepartureDateSK,  
            convert(date, p.TripEnd) ReturnDateSK,  
            convert(date, p.IssueDate) IssueDateSK  
        from  
            dbo.dimPolicy dp  
            inner join [db-au-cba].dbo.penPolicy p on  
                p.PolicyKey = dp.PolicyKey  
        where  
            dp.PolicySK = pt.PolicySK   
    ) p  
    --inner join dimpolicy as p on   
    --    p.policysk = pt.policysk  
    cross apply  
    (  
        select 'Point in time' OutletReference  
        union all  
        select 'Latest alpha' OutletReference  
    ) ref  
  
where  
    pt.DateSK >= 20130101  
  
  
  
  
  
  
  
  
  
GO
