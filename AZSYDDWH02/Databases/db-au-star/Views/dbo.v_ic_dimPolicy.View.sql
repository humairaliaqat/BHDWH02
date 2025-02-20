USE [db-au-star]
GO
/****** Object:  View [dbo].[v_ic_dimPolicy]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
CREATE view [dbo].[v_ic_dimPolicy]  
as  
with cte_corporate as  
(  
    select   
        PolicySK,  
        max(ExposedPolicyNumber) ExposedPolicyNumber,  
        'Active' PolicyStatus,  
        366 AMTMaxDuration,  
        0 TravellerCount,  
        0 AdultCount,  
        0 ChargedAdultCount,  
        sum(Premium) PremiumAtIssue,  
        '' PremiumAtIssueBand,  
        '' PremiumAtIssueBandKey,  
        0 MaxEMCScore,  
        0 TotalEMCScore,  
        max(Excess) Excess,  
        0 ExcessName,  
        'Corporate' PurchasePathGroup,  
        'Corporate' PurchasePath,  
        1000001 CancellationCoverBandKey,  
        '>1m' CancellationCoverBand,  
        1000001 TripCostBandKey,  
        '>1m' TripCostBand,  
        max(IssueDate) IssueDate  
    from  
        v_ic_Corporate  
    group by  
        PolicySK  
)  
select --top 1000  
    dp.PolicySK,   
    case  
        when dp.IssueDate < convert(date, convert(varchar(5), dateadd(year, -2, getdate()), 120) + '01-01') then 'Out of range'  
        else dp.PolicyNumber  
    end ExposedPolicyNumber,  
    dp.PolicyStatus,   
  
    isnull(dp.MaxDuration, 0) AMTMaxDuration,  
    isnull(dp.TravellerCount, 0) TravellerCount,  
    isnull(dp.AdultCount, 0) AdultCount,  
    isnull(dp.ChargedAdultCount, 0) ChargedAdultCount,  
    isnull(TotalPremium, 0) PremiumAtIssue,  
    case  
        when isnull(TotalPremium, 0) < 100 then '0 - 99'  
        when isnull(TotalPremium, 0) < 250 then '100 - 249'  
        when isnull(TotalPremium, 0) < 500 then '250 - 499'  
        when isnull(TotalPremium, 0) < 1000 then '500 - 999'  
        when isnull(TotalPremium, 0) < 1500 then '1000 - 1499'  
        when isnull(TotalPremium, 0) <= 2000 then '1500 - 2000'  
        else '2000+'  
    end PremiumAtIssueBand,  
    case  
        when isnull(TotalPremium, 0) < 100 then 100  
        when isnull(TotalPremium, 0) < 250 then 250  
        when isnull(TotalPremium, 0) < 500 then 500  
        when isnull(TotalPremium, 0) < 1000 then 1000  
        when isnull(TotalPremium, 0) < 1500 then 1500  
        when isnull(TotalPremium, 0) <= 2000 then 2000  
        else 2001  
    end PremiumAtIssueBandKey,  
    MaxEMCScore,  
    TotalEMCScore,  
    dp.Excess,  
    '$' + replace(convert(varchar, try_convert(money, isnull(dp.Excess, 0)), 1), '.00', '') ExcessName,  
    case  
        when dp.PurchasePath like 'Business%' then 'Business'  
        when dp.PurchasePath like 'Age%' then 'Age Approved'  
        else 'Leisure'  
    end PurchasePathGroup,  
    isnull(dp.PurchasePath, 'Leisure') PurchasePath,  
    case   
        when isnumeric(dp.CancellationCover) = 0 then 99999999  
        when try_convert(int, dp.CancellationCover) = 0 then 0  
        when try_convert(int, dp.CancellationCover) < 2000 then 2000  
        when try_convert(int, dp.CancellationCover) < 4000 then 4000  
        when try_convert(int, dp.CancellationCover) < 7000 then 7000  
        when try_convert(int, dp.CancellationCover) < 11000 then 11000  
        when try_convert(int, dp.CancellationCover) < 21000 then 21000  
        when try_convert(int, dp.CancellationCover) <= 200000 then 200000  
        when try_convert(int, dp.CancellationCover) < 1000000 then 1000000  
        else 1000001  
    end CancellationCoverBandKey,  
    case   
        when isnumeric(dp.CancellationCover) = 0 then 'Unknown'   
        when try_convert(int, dp.CancellationCover) = 0 then '0'   
        when try_convert(int, dp.CancellationCover) < 2000 then '< 2k'   
        when try_convert(int, dp.CancellationCover) < 4000 then '2-3k'   
        when try_convert(int, dp.CancellationCover) < 7000 then '4-6k'   
        when try_convert(int, dp.CancellationCover) < 11000 then '7-10k'   
        when try_convert(int, dp.CancellationCover) < 21000 then '11-20k'   
        when try_convert(int, dp.CancellationCover) <= 200000 then '21-200k'   
        when try_convert(int, dp.CancellationCover) < 1000000 then '200-900k'   
        else '>1m'   
    end CancellationCoverBand,  
    case   
        when isnumeric(dp.TripCost) = 0 then 99999999  
        when try_convert(int, dp.TripCost) = 0 then 0  
        when try_convert(int, dp.TripCost) < 2000 then 2000  
        when try_convert(int, dp.TripCost) < 4000 then 4000  
        when try_convert(int, dp.TripCost) < 7000 then 7000  
        when try_convert(int, dp.TripCost) < 11000 then 11000  
        when try_convert(int, dp.TripCost) < 21000 then 21000  
        when try_convert(int, dp.TripCost) <= 200000 then 200000  
        when try_convert(int, dp.TripCost) < 1000000 then 1000000  
        else 1000001  
    end TripCostBandKey,  
    case   
        when isnumeric(dp.TripCost) = 0 then 'Unknown'   
        when try_convert(int, dp.TripCost) = 0 then '0'   
        when try_convert(int, dp.TripCost) < 2000 then '< 2k'   
        when try_convert(int, dp.TripCost) < 4000 then '2-3k'   
        when try_convert(int, dp.TripCost) < 7000 then '4-6k'   
        when try_convert(int, dp.TripCost) < 11000 then '7-10k'   
        when try_convert(int, dp.TripCost) < 21000 then '11-20k'   
        when try_convert(int, dp.TripCost) <= 200000 then '21-200k'   
        when try_convert(int, dp.TripCost) < 1000000 then '200-900k'   
        else '>1m'   
    end TripCostBand,
 CASE   
 WHEN Country = 'AU' and len(PolicyNumber) = 12 THEN  
  CASE substring(PolicyNumber,4,1)  
   WHEN '0' THEN 'CM'  
   WHEN '1' THEN 'Innate'  
   WHEN '2' THEN 'CBA'  
   ELSE 'UNKNOWN'  
  END  
 WHEN Country = 'AU' AND left(PolicyNumber,4) = 'RCPZ' THEN 'HALO'  
 ELSE 'Unknown' END PolicySource   
  
from  
    dimPolicy dp  
  
--where  
--    dp.IssueDate >= '2018-01-01'  
  
union all  
  
select   
    PolicySK,  
    ExposedPolicyNumber,  
    PolicyStatus,  
    AMTMaxDuration,  
    TravellerCount,  
    AdultCount,  
    ChargedAdultCount,  
    PremiumAtIssue,  
    case  
        when isnull(PremiumAtIssue, 0) < 100 then '0 - 99'  
        when isnull(PremiumAtIssue, 0) < 250 then '100 - 249'  
        when isnull(PremiumAtIssue, 0) < 500 then '250 - 499'  
        when isnull(PremiumAtIssue, 0) < 1000 then '500 - 999'  
        when isnull(PremiumAtIssue, 0) < 1500 then '1000 - 1499'  
        when isnull(PremiumAtIssue, 0) <= 2000 then '1500 - 2000'  
        else '2000+'  
    end PremiumAtIssueBand,  
    case  
        when isnull(PremiumAtIssue, 0) < 100 then 100  
        when isnull(PremiumAtIssue, 0) < 250 then 250  
        when isnull(PremiumAtIssue, 0) < 500 then 500  
        when isnull(PremiumAtIssue, 0) < 1000 then 1000  
        when isnull(PremiumAtIssue, 0) < 1500 then 1500  
        when isnull(PremiumAtIssue, 0) <= 2000 then 2000  
        else 2001  
    end PremiumAtIssueBandKey,  
    MaxEMCScore,  
    TotalEMCScore,  
    Excess,  
    '$' + replace(convert(varchar, try_convert(money, isnull(Excess, 0)), 1), '.00', '') ExcessName,  
    'Corporate' PurchasePathGroup,  
    'Corporate' PurchasePath,  
    1000001 CancellationCoverBandKey,  
    '>1m' CancellationCoverBand,  
    1000001 TripCostBandKey,  
    '>1m' TripCostBand,
    'CM' as PolicySource   
from  
    cte_corporate  
  
--where  
--    IssueDate >= '2018-01-01'  
  
      
  
  
  
  
  
GO
