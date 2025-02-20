USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penQuote]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_penQuote]
as
begin


/************************************************************************************************************************************
Author:         Leonardus Setyabudi
Date:
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:
Change History:
                20130204 - LS - Case 18219, change QuoteEMC.QuoteID reference
                20130408 - LS - Case 18440, bug fix on Trip Duration & Trip Dates
                20130422 - LS - Add YAGOCreateDate
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20130812 - LS - Performance fixes
                20131218 - LT - Added QuoteSaveDate and QuoteSaveDateUTC columns to penQuote table
                20140129 - LS - Add purchase path type in penQuote
                20140220 - LS - case 19851, competitor data
                                remove legacy quote
                20140327 - LS - case 19851, CRM User info
                20140530 - LS - case 20933, PreviousPolicyNumber and selected plan
                20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                                drop and recreate staging tables instead truncating
                                add QuoteSave.ImportDate
                                remove QuoteEMC.Condition & QuoteMEC.DeniedAccepted these are always null (data not exists when etl run)
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
                20140620 - LS - bug fix, penQuotePromo, wrong join logic (how the hell did I end up with that)
                20140626 - LS - bring in selected quoteplan
                20140702 - LT - TFS 12675 - Merged columns from tblQuotePlan with penQuote table WHERE tblQuotePlan.isSelected = 1
                                This is required for Universe to query on YAGO metrics and attributes.
                                Removed penQuoteSelectedPlan table.
                20140710 - LT - Case 21289 - Temporary workaround fix. limit tblquoteplan to top 1 due to duplicate selected quote plans
                                remove temporary fix, and uncomment permanent fix when issue is fixed at the source
                20140721 - LS - Case 21379, regression fix on TFS 12675, typo in quotesave for CM should be _aucm instead of _autp
                20140805 - LT - TFS 13021, changed PolicyNumber from bigint to varchar(50), changed PreviousPolicyNumber from bigint to varchar(50)
                20141216 - LS - P11.5, consultantusername & CRMusername from 50 to 100 nvarchar
                20150311 - LT - Penguin 12.5, added ParentQuoteID column
                20150428 - LT - TFS 14124 - Added GoBelowNet column to penQuotePromo table
				20151027 - DM - Penguin v16 Release - update column Destination
				20151119 - LT - Penguin 16.5 Release - Added penQuoteDestination table and set penQuote.Destination to destination with
								highest risk based on area weighting. Added MultiDestination column to penPolicy. This is unmodified PrimaryCountry field in Penguin source.
				20160318 - LT - Penguin 18.0 release - Added US penguin instance
				20160518 - LT - T24689, fixed leading space in Destination column for penQuoteDestination
                20161021 - LS - Penguin 2x.? penQuote.IsNoClaimBonus
                                             penQuoteCustomer.EMCCoverLimit
                                Penguin 21.5 penQuote.LeadTimeDate
				20170419 - LT - Penguin 24.0 increased Area to varchar(100)
				20180913 - LT - Customised for CBA
				20190925 - RS - Modified penquote.quotedprice column from (10,4) to (19,4)
*************************************************************************************************************************************/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    /* quote customer -------------------------------------------------------------------------------------------------- */
    if object_id('etl_penQuoteCustomer') is not null
        drop table etl_penQuoteCustomer

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, qc.QuoteID) QuoteCountryKey,
        PrefixKey + convert(varchar, qc.CustomerID) CustomerKey,
        q.DomainID,
        qc.QuoteID,
        qc.CustomerID,
        qc.QuoteCustomerID,
        qc.Age,
        qc.IsPrimary,
        qc.IsAdult PersonIsAdult,
        qc.HasEMC,
        qc.EmcCoverLimit
    into etl_penQuoteCustomer
    from
        penguin_tblquotecustomer_aucm qc
        inner join penguin_tblQuote_aucm q on
            q.QuoteID = qc.QuoteID
        cross apply dbo.fn_GetDomainKeys(q.DomainID, 'CM', 'AU') dk


    create index idx on etl_penQuoteCustomer (QuoteCountryKey) include (PersonIsAdult, CustomerID)

    /* delete existing quotecustomer */
    if object_id('[db-au-cba].dbo.penQuoteCustomer') is null
    begin

        create table [db-au-cba].dbo.[penQuoteCustomer]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [QuoteCountryKey] varchar(41) null,
            [CustomerKey] varchar(41) null,
            [QuoteID] int null,
            [CustomerID] int null,
            [QuoteCustomerID] int null,
            [Age] int null,
            [IsPrimary] bit null,
            [PersonIsAdult] bit null,
            [HasEMC] bit null,
            [DomainKey] varchar(41) null,
            [DomainID] int null,
            [EMCCoverLimit] decimal(18,2) null
        )

        create clustered index idx_penQuoteCustomer_QuoteCountryKey on [db-au-cba].dbo.penQuoteCustomer(QuoteCountryKey,IsPrimary)

    end
    else
    begin

        delete [db-au-cba].dbo.penQuoteCustomer
        where
            QuoteCountryKey in
            (
                select distinct
                    QuoteCountryKey
                from
                    etl_penQuoteCustomer
            )

    end

    /* load quotecustomer */
    insert into [db-au-cba].dbo.penQuoteCustomer with (tablock)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        QuoteCountryKey,
        CustomerKey,
        DomainID,
        QuoteID,
        CustomerID,
        QuoteCustomerID,
        Age,
        IsPrimary,
        PersonIsAdult,
        HasEMC,
        EMCCoverLimit
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        QuoteCountryKey,
        CustomerKey,
        DomainID,
        QuoteID,
        CustomerID,
        QuoteCustomerID,
        Age,
        IsPrimary,
        PersonIsAdult,
        HasEMC,
        EMCCoverLimit
    from
        etl_penQuoteCustomer



	--transform and load penQuoteDestination
	if object_id('etl_penQuoteDestination') is not null drop table etl_penQuoteDestination

	select 
		CountryKey,
		CompanyKey,
		DomainKey,
		PrefixKey + ltrim(rtrim(q.AlphaCode)) collate database_default + '-' + convert(varchar, q.QuoteID) QuoteKey,
		q.PrimaryCountry,
		q.Area,
		q.AreaCode,
		d.ItemNumber as DestinationOrder,
		ltrim(rtrim(d.Item)) as Destination,
		area.CountryAreaID,
		area.CountryID,
		area.AreaID,		
		area.Weighting
	into etl_penQuoteDestination
	from
		penguin_tblQuote_aucm q
		outer apply dbo.fn_DelimitedSplit8K(q.PrimaryCountry,';') d
		cross apply dbo.fn_GetDomainKeys(q.DomainId, 'CM', 'AU') dk  
        outer apply
        (
            select top 1
				ca.CountryAreaID,
				ca.CountryID,
				ca.AreaID,
				a.Weighting
            from
				Penguin_tblCountryArea_aucm ca
				inner join Penguin_tblCountry_aucm c on
					ca.CountryID = c.CountryID
				inner join penguin_tblArea_aucm a on
					ca.AreaID = a.AreaId
            where
				a.DomainID = q.DomainId and
                a.Area collate database_default  = q.Area collate database_default  and
				c.Country collate database_default  = d.Item collate database_default 
		) area



	if object_id('[db-au-cba].dbo.penQuoteDestination') is null
	begin
		create table [db-au-cba].dbo.penQuoteDestination
		(
			CountryKey varchar(2) NOT NULL,
			CompanyKey varchar(5) NOT NULL,
			DomainKey varchar(41) NOT NULL,
			QuoteKey varchar(71) NOT NULL,
			PrimaryCountry nvarchar(max) NULL,
			DestinationOrder bigint NULL,
			Destination nvarchar(100) NULL,
			Area nvarchar(100) NULL,
			CountryAreaID int NULL,
			CountryID int NULL,
			AreaID int NULL,
			Weighting int NULL,
			isPrimaryDestination bit NULL
		)
		create clustered index idx_penQuoteDestination_QuoteKey on [db-au-cba].dbo.penQuoteDestination(QuoteKey)
		create nonclustered index idx_penQuoteDestination_Destination on [db-au-cba].dbo.penQuoteDestination(Destination)
		create nonclustered index idx_penQuoteDestination_isPrimaryCountry on [db-au-cba].dbo.penQuoteDestination(isPrimaryDestination)
	end


    /*************************************************************/
    -- Transfer data from  etl_penQuoteDestination to [db-au-cba].dbo.penQuoteDestination
    /*************************************************************/
    begin transaction penQuoteDestination

    begin try

		delete a
		from
			[db-au-cba].dbo.penQuoteDestination a
			inner join etl_penQuoteDestination b on
				b.QuoteKey = a.QuoteKey


		insert [db-au-cba].dbo.penQuoteDestination with(tablockx)
		(
			CountryKey,
			CompanyKey,
			DomainKey,
			QuoteKey,
			PrimaryCountry,
			DestinationOrder,
			Destination,
			Area,
			CountryAreaID,
			CountryID,
			AreaID,
			Weighting,
			isPrimaryDestination
		)
		select
			d.CountryKey,
			d.CompanyKey,
			d.DomainKey,
			d.QuoteKey,
			d.PrimaryCountry,
			d.DestinationOrder,
			d.Destination,
			d.Area,
			d.CountryAreaID,
			d.CountryID,
			d.AreaID,
			d.Weighting,
			case when d.Destination = pr.Destination then 1 else 0 end isPrimaryDestination
		from
			etl_penQuoteDestination d
			outer apply												--determine Destination has riskiest weighting
			(														--if there are multiple destinations of same area, the first destination (in ascending order) is selected
				select top 1 Destination
				from etl_penQuoteDestination
				where
					QuoteKey = d.QuoteKey and
					AreaID = d.AreaID
				order by AreaID, Weighting desc, Destination					
			) pr
		order by d.QuoteKey

    end try

    begin catch

        if @@trancount > 0
            rollback transaction penQuoteDestination

        exec syssp_genericerrorhandler 'penQuoteDestination data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction penQuoteDestination


    /* quote -------------------------------------------------------------------------------------------------- */
    if object_id('etl_penQuote') is not null
        drop table etl_penQuote

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + ltrim(rtrim(q.AlphaCode)) collate database_default + '-' + convert(varchar, q.QuoteID) QuoteKey,
        PrefixKey + convert(varchar, q.QuoteID) QuoteCountryKey,
        PrefixKey + convert(varchar, p.PolicyID) PolicyKey,
        null as OutletSKey,
        PrefixKey + ltrim(rtrim(q.AlphaCode)) collate database_default OutletAlphaKey,
        q.DomainID,
        q.QuoteID,
        isnull(q.UniqueCustomerID, '') as SessionID,
        q.AlphaCode as AgencyCode,
        cn.ConsultantName,
        q.ConsultantUserName as UserName,
        convert(date, dbo.xfn_ConvertUTCtoLocal(q.QuoteDate, TimeZone)) as CreateDate,
        dbo.xfn_ConvertUTCtoLocal(q.QuoteDate, TimeZone) as CreateTime,
        convert(varchar(10), q.QuoteDate, 120) as CreateDateUTC,
        q.QuoteDate as CreateTimeUTC,
        q.Area,
        q.PrimaryCountry as Destination,
        convert(date, dbo.xfn_ConvertUTCtoLocal(q.TripStart, TimeZone)) as DepartureDate,
        convert(date, dbo.xfn_ConvertUTCtoLocal(q.TripEnd, TimeZone)) as ReturnDate,
        q.IsExpo,
        q.IsAgentSpecial,
        q.PromoCode,
        q.IsCancellation as CanxFlag,
        p.PolicyNumber  collate database_default PolicyNo,
        isnull(ccount.NumberOfChildren, 0) NumberOfChildren,
        isnull(ccount.NumberOfAdults, 0) NumberOfAdults,
        isnull(ccount.NumberOfPersons, 0) NumberOfPersons,
        datediff(day, q.tripstart, q.tripend) + 1 as Duration,
        case
            when qs.QuoteID is null then 0
            else 1
        end IsSaved,
        qs.SaveStep,
        qs.AgentReference,
        convert(date, dbo.xfn_ConvertUTCtoLocal(qs.CreateDateTime, TimeZone)) as QuoteSaveDate,
        qs.CreateDateTime as QuoteSaveDateUTC,
        dbo.xfn_ConvertUTCtoLocal(qs.UpdateDateTime, TimeZone) UpdateTime,
        qs.UpdateDateTime UpdateTimeUTC,
        q.StoreCode,
        isnull(p.QuotedPrice, qsp.GrossPremium) QuotedPrice,
        isnull(p.ProductCode, qsp.ProductCode) ProductCode,
        PurchasePathType PurchasePath,
        q.CRMUserName,
        crm.CRMFullName,
        q.PreviousPolicyNumber  collate database_default PreviousPolicyNumber,
        qs.ImportDateTime QuoteImportDateUTC,
        q.CurrencyCode,
        q.CultureCode,
        q.AreaCode,
        qsp.ProductName,
        qsp.PlanID,
        qsp.PlanName,
        qsp.PlanCode,
        qsp.PlanType,
        qsp.IsUpSell,
        qsp.Excess,
        qsp.IsDefaultExcess,
        qsp.PolicyStart,
        qsp.PolicyEnd,
        qsp.DaysCovered,
        qsp.MaxDuration,
        qsp.GrossPremium,
        qsp.PDSUrl,
        qsp.SortOrder,
        qsp.PlanDisplayName,
        qsp.RiskNet,
        qsp.PlanProductPricingTierID,
        qsp.VolumeCommission,
        qsp.Discount,
        qsp.CommissionTier,
        qsp.COI,
        qsp.UniquePlanID,
        qsp.TripCost,
        qsp.PolicyID,
        qsp.IsPriceBeat,
        qsp.CancellationValueText,
        qsp.ProductDisplayName,
        qsp.AreaID,
        qsp.AgeBandID,
        qsp.DurationID,
        qsp.ExcessID,
        qsp.LeadTimeID,
        qsp.RateCardID,
        qsp.IsSelected,
        q.ParentQuoteID,
		q.PrimaryCountry MultiDestination,
        q.IsNoClaimBonus,
        q.LeadTimeDate
    into etl_penQuote
    from
        penguin_tblquote_aucm q
        cross apply dbo.fn_GetDomainKeys(q.DomainID, 'CM', 'AU') dk
        outer apply
        (
            select top 1
                rtrim(u.FirstName + ' ' + u.LastName) ConsultantName
            from
                penguin_tblOutlet_aucm o
                inner join penguin_tblUser_aucm u on
                    u.OutletId = o.OutletId
            where
                o.AlphaCode = q.AlphaCode and
                u.Login = q.ConsultantUserName
        ) cn
        outer apply
        (
            select
                count(distinct
                    case
                        when qc.PersonIsAdult = 0 then qc.CustomerID
                        else null
                    end
                ) NumberOfChildren,
                count(distinct
                    case
                        when qc.PersonIsAdult = 1 then qc.CustomerID
                        else null
                    end
                ) NumberOfAdults,
                count(distinct qc.CustomerID) NumberOfPersons
            from
                etl_penQuoteCustomer qc
            where
                qc.QuoteCountryKey = PrefixKey + convert(varchar, q.QuoteID)
        ) ccount
        outer apply
        (
            select top 1
                p.PolicyNumber collate database_default PolicyNumber,
                p.PolicyID,
                qp.GrossPremium QuotedPrice,
                qp.ProductCode
            from
                penguin_tblQuotePlan_aucm qp
                inner join penguin_tblPolicy_aucm p on
                    p.QuotePlanID = qp.QuotePlanID
            where
                qp.QuoteID = q.QuoteID
            order by
                isnull(IsSelected, 0) desc
        ) p
        left join penguin_tblquotesave_aucm qs on
            qs.QuoteID = q.QuoteID
        outer apply
        (
            select top 1
                isnull(cu.FirstName + ' ', '') + isnull(cu.LastName, '') CRMFullName
            from
                penguin_tblCRMUser_aucm cu
            where
                cu.UserName = q.CRMUserName
        ) crm
        outer apply
        (
            select top 1 *
            from
                penguin_tblquoteplan_aucm qsp
            where
                q.QuoteID = qsp.QuoteID and
                qsp.isSelected = 1
            order by
                qsp.QuotePlanID
        ) qsp



	--update PrimaryCountry to destination with highest risk
	update a
	set Destination = case when b.Destination is not null then b.Destination		--get primary destination with highest risk
							  when b.Destination is null then c.Destination			--there is no highest risk destination for some unknown reason, then get first destination
							  else null												--policy has no destination
						end
	from
		etl_penQuote a
		outer apply								
		(
			select top 1 Destination
			from [db-au-cba].dbo.penQuoteDestination
			where 
				isPrimaryDestination = 1 and
				QuoteKey = a.QuoteKey
		) b
		outer apply								
		(
			select top 1 Destination
			from [db-au-cba].dbo.penQuoteDestination
			where 
				QuoteKey = a.QuoteKey and
				isPrimaryDestination = 0
		) c


    /* update OutletSKey in etl_penQuote records for current agencies */
    update q
    set
        OutletSKey = o.OutletSKey
    from
        etl_penQuote q
        inner join [db-au-cba].dbo.penOutlet o on
            q.OutletAlphaKey = o.OutletAlphaKey and
            o.OutletStatus = 'Current'

    /* update OutletSKey in etl_penQuote records for non current agencies */
    update q
    set
        OutletSKey = o.OutletSKey
    from
        etl_penQuote q
        inner join [db-au-cba].dbo.penOutlet o on
            q.OutletAlphaKey = o.OutletAlphaKey and
            o.OutletStatus = 'Not Current' and
            q.CreateDate between o.OutletStartDate and o.OutletEndDate

    /* delete existing quote */
    if object_id('[db-au-cba].dbo.penQuote') is null
    begin

        create table [db-au-cba].dbo.[penQuote]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [QuoteKey] varchar(30) null,
            [QuoteCountryKey] varchar(41) null,
            [PolicyKey] varchar(41) null,
            [OutletSKey] bigint null,
            [OutletAlphaKey] nvarchar(50) null,
            [QuoteID] int null,
            [SessionID] nvarchar(255) null,
            [AgencyCode] nvarchar(60) null,
            [ConsultantName] nvarchar(101) null,
            [UserName] nvarchar(100) null,
            [CreateDate] datetime null,
            [CreateTime] datetime null,
            [Area] nvarchar(100) null,
            [Destination] nvarchar(max),
            [DepartureDate] datetime null,
            [ReturnDate] datetime null,
            [IsExpo] bit null,
            [IsAgentSpecial] bit null,
            [PromoCode] nvarchar(60) null,
            [CanxFlag] bit null,
            [PolicyNo] varchar(50) null,
            [NumberOfChildren] int null,
            [NumberOfAdults] int null,
            [NumberOfPersons] int null,
            [Duration] int null,
            [IsSaved] bit null,
            [SaveStep] int null,
            [AgentReference] nvarchar(100) null,
            [UpdateTime] datetime null,
            [StoreCode] varchar(10) null,
            --[QuotedPrice] numeric(10,4) null, --Commented and next line added on 201909925 by Ratnesh
			[QuotedPrice] numeric(19,4) null,
            [ProductCode] nvarchar(50) null,
            [DomainKey] varchar(41) null,
            [DomainID] int null,
            [CreateDateUTC] datetime null,
            [CreateTimeUTC] datetime null,
            [UpdateTimeUTC] datetime null,
            [YAGOCreateDate] datetime null,
            [PurchasePath] nvarchar(50) null,
            [QuoteSaveDate] datetime null,
            [QuoteSaveDateUTC] datetime null,
            [CRMUserName] nvarchar(100) null,
            [CRMFullName] nvarchar(101) null,
            [PreviousPolicyNumber] varchar(50) null,
            [QuoteImportDateUTC] datetime null,
            [CurrencyCode] varchar(3) null,
            [AreaCode] nvarchar(3) null,
            [CultureCode] nvarchar(20) null,
            [ProductName] nvarchar(50) null,
            [PlanID] int null,
            [PlanName] nvarchar(50) null,
            [PlanCode] nvarchar(50) null,
            [PlanType] nvarchar(50) null,
            [IsUpSell] bit null,
            [Excess] money null,
            [IsDefaultExcess] bit null,
            [PolicyStart] datetime null,
            [PolicyEnd] datetime null,
            [DaysCovered] int null,
            [MaxDuration] int null,
            [GrossPremium] money not null,
            [PDSUrl] varchar(100) null,
            [SortOrder] int null,
            [PlanDisplayName] nvarchar(100) null,
            [RiskNet] money null,
            [PlanProductPricingTierID] int null,
            [VolumeCommission] decimal(18, 9) null,
            [Discount] decimal(18, 9) null,
            [CommissionTier] varchar(50) null,
            [COI] varchar(100) null,
            [UniquePlanID] int null,
            [TripCost] nvarchar(100) null,
            [PolicyID] int null,
            [IsPriceBeat] bit null,
            [CancellationValueText] nvarchar(50) null,
            [ProductDisplayName] nvarchar(50) null,
            [AreaID] int null,
            [AgeBandID] int null,
            [DurationID] int null,
            [ExcessID] int null,
            [LeadTimeID] int null,
            [RateCardID] int null,
            [IsSelected] bit null,
            [ParentQuoteID] int null,
			[MultiDestination] nvarchar(max) null,
            [IsNoClaimBonus] bit null,
            [LeadTimeDate] date null
        )

        create clustered index idx_penQuote_CreateDate on [db-au-cba].dbo.penQuote(CreateDate)
        create nonclustered index idx_penQuote_AgencyCode on [db-au-cba].dbo.penQuote(AgencyCode,CompanyKey,CountryKey)
        create nonclustered index idx_penQuote_OutletAlphaKey on [db-au-cba].dbo.penQuote(OutletAlphaKey,UpdateTime)
        create nonclustered index idx_penQuote_PolicyKey on [db-au-cba].dbo.penQuote(PolicyKey) include (QuoteID)
        create nonclustered index idx_penQuote_QuoteCountryKey on [db-au-cba].dbo.penQuote(QuoteCountryKey) include (PolicyKey,OutletAlphaKey,QuoteID,CreateDate,IsSaved)
        create nonclustered index idx_penQuote_YAGOCreateDate on [db-au-cba].dbo.penQuote(YAGOCreateDate)

    end
    else
    begin

        delete [db-au-cba].dbo.penQuote
        where
            QuoteCountryKey in
            (
                select distinct
                    QuoteCountryKey
                from
                    etl_penQuote
            )

    end


    /* load quote */
    insert into [db-au-cba].dbo.penQuote with (tablock)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        QuoteKey,
        QuoteCountryKey,
        PolicyKey,
        OutletSKey,
        OutletAlphaKey,
        DomainID,
        QuoteID,
        SessionID,
        AgencyCode,
        ConsultantName,
        UserName,
        CreateDate,
        YAGOCreateDate,
        CreateTime,
        CreateDateUTC,
        CreateTimeUTC,
        Area,
        Destination,
        DepartureDate,
        ReturnDate,
        IsExpo,
        IsAgentSpecial,
        PromoCode,
        CanxFlag,
        PolicyNo,
        NumberOfChildren,
        NumberOfAdults,
        NumberOfPersons,
        Duration,
        IsSaved,
        SaveStep,
        AgentReference,
        QuoteSaveDate,
        QuoteSaveDateUTC,
        UpdateTime,
        UpdateTimeUTC,
        StoreCode,
        QuotedPrice,
        ProductCode,
        PurchasePath,
        CRMUserName,
        CRMFullName,
        PreviousPolicyNumber,
        QuoteImportDateUTC,
        CurrencyCode,
        AreaCode,
        CultureCode,
        ProductName,
        PlanID,
        PlanName,
        PlanCode,
        PlanType,
        IsUpSell,
        Excess,
        IsDefaultExcess,
        PolicyStart,
        PolicyEnd,
        DaysCovered,
        MaxDuration,
        GrossPremium,
        PDSUrl,
        SortOrder,
        PlanDisplayName,
        RiskNet,
        PlanProductPricingTierID,
        VolumeCommission,
        Discount,
        CommissionTier,
        COI,
        UniquePlanID,
        TripCost,
        PolicyID,
        IsPriceBeat,
        CancellationValueText,
        ProductDisplayName,
        AreaID,
        AgeBandID,
        DurationID,
        ExcessID,
        LeadTimeID,
        RateCardID,
        IsSelected,
        ParentQuoteID,
		MultiDestination,
        IsNoClaimBonus,
        LeadTimeDate
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        QuoteKey,
        QuoteCountryKey,
        PolicyKey,
        OutletSKey,
        OutletAlphaKey,
        DomainID,
        QuoteID,
        SessionID,
        AgencyCode,
        ConsultantName,
        UserName,
        CreateDate,
        dateadd(year, 1, CreateDate) YAGOCreateDate,
        CreateTime,
        CreateDateUTC,
        CreateTimeUTC,
        Area,
        Destination,
        DepartureDate,
        ReturnDate,
        IsExpo,
        IsAgentSpecial,
        PromoCode,
        CanxFlag,
        PolicyNo,
        NumberOfChildren,
        NumberOfAdults,
        NumberOfPersons,
        Duration,
        IsSaved,
        SaveStep,
        AgentReference,
        QuoteSaveDate,
        QuoteSaveDateUTC,
        UpdateTime,
        UpdateTimeUTC,
        StoreCode,
        QuotedPrice,
        ProductCode,
        PurchasePath,
        CRMUserName,
        CRMFullName,
        PreviousPolicyNumber,
        QuoteImportDateUTC,
        CurrencyCode,
        AreaCode,
        CultureCode,
        ProductName,
        PlanID,
        PlanName,
        PlanCode,
        PlanType,
        IsUpSell,
        Excess,
        IsDefaultExcess,
        PolicyStart,
        PolicyEnd,
        DaysCovered,
        MaxDuration,
        isnull(GrossPremium,0) as GrossPremium,
        PDSUrl,
        SortOrder,
        PlanDisplayName,
        RiskNet,
        PlanProductPricingTierID,
        VolumeCommission,
        Discount,
        CommissionTier,
        COI,
        UniquePlanID,
        TripCost,
        PolicyID,
        IsPriceBeat,
        CancellationValueText,
        ProductDisplayName,
        AreaID,
        AgeBandID,
        DurationID,
        ExcessID,
        LeadTimeID,
        RateCardID,
        IsSelected,
        ParentQuoteID,
		MultiDestination,
        IsNoClaimBonus,
        LeadTimeDate
    from
        etl_penQuote


    /* quote emc -------------------------------------------------------------------------------------------------- */
    if object_id('etl_penQuoteEMC') is not null
        drop table etl_penQuoteEMC

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, q.QuoteID) as QuoteCountryKey,
        q.DomainID,
        q.QuoteID,
        qc.CustomerID,
        qe.EMCScore,
        qe.PremiumIncrease,
        qe.IsPercentage,
        case
            when qe.EMCRef = 'Not Applicable' then convert(int, null)
            else convert(int, qe.EMCRef)
        end EMCID,
        null Condition,
        null DeniedAccepted
    into etl_penQuoteEMC
    from
        penguin_tblquoteemc_aucm qe
        inner join penguin_tblQuoteCustomer_aucm qc on
            qc.QuoteCustomerID = qe.QuoteCustomerID
        inner join penguin_tblQuote_aucm q on
            q.QuoteID = qc.QuoteID
        cross apply dbo.fn_GetDomainKeys(q.DomainID, 'CM', 'AU') dk

 

    /* delete existing QuoteEMC */
    if object_id('[db-au-cba].dbo.penQuoteEMC') is null
    begin

        create table [db-au-cba].dbo.[penQuoteEMC]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [QuoteCountryKey] varchar(41) null,
            [QuoteID] int not null,
            [CustomerID] int not null,
            [EMCScore] numeric(10,4) null,
            [PremiumIncrease] numeric(10,4) null,
            [IsPercentage] bit null,
            [EMCID] int null,
            [Condition] varchar(50) null,
            [DeniedAccepted] varchar(1) null,
            [DomainKey] varchar(41) null,
            [DomainID] int null
        )

        create clustered index idx_penQuoteEMC_QuoteCountryKey on [db-au-cba].dbo.penQuoteEMC(QuoteCountryKey,CustomerID)
        create nonclustered index idx_penQuoteEMC_CustomerID on [db-au-cba].dbo.penQuoteEMC(CustomerID)
        create nonclustered index idx_penQuoteEMC_EMCID on [db-au-cba].dbo.penQuoteEMC(EMCID)

    end
    else
    begin

        delete [db-au-cba].dbo.penQuoteEMC
        where
            QuoteCountryKey in
            (
                select distinct
                    QuoteCountryKey
                from
                    etl_penQuoteEMC
            )

    end

    /* load QuoteEMC */
    insert into [db-au-cba].dbo.penQuoteEMC with (tablock)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        QuoteCountryKey,
        DomainID,
        QuoteID,
        CustomerID,
        EMCScore,
        PremiumIncrease,
        IsPercentage,
        EMCID,
        Condition,
        DeniedAccepted
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        QuoteCountryKey,
        DomainID,
        QuoteID,
        CustomerID,
        EMCScore,
        PremiumIncrease,
        IsPercentage,
        EMCID,
        Condition,
        DeniedAccepted
    from
        etl_penQuoteEMC



    /* quote addon -------------------------------------------------------------------------------------------------- */
    if object_id('etl_penQuoteAddOn') is not null
        drop table etl_penQuoteAddOn

    select
        CountryKey,
        CompanyKey,
        PrefixKey + convert(varchar, qc.QuoteID) QuoteCountryKey,
        PrefixKey + convert(varchar, qc.CustomerID) CustomerKey,
        qc.QuoteID,
        qc.CustomerID,
        qa.ID QuoteAddOnID,
        qa.AddOnName,
        qa.AddOnGroup,
        qa.ValueText AddOnItem,
        qa.PremiumIncrease,
        qa.CoverIncrease,
        qa.IsPercentage CoverIsPercentage,
        qa.IsRateCardBased,
        qa.Active IsActive
    into etl_penQuoteAddOn
    from
        penguin_tblquoteAddOn_aucm qa
        inner join penguin_tblQuoteCustomer_aucm qc on
            qc.QuoteCustomerID = qa.QuoteCustomerID
        inner join penguin_tblQuote_aucm q on
            q.QuoteID = qc.QuoteID
        cross apply dbo.fn_GetDomainKeys(q.DomainID, 'CM', 'AU') dk



    /* delete existing QuoteAddOn */
    if object_id('[db-au-cba].dbo.penQuoteAddOn') is null
    begin

        create table [db-au-cba].dbo.[penQuoteAddOn]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [QuoteCountryKey] varchar(41) null,
            [CustomerKey] varchar(41) null,
            [QuoteID] int not null,
            [CustomerID] int not null,
            [QuoteAddOnID] int not null,
            [AddOnName] nvarchar(50) null,
            [AddOnGroup] nvarchar(50) null,
            [AddOnItem] nvarchar(500) null,
            [PremiumIncrease] numeric(10,4) null,
            [CoverIncrease] numeric(10,4) null,
            [CoverIsPercentage] bit null,
            [IsRateCardBased] bit null,
            [IsActive] bit null
        )

        create clustered index idx_penQuoteAddOn_QuoteCountryKey on [db-au-cba].dbo.penQuoteAddOn(QuoteCountryKey,CustomerID)
        create nonclustered index idx_penQuoteAddOn_CustomerKey on [db-au-cba].dbo.penQuoteAddOn(CustomerKey)

    end
    else
    begin

        delete [db-au-cba].dbo.penQuoteAddOn
        where
            QuoteCountryKey in
            (
                select distinct
                    QuoteCountryKey
                from
                    etl_penQuoteAddOn
            )

    end

    /* load QuoteAddOn */
    insert into [db-au-cba].dbo.penQuoteAddOn with (tablock)
    (
        CountryKey,
        CompanyKey,
        QuoteCountryKey,
        CustomerKey,
        QuoteID,
        CustomerID,
        QuoteAddOnID,
        AddOnName,
        AddOnGroup,
        AddOnItem,
        PremiumIncrease,
        CoverIncrease,
        CoverIsPercentage,
        IsRateCardBased,
        IsActive
    )
    select
        CountryKey,
        CompanyKey,
        QuoteCountryKey,
        CustomerKey,
        QuoteID,
        CustomerID,
        QuoteAddOnID,
        AddOnName,
        AddOnGroup,
        AddOnItem,
        PremiumIncrease,
        CoverIncrease,
        CoverIsPercentage,
        IsRateCardBased,
        IsActive
    from
        etl_penQuoteAddOn


    /* quote promo -------------------------------------------------------------------------------------------- */
    if object_id('etl_penQuotePromo') is not null
        drop table etl_penQuotePromo

    select
        CountryKey,
        CompanyKey,
        PrefixKey + convert(varchar, qpp.PromoID) as PromoKey,
        PrefixKey + convert(varchar, q.QuoteID) collate database_default as QuoteCountryKey,
        q.QuoteID,
        qpp.PromoID,
        qpp.PromoCode,
        qpp.PromoName,
        qpp.PromoType,
        qpp.Discount,
        qpp.IsApplied,
        qpp.ApplyOrder,
        qpp.GoBelowNet
    into etl_penQuotePromo
    from
        penguin_tblquote_aucm q
        cross apply dbo.fn_GetDomainKeys(q.DomainID, 'CM', 'AU') dk
        cross apply
        (
            select top 1 qp.QuotePlanID
            from
                penguin_tblQuotePlan_aucm qp
            where
                qp.QuoteID = q.QuoteID and
                (
                    exists
                    (
                        select null
                        from
                            penguin_tblPolicy_aucm p
                        where
                            p.QuotePlanID = qp.QuotePlanID
                    ) or
                    qp.GrossPremium is not null
                )
            order by
                isnull(qp.IsSelected, 0) desc
        ) qp
        cross apply
        (
            select
                pr.PromoID,
                pr.Code PromoCode,
                pr.Name PromoName,
                rv.Value PromoType,
                qpp.Discount,
                qpp.IsApplied,
                qpp.ApplyOrder,
                pr.GoBelowNet
            from
                penguin_tblQuotePlanPromo_aucm qpp
                inner join penguin_tblPromo_aucm pr on
                    pr.PromoID = qpp.PromoID
                inner join penguin_tblReferenceValue_aucm rv on
                    rv.ID = pr.PromoTypeID
            where
                qpp.QuotePlanID = qp.QuotePlanID
        ) qpp


    /* delete existing quote promo */
    if object_id('[db-au-cba].dbo.penQuotePromo') is null
    begin

        create table [db-au-cba].dbo.[penQuotePromo]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [PromoKey] varchar(41) null,
            [QuoteCountryKey] varchar(41) null,
            [QuoteID] int null,
            [PromoID] int null,
            [PromoCode] varchar(10) null,
            [PromoName] nvarchar(250) null,
            [PromoType] nvarchar(50) null,
            [Discount] numeric(10,4) null,
            [IsApplied] bit null,
            [ApplyOrder] int null,
            [GoBelowNet] bit null
        )

        create clustered index idx_penQuotePromo_QuoteCountryKey on [db-au-cba].dbo.penQuotePromo(QuoteCountryKey)
        create nonclustered index idx_penQuotePromo_PromoCode on [db-au-cba].dbo.penQuotePromo(PromoCode,CountryKey)
        create nonclustered index idx_penQuotePromo_PromoID on [db-au-cba].dbo.penQuotePromo(PromoID,CountryKey)
        create nonclustered index idx_penQuotePromo_PromoName on [db-au-cba].dbo.penQuotePromo(PromoName,CountryKey)
        create nonclustered index idx_penQuotePromo_QuoteID on [db-au-cba].dbo.penQuotePromo(QuoteID,CountryKey)

    end
    else
    begin

        delete [db-au-cba].dbo.penQuotePromo
        where
            QuoteCountryKey in
            (
                select distinct
                    QuoteCountryKey
                from
                    etl_penQuotePromo
            )

    end


    /* load quote promo */
    insert into [db-au-cba].dbo.penQuotePromo with (tablock)
    (
        CountryKey,
        CompanyKey,
        PromoKey,
        QuoteCountryKey,
        QuoteID,
        PromoID,
        PromoCode,
        PromoName,
        PromoType,
        Discount,
        IsApplied,
        ApplyOrder,
        GoBelowNet
    )
    select
        CountryKey,
        CompanyKey,
        PromoKey,
        QuoteCountryKey,
        QuoteID,
        PromoID,
        PromoCode,
        PromoName,
        PromoType,
        Discount,
        IsApplied,
        ApplyOrder,
        GoBelowNet
    from
        etl_penQuotePromo



    /* quote competitor -------------------------------------------------------------------------------------------- */

    if object_id('etl_penQuoteCompetitor') is not null
        drop table etl_penQuoteCompetitor

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, qc.QuoteID) QuoteKey,
        dbo.xfn_ConvertUTCtoLocal(CreateDateTime, TimeZone) CreateDateTime,
        dbo.xfn_ConvertUTCtoLocal(UpdateDateTime, TimeZone) UpdateDateTime,
        CreateDateTime CreateDateTimeUTC,
        UpdateDateTime UpdateDateTimeUTC,
        QuoteID,
        CompetitorID,
        c.Name CompetitorName,
        CompetitorPrice
    into etl_penQuoteCompetitor
    from
        penguin_tblQuoteCompetitor_aucm qc
        left join penguin_tblCompetitor_aucm c on
            c.Id = qc.CompetitorId
        cross apply dbo.fn_GetDomainKeys(c.DomainId, 'CM', 'AU') dk

 


    /**************************************************************************/
    --delete existing data or create table if table doesnt exist
    /**************************************************************************/
    if object_id('[db-au-cba].dbo.penQuoteCompetitor') is null
    begin

        create table [db-au-cba].dbo.[penQuoteCompetitor]
        (
            [BIRowID] bigint not null identity (1,1),
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [DomainKey] varchar(41) null,
            [QuoteKey] varchar(41) null,
            [CreateDateTime] datetime not null,
            [UpdateDateTime] datetime not null,
            [CreateDateTimeUTC] datetime not null,
            [UpdateDateTimeUTC] datetime not null,
            [QuoteID] int not null,
            [CompetitorID] int null,
            [CompetitorName] nvarchar(50) null,
            [CompetitorPrice] money null
        )

        create clustered index idx_penQuoteCompetitor_BIRowID on [db-au-cba].dbo.penQuoteCompetitor(BIRowID)
        create nonclustered index idx_penQuoteCompetitor_CompetitorName on [db-au-cba].dbo.penQuoteCompetitor(CompetitorName) include (QuoteKey)
        create nonclustered index idx_penQuoteCompetitor_CreateDateTime on [db-au-cba].dbo.penQuoteCompetitor(CreateDateTime) include (QuoteKey,CompetitorName,CompetitorPrice)
        create nonclustered index idx_penQuoteCompetitor_QuoteKey on [db-au-cba].dbo.penQuoteCompetitor(QuoteKey) include (CompetitorName,CompetitorPrice)

    end
    else
    begin

        delete a
        from
            [db-au-cba].dbo.penQuoteCompetitor a
            inner join etl_penQuoteCompetitor b on
                a.QuoteKey = b.QuoteKey

    end


    /*****************************************************************************************/
    -- Transfer data from etl_penQuoteCompetitor to [db-au-cba].dbo.penQuoteCompetitor
    /*****************************************************************************************/

    insert into [db-au-cba].dbo.penQuoteCompetitor with (tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        QuoteKey,
        CreateDateTime,
        UpdateDateTime,
        CreateDateTimeUTC,
        UpdateDateTimeUTC,
        QuoteID,
        CompetitorID,
        CompetitorName,
        CompetitorPrice
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        QuoteKey,
        CreateDateTime,
        UpdateDateTime,
        CreateDateTimeUTC,
        UpdateDateTimeUTC,
        QuoteID,
        CompetitorID,
        CompetitorName,
        CompetitorPrice
    from
        etl_penQuoteCompetitor

end


GO
