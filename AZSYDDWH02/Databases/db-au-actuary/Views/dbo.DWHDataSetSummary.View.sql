USE [db-au-actuary]
GO
/****** Object:  View [dbo].[DWHDataSetSummary]    Script Date: 20/02/2025 10:01:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
  
  
  
CREATE view [dbo].[DWHDataSetSummary]   
as  

select   
    ds.*,  
    isnull(do.[Outlet Name], o.[Outlet Name]) [Outlet Name],  
    isnull(do.[Outlet Sub Group Code], o.[Outlet Sub Group Code]) [Outlet Sub Group Code],  
    isnull(do.[Outlet Sub Group Name], o.[Outlet Sub Group Name]) [Outlet Sub Group Name],  
    isnull(do.[Outlet Group Code], o.[Outlet Group Code]) [Outlet Group Code],  
    isnull(do.[Outlet Group Name], o.[Outlet Group Name]) [Outlet Group Name],  
    case  
        when isnull(do.[Outlet Super Group], '') = '' and isnull(o.[Outlet Super Group], '') = '' then o.[Outlet Group Name]  
        when isnull(do.[Outlet Super Group], '') = '' and isnull(o.[Outlet Super Group], '') <> '' then o.[Outlet Super Group]  
        else do.[Outlet Super Group]   
    end [Outlet Super Group],  
    isnull(do.[Outlet Channel], o.[Outlet Channel]) [Outlet Channel],  
    isnull(do.[Outlet BDM], o.[Outlet BDM]) [Outlet BDM],  
    isnull(do.[Outlet Post Code], o.[Outlet Post Code]) [Outlet Post Code],  
    isnull(do.[Outlet Sales State Area], o.[Outlet Sales State Area]) [Outlet Sales State Area],  
    isnull(do.[Outlet Trading Status], o.[Outlet Trading Status]) [Outlet Trading Status],  
    isnull(do.[Outlet Type], o.[Outlet Type]) [Outlet Type],  
    case  
        when isnull([TRIPS Policy], 0) = 0 and isnull([Purchase Path], '') <> '' then [Purchase Path]  
        when [Oldest Age] < 70 then 'Leisure'  
        when [Area Number] = 'Area 1' then  
        case  
            when [Oldest Age] between 70 and 74 and [Trip Length] < 56 then isnull([Purchase Path], 'Leisure')  
            when [Oldest Age] between 75 and 79 and [Trip Length] < 56 then isnull([Purchase Path], 'Leisure')  
            when [Oldest Age] between 80 and 84 and [Trip Length] < 35 then isnull([Purchase Path], 'Leisure')  
            when [Oldest Age] between 85 and 89 and [Trip Length] >= 180 then 'Invalid'  
            when [Oldest Age] >= 90 and [Trip Length] >= 120 then 'Invalid'  
            else 'Age Approved'  
        end  
        when [Area Number] = 'Area 2' then  
        case  
            when [Oldest Age] between 70 and 74 and [Trip Length] < 120 then isnull([Purchase Path], 'Leisure')  
            when [Oldest Age] between 75 and 79 and [Trip Length] < 56 then isnull([Purchase Path], 'Leisure')  
            when [Oldest Age] between 80 and 84 and [Trip Length] < 35 then isnull([Purchase Path], 'Leisure')  
            when [Oldest Age] between 85 and 89 and [Trip Length] >= 180 then 'Invalid'  
            when [Oldest Age] >= 90 and [Trip Length] >= 120 then 'Invalid'  
            else 'Age Approved'  
        end  
        when [Area Number] = 'Area 3' then  
        case  
            when [Oldest Age] between 70 and 74 and [Trip Length] < 120 then isnull([Purchase Path], 'Leisure')  
            when [Oldest Age] between 75 and 79 and [Trip Length] < 56 then isnull([Purchase Path], 'Leisure')  
            when [Oldest Age] between 80 and 84 and [Trip Length] < 35 then isnull([Purchase Path], 'Leisure')  
            when [Oldest Age] between 85 and 89 and [Trip Length] >= 180 then 'Invalid'  
            when [Oldest Age] >= 90 and [Trip Length] >= 120 then 'Invalid'  
            else 'Age Approved'  
        end  
        when [Area Number] in ('Area 4', 'Area 5') then  
        case  
            when [Trip Length] >= 210 then 'Invalid'  
            when [Oldest Age] < 80 then isnull([Purchase Path], 'Leisure')  
            when [Oldest Age] between 80 and 84 and [Trip Length] < 120 then isnull([Purchase Path], 'Leisure')  
            when [Oldest Age] between 85 and 89 and [Trip Length] >= 180 then 'Invalid'  
            when [Oldest Age] >= 90 and [Trip Length] >= 120 then 'Invalid'  
            else 'Age Approved'  
        end  
    end [Derived Purchase Path],  
    isnull([Derived Product Name], [Product Name]) [Derived Product Name],  
    isnull([Derived Product Plan], [Product Plan]) [Derived Product Plan],  
    isnull([Derived Product Type], [Product Type]) [Derived Product Type],  
    isnull([Derived Product Group], [Product Group]) [Derived Product Group],  
    isnull([Derived Policy Type], [Policy Type]) [Derived Policy Type],  
    isnull([Derived Plan Type], [Plan Type]) [Derived Plan Type],  
    isnull([Derived Trip Type], [Trip Type]) [Derived Trip Type],  
    isnull([Derived Product Classification], [Product Classification]) [Derived Product Classification],  
    isnull([Derived Finance Product Code], [Finance Product Code]) [Derived Finance Product Code],  
    isnull(do.[JV Code], o.[JV Code]) [JV Code],  
    isnull(do.[JV Description], o.[JV Description]) [JV Description],  
  
    case   
        when ds.Company = 'TIP' and (ds.[Issue Date] < '2017-06-01' or (ds.[Alpha Code] in ('APN0004', 'APN0005') and ds.[Issue Date] < '2017-07-01')) then 'TIP-GLA'  
        when ds.Company = 'TIP' and (ds.[Issue Date] >= '2017-06-01' or (ds.[Alpha Code] in ('APN0004', 'APN0005') and ds.[Issue Date] >= '2017-07-01')) then 'TIP-ZURICH'  
        when ds.[Domain Country] in ('AU', 'NZ') and ds.[Issue Date] >= '2009-07-01' and ds.[Issue Date] < '2017-06-01' then 'GLA'  
        when ds.[Domain Country] in ('AU', 'NZ') and ds.[Issue Date] >= '2017-06-01' then 'ZURICH'   
        when ds.[Domain Country] in ('AU', 'NZ') and ds.[Issue Date] <= '2009-06-30' then 'VERO'   
        when ds.[Domain Country] in ('UK') and ds.[Issue Date] >= '2009-09-01' then 'ETI'   
        when ds.[Domain Country] in ('UK') and ds.[Issue Date] < '2009-09-01' then 'UKU'   
        when ds.[Domain Country] in ('MY', 'SG') then 'ETIQA'   
        when ds.[Domain Country] in ('CN') then 'CCIC'   
        when ds.[Domain Country] in ('ID') then 'Simas Net'   
        when ds.[Domain Country] in ('US') then 'AON'  
        else 'OTHER'   
    end Underwriter  
  
from  
    ws.DWHDataSetSummary ds  
    outer apply  
    (  
        select top 1   
            do.OutletName [Outlet Name],  
            do.SubGroupCode [Outlet Sub Group Code],  
            do.SubGroupName [Outlet Sub Group Name],  
            do.GroupCode [Outlet Group Code],  
            do.GroupName [Outlet Group Name],  
            do.SuperGroupName [Outlet Super Group],  
            do.Channel [Outlet Channel],  
            do.BDMName [Outlet BDM],  
            do.ContactPostCode [Outlet Post Code],  
            do.StateSalesArea [Outlet Sales State Area],  
            do.TradingStatus [Outlet Trading Status],  
            do.OutletType [Outlet Type],  
            do.JV [JV Code],  
            do.JVDesc [JV Description]  
        from  
            [db-au-star]..dimOutlet do with(nolock)  
        where  
            do.OutletKey = ds.OutletKey and  
            do.isLatest = 'Y'  
    ) do  
    outer apply  
    (  
        select top 1   
            o.OutletName [Outlet Name],  
            o.SubGroupCode [Outlet Sub Group Code],  
            o.SubGroupName [Outlet Sub Group Name],  
            o.GroupCode [Outlet Group Code],  
            o.GroupName [Outlet Group Name],  
            o.SuperGroupName [Outlet Super Group],  
            '' [Outlet Channel],  
            o.BDMName [Outlet BDM],  
            o.ContactPostCode [Outlet Post Code],  
            o.StateSalesArea [Outlet Sales State Area],  
            o.TradingStatus [Outlet Trading Status],  
            o.OutletType [Outlet Type],  
            o.JVCode [JV Code],  
            o.JV [JV Description]  
        from  
            [db-au-cba]..penOutlet o with(nolock)  
        where  
            o.OutletKey = ds.OutletKey and  
            o.OutletStatus = 'Current'  
    ) o  
    outer apply  
    (  
        select top 1   
            dp.ProductName [Derived Product Name],  
            dp.ProductPlan [Derived Product Plan],  
            dp.ProductType [Derived Product Type],   
            dp.ProductGroup [Derived Product Group],  
            dp.PolicyType [Derived Policy Type],  
            dp.PlanType [Derived Plan Type],  
            dp.TripType [Derived Trip Type],  
            dp.ProductClassification [Derived Product Classification],  
            dp.FinanceProductCode [Derived Finance Product Code]  
        from  
            [db-au-star]..dimProduct dp  
        where  
            --trips policies  
            (  
                ds.[TRIPS Policy] = 1 or  
                ds.[Issue Date] < '2011-07-01'  
            ) and  
            dp.ProductCode = ds.[Product Code] and  
            (  
                dp.ProductPlan = ds.[Plan Code] or  
                dp.ProductPlan like '% ' + ds.[Plan Code] or  
                dp.ProductPlan like '%TRIPS' + ds.[Plan Code] or  
                (  
                    ds.[Plan Code] = 'DA' and  
                    dp.ProductPlan like '% ' + ds.[Plan Code] + '%'  
                ) or  
                (  
                    ds.[Plan Code] like 'X%' and  
                    ds.[Plan Code] <> 'X' and  
                    dp.ProductPlan like '%' + replace(ds.[Plan Code], 'X', '')  
                )  
            )  
    ) dp
  
  
  
  
  
  
  
  
  
  
  
  
  
GO
