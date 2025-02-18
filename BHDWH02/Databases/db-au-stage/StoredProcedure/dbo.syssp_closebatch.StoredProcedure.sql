USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[syssp_closebatch]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[syssp_closebatch]
    @BatchID int,
    @Error bit = 0

as
begin

/****************************************************************************************************/
--  Name:           syssp_closebatch
--  Author:         Leonardus S
--  Date Created:   20140814
--  Description:    This stored procedure close specific batch
--  Parameters:     @SubjectArea: ETL subject
--
--  Change History:  
--                  20140814 - LS - Created
--
/****************************************************************************************************/

    set nocount on

    declare
        @errmsg varchar(max),
        @errcode int,
        @procname varchar(max)
    
    select 
        @errcode = 0,
        @procname = object_name(@@procid)
    
    begin try

        update l
        set
            Batch_End_Time = getdate(),
            Batch_Status = 
                case
                    when @Error = 1 then 'Error'
                    when isnull(ec.ErrorCount, 0) > 0 then 'Error'
                    else 'Success'
                end
        from
            [db-au-log]..Batch_Run_Status l
            outer apply
            (
                select 
                    count(*) ErrorCount
                from
                    [db-au-log]..Package_Error_Log e
                where
                    e.Batch_ID = l.Batch_ID
            ) ec
        where
            l.Batch_ID = @BatchID
        
    end try
    
    begin catch
    
        select 
            @errcode = -100,
            @errmsg = 'unable to close batch ' + convert(varchar, @BatchID)
        
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
