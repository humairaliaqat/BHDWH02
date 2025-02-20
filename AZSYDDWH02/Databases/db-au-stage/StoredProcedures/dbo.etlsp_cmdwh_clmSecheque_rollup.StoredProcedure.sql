USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmSecheque_rollup]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_clmSecheque_rollup]
as
begin
/*
    20140415, LS,   20728 Refactoring, change to incremental
    20140811, LS,   T12242 Global Claim
                    use batch logging
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

    if object_id('[db-au-cba].dbo.clmSecheque') is null
    begin

        create table [db-au-cba].dbo.clmSecheque
        (
            [CountryKey] varchar(2) not null,
            [ClaimKey] varchar(40) null,
            [ChequeKey] varchar(40) null,
            [PayeeKey] varchar(40) null,
            [ChequeID] int not null,
            [ChequeNo] bigint null,
            [ClaimNo] int null,
            [Status] varchar(10) null,
            [TransactionType] varchar(4) null,
            [Currency] varchar(4) null,
            [Amount] money null,
            [isManual] bit not null,
            [PayeeID] int null,
            [AddresseeID] int null,
            [AccountID] int null,
            [ReasonCategoryID] int null,
            [PaymentDate] datetime null,
            [BatchNo] int null,
            [PaymentMethodID] int null,
            [isBounced] bit null,
            [BIRowID] int not null identity(1,1),
            [PaymentDateTimeUTC] datetime null,
            [CreateBatchID] int null,
            [UpdateBatchID] int null
        )

        create clustered index idx_clmSecheque_BIRowID on [db-au-cba].dbo.clmSecheque(BIRowID)
        create nonclustered index idx_clmSecheque_ChequeKey on [db-au-cba].dbo.clmSecheque(ChequeKey) include(TransactionType,[Status],PaymentDate,Amount)
        create nonclustered index idx_clmSecheque_ClaimKey on [db-au-cba].dbo.clmSecheque(ClaimKey) include(PayeeKey,ClaimNo,PayeeID,TransactionType,[Status],PaymentDate,Amount)
        create nonclustered index idx_clmSecheque_PaymentDate on [db-au-cba].dbo.clmSecheque(PaymentDate) include(PayeeKey,ClaimKey,ClaimNo,PayeeID,TransactionType,[Status],Amount)
        create nonclustered index idx_clmSecheque_ChequeNo on [db-au-cba].dbo.clmSecheque(ChequeNo)
        create nonclustered index idx_clmSecheque_ClaimNo on [db-au-cba].dbo.clmSecheque(ClaimNo)

    end

    if object_id('etl_claims_secheque') is not null
        drop table etl_claims_secheque

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, c.SECLAIM) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, c.SECLAIM) + '-' + convert(varchar, c.SECHEQUE_ID) ChequeKey,
        dk.CountryKey + '-' + convert(varchar, c.SECLAIM) + '-' + convert(varchar, c.SEPAYEE_ID) PayeeKey,
        c.SECHEQUE_ID ChequeID,
        c.SECHEQUE ChequeNo,
        c.SECLAIM ClaimNo,
        c.SESTATUS [Status],
        c.SETRANS TransactionType,
        c.SECURR Currency,
        c.SETOTAL Amount,
        c.SEMANUAL isManual,
        c.SEPAYEE_ID PayeeID,
        c.SEADDRESSEE_ID AddresseeID,
        c.SEACCT_ID AccountID,
        c.SEREASONCAT_ID ReasonCategoryID,
        dbo.xfn_ConvertUTCtoLocal(c.SEPAYDATE, dk.TimeZone) PaymentDate,
        c.SEPAYDATE PaymentDateTimeUTC,
        c.SEBATCH BatchNo,
        c.PAYMENTMODE_ID PaymentMethodID,
        c.SEBOUNCED isBounced
    into etl_claims_secheque
    from
        claims_secheque_au c
        cross apply
        (
            select top 1
                KLDOMAINID
            from
                claims_KLREG_au cc
            where
                cc.KLCLAIM = c.SECLAIM
        ) cc
        cross apply dbo.fn_GetDomainKeys(c.KLDOMAINID, 'CM', 'AU') dk



    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-cba].dbo.clmSecheque with(tablock) t
        using etl_claims_secheque s on
            s.ChequeKey = t.ChequeKey

        when matched then

            update
            set
                ClaimKey = s.ClaimKey,
                PayeeKey = s.PayeeKey,
                ChequeID = s.ChequeID,
                ChequeNo = s.ChequeNo,
                ClaimNo = s.ClaimNo,
                [Status] = s.[Status],
                TransactionType = s.TransactionType,
                Currency = s.Currency,
                Amount = s.Amount,
                isManual = s.isManual,
                PayeeID = s.PayeeID,
                AddresseeID = s.AddresseeID,
                AccountID = s.AccountID,
                ReasonCategoryID = s.ReasonCategoryID,
                PaymentDate = s.PaymentDate,
                BatchNo = s.BatchNo,
                PaymentMethodID = s.PaymentMethodID,
                isBounced = s.isBounced,
                PaymentDateTimeUTC = s.PaymentDateTimeUTC,
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                CountryKey,
                ClaimKey,
                ChequeKey,
                PayeeKey,
                ChequeID,
                ChequeNo,
                ClaimNo,
                [Status],
                TransactionType,
                Currency,
                Amount,
                isManual,
                PayeeID,
                AddresseeID,
                AccountID,
                ReasonCategoryID,
                PaymentDate,
                BatchNo,
                PaymentMethodID,
                isBounced,
                PaymentDateTimeUTC,
                CreateBatchID
            )
            values
            (
                s.CountryKey,
                s.ClaimKey,
                s.ChequeKey,
                s.PayeeKey,
                s.ChequeID,
                s.ChequeNo,
                s.ClaimNo,
                s.[Status],
                s.TransactionType,
                s.Currency,
                s.Amount,
                s.isManual,
                s.PayeeID,
                s.AddresseeID,
                s.AccountID,
                s.ReasonCategoryID,
                s.PaymentDate,
                s.BatchNo,
                s.PaymentMethodID,
                s.isBounced,
                s.PaymentDateTimeUTC,
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
            @SourceInfo = 'clmSecheque data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end



GO
