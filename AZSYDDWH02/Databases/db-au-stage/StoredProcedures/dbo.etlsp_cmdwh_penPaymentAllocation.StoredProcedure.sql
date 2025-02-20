USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penPaymentAllocation]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penPaymentAllocation]
as
begin

/************************************************************************************************************************************
Author:         Linus Tor
Date:           20130527
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    PaymentAllocation table contains payment allocation attributes.
                This transformation adds essential key fields and implemented slow changing dimension technique to track
                changes to the agency attributes.
Change History:
                20130531 - LT - Procedure created
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20130815 - LS - bug fix, fn_GetOutletDomainKeys should have been fn_GetDomainKeys
                20140715 - LS - F 21325, use transaction, other session will not see data gets deleted until after it's replaced (intraday refresh)
				20160321 - LT - Penguin 18.0, added US Penguin instance

*************************************************************************************************************************************/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penPaymentAllocation') is not null
        drop table etl_penPaymentAllocation


    --temp workaround for invalid accounting period
    update penguin_tblPaymentAllocation_aucm
    set AccountingPeriod = dateadd(d,-1,convert(datetime,convert(varchar(8),dateadd(m,1,getdate()),120)+'01'))
    where AccountingPeriod = '0001-01-01'

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        left(PrefixKey + convert(varchar, p.PaymentAllocationID), 41) as PaymentAllocationKey,
        left(PrefixKey + convert(varchar, p.OutletID), 41) as OutletKey,
        left(PrefixKey + convert(varchar, p.CRMUserID), 41) as CRMUserKey,
        p.PaymentAllocationID,
        p.OutletID,
        p.AlphaCode,
        dbo.xfn_ConvertUTCtoLocal(p.AccountingPeriod,Timezone) as AccountingPeriod,
        p.AccountingPeriod as AccountingPeriodUTC,
        p.PaymentAmount,
        p.AmountType,
        p.Comments,
        p.[Status],
        p.[Source],
        dbo.xfn_ConvertUTCtoLocal(p.CreateDateTime, Timezone) as CreateDateTime,
        dbo.xfn_ConvertUTCtoLocal(p.UpdateDateTime, Timezone) as UpdateDateTime,
        p.CreateDateTime as CreateDateTimeUTC,
        p.UpdateDateTime as UpdateDateTimeUTC,
        p.PolicyAmount
    into etl_penPaymentAllocation
    from
        dbo.penguin_tblPaymentAllocation_aucm p
        inner join dbo.penguin_tblOutlet_aucm o on
            p.OutletID = o.OutletID
        inner join dbo.penguin_tblCRMUser_aucm u on
            p.CRMUserID = u.ID
        cross apply dbo.fn_GetDomainKeys(o.DomainID, 'CM', 'AU') dk

 

    if object_id('[db-au-cba].dbo.penPaymentAllocation') is null
    begin

        create table [db-au-cba].[dbo].penPaymentAllocation
        (
            [CountryKey] [varchar](2) null,
            [CompanyKey] [varchar](5) null,
            [DomainKey] [varchar](41) null,
            [PaymentAllocationKey] [varchar](41) null,
            [OutletKey] [varchar](41) null,
            [CRMUserKey] [varchar](41) null,
            [PaymentAllocationID] [int] not null,
            [OutletID] [int] not null,
            [AlphaCode] [varchar](20) not null,
            [AccountingPeriod] [datetime] null,
            [AccountingPeriodUTC] [date] not null,
            [PaymentAmount] [money] not null,
            [AmountType] [varchar](15) not null,
            [Comments] [varchar](255) null,
            [Status] [varchar](15) not null,
            [Source] [varchar](50) not null,
            [CreateDateTime] [datetime] null,
            [UpdateDateTime] [datetime] null,
            [CreateDateTimeUTC] [datetime] not null,
            [UpdateDateTimeUTC] [datetime] not null,
            [PolicyAmount] [money] not null,
        )

        create clustered index idx_penPaymentAllocation_PaymentAllocationKey on [db-au-cba].dbo.penPaymentAllocation(PaymentAllocationKey)
        create index idx_penPaymentAllocation_CountryKey on [db-au-cba].dbo.penPaymentAllocation(CountryKey)
        create index idx_penPaymentAllocation_OutletKey on [db-au-cba].dbo.penPaymentAllocation(OutletKey)
        create index idx_penPaymentAllocation_CMRUserKey on [db-au-cba].dbo.penPaymentAllocation(CRMUserKey)
        
    end
    
    
    begin transaction penPaymentAllocation
    
    begin try

        delete a
        from
            [db-au-cba].dbo.penPaymentAllocation a
            inner join etl_penPaymentAllocation b on
                a.PaymentAllocationKey = b.PaymentAllocationKey

        insert [db-au-cba].dbo.penPaymentAllocation with(tablockx)
        (
            [CountryKey],
            [CompanyKey],
            [DomainKey],
            [PaymentAllocationKey],
            [OutletKey],
            [CRMUserKey],
            [PaymentAllocationID],
            [OutletID],
            [AlphaCode],
            [AccountingPeriod],
            [AccountingPeriodUTC],
            [PaymentAmount],
            [AmountType],
            [Comments],
            [Status],
            [Source],
            [CreateDateTime],
            [UpdateDateTime],
            [CreateDateTimeUTC],
            [UpdateDateTimeUTC],
            [PolicyAmount]
        )
        select
            [CountryKey],
            [CompanyKey],
            [DomainKey],
            [PaymentAllocationKey],
            [OutletKey],
            [CRMUserKey],
            [PaymentAllocationID],
            [OutletID],
            [AlphaCode],
            [AccountingPeriod],
            [AccountingPeriodUTC],
            [PaymentAmount],
            [AmountType],
            [Comments],
            [Status],
            [Source],
            [CreateDateTime],
            [UpdateDateTime],
            [CreateDateTimeUTC],
            [UpdateDateTimeUTC],
            [PolicyAmount]
        from
            etl_penPaymentAllocation

    end try
    
    begin catch
    
        if @@trancount > 0
            rollback transaction penPaymentAllocation
            
        exec syssp_genericerrorhandler 'penPaymentAllocation data refresh failed'
        
    end catch    

    if @@trancount > 0
        commit transaction penPaymentAllocation
        
end


GO
