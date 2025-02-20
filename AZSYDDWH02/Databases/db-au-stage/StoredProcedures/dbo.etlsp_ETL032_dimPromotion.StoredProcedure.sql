USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL032_dimPromotion]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_ETL032_dimPromotion]
as
begin
/************************************************************************************************************************************
Author:         Linus Tor
Date:           20131114
Prerequisite:   Requires Penguin Data Model ETL successfully run.
                Requires [db-au-cba].dbo.penCountry table available
Description:    dimPromotion dimension table contains destination attributes.
Parameters:     @LoadType: value is Migration or Incremental
Change History:
                20131114 - LT - Procedure created
                20140710 - PW - Removed Domain references
                20140714 - PW - Removed type 2 references
                20140725 - LT - Amended merged statement
                20140905 - LS - refactoring
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


    --create dimCRMUser if table does not exist
    if object_id('[db-au-star].dbo.dimPromotion') is null
    begin
    
        create table [db-au-star].dbo.dimPromotion
        (
            PromotionSK int identity(1,1) not null,
            Country nvarchar(10) not null,
            PromotionKey nvarchar(50) not null,
            PromotionCode nvarchar(10) null,
            PromotionName nvarchar(250) null,
            PromotionType nvarchar(50) null,
            LoadDate datetime not null,
            updateDate datetime null,
            LoadID int not null,
            updateID int null,
            HashKey varbinary(30) null
        )
        
        create clustered index idx_dimPromotion_PromotionSK on [db-au-star].dbo.dimPromotion(PromotionSK)
        create nonclustered index idx_dimPromotion_Country on [db-au-star].dbo.dimPromotion(Country)
        create nonclustered index idx_dimPromotion_PromotionKey on [db-au-star].dbo.dimPromotion(PromotionKey)
        create nonclustered index idx_dimPromotion_PromotionCode on [db-au-star].dbo.dimPromotion(PromotionCode)
        create nonclustered index idx_dimPromotion_PromotionType on [db-au-star].dbo.dimPromotion(PromotionType)
        create nonclustered index idx_dimPromotion_HashKey on [db-au-star].dbo.dimPromotion(HashKey)

        set identity_insert [db-au-star].dbo.dimPromotion on

        --populate dimension with default unknown values
        insert [db-au-star].dbo.dimPromotion
        (
            PromotionSK,
            Country,
            PromotionKey,
            PromotionCode,
            PromotionName,
            PromotionType,
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
            getdate(),
            null,
            @batchid,
            null,
            binary_checksum(-1, -1, 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN', 'UNKNOWN')
        )

        set identity_insert [db-au-star].dbo.dimPromotion off
        
    end


    if object_id('[db-au-stage].dbo.etl_dimPromotion') is not null 
        drop table [db-au-stage].dbo.etl_dimPromotion
        
    select distinct
        isnull(d.CountryCode,'UNKNOWN') as Country,
        pr.PromoKey as PromotionKey,
        pr.PromoCode as PromotionCode,
        pr.PromoName as PromotionName,
        pr.PromoType as PromotionType,
        convert(datetime,null) as LoadDate,
        convert(datetime,null) as updateDate,
        convert(int,null) as LoadID,
        convert(int,null) as updateID,
        convert(varbinary,null) as HashKey
    into [db-au-stage].dbo.etl_dimPromotion
    from
        [db-au-cba].dbo.penPolicyTransactionPromo pr
        inner join [db-au-cba].dbo.penPolicyTransSummary pt on 
            pr.PolicyTransactionKey = pt.PolicyTransactionKey
        left join [db-au-star].dbo.dimDomain d on 
            pt.DomainID = d.DomainID



    --Update HashKey value
    update [db-au-stage].dbo.etl_dimPromotion
    set HashKey = binary_checksum(Country, PromotionKey, PromotionCode,PromotionName, PromotionType)


    select
        @sourcecount = count(*)
    from
        [db-au-stage].dbo.etl_dimPromotion

    begin transaction
    begin try

        -- Merge statement
        merge into [db-au-star].dbo.dimPromotion as DST
        using [db-au-stage].dbo.etl_dimPromotion as SRC
        on (src.PromotionKey = DST.PromotionKey)

        -- inserting new records
        when not matched by target then
        insert
        (
            Country,
            PromotionKey,
            PromotionCode,
            PromotionName,
            PromotionType,
            LoadDate,
            updateDate,
            LoadID,
            updateID,
            HashKey
        )
        values
        (
            SRC.Country,
            SRC.PromotionKey,
            SRC.PromotionCode,
            SRC.PromotionName,
            SRC.PromotionType,
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
            DST.PromotionKey = SRC.PromotionKey,
            DST.PromotionCode = SRC.PromotionCode,
            DST.PromotionName = SRC.PromotionName,
            DST.PromotionType = SRC.PromotionType,
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
