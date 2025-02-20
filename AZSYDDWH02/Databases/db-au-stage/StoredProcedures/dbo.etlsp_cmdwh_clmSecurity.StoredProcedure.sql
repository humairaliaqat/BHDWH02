USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmSecurity]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_clmSecurity]
as
begin
/*
    20140731, LS, T12242 Global Claim
    20140801, LS, use batch logging
    20141111, LS, T14092 Claims.Net Global
                  add new UK data set
    20150129, LS, bug fix, handle null in binary_checksum comparison
	20180927, LT, Customised for CBA
*/

    set nocount on

    exec etlsp_StagingIndex_Claim

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
        @SubjectArea = 'Claim ODS',
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

    if object_id('[db-au-cba].dbo.clmSecurity') is null
    begin

        create table [db-au-cba].dbo.clmSecurity
        (
            [BIRowID] bigint not null identity(1,1),
            [CountryKey] varchar(2) not null,
            [SecurityKey] varchar(40) not null,
            [SecurityID] int not null,
            [Limits] money null,
            [EstimateLimits] money null,
            [Initials] nvarchar(50) null,
            [Name] nvarchar(150) null,
            [Login] nvarchar(50) null,
            [LevelDesc] nvarchar(500) null,
            [isActive] bit null,
            [CreateDateTime] datetime null,
            [UpdateDateTime] datetime null,
            [DeleteDateTime] datetime null,
            [CreateBatchID] int null,
            [UpdateBatchID] int null
        )

        create clustered index idx_clmSecurity_BIRowID on [db-au-cba].dbo.clmSecurity(BIRowID)
        create nonclustered index idx_clmSecurity_SecurityKey on [db-au-cba].dbo.clmSecurity(SecurityKey)
        create nonclustered index idx_clmSecurity_SecurityID on [db-au-cba].dbo.clmSecurity(SecurityID,CountryKey) include (Name,Initials,LevelDesc,isActive)
        create nonclustered index idx_clmSecurity_Login on [db-au-cba].dbo.clmSecurity([Login],CountryKey) include (Name,Initials,LevelDesc,isActive)

    end

    if object_id('tempdb..#clmSecurity') is not null
        drop table #clmSecurity

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, s.KS_ID) SecurityKey,
        s.KS_ID SecurityID,
        s.KSLIMITS Limits,
        s.KSESTLIMITS EstimateLimits,
        s.KSINITS Initials,
        s.KSNAME [Name],
        s.KSLOGIN [Login],
        (
            select
                KSDESCRIPTION +
                case
                    when KS_LEVEL = max(KS_LEVEL) over () then ''
                    else ', '
                end
            from
                claims_klusersecurity_au ku
                inner join claims_klsecuritylevel_au sl on
                    sl.KS_LEVEL = ku.KLSECURITYLEVEL
            where
                ku.KLUSERID = s.KS_ID
            order by KS_LEVEL
            for xml path('')
        ) LevelDesc,
        s.KSACTIVE isActive
    into #clmSecurity
    from
        claims_klsecurity_au s
        cross apply dbo.fn_GetDomainKeys(s.KSDOMAINID, 'CM', 'AU') dk


    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-cba].dbo.clmSecurity with(tablock) t
        using #clmSecurity s on
            s.SecurityKey = t.SecurityKey

        when
            matched and
            binary_checksum(
                isnull(t.Limits, ''),
                isnull(t.EstimateLimits, ''),
                isnull(t.Initials, ''),
                isnull(t.[Name], ''),
                isnull(t.[Login], ''),
                isnull(t.LevelDesc, ''),
                isnull(t.isActive, 0)
            ) <>
            binary_checksum(
                isnull(s.Limits, ''),
                isnull(s.EstimateLimits, ''),
                isnull(s.Initials, ''),
                isnull(s.[Name], ''),
                isnull(s.[Login], ''),
                isnull(s.LevelDesc, ''),
                isnull(s.isActive, 0)
            )
        then

            update
            set
                Limits = s.Limits,
                EstimateLimits = s.EstimateLimits,
                Initials = s.Initials,
                [Name] = s.[Name],
                [Login] = s.[Login],
                LevelDesc = s.LevelDesc,
                isActive = s.isActive,
                UpdateDateTime = getdate(),
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                CountryKey,
                SecurityKey,
                SecurityID,
                Limits,
                EstimateLimits,
                Initials,
                [Name],
                [Login],
                LevelDesc,
                isActive,
                CreateDateTime,
                CreateBatchID
            )
            values
            (
                s.CountryKey,
                s.SecurityKey,
                s.SecurityID,
                s.Limits,
                s.EstimateLimits,
                s.Initials,
                s.[Name],
                s.[Login],
                s.LevelDesc,
                s.isActive,
                getdate(),
                @batchid
            )

        when
            not matched by source and
            DeleteDateTime is null
        then

            update
            set
                DeleteDateTime = getdate()

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
            @SourceInfo = 'clmSecurity data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end

GO
