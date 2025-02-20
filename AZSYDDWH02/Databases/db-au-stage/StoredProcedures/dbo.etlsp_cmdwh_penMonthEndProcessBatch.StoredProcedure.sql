USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penMonthEndProcessBatch]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_penMonthEndProcessBatch]
as
begin
/************************************************************************************************************************************
Author:         Leo
Date:           20130905
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    
Change History:
				20160321 - LT - Penguin 18.0, added US penguin instance

*************************************************************************************************************************************/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penMonthEndProcessBatch') is not null 
        drop table etl_penMonthEndProcessBatch
        
    select 
        CountryKey,
        CompanyKey,
        DomainKey,
        left(PrefixKey + convert(varchar, MonthEndProcessBatchId), 41) as BatchKey,
        left(PrefixKey + convert(varchar, CRMUserID), 41) as CRMUserKey,
        b.DomainID,
        MonthEndProcessBatchId BatchID,
        CRMUserID,
        b.PaymentTypeID,
        b.PaymentProcessAgentId AgentID,
        dbo.xfn_ConvertUTCtoLocal(CreateDateTime, dk.TimeZone) CreateDateTime,
        dbo.xfn_ConvertUTCtoLocal(UpdateDateTime, dk.TimeZone) UpdateDateTime,
        AccountingPeriod,
        b.Status BatchStatus,
        pt.Name PaymentType,
        ppa.Name PaymentProcessAgent,
        JobType
    into etl_penMonthEndProcessBatch
    from
        penguin_tblMonthEndProcessBatch_aucm b
        cross apply dbo.fn_GetDomainKeys(b.DomainID, 'CM', 'AU') dk
        left join penguin_tblPaymentType_aucm pt on 
            pt.PaymentTypeId = b.PaymentTypeId
        left join penguin_tblPaymentProcessAgent_aucm ppa on
            ppa.PaymentProcessAgentId = b.PaymentProcessAgentId
            
   


    if object_id('[db-au-cba].dbo.penMonthEndProcessBatch') is null
    begin
    
        create table [db-au-cba].[dbo].penMonthEndProcessBatch
        (
            CountryKey varchar(2) not null,
            CompanyKey varchar(5) not null,
            DomainKey varchar(41) not null,
            BatchKey varchar(41) not null,
            CRMUserKey varchar(41) null,
            DomainID int,
            BatchID int,
            CRMUserID int,
            PaymentTypeID int,
            AgentID int,
            CreateDateTime datetime,
            UpdateDateTime datetime,
            AccountingPeriod date,
            BatchStatus varchar(15),
            PaymentType varchar(55),
            PaymentProcessAgent varchar(55),
            JobType varchar(15)
        )

        create clustered index idx_penMonthEndProcessBatch_BatchID on [db-au-cba].dbo.penMonthEndProcessBatch(BatchID)
        create index idx_penMonthEndProcessBatch_CountryKey on [db-au-cba].dbo.penMonthEndProcessBatch(CountryKey)
        create index idx_penMonthEndProcessBatch_CreateDateTime on [db-au-cba].dbo.penMonthEndProcessBatch(CreateDateTime)
        create index idx_penMonthEndProcessBatch_CMRUserKey on [db-au-cba].dbo.penMonthEndProcessBatch(CRMUserKey)
        
    end
    else
    begin
    
        delete a
        from
            [db-au-cba].dbo.penMonthEndProcessBatch a
            inner join etl_penMonthEndProcessBatch b on
                a.BatchKey = b.BatchKey
                
    end


    insert [db-au-cba].dbo.penMonthEndProcessBatch with(tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        BatchKey,
        CRMUserKey,
        DomainID,
        BatchID,
        CRMUserID,
        PaymentTypeID,
        AgentID,
        CreateDateTime,
        UpdateDateTime,
        AccountingPeriod,
        BatchStatus,
        PaymentType,
        PaymentProcessAgent,
        JobType
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        BatchKey,
        CRMUserKey,
        DomainID,
        BatchID,
        CRMUserID,
        PaymentTypeID,
        AgentID,
        CreateDateTime,
        UpdateDateTime,
        AccountingPeriod,
        BatchStatus,
        PaymentType,
        PaymentProcessAgent,
        JobType
    from
        etl_penMonthEndProcessBatch


    if object_id('etl_penMonthEndProcessBatchTransaction') is not null 
        drop table etl_penMonthEndProcessBatchTransaction
        
    select 
        CountryKey,
        CompanyKey,
        DomainKey,
        left(PrefixKey + convert(varchar, bt.MonthEndProcessBatchId), 41) as BatchKey,
        left(PrefixKey + convert(varchar, bt.MonthEndProcessBatchTransactionId), 41) as BatchTransactionKey,
        left(PrefixKey + convert(varchar, bt.PaymentAllocationId), 41) as PaymentAllocationKey,
        left(PrefixKey + convert(varchar, bt.OutletId), 41) as OutletKey,
        bt.MonthEndProcessBatchId BatchID,
        MonthEndProcessBatchTransactionId BatchTransactionID,
        PaymentAllocationID,
        bt.AlphaCode,
        dbo.xfn_ConvertUTCtoLocal(bt.CreateDateTime, dk.TimeZone) CreateDateTime,
        dbo.xfn_ConvertUTCtoLocal(bt.UpdateDateTime, dk.TimeZone) UpdateDateTime,
        bt.Amount,
        bt.AllocationAmount,
        bt.AmountType,
        bt.Email,
        bt.IsProcessed
    into etl_penMonthEndProcessBatchTransaction
    from
        penguin_tblMonthEndProcessBatchTransaction_aucm bt
        inner join penguin_tblMonthEndProcessBatch_aucm b on
            b.MonthEndProcessBatchId = bt.MonthEndProcessBatchId
        cross apply dbo.fn_GetDomainKeys(b.DomainID, 'CM', 'AU') dk
            
   


    if object_id('[db-au-cba].dbo.penMonthEndProcessBatchTransaction') is null
    begin
    
        create table [db-au-cba].[dbo].penMonthEndProcessBatchTransaction
        (
            CountryKey varchar(2) not null,
            CompanyKey varchar(5) not null,
            DomainKey varchar(41) not null,
            BatchKey varchar(41) not null,
            BatchTransactionKey varchar(41) not null,
            PaymentAllocationKey varchar(41) null,
            OutletKey varchar(41) not null,
            BatchID int,
            BatchTransactionID int,
            PaymentAllocationID int,
            AlphaCode varchar(20),
            CreateDateTime datetime,
            UpdateDateTime datetime,
            Amount money,
            AllocationAmount money,
            AmountType varchar(15),
            Email varchar(255),
            IsProcessed bit
        )

        create clustered index idx_penMonthEndProcessBatchTransaction_BatchTransactionID on [db-au-cba].dbo.penMonthEndProcessBatchTransaction(BatchTransactionID)
        create index idx_penMonthEndProcessBatchTransaction_CountryKey on [db-au-cba].dbo.penMonthEndProcessBatchTransaction(CountryKey)
        create index idx_penMonthEndProcessBatchTransaction_BatchKey on [db-au-cba].dbo.penMonthEndProcessBatchTransaction(BatchKey)
        create index idx_penMonthEndProcessBatchTransaction_BatchID on [db-au-cba].dbo.penMonthEndProcessBatchTransaction(BatchID)
        create index idx_penMonthEndProcessBatchTransaction_AlphaCode on [db-au-cba].dbo.penMonthEndProcessBatchTransaction(AlphaCode)
        create index idx_penMonthEndProcessBatchTransaction_CreateDateTime on [db-au-cba].dbo.penMonthEndProcessBatchTransaction(CreateDateTime)
        
    end
    else
    begin
    
        delete a
        from
            [db-au-cba].dbo.penMonthEndProcessBatchTransaction a
            inner join etl_penMonthEndProcessBatchTransaction b on
                a.BatchTransactionKey = b.BatchTransactionKey
                
    end


    insert [db-au-cba].dbo.penMonthEndProcessBatchTransaction with(tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        BatchKey,
        BatchTransactionKey,
        PaymentAllocationKey,
        OutletKey,
        BatchID,
        BatchTransactionID,
        PaymentAllocationID,
        AlphaCode,
        CreateDateTime,
        UpdateDateTime,
        Amount,
        AllocationAmount,
        AmountType,
        Email,
        IsProcessed
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        BatchKey,
        BatchTransactionKey,
        PaymentAllocationKey,
        OutletKey,
        BatchID,
        BatchTransactionID,
        PaymentAllocationID,
        AlphaCode,
        CreateDateTime,
        UpdateDateTime,
        Amount,
        AllocationAmount,
        AmountType,
        Email,
        IsProcessed
    from
        etl_penMonthEndProcessBatchTransaction

end


GO
