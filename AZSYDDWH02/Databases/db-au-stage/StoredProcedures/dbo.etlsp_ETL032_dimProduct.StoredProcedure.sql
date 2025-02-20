USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL032_dimProduct]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_ETL032_dimProduct]
as
begin
/************************************************************************************************************************************
Author:         Linus Tor
Date:           20131114
Prerequisite:   Requires Penguin Data Model ETL successfully run.
                Requires [db-au-cmdwh].dbo.penCountry table available
Description:    dimProduct dimension table contains destination attributes.
Parameters:     @LoadType: value is Migration or Incremental
Change History:
                20131114 - LT - Procedure created
                20140710 - PW - Removed Domain references
                20140714 - PW - Removed type 2 references
                20140905 - LS - refactoring
                20141119 - LS - add PlanType & TripType
                20150204 - LS - replace batch codes with standard batch logging

*************************************************************************************************************************************/

    set nocount on

    declare
        @batchid int,
        @start date,
        @end date,
        @name varchar(50),
        @sourcecount int,
        @insertcount int,
        @updatecount int

    declare @mergeoutput table (MergeAction varchar(20))

    exec syssp_getrunningbatch
        @SubjectArea = 'Policy Star',
        @BatchID = @batchid out,
        @StartDate = @start out,
        @EndDate = @end out

    select
        @name = object_name(@@procid)

    exec syssp_genericerrorhandler
        @LogToTable = 1,
        @ErrorCode = '0',
        @BatchID = @batchid,
        @PackageID = @name,
        @LogStatus = 'Running'


    --create dimProduct if table does not exist
    if object_id('[db-au-star].dbo.dimProduct') is null
    begin
    
        create table [db-au-star].dbo.dimProduct
        (
            ProductSK int identity(1,1) not null,
            Country nvarchar(10) not null,
            ProductKey nvarchar(100) null,
            ProductCode nvarchar(50) null,
            ProductName nvarchar(100) null,
            ProductPlan nvarchar(100) null,
            ProductType nvarchar(100) null,
            ProductGroup nvarchar(100) null,
            PolicyType nvarchar(50) null,
            ProductClassification nvarchar(100) null,
            PlanType nvarchar(50) null,
            TripType nvarchar(50) null,
            FinanceProductCode nvarchar(50) null,
            FinanceProductCodeOld nvarchar(50) null,
            LoadDate datetime not null,
            updateDate datetime null,
            LoadID int not null,
            updateID int null,
            HashKey varbinary(30) null
        )
        
        create clustered index idx_dimProduct_ProductSK on [db-au-star].dbo.dimProduct(ProductSK)
        create nonclustered index idx_dimProduct_Country on [db-au-star].dbo.dimProduct(Country)
        create nonclustered index idx_dimProduct_ProductKey on [db-au-star].dbo.dimProduct(ProductKey) include (Country,ProductSK)
        create nonclustered index idx_dimProduct_ProductCode on [db-au-star].dbo.dimProduct(ProductCode)
        create nonclustered index idx_dimProduct_HashKey on [db-au-star].dbo.dimProduct(HashKey)

        set identity_insert [db-au-star].dbo.dimProduct on

        --populate dimension with default unknown values
        insert [db-au-star].dbo.dimProduct
        (
            ProductSK,
            Country,
            ProductKey,
            ProductCode,
            ProductName,
            ProductPlan,
            ProductType,
            ProductGroup,
            PolicyType,
            ProductClassification,
            PlanType,
            TripType,
            FinanceProductCode,
            FinanceProductCodeOld,
            LoadDate,
            updateDate,
            LoadID,
            updateID,
            HashKey
        )
        values
        (
            -1,
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            getdate(),
            null,
            @batchid,
            null,
            binary_checksum(-1, -1, 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN')
        )

        set identity_insert [db-au-star].dbo.dimProduct off
        
    end


    if object_id('[db-au-stage].dbo.etl_dimProduct') is not null 
        drop table [db-au-stage].dbo.etl_dimProduct
        
    select distinct
        isnull(d.CountryCode,'UNKNOWN') as Country,
        isnull(p.CountryKey,'') + '-' + isnull(p.CompanyKey,'') + '' + convert(varchar,isnull(p.DomainID,0)) + '-' + isnull(p.ProductCode,'') + '-' + isnull(p.ProductName,'') + '-' + isnull(p.ProductDisplayName,'') + '-' + isnull(p.PlanName,'') as ProductKey,
        isnull(p.ProductCode, '') ProductCode,
        isnull(p.ProductDisplayName, '') as ProductName,
        case when p.PlanName is null or p.PlanName = '' then p.ProductCode + ' ' + p.ProductDisplayName
             else p.ProductCode + ' ' + p.ProductDisplayName + ' ' + isnull(p.PlanName,'')
        end as ProductPlan,
        isnull(p.ProductType, '') ProductType,
        isnull(p.ProductGroup, '') ProductGroup,
        isnull(p.PolicyType, '') PolicyType,
        isnull(p.ProductClassification, '') ProductClassification,
        isnull(p.PlanType, '') PlanType,
        isnull(p.TripType, '') TripType,
        isnull(p.FinanceProductCode, '') FinanceProductCode,
        isnull(p.FinanceProductCodeOld, '') FinanceProductCodeOld,
        convert(datetime,null) as LoadDate,
        convert(datetime,null) as updateDate,
        convert(int,null) as LoadID,
        convert(int,null) as updateID,
        convert(varbinary,null) as HashKey
    into [db-au-stage].dbo.etl_dimProduct
    from
        [db-au-stage].dbo.etl_excel_Product p
        left join [db-au-star].dbo.dimDomain d on
            p.DomainID = d.DomainID

    --Update HashKey value
    update [db-au-stage].dbo.etl_dimProduct
    set 
        HashKey = 
            binary_checksum(
                Country, 
                ProductKey,    
                ProductCode, 
                ProductName, 
                ProductPlan, 
                ProductType, 
                ProductGroup, 
                PolicyType, 
                ProductClassification, 
                PlanType,
                TripType,
                FinanceProductCode, 
                FinanceProductCodeOld
            )


    select
        @sourcecount = count(*)
    from
        [db-au-stage].dbo.etl_dimProduct

    begin transaction
    begin try

        -- Merge statement
        merge into [db-au-star].dbo.dimProduct as DST
        using [db-au-stage].dbo.etl_dimProduct as SRC
        on (SRC.ProductKey = DST.ProductKey)

        -- inserting new records
        when not matched by target then
        insert
        (
            Country,
            ProductKey,
            ProductCode,
            ProductName,
            ProductPlan,
            ProductType,
            ProductGroup,
            PolicyType,
            ProductClassification,
            PlanType,
            TripType,
            FinanceProductCode,
            FinanceProductCodeOld,
            LoadDate,
            updateDate,
            LoadID,
            updateID,
            HashKey
        )
        values
        (
            SRC.Country,
            SRC.ProductKey,
            SRC.ProductCode,
            SRC.ProductName,
            SRC.ProductPlan,
            SRC.ProductType,
            SRC.ProductGroup,
            SRC.PolicyType,
            SRC.ProductClassification,
            SRC.PlanType,
            SRC.TripType,
            SRC.FinanceProductCode,
            SRC.FinanceProductCodeOld,
            getdate(),
            null,
            @batchid,
            null,
            SRC.HashKey
        )
        
        -- update existing records where data has changed via HashKey
        when matched and DST.HashKey <> SRC.HashKey then
        update
        set DST.Country = SRC.Country,
            DST.ProductKey = SRC.ProductKey,
            DST.ProductCode = SRC.ProductCode,
            DST.ProductName = SRC.ProductName,
            DST.ProductPlan = SRC.ProductPlan,
            DST.ProductType = SRC.ProductType,
            DST.ProductGroup = SRC.ProductGroup,
            DST.PolicyType = SRC.PolicyType,
            DST.ProductClassification = SRC.ProductClassification,
            DST.PlanType = SRC.PlanType,
            DST.TripType = SRC.TripType,
            DST.FinanceProductCode = SRC.FinanceProductCode,
            DST.FinanceProductCodeOld = SRC.FinanceProductCodeOld,
            DST.UpdateDate = getdate(),
            DST.UpdateID = @batchid,
            DST.HashKey = SRC.HashKey
            
        output $action into @mergeoutput;

        select
            @insertcount =
                sum(
                    case
                        when MergeAction = 'insert' then 1
                        else 0
                    end
                ),
            @updatecount =
                sum(
                    case
                        when MergeAction = 'update' then 1
                        else 0
                    end
                )
        from
            @mergeoutput

        exec syssp_genericerrorhandler
            @LogToTable = 1,
            @ErrorCode = '0',
            @BatchID = @batchid,
            @PackageID = @name,
            @LogStatus = 'Finished',
            @LogSourceCount = @sourcecount,
            @LogInsertCount = @insertcount,
            @LogUpdateCount = @updatecount

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end

GO
