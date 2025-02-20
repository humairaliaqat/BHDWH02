USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmOnlineClaimCreditCard]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_clmOnlineClaimCreditCard]
as
begin
/*
    20160617, LL, create
	20180927, LT, customised for CBA
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

    if object_id('[db-au-cba].dbo.clmOnlineClaimCreditCard') is null
    begin

        create table [db-au-cba].dbo.clmOnlineClaimCreditCard
        (
            BIRowID bigint identity(1,1) not null,
            CountryKey varchar(2) not null,
            ClaimKey varchar(40),
            OnlineClaimKey varchar(40) not null,
            OnlineClaimID int not null,
            ClaimNo int,
            CardProvider nvarchar(max),
            CardType nvarchar(max)
        )

        create clustered index idx_clmOnlineClaimCreditCard_BIRowID on [db-au-cba].dbo.clmOnlineClaimCreditCard(BIRowID)
        create nonclustered index idx_clmOnlineClaimCreditCard_ClaimKey on [db-au-cba].dbo.clmOnlineClaimCreditCard(ClaimKey) include(BIRowID)
        create nonclustered index idx_clmOnlineClaimCreditCard_ClaimNo on [db-au-cba].dbo.clmOnlineClaimCreditCard(ClaimNo) include(BIRowID)
        create nonclustered index idx_clmOnlineClaimCreditCard_OnlineClaimKey on [db-au-cba].dbo.clmOnlineClaimCreditCard(OnlineClaimKey)

    end



    if object_id('tempdb..#onlineclaimscc') is not null
        drop table #onlineclaimscc

    select --top 1000 
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, oc.ClaimId) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, oc.OnlineClaimID) OnlineClaimKey,
        oc.OnlineClaimID,
        oc.ClaimId ClaimNo,
        --cx.*,
        cc.value('CardProvider[1]', 'varchar(max)') CardProvider,
        cc.value('CardType[1]', 'varchar(max)') CardType
    into #onlineclaimscc
    from
        claims_tblOnlineClaims_au oc 
        cross apply dbo.fn_GetDomainKeys(oc.KLDOMAINID, 'CM', 'AU') dk
        inner join claims_tblOnlineClaimantCreditCards_au occc on
            occc.ClaimantId = oc.PrimaryClaimantID
        cross apply
        (
            select
                try_convert(xml, occc.CardDetails) CardXML
        ) cx
        cross apply CardXML.nodes('/CreditCards/CreditCards/CreditCard') as cc(cc)



    set @sourcecount = @@rowcount

    begin transaction

    begin try

        delete 
        from
            [db-au-cba].dbo.clmOnlineClaimCreditCard
        where
            OnlineClaimKey in
            (
                select
                    OnlineClaimKey
                from
                    #onlineclaimscc
            )

        insert into [db-au-cba].dbo.clmOnlineClaimCreditCard with (tablock)
        (
            CountryKey,
            ClaimKey,
            OnlineClaimKey,
            OnlineClaimID,
            ClaimNo,
            CardProvider,
            CardType
        )
        select
            CountryKey,
            ClaimKey,
            OnlineClaimKey,
            OnlineClaimID,
            ClaimNo,
            CardProvider,
            CardType
        from
            #onlineclaimscc

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
            @SourceInfo = 'clmOnlineClaimCreditCard data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end



GO
