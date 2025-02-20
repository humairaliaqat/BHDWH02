USE [db-au-actuary]
GO
/****** Object:  View [dbo].[DWHDataSet]    Script Date: 20/02/2025 10:01:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create view [dbo].[DWHDataSet] 
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
    isnull(do.[JV Code], o.[JV Code]) [JV Code],
    isnull(do.[JV Description], o.[JV Description]) [JV Description],

    case 
        when ds.Company = 'TIP' and (ds.[Issue Date] < '2017-06-01' or (ds.[Alpha Code] in ('APN0004', 'APN0005') and ds.[Issue Date] < '2017-07-01')) then 'TIP-GLA'
        when ds.Company = 'TIP' and (ds.[Issue Date] >= '2017-06-01' or (ds.[Alpha Code] in ('APN0004', 'APN0005') and ds.[Issue Date] >= '2017-07-01')) then 'TIP-ZURICH'
        when ds.[Domain Country] in ('AU', 'NZ') and ds.[Issue Date] >= '2009-07-01' and ds.[Issue Date] < '2017-06-01' then 'GLA'
        when ds.[Domain Country] in ('AU', 'NZ') and ds.[Issue Date] >= '2017-06-01' then 'ZURICH' 
        when ds.[Domain Country] in ('AU', 'NZ') and ds.[Transaction Issue Date] <= '2009-06-30' then 'VERO' 
        when ds.[Domain Country] in ('UK') and ds.[Transaction Issue Date] >= '2009-09-01' then 'ETI' 
        when ds.[Domain Country] in ('UK') and ds.[Transaction Issue Date] < '2009-09-01' then 'UKU' 
        when ds.[Domain Country] in ('MY', 'SG') then 'ETIQA' 
        when ds.[Domain Country] in ('CN') then 'CCIC' 
        when ds.[Domain Country] in ('ID') then 'Simas Net' 
        when ds.[Domain Country] in ('US') then 'AON'
        else 'OTHER' 
    end Underwriter

from
    ws.DWHDataSet ds
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










GO
