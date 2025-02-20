USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penPaymentAllocationAdjustment]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_penPaymentAllocationAdjustment]
as
begin
/************************************************************************************************************************************
Author:         Linus Tor
Date:           20130527
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    PaymentAllocationAdjustment table contains payment allocation adjustment attributes.
                This transformation adds essential key fields and denormalise tables.
Change History:
                20130607 - LT - Procedure created
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20130815 - LS - bug fix, fn_GetOutletDomainKeys should have been fn_GetDomainKeys
                20140715 - LS - F 21325, use transaction, other session will not see data gets deleted until after it's replaced (intraday refresh)
				20160321 - LT - Penguin 18.0, added US Penguin instance
*************************************************************************************************************************************/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penPaymentAllocationAdjustment') is not null
        drop table etl_penPaymentAllocationAdjustment

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        left(PrefixKey + convert(varchar, p.PaymentAllocationAdjustmentID), 41) as PaymentAllocationAdjustmentKey,
        left(PrefixKey + convert(varchar, p.PaymentAllocationID), 41) as PaymentAllocationKey,
        p.PaymentAllocationAdjustmentID,
        p.PaymentAllocationID,
        p.Amount,
        p.AdjustmentType,
        p.Comments
    into etl_penPaymentAllocationAdjustment
    from
        dbo.penguin_tblPaymentAllocation_aucm pa
        inner join dbo.penguin_tblPaymentAllocationAdjustment_aucm p on
            pa.PaymentAllocationID = p.PaymentAllocationID
        inner join dbo.penguin_tblOutlet_aucm o on
            pa.OutletID = o.OutletID
        cross apply dbo.fn_GetDomainKeys(o.DomainID, 'CM', 'AU') dk

 


    if object_id('[db-au-cba].dbo.penPaymentAllocationAdjustment') is null
    begin

        create table [db-au-cba].[dbo].penPaymentAllocationAdjustment
        (
            [CountryKey] [varchar](2) null,
            [CompanyKey] [varchar](5) null,
            [DomainKey] [varchar](41) null,
            [PaymentAllocationAdjustmentKey] [varchar](41) null,
            [PaymentAllocationKey] [varchar](41) null,
            [PaymentAllocationAdjustmentID] [int] not null,
            [PaymentAllocationID] [int] not null,
            [Amount] [money] not null,
            [AdjustmentType] [varchar](30) not null,
            [Comments] [varchar](255) null
        )

        create clustered index idx_penPaymentAllocationAdjustment_PaymentAllocationKey on [db-au-cba].dbo.penPaymentAllocationAdjustment(PaymentAllocationAdjustmentKey)
        create index idx_penPaymentAllocationAdjustment_CountryKey on [db-au-cba].dbo.penPaymentAllocationAdjustment(CountryKey)
        create index idx_penPaymentAllocationAdjustment_OutletKey on [db-au-cba].dbo.penPaymentAllocationAdjustment(PaymentAllocationKey)
    end
    
    
    begin transaction penPaymentAllocationAdjustment
    
    begin try

        delete a
        from
            [db-au-cba].dbo.penPaymentAllocationAdjustment a
            inner join etl_penPaymentAllocationAdjustment b on
                a.PaymentAllocationAdjustmentKey = b.PaymentAllocationAdjustmentKey

        insert [db-au-cba].dbo.penPaymentAllocationAdjustment with(tablockx)
        (
            [CountryKey],
            [CompanyKey],
            [DomainKey],
            [PaymentAllocationAdjustmentKey],
            [PaymentAllocationKey],
            [PaymentAllocationAdjustmentID],
            [PaymentAllocationID],
            [Amount],
            [AdjustmentType],
            [Comments]
        )
        select
            [CountryKey],
            [CompanyKey],
            [DomainKey],
            [PaymentAllocationAdjustmentKey],
            [PaymentAllocationKey],
            [PaymentAllocationAdjustmentID],
            [PaymentAllocationID],
            [Amount],
            [AdjustmentType],
            [Comments]
        from
            etl_penPaymentAllocationAdjustment

    end try
    
    begin catch
    
        if @@trancount > 0
            rollback transaction penPaymentAllocationAdjustment
            
        exec syssp_genericerrorhandler 'penPaymentAllocationAdjustment data refresh failed'
        
    end catch    

    if @@trancount > 0
        commit transaction penPaymentAllocationAdjustment

end


GO
