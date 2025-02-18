USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL062_EMC_Scores]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[etlsp_ETL062_EMC_Scores]
    @StartDate date,
    @EndDate date

as

SET NOCOUNT ON

--20180821 - LT - created and refactored from Leo's code in uldwh02.[db-au-actuary].dbo.PopulateEMCGroupScores

begin


	--uncomment to debug
	/*
	declare @StartDate date, @EndDate date
	select @StartDate = '2018-07-01', @EndDate = '2018-07-31'
	*/


	declare @SQL varchar(8000)

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
            [Total EMC Score No Filter] numeric(6,2) null            
        )

        create unique clustered index cidx on [db-au-actuary].ws.EMCGroupScore(BIRowID)
        create nonclustered index idx on [db-au-actuary].ws.EMCGroupScore(SourceKey,SourceSystem) include([Max EMC Score],[Total EMC Score],[Max EMC Score No Filter],[Total EMC Score No Filter])

    end

    if object_id('[db-au-stage].dbo.etl062_emc_penguin') is not null
        drop table [db-au-stage].dbo.etl062_emc_penguin

	select @SQL = 'select *	into [db-au-stage].dbo.etl062_emc_penguin from openquery(ULDWH02,
				''select ''''Penguin'''' SourceSystem,
						p.PolicyKey SourceKey,
						es.[Max EMC Score],
						es.[Total EMC Score],
						esnf.[Max EMC Score No Filter],
						esnf.[Total EMC Score No Filter]    
				from [db-au-cmdwh]..penPolicy p with(nolock)
				cross apply	(select max(e.MaxEMCScore) [Max EMC Score],	sum(isnull(e.TotalEMCScore, 0)) [Total EMC Score]
							from [db-au-cmdwh]..penPolicyTraveller ptv with(nolock)
							cross apply	(select max(isnull(GroupScore, 0)) MaxEMCScore,	sum(isnull(GroupScore, 0)) TotalEMCScore
										from (select distinct mc.ApplicationID,	mc.GroupID,	mc.GroupScore
											from [db-au-cmdwh]..penPolicyTravellerTransaction ptt with(nolock)
											inner join [db-au-cmdwh]..penPolicyEMC pe with(nolock) on
												pe.PolicyTravellerTransactionKey = ptt.PolicyTravellerTransactionKey
											inner join [db-au-cmdwh]..emcMedical mc with(nolock) on
												mc.ApplicationKey = pe.EMCApplicationKey
										where ptt.PolicyTravellerKey = ptv.PolicyTravellerKey and mc.ConditionStatus = ''''Approved'''' and	mc.GroupScore > 1.2
								) eg
						) e
					where
						ptv.PolicyKey = p.PolicyKey        
				) es
			   cross apply (select max(e.MaxEMCScore) [Max EMC Score No Filter], sum(isnull(e.TotalEMCScore, 0)) [Total EMC Score No Filter]
							from [db-au-cmdwh]..penPolicyTraveller ptv with(nolock)
							cross apply	(select max(isnull(GroupScore, 0)) MaxEMCScore,	sum(isnull(GroupScore, 0)) TotalEMCScore
										from (select distinct mc.ApplicationID,	mc.GroupID,	mc.GroupScore
											from [db-au-cmdwh]..penPolicyTravellerTransaction ptt with(nolock)
												inner join [db-au-cmdwh]..penPolicyEMC pe with(nolock) on
													pe.PolicyTravellerTransactionKey = ptt.PolicyTravellerTransactionKey
												inner join [db-au-cmdwh]..emcMedical mc with(nolock) on
													mc.ApplicationKey = pe.EMCApplicationKey
											where ptt.PolicyTravellerKey = ptv.PolicyTravellerKey and mc.ConditionStatus = ''''Approved''''
											) eg
							) e
							where
							ptv.PolicyKey = p.PolicyKey        
				) esnf
			where
				isnull(p.isTripsPolicy, 0) = 0 and	
				exists	(select null
						from [db-au-cmdwh]..penPolicyTransSummary pt
						where pt.PolicyKey = p.PolicyKey and pt.PostingDate >= ''''2010-07-01'''' and
						pt.PostingDate >= ''''' + convert(varchar(10),@StartDate,120) + ''''' and
						pt.PostingDate <  ''''' + convert(varchar(10),dateadd(day, 1, @EndDate),120) + '''''
				) and [Max EMC Score] is not null
	'')'

	exec(@SQL)

    delete t
    from
        [db-au-actuary].ws.EMCGroupScore t
        inner join [db-au-stage].dbo.etl062_emc_penguin r on
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
        [db-au-stage].dbo.etl062_emc_penguin


    if object_id('[db-au-stage].dbo.etl062_emc_corporate') is not null
        drop table [db-au-stage].dbo.etl062_emc_corporate

	select @SQL = 'select * into [db-au-stage].dbo.etl062_emc_corporate	from openquery(ULDWH02,
					''select ''''Corporate'''' SourceSystem, q.QuoteKey SourceKey, es.[Max EMC Score], es.[Total EMC Score]
					  from [db-au-cmdwh]..corpQuotes q with(nolock)
						outer apply (select max(e.MaxEMCScore) [Max EMC Score], sum(isnull(e.TotalEMCScore, 0)) [Total EMC Score]
									from [db-au-cmdwh].dbo.corpEMC ce with(nolock)
									cross apply (select max(isnull(GroupScore, 0)) MaxEMCScore, sum(isnull(GroupScore, 0)) TotalEMCScore
												from (select distinct  mc.ApplicationID,  mc.GroupID, mc.GroupScore
														from [db-au-cmdwh].dbo.emcMedical mc with(nolock)
														where  mc.ApplicationKey = ce.CountryKey + ''''-'''' + ce.EMCApplicatioNo and
														mc.ConditionStatus = ''''Approved'''' and  mc.GroupScore > 1.2
													) eg
												) e
								where ce.QuoteKey = q.QuoteKey
						) es
					where
						exists
						(
							select 
								null
							from
								[db-au-cmdwh].dbo.corpEMC ce with(nolock)
							where
								ce.QuoteKey = q.QuoteKey
						) and
						[Max EMC Score] is not null
	'')'

	exec(@SQL)


    delete t
    from
        [db-au-actuary].ws.EMCGroupScore t
        inner join [db-au-stage].dbo.etl062_emc_corporate r on
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
        [db-au-stage].dbo.etl062_emc_corporate


end

GO
