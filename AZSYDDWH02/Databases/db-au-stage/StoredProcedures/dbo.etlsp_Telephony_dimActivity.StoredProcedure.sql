USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_Telephony_dimActivity]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_Telephony_dimActivity]
as
begin
/************************************************************************************************************************************
Author:         Leo
Date:           20141217
Prerequisite:   Verint
Description:    
Change History:
                20141217 - LS - created

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
        @SubjectArea = 'Telephony STAR',
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

    if object_id('[db-au-star].dbo.dimActivity') is null
    begin

        create table [db-au-star].dbo.dimActivity
        (
            ActivitySK int not null identity(1,1),
            ActivityID int,
            ActivityName nvarchar(255),
            ActivityDescription nvarchar(255),
            CreateBatchID int,
            UpdateBatchID int
        )
        
        create clustered index idx_dimActivity_ActivitySK on [db-au-star].dbo.dimActivity(ActivitySK)
        create nonclustered index idx_dimActivity_ActivityID on [db-au-star].dbo.dimActivity(ActivityID)
        
        set identity_insert [db-au-star].dbo.dimActivity on

        insert [db-au-star].[dbo].dimActivity
        (
            ActivitySK,
            ActivityID,
            ActivityName,
            ActivityDescription,
            CreateBatchID,
            UpdateBatchID
        )
        values
        (
            -1,
            null,
            'UNKNOWN',
            'UNKNOWN',
            @batchid,
            @batchid
        )

        set identity_insert [db-au-star].dbo.dimActivity off
        
    end
    
    if object_id('tempdb..#dimActivity') is not null
        drop table #dimActivity

    select 
        ActivityKey ActivityID,
        ActivityName,
        ActivityDescription
    into #dimActivity
    from
        [db-au-cba]..verActivity
    
    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-star].dbo.dimActivity with(tablock) t
        using #dimActivity s on
            s.ActivityID = t.ActivityID

        when
            matched and
            binary_checksum(
                t.ActivityName,
                t.ActivityDescription
            ) <>
            binary_checksum(
                s.ActivityName,
                s.ActivityDescription
            )
        then

            update
            set
                ActivityName = s.ActivityName,
                ActivityDescription = s.ActivityDescription,
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                ActivityID,
                ActivityName,
                ActivityDescription,
                CreateBatchID
            )
            values
            (
                s.ActivityID,
                s.ActivityName,
                s.ActivityDescription,
                @batchid
            )

        output $action into @mergeoutput
        ;

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
            @SourceInfo = 'Failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end

GO
