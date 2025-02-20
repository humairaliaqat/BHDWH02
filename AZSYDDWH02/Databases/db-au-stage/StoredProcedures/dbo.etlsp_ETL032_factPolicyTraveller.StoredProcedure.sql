USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL032_factPolicyTraveller]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_ETL032_factPolicyTraveller] 
    @DateRange varchar(30),
    @StartDate varchar(10),
    @EndDate varchar(10)

as
begin
/************************************************************************************************************************************
Author:         Linus Tor
Date:           20131115
Prerequisite:   Requires Penguin Data Model ETL successfully run.
                Requires [db-au-cba].dbo.penPolicyTransSummary table available
Description:    factPolicyTraveller dimension table contains Policy traveller attributes
Parameters:     @DateRange:     Required. Standard date range or _User Defined
                @StartDate:     Required if _User Defined. Format YYYY-MM-DD eg. 2013-01-01
                @EndDate:       Required if _User Defined. Format YYYY-MM-DD eg. 2013-01-01
Change History:
                20140717 - LT - Procedure created
                20150204 - LS - replace batch codes with standard batch logging

*************************************************************************************************************************************/

--uncomment to debug
/*
declare @DateRange varchar(30)
declare @StartDate varchar(10)
declare @EndDate varchar(10)
select @DateRange = '_User Defined', @StartDate = '2011-07-01', @EndDate = '2014-06-30'
*/

    set nocount on

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


    if object_id('[db-au-stage].dbo.etl_factPolicyTravellerTemp') is not null 
        drop table [db-au-stage].dbo.etl_factPolicyTravellerTemp;
        
    select
        pts.PolicyTransactionKey,
        pts.CountryKey as Country,
        pts.OutletAlphaKey,
        pol.AlphaCode,
        pol.DomainID,
        pol.PolicyKey,
        pol.PolicyNumber,
        case 
            when pol.CountryKey = 'AU' and pol.AreaType = 'Domestic (Inbound)' then 'Australia Inbound'
            when pol.CountryKey = 'NZ' and pol.AreaType = 'Domestic (Inbound)' then 'New Zealand Inbound'
            when pol.CountryKey = 'NZ' and pol.AreaType = 'Domestic' and pol.AreaName like 'New Zealand%' then 'New Zealand'
            when pol.CountryKey = 'MY' and pol.AreaType = 'Domestic' and pol.AreaName = 'Domestic' then 'Malaysia'
            when pol.CountryKey = 'UK' and pol.AreaType = 'Domestic' and pol.AreaName = 'Domestic Dummy' then 'United Kingdom'
            else pol.AreaName
        end as AreaName,
        pol.AreaType,
        pol.PrimaryCountry,
        isnull(pol.CountryKey,'') + '-' + isnull(pol.CompanyKey,'') + '' + convert(varchar,isnull(pol.DomainID,0)) + '-' + isnull(pol.ProductCode,'') + '-' + isnull(pol.ProductName,'') + '-' + isnull(pol.ProductDisplayName,'') + '-' + isnull(pp.PlanName,isnull(pol.PlanDisplayName,'')) as ProductKey,
        pol.ProductCode,
        pol.ProductName,
        pol.ProductDisplayName,
        pol.PlanID,
        pol.PlanName,
        pol.PlanDisplayName,
        pol.TripDuration,
        poltrav.PolicyTravellerKey as TravellerKey,
        poltrav.Age,
        pts.UserKey,
        (
            select top 1 
                isnull([Login],'UNKNOWN') as UserName 
            from 
                [db-au-cba].dbo.penUser 
            where 
                UserKey = pts.UserKey
        ) as UserName,
        pts.ConsultantID,
        pts.IssueDate,
        convert(date,pts.PostingDate) as PostingDate,
        convert(date,pol.TripStart) as TripDate,
        case
            when isnull(pol.isTripsPolicy,0) = 0 then
                case
                    when pts.TransactionType = 'Base' and pts.TransactionStatus = 'Active' then 1
                    when pts.TransactionType = 'Base' and pts.TransactionStatus like 'Cancelled%' then -1
                    else 0
                end
            else
                case
                    -- Assumes that where there are bulk travellers there will be matching travller records
                    when ABS(pts.TravellersCount) > 1 and pts.TransactionStatus = 'Active' then
                        CASE WHEN ABS(pts.TravellersCount) = poltravAgg.travellerAgg  then 1 ELSE pts.TravellersCount END
                    when ABS(pts.TravellersCount) > 1 and pts.TransactionStatus like 'Cancelled%' then
                        CASE WHEN ABS(pts.TravellersCount) = poltravAgg.travellerAgg  then -1 ELSE -1*ABS(pts.TravellersCount) END
                    ELSE isnull(pts.TravellersCount,0)
                end
        end as TravellersCount,
        CRMUserName
    into [db-au-stage].dbo.etl_factPolicyTravellerTemp
    from
        [db-au-cba].dbo.penPolicyTransSummary pts
        left join [db-au-cba].dbo.penPolicy pol on
            pts.PolicyKey = pol.PolicyKey
        left join [db-au-cba].dbo.penPolicyTraveller poltrav on
            pol.PolicyKey = poltrav.PolicyKey
        outer apply
        (
            select top 1 pp.PlanName
            from 
                [db-au-cba].dbo.penProductPlan pp
            where
                pol.CountryKey = pp.CountryKey and
                pol.CompanyKey = pp.CompanyKey and
                pol.ProductID = pp.ProductID and
                pol.UniquePLanID = pp.UniquePLanID
        ) pp
        outer apply
        (
            select count(1) travellerAgg
            from [db-au-cba].dbo.penPolicyTraveller poltrav
            where
            pol.PolicyKey = poltrav.PolicyKey
        ) poltravAgg
    where
        pts.PolicyTransactionKey <> 'AU-CM7-2540646' and
        pol.TripStart between @rptStartDate and @rptEndDate



    if object_id('[db-au-stage].dbo.etl_factPolicyTraveller') is not null drop table [db-au-stage].dbo.etl_factPolicyTraveller
    select
        dt.Date_SK as DateSK,
        isnull(dom.DomainSK,-1) as DomainSK,
        isnull(tr.TravellerSK,-1) as TravellerSK,
        isnull(o.OutletSK,-1) as OutletSK,
        isnull(pol.PolicySK,-1) as PolicySK,
        isnull(con.ConsultantSK, isnull(dcon.ConsultantSK, -1)) as ConsultantSK,
        isnull(area.AreaSK,-1) as AreaSK,
        isnull(dest.DestinationSK,-1) as DestinationSK,
        isnull(duration.DurationSK,-1) as DurationSK,
        isnull(product.ProductSK,-1) as ProductSK,
        isnull(age.AgeBandSK,-1) as AgeBandSK,
        pts.PolicyTransactionKey,
        pts.TravellersCount
    into [db-au-stage].dbo.etl_factPolicyTraveller
    from
        [db-au-stage].dbo.etl_factPolicyTravellerTemp pts
        cross apply
        (
            select 
                Country + isnull(AlphaCode, '') + isnull(convert(varchar, ConsultantID), isnull(CRMUserName, '')) DerivedConsultantKey
        ) dc
        outer apply
	    (
		    select top 1 Date_SK
		    from [db-au-star].dbo.Dim_Date dt
		    where pts.TripDate = dt.[Date]
	    ) dt
        outer apply
	    (
		    select top 1 TravellerSK
		    from [db-au-star].dbo.dimTraveller tr 
		    where pts.PolicyKey = tr.PolicyKey 
		    and pts.TravellerKey = tr.TravellerKey
	    ) tr    
        outer apply
	    (
		    select top 1 OutletSK
		    from [db-au-star].dbo.dimOutlet o
		    where isnull(pts.OutletAlphaKey,'') = o.OutletAlphaKey
            and pts.PostingDate between o.ValidStartDate and o.ValidEndDate
	    ) o     
        outer apply
	    (
		    select top 1 DomainSK
		    from [db-au-star].dbo.dimDomain dom
		    where pts.DomainID = dom.DomainID
	    ) dom
        outer apply
	    (
		    select top 1 PolicySK
		    from [db-au-star].dbo.dimPolicy pol
		    where pts.PolicyKey = pol.PolicyKey
	    ) pol
        outer apply
	    (
		    select top 1 ConsultantSK
		    from [db-au-star].dbo.dimConsultant con
		    where pts.UserKey = con.ConsultantKey
	    ) con
        outer apply
        (
            select top 1
                con.ConsultantSK
            from
                [db-au-star].dbo.dimConsultant con
            where
                con.ConsultantKey = dc.DerivedConsultantKey
        ) dcon
         outer apply
	    (
		    select top 1 AreaSK
		    from [db-au-star].dbo.dimArea area 
		    where pts.Country = area.Country
            and pts.AreaName = area.AreaName
            and pts.AreaType = area.AreaType
	    ) area       
        outer apply
	    (
		    select top 1 DestinationSK
		    from [db-au-star].dbo.dimDestination dest
		    where pts.PrimaryCountry = dest.Destination
            order by
                dest.DestinationSK desc
	    ) dest
        outer apply
	    (
		    select top 1 DurationSK
		    from [db-au-star].dbo.dimDuration duration
		    where pts.TripDuration = duration.Duration
	    ) duration
        outer apply
	    (
		    select top 1 ProductSK
		    from [db-au-star].dbo.dimProduct product
		    where pts.Country = product.Country
            and pts.ProductKey = product.ProductKey
	    ) product
        outer apply
	    (
		    select top 1 AgeBandSK
		    from [db-au-star].dbo.dimAgeBand age
		    where pts.Age = age.Age
	    ) age

    --create factPolicyTraveller if table does not exist
    if object_id('[db-au-star].dbo.factPolicyTraveller') is null
    begin
        create table [db-au-star].dbo.factPolicyTraveller
        (
            DateSK int not null,
            DomainSK int not null,
            TravellerSK int not null,
            OutletSK int not null,
            PolicySK int not null,
            AreaSK int not null,
            DestinationSK int not null,
            DurationSK int not null,
            ProductSK int not null,
            AgeBandSK int not null,
            PolicyTransactionKey nvarchar(50) null,
            TravellersCount int null,
            LoadDate datetime not null,
            LoadID int not null,
            updateDate datetime null,
            updateID int null
        )

        create clustered index idx_factPolicyTraveller_DateSK on [db-au-star].dbo.factPolicyTraveller(DateSK)
        create nonclustered index idx_factPolicyTraveller_DomainSK on [db-au-star].dbo.factPolicyTraveller(DomainSK)
        create nonclustered index idx_factPolicyTraveller_TravellerSK on [db-au-star].dbo.factPolicyTraveller(TravellerSK)
        create nonclustered index idx_factPolicyTraveller_OutletSK on [db-au-star].dbo.factPolicyTraveller(OutletSK)
        create nonclustered index idx_factPolicyTraveller_PolicySK on [db-au-star].dbo.factPolicyTraveller(PolicySK)
        create nonclustered index idx_factPolicyTraveller_AreaSK on [db-au-star].dbo.factPolicyTraveller(AreaSK)
        create nonclustered index idx_factPolicyTraveller_DestinationSK on [db-au-star].dbo.factPolicyTraveller(DestinationSK)
        create nonclustered index idx_factPolicyTraveller_DurationSK on [db-au-star].dbo.factPolicyTraveller(DurationSK)
        create nonclustered index idx_factPolicyTraveller_ProductSK on [db-au-star].dbo.factPolicyTraveller(ProductSK)
        create nonclustered index idx_factPolicyTraveller_AgeBandSK on [db-au-star].dbo.factPolicyTraveller(AgeBandSK)
    end
    
    
    select
        @sourcecount = count(*)
    from
        [db-au-stage].dbo.etl_factPolicyTraveller

    begin transaction
    begin try
    
        delete [db-au-star].dbo.factPolicyTraveller
        from
            [db-au-star].dbo.factPolicyTraveller b
            join [db-au-stage].dbo.etl_factPolicyTraveller a on
                b.DateSK = a.DateSK and
                b.DomainSK = a.DomainSK


        insert into [db-au-star].dbo.factPolicyTraveller with (tablockx)
        (
            DateSK,
            DomainSK,
            TravellerSK,
            OutletSK,
            PolicySK,
            AreaSK,
            DestinationSK,
            DurationSK,
            ProductSK,
            AgeBandSK,
            PolicyTransactionKey,
            TravellersCount,
            LoadDate,
            LoadID,
            updateDate,
            updateID
        )
        select
            DateSK,
            DomainSK,
            TravellerSK,
            OutletSK,
            PolicySK,
            AreaSK,
            DestinationSK,
            DurationSK,
            ProductSK,
            AgeBandSK,
            PolicyTransactionKey,
            TravellersCount,
            getdate() as LoadDate,
            @batchid as LoadID,
            null as updateDate,
            null as updateID
        from
            [db-au-stage].dbo.etl_factPolicyTraveller

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
