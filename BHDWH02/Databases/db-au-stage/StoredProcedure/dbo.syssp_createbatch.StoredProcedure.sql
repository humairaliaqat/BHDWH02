USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[syssp_createbatch]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[syssp_createbatch]
    @SubjectArea varchar(50),
    @StartDate date = null,
    @EndDate date = null,
    @IncrementDate bit = 1

as
begin

/****************************************************************************************************/
--  Name:           syssp_createbatch
--  Author:         Leonardus S
--  Date Created:   20140801
--  Description:    This stored procedure creates etl batch
--  Parameters:     @SubjectArea: ETL subject
--                  @StartDate: optional start date, if null it will use previous run
--                  @EndDate: optional end date, if null it will use current date
--                  @IncrementDate: flag to increase @StartDate
--
--  Change History:
--                  20140801 - LS - Created
--
/****************************************************************************************************/

--debug
--declare
--    @SubjectArea varchar(50),
--    @StartDate date,
--    @EndDate date,
--    @IncrementDate bit
--select
--    @SubjectArea = 'Claim ODS',
--    @IncrementDate = 1

    set nocount on

    declare
        @batchdate date,
        @batchstatus varchar(10),
        @errmsg varchar(max),
        @errcode int,
        @procname varchar(max)

    select
        @errcode = 0,
        @procname = object_name(@@procid)

    begin try

        --get last batch on subject
        select top 1
            @batchdate = Batch_Date,
            @batchstatus = Batch_Status
        from
            [db-au-log]..Batch_Run_Status
        where
            Subject_Area = @SubjectArea
        order by
            Batch_ID desc


        if @batchstatus = 'Running'
        begin

            select
                @errcode = -1,
                @errmsg = 'unable to create new batch on ' + @SubjectArea + ', running instance found'

            exec syssp_genericerrorhandler
                @sourceinfo = @errmsg,
                @LogToTable = 1,
                @SourceTable = @procname,
                @ErrorCode = @errcode,
                @ErrorDescription = @errmsg

        end

        else
        begin

            insert into [db-au-log]..Batch_Run_Status
            (
                Subject_Area,
                Batch_Date,
                Batch_To_Date,
                Batch_Status,
                Batch_Start_Time
            )
            select
                @SubjectArea,
                isnull(@StartDate, isnull(dateadd(day, convert(int, @IncrementDate), @batchdate), dateadd(day, -30, getdate()))),
                isnull(@EndDate, getdate()),
                'Running',
                getdate()

        end

    end try

    begin catch

        select
            @errcode = -100,
            @errmsg = 'unable to create new batch on ' + @SubjectArea + ', unknown error'

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
