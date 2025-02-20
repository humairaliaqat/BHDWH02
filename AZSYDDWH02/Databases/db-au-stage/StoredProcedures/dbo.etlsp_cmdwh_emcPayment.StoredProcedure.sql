USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_emcPayment]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_emcPayment]
as
begin
/*
    20140317, LS,   TFS 9410, UK data
                    take off audit, it will be called independently
*/

    set nocount on

    exec etlsp_StagingIndex_EMC

    if object_id('[db-au-cba].dbo.emcPayment') is null
    begin

        create table [db-au-cba].dbo.emcPayment
        (
            CountryKey varchar(2) not null,
            ApplicationKey varchar(15) not null,
            PaymentKey varchar(15) not null,
            ApplicationID int not null,
            PaymentID int not null,
            OrderID varchar(50) null,
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

        create index idx_emcPayment_ApplicationKey on [db-au-cba].dbo.emcPayment(ApplicationKey)
        create index idx_emcPayment_CountryKey on [db-au-cba].dbo.emcPayment(CountryKey)
        create index idx_emcPayment_ApplicationID on [db-au-cba].dbo.emcPayment(ApplicationID, CountryKey)
        create index idx_emcPayment_PaymentDate on [db-au-cba].dbo.emcPayment(PaymentDate, CountryKey)
        create index idx_emcPayment_OrderID on [db-au-cba].dbo.emcPayment(OrderID, CountryKey)

    end

    if object_id('etl_emcPayment') is not null
        drop table etl_emcPayment

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar(12), ClientID) ApplicationKey,
        dk.CountryKey + '-' + convert(varchar(12), [Counter]) PaymentKey,
        ClientID ApplicationID,
        [Counter] PaymentID,
        OrderID,
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
    into etl_emcPayment
    from
        emc_CBA_EMC_Payment_AU p
        outer apply dbo.fn_GetEMCDomainKeys(p.ClientID, 'AU') dk
    where
        ClientID is not null

   

    delete ep
    from
        [db-au-cba].dbo.emcPayment ep
        inner join etl_emcPayment t on
            t.PaymentKey = ep.PaymentKey


    insert into [db-au-cba].dbo.emcPayment with (tablock)
    (
        CountryKey,
        ApplicationKey,
        PaymentKey,
        ApplicationID,
        PaymentID,
        OrderID,
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
        PaymentKey,
        ApplicationID,
        PaymentID,
        OrderID,
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
        etl_emcPayment

end

GO
