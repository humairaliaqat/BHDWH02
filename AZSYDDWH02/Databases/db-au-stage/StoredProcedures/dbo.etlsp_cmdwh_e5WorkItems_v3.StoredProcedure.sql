USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_e5WorkItems_v3]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_e5WorkItems_v3]
as
begin
/*
20141210, LS,   split out from e5Work_v3
                use batch
                bill this to claim portfolio/dashboard
20150708, LS,   T16817, NZ e5 v3
20180928, LT,	Customised for CBA
*/

    set nocount on

    exec etlsp_StagingIndex_e5_v3

    declare
        @batchid int,
        @start date,
        @end date,
        @name varchar(50),
        @sourcecount int,
        @insertcount int,
        @updatecount int

    declare @mergeoutput table (MergeAction varchar(20))

	begin try
	
		exec syssp_getrunningbatch
			@SubjectArea = 'e5 ODS',
			@BatchID = @batchid out,
			@StartDate = @start out,
			@EndDate = @end out
			
	end try
	
	begin catch
		
		set @batchid = -1
	
	end catch

    select
        @name = object_name(@@procid)

    exec syssp_genericerrorhandler
        @LogToTable = 1,
        @ErrorCode = '0',
        @BatchID = @batchid,
        @PackageID = @name,
        @LogStatus = 'Running'

    if object_id('[db-au-cba].dbo.e5WorkItems_v3') is null
    begin

        create table [db-au-cba].[dbo].[e5WorkItems_v3]
        (
            [BIRowID] bigint not null identity(1,1),
            [Domain] varchar(5),
            [ItemKey] varchar(50),
            [ID] [int] not null,
            [Code] [nvarchar](32) null,
            [Name] [nvarchar](400) null,
            [CreateBatchID] int,
            [UpdateBatchID] int,
            [DeleteBatchID] int
        )

        create clustered index idx_e5WorkItems_v3_BIRowID on [db-au-cba].dbo.e5WorkItems_v3(BIRowID)
        create nonclustered index idx_e5WorkItems_v3_ItemKey on [db-au-cba].dbo.e5WorkItems_v3(ItemKey) include(Code,Name)
        create nonclustered index idx_e5WorkItems_v3_ID on [db-au-cba].dbo.e5WorkItems_v3(ID,Domain) include(Code,Name)
        create nonclustered index idx_e5WorkItems_v3_Name on [db-au-cba].dbo.e5WorkItems_v3(Name) include(Code,ID)

    end


    if object_id('tempdb..#e5WorkItems_v3') is not null
        drop table #e5WorkItems_v3

    select
        'V3' Domain,
        'V3' + convert(varchar, [ID]) ItemKey,
        ID,
        [Code] collate database_default [Code],
        [Name] collate database_default [Name]
    into #e5WorkItems_v3
    from
        e5_ListItem_v3

    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-cba].[dbo].[e5WorkItems_v3] with(tablock) t
        using #e5WorkItems_v3 s on
            s.ItemKey = t.ItemKey

        when matched then

            update
            set
                Domain = s.Domain,
                Code = s.Code,
                Name = s.Name,
                UpdateBatchID = @batchid,
                DeleteBatchID = null

        when not matched by target then
            insert
            (
                Domain,
                ItemKey,
                ID,
                Code,
                Name,
                CreateBatchID
            )
            values
            (
                s.Domain,
                s.ItemKey,
                s.ID,
                s.Code,
                s.Name,
                @batchid
            )

        when
            not matched by source and
            DeleteBatchID is null
        then

            update
            set
                DeleteBatchID = @batchid

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
            @SourceInfo = 'e5WorkItems_v3 data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end
GO
