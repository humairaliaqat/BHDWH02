USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penProduct]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_cmdwh_penProduct]
as
begin

/************************************************************************************************************************************
Author:         Linus Tor
Date:           20130412
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    penProduct table contains product attributes.
                This transformation adds essential key fields and implemented slow changing dimension technique to track
                changes to the agency attributes.
Change History:
                20130412 - LT - Procedure created
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
				20160318 - LT - Penguin 18.0, added US penguin instance, FinanceProductID, FinanceProductCode, and FinanceProductName columns

*************************************************************************************************************************************/

    set nocount on

    if object_id('etl_penProduct') is not null
        drop table etl_penProduct

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, p.ProductID) ProductKey,
        p.ProductID,
        p.PurchasePathID,
        dbo.fn_GetReferenceValueByID(p.PurchasePathID, CompanyKey, CountrySet) PurchasePathName,
        p.ProductCode,
        p.ProductName,
        p.ProductDisplayName,
        p.isCancellation,
        p.DomainID,
		fp.FinanceProductID,
		fp.FinanceProductCode,
		fp.FinanceProductName
    into etl_penProduct
    from
        dbo.penguin_tblProduct_aucm p
        cross apply dbo.fn_GetDomainKeys(p.DomainID, 'CM', 'AU') dk
		outer apply
		(
			select top 1
				FinanceProductID,
				Code as FinanceProductCode,
				Name as FinanceProductName
			from
				dbo.penguin_tblFinanceProduct_aucm
			where
				FinanceProductID = p.FinanceProductID
		) fp

   

    --create penProduct table if not already created
    if object_id('[db-au-cba].dbo.penProduct') is null
    begin

        create table [db-au-cba].dbo.[penProduct]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [DomainKey] varchar(41) null,
            [ProductKey] varchar(33) null,
            [ProductID] int null,
            [PurchasePathID] int null,
            [PurchasePathName] nvarchar(50) null,
            [ProductCode] nvarchar(50) null,
            [ProductName] nvarchar(50) null,
            [ProductDisplayName] nvarchar(50) null,
            [isCancellation] bit null,
            [DomainID] int null,
			[FinanceProductID] int null,
			[FinanceProductCode] nvarchar(10) null,
			[FinanceProductName] nvarchar(125) null
        )

        create clustered index idx_penProduct_ProductKey on [db-au-cba].dbo.penProduct(ProductKey)
        create nonclustered index idx_penProduct_CountryKey on [db-au-cba].dbo.penProduct(CountryKey)
        create nonclustered index idx_penProduct_ProductCode on [db-au-cba].dbo.penProduct(ProductCode)

    end
    else
        delete [db-au-cba].dbo.penProduct
        from
            [db-au-cba].dbo.penProduct a
            join etl_penProduct b on
                a.CountryKey = b.CountryKey and
                a.ProductKey = b.ProductKey

    insert [db-au-cba].dbo.penProduct with(tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        ProductKey,
        ProductID,
        PurchasePathID,
        PurchasePathName,
        ProductCode,
        ProductName,
        ProductDisplayName,
        isCancellation,
        DomainID,
		FinanceProductID,
		FinanceProductCode,
		FinanceProductName
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        ProductKey,
        ProductID,
        PurchasePathID,
        PurchasePathName,
        ProductCode,
        ProductName,
        ProductDisplayName,
        isCancellation,
        DomainID,
		FinanceProductID,
		FinanceProductCode,
		FinanceProductName
    from dbo.etl_penProduct

end



GO
