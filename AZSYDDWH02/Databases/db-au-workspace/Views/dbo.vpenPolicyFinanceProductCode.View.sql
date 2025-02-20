USE [db-au-workspace]
GO
/****** Object:  View [dbo].[vpenPolicyFinanceProductCode]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
CREATE view [dbo].[vpenPolicyFinanceProductCode]   
/*  
    20140926, LS, change mapping to use dimProduct  
 20180831, LT, get FinanceProductCode from penPolicy, else use dimProduct  
*/  
as  
select   
    pt.PolicyTransactionKey,  
    --isnull(p.FinanceProductCode,map.FinanceProductCode) as FinanceProductCode,  
    --map.OldFinanceProductCode,  
    --GLProductParent,  
    --GLProductType  
    --pp.FinanceProductCode,
	case when p.CountryKey='AU' and p.PrimaryCountry='New Zealand' and AreaType='International'  
 then 'TT'+substring(pp.FinanceProductCode,2,len(pp.FinanceProductCode))  
 when p.CountryKey='NZ' and p.PrimaryCountry='Australia' and AreaType='International'   
    then 'TT'+substring(pp.FinanceProductCode,2,len(pp.FinanceProductCode)) else pp.FinanceProductCode
	end as  FinanceProductCode,
	
	  
    '' OldFinanceProductCode,  
    '' GLProductParent,  
    '' GLProductType  
from  
    [db-au-cba]..penPolicyTransSummary pt  
    inner join [db-au-cba]..penPolicy p on  
        p.PolicyKey = pt.PolicyKey  
    outer apply  
    (  
        select top 1  
            pp.PlanName,  
            pp.FinanceProductCode  
        from  
            [db-au-cba]..penProductPlan pp  
            inner join [db-au-cba]..penOutlet o on  
                o.OutletKey = pp.OutletKey and  
                o.OutletStatus = 'Current'  
        where  
            o.OutletAlphaKey = pt.OutletAlphaKey and  
            pp.ProductId = p.ProductID and  
            pp.UniquePlanId = p.UniquePlanID  
    ) pp  
    --outer apply  
    --(  
    --    select  
    --     isnull(p.CountryKey,'') + '-' +   
    --     isnull(p.CompanyKey,'') + '' +   
    --     convert(varchar,isnull(p.DomainID,0)) + '-' +   
    --     isnull(p.ProductCode,'') + '-' +   
    --     isnull(p.ProductName,'') + '-' +   
    --     isnull(p.ProductDisplayName,'') + '-' +   
    --     isnull(pp.PlanName,isnull(p.PlanDisplayName,'')) ProductKey  
    --) pk  
    --outer apply  
    --(  
    --    select top 1  
    --        FinanceProductCode,  
    --        FinanceProductCodeOld OldFinanceProductCode  
    --    from  
    --        uldwh02.[db-au-star].dbo.dimProduct dp  
    --    where  
    --        dp.ProductKey = pk.ProductKey  
    --) map  
    --outer apply  
    --(  
    --    select top 1  
    --        gp.Product_Parent_Code GLProductParent,  
    --        gp.Product_Type_Code GLProductType  
    --    from  
    --        uldwh02.[db-au-star].dbo.Dim_GL_Product gp  
    --    where  
    --        gp.Product_Code = map.FinanceProductCode  
    --) gp  
      
  
  
  
  
GO
