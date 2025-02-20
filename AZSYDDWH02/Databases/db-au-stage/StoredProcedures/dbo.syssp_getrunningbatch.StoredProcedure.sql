USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[syssp_getrunningbatch]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create procedure [dbo].[syssp_getrunningbatch]
    @SubjectArea varchar(50),
    @BatchID int out,
    @StartDate date out,
    @EndDate date out

as
begin

/****************************************************************************************************/
--  Name:           syssp_getrunningbatch
--  Author:         Leonardus S
--  Date Created:   20140801
--  Description:    This stored procedure gets current running batch
--  Parameters:     @SubjectArea: ETL subject
--
--  Change History:
--                  20140801 - LS - Created
--
/****************************************************************************************************/

--debug
--declare
--    @SubjectArea varchar(50)
--select
--    @SubjectArea = 'Claim ODS'

    set nocount on

    declare
        @errmsg varchar(max),
        @errcode int,
        @procname varchar(max)

    select
        @errcode = 0,
        @procname = object_name(@@procid)

    begin try

        --get last batch on subject
        select top 1
            @BatchID = Batch_ID,
            @StartDate = Batch_Date,
            @EndDate = Batch_To_Date
        from
            [db-au-log]..Batch_Run_Status
        where
            Subject_Area = @SubjectArea and
            Batch_Status = 'Running'
        order by
            Batch_ID desc

        if @BatchID is null
        begin

            select
                @errcode = -1,
                @errmsg = 'no running instance found for ' + @SubjectArea,
                @BatchID = -1

            exec syssp_genericerrorhandler
                @sourceinfo = @errmsg,
                @LogToTable = 1,
                @SourceTable = @procname,
                @ErrorCode = @errcode,
                @ErrorDescription = @errmsg

        end

    end try

    begin catch

        select
            @errcode = -100,
            @errmsg = 'unable to retrieve running instance for ' + @SubjectArea + ', unknown error'

        exec syssp_genericerrorhandler
            @sourceinfo = @errmsg,
            @LogToTable = 1,
            @SourceTable = @procname,
            @ErrorCode = @errcode,
            @ErrorDescription = @errmsg

    end catch

    return @errcode

end


GO
