USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL032_dimDemography]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_ETL032_dimDemography]
    @StartDate date,
    @EndDate date

as
begin

--20170706, LL, create

    set nocount on

    declare
        @batchid int,
        @start date,
        @end date,
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

    end try

    begin catch

        --or manually

        set @batchid = -1

        --get date range
        set @start = @StartDate
        set @end = @EndDate

    end catch


    --create dimDemography if table does not exist
    if object_id('[db-au-star].dbo.dimDemography') is null
    begin

        create table [db-au-star].dbo.dimDemography
        (
            DemographySK int identity(1,1) not null,
            PolicySK bigint,
            PolicyKey varchar(41),
            CustomerID bigint,
            RiskProfile varchar(50),
            EmailDomain nvarchar(255),
            AgeGroup varchar(50),
            ProductPreference varchar(50),
            ChannelPreference varchar(50),
            BrandAffiliation varchar(50),
            TravelPattern varchar(50),
            TravelGroup varchar(50),
            DestinationGroup varchar(50),
            LocationProfile varchar(50),
            OwnershipProfile varchar(50),
            SuburbRank decimal,
            Suburb nvarchar(50),
            PostCode nvarchar(50),
            State nvarchar(100),
            UpdateBatchID bigint
        )

        create unique clustered index idx_dimDemography_DemographySK on [db-au-star].dbo.dimDemography(DemographySK)
        create nonclustered index idx_dimDemography_PolicyKey on [db-au-star].dbo.dimDemography(PolicyKey)
        create nonclustered index idx_dimDemography_CustomerID on [db-au-star].dbo.dimDemography(CustomerID)

        set identity_insert [db-au-star].dbo.dimDemography on

        --populate dimension with default unknown values
        insert [db-au-star].[dbo].[dimDemography]
        (
            DemographySK,
            PolicySK,
            PolicyKey,
            CustomerID,
            RiskProfile,
            EmailDomain,
            AgeGroup,
            ProductPreference,
            ChannelPreference,
            BrandAffiliation,
            TravelPattern,
            TravelGroup,
            DestinationGroup,
            LocationProfile,
            OwnershipProfile,
            SuburbRank,
            Suburb,
            PostCode,
            State,
            UpdateBatchID
        )
        select
            -1 DemographySK,
            -1 PolicySK,
            'UNKNOWN' PolicyKey,
            -1 CustomerID,
            'UNKNOWN' RiskProfile,
            'UNKNOWN' EmailDomain,
            'UNKNOWN' AgeGroup,
            'UNKNOWN' ProductPreference,
            'UNKNOWN' ChannelPreference,
            'UNKNOWN' BrandAffiliation,
            'UNKNOWN' TravelPattern,
            'UNKNOWN' TravelGroup,
            'UNKNOWN' DestinationGroup,
            'UNKNOWN' LocationProfile,
            'UNKNOWN' OwnershipProfile,
            0 SuburbRank,
            'UNKNOWN' Suburb,
            'UNKNOWN' PostCode,
            'UNKNOWN' State,
            -1 UpdateBatchID

        set identity_insert [db-au-star].dbo.dimDemography off

    end

--select
--    COLUMN_NAME + ' ' + DATA_TYPE + isnull('(' + convert(varchar, CHARACTER_MAXIMUM_LENGTH) + ')', '') + ',',
--    COLUMN_NAME + ','
--from
--    tempdb.INFORMATION_SCHEMA.COLUMNS
--where
--    TABLE_NAME like '#temop%'

    if object_id('tempdb..#dimDemography') is not null
        drop table dimDemography

    select 
        dp.PolicySK,
        dp.PolicyKey,
        ec.CustomerID,
        ecd.RiskProfile,
        lower(right(ec.CurrentEmail, len(ec.CurrentEmail) - charindex('@', ec.CurrentEmail))) EmailDomain,
        ecd.AgeGroup,
        ecd.ProductPreference,
        ecd.ChannelPreference,
        ecd.BrandAffiliation,
        ecd.TravelPattern,
        ecd.TravelGroup,
        ecd.DestinationGroup,
        ecd.LocationProfile,
        ecd.OwnershipProfile,
        ecd.SuburbRank,
        case
            when dp.Country not in ('AU', 'NZ') then 'UNKNOWN'
            when 
                not exists
                (
                    select
                        null
                    from
                        [db-au-cba]..usrsuburbprofile r
                    where
                        r.CountryDomain = dp.Country and
                        r.Suburb = ltrim(rtrim(clean.Suburb))
                ) then 'UNKNOWN'
            else ltrim(rtrim(clean.Suburb))
        end Suburb,
        case
            when dp.Country not in ('AU', 'NZ') then 'UNKNOWN'
            when 
                not exists
                (
                    select
                        null
                    from
                        [db-au-cba]..usrsuburbprofile r
                    where
                        r.CountryDomain = dp.Country and
                        r.PostCode = ltrim(rtrim(clean.PostCode))
                ) then 'UNKNOWN'
            else ltrim(rtrim(clean.PostCode))
        end PostCode,

        case
            when dp.Country not in ('AU', 'NZ') then 'UNKNOWN'
            when dp.Country = 'NZ' then 'NEW ZEALAND'
            when dp.Country = 'AU' and clean.State = 'NSW' then 'NEW SOUTH WALES'
            when dp.Country = 'AU' and clean.State = 'QLD' then 'QUEENSLAND'
            when dp.Country = 'AU' and clean.State = 'VIC' then 'VICTORIA'
            when dp.Country = 'AU' and clean.State = 'TAS' then 'TASMANIA'
            when dp.Country = 'AU' and clean.State = 'WA' then 'WESTERN AUSTRALIA'
            when dp.Country = 'AU' and clean.State = 'SA' then 'SOUTH AUSTRALIA'
            when dp.Country = 'AU' and clean.State = 'ACT' then 'AUSTRALIAN CAPITAL TERRITORY'
            when dp.Country = 'AU' and clean.State = 'NT' then 'NORTHERN TERRITORY'
            when 
                dp.Country = 'AU' and
                rtrim(ltrim(clean.State)) in
                (
                    'NEW SOUTH WALES',
                    'QUEENSLAND',
                    'VICTORIA',
                    'TASMANIA',
                    'WESTERN AUSTRALIA',
                    'SOUTH AUSTRALIA',
                    'AUSTRALIAN CAPITAL TERRITORY',
                    'NORTHERN TERRITORY'
                )
            then rtrim(ltrim(clean.State))
            else 'UNKNOWN'
        end State,
        -1 batchid
    into #dimDemography
    from
        [db-au-star]..dimPolicy dp with(nolock)
        outer apply
        (
            select top 1 
                ec.CustomerID
            from
                [db-au-cba]..entCustomer ec
                cross apply
                (
                    select
                        case when isnull(ec.FirstName, '') <> '' then 1 else 0 end +
                        case when ec.DOB is not null then 1 else 0 end +
                        case when isnull(ec.CurrentAddress, '') <> '' then 1 else 0 end +
                        case when isnull(ec.CurrentContact, '') <> '' then 1 else 0 end +
                        case when isnull(ec.CurrentEmail, '') <> '' then 1 else 0 end DataScore
                ) ds
                outer apply
                (
                    select
                        count(distinct ep.PolicyKey) PolicyRecordCount
                    from
                        [db-au-cba]..entPolicy ep
                    where
                        ep.CustomerID = ec.CustomerID
                ) ep
            where
                ec.CustomerID = ec.MergedTo and
                ec.CustomerID in
                (
                    select 
                        CustomerID
                    from
                        [db-au-cba]..entPolicy rep
                    where
                        rep.PolicyKey = dp.PolicyKey
                )
            order by
                ds.DataScore desc,
                ep.PolicyRecordCount desc
        ) cec
        left join [db-au-cba]..entCustomer ec on
            ec.CustomerID = cec.CustomerID
        left join [db-au-cba]..entCustomerDemography ecd on
            ecd.CustomerID = ec.CustomerID
        outer apply
        (
            select top 1
                ptv.Suburb,
                ptv.PostCode,
                ptv.State
            from
                [db-au-cba]..penPolicyTraveller ptv
            where
                ptv.PolicyKey = dp.PolicyKey and
                ptv.Suburb is not null
        ) ptv
        outer apply
        (
            select top 1 
                ea.Suburb,
                ea.PostCode,
                ea.State
            from    
                [db-au-cba]..entAddress ea
            where
                ea.CustomerID = ec.CustomerID
            order by
                ea.UpdateDate desc
        ) ea
        outer apply
        (
            select
                case
                    when isnull(ea.Suburb, '') = '' and isnull(ptv.Suburb, '') = '' then 'UNKNOWN'
                    when isnull(ea.Suburb, '') <> '' then upper(ea.Suburb)
                    else upper(ptv.Suburb)
                end Suburb,
                case
                    when isnull(ea.PostCode, '') = '' and isnull(ptv.PostCode, '') = '' then 'UNKNOWN'
                    when isnull(ea.PostCode, '') <> '' then upper(ea.PostCode)
                    else upper(ptv.PostCode)
                end PostCode,
                case
                    when isnull(ea.State, '') = '' and isnull(ptv.State, '') = '' then 'UNKNOWN'
                    when isnull(ea.State, '') <> '' then upper(ea.State)
                    else upper(ptv.State)
                end State
        ) clean
    where
        dp.PolicyKey in
        (
            select 
                pt.PolicyKey
            from
                [db-au-cba]..penPolicyTransSummary pt
            where
                pt.PostingDate >= @start and
                pt.PostingDate <  dateadd(day, 1, @end)
        ) 
        or
        dp.PolicyKey in
        (
            select 
                rep.PolicyKey
            from
                [db-au-cba]..entCustomer rec
                inner join [db-au-cba]..entPolicy rep on
                    rep.CustomerID = rec.CustomerID
            where
                rec.UpdateDate >= @start and
                rec.UpdateDate <  dateadd(day, 1, @end)
        )

    begin transaction
    begin try

        delete
        from
            [db-au-star].dbo.dimDemography
        where
            PolicyKey in
            (
                select
                    r.PolicyKey
                from
                    #dimDemography r
            )

        insert into [db-au-star].dbo.dimDemography
        (
            PolicySK,
            PolicyKey,
            CustomerID,
            RiskProfile,
            EmailDomain,
            AgeGroup,
            ProductPreference,
            ChannelPreference,
            BrandAffiliation,
            TravelPattern,
            TravelGroup,
            DestinationGroup,
            LocationProfile,
            OwnershipProfile,
            SuburbRank,
            Suburb,
            PostCode,
            State,
            UpdateBatchID
        )
        select
            PolicySK,
            PolicyKey,
            CustomerID,
            RiskProfile,
            EmailDomain,
            AgeGroup,
            ProductPreference,
            ChannelPreference,
            BrandAffiliation,
            TravelPattern,
            TravelGroup,
            DestinationGroup,
            LocationProfile,
            OwnershipProfile,
            SuburbRank,
            Suburb,
            PostCode,
            State,
            @batchid UpdateBatchID
        from
            #dimDemography 

        if @batchid <> -1
            exec syssp_genericerrorhandler
                @LogToTable = 1,
                @ErrorCode = '0',
                @BatchID = @batchid,
                @PackageID = @name,
                @LogStatus = 'Finished',
                @LogSourceCount = @sourcecount,
                @LogInsertCount = @insertcount,
                @LogUpdateCount = @updatecount

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        if @batchid <> -1
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
