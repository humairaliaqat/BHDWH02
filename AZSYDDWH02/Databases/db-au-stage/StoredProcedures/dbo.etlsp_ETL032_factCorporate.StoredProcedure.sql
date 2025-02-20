USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL032_factCorporate]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_ETL032_factCorporate] 
    @DateRange varchar(30),
    @StartDate varchar(10),
    @EndDate varchar(10)
    
as
begin


/************************************************************************************************************************************
Author:         Linus Tor
Date:           20131115
Prerequisite:   Requires Penguin Data Model ETL successfully run.
                Requires corporate tables available in ODS
Description:    factCorporate table contains facts of corporate policies
Parameters:     @DateRange:     Required. Standard date range or _User Defined
                @StartDate:     Required if _User Defined. Format YYYY-MM-DD eg. 2013-01-01
                @EndDate:       Required if _User Defined. Format YYYY-MM-DD eg. 2013-01-01
Change History:
                20150109 - LT - Procedure created
                20150127 - LT - Added Quote Count measure
                20150217 - LS - F22720, incorrect commission definition: removed CM portion out of commission and commission gst
                                change end date to end of month to accomodate accounting period
                20160316 - LS - T22961
                                too many movements in corporate data with no trail, this causes policy cube to be misalligned to ODS
                                at the moment corporate data are small enough, i'm changing this to full load every run

                                SellPrice calculation was also wrong
                20180416 - LL - additional columns, preparing merge to factPolicyTransaction
                20180418 - LL - materialise additional date sks

*************************************************************************************************************************************/

--uncomment to debug
/*
declare @DateRange varchar(30)
declare @StartDate varchar(10)
declare @EndDate varchar(10)
select 
    @DateRange = '_User Defined', 
    @StartDate = '2011-07-01', 
    @EndDate = '2014-12-31'
*/

    set nocount on

    declare
        @batchid int,
        @start date,
        @end date,
        @rptStartDate date,
        @rptEndDate date,
        @name varchar(50),
        @sourcecount int,
        @insertcount int,
        @updatecount int

    declare @mergeoutput table (MergeAction varchar(20))

    select
        @name = object_name(@@procid)

    begin try
    
        --check if this is running on batch

        exec syssp_getrunningbatch
            @SubjectArea = 'Policy Star',
            @BatchID = @batchid out,
            @StartDate = @start out,
            @EndDate = @end out

        exec syssp_genericerrorhandler
            @LogToTable = 1,
            @ErrorCode = '0',
            @BatchID = @batchid,
            @PackageID = @name,
            @LogStatus = 'Running'

        select 
            @rptStartDate = @start, 
            @rptEndDate = @end

    end try
    
    begin catch
    
        --or manually
    
        set @batchid = -1

        --get date range
        if @DateRange = '_User Defined'
            select 
                @rptStartDate = @StartDate, 
                @rptEndDate = @EndDate
        else
            select 
                @rptStartDate = StartDate,
                @rptEndDate = EndDate
            from 
                [db-au-cba].dbo.vDateRange
            where 
                DateRange = @DateRange

    end catch

    set @rptEndDate = dateadd(day, -1, dateadd(month, 1, convert(varchar(8), @rptEndDate, 120) + '01'))

    if object_id('[db-au-stage].dbo.etl_factCorporate') is not null 
        drop table [db-au-stage].dbo.etl_factCorporate

    ;with
    cte_corporate as
        (        
        select
		    q.CountryKey Country,
            o.OutletKey,
		    q.QuoteKey,
		    q.PolicyKey,
            [db-au-cba].dbo.fn_GetUnderWriterCode('CM', q.CountryKey, o.AlphaCode, convert(date, q.IssuedDate)) UnderwriterCode,
            isnull
            (
                (
                    select top 1
                        DurationSK
                    from
                        [db-au-star]..dimDuration 
                    where
                        Duration = (datediff(day, q.PolicyStartDate, q.PolicyExpiryDate) + 1)
                ),
                -1
            ) DurationSK,
		    convert(date, convert(varchar(8), qt.AccountingPeriod, 120) + '01') [Date],
            convert(date, qt.AccountingPeriod) AccountingPeriod,
            convert(date, q.IssuedDate) IssueDate,
            q.PolicyNo PolicyNumber,
		    convert(date, q.PolicyStartDate) PolicyStartDate,
		    convert(date, q.PolicyExpiryDate) PolicyExpiryDate,
            isnull(q.Excess, 0) Excess,
            q.CountryKey + '-CM7-CMC-Corporate-Corporate-Corporate' ProductKey,
		    isnull(qt.UWSaleExGST, 0) - (isnull(qt.DomStamp, 0) + isnull(qt.IntStamp, 0)) Premium,
		    isnull(qt.UWSaleExGST, 0) + isnull(qt.GSTGross, 0) Sellprice,
		    isnull(qt.DomStamp, 0) + isnull(qt.IntStamp, 0) PremiumSD,
            isnull(qt.GSTGross, 0) PremiumGST,
            isnull(qt.AgtCommExGST, 0) + isnull(qt.GSTAgtComm, 0) Commission,
            isnull(qt.GSTAgtComm, 0) CommissionGST,
            (
                select
                    r.DateSK
                from
                    [db-au-star]..v_ic_dimGeneralDate r
                where
                    r.DateSK = q.PolicyStartDate
            ) DepartureDateSK,
            (
                select
                    r.DateSK
                from
                    [db-au-star]..v_ic_dimGeneralDate r
                where
                    r.DateSK = q.PolicyExpiryDate
            ) ReturnDateSK,
            (
                select
                    r.DateSK
                from
                    [db-au-star]..v_ic_dimGeneralDate r
                where
                    r.DateSK = q.IssuedDate
            ) IssueDateSK
        from
            [db-au-cba].dbo.corpQuotes q
            left join [db-au-cba].dbo.vcorpItems qi on 
			    qi.QuoteKey = q.QuoteKey
            left join [db-au-cba].dbo.corpTaxes qt on
			    qi.QuoteKey = qt.QuoteKey and 
			    qi.ItemID = qt.ItemID
            left join [db-au-cba].dbo.penOutlet o on
			    o.CountryKey = q.CountryKey and
			    o.AlphaCode = q.AgencyCode and
			    o.OutletStatus = 'Current'
        where
            qt.AccountingPeriod >= '2011-07-01'
    )
    select
        dt.Date_SK DateSK,
        isnull(dom.DomainSK, -1) DomainSK,
        isnull(o.OutletSK, -1) OutletSK,
        isnull(product.ProductSK, -1) ProductSK,
        q.DurationSK,
        q.UnderwriterCode,
        q.AccountingPeriod,
        q.IssueDate,
        q.QuoteKey,
        q.PolicyKey,
        q.PolicyNumber,
		q.PolicyStartDate,
		q.PolicyExpiryDate,        
		q.Excess,
		sum(q.Premium) Premium,
		sum(q.SellPrice) SellPrice,
		sum(q.PremiumSD) PremiumSD,
		sum(q.PremiumGST) PremiumGST,
		sum(q.Commission) Commission,
		sum(q.CommissionGST) CommissionGST,
		count(distinct PolicyKey) PolicyCount,
		count(distinct QuoteKey) QuoteCount,
        DepartureDateSK,
        ReturnDateSK,
        IssueDateSK
    into [db-au-stage].dbo.etl_factCorporate
    from
        cte_corporate q
        outer apply
        (
            select top 1
                dt.Date_SK
            from
                [db-au-star].dbo.Dim_Date dt
            where
                q.[Date] = dt.[Date]
        ) dt
        outer apply
        (
            select top 1
                o.OutletSK
            from
                [db-au-star].dbo.dimOutlet o
            where
				o.OutletKey = q.OutletKey and
                q.IssueDate >= o.ValidStartDate and 
                q.IssueDate <  dateadd(day, 1, o.ValidEndDate)
        ) o
        outer apply
        (
            select top 1
                dom.DomainSK
            from
                [db-au-star].dbo.dimDomain dom
            where
                dom.CountryCode = q.Country
        ) dom  
        outer apply
        (
            select top 1
                product.ProductSK
            from
                [db-au-star].dbo.dimProduct product
            where
                q.ProductKey = product.ProductKey
        ) product
    group by 
        dt.Date_SK,
        isnull(dom.DomainSK, -1),
        isnull(o.OutletSK, -1),
        isnull(product.ProductSK, -1),
        q.DurationSK,
        q.UnderwriterCode,
        q.AccountingPeriod,
        q.DepartureDateSK,
        q.ReturnDateSK,
        q.IssueDateSK,
        q.IssueDate,
        q.QuoteKey,
        q.PolicyKey,
        q.PolicyNumber,
		q.PolicyStartDate,
		q.PolicyExpiryDate,        
		q.Excess

    --create factCorporate if table does not exist
    if object_id('[db-au-star].dbo.factCorporate') is null
    begin
    
        create table [db-au-star].dbo.factCorporate
        (
            BIRowID bigint not null identity(1,1),
            DateSK int not null,
            DomainSK int not null,
            OutletSK int not null,
            ProductSK int not null,
            DurationSK int,
            UnderwriterCode varchar(100),
            AccountingPeriod datetime null,
            IssueDate datetime null,
            QuoteKey nvarchar(50) null,
            PolicyKey nvarchar(50) null,
            PolicyNumber varchar(50) null,
            PolicyStartDate datetime null,
            PolicyExpiryDate datetime null,
            Excess decimal(18,2) null,
            Premium float null,
            SellPrice float null,
            PremiumSD float null,
            PremiumGST float null,
            Commission float null,
            CommissionGST float null,
            PolicyCount int null,
            QuoteCount int null,
            LoadDate datetime not null,
            LoadID int not null,
            updateDate datetime null,
            updateID int null,
            DepartureDateSK date,
            ReturnDateSK date,
            IssueDateSK date
        )
        
        create clustered index idx_factCorporate_BIRowID on [db-au-star].dbo.factCorporate(BIRowID)
        create nonclustered index idx_factCorporate_DateSK on [db-au-star].dbo.factCorporate(DateSK) include (DomainSK)
        create nonclustered index idx_factCorporate_DomainSK on [db-au-star].dbo.factCorporate(DomainSK)
        create nonclustered index idx_factCorporate_OutletSK on [db-au-star].dbo.factCorporate(OutletSK)
        create nonclustered index idx_factCorporate_ProductSK on [db-au-star].dbo.factCorporate(ProductSK)
        create nonclustered index idx_factCorporate_AccountingPeriod on [db-au-star].dbo.factCorporate(AccountingPeriod)
        create nonclustered index idx_factCorporate_IssueDate on [db-au-star].dbo.factCorporate(IssueDate)      

    end
    

    select
        @sourcecount = count(*)
    from
        [db-au-stage].dbo.etl_factCorporate

    begin transaction
    begin try
    
        truncate table [db-au-star].dbo.factCorporate
        
        insert into [db-au-star].dbo.factCorporate with (tablockx)
        (
		    DateSK,
		    DomainSK,
		    OutletSK,
		    ProductSK,
            DurationSK,
            UnderwriterCode,
		    AccountingPeriod,
            DepartureDateSK,
            ReturnDateSK,
            IssueDateSK,
		    IssueDate,
		    QuoteKey,
		    PolicyKey,
		    PolicyNumber,
		    PolicyStartDate,
		    PolicyExpiryDate,
		    Excess,
		    Premium,
		    SellPrice,
		    PremiumSD,
		    PremiumGST,
		    Commission,
		    CommissionGST,
		    PolicyCount,
		    QuoteCount,
		    LoadDate,
		    LoadID,
		    updateDate,
		    updateID
        )
        select
		    DateSK,
		    DomainSK,
		    OutletSK,
		    ProductSK,
            DurationSK,
            UnderwriterCode,
		    AccountingPeriod,
            DepartureDateSK,
            ReturnDateSK,
            IssueDateSK,
		    IssueDate,
		    QuoteKey,
		    PolicyKey,
		    PolicyNumber,
		    PolicyStartDate,
		    PolicyExpiryDate,
		    Excess,
		    Premium,
		    SellPrice,
		    PremiumSD,
		    PremiumGST,
		    Commission,
		    CommissionGST,
		    PolicyCount,
		    QuoteCount,
            getdate() LoadDate,
            @batchid LoadID,
            null updateDate,
            null updateID
        from
            [db-au-stage].dbo.etl_factCorporate
                
        if @batchid <> - 1
            exec syssp_genericerrorhandler
                @LogToTable = 1,
                @ErrorCode = '0',
                @BatchID = @batchid,
                @PackageID = @name,
                @LogStatus = 'Finished',
                @LogSourceCount = @sourcecount

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        if @batchid <> - 1
            exec syssp_genericerrorhandler
                @SourceInfo = 'data refresh failed',
                @LogToTable = 1,
                @ErrorCode = '-100',
                @BatchID = @batchid,
                @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end

GO
