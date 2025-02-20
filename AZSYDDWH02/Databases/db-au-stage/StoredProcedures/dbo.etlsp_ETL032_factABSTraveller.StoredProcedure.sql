USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL032_factABSTraveller]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_ETL032_factABSTraveller] 
    @DateRange varchar(30),
    @StartDate varchar(10),
    @EndDate varchar(10)
    
as
begin


/************************************************************************************************************************************
Author:         Philip Wong
Date:           20140715
Prerequisite:   Requires Penguin Data Model ETL successfully run.
                Requires [db-au-cba].[dbo].[usrABSData] table available
Description:    factABSTraveller fact table contains ABS Traveller attributes.
Parameters:     @DateRange:    Required. Standard date range or _User Defined
                @StartDate:    Required if _User Defined. Format YYYY-MM-DD eg. 2013-01-01
                @EndDate:    Required if _User Defined. Format YYYY-MM-DD eg. 2013-01-01
Change History:
                20140715 - PW - Procedure created
                20140905 - LS - refactoring
                20150204 - LS - replace batch codes with standard batch logging
				20151013 - LT - Added FriendsRelativesCount and HolidayCount metrics to factABSTraveller table
				20160113 - LT - Fixed batch run date range to run from 01/07/2010 to 31/12/2999

*************************************************************************************************************************************/

--uncomment to debug
/*
declare @DateRange varchar(30)
declare @StartDate varchar(10)
declare @EndDate varchar(10)
select @DateRange = '_User Defined', @StartDate = '2011-01-01', @EndDate = '2015-09-30'
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

        --select 
        --    @rptStartDate = @start, 
        --    @rptEndDate = @end

		--LT 20160113 - override running batch date range. Previously the ETL was not updating due to date range out of scope.
        select 
            @rptStartDate = '2011-07-01', 
            @rptEndDate = '2999-12-31'



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


    if object_id('[db-au-stage].dbo.etl_factABSTravellerTemp') is not null 
        drop table [db-au-stage].dbo.etl_factABSTravellerTemp;
        
    select
        [Month] TravelDate
        ,[DurationGroup]
        ,[AgeGroup]
        ,[Country]
        ,[Reason]
        ,[TravellersCount]
    into [db-au-stage].dbo.etl_factABSTravellerTemp
    from [db-au-cba].[dbo].[usrABSData] a
    where
        a.Month between @rptStartDate and @rptEndDate

    -- update Concatenated Countries

    update [db-au-stage].dbo.etl_factABSTravellerTemp
    set Country = 'United States of America'
    where Country = 'USA'

    update [db-au-stage].dbo.etl_factABSTravellerTemp
    set Country = 'South Korea'
    where Country = 'Korea, South'

    update [db-au-stage].dbo.etl_factABSTravellerTemp
    set Country = 'United Arab Emirates'
    where Country = 'Unit Arab Emir'

    update [db-au-stage].dbo.etl_factABSTravellerTemp
    set Country = 'French Polynesia'
    where Country = 'French Poly'

    update [db-au-stage].dbo.etl_factABSTravellerTemp
    set Country = 'Papua New Guinea'
    where Country = 'PNG'


    if object_id('[db-au-stage].dbo.etl_factABSTraveller') is not null drop table [db-au-stage].dbo.etl_factABSTraveller;
    SELECT
        dt.Date_SK as DateSK,
        isnull(dom.DomainSK,-1) as DomainSK,
        isnull(age.AgeBandSK,-1) as AgeBandSK,
        isnull(dest.DestinationSK,-1) as DestinationSK,
        isnull(duration.DurationSK,-1) as DurationSK,
        CASE WHEN ltrim(rtrim(a.Reason)) <> 'Other reasons' then a.TravellersCount ELSE 0 END LeisureTravellerCount,
        CASE WHEN ltrim(rtrim(a.Reason)) = 'Other reasons' then a.TravellersCount ELSE 0 END NonLeisureTravellerCount,
		case when ltrim(rtrim(a.Reason)) = 'Visiting friends/relatives' then a.TravellersCount else 0 end FriendRelativeCount,
		case when ltrim(rtrim(a.Reason)) = 'Holiday' then a.TravellersCount else 0 end as HolidayCount
    into [db-au-stage].dbo.etl_factABSTraveller
    FROM 
        [db-au-stage].dbo.etl_factABSTravellerTemp a
		outer apply
		(
			select top 1 Date_SK
			from [db-au-star].dbo.Dim_Date dt
			where a.TravelDate = dt.[Date]
		) dt
		outer apply
		(
			select top 1 DestinationSK
			from [db-au-star].dbo.dimDestination dest
			where a.Country = dest.Destination
            order by
                dest.DestinationSK desc
		) dest
		outer apply
		(
			select top 1 DomainSK
			from [db-au-star].dbo.dimDomain dom
			where 7 = dom.DomainID -- Assume ABS is AU
		) dom
		outer apply
		(
			select top 1 AgeBandSK
			from [db-au-star].dbo.dimAgeBand age
			where RIGHT(ltrim(rtrim(a.AgeGroup)),2) = age.Age
		) age
		outer apply
		(
			select top 1 DurationSK
			from [db-au-star].dbo.dimDuration duration
			where duration.Duration = CASE a.DurationGroup
				 WHEN '1 - 2mths' then 60
				 WHEN '1 - 2wks' then 14
				 WHEN '2 - 3mths' then 90
				 WHEN '2 - 4wks' then 28
				 WHEN '3 - 6mths' then 180
				 WHEN '6 - 12mths' then 365
				 WHEN 'Under 1wk' then 7
				 ELSE -1
			  END
		) duration

    --create factABSTraveller if table does not exist
    if object_id('[db-au-star].dbo.factABSTraveller') is null
    begin
        create table [db-au-star].dbo.factABSTraveller
        (
            DateSK int not null,
            DomainSK int not null,
            DestinationSK int not null,
            DurationSK int not null,
            AgeBandSK int not null,
            LeisureTravellerCount int not null,
            NonLeisureTravellerCount int not null,
			FriendRelativeCount int not null,
			HolidayCount int not null,
            LoadDate datetime not null,
            LoadID int not null,
            updateDate datetime null,
            updateID int null
        )
        create clustered index idx_factABSTraveller_DateSK on [db-au-star].dbo.factABSTraveller(DateSK)
        create nonclustered index idx_factABSTraveller_DomainSK on [db-au-star].dbo.factABSTraveller(DomainSK)
        create nonclustered index idx_factABSTraveller_DestinationSK on [db-au-star].dbo.factABSTraveller(DestinationSK)
        create nonclustered index idx_factABSTraveller_DurationSK on [db-au-star].dbo.factABSTraveller(DurationSK)
        create nonclustered index idx_factABSTraveller_AgeBandSK on [db-au-star].dbo.factABSTraveller(AgeBandSK)

    end


    select
        @sourcecount = count(*)
    from
        [db-au-stage].dbo.etl_factABSTraveller

    begin transaction
    begin try

        delete [db-au-star].dbo.factABSTraveller
        from
            [db-au-star].dbo.factABSTraveller b
            join [db-au-stage].dbo.etl_factABSTraveller a on
                b.DateSK = a.DateSK and
                b.DomainSK = a.DomainSK

        insert into [db-au-star].dbo.factABSTraveller with (tablockx)
        (
            DateSK,
            DomainSK,
            DestinationSK,
            DurationSK,
            AgeBandSK,
            LeisureTravellerCount,
            NonLeisureTravellerCount,
			FriendRelativeCount,
			HolidayCount,
            LoadDate,
            LoadID,
            updateDate,
            updateID
        )
        select
            DateSK,
            DomainSK,
            DestinationSK,
            DurationSK,
            AgeBandSK,
            LeisureTravellerCount,
            NonLeisureTravellerCount,
			FriendRelativeCount,
			HolidayCount,
            getdate() as LoadDate,
            @batchid as LoadID,
            null as updateDate,
            null as updateID
        from
            [db-au-stage].dbo.etl_factABSTraveller
        
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
