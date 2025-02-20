USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_e5WorkActivity_v3]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE procedure [dbo].[etlsp_cmdwh_e5WorkActivity_v3]
as
begin
/*
20150708, LS, T16817, NZ e5 v3
20151118, LS, Dane found a bug with assessment outcome not reflected in WA (OSAssessmentOutcome)
20180928, LT, Customised for CBA
20240623, SB, As part of claims Uplift(E5 classic to E5 connect) User details were updated according to respective joins (CHG0039218).
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

    if object_id('[db-au-cba].dbo.e5WorkActivity_v3') is null
    begin

        create table [db-au-cba].dbo.e5WorkActivity_v3
        (
            [BIRowID] bigint not null identity(1,1),
            [Domain] varchar(5) null,
            [Country] varchar(5) null,
            [Work_ID] varchar(50),
            [ID] varchar(50) null,
            [Original_ID] uniqueidentifier not null,
            [Original_Work_ID] uniqueidentifier not null,
            [WorkActivity_ID] bigint null,
            [CategoryActivityName] nvarchar(100) null,
            [StatusName] nvarchar(100) null,
            [SortOrder] int null,
            [CreationDate] datetime null,
            [CreationUserID] nvarchar(100) null,
            [CreationUser] nvarchar(455) null,
            [CompletionDate] datetime null,
            [CompletionUserID] nvarchar(100) null,
            [CompletionUser] nvarchar(455) null,
            [AssignedDate] datetime null,
            [AssignedUserID] nvarchar(100) null,
            [AssignedUser] nvarchar(455) null,
            [DueDate] datetime null,
            [AssessmentOutcome] int null,
            [AssessmentOutcomeDescription] nvarchar(400) null,
            [CreateBatchID] int,
            [UpdateBatchID] int,
            [DeleteBatchID] int
        )

        create clustered index idx_e5WorkActivity_v3_BIRowID on [db-au-cba].dbo.e5WorkActivity_v3(BIRowID)
        create nonclustered index idx_e5WorkActivity_v3_ID on [db-au-cba].dbo.e5WorkActivity_v3(ID)
        create nonclustered index idx_e5WorkActivity_v3_Work_ID on [db-au-cba].dbo.e5WorkActivity_v3(Work_ID) include(ID,Country,CategoryActivityName,StatusName,CompletionDate,CompletionUser,AssessmentOutcome,AssessmentOutcomeDescription)
        create nonclustered index idx_e5Work_v3Act_CatActName on [db-au-cba].dbo.e5WorkActivity_v3(CategoryActivityName,CompletionDate) include (ID,CompletionUser,AssessmentOutcome,AssessmentOutcomeDescription,Work_ID)
        create nonclustered index idx_e5Work_v3Act_CompletionDate on [db-au-cba].dbo.e5WorkActivity_v3(CompletionDate) include (Work_ID,ID,AssessmentOutcome,AssessmentOutcomeDescription)
        create nonclustered index idx_e5Work_v3Act_CreationDate on [db-au-cba].dbo.e5WorkActivity_v3(CreationDate) include (Work_ID,ID,AssessmentOutcome,AssessmentOutcomeDescription)


    end

    if object_id('tempdb..#e5WorkActivity_v3') is not null
        drop table #e5WorkActivity_v3

    select
        Domain,
        Country,
        Country + Domain + convert(varchar(40), wa.Work_ID) Work_ID,
        Country + Domain + convert(varchar(40), wa.ID) ID,
        Work_ID Original_Work_ID,
        ID Original_ID,
        wa.[_Id] as WorkActivity_ID,
        (
            select top 1
                [name] collate database_default
            from
                e5_CategoryActivity_v3
            where
                Id = wa.[CategoryActivity_ID]
        ) CategoryActivityName,
        (
            select top 1
                [name] collate database_default
            from
                e5_status_v3
            where
                Id = wa.[Status_ID]
        ) StatusName,
        wa.[SortOrder],
        wa.[CreationDate],
        uscr.CreationUser collate database_default CreationUserID,
        (
            select top 1
                l.DisplayName
            from
                [db-au-cba]..usrLDAP l
            where
                l.UserName = replace(uscr.CreationUser, 'covermore\', '') collate database_default 
            order by
                case
                    when DeleteDateTime is null then 0
                    else 1
                end
        ) CreationUser,
        wa.[CompletionDate],
        usco.CompletionUser collate database_default CompletionUserID,
        (
            select top 1
                l.DisplayName
            from
                [db-au-cba]..usrLDAP l
            where
                l.UserName = replace(usco.CompletionUser, 'covermore\', '') collate database_default 
            order by
                case
                    when DeleteDateTime is null then 0
                    else 1
                end
        ) CompletionUser,
        wa.[AssignedDate],
        us.AssignedUser collate database_default AssignedUserID,
        (
            select top 1
                l.DisplayName
            from
                [db-au-cba]..usrLDAP l
            where
                l.UserName = replace(us.AssignedUser, 'covermore\', '') collate database_default 
            order by
                case
                    when DeleteDateTime is null then 0
                    else 1
                end
        ) AssignedUser,
        wa.[SLAExpiryDate] DueDate,
        wacp.AssessmentOutcome,
        wao.AssessmentOutcomeDescription
    into #e5WorkActivity_v3
    from
        e5_WorkActivity_v3 wa
        cross apply
        (
            select top 1 
                w.Category1_Id
            from
                e5_Work_v3 w
            where
                w.Id = wa.Work_Id
        ) w
		outer apply  --Userdetails added as part of Claims uplift (CHG0039218): SB
        (
            select top 1
                u.UserName collate database_default AssignedUser
            from
                e5_User_v3 u
            where
                u.Id = wa.AssignedUser
        ) us
		outer apply  --Userdetails added as part of Claims uplift (CHG0039218): SB
        (
            select top 1
                u.UserName collate database_default CreationUser
            from
                e5_User_v3 u
            where
                u.Id = wa.CreationUser
        ) uscr
		outer apply  --Userdetails added as part of Claims uplift (CHG0039218): SB
        (
            select top 1
                u.UserName collate database_default CompletionUser
            from
                e5_User_v3 u
            where
                u.Id = wa.CompletionUser
        ) usco
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
        ) d
        outer apply
        (
            select top 1
                convert(int, max(PropertyValue)) AssessmentOutcome
            from
                e5_WorkActivityProperty_v3 wacp
                inner join e5_Property_v3 p on
                    p.Id = wacp.Property_Id
            where
                wacp.Work_Id = wa.Work_Id and
                wacp.WorkActivity_Id = wa.Id and
                p.PropertyLabel = 'Assessment Outcome'
        ) wacp
        outer apply
        (
            select top 1
                i.Name  collate database_default AssessmentOutcomeDescription
            from
                e5_ListItem_v3 i
            where
                i.Id = wacp.AssessmentOutcome
        ) wao


    set @sourcecount = @@rowcount


    begin transaction

    begin try

        merge into [db-au-cba].[dbo].[e5WorkActivity_v3] with(tablock) t
        using #e5WorkActivity_v3 s on
            s.ID = t.ID

        when matched then

            update
            set
                Domain = s.Domain,
                Country = s.Country,
                Work_ID = s.Work_ID,
                Original_Work_ID = s.Original_Work_ID,
                Original_ID = s.Original_ID,
                WorkActivity_ID = s.WorkActivity_ID,
                CategoryActivityName = s.CategoryActivityName,
                StatusName = s.StatusName,
                SortOrder = s.SortOrder,
                CreationDate = s.CreationDate,
                CreationUserID = s.CreationUserID,
                CreationUser = s.CreationUser,
                CompletionDate = s.CompletionDate,
                CompletionUserID = s.CompletionUserID,
                CompletionUser = s.CompletionUser,
                AssignedDate = s.AssignedDate,
                AssignedUserID = s.AssignedUserID,
                AssignedUser = s.AssignedUser,
                DueDate = s.DueDate,
                AssessmentOutcome = s.AssessmentOutcome,
                AssessmentOutcomeDescription = s.AssessmentOutcomeDescription,
                UpdateBatchID = @batchid,
                DeleteBatchID = null

        when not matched by target then
            insert
            (
                Domain,
                Country,
                Work_ID,
                ID,
                Original_Work_ID,
                Original_ID,
                WorkActivity_ID,
                CategoryActivityName,
                StatusName,
                SortOrder,
                CreationDate,
                CreationUserID,
                CreationUser,
                CompletionDate,
                CompletionUserID,
                CompletionUser,
                AssignedDate,
                AssignedUserID,
                AssignedUser,
                DueDate,
                AssessmentOutcome,
                AssessmentOutcomeDescription,
                CreateBatchID
            )
            values
            (
                s.Domain,
                s.Country,
                s.Work_ID,
                s.ID,
                s.Original_Work_ID,
                s.Original_ID,
                s.WorkActivity_ID,
                s.CategoryActivityName,
                s.StatusName,
                s.SortOrder,
                s.CreationDate,
                s.CreationUserID,
                s.CreationUser,
                s.CompletionDate,
                s.CompletionUserID,
                s.CompletionUser,
                s.AssignedDate,
                s.AssignedUserID,
                s.AssignedUser,
                s.DueDate,
                s.AssessmentOutcome,
                s.AssessmentOutcomeDescription,
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
            @SourceInfo = 'e5WorkActivity_v3 data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end






GO
