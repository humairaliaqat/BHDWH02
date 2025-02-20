USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmAuditSecurity]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_clmAuditSecurity]
as
begin
/*
20140807, LS,   T12242 Global Claim
                use batch logging
                change into raw data, processing should be on report level not here
20140918, LS,   T13338 Claim UTC
20141111, LS,   T14092 Claims.Net Global
                add new UK data set
20180927, LT,	Customised for CBA
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

    if object_id('[db-au-cba].dbo.clmAuditSecurity') is null
    begin

        create table [db-au-cba].dbo.clmAuditSecurity
        (
            [BIRowID] bigint not null identity(1,1),
            [CountryKey] varchar(2) not null,
            [AuditKey] varchar(50) not null,
            [AuditUserName] nvarchar(150) null,
            [AuditDateTime] datetime not null,
            [AuditAction] char(1) not null,
            [CreateBatchID] int null,
            [UpdateBatchID] int null,
            [SecurityKey] varchar(40) not null,
            [SecurityID] int not null,
            [Limits] money null,
            [EstimateLimits] money null,
            [Initials] nvarchar(50) null,
            [Name] nvarchar(150) null,
            [Login] nvarchar(50) null,
            [LevelDesc] nvarchar(500) null,
            [isActive] bit null,
            [AuditDateTimeUTC] datetime null
        )

        create clustered index idx_clmAuditSecurity_BIRowID on [db-au-cba].dbo.clmAuditSecurity(BIRowID)
        create nonclustered index idx_clmAuditSecurity_SecurityKey on [db-au-cba].dbo.clmAuditSecurity(SecurityKey)
        create nonclustered index idx_clmAuditSecurity_SecurityID on [db-au-cba].dbo.clmAuditSecurity(SecurityID,CountryKey)
        create nonclustered index idx_clmAuditSecurity_Login on [db-au-cba].dbo.clmAuditSecurity([Login],CountryKey)
        create nonclustered index idx_clmAuditSecurity_AuditKey on [db-au-cba].dbo.clmAuditSecurity(AuditKey)

    end

    if object_id('tempdb..#clmAuditSecurity') is not null
        drop table #clmAuditSecurity

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, s.KS_ID) + '-' + left(s.AUDIT_ACTION, 1) collate database_default + replace(replace(replace(replace(convert(varchar, s.AUDIT_DATETIME, 126), ':', ''), '-', ''), '.', ''), 'T', '') collate database_default + convert(varchar, binary_checksum(*)) AuditKey,
        dk.CountryKey + '-' + convert(varchar, s.KS_ID) SecurityKey,
        s.AUDIT_USERNAME AuditUserName,
        dbo.xfn_ConvertUTCtoLocal(s.AUDIT_DATETIME, dk.TimeZone) AuditDateTime,
        s.AUDIT_DATETIME AuditDateTimeUTC,
        s.AUDIT_ACTION AuditAction,
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
    into #clmAuditSecurity
    from
        claims_AUDIT_KLSECURITY_au s
        outer apply
        (
            select top 1
                KSDOMAINID
            from
                claims_KLSECURITY_au sd
            where
                sd.KS_ID = s.KS_ID
        ) sd
        cross apply dbo.fn_GetDomainKeys(isnull(sd.KSDOMAINID, s.KSDOMAINID), 'CM', 'AU') dk


    
    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-cba].dbo.clmAuditSecurity with(tablock) t
        using #clmAuditSecurity s on
            s.AuditKey = t.AuditKey

        when
            matched and
            (
                select count(AuditKey)
                from
                    [db-au-cba].dbo.clmAuditSecurity r
                where
                    r.AuditKey = s.AuditKey
            ) < 2 /* bug on security audit data, so many duplicates - same values on ALL columns */
        then

            update
            set
                AuditUserName = s.AuditUserName,
                AuditDateTime = s.AuditDateTime,
                AuditAction = s.AuditAction,
                SecurityKey = s.SecurityKey,
                SecurityID = s.SecurityID,
                Limits = s.Limits,
                EstimateLimits = s.EstimateLimits,
                Initials = s.Initials,
                [Name] = s.[Name],
                [Login] = s.[Login],
                LevelDesc = s.LevelDesc,
                isActive = s.isActive,
                AuditDateTimeUTC = s.AuditDateTimeUTC,
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                CountryKey,
                AuditKey,
                AuditUserName,
                AuditDateTime,
                AuditAction,
                SecurityKey,
                SecurityID,
                Limits,
                EstimateLimits,
                Initials,
                [Name],
                [Login],
                LevelDesc,
                isActive,
                AuditDateTimeUTC,
                CreateBatchID
            )
            values
            (
                s.CountryKey,
                s.AuditKey,
                s.AuditUserName,
                s.AuditDateTime,
                s.AuditAction,
                s.SecurityKey,
                s.SecurityID,
                s.Limits,
                s.EstimateLimits,
                s.Initials,
                s.[Name],
                s.[Login],
                s.LevelDesc,
                s.isActive,
                s.AuditDateTimeUTC,
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
            @SourceInfo = 'clmAuditSecurity data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end



GO
