USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penProductPlan]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penProductPlan]
as

/************************************************************************************************************************************
Author:         Linus Tor
Date:           20130412
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    penProductPlan table contains merged data of tblOutlet, tblPlan, tblProduct, and tblPlanArea.
                This transformation adds essential key fields.
Change History:
                20120201 - LT - Procedure created
                20130429 - LT - added PlanAreaID, AreaID, and AMTUpsellDisplayName columns
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20131009 - LT - Added TravellerSetID and TravellerSetName columns
                20131128 - LS - add clustered auto identity column to prevent disk sorting, this ETL deletes massive rows
                20140204 - LS - add PlanCode
                20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                                is this table still relevant?
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
				20160318 - LT - Penguin 18.0, added US penguin instance, FinanceProductID, FinanceProductCode and FinanceProductName columns
				20160323 - LT - Fixed Finance product linkaged from Product to Plan.

*************************************************************************************************************************************/

begin


    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penProductPlan') is not null
        drop table etl_penProductPlan

    select distinct
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, Outlet.OutletID) OutletKey,
        Outlet.DomainID,
        Outlet.OutletID,
        OutletProd.ID as OutletProductID,
        Prod.ProductId as ProductId,
        OTPProd2.SortOrder,
        Prod.ProductCode,
        Prod.PurchasePathID,
        dbo.fn_GetReferenceValueByID(Prod.PurchasePathID, CompanyKey, CountrySet) PurchasePath,
        OutletProd.CommissionTierID as CommissionTierID,
        dbo.fn_GetReferenceValueByID(OutletProd.CommissionTierID, CompanyKey, CountrySet) CommissionTier,
        OutletProd.VolumeCommission,
        OutletProd.Discount,
        OutletProd.ProductPricingTierID,
        OutletProd.DeclarationSetID,
        Prod.IsCancellation,
        OutletProd.IsStocked as Stocked,
        [Plan].PlanName,
        [Plan].DisplayName as PlanDisplayName,
        OutletProdPlan.UniquePlanID,
        OutletProdPlan.id as PlanId,
        OutletProdPlanSetting.DefaultExcess as DefaultExcess,
        OutletProdPlanSetting.MaxAdminFee as MaxAdminFee,
        OutletProdPlanSetting.IsUpsell as IsUpsell,
        PlanArea.PlanAreaID,
        PlanArea.AreaID,
        AMTUpsellDisplayName,
        PlanArea.PlanCode,
        ts.TravellerSetID,
        ts.Name as TravellerSetName,
        ts.MinimumAdult as MinimumAdult,
        ts.MaximumAdult as MaximumAdult,
        ts.MinimumChild as MinimumChild,
        ts.MaximumChild as MaximumChild,
		fp.FinanceProductID,
		case when ar.AreaType = 'International' then 'I' + fp.FinanceProductCode
			 when ar.AreaType = 'Domestic' then 'D' + fp.FinanceProductCode
			 when ar.AreaType = 'Domestic (Inbound)' then 'DI' + fp.FinanceProductCode
			 else 'Unknown'
		end as FinanceProductCode,
		fp.FinanceProductName
     into etl_penProductPlan
     from
        penguin_tblOutlet_aucm Outlet
        inner join penguin_tblOutlet_Product_aucm OutletProd on
            Outlet.OutletID = OutletProd.OutletId
        inner join penguin_tblProduct_aucm Prod on
            Prod.ProductId = OutletProd.ProductID
        inner join penguin_tblOutlet_ProductPlan_aucm OutletProdPlan on
            OutletProdPlan.OutletProductID = OutletProd.ID
        inner join penguin_tblOutlet_ProductPlanSettings_aucm OutletProdPlanSetting on
            OutletProdPlanSetting.OutletProductPlanID = OutletProdPlan.ID
        inner join penguin_tblPlan_aucm [Plan] on
            [Plan].UniquePlanID = OutletProdPlan.UniquePlanID
        inner join penguin_tblOTP_Product_aucm OTPProd on
            Prod.PurchasePathID = OTPProd.PurchasePathTypeID and
            Prod.ProductCode = OTPProd.ProductCode and
            Prod.IsCancellation = OTPProd.IsCancellation and
            Outlet.OTPId = OTPProd.OTPId
        inner join penguin_tblOTP_PlanProduct_aucm OTPProd2 on
            OTPProd.id = OTPProd2.OTP_ProductId and
            OTPProd2.UniquePlanID = [Plan].UniquePlanID
        cross apply dbo.fn_GetDomainKeys(Outlet.DomainId, 'CM', 'AU') dk
        inner join penguin_tblPlanArea_aucm PlanArea on
            [Plan].PlanId = PlanArea.PlanID
        inner join dbo.penguin_tblTravellerSet_aucm ts on
            [Plan].TravellerSetID = ts.TravellerSetID
        outer apply
        (
            select top 1
                Area AMTUpsellDisplayName
            from
                penguin_tblArea_aucm a
            where
                a.AreaId = PlanArea.AMTUpsellAreaId
        ) amt
		outer apply
		(
			select top 1
				FinanceProductID,
				Code as FinanceProductCode,
				Name as FinanceProductName
			from
				dbo.penguin_tblFinanceProduct_aucm
			where
				FinanceProductID = [plan].FinanceProductID
		) fp
        outer apply
        (
            select top 1
                case
                    when ar.Area like '%inbound%' then 'Domestic (Inbound)'
                    when ar.Domestic = 1 then 'Domestic'
                    when ar.Domestic = 0 then 'International'
                    else 'Unknown'
                end as AreaType,
                'Area ' + cast(ar.Weighting as varchar) as AreaNumber
            from
                penguin_tblPlan_aucm pl
                inner join penguin_tblPlanArea_aucm pa on
                    pl.PlanID = pa.PlanID
                inner join penguin_tblArea_aucm ar on
                    pa.AreaID = ar.AreaID and
                    ar.DomainID = prod.DomainID
            where
                pl.UniquePlanID = OutletProdPlan.UniquePlanID
        ) ar

  


    if object_id('[db-au-cba].dbo.penProductPlan') is null
    begin

        create table [db-au-cba].dbo.[penProductPlan]
        (
            [BIRowID] bigint not null identity (1,1),
            [CountryKey] varchar(2) null,
            [CompanyKey] varchar(5) null,
            [DomainKey] varchar(41) null,
            [OutletKey] varchar(41) null,
            [DomainID] int null,
            [OutletID] int null,
            [OutletProductId] int null,
            [ProductId] int null,
            [SortOrder] int null,
            [ProductCode] nvarchar(50) null,
            [PurchasePathId] int null,
            [PurchasePath] nvarchar(50) null,
            [CommissionTierId] int null,
            [CommissionTier] nvarchar(50) null,
            [VolumeCommission] decimal(18,5) null,
            [Discount] decimal(18,5) null,
            [ProductPricingTierId] int null,
            [DeclarationSetId] int null,
            [IsCancellation] bit null,
            [Stocked] bit null,
            [PlanName] nvarchar(50) null,
            [PlanDisplayName] nvarchar(50) null,
            [UniquePlanId] int null,
            [PlanId] int null,
            [DefaultExcess] money null,
            [MaxAdminFee] money null,
            [IsUpsell] bit null,
            [PlanAreaID] int null,
            [AreaID] int null,
            [AMTUpsellDisplayName] nvarchar(50) null,
            [TravellerSetID] int null,
            [TravellerSetName] varchar(100) null,
            [MinimumAdult] int null,
            [MaximumAdult] int null,
            [MinimumChild] int null,
            [MaximumChild] int null,
            [PlanCode] nvarchar(50) null,
			[FinanceProductID] int null,
			[FinanceProductCode] nvarchar(10) null,
			[FinanceProductName] nvarchar(125) null
        )

        create clustered index idx_penProductPlan_BIRowID on [db-au-cba].dbo.penProductPlan(BIRowID)
        create nonclustered index idx_penProductPlan_OutletKey on [db-au-cba].dbo.penProductPlan(OutletKey,ProductID,UniquePlanId) include (PlanName,PlanDisplayName,PlanCode,PlanId,AMTUpsellDisplayName,TravellerSetName,Discount,AreaID,CountryKey,CompanyKey,FinanceProductCode)
        create nonclustered index idx_penProductPlan_UniquePlanId on [db-au-cba].dbo.penProductPlan(UniquePlanId,ProductID) include (OutletKey,PlanName,PlanDisplayName,PlanCode,PlanId,AMTUpsellDisplayName,TravellerSetName,Discount,AreaID,CountryKey,CompanyKey,FinanceProductCode)

    end
    else
    begin

        delete a
        from
            [db-au-cba].dbo.penProductPlan a
            inner join etl_penProductPlan b on
                a.OutletKey = b.OutletKey

    end

    insert [db-au-cba].dbo.penProductPlan with(tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        OutletKey,
        DomainID,
        OutletID,
        OutletProductId,
        ProductId,
        SortOrder,
        ProductCode,
        PurchasePathId,
        PurchasePath,
        CommissionTierId,
        CommissionTier,
        VolumeCommission,
        Discount,
        ProductPricingTierId,
        DeclarationSetId,
        IsCancellation,
        Stocked,
        PlanName,
        PlanDisplayName,
        PlanCode,
        UniquePlanId,
        PlanId,
        DefaultExcess,
        MaxAdminFee,
        IsUpsell,
        PlanAreaID,
        AreaID,
        AMTUpsellDisplayName,
        TravellerSetID,
        TravellerSetName,
        MinimumAdult,
        MaximumAdult,
        MinimumChild,
        MaximumChild,
		FinanceProductID,
		FinanceProductCode,
		FinanceProductName
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        OutletKey,
        DomainID,
        OutletID,
        OutletProductId,
        ProductId,
        SortOrder,
        ProductCode,
        PurchasePathId,
        PurchasePath,
        CommissionTierId,
        CommissionTier,
        VolumeCommission,
        Discount,
        ProductPricingTierId,
        DeclarationSetId,
        IsCancellation,
        Stocked,
        PlanName,
        PlanDisplayName,
        PlanCode,
        UniquePlanId,
        PlanId,
        DefaultExcess,
        MaxAdminFee,
        IsUpsell,
        PlanAreaID,
        AreaID,
        AMTUpsellDisplayName,
        TravellerSetID,
        TravellerSetName,
        MinimumAdult,
        MaximumAdult,
        MinimumChild,
        MaximumChild,
		FinanceProductID,
		FinanceProductCode,
		FinanceProductName
    from
        etl_penProductPlan

end



GO
