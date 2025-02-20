USE [db-au-cba]
GO
/****** Object:  View [dbo].[vpenPolicyPlanCode]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE view [dbo].[vpenPolicyPlanCode]
/*
    20140204 - LS - copied from TRIPS.PenguinPull_PolicyTransaction & Penguin.TRIPSGetPolicyPlan
*/
as
select
    pt.PolicyTransactionKey,
    case pt.CountryKey 
        when 'NZ' then 
        case 
            when IsExpo = 1 then 
            case 
                when pp.PlanCode = 'C' then
                case p.TripCost
                    when 'C-$200' then 'XA2'
                    when 'C-$400' then 'XA4'
                    when 'C-$600' then 'XA6'
                    when 'C-$800' then 'XA8'
                    when 'C-$1,500' then 'XA15'
                    else 'X' + substring(pp.PlanCode, 2, len(pp.PlanCode))
                end 
                when left(pp.PlanCode, 1) = 'C' then 'X' + replace(pp.PlanCode, substring(pp.PlanCode, 2, 1), '')
                else 'X' + substring(pp.PlanCode, 2, len(pp.PlanCode)) 
            end
            when IsAgentSpecial = 1 then substring(pp.PlanCode, 3, len(pp.PlanCode))
            else 
            case 
                when pp.PlanCode = 'C' then
                case p.TripCost
                    when 'C-$200' then 'C2'
                    when 'C-$400' then 'C4'
                    when 'C-$600' then 'C6'
                    when 'C-$800' then 'C8'
                    when 'C-$1,500' then 'C15'
                    else pp.PlanCode
                end 
                else pp.PlanCode 
            end
        end 			
        else 
        case    
            when IsExpo = 1 then 
            case 
                when pp.PlanCode in ('DA2', 'DA') then
                case p.TripCost
                    when 'DA-$200' then 'XA2'
                    when 'DA-$400' then 'XA4'
                    when 'DA-$600' then 'XA6'
                    when 'DA-$800' then 'XA8'
                    when 'DA-$1,500' then 'XA15'  
                    else  'X' + substring(pp.PlanCode, 2, len(pp.PlanCode))
                end 
                when left(pp.PlanCode, 1) = 'C' then 'X' + replace(pp.PlanCode, substring(pp.PlanCode, 2, 1), '')
                else 'X' + substring(pp.PlanCode, 2, len(pp.PlanCode)) 
            end
            when IsAgentSpecial = 1 then substring(pp.PlanCode, 3, len(pp.PlanCode))
            else 
                case 
                    when pp.PlanCode in ('DA2', 'DA') then
                    case p.TripCost
                        when 'DA-$200' then 'DA2'
                        when 'DA-$400' then 'DA4'
                        when 'DA-$600' then 'DA6'
                        when 'DA-$800' then 'DA8'
                        when 'DA-$1,500' then 'DA15'
                        else pp.PlanCode                         				
                    end 
                    else pp.PlanCode 
                end
        end
    end PlanCode
from
    penPolicyTransSummary pt
    inner join penPolicy p on
        pt.PolicyKey = p.PolicyKey
    inner join penOutlet o on
        o.OutletAlphaKey = pt.OutletAlphaKey and
        o.OutletStatus = 'Current'
    outer apply
    (
        select top 1 
            PlanCode
        from
            penArea a
            inner join penProductPlan pp on
                pp.AreaID = a.AreaID
        where
            a.CountryKey = p.CountryKey and
            a.CompanyKey = p.CompanyKey and
            a.AreaName = p.AreaName and
            pp.OutletKey = o.OutletKey and
            pp.ProductId = p.ProductID and
            pp.UniquePlanId = p.UniquePlanID
    ) napp
    outer apply
    (
        select top 1 
            PlanCode
        from
            penProductPlan amtpp
        where
            amtpp.OutletKey = o.OutletKey and
            amtpp.UniquePlanId = p.UniquePlanID and
            amtpp.ProductId = p.ProductId and
            amtpp.AMTUpsellDisplayName = p.AreaName
    ) amtpp
    cross apply
    (
        select
            isnull(napp.PlanCode, amtpp.PlanCode) PlanCode
    ) pp
    
    





GO
