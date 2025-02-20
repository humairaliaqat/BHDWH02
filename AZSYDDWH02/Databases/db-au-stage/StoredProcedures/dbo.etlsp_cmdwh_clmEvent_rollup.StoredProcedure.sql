USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmEvent_rollup]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_clmEvent_rollup]
as
begin
/*
    20140415, LS,   20728 Refactoring, change to incremental
    20140506, LS,   delete based on KLREG
                    metadata has been updated to make sure all related tables are at the same base KLREG
    20140811, LS,   T12242 Global Claim
                    use batch logging
                    use merge instead of deleting the whole event in a claim
    20140918, LS,   T13338 Claim UTC
    20141111, LS,   T14092 Claims.Net Global
                    add new UK data set
    20151021, LS,   CAT threshold
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

    if object_id('[db-au-cba].dbo.clmEvent') is null
    begin

        create table [db-au-cba].dbo.clmEvent
        (
            [CountryKey] varchar(2) not null,
            [ClaimKey] varchar(40) not null,
            [EventKey] varchar(40) not null,
            [EventID] int not null,
            [ClaimNo] int null,
            [EMCID] int null,
            [PerilCode] varchar(3) null,
            [PerilDesc] nvarchar(65) null,
            [EventCountryCode] varchar(3) null,
            [EventCountryName] nvarchar(45) null,
            [EventDate] datetime null,
            [EventDesc] nvarchar(100) null,
            [CreateDate] datetime null,
            [CreatedBy] nvarchar(150) null,
            [CaseID] varchar(15) null,
            [CatastropheCode] varchar(3) null,
            [CatastropheShortDesc] nvarchar(20) null,
            [CatastropheLongDesc] nvarchar(60) null,
            [BIRowID] int not null identity(1,1),
            [EventDateTimeUTC] datetime null,
            [CreateDateTimeUTC] datetime null,
            [CreateBatchID] int null,
            [UpdateBatchID] int null
        )

        create clustered index idx_clmEvent_BIRowID on [db-au-cba].dbo.clmEvent(BIRowID)
        create nonclustered index idx_clmEvent_ClaimKey on [db-au-cba].dbo.clmEvent(ClaimKey) include(EventKey,EventCountryCode,EventCountryName,EventDate,EventDesc,CaseID,CatastropheCode)
        create nonclustered index idx_clmEvent_CatastropheCode on [db-au-cba].dbo.clmEvent(CatastropheCode) include(ClaimKey,EventKey,EventCountryCode,EventCountryName,EventDate,EventDesc,CatastropheShortDesc)
        create nonclustered index idx_clmEvent_ClaimNo on [db-au-cba].dbo.clmEvent(ClaimNo) include(CountryKey,ClaimKey,EventKey)
        create nonclustered index idx_clmEvent_EventKey on [db-au-cba].dbo.clmEvent(EventKey) include(ClaimKey,EventCountryCode,EventCountryName,EventDate,EventDesc,CaseID)
        create nonclustered index idx_clmEvent_PerilCode on [db-au-cba].dbo.clmEvent(PerilCode) include(ClaimKey,EventKey,EventCountryCode,EventCountryName,EventDate,EventDesc,PerilDesc)

    end

    if object_id('etl_claims_event') is not null
        drop table etl_claims_event

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, e.KECLAIM) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, e.KECLAIM) + '-' + convert(varchar, e.KE_ID) EventKey,
        e.KE_ID EventID,
        e.KECLAIM ClaimNo,
        e.KEEMC_ID EMCID,
        e.KEPERIL PerilCode,
        (
            select top 1
                KLPERDESC
            from
                claims_klperilcodes_au pc
            where
                pc.KLPERCODE = e.KEPERIL and
                pc.KLDOMAINID = c.KLDOMAINID
        ) PerilDesc,
        e.KECOUNTRY EventCountryCode,
        (
            select top 1
                KLCNTRYDESC
            from
                claims_klcountry_au
            where
                KLCNTRYCODE = e.KECOUNTRY
        ) EventCountryName,
        e.KEDESC EventDesc,
        dbo.xfn_ConvertUTCtoLocal(e.KEDLOSS, dk.TimeZone) EventDate,
        dbo.xfn_ConvertUTCtoLocal(e.KEDCREATED, dk.TimeZone) CreateDate,
        e.KEDLOSS EventDateTimeUTC,
        e.KEDCREATED CreateDateTimeUTC,
        (
            select top 1
                KSNAME
            from
                claims_klsecurity_au
            where
                KS_ID = e.KECREATEDBY_ID
        ) CreatedBy,
        e.KECASE_ID CaseID,
        e.KECATASTROPHE CatastropheCode,
        cat.CatastropheShortDesc,
        cat.CatastropheLongDesc
    into etl_claims_event
    from
        claims_klevent_au e
        outer apply
        (
            select top 1
                c.KLDOMAINID
            from
                claims_klreg_au c
            where
                c.KLCLAIM = e.KECLAIM
        ) c
        cross apply dbo.fn_GetDomainKeys(c.KLDOMAINID, 'CM', 'AU') dk
        outer apply
        (
            select top 1
                KCSHORT CatastropheShortDesc,
                KCLONG CatastropheLongDesc
            from
                claims_klcatas_au  cat
            where
                cat.KC_CODE = e.KECATASTROPHE and
                cat.KLDOMAINID = c.KLDOMAINID
        ) cat



    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-cba].dbo.clmEvent with(tablock) t
        using etl_claims_event s on
            s.EventKey = t.EventKey

        when matched then

            update
            set
                ClaimKey = s.ClaimKey,
                EventID = s.EventID,
                ClaimNo = s.ClaimNo,
                EMCID = s.EMCID,
                PerilCode = s.PerilCode,
                PerilDesc = s.PerilDesc,
                EventCountryCode = s.EventCountryCode,
                EventCountryName = s.EventCountryName,
                EventDate = s.EventDate,
                EventDesc = s.EventDesc,
                CreateDate = s.CreateDate,
                CreatedBy = s.CreatedBy,
                CaseID = s.CaseID,
                CatastropheCode = s.CatastropheCode,
                CatastropheShortDesc = s.CatastropheShortDesc,
                CatastropheLongDesc = s.CatastropheLongDesc,
                EventDateTimeUTC = s.EventDateTimeUTC,
                CreateDateTimeUTC = s.CreateDateTimeUTC,
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                CountryKey,
                ClaimKey,
                EventKey,
                EventID,
                ClaimNo,
                EMCID,
                PerilCode,
                PerilDesc,
                EventCountryCode,
                EventCountryName,
                EventDate,
                EventDesc,
                CreateDate,
                CreatedBy,
                CaseID,
                CatastropheCode,
                CatastropheShortDesc,
                CatastropheLongDesc,
                EventDateTimeUTC,
                CreateDateTimeUTC,
                CreateBatchID
            )
            values
            (
                s.CountryKey,
                s.ClaimKey,
                s.EventKey,
                s.EventID,
                s.ClaimNo,
                s.EMCID,
                s.PerilCode,
                s.PerilDesc,
                s.EventCountryCode,
                s.EventCountryName,
                s.EventDate,
                s.EventDesc,
                s.CreateDate,
                s.CreatedBy,
                s.CaseID,
                s.CatastropheCode,
                s.CatastropheShortDesc,
                s.CatastropheLongDesc,
                s.EventDateTimeUTC,
                s.CreateDateTimeUTC,
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
            @SourceInfo = 'clmEvent data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

    if object_id('[db-au-cba]..clmCatastrophe') is null
    begin

        create table [db-au-cba]..clmCatastrophe
        (
            CountryKey varchar(2),
            CatastropheCode varchar(3),
            TotalIncurred money,
            UpdateDateTime datetime
        )

        create nonclustered index idx on [db-au-cba]..clmCatastrophe (CountryKey, CatastropheCode) include (TotalIncurred)

    end


    if object_id('tempdb..#catvalues') is not null
        drop table #catvalues

    select 
        ce.CountryKey,
        ce.CatastropheCode,
        sum(IncurredValue) TotalIncurred,
        case
            when ce.CountryKey = 'AU' then 300000
            when ce.CountryKey = 'NZ' then 300000
            when ce.CountryKey = 'UK' then 20000
            else 1000000
        end Threshold
    into #catvalues
    from
        [db-au-cba]..clmEvent ce
        inner join [db-au-cba]..clmClaim cl on
            cl.ClaimKey = ce.ClaimKey
        cross apply
        (
            select top 1 
                IncurredValue
            from
                [db-au-cba]..vclmClaimIncurred ci
            where
                ci.ClaimKey = cl.ClaimKey
            order by
                ci.IncurredDate desc
            --unlike Large where it stays large once it goes large, cat can drop down to non cat
        ) ci
    where
        isnull(ce.CatastropheCode, '') not in ('', 'CC', 'REC')
    group by
        ce.CountryKey,
        ce.CatastropheCode

    truncate table [db-au-cba]..clmCatastrophe

    insert into [db-au-cba]..clmCatastrophe 
    (
        CountryKey,
        CatastropheCode,
        TotalIncurred,
        UpdateDateTime
    )
    select 
        CountryKey,
        CatastropheCode,
        TotalIncurred,
        getdate()
    from
        #catvalues
    where
        TotalIncurred > Threshold

end



GO
