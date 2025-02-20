USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmEstimateHistory]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_clmEstimateHistory]
as
begin
/*
    20140415, LS,   20728 Refactoring, change to incremental
    20140805, LS,   T12242 Global Claim
                    use batch logging
    20140918, LS,   T13338 Claim UTC
    20141111, LS,   T14092 Claims.Net Global
                    add new UK data set
	20180927, LT,	customised for CBA
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

    if object_id('[db-au-cba].dbo.clmEstimateHistory') is null
    begin

        create table [db-au-cba].dbo.clmEstimateHistory
        (
            [CountryKey] varchar(2) not null,
            [EstimateHistoryKey] varchar(40) not null,
            [EstimateHistoryID] int not null,
            [EHSectionID] int null,
            [EHEstimateValue] money null,
            [EHCreateDate] datetime null,
            [EHCreatedByID] int null,
            [ClaimKey] varchar(40) null,
            [SectionKey] varchar(40) null,
            [EHCreatedBy] nvarchar(150) null,
            [EHRecoveryEstimateValue] money null,
            [BIRowID] int not null identity(1,1),
            [EHCreateDateTimeUTC] datetime null,
            [CreateBatchID] int null,
            [UpdateBatchID] int null
        )

        create clustered index idx_clmEstimateHistory_BIRowID on [db-au-cba].dbo.clmEstimateHistory(BIRowID)
        create nonclustered index idx_clmEstimateHistory_EHSectionID on [db-au-cba].dbo.clmEstimateHistory(EHSectionID,CountryKey) include(EstimateHistoryID,EHCreateDate,EHCreatedBy,EHEstimateValue,EHRecoveryEstimateValue)
        create nonclustered index idx_clmEstimateHistory_EHCreateDate on [db-au-cba].dbo.clmEstimateHistory(EHCreateDate) include(CountryKey,ClaimKey,SectionKey,EstimateHistoryID,EHCreatedBy,EHEstimateValue,EHRecoveryEstimateValue)
        create nonclustered index idx_clmEstimateHistory_SectionKey on [db-au-cba].dbo.clmEstimateHistory(SectionKey) include(CountryKey,ClaimKey,EstimateHistoryID,EHCreateDate,EHCreatedBy,EHEstimateValue,EHRecoveryEstimateValue)
        create nonclustered index idx_clmEstimateHistory_ClaimKey on [db-au-cba].dbo.clmEstimateHistory(ClaimKey) include(SectionKey,EHCreateDate,EHEstimateValue)

    end

    if object_id('etl_clmEstimateHistory') is not null
        drop table etl_clmEstimateHistory

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, eh.EH_ID) EstimateHistoryKey,
        dk.CountryKey + '-' + convert(varchar, cs.KSCLAIM_ID) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, cs.KSCLAIM_ID) + '-' + convert(varchar, cs.KSEVENT_ID) + '-' + convert(varchar, eh.EHIS_ID) SectionKey,
        eh.EH_ID EstimateHistoryID,
        eh.EHIS_ID EHSectionID,
        eh.EHESTIMATE EHEstimateValue,
        eh.EHRECOVEST EHRecoveryEstimateValue,
        dbo.xfn_ConvertUTCtoLocal(eh.EHCREATED, dk.TimeZone) EHCreateDate,
        eh.EHCREATED EHCreateDateTimeUTC,
        eh.EHCREATEDBY_ID EHCreatedByID,
        s.EHCreatedBy
    into etl_clmEstimateHistory
    from
        claims_klesthist_au eh
        outer apply
        (
            select top 1
                s.KSCLAIM_ID,
                s.KSEVENT_ID,
                c.KLDOMAINID
            from
                claims_klsection_au s
                inner join claims_klreg_au c on
                    c.KLCLAIM = s.KSCLAIM_ID
            where
                s.KS_ID = eh.EHIS_ID
        ) fcs
        outer apply
        (
            select top 1
                sa.KSCLAIM_ID,
                sa.KSEVENT_ID,
                ca.KLDOMAINID
            from
                claims_AUDIT_KLSECTION_au sa
                inner join claims_klreg_au ca on
                    ca.KLCLAIM = sa.KSCLAIM_ID
            where
                sa.KS_ID = eh.EHIS_ID
        ) acs
        outer apply
        (
            select
                isnull(fcs.KSCLAIM_ID, acs.KSCLAIM_ID) KSCLAIM_ID,
                isnull(fcs.KSEVENT_ID, acs.KSEVENT_ID) KSEVENT_ID,
                isnull(fcs.KLDOMAINID, acs.KLDOMAINID) KLDOMAINID

        ) cs
        outer apply
        (
            select top 1
                KSNAME EHCreatedBy
            from
                claims_klsecurity_au
            where
                KS_ID = eh.EHCREATEDBY_ID
        ) s
        cross apply dbo.fn_GetDomainKeys(cs.KLDOMAINID, 'CM', 'AU') dk



    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-cba].dbo.clmEstimateHistory with(tablock) t
        using etl_clmEstimateHistory s on
            s.EstimateHistoryKey = t.EstimateHistoryKey

        when matched then

            update
            set
                ClaimKey = s.ClaimKey,
                SectionKey = s.SectionKey,
                EstimateHistoryID = s.EstimateHistoryID,
                EHSectionID = s.EHSectionID,
                EHEstimateValue = s.EHEstimateValue,
                EHCreateDate = s.EHCreateDate,
                EHCreatedByID = s.EHCreatedByID,
                EHCreatedBy = s.EHCreatedBy,
                EHRecoveryEstimateValue = s.EHRecoveryEstimateValue,
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                CountryKey,
                ClaimKey,
                SectionKey,
                EstimateHistoryKey,
                EstimateHistoryID,
                EHSectionID,
                EHEstimateValue,
                EHCreateDate,
                EHCreatedByID,
                EHCreatedBy,
                EHRecoveryEstimateValue,
                CreateBatchID
            )
            values
            (
                s.CountryKey,
                s.ClaimKey,
                s.SectionKey,
                s.EstimateHistoryKey,
                s.EstimateHistoryID,
                s.EHSectionID,
                s.EHEstimateValue,
                s.EHCreateDate,
                s.EHCreatedByID,
                s.EHCreatedBy,
                s.EHRecoveryEstimateValue,
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
            @SourceInfo = 'clmEstimateHistory data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end



GO
