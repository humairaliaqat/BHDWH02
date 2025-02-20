USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL032_dimAgeBand]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_ETL032_dimAgeBand]
as
begin
/************************************************************************************************************************************
Author:         Linus Tor
Date:           20131114
Prerequisite:   Requires Penguin Data Model ETL successfully run.
                Requires [db-au-cmdwh].dbo.penCountry table available
Description:    dimAgeBand dimension table contains destination attributes.
Parameter:      @LoadType: value is Migration, Incremental
Change History:
                20131114 - LT - Procedure created
                20140710 - PW - Added ABS Age category and banding
                20140711 - PW - Removed type 2 references
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

    --create dimAgeBand if table does not exist
    if object_id('[db-au-star].dbo.dimAgeBand') is null
    begin

        create table [db-au-star].dbo.dimAgeBand
        (
            AgeBandSK int identity(1,1) not null,
            Age int not null,
            Code nvarchar(50) null,
            AgeBand nvarchar(50) null,
            ABSAgeBand nvarchar(50) null,
            ABSAgeCategory nvarchar(50) null,
            LoadDate datetime not null,
            updateDate datetime null,
            LoadID int not null,
            updateID int null,
            HashKey varbinary(30) null
        )

        create clustered index idx_dimAgeBand_AgeBandSK on [db-au-star].dbo.dimAgeBand(AgeBandSK)
        create nonclustered index idx_dimAgeBand_Age on [db-au-star].dbo.dimAgeBand(Age)
        create nonclustered index idx_dimAgeBand_AgeBand on [db-au-star].dbo.dimAgeBand(AgeBand)
        create nonclustered index idx_dimAgeBand_ABSAgeBand on [db-au-star].dbo.dimAgeBand(ABSAgeBand)
        create nonclustered index idx_dimAgeBand_ABSAgeCategory on [db-au-star].dbo.dimAgeBand(ABSAgeCategory)
        create nonclustered index idx_dimAgeBand_HashKey on [db-au-star].dbo.dimAgeBand(HashKey)

        set identity_insert [db-au-star].dbo.dimAgeBand on

        --populate dimension with default unknown values
        insert [db-au-star].dbo.dimAgeBand
        (
            AgeBandSK,
            Age,
            Code,
            AgeBand,
            ABSAgeBand,
            ABSAgeCategory,
            LoadDate,
            updateDate,
            LoadID,
            updateID,
            HashKey
        )
        values
        (
            -1,
            -1,
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            getdate(),
            null,
            @batchid,
            null,
            binary_checksum(0, 'UNKNOWN', 'UNKNOWN')
        )

        set identity_insert [db-au-star].dbo.dimAgeBand off

    end

    if object_id('[db-au-stage].dbo.etl_dimAgeBand') is not null
        drop table [db-au-stage].dbo.etl_dimAgeBand

    select
        a.Age,
        a.Code,
        a.[Description] as AgeBand,
        case
            when a.Age between 0 and 16 then '0-16'
            when a.Age between 17 and 24 then '17-24'
            when a.Age between 25 and 34 then '25-34'
            when a.Age between 35 and 49 then '35-49'
            when a.Age between 50 and 59 then '50-59'
            when a.Age between 60 and 64 then '60-64'
            when a.Age between 65 and 69 then '65-69'
            when a.Age between 70 and 74 then '70-74'
            when a.Age > 74 then '75+'
            else 'UNKNOWN'
        end as ABSAgeBand,
        case
            when a.Age between 0 and 16 then 'Child'
            when a.Age > 16 then 'Adult'
            else 'UNKNOWN'
        end as ABSAgeCategory,
        convert(datetime,null) as LoadDate,
        convert(datetime,null) as updateDate,
        convert(int,null) as LoadID,
        convert(int,null) as updateID,
        convert(varbinary,null) as HashKey
    into [db-au-stage].dbo.etl_dimAgeBand
    from
        [db-au-stage].dbo.etl_excel_agebands a

    --Update HashKey value
    update [db-au-stage].dbo.etl_dimAgeBand
    set
        HashKey = binary_checksum(Age, Code, AgeBand, ABSAgeBand, ABSAgeCategory)

    select
        @sourcecount = count(*)
    from
        [db-au-stage].dbo.etl_dimAgeBand

    begin transaction
    
    begin try

        -- Merge statement
        merge into [db-au-star].dbo.dimAgeBand as DST
        using [db-au-stage].dbo.etl_dimAgeBand as SRC
        on (src.Age = DST.Age)

        -- inserting new records
        when not matched by target then
        insert
        (
            Age,
            Code,
            AgeBand,
            ABSAgeBand,
            ABSAgeCategory,
            LoadDate,
            updateDate,
            LoadID,
            updateID,
            HashKey
        )
        values
        (
            SRC.Age,
            SRC.Code,
            SRC.AgeBand,
            SRC.ABSAgeBand,
            SRC.ABSAgeCategory,
            getdate(),
            null,
            @batchid,
            null,
            SRC.HashKey
        )

        -- update existing records where data has changed via HashKey
        when matched and DST.HashKey <> SRC.HashKey then
        update
        set
            DST.Age = SRC.Age,
            DST.Code = SRC.Code,
            DST.AgeBand = SRC.AgeBand,
            DST.ABSAgeBand = SRC.ABSAgeBand,
            DST.ABSAgeCategory = SRC.ABSAgeCategory,
            DST.HashKey = SRC.HashKey,
            DST.UpdateDate = getdate(),
            DST.UpdateID = @batchid

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
