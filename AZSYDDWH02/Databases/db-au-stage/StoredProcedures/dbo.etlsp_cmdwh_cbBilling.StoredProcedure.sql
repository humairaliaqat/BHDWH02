USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_cbBilling]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_cbBilling]
as
begin
/*
20131014, LS,   schema changes
20131121, LS,   remap columns
20140715, LS,   TFS12109
                cange Provider from encrypted to nvarchar
                remap BillItem to master data
                use transaction (as carebase has intra-day refreshes)
20140825, LS,   use audit insert date as create date for cost containment billing
                wtf were they thinking when they remove created date?
*/

    set nocount on

    exec etlsp_StagingIndex_Carebase

    if object_id('[db-au-cba].dbo.cbBilling') is null
    begin

        create table [db-au-cba].dbo.cbBilling
        (
            [BIRowID] bigint not null identity(1,1),
            [CountryKey] nvarchar(2) not null,
            [CaseKey] nvarchar(20) not null,
            [BillingKey] nvarchar(20) not null,
            [AddressKey] nvarchar(20) null,
            [CaseNo] nvarchar(15) not null,
            [BillingID] int not null,
            [OpenDate] datetime null,
            [OpenTimeUTC] datetime null,
            [SentDate] datetime null,
            [SentTimeUTC] datetime null,
            [OpenedByID] nvarchar(30) null,
            [OpenedBy] nvarchar(55) null,
            [ProcessedBy] nvarchar(30) null,
            [BillingTypeCode] nvarchar(10) null,
            [BillingType] nvarchar(100) null,
            [InvoiceNo] nvarchar(50) null,
            [InvoiceDate] datetime null,
            [BillItem] nvarchar(20) null,
            [Provider] nvarchar(200) null,
            [Details] nvarchar(1500) null,
            [PaymentBy] nvarchar(50) null,
            [PaymentDate] datetime null,
            [LocalCurrencyCode] nvarchar(3) null,
            [LocalCurrency] nvarchar(20) null,
            [LocalInvoice] money null,
            [ExchangeRate] money null,
            [AUDInvoice] money null,
            [AUDGST] money null,
            [CostContainmentAgent] nvarchar(25) null,
            [BackFrontEnd] nvarchar(50) null,
            [CCInvoiceAmount] money null,
            [CCSaving] money null,
            [CCDiscountedInvoice] money null,
            [CustomerPayment] money null,
            [ClientPayment] money null,
            [PPOFee] money null,
            [TotalDueCCAgent] money null,
            [CCFee] money null,
            [isImported] bit null,
            [isDeleted] bit null
        )

        create clustered index idx_cbBilling_BIRowID on [db-au-cba].dbo.cbBilling(BIRowID)
        create nonclustered index idx_cbBilling_BillItem on [db-au-cba].dbo.cbBilling(BillItem,CountryKey)
        create nonclustered index idx_cbBilling_CaseKey on [db-au-cba].dbo.cbBilling(CaseKey)
        create nonclustered index idx_cbBilling_CaseNo on [db-au-cba].dbo.cbBilling(CaseNo,CountryKey)
        create nonclustered index idx_cbBilling_OpenDate on [db-au-cba].dbo.cbBilling(OpenDate)
        create nonclustered index idx_cbBilling_OpenedBy on [db-au-cba].dbo.cbBilling(OpenedBy,OpenDate)
        create nonclustered index idx_cbBilling_SentDate on [db-au-cba].dbo.cbBilling(SentDate,CountryKey)
        create nonclustered index idx_cbBilling_BillingKey on [db-au-cba].dbo.cbBilling(BillingKey) include(CaseKey)

    end

    if object_id('tempdb..#cbBilling') is not null
        drop table #cbBilling

    select
        'AU' CountryKey,
        left('AU-' + bl.CASE_NO, 20) CaseKey,
        left('AU-' + convert(varchar, bl.ROWID), 20) BillingKey,
        left('AU-' + convert(varchar, Address_ID), 20) AddressKey,
        bl.CASE_NO CaseNo,
        bl.rowid BillingID,
        dbo.xfn_ConvertUTCtoLocal(isnull(OPEN_DATE, abl.BillingInsertDateUTC), 'AUS Eastern Standard Time') OpenDate,
        isnull(OPEN_DATE, abl.BillingInsertDateUTC) OpenTimeUTC,
        dbo.xfn_ConvertUTCtoLocal(dep_date, 'AUS Eastern Standard Time') SentDate,
        dep_date SentTimeUTC,
        init_ac OpenedByID,
        OpenedBy,
        accauthby ProcessedBy,
        BillingTypeCode,
        BillingType,
        INVOICE_NO InvoiceNo,
        BILL_DATE InvoiceDate,
        isnull(bi.ITEM, bl.ITEM) BillItem,
        Provider,
        NOTES Details,
        PaymentBy,
        PFP_DATE PaymentDate,
        bl.CURRENCY LocalCurrencyCode,
        cr.DESCRIPT LocalCurrency,
        LOCAL_REV LocalInvoice,
        EXCHANGE ExchangeRate,
        AUD_REV AUDInvoice,
        AUD_GST AUDGST,
        PPO_NETWORK CostContainmentAgent,
        BACK_FRONT_END BackFrontEnd,
        LOCAL_ACT CCInvoiceAmount,
        NET_SAVING CCSaving,
        LOCAL_ACT - NET_SAVING CCDiscountedInvoice,
        CUST_PAYMENT CustomerPayment,
        CLIENT_PAYMENT ClientPayment,
        PPO_FEE PPOFee,
        LOCAL_REV TotalDueCCAgent,
        CCA_CCFEE CCFee,
        isImported,
        isDeleted
    into #cbBilling
    from
        carebase_CBL_BILLING_aucm bl
        left join carebase_UCR_CURRENCY_aucm cr on
            cr.CURRENCY = bl.CURRENCY
        outer apply
        (
            select top 1
                PREF_NAME + ' ' + SURNAME OpenedBy
            from
                carebase_ADM_USER_aucm u
            where
                u.USERID = bl.init_ac
        ) ob
        outer apply
        (
            select top 1
                bt.Code BillingTypeCode,
                bt.Description BillingType
            from
                carebase_tblBillingType_aucm bt
            where
                bt.BillingType_ID = bl.BillingType_ID
        ) bt
        outer apply
        (
            select top 1
                pb.Description PaymentBy
            from
                carebase_tblPaymentByDetails_aucm pb
            where
                pb.PaymentBy_ID = bl.PaymentBy_ID
        ) pb
        outer apply
        (
            select top 1
                ITEM
            from
                carebase_BILL_ITEMS_CV_aucm bi
            where
                bi.BILL_ITEM_ID = bl.BillingItem_ID
        ) bi
        outer apply
        (
            select top 1
                AUDIT_DATETIME BillingInsertDateUTC
            from
                carebase_AUDIT_CBL_BILLING_aucm abl
            where
                abl.ROWID = bl.ROWID and
                abl.AUDIT_ACTION = 'I'
        ) abl


    begin transaction cbBilling

    begin try

        delete
        from [db-au-cba].dbo.cbBilling
        where
            BillingKey in
            (
                select
                    left('AU-' + convert(varchar, ROWID), 20) collate database_default
                from
                    carebase_CBL_BILLING_aucm
            )

        insert into [db-au-cba].dbo.cbBilling with(tablock)
        (
            CountryKey,
            CaseKey,
            BillingKey,
            AddressKey,
            CaseNo,
            BillingID,
            OpenDate,
            OpenTimeUTC,
            SentDate,
            SentTimeUTC,
            OpenedByID,
            OpenedBy,
            ProcessedBy,
            BillingTypeCode,
            BillingType,
            InvoiceNo,
            InvoiceDate,
            BillItem,
            Provider,
            Details,
            PaymentBy,
            PaymentDate,
            LocalCurrencyCode,
            LocalCurrency,
            LocalInvoice,
            ExchangeRate,
            AUDInvoice,
            AUDGST,
            CostContainmentAgent,
            BackFrontEnd,
            CCInvoiceAmount,
            CCSaving,
            CCDiscountedInvoice,
            CustomerPayment,
            ClientPayment,
            PPOFee,
            TotalDueCCAgent,
            CCFee,
            isImported,
            isDeleted
        )
        select
            CountryKey,
            CaseKey,
            BillingKey,
            AddressKey,
            CaseNo,
            BillingID,
            OpenDate,
            OpenTimeUTC,
            SentDate,
            SentTimeUTC,
            OpenedByID,
            OpenedBy,
            ProcessedBy,
            BillingTypeCode,
            BillingType,
            InvoiceNo,
            InvoiceDate,
            BillItem,
            Provider,
            Details,
            PaymentBy,
            PaymentDate,
            LocalCurrencyCode,
            LocalCurrency,
            LocalInvoice,
            ExchangeRate,
            AUDInvoice,
            AUDGST,
            CostContainmentAgent,
            BackFrontEnd,
            CCInvoiceAmount,
            CCSaving,
            CCDiscountedInvoice,
            CustomerPayment,
            ClientPayment,
            PPOFee,
            TotalDueCCAgent,
            CCFee,
            isImported,
            isDeleted
        from
            #cbBilling

    end try

    begin catch

        if @@trancount > 0
            rollback transaction cbBilling

        exec syssp_genericerrorhandler 'cbBilling data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction cbBilling

end


GO
