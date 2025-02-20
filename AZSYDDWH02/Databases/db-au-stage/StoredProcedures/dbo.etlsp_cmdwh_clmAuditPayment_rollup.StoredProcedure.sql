USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmAuditPayment_rollup]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_cmdwh_clmAuditPayment_rollup]
as
begin
/*
20121214 - LS - bug fix, Audit key supposed to be on Payment ID not Claim ID, truncate data and refresh this one time only
                Case 18105:
                change from dimension to fact (incremental)
                add FirstOccurrenceIndicator
20130227 - LS - Case 18105:
                add ValidTransactionsIndicator
20140807 - LS - T12242 Global Claim
                use batch logging
20140811 - LS - update isDeleted flag
20140918 - LS - T13338 Claim UTC
20141111 - LS - F22370, mark PAID status after non PAID status to be valid transaction
20141120 - LS - F22370, logic fix on catching the PAID status after non PAID
                auditdatetime stamp can sometime be identical
20141201 - LS - F22370, logic fix, user can edit old (pre-audit) PAID payments and thus creating invalid marking
20141216 - LS - T14092 Claims.Net Global
                add new UK data set
20180927 - LT - Customised for CBA
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

    if object_id('[db-au-cba].dbo.clmAuditPayment') is null
    begin

        create table [db-au-cba].dbo.clmAuditPayment
        (
            [CountryKey] varchar(2) not null,
            [AuditKey] varchar(50) not null,
            [ClaimKey] varchar(40) not null,
            [AuditUserName] nvarchar(150) null,
            [AuditDateTime] datetime not null,
            [AuditAction] char(1) not null,
            [PaymentKey] varchar(40) null,
            [EventKey] varchar(40) null,
            [SectionKey] varchar(40) null,
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
            [BankRef] int null,
            [DAMOutcome] money null,
            [ITCOutcome] money null,
            [ITCAdjustedAmount] money null,
            [Supply] int null,
            [Invoice] nvarchar(100) null,
            [Taxable] bit null,
            [GSTOutcome] money null,
            [PayMethod_ID] int null,
            [GSTPercentage] numeric(18,0) null,
            [FirstOccurrenceIndicator] bit null,
            [ValidTransactionsIndicator] bit null,
            [PayeeKey] varchar(40) null,
            [ChequeKey] varchar(40) null,
            [BIRowID] int not null identity(1,1),
            [AuditDateTimeUTC] datetime null,
            [ModifiedDateTimeUTC] datetime null,
            [PropDateTimeUTC] datetime null,
            [CreatedDateTimeUTC] datetime null,
            [CreateBatchID] int null,
            [UpdateBatchID] int null,
			[UTRNumber] [varchar](16) NULL,
			[CHQDate]	[datetime] NULL
        )

        create clustered index idx_clmAuditPayment_BIRowID on [db-au-cba].dbo.clmAuditPayment(BIRowID)
        create nonclustered index idx_clmAuditPayment_AuditDateTime on [db-au-cba].dbo.clmAuditPayment(AuditDateTime) include(CountryKey,ClaimKey,PayeeID,PaymentKey,PayeeKey)
        create nonclustered index idx_clmAuditPayment_ClaimKey on [db-au-cba].dbo.clmAuditPayment(ClaimKey) include(CountryKey,ClaimNo,PayeeID,PayeeKey,BatchNo,PaymentID,PaymentKey,PaymentStatus,FirstOccurrenceIndicator,ValidTransactionsIndicator)
        create nonclustered index idx_clmAuditPayment_ClaimNo on [db-au-cba].dbo.clmAuditPayment(ClaimNo)
        create nonclustered index idx_clmAuditPayment_PaymentKey on [db-au-cba].dbo.clmAuditPayment(PaymentKey) include(CountryKey,ClaimNo,ClaimKey,PayeeID,PayeeKey,BatchNo,PaymentID,PaymentStatus,FirstOccurrenceIndicator,ValidTransactionsIndicator,AuditDateTime,AuditKey)
        create nonclustered index idx_clmAuditPayment_SectionKey on [db-au-cba].dbo.clmAuditPayment(SectionKey,FirstOccurrenceIndicator,ValidTransactionsIndicator) include(CountryKey,ClaimNo,ClaimKey,PayeeID,PayeeKey,BatchNo,PaymentID,PaymentKey,PaymentStatus,AuditDateTime,PaymentAmount,ModifiedDate,AuditAction)
        create nonclustered index idx_clmAuditPayment_AuditKey on [db-au-cba].dbo.clmAuditPayment(AuditKey)
        create nonclustered index idx_clmAuditPayment_ChequeKey on [db-au-cba].dbo.clmAuditPayment(ChequeKey) include(CountryKey,ClaimNo,ClaimKey,PayeeID,PayeeKey,BatchNo,PaymentID,PaymentStatus,FirstOccurrenceIndicator,ValidTransactionsIndicator,AuditDateTime,AuditKey)

    end

    if object_id('etl_audit_claims_payment') is not null
        drop table etl_audit_claims_payment

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, p.KPAY_ID) + '-' + left(p.AUDIT_ACTION, 1) collate database_default + replace(replace(replace(replace(convert(varchar, p.AUDIT_DATETIME, 126), ':', ''), '-', ''), '.', ''), 'T', '') collate database_default + convert(varchar, binary_checksum(*)) AuditKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) + '-' + convert(varchar, p.KPEVENT_ID) + '-' + isnull(convert(varchar, p.KPIS_ID), 'R') + '-' + convert(varchar, p.KPAY_ID) PaymentKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) + '-' + convert(varchar, p.KPEVENT_ID) EventKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) + '-' + convert(varchar, p.KPEVENT_ID) + '-' + convert(varchar, p.KPIS_ID) SectionKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) + '-' + convert(varchar, p.KPPAYEE_ID) PayeeKey,
        dk.CountryKey + '-' + convert(varchar, p.KPCLAIM_ID) + '-' + convert(varchar, p.KPCHQ_ID) ChequeKey,
        p.AUDIT_USERNAME AuditUserName,
        dbo.xfn_ConvertUTCtoLocal(p.AUDIT_DATETIME, dk.TimeZone) AuditDateTime,
        dbo.xfn_ConvertUTCtoLocal(p.KPMODDT, dk.TimeZone) ModifiedDate,
        dbo.xfn_ConvertUTCtoLocal(p.KPPROPDT, dk.TimeZone) PropDate,
        dbo.xfn_ConvertUTCtoLocal(p.KPCREATEDDT, dk.TimeZone) CreatedDate,
        p.AUDIT_DATETIME AuditDateTimeUTC,
        p.KPMODDT ModifiedDateTimeUTC,
        p.KPPROPDT PropDateTimeUTC,
        p.KPCREATEDDT CreatedDateTimeUTC,
        p.AUDIT_ACTION AuditAction,
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
        null BankRef,
        p.KPDAMOUTCOME DAMOutcome,
        p.KPITCOUTCOME ITCOutcome,
        p.KPITCADJ ITCAdjustedAmount,
        p.KPSUPPLY Supply,
        p.KPINVOICE Invoice,
        p.KPTAXABLE Taxable,
        p.KPGSTOutcome GSTOutcome,
        p.KPPAYMETHOD_ID PayMethod_ID,
        p.KPGSTPER GSTPercentage,
		p.UTRNumber,
		p.CHQDate
    into
        etl_audit_claims_payment
    from
        claims_AUDIT_KLPAYMENTS_au p
        outer apply
        (
            /* claim record exists due to metadata rule */
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

        merge into [db-au-cba].dbo.clmAuditPayment with(tablock) t
        using etl_audit_claims_payment s on
            s.AuditKey = t.AuditKey

        when
            matched and
            (
                select count(AuditKey)
                from
                    [db-au-cba].dbo.clmAuditPayment r
                where
                    r.AuditKey = s.AuditKey
            ) < 2 /* bug on payment audit data, so many duplicates - same values on ALL columns */
        then

            update
            set
                ClaimKey = s.ClaimKey,
                AuditUserName = s.AuditUserName,
                AuditDateTime = s.AuditDateTime,
                AuditAction = s.AuditAction,
                PaymentKey = s.PaymentKey,
                EventKey = s.EventKey,
                SectionKey = s.SectionKey,
                ChequeKey = s.ChequeKey,
                PayeeKey = s.PayeeKey,
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
                BankRef = s.BankRef,
                DAMOutcome = s.DAMOutcome,
                ITCOutcome = s.ITCOutcome,
                ITCAdjustedAmount = s.ITCAdjustedAmount,
                Supply = s.Supply,
                Invoice = s.Invoice,
                Taxable = s.Taxable,
                GSTOutcome = s.GSTOutcome,
                PayMethod_ID = s.PayMethod_ID,
                GSTPercentage = s.GSTPercentage,
                AuditDateTimeUTC = s.AuditDateTimeUTC,
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
                AuditKey,
                ClaimKey,
                PayeeKey,
                AuditUserName,
                AuditDateTime,
                AuditAction,
                PaymentKey,
                EventKey,
                SectionKey,
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
                BankRef,
                DAMOutcome,
                ITCOutcome,
                ITCAdjustedAmount,
                Supply,
                Invoice,
                Taxable,
                GSTOutcome,
                PayMethod_ID,
                GSTPercentage,
                AuditDateTimeUTC,
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
                s.AuditKey,
                s.ClaimKey,
                s.PayeeKey,
                s.AuditUserName,
                s.AuditDateTime,
                s.AuditAction,
                s.PaymentKey,
                s.EventKey,
                s.SectionKey,
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
                s.BankRef,
                s.DAMOutcome,
                s.ITCOutcome,
                s.ITCAdjustedAmount,
                s.Supply,
                s.Invoice,
                s.Taxable,
                s.GSTOutcome,
                s.PayMethod_ID,
                s.GSTPercentage,
                s.AuditDateTimeUTC,
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
                )
        from
            @mergeoutput

        --reset first occurence & valid indicator flag for rolledup data
        update [db-au-cba].dbo.clmAuditPayment
        set
            FirstOccurrenceIndicator = 0,
            ValidTransactionsIndicator = 0
        where
            ClaimKey in
            (
                select ClaimKey
                from
                    etl_audit_claims_payment
            )

        set @updatecount = @@rowcount

        --set first occurence flag
        if object_id('etl_audit_claims_payment_firstoccur') is not null
            drop table etl_audit_claims_payment_firstoccur

        ;with cte_auditpayment as
        (
            select distinct
                CountryKey,
                PaymentKey,
                PaymentStatus
            from
                [db-au-cba].dbo.clmAuditPayment cap
            where
                ClaimKey in
                (
                    select ClaimKey
                    from
                        etl_audit_claims_payment
                )
        )
        select 
            AuditKey
        into etl_audit_claims_payment_firstoccur
        from
            cte_auditpayment cap
            cross apply
            (
                select top 1
                    AuditKey
                from
                    [db-au-cba].dbo.clmAuditPayment r
                where
                    r.PaymentKey = cap.PaymentKey and
                    r.PaymentStatus = cap.PaymentStatus
                order by
                    AuditDateTime,
                    /*identical timestamp workaround*/
                    BIRowID
            ) r
            
        /* F22370 */
        insert into etl_audit_claims_payment_firstoccur
        select 
            cap.AuditKey
        from
            [db-au-cba].dbo.clmAuditPayment cap
            cross apply
            (
                select top 1
                    PaymentStatus PreviousStatus
                from
                    [db-au-cba].dbo.clmAuditPayment r
                where
                    r.PaymentKey = cap.PaymentKey and
                    /*identical timestamp workaround*/
                    r.AuditDateTime <= cap.AuditDateTime and
                    r.BIRowID <> cap.BIRowID
                order by
                    r.AuditDateTime desc,
                    BIRowID desc
            ) ps
        where
            ClaimKey in
            (
                select 
                    ClaimKey
                from
                    etl_audit_claims_payment
            ) and
            not exists
            (
                select null
                from
                    etl_audit_claims_payment_firstoccur r
                where
                    cap.AuditKey = r.AuditKey
            ) and
            cap.PaymentStatus = 'PAID' and
            isnull(ps.PreviousStatus, 'PAID') <> 'PAID'
           

        update cap
        set
            FirstOccurrenceIndicator = 1
        from
            [db-au-cba].dbo.clmAuditPayment cap
        where
            cap.AuditKey in
            (
                select 
                    AuditKey
                from
                    etl_audit_claims_payment_firstoccur
            ) and
            (
                cap.PaymentStatus = 'RECY' or
                
                --must have previous records
                exists
                (
                    select 
                        null
                    from
                        [db-au-cba].dbo.clmAuditPayment r
                    where
                        r.PaymentKey = cap.PaymentKey and
                        r.AuditDateTime < cap.AuditDateTime and
                        r.PaymentStatus not in ('PAID')
                )
            )

        --set valid indicator flag
        update cap
        set
            ValidTransactionsIndicator = 1
        from
            [db-au-cba].dbo.clmAuditPayment cap
            outer apply
            (
                select top 1
                    pcap.PaymentStatus PreviousPaymentStatus
                from
                    [db-au-cba].dbo.clmAuditPayment pcap
                where
                    pcap.PaymentKey = cap.PaymentKey and
                    pcap.AuditDateTime < cap.AuditDateTime and
                    pcap.FirstOccurrenceIndicator = 1
                order by
                    pcap.AuditDateTime desc
            ) pcap
        where
            AuditKey in
            (
                select AuditKey
                from
                    etl_audit_claims_payment_firstoccur
            ) and
            FirstOccurrenceIndicator = 1 and
            (
                PaymentStatus in ('PAID', 'RECY') or
                PreviousPaymentStatus is null or
                (
                    PaymentStatus in ('CANX', 'FAIL', 'RTND', 'STOP') and
                    PreviousPaymentStatus not in ('CANX', 'FAIL', 'RTND', 'STOP')
                )
            )

        --update isDeleted
        update [db-au-cba]..clmPayment
        set
            isDeleted = 1,
            UpdateBatchID = @batchid
        where
            PaymentKey in
            (
                select
                    PaymentKey
                from
                    etl_audit_claims_payment
                where
                    AuditAction = 'D'
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
            @SourceInfo = 'clmAuditPayment data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end



GO
