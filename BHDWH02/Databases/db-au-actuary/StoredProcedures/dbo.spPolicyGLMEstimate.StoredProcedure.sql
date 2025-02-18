USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [dbo].[spPolicyGLMEstimate]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[spPolicyGLMEstimate]
    @DateRange varchar(30) = 'Yesterday-to-now',
    @StartDate date = null,
    @EndDate date = null

as
begin

--declare
--    @DateRange varchar(30) = '_User Defined',
--    @StartDate date = '2016-12-01',
--    @EndDate date = '2016-12-31'

    set nocount on

    if @DateRange <> '_User Defined'
        select
            @StartDate = StartDate,
            @EndDate = EndDate
        from
            [db-au-cmdwh].dbo.vDateRange
        where
            DateRange = @DateRange

    if object_id('tempdb.dbo.#transaction') is not null
        drop table #transaction

    select 
        PolicyTransactionKey
    into #transaction
    from
        [db-au-actuary].ws.PolicyTransactionGLM pt
    where
        pt.IssueTime >= @StartDate and
        pt.IssueTime <  dateadd(day, 1, @EndDate)

    if object_id('[db-au-actuary].ws.PolicyTransactionGLMEstimate') is null
    begin

        --drop table [db-au-actuary].ws.PolicyTransactionGLMEstimate
        create table [db-au-actuary].[ws].[PolicyTransactionGLMEstimate]
        (
            [BIRowID] bigint not null identity(1,1),
	        [PolicyKey] [varchar](41) null,
	        [PolicyTransactionKey] [varchar](41) not null,
	        [TransactionOrder] [int] null,
	        [Base Policy No] [varchar](50) null,
	        [IssueMonth] [varchar](2) null,
	        [IssueYear] [int] null,
	        [DepartureMonth] [varchar](2) null,
	        [JVGroup] [varchar](500) not null,
	        [ProductGroup] [varchar](500) not null,
	        [CountryGroup] [varchar](500) not null,
	        [AgeOldestBand] [varchar](500) null,
	        [LeadTimeBand] [varchar](500) null,
	        [TripLengthBand] [varchar](500) null,
	        [MaxTripLengthBand] [varchar](500) null,
	        [ExcessBand] [varchar](500) null,
	        [PlanType] [varchar](5) not null,
	        [NoOfChildrenBand] [varchar](500) null,
	        [NoOfChargedTravellerBand] [varchar](500) null,
	        [HasEMC] [varchar](1) not null,
	        [HasMotorcycle] [varchar](7) not null,
	        [HasWintersport] [int] not null,
	        [EstimateFactor] [decimal](30, 20) null,
	        [Estimate] [decimal](30, 20) null
        ) 

        create unique clustered index cidx_PolicyTransactionGLMEstimate on [db-au-actuary].ws.PolicyTransactionGLMEstimate(BIRowID)
        create nonclustered index idx_PolicyTransactionGLMEstimate_PolicyKey on [db-au-actuary].ws.PolicyTransactionGLMEstimate(PolicyKey,TransactionOrder) include(Estimate)
        create nonclustered index idx_PolicyTransactionGLMEstimate_PolicyTransactionKey on [db-au-actuary].ws.PolicyTransactionGLMEstimate(PolicyTransactionKey)

    end

    delete
    from
        [db-au-actuary].[ws].[PolicyTransactionGLMEstimate]
    where
        PolicyTransactionKey in
        (
            select
                PolicyTransactionKey
            from
                #transaction
        )

    insert into [db-au-actuary].[ws].[PolicyTransactionGLMEstimate]
    (
	    [PolicyKey],
	    [PolicyTransactionKey],
	    [TransactionOrder],
	    [Base Policy No],
	    [IssueMonth],
	    [IssueYear],
	    [DepartureMonth],
	    [JVGroup],
	    [ProductGroup],
	    [CountryGroup],
	    [AgeOldestBand],
	    [LeadTimeBand],
	    [TripLengthBand],
	    [MaxTripLengthBand],
	    [ExcessBand],
	    [PlanType],
	    [NoOfChildrenBand],
	    [NoOfChargedTravellerBand],
	    [HasEMC],
	    [HasMotorcycle],
	    [HasWintersport],
	    [EstimateFactor],
	    [Estimate]
    ) 
    select 
        glm.PolicyKey,
        glm.PolicyTransactionKey,
        glm.TransactionOrder,
        p.[Base Policy No],

        glf.IssueMonth,
        glf.IssueYear,
        glf.DepartureMonth,
        glf.JVGroup,
        glf.ProductGroup,
        glf.CountryGroup,
        glf.AgeOldestBand, 
        glf.LeadTimeBand,
        glf.TripLengthBand,
        glf.MaxTripLengthBand,
        glf.ExcessBand,
        glf.PlanType,
        glf.NoOfChildrenBand,
        glf.NoOfChargedTravellerBand,
        glf.HasEMC,
        glf.HasMotorcycle,
        glf.HasWintersport,

        ef.EstimateFactor,
        exp(ef.EstimateFactor) Estimate
    from
        [db-au-actuary].dbo.DWHDataSetSummary p
        inner join [db-au-actuary].ws.PolicyTransactionGLM glm on
            glm.PolicyKey = p.PolicyKey
        cross apply
        (
            select
                datediff(day, glm.DepartureDate, glm.ReturnDate) + 1 TripLength,
                datediff(day, p.[Issue Date], glm.DepartureDate) LeadTime,
                case
                    when p.[Issue Date] is null or glm.OldestChargedDOB is null then -1
                    else
                        floor(
                            (
                                datediff(month, glm.OldestChargedDOB, p.[Issue Date]) -
                                case
                                    when datepart(day, p.[Issue Date]) < datepart(day, glm.OldestChargedDOB) then 1
                                    else 0
                                end
                            ) /
                            12
                        )
                end [Oldest Age],
                isnull([db-au-actuary].ws.getGLMMapping('Country Group', glm.PrimaryCountry), 'UNKNOWN') CountryGroup
        ) b
        cross apply
        (
            select
                right('0' + convert(varchar(2), datepart(month, p.[Issue Date])), 2) IssueMonth,
                datepart(year, p.[Issue Date]) IssueYear,
                right('0' + convert(varchar(2), datepart(month, p.[Departure Date])), 2) DepartureMonth,

                --need to handle possible JV changes (unmapped to mapped or wrong mapping)
                isnull([db-au-actuary].ws.getGLMMapping('JV Group', p.[JV Description]), 'Other Distributors') JVGroup,
    
                isnull([db-au-actuary].ws.getGLMMapping('Product Group', p.[Product Code]), 'Comp - Standard') ProductGroup,

                case
                    when glm.PrimaryCountry = 'NORFOLK ISLAND' and glm.IssueTime < '2016-07-01' then 'NORFOLK ISLAND PRE JUL16'
                    when glm.PrimaryCountry = 'NORFOLK ISLAND' and glm.IssueTime >= '2016-07-01' then 'NORFOLK ISLAND POST JUL16'
                    when b.CountryGroup = 'UNKNOWN' and p.[Product Code] = 'CMB' then 'Unknown - CMB'
                    when b.CountryGroup = 'UNKNOWN' then 'Unknown - Mainly FCO FCT'
                    else b.CountryGroup
                end CountryGroup,

                [db-au-actuary].ws.getGLMBanding('Age Band', b.[Oldest Age]) AgeOldestBand, 
                [db-au-actuary].ws.getGLMBanding('Lead Time Band', b.LeadTime) LeadTimeBand,
                case
                    when [Derived Trip Type] = 'AMT' then 'Multi Trip'
                    else [db-au-actuary].ws.getGLMBanding('Trip Length Band', b.TripLength) 
                end TripLengthBand,
                [db-au-actuary].ws.getGLMBanding('AMT Trip Length Band', glm.MaxAMTDuration) MaxTripLengthBand,
                [db-au-actuary].ws.getGLMBanding('Excess Band', p.Excess) ExcessBand,

                case
                    when [Derived Plan Type] = 'International' and [Derived Trip Type] = 'AMT' then 'AMT'
                    when [Derived Plan Type] = 'International' and [Derived Trip Type] = 'Car hire' then 'CH'
                    when [Derived Plan Type] = 'International' and [Derived Trip Type] = 'Single Trip' then 'INT'
                    when [Derived Plan Type] = 'Domestic' and [Derived Trip Type] = 'AMT' then 'DM'
                    when [Derived Plan Type] = 'Domestic' and [Derived Trip Type] = 'Cancellation' then 'DA'
                    when [Derived Plan Type] = 'Domestic' and [Derived Trip Type] = 'Car hire' then 'CH'
                    when [Derived Plan Type] = 'Domestic' and [Derived Trip Type] = 'Single Trip' then 'DOM'
                    when [Derived Plan Type] = 'Domestic Inbound' then 'DIN'
                    else ''
                end PlanType,

                [db-au-actuary].ws.getGLMBanding('Traveller Count Band', p.[Unique Traveller Count] - p.[Charged Traveller Count]) NoOfChildrenBand,
                [db-au-actuary].ws.getGLMBanding('Traveller Count Band', p.[Charged Traveller Count]) NoOfChargedTravellerBand,

                case
                    when isnull(glm.Running_HasEMC, 0) > 0 then 'Y'
                    else 'N'
                end HasEMC,
                case
                    when isnull(glm.Running_HasMotorcycle, 0) > 0 and isnull(glm.Bundled_Motorcycle, 0) = 1 then 'Bundled'
                    when isnull(glm.Running_HasMotorcycle, 0) > 0 then 'Yes'
                    else 'No'
                end HasMotorcycle,
                case
                    when isnull(glm.Running_HasWintersport, 0) > 0 then 1
                    else 0
                end HasWintersport

        ) glf
        cross apply
        (
            select
                [db-au-actuary].ws.CalculateGLMFactor
                (
                    p.[Issue Date],
                    glf.CountryGroup,
                    glf.LeadTimeBand,
                    glf.TripLengthBand,
                    glf.MaxTripLengthBand,
                    glf.AgeOldestBand, 
                    glf.PlanType,
                    glf.JVGroup,
                    glf.ExcessBand,
                    glf.ProductGroup,
                    glf.NoOfChildrenBand,
                    glf.NoOfChargedTravellerBand,
                    glf.HasMotorcycle,
                    glf.HasEMC,
                    glf.HasWintersport
                ) EstimateFactor
        ) ef
        --outer apply
        --(
        --    select top 1
        --        [db-au-cmdwh].dbo.fn_CountDatePattern(CallComment) AdditionalChildren
        --    from
        --        [db-au-cmdwh].dbo.penPolicyAdminCallComment pac
        --    where
        --        pac.PolicyKey = p.PolicyKey and
        --        pac.CallDate < dateadd(hour, 1, glm.IssueTime) and
        --        pac.CallComment like '%[0-9]/%[0-9]/[0-9][0-9]%' and
        --        (
        --            pac.CallComment like '%add%' or
        --            pac.CallComment like '%acc%' or
        --            pac.CallComment like '%travel%' or
        --            pac.CallComment like '%cover%'
        --        ) and
        --        (
        --            pac.CallComment like '%child%' or
        --            pac.CallComment like '%kid%' or
        --            pac.CallComment like '%daughter%' or
        --            pac.CallComment like '% son%'
        --        ) and
        --        pac.CallComment not like '%extend%' and
        --        pac.CallComment not like '%behalf%' and
        --        pac.CallComment not like '%diag%' and
        --        pac.CallComment not like '%emc%' and
        --        pac.CallComment not like '%[0-9][0-9][0-9][0-9][0-9]/[0-9]%' and
        --        pac.CallComment not like '%attorney%' and
        --        pac.CallComment not like '%accident%' and
        --        pac.CallComment not like '%cancel%' and
        --        pac.CallComment not like '%refund%' and
        --        pac.CallComment not like '%cleared%' and
        --        pac.CallComment not like '%dates%' and
        --        pac.CallComment not like '%recover%' and
        --        pac.CallComment not like '%upgrad%' and
        --        pac.CallComment not like '%purchas%' and
        --        pac.CallComment not like '%claim%' and
        --        pac.CallComment not like '%TPA%'
        --    order by
        --        pac.CallDate desc
        --) ac
    where
        glm.PolicyTransactionKey in
        (
            select
                PolicyTransactionKey 
            from
                #transaction
        )

end
GO
