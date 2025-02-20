USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_e5WorkActivityProperties_v3]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_e5WorkActivityProperties_v3]
as
begin
/*
20141211, LS, create
20150708, LS, T16817, NZ e5 v3
20180928, LT, Customised for CBA
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

    if object_id('[db-au-cba].dbo.e5WorkActivityProperties_v3') is null
    begin

        create table [db-au-cba].[dbo].e5WorkActivityProperties_v3
        (
            [BIRowID] bigint not null identity(1,1),
            [Domain] varchar(5),
            [Country] varchar(5), 
            Work_ID varchar(50),
            WorkActivity_ID varchar(50),
            [Original_Work_ID] uniqueidentifier not null,
            [Original_WorkActivity_ID] uniqueidentifier null,
            [Property_ID] nvarchar(32) null,
            [PropertyValue] sql_variant null,
            [UpdateBatchID] int
        )

        create clustered index idx_e5WorkActivityProperties_v3_BIRowID on [db-au-cba].dbo.e5WorkActivityProperties_v3(BIRowID)
        create nonclustered index idx_e5WorkActivityProperties_v3_WorkActivity_ID on [db-au-cba].dbo.e5WorkActivityProperties_v3(WorkActivity_ID,Property_ID) include(Work_ID,PropertyValue)
        create nonclustered index idx_e5WorkActivityProperties_v3_ID on [db-au-cba].dbo.e5WorkActivityProperties_v3(Work_ID,WorkActivity_ID,Property_ID) include (Domain,Country,PropertyValue)
        create nonclustered index idx_e5WorkActivityProperties_Property_ID on [db-au-cba].dbo.e5WorkActivityProperties_v3(Property_ID) include (WorkActivity_ID,PropertyValue)

    end

    if object_id('tempdb..#e5WorkActivityProperties_v3') is not null
        drop table #e5WorkActivityProperties_v3

    select
        Domain,
        Country,
        Country + Domain + convert(varchar(40), Work_ID) Work_ID,
        Country + Domain + convert(varchar(40), WorkActivity_ID) WorkActivity_ID,
        Work_ID Original_Work_ID,
        WorkActivity_ID Original_WorkActivity_ID,
        Property_ID collate database_default Property_ID,
        PropertyValue
    into #e5WorkActivityProperties_v3
    from
        e5_WorkActivityProperty_v3 wap
        cross apply
        (
            select top 1 
                w.Category1_Id
            from
                e5_Work_v3 w
            where
                w.Id = wap.Work_Id
        ) w
        cross apply
        (
            select top 1
                [Code] collate database_default [Code],
                [Name] collate database_default [Name]
            from
                e5_Category1_v3
            where
                Id = w.Category1_Id
        ) bn
        cross apply
        (
            select
                'V3' Domain,
                bn.Code Country
        ) dm


    set @sourcecount = @@rowcount

    begin transaction

    begin try

        delete 
        from
            [db-au-cba].[dbo].[e5WorkActivityProperties_v3] 
        where
            WorkActivity_ID in
            (
                select 
                    WorkActivity_ID
                from
                    #e5WorkActivityProperties_v3
            )

        insert into [db-au-cba].[dbo].[e5WorkActivityProperties_v3] with(tablock)
        (
            Domain,
            Country,
            Work_ID,
            WorkActivity_ID,
            Original_Work_ID,
            Original_WorkActivity_ID,
            Property_ID,
            PropertyValue,
            UpdateBatchID
        )
        select
            s.Domain,
            s.Country,
            s.Work_ID,
            s.WorkActivity_ID,
            s.Original_Work_ID,
            s.Original_WorkActivity_ID,
            s.Property_ID,
            s.PropertyValue,
            @batchid
        from
            #e5WorkActivityProperties_v3 s

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
            @SourceInfo = 'e5WorkActivityProperties_v3 data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end
GO
