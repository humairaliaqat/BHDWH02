USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL113_factQuoteSummaryBot]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--create
CREATE 
procedure [dbo].[etlsp_ETL113_factQuoteSummaryBot]
    @DateRange varchar(30),
    @StartDate varchar(10),
    @EndDate varchar(10)
    
as
begin


--2016-02-01, LS, merge Impulse 2.0, use new bot tables
--2016-02-03, LS, WTF!!!! copy paste error, should've been @rptStartDate instead of @start
--2016-02-16, LS, another WTF moment. not sure why the change on 20150831 in main penQuoteSummary wasn't replicated here
--2016-06-22, LS, include Lead Time (T25480)
--2018-06-01, LT, Removed Impulse2 Version1 quote source, and added Impulse2 Version2 quote source
--2019-01-24, RS, Quote processing happens in GCP now. utilizing the data downloaded from GCP for dimensional/cube processing.
--2019-11-19, RS, Moved the proc to azsyddwh02.

--uncomment to debug
/*
declare @DateRange varchar(30)
declare @StartDate varchar(10)
declare @EndDate varchar(10)
select 
    @DateRange = '_User Defined', 
    @StartDate = '2018-02-01', 
    @EndDate = '2018-03-31'
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

    

    if object_id('[db-au-stage].dbo.etl_factQuoteSummaryBotTemp') is not null 
        drop table [db-au-stage].dbo.etl_factQuoteSummaryBotTemp
        
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
        -sum(QuoteSessionCount) QuoteSessionCount,
        -sum(QuoteCount) QuoteCount,
        -sum(QuoteWithPriceCount) QuoteWithPriceCount,
        -sum(SavedQuoteCount) SavedQuoteCount,
        -sum(ConvertedCount) ConvertedCount,
        -sum(ExpoQuoteCount) ExpoQuoteCount,
        -sum(AgentSpecialQuoteCount) AgentSpecialQuoteCount,
        -sum(PromoQuoteCount) PromoQuoteCount,
        -sum(UpsellQuoteCount) UpsellQuoteCount,
        -sum(PriceBeatQuoteCount) PriceBeatQuoteCount,
        -sum(QuoteRenewalCount) QuoteRenewalCount,
        -sum(CancellationQuoteCount) CancellationQuoteCount,
        -sum(LuggageQuoteCount) LuggageQuoteCount,
        -sum(MotorcycleQuoteCount) MotorcycleQuoteCount,
        -sum(WinterQuoteCount) WinterQuoteCount,
        -sum(EMCQuoteCount) EMCQuoteCount
    into [db-au-stage].dbo.etl_factQuoteSummaryBotTemp
    from
        etl_penQuoteSummaryBot qs
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



    --create factQuoteSummaryBot if table does not exist
    if object_id('[db-au-star].dbo.factQuoteSummaryBot') is null
    begin
    
        create table [db-au-star].dbo.factQuoteSummaryBot
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
        
        create clustered index idx_factQuoteSummaryBot_BIRowID on [db-au-star].dbo.factQuoteSummaryBot(BIRowID)
        create nonclustered index idx_factQuoteSummaryBot_DateSK on [db-au-star].dbo.factQuoteSummaryBot(DateSK) include(DomainSK)
        create nonclustered index idx_factQuoteSummaryBot_DomainSK on [db-au-star].dbo.factQuoteSummaryBot(DomainSK)
        create nonclustered index idx_factQuoteSummaryBot_OutletSK on [db-au-star].dbo.factQuoteSummaryBot(OutletSK)
        create nonclustered index idx_factQuoteSummaryBot_ConsultantSK on [db-au-star].dbo.factQuoteSummaryBot(ConsultantSK) include(OutletSK,DateSK)
        create nonclustered index idx_factQuoteSummaryBot_AreaSK on [db-au-star].dbo.factQuoteSummaryBot(AreaSK)
        create nonclustered index idx_factQuoteSummaryBot_DestinationSK on [db-au-star].dbo.factQuoteSummaryBot(DestinationSK)
        create nonclustered index idx_factQuoteSummaryBot_DurationSK on [db-au-star].dbo.factQuoteSummaryBot(DurationSK)
        create nonclustered index idx_factQuoteSummaryBot_AgeBandSK on [db-au-star].dbo.factQuoteSummaryBot(AgeBandSK)
        create nonclustered index idx_factQuoteSummaryBot_ProductSK on [db-au-star].dbo.factQuoteSummaryBot(ProductSK)
        create nonclustered index idx_factQuoteSummaryBot_LeadTime on [db-au-star].dbo.factQuoteSummaryBot(LeadTime)
        
    end
    
    select
        @sourcecount = count(*)
    from
        [db-au-stage].dbo.etl_factQuoteSummaryBotTemp

    begin transaction
    begin try

        delete [db-au-star].dbo.factQuoteSummaryBot
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

        insert into [db-au-star].dbo.factQuoteSummaryBot with (tablockx)
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
            -1 as LoadID,
            null as updateDate,
            null as updateID
        from
            [db-au-stage].dbo.etl_factQuoteSummaryBotTemp
                
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
