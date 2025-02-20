USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmPayment_rollup]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[etlsp_cmdwh_clmPayment_rollup]
as
begin
/*
    20140415, LS,   20728 Refactoring, change to incremental
    20140506, LS,   delete based on KLREG
                    metadata has been updated to make sure all related tables are at the same base KLREG
    20140811, LS,   T12242 Global Claim
                    use batch logging
                    use merge instead of deleting the whole names in a claim
    20141111, LS,   T14092 Claims.Net Global
                    add new UK data set
    20150223, PW,	F23264 Incorrectly flagging all NZ Global Claims as deleted             
    20150224, LS,   F23264, change the deleted flagging
                    if audit data exists do not use crude work around (old system)
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

    if object_id('[db-au-cba].dbo.clmPayment') is null
    begin

        create table [db-au-cba].dbo.clmPayment
        (
            [CountryKey] varchar(2) not null,
            [ClaimKey] varchar(40) null,
            [PaymentKey] varchar(40) null,
            [AddresseeKey] varchar(40) null,
            [ProviderKey] varchar(40) null,
            [EventKey] varchar(40) null,
            [SectionKey] varchar(40) null,
            [PayeeKey] varchar(40) null,
            [ChequeKey] varchar(40) null,
            [PaymentID] int not null,
            [ClaimNo] int null,
            [AddresseeID] int null,
            [ProviderID] int null,
            [ChequeID] int null,
            [EventID] int null,
            [SectionID] int null,
            [InvoiceID] int null,
            [AuthorisedID] int null,
            [CheckedOfficerID] int null,
            [AuthorisedOfficerName] nvarchar(150) null,
            [CheckedOfficerName] nvarchar(150) null,
            [WordingID] int null,
            [Method] varchar(3) null,
            [CreatedByID] int null,
            [CreatedByName] nvarchar(150) null,
            [Number] smallint null,
            [BillAmount] money null,
            [CurrencyCode] varchar(3) null,
            [Rate] float null,
            [AUDAmount] money null,
            [DEPR] float null,
            [DEPV] money null,
            [Other] money null,
            [OtherDesc] nvarchar(50) null,
            [PaymentStatus] varchar(4) null,
            [GST] money null,
            [MaxPay] money null,
            [PaymentAmount] money null,
            [Payee] nvarchar(200) null,
            [ModifiedByName] nvarchar(150) null,
            [ModifiedDate] datetime null,
            [PropDate] datetime null,
            [PayeeID] int null,
            [BatchNo] int null,
            [DFTPayeeID] int null,
            [GSTAdjustedAmount] money null,
            [ExcessAmount] money null,
            [CreatedDate] datetime null,
            [GoodServ] varchar(1) null,
            [TPLoc] varchar(3) null,
            [GSTInc] bit not null,
            [PayeeType] varchar(1) null,
            [ChequeNo] bigint null,
            [ChequeStatus] varchar(4) null,
            [DAMOutcome] money null,
            [ITCOutcome] money null,
            [ITCAdjustedAmount] money null,
            [Supply] int null,
            [Invoice] nvarchar(100) null,
            [Taxable] bit null,
            [GSTOutcome] money null,
            [PayMethod_ID] int null,
            [GSTPercentage] numeric(18,0) null,
            [isDeleted] bit not null default 0,
            [BIRowID] int not null identity(1,1),
            [ModifiedDateTimeUTC] datetime null,
            [PropDateTimeUTC] datetime null,
            [CreatedDateTimeUTC] datetime null,
            [CreateBatchID] int null,
            [UpdateBatchID] int null,
			UTRNumber [varchar](16) NULL,
			CHQDate	[datetime] NULL
        )

        create clustered index idx_clmPayment_BIRowID on [db-au-cba].dbo.clmPayment(BIRowID)
        create nonclustered index idx_clmPayment_ClaimKey on [db-au-cba].dbo.clmPayment(ClaimKey) include(SectionKey,PayeeKey,PaymentID,PaymentStatus,PaymentAmount,ModifiedDate,CreatedDate,isDeleted)
        create nonclustered index idx_clmPayment_SectionKey on [db-au-cba].dbo.clmPayment(SectionKey) include(ClaimKey,PayeeKey,PaymentID,PaymentStatus,PaymentAmount,ModifiedDate,isDeleted)
        create nonclustered index idx_clmPayment_ModifiedDate on [db-au-cba].dbo.clmPayment(ModifiedDate,PaymentStatus) include(CountryKey,ClaimKey,SectionKey,PayeeKey,PaymentAmount,isDeleted)
        create nonclustered index idx_clmPayment_CreatedDate on [db-au-cba].dbo.clmPayment(CreatedDate,PaymentStatus) include(CountryKey,ClaimKey,SectionKey,PayeeKey,PaymentAmount,isDeleted)
        create nonclustered index idx_clmPayment_EventKey on [db-au-cba].dbo.clmPayment(EventKey) include(ClaimKey,PaymentStatus,PaymentAmount,ModifiedDate,isDeleted)
        create nonclustered index idx_clmPayment_ClaimNo on [db-au-cba].dbo.clmPayment(ClaimNo)
        create nonclustered index idx_clmPayment_CountryKey on [db-au-cba].dbo.clmPayment(CountryKey,PaymentID)
        create nonclustered index idx_clmPayment_Invoice on [db-au-cba].dbo.clmPayment(Invoice,ClaimKey) include(PaymentKey,PaymentID)
        create nonclustered index idx_clmPayment_PayeeKey on [db-au-cba].dbo.clmPayment(PayeeKey) include(PaymentKey,ClaimKey)

    end

    if object_id('etl_claims_payment') is not null
        drop table etl_claims_payment

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) + '-' + isnull(convert(varchar, p.KPEVENT_ID), '') + '-' + isnull(convert(varchar, p.KPIS_ID), 'R') + '-' + convert(varchar, p.KPAY_ID) PaymentKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) + '-' + convert(varchar, p.KPADDRSEE_ID) AddresseeKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) + '-' + convert(varchar, p.KPPROV_ID) ProviderKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) + '-' + convert(varchar, p.KPEVENT_ID) EventKey,
        /* 2012020223, LS, work around for RECY payments with no section */
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) + '-' + isnull(convert(varchar, p.KPEVENT_ID), '') + isnull('-' + convert(varchar, p.KPIS_ID), 'R' + convert(varchar, p.KPAY_ID)) SectionKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) + '-' + convert(varchar, p.KPPAYEE_ID) PayeeKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) + '-' + convert(varchar, p.KPCHQ_ID) ChequeKey,
        p.KPAY_ID PaymentID,
        p.KPCLAIM_ID ClaimNo,
        p.KPADDRSEE_ID AddresseeID,
        p.KPPROV_ID ProviderID,
        p.KPCHQ_ID ChequeID,
        p.KPEVENT_ID EventID,
        p.KPIS_ID SectionID,
        p.KPINV_ID InvoiceID,
        p.KPAUTHOFF_ID AuthorisedID,
        p.KPCHECKOFF_ID CheckedOfficerID,
        (
            select top 1
                KSNAME
            from
                claims_klsecurity_au
            where
                KS_ID = p.KPAUTHOFF_ID
        ) AuthorisedOfficerName,
        (
            select top 1
                KSNAME
            from
                claims_klsecurity_au
            where
                KS_ID = p.KPCHECKOFF_ID
        ) CheckedOfficerName,
        p.KPWORDING_ID WordingID,
        p.KPMETHOD Method,
        p.KPCREATEDBY_ID CreatedByID,
        (
            select top 1
                KSNAME
            from
                claims_klsecurity_au
            where
                KS_ID = p.KPCREATEDBY_ID
        ) CreatedByName,
        p.KPNUM Number,
        p.KPBILLAMT BillAmount,
        p.KPCURR CurrencyCode,
        p.KPRATE Rate,
        p.KPAUD AUDAmount,
        p.KPDEPR DEPR,
        p.KPDEPV DEPV,
        p.KPOTHER Other,
        p.KPOTHERDESC OtherDesc,
        p.KPSTATUS PaymentStatus,
        p.KPGST GST,
        p.KPMAXPAY MaxPay,
        p.KPPAYAMT PaymentAmount,
        p.KPPAYEE Payee,
        (
            select top 1
                KSNAME
            from
                claims_klsecurity_au
            where
                KS_ID = p.KPMODIFIEDBY_ID
        ) ModifiedByName,
        dbo.xfn_ConvertUTCtoLocal(p.KPMODDT, dk.TimeZone) ModifiedDate,
        dbo.xfn_ConvertUTCtoLocal(p.KPPROPDT, dk.TimeZone) PropDate,
        dbo.xfn_ConvertUTCtoLocal(p.KPCREATEDDT, dk.TimeZone) CreatedDate,
        p.KPMODDT ModifiedDateTimeUTC,
        p.KPPROPDT PropDateTimeUTC,
        p.KPCREATEDDT CreatedDateTimeUTC,
        p.KPPAYEE_ID PayeeID,
        p.KPBATCH BatchNo,
        p.KPDFTPAYEE_ID DFTPayeeID,
        p.KPGSTADJ GSTAdjustedAmount,
        p.KPEXCESS ExcessAmount,
        p.KPGOODSERV GoodServ,
        p.KPTPLOC TPLoc,
        p.KPGSTINC GSTInc,
        p.KPPAYEETYPE PayeeType,
        p.KPCHEQUENUM ChequeNo,
        p.KPCHECKSTATUS ChequeStatus,
        p.KPDAMOUTCOME DAMOutcome,
        p.KPITCOUTCOME ITCOutcome,
        p.KPITCADJ ITCAdjustedAmount,
        p.KPSUPPLY Supply,
        p.KPINVOICE Invoice,
        p.KPTAXABLE Taxable,
        p.KPGSTOutcome GSTOutcome,
        p.KPPAYMETHOD_ID PayMethod_ID,
        p.KPGSTPER GSTPercentage,
		null UTRNumber,
		null CHQDate
    into etl_claims_payment
    from
        claims_klpayments_au p
        outer apply
        (
            select top 1
                KLDOMAINID
            from
                claims_KLREG_au c
            where
                c.KLCLAIM = p.KPCLAIM_ID
        ) c
        cross apply dbo.fn_GetDomainKeys(c.KLDOMAINID, 'CM', 'AU') dk


    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-cba].dbo.clmPayment with(tablock) t
        using etl_claims_payment s on
            s.PaymentKey = t.PaymentKey

        when matched then

            update
            set
                ClaimKey = s.ClaimKey,
                AddresseeKey = s.AddresseeKey,
                ProviderKey = s.ProviderKey,
                EventKey = s.EventKey,
                SectionKey = s.SectionKey,
                PayeeKey = s.PayeeKey,
                ChequeKey = s.ChequeKey,
                PaymentID = s.PaymentID,
                ClaimNo = s.ClaimNo,
                AddresseeID = s.AddresseeID,
                ProviderID = s.ProviderID,
                ChequeID = s.ChequeID,
                EventID = s.EventID,
                SectionID = s.SectionID,
                InvoiceID = s.InvoiceID,
                AuthorisedID = s.AuthorisedID,
                CheckedOfficerID = s.CheckedOfficerID,
                AuthorisedOfficerName = s.AuthorisedOfficerName,
                CheckedOfficerName = s.CheckedOfficerName,
                WordingID = s.WordingID,
                Method = s.Method,
                CreatedByID = s.CreatedByID,
                CreatedByName = s.CreatedByName,
                Number = s.Number,
                BillAmount = s.BillAmount,
                CurrencyCode = s.CurrencyCode,
                Rate = s.Rate,
                AUDAmount = s.AUDAmount,
                DEPR = s.DEPR,
                DEPV = s.DEPV,
                Other = s.Other,
                OtherDesc = s.OtherDesc,
                PaymentStatus = s.PaymentStatus,
                GST = s.GST,
                MaxPay = s.MaxPay,
                PaymentAmount = s.PaymentAmount,
                Payee = s.Payee,
                ModifiedByName = s.ModifiedByName,
                ModifiedDate = s.ModifiedDate,
                PropDate = s.PropDate,
                PayeeID = s.PayeeID,
                BatchNo = s.BatchNo,
                DFTPayeeID = s.DFTPayeeID,
                GSTAdjustedAmount = s.GSTAdjustedAmount,
                ExcessAmount = s.ExcessAmount,
                CreatedDate = s.CreatedDate,
                GoodServ = s.GoodServ,
                TPLoc = s.TPLoc,
                GSTInc = s.GSTInc,
                PayeeType = s.PayeeType,
                ChequeNo = s.ChequeNo,
                ChequeStatus = s.ChequeStatus,
                DAMOutcome = s.DAMOutcome,
                ITCOutcome = s.ITCOutcome,
                ITCAdjustedAmount = s.ITCAdjustedAmount,
                Supply = s.Supply,
                Invoice = s.Invoice,
                Taxable = s.Taxable,
                GSTOutcome = s.GSTOutcome,
                PayMethod_ID = s.PayMethod_ID,
                GSTPercentage = s.GSTPercentage,
                isDeleted = 0,
                ModifiedDateTimeUTC = s.ModifiedDateTimeUTC,
                PropDateTimeUTC = s.PropDateTimeUTC,
                CreatedDateTimeUTC = s.CreatedDateTimeUTC,
                UpdateBatchID = @batchid,
				UTRNumber = s.UTRNumber,
				CHQDate = s.CHQDate

        when not matched by target then
            insert
            (
                CountryKey,
                ClaimKey,
                PaymentKey,
                AddresseeKey,
                ProviderKey,
                EventKey,
                SectionKey,
                PayeeKey,
                ChequeKey,
                PaymentID,
                ClaimNo,
                AddresseeID,
                ProviderID,
                ChequeID,
                EventID,
                SectionID,
                InvoiceID,
                AuthorisedID,
                CheckedOfficerID,
                AuthorisedOfficerName,
                CheckedOfficerName,
                WordingID,
                Method,
                CreatedByID,
                CreatedByName,
                Number,
                BillAmount,
                CurrencyCode,
                Rate,
                AUDAmount,
                DEPR,
                DEPV,
                Other,
                OtherDesc,
                PaymentStatus,
                GST,
                MaxPay,
                PaymentAmount,
                Payee,
                ModifiedByName,
                ModifiedDate,
                PropDate,
                PayeeID,
                BatchNo,
                DFTPayeeID,
                GSTAdjustedAmount,
                ExcessAmount,
                CreatedDate,
                GoodServ,
                TPLoc,
                GSTInc,
                PayeeType,
                ChequeNo,
                ChequeStatus,
                DAMOutcome,
                ITCOutcome,
                ITCAdjustedAmount,
                Supply,
                Invoice,
                Taxable,
                GSTOutcome,
                PayMethod_ID,
                GSTPercentage,
                isDeleted,
                ModifiedDateTimeUTC,
                PropDateTimeUTC,
                CreatedDateTimeUTC,
                CreateBatchID,
				UTRNumber,
				CHQDate
            )
            values
            (
                s.CountryKey,
                s.ClaimKey,
                s.PaymentKey,
                s.AddresseeKey,
                s.ProviderKey,
                s.EventKey,
                s.SectionKey,
                s.PayeeKey,
                s.ChequeKey,
                s.PaymentID,
                s.ClaimNo,
                s.AddresseeID,
                s.ProviderID,
                s.ChequeID,
                s.EventID,
                s.SectionID,
                s.InvoiceID,
                s.AuthorisedID,
                s.CheckedOfficerID,
                s.AuthorisedOfficerName,
                s.CheckedOfficerName,
                s.WordingID,
                s.Method,
                s.CreatedByID,
                s.CreatedByName,
                s.Number,
                s.BillAmount,
                s.CurrencyCode,
                s.Rate,
                s.AUDAmount,
                s.DEPR,
                s.DEPV,
                s.Other,
                s.OtherDesc,
                s.PaymentStatus,
                s.GST,
                s.MaxPay,
                s.PaymentAmount,
                s.Payee,
                s.ModifiedByName,
                s.ModifiedDate,
                s.PropDate,
                s.PayeeID,
                s.BatchNo,
                s.DFTPayeeID,
                s.GSTAdjustedAmount,
                s.ExcessAmount,
                s.CreatedDate,
                s.GoodServ,
                s.TPLoc,
                s.GSTInc,
                s.PayeeType,
                s.ChequeNo,
                s.ChequeStatus,
                s.DAMOutcome,
                s.ITCOutcome,
                s.ITCAdjustedAmount,
                s.Supply,
                s.Invoice,
                s.Taxable,
                s.GSTOutcome,
                s.PayMethod_ID,
                s.GSTPercentage,
                0,
                s.ModifiedDateTimeUTC,
                s.PropDateTimeUTC,
                s.CreatedDateTimeUTC,
                @batchid,
				s.UTRNumber,
				s.CHQDate
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
            @SourceInfo = 'clmPayment data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end


GO
