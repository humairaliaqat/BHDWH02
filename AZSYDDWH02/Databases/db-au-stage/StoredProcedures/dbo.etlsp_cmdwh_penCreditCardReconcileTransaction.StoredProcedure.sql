USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penCreditCardReconcileTransaction]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_penCreditCardReconcileTransaction]
as
begin
/************************************************************************************************************************************
Author:         Linus Tor
Date:           20130527
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    CreditCardReconcileTransaction table contains credit card reconcile attributes.
                This transformation adds essential key fields and denormalises tables.
Change History:
                20130607 - LT - Procedure created
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20130726 - LT - Amended proceudre to cater for UK Penguin ETL/Refresh window
                20140613 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
                20140715 - LS - F 21325, use transaction, other session will not see data gets deleted until after it's replaced (intraday refresh)
                20160321 - LT - Penguin 18.0, Added US Penguin Instance
*************************************************************************************************************************************/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penCreditCardReconcileTransaction') is not null
        drop table etl_penCreditCardReconcileTransaction

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, p.CreditCardReconcileTransactionID) as CreditCardReconcileTransactionKey,
        PrefixKey + convert(varchar, p.CreditCardReconcileID) as CreditCardReconcileKey,
        PrefixKey + convert(varchar, p.PolicyTransactionID) as PolicyTransactionKey,
        PrefixKey + convert(varchar, p.OutletID) as OutletKey,
        p.CreditCardReconcileTransactionID,
        p.CreditCardReconcileID,
        p.PolicyTransactionID,
        p.Net,
        p.Commission,
        p.Gross,
        p.AmountType,
        p.PaymentTypeID,
        pyt.PaymentTypeName,
        pyt.PaymentTypeCode,
        p.[Status],
        p.OutletID,
        p.AlphaCode,
        dbo.xfn_ConvertUTCtoLocal(p.CreateDateTime, TimeZone) as CreateDateTime,
        p.CreateDateTime as CreateDateTimeUTC,
        dbo.xfn_ConvertUTCtoLocal(p.UpdateDateTime, TimeZone) as UpdateDateTime,
        p.UpdateDateTime as UpdateDateTimeUTC
    into etl_penCreditCardReconcileTransaction
    from
        dbo.penguin_tblCreditCardReconcileTransaction_aucm p
        inner join dbo.penguin_tblCreditCardReconcile_aucm c on
            p.CreditCardReconcileID = c.CreditCardReconcileID
        cross apply dbo.fn_GetDomainKeys(c.DomainID, 'CM', 'AU') dk
        outer apply
        (
            select top 1
                [Code] PaymentTypeCode,
                [Name] PaymentTypeName
            from
                penguin_tblPaymentType_aucm
            where
                PaymentTypeID = p.PaymentTypeID
        ) pyt

  

    if object_id('[db-au-cba].dbo.penCreditCardReconcileTransaction') is null
    begin

        create table [db-au-cba].dbo.[penCreditCardReconcileTransaction]
        (
            [CountryKey] varchar(2) null,
            [CompanyKey] varchar(5) null,
            [DomainKey] varchar(41) null,
            [CreditCardReconcileTransactionKey] varchar(41) null,
            [CreditCardReconcileKey] varchar(41) null,
            [PolicyTransactionKey] varchar(41) null,
            [OutletKey] varchar(41) null,
            [CreditCardReconcileTransactionID] int null,
            [CreditCardReconcileID] int null,
            [PolicyTransactionID] int null,
            [Net] money null,
            [Commission] money null,
            [Gross] money null,
            [AmountType] varchar(15) null,
            [PaymentTypeID] int null,
            [PaymentTypeName] varchar(55) null,
            [PaymentTypeCode] varchar(3) null,
            [Status] varchar(15) null,
            [OutletID] int null,
            [AlphaCode] nvarchar(20) null,
            [CreateDateTime] datetime null,
            [CreateDateTimeUTC] datetime null,
            [UpdateDateTime] datetime null,
            [UpdateDateTimeUTC] datetime null
        )

        create clustered index idx_penCreditCardReconcileTransaction_CreditCardReconcileTransactionKey on [db-au-cba].dbo.penCreditCardReconcileTransaction(CreditCardReconcileTransactionKey)
        create nonclustered index idx_penCreditCardReconcileTransaction_CountryKey on [db-au-cba].dbo.penCreditCardReconcileTransaction(CountryKey)
        create nonclustered index idx_penCreditCardReconcileTransaction_CreditCardReconcileKey on [db-au-cba].dbo.penCreditCardReconcileTransaction(CreditCardReconcileKey)
        create nonclustered index idx_penCreditCardReconcileTransaction_OutletKey on [db-au-cba].dbo.penCreditCardReconcileTransaction(OutletKey)
        create nonclustered index idx_penCreditCardReconcileTransaction_PolicyTransactionKey on [db-au-cba].dbo.penCreditCardReconcileTransaction(PolicyTransactionKey)

    end
    
    
    begin transaction penCCReconcileTransaction
    
    begin try

        delete a
        from
            [db-au-cba].dbo.penCreditCardReconcileTransaction a
            inner join etl_penCreditCardReconcileTransaction b on
                a.CreditCardReconcileTransactionKey = b.CreditCardReconcileTransactionKey

        insert [db-au-cba].dbo.penCreditCardReconcileTransaction with(tablockx)
        (
            [CountryKey],
            [CompanyKey],
            [DomainKey],
            [CreditCardReconcileTransactionKey],
            [CreditCardReconcileKey],
            [PolicyTransactionKey],
            [OutletKey],
            [CreditCardReconcileTransactionID],
            [CreditCardReconcileID],
            [PolicyTransactionID],
            [Net],
            [Commission],
            [Gross],
            [AmountType],
            [PaymentTypeID],
            [PaymentTypeName],
            [PaymentTypeCode],
            [Status],
            [OutletID],
            [AlphaCode],
            [CreateDateTime],
            [CreateDateTimeUTC],
            [UpdateDateTime],
            [UpdateDateTimeUTC]
        )
        select
            [CountryKey],
            [CompanyKey],
            [DomainKey],
            [CreditCardReconcileTransactionKey],
            [CreditCardReconcileKey],
            [PolicyTransactionKey],
            [OutletKey],
            [CreditCardReconcileTransactionID],
            [CreditCardReconcileID],
            [PolicyTransactionID],
            [Net],
            [Commission],
            [Gross],
            [AmountType],
            [PaymentTypeID],
            [PaymentTypeName],
            [PaymentTypeCode],
            [Status],
            [OutletID],
            [AlphaCode],
            [CreateDateTime],
            [CreateDateTimeUTC],
            [UpdateDateTime],
            [UpdateDateTimeUTC]
        from
            etl_penCreditCardReconcileTransaction

    end try
    
    begin catch
    
        if @@trancount > 0
            rollback transaction penCCReconcileTransaction
            
        exec syssp_genericerrorhandler 'penCreditCardReconcileTransaction data refresh failed'
        
    end catch    

    if @@trancount > 0
        commit transaction penCCReconcileTransaction
        
end


GO
