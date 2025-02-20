USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_emcAuditPayment]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_emcAuditPayment]
as
begin
/*
    20140317, LS,   TFS 9410, UK data
                    take off audit, it will be called independently
*/

    set nocount on

    exec etlsp_StagingIndex_EMC

    if object_id('[db-au-cba].dbo.emcAuditPayment') is null
    begin

        create table [db-au-cba].dbo.emcAuditPayment
        (
            CountryKey varchar(2) not null,
            ApplicationKey varchar(15) not null,
            AuditPaymentKey varchar(15) not null,
            ApplicationID int not null,
            AuditPaymentID int not null,
            OrderID varchar(50) null,
            AuditDate datetime null,
            AuditUserLogin varchar(50) null,
            AuditUser varchar(255) null,
            AuditAction varchar(5) null,
            PaymentDate datetime null,
            EMCPremium decimal(18, 2) not null,
            AgePremium decimal(18, 2) not null,
            Excess decimal(18, 2) not null,
            GeneralLimit decimal(18, 2) not null,
            PaymentDuration varchar(15) null,
            RestrictedConditions varchar(255) null,
            OtherRestrictions varchar(255) null,
            PaymentComments varchar(1000) null,
            Surname varchar(22) null,
            CardType varchar(6) null,
            GST decimal(18, 2) not null,
            MerchantID varchar(16) null,
            ReceiptNo varchar(50) null,
            TransactionResponseCode varchar(5) null,
            ACQResponseCode varchar(50) null,
            TransactionStatus varchar(100) null
        )

        create index idx_emcAuditPayment_ApplicationKey on [db-au-cba].dbo.emcAuditPayment(ApplicationKey)
        create index idx_emcAuditPayment_CountryKey on [db-au-cba].dbo.emcAuditPayment(CountryKey)
        create index idx_emcAuditPayment_ApplicationID on [db-au-cba].dbo.emcAuditPayment(ApplicationID, CountryKey)
        create index idx_emcAuditPayment_PaymentDate on [db-au-cba].dbo.emcAuditPayment(PaymentDate, CountryKey)
        create index idx_emcAuditPayment_OrderID on [db-au-cba].dbo.emcAuditPayment(OrderID, CountryKey)
        create index idx_emcAuditPayment_AuditPaymentID on [db-au-cba].dbo.emcAuditPayment(AuditPaymentID, CountryKey)
        create index idx_emcAuditPayment_AuditDate on [db-au-cba].dbo.emcAuditPayment(AuditDate, CountryKey)

    end

    if object_id('etl_emcAuditPayment') is not null
        drop table etl_emcAuditPayment

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar(12), ClientID) ApplicationKey,
        dk.CountryKey + '-' + convert(varchar(12), [Counter]) AuditPaymentKey,
        ClientID ApplicationID,
        [Counter] AuditPaymentID,
        OrderID,
        AUDIT_DATETIME AuditDate,
        AUDIT_USERNAME AuditUserLogin,
        s.FullName AuditUser,
        AUDIT_ACTION AuditAction,
        PDate PaymentDate,
        isnull(Premium, 0) EMCPremium,
        isnull(Over70, 0) AgePremium,
        isnull(Excess, 0) Excess,
        isnull(Limit, 0) GeneralLimit,
        Duration PaymentDuration,
        ResricCond RestrictedConditions,
        OtherRestrictions,
        Comments PaymentComments,
        Surname,
        CardType,
        isnull(GST,0) GST,
        MerchantID,
        ReceiptNo,
        TxnResponseCode TransactionResponseCode,
        ACQResponseCode,
        p.Status TransactionStatus
    into etl_emcAuditPayment
    from
        emc_CBA_EMC_AUDIT_PAYMENT_AU p
        outer apply dbo.fn_GetEMCDomainKeys(p.ClientID, 'AU') dk
        left join emc_CBA_EMC_tblSecurity_AU s on
            s.Login = p.AUDIT_USERNAME

    

    delete eap
    from
        [db-au-cba].dbo.emcAuditPayment eap
        inner join etl_emcAuditPayment t on
            t.AuditPaymentKey = eap.AuditPaymentKey


    insert into [db-au-cba].dbo.emcAuditPayment with (tablock)
    (
        CountryKey,
        ApplicationKey,
        AuditPaymentKey,
        ApplicationID,
        AuditPaymentID,
        OrderID,
        AuditDate,
        AuditUserLogin,
        AuditUser,
        AuditAction,
        PaymentDate,
        EMCPremium,
        AgePremium,
        Excess,
        GeneralLimit,
        PaymentDuration,
        RestrictedConditions,
        OtherRestrictions,
        PaymentComments,
        Surname,
        CardType,
        GST,
        MerchantID,
        ReceiptNo,
        TransactionResponseCode,
        ACQResponseCode,
        TransactionStatus
    )
    select
        CountryKey,
        ApplicationKey,
        AuditPaymentKey,
        ApplicationID,
        AuditPaymentID,
        OrderID,
        AuditDate,
        AuditUserLogin,
        AuditUser,
        AuditAction,
        PaymentDate,
        EMCPremium,
        AgePremium,
        Excess,
        GeneralLimit,
        PaymentDuration,
        RestrictedConditions,
        OtherRestrictions,
        PaymentComments,
        Surname,
        CardType,
        GST,
        MerchantID,
        ReceiptNo,
        TransactionResponseCode,
        ACQResponseCode,
        TransactionStatus
    from
        etl_emcAuditPayment

end

GO
