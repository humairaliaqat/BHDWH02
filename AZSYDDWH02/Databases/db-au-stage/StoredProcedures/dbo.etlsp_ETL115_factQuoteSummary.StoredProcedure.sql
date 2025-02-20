USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL115_factQuoteSummary]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--create
CREATE 
procedure [dbo].[etlsp_ETL115_factQuoteSummary]    
    @DateRange varchar(30),
    @StartDate varchar(10),
    @EndDate varchar(10)
    
as
begin

/************************************************************************************************************************************
Author:         Linus Tor
Date:           20131115
Prerequisite:   Requires Penguin Data Model ETL successfully run.
                Requires [db-au-cba].dbo.penQuoteSummary table available
Description:    factQuoteSummary dimension table contains Quote summary attributes.
Parameters:     @DateRange:     Required. Standard date range or _User Defined
                @StartDate:     Required if _User Defined. Format YYYY-MM-DD eg. 2013-01-01
                @EndDate:       Required if _User Defined. Format YYYY-MM-DD eg. 2013-01-01
Change History:
                20141010 - LS - Procedure created
                20141111 - LS - optimise
                20141121 - LS - bug fix, consultant sk
                                find exact match first before using derived key
                20150204 - LS - replace batch codes with standard batch logging
                20160622 - LS - include Lead Time (T25480)
				20190319 - RS - Customised for CBA reporting.
				20191119 - RS - Moving the proc to azsysdwh02.
                                
*************************************************************************************************************************************/

--uncomment to debug
/*
declare @DateRange varchar(30)
declare @StartDate varchar(10)
declare @EndDate varchar(10)
select 
    @DateRange = '_User Defined', 
    @StartDate = null,
    @EndDate = null
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
            @SubjectArea = 'CDG Quote Bigquery',
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


   /* if object_id('tempdb..#penQuoteSummary') is not null 
        drop table #penQuoteSummary
        
    select 
        QuoteDate,
        CountryKey,
        OutletAlphaKey,
        UserKey,
        CRMUserKey,
        Area,
        Destination,
        Duration,
        LeadTime,
        PrimaryCustomerAge,
        ProductKey,
        isnull(QuoteSessionCount,0) as QuoteSessionCount,
        QuoteCount,
        isnull(QuoteWithPriceCount,0) as QuoteWithPriceCount,
        SavedQuoteCount,
        ConvertedCount,
        ExpoQuoteCount,
        AgentSpecialQuoteCount,
        PromoQuoteCount,
        UpsellQuoteCount,
        PriceBeatQuoteCount,
        QuoteRenewalCount,
        CancellationQuoteCount,
        LuggageQuoteCount,
        MotorcycleQuoteCount,
        WinterQuoteCount,
        EMCQuoteCount
    into #penQuoteSummary
    from
        [db-au-cba].dbo.penQuoteSummary qs
    where
        qs.QuoteDate >= @rptStartDate and
        qs.QuoteDate <  dateadd(day, 1, @rptEndDate) and
        qs.QuoteDate <  convert(date, getdate())*/
		
    
    if object_id('[db-au-stage].dbo.etl_factQuoteSummaryTemp') is not null 
        drop table [db-au-stage].dbo.etl_factQuoteSummaryTemp
        
    select 
        dt.Date_SK DateSK,
        isnull(dom.DomainSK, -1) DomainSK,
        isnull(do.OutletSK, -1) OutletSK,
        isnull(econ.ConsultantSK, isnull(con.ConsultantSK, -1)) ConsultantSK,
        isnull(area.AreaSK, -1) AreaSK,
        isnull(dest.DestinationSK, -1) DestinationSK,
        isnull(duration.DurationSK, -1) DurationSK,
        isnull(LeadTime, -1) LeadTime,
        isnull(age.AgeBandSK, -1) AgeBandSK,
        isnull(product.ProductSK, -1) ProductSK,
        sum(QuoteSessionCount) QuoteSessionCount,
        sum(QuoteCount) QuoteCount,
        sum(QuoteWithPriceCount) QuoteWithPriceCount,
        sum(SavedQuoteCount) SavedQuoteCount,
        sum(ConvertedCount) ConvertedCount,
        sum(ExpoQuoteCount) ExpoQuoteCount,
        sum(AgentSpecialQuoteCount) AgentSpecialQuoteCount,
        sum(PromoQuoteCount) PromoQuoteCount,
        sum(UpsellQuoteCount) UpsellQuoteCount,
        sum(PriceBeatQuoteCount) PriceBeatQuoteCount,
        sum(QuoteRenewalCount) QuoteRenewalCount,
        sum(CancellationQuoteCount) CancellationQuoteCount,
        sum(LuggageQuoteCount) LuggageQuoteCount,
        sum(MotorcycleQuoteCount) MotorcycleQuoteCount,
        sum(WinterQuoteCount) WinterQuoteCount,
        sum(EMCQuoteCount) EMCQuoteCount
    into [db-au-stage].dbo.etl_factQuoteSummaryTemp
    from
        --#penQuoteSummary qs
		etl_penQuoteSummary qs
        cross apply
        (
            select top 1
                dt.Date_SK
            from
                [db-au-star].dbo.Dim_Date dt
            where
                dt.[Date] = convert(date, qs.QuoteDate)
        ) dt
        outer apply
        (
            select top 1
                dom.DomainSK,
                DomainID
            from
                [db-au-star].dbo.dimDomain dom
            where
                dom.CountryCode = qs.CountryKey
        ) dom
        outer apply
        (
            select top 1 
                o.OutletSK,
                o.AlphaCode
            from
                [db-au-star].dbo.dimOutlet o
            where
                o.OutletAlphaKey = qs.OutletAlphaKey and
                o.ValidStartDate <= qs.QuoteDate and
                o.ValidEndDate >= qs.QuoteDate
        ) do
        outer apply
        (
            select top 1 
                UserID ConsultantID
            from
                [db-au-cba]..penUser u
            where
                u.UserKey = qs.UserKey and
                u.UserStatus = 'Current'
        ) u
        outer apply
        (
            select top 1 
                UserName CRMUserName
            from
                [db-au-cba]..penCRMUser cu
            where
                cu.CRMUserKey = qs.CRMUserKey
        ) cu
        cross apply
        (
            select
                qs.CountryKey + isnull(do.AlphaCode, '') + isnull(convert(varchar, ConsultantID), isnull(CRMUserName, '')) DerivedConsultant
        ) dcon
        outer apply
        (
            select top 1
                con.ConsultantSK
            from
                [db-au-star].dbo.dimConsultant con
            where
                con.ConsultantKey = qs.UserKey
        ) econ
        outer apply
        (
            select top 1
                con.ConsultantSK
            from
                [db-au-star].dbo.dimConsultant con
            where
                con.ConsultantKey = DerivedConsultant
        ) con
        outer apply
        (
            select top 1
                area.AreaSK
            from
                [db-au-star].dbo.dimArea area
            where
                area.Country = qs.CountryKey and
                area.AreaName = qs.Area
        ) area
        outer apply
        (
            select top 1
                dest.DestinationSK
            from
                [db-au-star].dbo.dimDestination dest
            where
                dest.Destination = qs.Destination
            order by
                dest.DestinationSK desc
        ) dest
        outer apply
        (
            select top 1
                duration.DurationSK
            from
                [db-au-star].dbo.dimDuration duration
            where
                duration.Duration = qs.Duration
        ) duration
        outer apply
        (
            select top 1
                age.AgeBandSK
            from
                [db-au-star].dbo.dimAgeBand age
            where
                age.Age = qs.PrimaryCustomerAge
        ) age
        outer apply
        (
            select top 1
                product.ProductSK
            from
                [db-au-star].dbo.dimProduct product
            where
                product.ProductKey = qs.ProductKey
        ) product
    group by
        dt.Date_SK,
        isnull(dom.DomainSK, -1),
        isnull(do.OutletSK, -1),
        isnull(econ.ConsultantSK, isnull(con.ConsultantSK, -1)),
        isnull(area.AreaSK, -1),
        isnull(dest.DestinationSK, -1),
        isnull(duration.DurationSK, -1),
        isnull(LeadTime, -1),
        isnull(age.AgeBandSK, -1),
        isnull(product.ProductSK, -1)


    --create factQuoteSummary if table does not exist
    if object_id('[db-au-star].dbo.factQuoteSummary') is null
    begin
    
        create table [db-au-star].dbo.factQuoteSummary
        (
            BIRowID bigint not null identity(1,1),
            DateSK int not null,
            DomainSK int not null,
            OutletSK int not null,
            ConsultantSK int not null,
            AreaSK int not null,
            DestinationSK int not null,
            DurationSK int not null,
            LeadTime int not null default -1,
            AgeBandSK int not null,
            ProductSK int not null,
            QuoteSessionCount int not null default 0,
            QuoteCount int not null default 0,
            QuoteWithPriceCount int not null default 0,
            SavedQuoteCount int not null default 0,
            ConvertedCount int not null default 0,
            ExpoQuoteCount int not null default 0,
            AgentSpecialQuoteCount int not null default 0,
            PromoQuoteCount int not null default 0,
            UpsellQuoteCount int not null default 0,
            PriceBeatQuoteCount int not null default 0,
            QuoteRenewalCount int not null default 0,
            CancellationQuoteCount int not null default 0,
            LuggageQuoteCount int not null default 0,
            MotorcycleQuoteCount int not null default 0,
            WinterQuoteCount int not null default 0,
            EMCQuoteCount int not null default 0,
            LoadDate datetime not null,
            LoadID int not null,
            updateDate datetime null,
            updateID int null

        )
        
        create clustered index idx_factQuoteSummary_BIRowID on [db-au-star].dbo.factQuoteSummary(BIRowID)
        create nonclustered index idx_factQuoteSummary_DateSK on [db-au-star].dbo.factQuoteSummary(DateSK) include(DomainSK)
        create nonclustered index idx_factQuoteSummary_DomainSK on [db-au-star].dbo.factQuoteSummary(DomainSK)
        create nonclustered index idx_factQuoteSummary_OutletSK on [db-au-star].dbo.factQuoteSummary(OutletSK)
        create nonclustered index idx_factQuoteSummary_ConsultantSK on [db-au-star].dbo.factQuoteSummary(ConsultantSK) include(OutletSK,DateSK)
        create nonclustered index idx_factQuoteSummary_AreaSK on [db-au-star].dbo.factQuoteSummary(AreaSK)
        create nonclustered index idx_factQuoteSummary_DestinationSK on [db-au-star].dbo.factQuoteSummary(DestinationSK)
        create nonclustered index idx_factQuoteSummary_DurationSK on [db-au-star].dbo.factQuoteSummary(DurationSK)
        create nonclustered index idx_factQuoteSummary_AgeBandSK on [db-au-star].dbo.factQuoteSummary(AgeBandSK)
        create nonclustered index idx_factQuoteSummary_ProductSK on [db-au-star].dbo.factQuoteSummary(ProductSK)
        create nonclustered index idx_factQuoteSummary_LeadTime on [db-au-star].dbo.factQuoteSummary(LeadTime)
        
    end
    
    select
        @sourcecount = count(*)
    from
        [db-au-stage].dbo.etl_factQuoteSummaryTemp

    begin transaction
    begin try

        delete [db-au-star].dbo.factQuoteSummary
        where
            DateSK in
            (
                select 
                    dt.Date_SK
                from
                    [db-au-star].dbo.Dim_Date dt
                where
                    dt.[Date] >= @rptStartDate and
                    dt.[Date] <  dateadd(day, 1, @rptEndDate)

            )

        insert into [db-au-star].dbo.factQuoteSummary with (tablockx)
        (
            DateSK,
            DomainSK,
            OutletSK,
            ConsultantSK,
            AreaSK,
            DestinationSK,
            DurationSK,
            LeadTime,
            AgeBandSK,
            ProductSK,
            QuoteSessionCount,
            QuoteCount,
            QuoteWithPriceCount,
            SavedQuoteCount,
            ConvertedCount,
            ExpoQuoteCount,
            AgentSpecialQuoteCount,
            PromoQuoteCount,
            UpsellQuoteCount,
            PriceBeatQuoteCount,
            QuoteRenewalCount,
            CancellationQuoteCount,
            LuggageQuoteCount,
            MotorcycleQuoteCount,
            WinterQuoteCount,
            EMCQuoteCount,
            LoadDate,
            LoadID,
            updateDate,
            updateID
        )
        select
            DateSK,
            DomainSK,
            OutletSK,
            ConsultantSK,
            AreaSK,
            DestinationSK,
            DurationSK,
            LeadTime,
            AgeBandSK,
            ProductSK,
            QuoteSessionCount,
            QuoteCount,
            QuoteWithPriceCount,
            SavedQuoteCount,
            ConvertedCount,
            ExpoQuoteCount,
            AgentSpecialQuoteCount,
            PromoQuoteCount,
            UpsellQuoteCount,
            PriceBeatQuoteCount,
            QuoteRenewalCount,
            CancellationQuoteCount,
            LuggageQuoteCount,
            MotorcycleQuoteCount,
            WinterQuoteCount,
            EMCQuoteCount,
            getdate() as LoadDate,
            @batchid as LoadID,
            null as updateDate,
            null as updateID
        from
            [db-au-stage].dbo.etl_factQuoteSummaryTemp
                
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
