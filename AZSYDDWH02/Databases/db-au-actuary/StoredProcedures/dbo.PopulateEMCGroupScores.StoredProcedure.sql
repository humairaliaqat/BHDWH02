USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [dbo].[PopulateEMCGroupScores]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[PopulateEMCGroupScores]
    @StartDate date,
    @EndDate date

as
begin

    if object_id('[db-au-actuary].ws.EMCGroupScore') is null
    begin

        create table [db-au-actuary].ws.EMCGroupScore
        (
            BIRowID bigint not null identity(1,1),
            SourceSystem varchar(15),
            SourceKey varchar(100),
            [Max EMC Score] numeric(6,2) null,
            [Total EMC Score] numeric(6,2) null,
            [Max EMC Score No Filter] numeric(6,2) null,
            [Total EMC Score No Filter] numeric(6,2) null,
            constraint PK_EMCGroupScore primary key clustered (BIRowID)
        )

        create unique clustered index cidx on ws.EMCGroupScore(BIRowID)
        create nonclustered index idx on ws.EMCGroupScore(SourceKey,SourceSystem) include([Max EMC Score],[Total EMC Score],[Max EMC Score No Filter],[Total EMC Score No Filter])

    end

    if object_id('tempdb..#penguin') is not null
        drop table #penguin

    select 
        'Penguin' SourceSystem,
        p.PolicyKey SourceKey,
        es.[Max EMC Score],
        es.[Total EMC Score],
        esnf.[Max EMC Score No Filter],
        esnf.[Total EMC Score No Filter]
    into #penguin
    from
        [db-au-cba]..penPolicy p with(nolock)
        cross apply
        (
            select 
                max(e.MaxEMCScore) [Max EMC Score],
                sum(isnull(e.TotalEMCScore, 0)) [Total EMC Score]
            from
                [db-au-cba]..penPolicyTraveller ptv with(nolock)
                cross apply
                (
                    select 
                        --applicationid,
                        max(isnull(GroupScore, 0)) MaxEMCScore,
                        sum(isnull(GroupScore, 0)) TotalEMCScore
                    from
                        (
                            select distinct
                                mc.ApplicationID,
                                mc.GroupID,
                                mc.GroupScore
                            from
                                [db-au-cba]..penPolicyTravellerTransaction ptt with(nolock)
                                inner join [db-au-cba]..penPolicyEMC pe with(nolock) on
                                    pe.PolicyTravellerTransactionKey = ptt.PolicyTravellerTransactionKey
                                inner join [db-au-cba]..emcMedical mc with(nolock) on
                                    mc.ApplicationKey = pe.EMCApplicationKey
                            where
                                ptt.PolicyTravellerKey = ptv.PolicyTravellerKey and
                                mc.ConditionStatus = 'Approved' and
                                mc.GroupScore > 1.2
                                --this number is copied from sas program
                        ) eg
                    --group by
                    --    applicationid
                ) e
            where
                ptv.PolicyKey = p.PolicyKey        
        ) es
        cross apply
        (
            select 
                max(e.MaxEMCScore) [Max EMC Score No Filter],
                sum(isnull(e.TotalEMCScore, 0)) [Total EMC Score No Filter]
            from
                [db-au-cba]..penPolicyTraveller ptv with(nolock)
                cross apply
                (
                    select 
                        --applicationid,
                        max(isnull(GroupScore, 0)) MaxEMCScore,
                        sum(isnull(GroupScore, 0)) TotalEMCScore
                    from
                        (
                            select distinct
                                mc.ApplicationID,
                                mc.GroupID,
                                mc.GroupScore
                            from
                                [db-au-cba]..penPolicyTravellerTransaction ptt with(nolock)
                                inner join [db-au-cba]..penPolicyEMC pe with(nolock) on
                                    pe.PolicyTravellerTransactionKey = ptt.PolicyTravellerTransactionKey
                                inner join [db-au-cba]..emcMedical mc with(nolock) on
                                    mc.ApplicationKey = pe.EMCApplicationKey
                            where
                                ptt.PolicyTravellerKey = ptv.PolicyTravellerKey and
                                mc.ConditionStatus = 'Approved'
                        ) eg
                    --group by
                    --    applicationid
                ) e
            where
                ptv.PolicyKey = p.PolicyKey        
        ) esnf
    where
        isnull(p.isTripsPolicy, 0) = 0 and
        exists
        (
            select 
                null
            from
                [db-au-cba]..penPolicyTransSummary pt
            where
                pt.PolicyKey = p.PolicyKey and
                pt.PostingDate >= '2010-07-01' and
                pt.PostingDate >= @StartDate and
                pt.PostingDate <  dateadd(day, 1, @EndDate)
        ) and
        [Max EMC Score] is not null

    delete t
    from
        [db-au-actuary].ws.EMCGroupScore t
        inner join #penguin r on
            r.SourceKey = t.SourceKey and
            r.SourceSystem = t.SourceSystem

    insert into [db-au-actuary].ws.EMCGroupScore with(tablock)
    (
        SourceSystem,
        SourceKey,
        [Max EMC Score],
        [Total EMC Score],
        [Max EMC Score No Filter],
        [Total EMC Score No Filter]
    )
    select 
        SourceSystem,
        SourceKey,
        [Max EMC Score],
        [Total EMC Score],
        [Max EMC Score No Filter],
        [Total EMC Score No Filter]
    from
        #penguin


    if object_id('tempdb..#corporate') is not null
        drop table #corporate

    select 
        'Corporate' SourceSystem,
        q.QuoteKey SourceKey,
        es.[Max EMC Score],
        es.[Total EMC Score]
    into #corporate
    from
        [db-au-cba]..corpQuotes q with(nolock)
        outer apply
        (
            select 
                max(e.MaxEMCScore) [Max EMC Score],
                sum(isnull(e.TotalEMCScore, 0)) [Total EMC Score]
            from
                [db-au-cba].dbo.corpEMC ce with(nolock)
                cross apply
                (
                    select 
                        --applicationid,
                        max(isnull(GroupScore, 0)) MaxEMCScore,
                        sum(isnull(GroupScore, 0)) TotalEMCScore
                    from
                        (
                            select distinct
                                mc.ApplicationID,
                                mc.GroupID,
                                mc.GroupScore
                            from
                                [db-au-cba].dbo.emcMedical mc with(nolock)
                            where
                                mc.ApplicationKey = ce.CountryKey + '-' + ce.EMCApplicatioNo and
                                mc.ConditionStatus = 'Approved' and
                                mc.GroupScore > 1.2
                        ) eg
                    --group by
                    --    applicationid
                ) e
            where
                ce.QuoteKey = q.QuoteKey
        ) es
    where
        exists
        (
            select 
                null
            from
                [db-au-cba].dbo.corpEMC ce with(nolock)
            where
                ce.QuoteKey = q.QuoteKey
        ) and
        [Max EMC Score] is not null

    delete t
    from
        [db-au-actuary].ws.EMCGroupScore t
        inner join #corporate r on
            r.SourceKey = t.SourceKey and
            r.SourceSystem = t.SourceSystem

    insert into [db-au-actuary].ws.EMCGroupScore with(tablock)
    (
        SourceSystem,
        SourceKey,
        [Max EMC Score],
        [Total EMC Score]
    )
    select 
        SourceSystem,
        SourceKey,
        [Max EMC Score],
        [Total EMC Score]
    from
        #corporate


    --only 421? WTF, such an expensive query for a small result set
    --if object_id('tempdb..#trips') is not null
    --    drop table #trips

    --select 
    --    'TRIPS' SourceSystem,
    --    p.PolicyKey SourceKey,
    --    es.[Max EMC Score],
    --    es.[Total EMC Score]
    --into #trips
    --from
    --    [db-au-cba]..Policy p with(nolock)
    --    cross apply
    --    (
    --        select top 1 
    --            AncestorPolicyNo,
    --            AncestorPolicyKey,
    --            r.CountryKey AncestorCountryKey,
    --            r.CompanyKey AncestorCompanyKey,
    --            r.AgencyCode AncestorAgencyCode
    --        from
    --            [db-au-actuary].ws.PolicyLineage pl
    --            inner join [db-au-cba]..Policy r with(nolock) on
    --                r.PolicyKey = pl.AncestorPolicyKey
    --        where
    --            pl.PolicyKey = p.PolicyKey
    --    ) pl
    --    outer apply
    --    (
    --        select 
    --            max(e.MaxEMCScore) [Max EMC Score],
    --            sum(isnull(e.TotalEMCScore, 0)) [Total EMC Score]
    --        from
    --            [db-au-actuary].ws.CustomerOnBasePolicy cb
    --            cross apply
    --            (
    --                select 
    --                    --applicationid,
    --                    max(isnull(GroupScore, 0)) MaxEMCScore,
    --                    sum(isnull(GroupScore, 0)) TotalEMCScore
    --                from
    --                    (
    --                        select distinct
    --                            mc.ApplicationID,
    --                            mc.GroupID,
    --                            mc.GroupScore
    --                        from
    --                            [db-au-cba]..emcApplications ea with(nolock)
    --                            inner join [db-au-cba]..emcMedical mc with(nolock) on
    --                                mc.ApplicationKey = ea.ApplicationKey
    --                        where
    --                            ea.ApplicationID <> 0 and
    --                            ea.ApplicationID = [db-au-cba].dbo.fn_StrToInt(replace(isnull(cb.ClientID,''),'.00','')) and
    --                            mc.ConditionStatus = 'Approved' and
    --                            mc.GroupScore > 1.2
    --                    ) eg
    --                --group by
    --                --    applicationid
    --            ) e
    --        where
    --            cb.PolicyKey = pl.AncestorPolicyKey
    --    ) es
    --where
    --    isnull(p.isTripsPolicy, 0) = 1 and
    --    [Max EMC Score] is not null

    --delete t
    --from
    --    [db-au-actuary].ws.EMCGroupScore t
    --    inner join #trips r on
    --        r.SourceKey = t.SourceKey and
    --        r.SourceSystem = t.SourceSystem

    --insert into [db-au-actuary].ws.EMCGroupScore with(tablock)
    --(
    --    SourceSystem,
    --    SourceKey,
    --    [Max EMC Score],
    --    [Total EMC Score]
    --)
    --select 
    --    SourceSystem,
    --    SourceKey,
    --    [Max EMC Score],
    --    [Total EMC Score]
    --from
    --    #trips

end

GO
