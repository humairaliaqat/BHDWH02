USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmLocationHistory]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_clmLocationHistory]
as
begin
/*
    20140415, LS,   20728 Refactoring, change to incremental
    20140811, LS,   T12242 Global Claim
                    use batch logging
    20140918, LS,   T13338 Claim UTC
    20140924, LS,   add first flag
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

    if object_id('[db-au-cba].dbo.clmLocationHistory') is null
    begin

        create table [db-au-cba].dbo.clmLocationHistory
        (
            [BIRowID] bigint not null identity(1,1),
            [CountryKey] varchar(2) null,
            [ClaimKey] varchar(40) null,
            [LocationHistoryKey] varchar(40) not null,
            [LocationKey] varchar(40) null,
            [ClaimNo] int null,
            [LocationHistoryID] int null,
            [LocationID] int null,
            [CreatedDate] datetime null,
            [CorroReceivedDate] datetime null,
            [CreatedByName] nvarchar(150) null,
            [Location] nvarchar(50) null,
            [LocationDescription] nvarchar(50) null,
            [Note] nvarchar(50) null,
            [CreatedDateTimeUTC] datetime null,
            [CorroReceivedDateTimeUTC] datetime null,
            [isFirst] bit not null default 0,
            [CreateBatchID] int null,
            [UpdateBatchID] int null
        )

        create clustered index idx_clmLocationHistory_BIRowID on [db-au-cba].dbo.clmLocationHistory(BIRowID)
        create nonclustered index idx_clmLocationHistory_ClaimNo on [db-au-cba].dbo.clmLocationHistory(ClaimNo,CountryKey) include (ClaimKey,LocationKey,LocationID,Location,LocationDescription,CreatedDate,CreatedByName)
        create nonclustered index idx_clmLocationHistory_ClaimKey on [db-au-cba].dbo.clmLocationHistory(ClaimKey) include (LocationKey,LocationID,Location,LocationDescription,CreatedDate,CreatedByName)
        create nonclustered index idx_clmLocationHistory_CreatedDate on [db-au-cba].dbo.clmLocationHistory(CreatedDate) include (ClaimKey,ClaimNo,LocationKey,LocationID,Location,LocationDescription,CreatedByName,isFirst)

    end

    if object_id('etl_clmLocationHistory') is not null
        drop table etl_clmLocationHistory

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, l.LHCLAIM_ID) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, l.LHCLAIM_ID) + '-' + convert(varchar, l.LH_ID) LocationHistoryKey,
        dk.CountryKey + '-' + convert(varchar, l.LHLOC_ID) LocationKey,
        l.LHCLAIM_ID ClaimNo,
        l.LH_ID LocationHistoryID,
        l.LHLOC_ID LocationID,
        dbo.xfn_ConvertUTCtoLocal(l.LHCREATED, dk.TimeZone) CreatedDate,
        dbo.xfn_ConvertUTCtoLocal(l.LHCorroRecdDt, dk.TimeZone) CorroReceivedDate,
        l.LHCREATED CreatedDateTimeUTC,
        l.LHCorroRecdDt CorroReceivedDateTimeUTC,
        (
            select top 1
                KSNAME
            from
                claims_klsecurity_au
            where
                KS_ID = l.LHCREATEDBY_ID
        ) CreatedByName,
        ll.Location,
        ll.LocationDescription,
        l.LHNOTE Note
    into etl_clmLocationHistory
    from
        claims_kllochist_au l
        outer apply
        (
            select top 1
                KLDOMAINID
            from
                claims_KLREG_au c
            where
                c.KLCLAIM = l.LHCLAIM_ID
        ) c
        cross apply dbo.fn_GetDomainKeys(c.KLDOMAINID, 'CM', 'AU') dk
        outer apply
        (
            select top 1
                ll.LOCAT Location,
                ll.LODESC LocationDescription
            from
                claims_KLLOCATION_au ll
            where
                ll.LO_ID = l.LHLOC_ID
        ) ll



    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-cba].dbo.clmLocationHistory with(tablock) t
        using etl_clmLocationHistory s on
            s.LocationHistoryKey = t.LocationHistoryKey

        when matched then

            update
            set
                CountryKey = s.CountryKey,
                ClaimKey = s.ClaimKey,
                LocationHistoryKey = s.LocationHistoryKey,
                LocationKey = s.LocationKey,
                ClaimNo = s.ClaimNo,
                LocationHistoryID = s.LocationHistoryID,
                LocationID = s.LocationID,
                CreatedDate = s.CreatedDate,
                CorroReceivedDate = s.CorroReceivedDate,
                CreatedByName = s.CreatedByName,
                Location = s.Location,
                LocationDescription = s.LocationDescription,
                Note = s.Note,
                CreatedDateTimeUTC = s.CreatedDateTimeUTC,
                CorroReceivedDateTimeUTC = s.CorroReceivedDateTimeUTC,
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                CountryKey,
                ClaimKey,
                LocationHistoryKey,
                LocationKey,
                ClaimNo,
                LocationHistoryID,
                LocationID,
                CreatedDate,
                CorroReceivedDate,
                CreatedByName,
                Location,
                LocationDescription,
                Note,
                CreatedDateTimeUTC,
                CorroReceivedDateTimeUTC,
                CreateBatchID
            )
            values
            (
                s.CountryKey,
                s.ClaimKey,
                s.LocationHistoryKey,
                s.LocationKey,
                s.ClaimNo,
                s.LocationHistoryID,
                s.LocationID,
                s.CreatedDate,
                s.CorroReceivedDate,
                s.CreatedByName,
                s.Location,
                s.LocationDescription,
                s.Note,
                s.CreatedDateTimeUTC,
                s.CorroReceivedDateTimeUTC,
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

        update t
        set
            isFirst = isnull(r.isFirst, 1)
        from
            [db-au-cba]..clmLocationHistory t
            outer apply
            (
                select top 1
                    0 isFirst
                from
                    [db-au-cba]..clmLocationHistory r
                where
                    r.ClaimKey = t.ClaimKey and
                    r.CreatedDate < t.CreatedDate and
                    r.LocationID = t.LocationID
            ) r
        where
            LocationHistoryKey in
            (
                select
                    LocationHistoryKey
                from
                    etl_clmLocationHistory
            )

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
            @SourceInfo = 'clmLocationHistory data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end



GO
