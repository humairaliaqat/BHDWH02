USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[syssp_genericerrorhandler]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[syssp_genericerrorhandler]
    @SourceInfo varchar(250) = null,
    @LogToTable bit = 0,
    @BatchID int = -1,
    @PackageID varchar(100) = '',
    @SourceTable varchar(100) = null,
    @Record varchar(2000) = null,
    @TargetTable varchar(100) = null,
    @TargetField varchar(50) = null,
    @ErrorCode varchar(50) = null,
    @ErrorDescription varchar(2000) = null,
    @LogStart datetime = null,
    @LogEnd datetime = null,
    @LogStatus varchar(50) = '',
    @LogSourceCount int = null,
    @LogInsertCount int = null,
    @LogUpdateCount int = null

as
begin

/****************************************************************************************************/
--  Name:           syssp_genericerrorhandler
--  Author:         Leonardus Setyabudi
--  Date Created:   20111025
--  Description:    This stored procedure handle generic error message
--  Parameters:     @sourceinfo: error message
--
--  Change History:  
--                  20111025 - LS - Created
--                  20140801 - LS - log to table
--
/****************************************************************************************************/
--uncomment to debug
--declare 
--    @sourceinfo varchar(250)
--set @sourceinfo = 'Test'

    set nocount on

    declare
        @errnum int,
        @severity int,
        @errstate int,
        @procname varchar(250),
        @line int,
        @message varchar(4096)

    if isnull(@ErrorCode, '0') <> '0' 
    begin
    
        -- get error information
        select
            @errnum   = ERROR_NUMBER(),
            @severity = ERROR_SEVERITY(),
            @procname = ERROR_PROCEDURE(),
            @line     = ERROR_LINE(),
            @message  = ERROR_MESSAGE()

        set @sourceinfo =
            @sourceinfo +
            '
            Error: %d,
            Severity: %d,
            State: %d,
            Calling Procedure: %s at line %d
            Message: "%s"'

        -- display error
        raiserror(
            @sourceinfo,
            10, -- severity, warning/info
            1,
            @errnum,
            @severity,
            @errstate,
            @procname,
            @line,
            @message
        )
        
    end
        
    if @LogToTable = 1 and isnull(@ErrorCode, '0') not in ('', '0')
    begin
    
        insert into [db-au-log]..Package_Error_Log
        (
            Batch_ID,
            Package_ID,
            Source_Table,
            Record,
            Target_Table,
            Target_Field,
            Error_Code,
            Error_Description,
            Insert_Date
        )
        select
            @BatchID,
            @PackageID,
            isnull(@SourceTable, @procname),
            isnull(@Record, convert(varchar, @line)),
            @TargetTable,
            @TargetField,
            isnull(@ErrorCode, convert(varchar, @errnum)),
            isnull(@ErrorDescription, @message),
            getdate()
            
        exec syssp_closebatch
            @BatchID = @BatchID,
            @Error = 1

        raiserror('Force Stop', 16, 1)
    
    end

    else if @LogToTable = 1 and isnull(@ErrorCode, '0') in ('', '0')
    begin
    
        if object_id('tempdb..#log') is not null
            drop table #log
    
        select
            @BatchID BatchID,
            isnull(@PackageID, '') PackageID,
            isnull(@SourceTable, '') SourceTable,
            isnull(@LogStart, getdate()) LogStart,
            isnull(@LogEnd, getdate()) LogEnd,
            @LogStatus LogStatus,
            @LogSourceCount LogSourceCount,
            @LogInsertCount LogInsertCount,
            @LogUpdateCount LogUpdateCount
        into #log
        
        merge into [db-au-log]..Package_Run_Details t
        using #log s on
            s.BatchID = t.Batch_ID and
            s.PackageID collate database_default = t.Package_ID collate database_default
            
		when matched then
		
		    update
		    set
                Package_End_Time = s.LogEnd,
                Package_Status = s.LogStatus,
                Src_Record_Count = s.LogSourceCount,
                Insert_Record_Count = s.LogInsertCount,
                Update_Record_Count = s.LogUpdateCount
		    
		when not matched by target then
            insert 
            (
                Batch_ID,
                Package_ID,
                Package_Name,
                Package_Start_Time,
                Package_End_Time,
                Package_Status,
                Src_Record_Count,
                Insert_Record_Count,
                Update_Record_Count
            )
            values
            (
                s.BatchID,
                s.PackageID,
                s.SourceTable,
                s.LogStart,
                s.LogEnd,
                s.LogStatus,
                s.LogSourceCount,
                s.LogInsertCount,
                s.LogUpdateCount
            );
    
    end

end


GO
