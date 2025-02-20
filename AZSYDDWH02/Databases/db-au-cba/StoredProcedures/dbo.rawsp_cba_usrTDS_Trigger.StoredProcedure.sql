USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rawsp_cba_usrTDS_Trigger]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[rawsp_cba_usrTDS_Trigger]
as
begin

/****************************************************************************************************/
--  Name:           rawsp_cba_usrTDS_Trigger
--  Author:         LL
--  Date Created:   20180925
--  Description:    create trigger file
--                    
--  Change History: 

/****************************************************************************************************/
	
	set nocount on

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


    --Formatter for file
    declare
        @dlt varchar(1),
        @recordcount int,
        @timestamp datetime,
        @version char(3),
        @name varchar(50),
        @Outputfilename varchar(100),
        @OutputPath varchar(200),
        @sql varchar(4096)

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

    set @version = isnull(@version, '001')
    set @OutputPath = isnull(@OutputPath, 'E:\ETL\Data\CBA\')
    set @Outputfilename = 'trigger.txt'


    --output data file
    select @SQL = 'bcp "select getdate()" queryout "'+ @OutputPath + @Outputfilename + '" -c -t -T -S AZSYDDWH02  -r "0x0A"'

    print @SQL

    execute master.dbo.xp_cmdshell @SQL

end


GO
