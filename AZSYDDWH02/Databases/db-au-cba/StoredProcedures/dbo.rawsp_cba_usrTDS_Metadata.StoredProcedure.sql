USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rawsp_cba_usrTDS_Metadata]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rawsp_cba_usrTDS_Metadata]

as
begin

/****************************************************************************************************/
--  Name:           rawsp_cba_usrTDS_Metadata]
--  Author:         Leo
--  Date Created:   20180920
--  Description:    Inserts CBA Claim records into the CBA usrTDS_Claim table for the TDS exports
--                  
--  Change History: 

--                  20180919 - LL - adjusted for cba database structure
--                                  batch handling
/****************************************************************************************************/

--CBA TDS, logic: All claim details having claim received on day - 1

    declare 
        @batchid int,
        @spname varchar(50),
        @start date,
        @end date


    --get active batch
    exec [db-au-stage]..syssp_getrunningbatch
        @SubjectArea = 'CBA TDS',
        @BatchID = @batchid out,
        @StartDate = @start out,
        @EndDate = @end out

    select
        @spname = object_name(@@procid)

    exec syssp_genericerrorhandler
        @LogToTable = 1,
        @ErrorCode = '0',
        @BatchID = @batchid,
        @PackageID = @spname,
        @LogStatus = 'Running'

    --Formatter for file
    declare
        @dlt varchar(1),
        @recordcount int,
        @timestamp datetime,
        @version char(3),
        @name varchar(50),
        @Outputfilename varchar(100),
        @OutputPath varchar(200)

    declare
        @dump table
            (
                LineID int not null identity(1,1),
                Data nvarchar(max)
            )
            
    select 
        @version = Package_Status
    from
        [db-au-log]..Package_Run_Details
    where
        Batch_ID = @batchid and
        Package_ID = '[FILE_VERSION]'

    select 
        @OutputPath = Package_Status
    from
        [db-au-log]..Package_Run_Details
    where
        Batch_ID = @batchid and
        Package_ID = '[OUTPUT_PATH]'

    --constants
    set @dlt = '|'
    set @timestamp = getdate()
    set @name = 'COVERMORE_TRAVEL_INS_METADATA'

    set @version = isnull(@version, '001')
    set @OutputPath = isnull(@OutputPath, 'E:\ETL\Data\CBA\')
    set @Outputfilename = @name + '_' + convert(varchar, @timestamp, 112) + '_' + @version + '.DAT'

    insert into @dump (Data)
    select 
        Package_ID + @dlt + 'Delta' + '|' + convert(varchar, Insert_Record_Count)
    from
        [db-au-log].[dbo].[Package_Run_Details]
    where
        Package_Name = '[METADATA]' and
        Package_ID not like 'ANI%' and
        Batch_ID = @batchid

    if object_id('[db-au-workspace].dbo.TDSMetadata_Output') is null
        select 
            data 
        into [db-au-workspace].dbo.TDSMetadata_Output 
        from 
            @dump 


    declare @SQL varchar(8000)

    --output data file
    set @SQL = 'bcp "select Data from [db-au-workspace].dbo.TDSMetadata_Output" queryout "'+ @OutputPath + @Outputfilename + '" -c -t -T -S AZSYDDWH02  -r "0x0A"'

    execute master.dbo.xp_cmdshell @SQL

    if object_id('[db-au-workspace].dbo.TDSMetadata_Output') is not null
        drop table [db-au-workspace].dbo.TDSMetadata_Output


    ------ ANI
    delete 
    from
        @dump

    set @name = 'ANI_COVERMORE_TRAVEL_INS_METADATA'
    set @Outputfilename = @name + '_' + convert(varchar, @timestamp, 112) + '_' + @version + '.DAT'

    insert into @dump (Data)
    select 
        Package_ID + @dlt + 'Delta' + '|' + convert(varchar, Insert_Record_Count)
    from
        [db-au-log].[dbo].[Package_Run_Details]
    where
        Package_Name = '[METADATA]' and
        Package_ID like 'ANI%' and
        Batch_ID = @batchid

    if object_id('[db-au-workspace].dbo.TDSMetadata_Output') is null
        select 
            data 
        into [db-au-workspace].dbo.TDSMetadata_Output 
        from 
            @dump 


    --output data file
    set @SQL = 'bcp "select Data from [db-au-workspace].dbo.TDSMetadata_Output" queryout "'+ @OutputPath + @Outputfilename + '" -c -t -T -S AZSYDDWH02  -r "0x0A"'

    execute master.dbo.xp_cmdshell @SQL

    if object_id('[db-au-workspace].dbo.TDSMetadata_Output') is not null
        drop table [db-au-workspace].dbo.TDSMetadata_Output


end

GO
