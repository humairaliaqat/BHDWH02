USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penCreditCardReconcile]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_penCreditCardReconcile]
as
begin
/************************************************************************************************************************************
Author:         Linus Tor
Date:           20130527
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    CreditCardReconcile table contains credit card reconcile attributes.
                This transformation adds essential key fields and denormalises tables.
Change History:
                20130607 - LT - Procedure created
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20130726 - LT - Amended proceudre to cater for UK Penguin ETL/Refresh window
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
                20140715 - LS - F 21325, use transaction, other session will not see data gets deleted until after it's replaced (intraday refresh)
				20160321 - LT - Penguin 18.0, added US Penguin instance
*************************************************************************************************************************************/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penCreditCardReconcile') is not null
        drop table etl_penCreditCardReconcile

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, p.CreditCardReconcileID) as CreditCardReconcileKey,
        PrefixKey + convert(varchar, p.CRMUserID) as CRMUserKey,
        p.CreditCardReconcileID,
        p.CRMUserID,
        p.[Status],
        dbo.xfn_ConvertUTCtoLocal(p.AccountingPeriod, TimeZone) as AccountingPeriod,
        p.AccountingPeriod as AccountingPeriodUTC,
        p.Groups,
        p.DomainID,
        dbo.xfn_ConvertUTCtoLocal(p.CreateDateTime, TimeZone) as CreateDateTime,
        p.CreateDateTime as CreateDateTimeUTC,
        dbo.xfn_ConvertUTCtoLocal(p.UpdateDateTime, TimeZone) as UpdateDateTime,
        p.UpdateDateTime as UpdateDateTimeUTC,
        p.DirectsCheque,
        p.NetCheque,
        p.CommissionCheque
    into etl_penCreditCardReconcile
    from
        dbo.penguin_tblCreditCardReconcile_aucm p
        cross apply dbo.fn_GetDomainKeys(p.DomainID, 'CM', 'AU') dk

 

    if object_id('[db-au-cba].dbo.penCreditCardReconcile') is null
    begin

        create table [db-au-cba].dbo.[penCreditCardReconcile]
        (
            [CountryKey] varchar(2) null,
            [CompanyKey] varchar(5) null,
            [DomainKey] varchar(41) null,
            [CreditCardReconcileKey] varchar(41) null,
            [CRMUserKey] varchar(41) null,
            [CreditCardReconcileID] int null,
            [CRMUserID] int null,
            [Status] varchar(15) null,
            [AccountingPeriod] datetime null,
            [AccountingPeriodUTC] datetime null,
            [Groups] varchar(255) null,
            [DomainID] int null,
            [CreateDateTime] datetime null,
            [CreateDateTimeUTC] datetime null,
            [UpdateDateTime] datetime null,
            [UpdateDateTimeUTC] datetime null,
            [DirectsCheque] varchar(30) null,
            [NetCheque] varchar(30) null,
            [CommissionCheque] varchar(30) null
        )

        create clustered index idx_penCreditCardReconcile_CreditCardReconcileKey on [db-au-cba].dbo.penCreditCardReconcile(CreditCardReconcileKey)
        create nonclustered index idx_penCreditCardReconcile_AccountingPeriod on [db-au-cba].dbo.penCreditCardReconcile(AccountingPeriod,CountryKey,CompanyKey)
        create nonclustered index idx_penCreditCardReconcile_CountryKey on [db-au-cba].dbo.penCreditCardReconcile(CountryKey)
        create nonclustered index idx_penCreditCardReconcile_CRMUserKey on [db-au-cba].dbo.penCreditCardReconcile(CRMUserKey)

    end
    else
    begin

        delete a
        from
            [db-au-cba].dbo.penCreditCardReconcile a
            inner join etl_penCreditCardReconcile b on
                a.CreditCardReconcileKey = b.CreditCardReconcileKey

    end


    insert [db-au-cba].dbo.penCreditCardReconcile with(tablockx)
    (
        [CountryKey],
        [CompanyKey],
        [DomainKey],
        [CreditCardReconcileKey],
        [CRMUserKey],
        [CreditCardReconcileID],
        [CRMUserID],
        [Status],
        [AccountingPeriod],
        [AccountingPeriodUTC],
        [Groups],
        [DomainID],
        [CreateDateTime],
        [CreateDateTimeUTC],
        [UpdateDateTime],
        [UpdateDateTimeUTC],
        [DirectsCheque],
        [NetCheque],
        [CommissionCheque]
    )
    select
        [CountryKey],
        [CompanyKey],
        [DomainKey],
        [CreditCardReconcileKey],
        [CRMUserKey],
        [CreditCardReconcileID],
        [CRMUserID],
        [Status],
        [AccountingPeriod],
        [AccountingPeriodUTC],
        [Groups],
        [DomainID],
        [CreateDateTime],
        [CreateDateTimeUTC],
        [UpdateDateTime],
        [UpdateDateTimeUTC],
        [DirectsCheque],
        [NetCheque],
        [CommissionCheque]
    from
        etl_penCreditCardReconcile

end


GO
