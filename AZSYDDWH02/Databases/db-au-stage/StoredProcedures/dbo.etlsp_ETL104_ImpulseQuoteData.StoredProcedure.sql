USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL104_ImpulseQuoteData]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


--CREATE 
CREATE
procedure [dbo].[etlsp_ETL104_ImpulseQuoteData]    
as
begin
	/************************************************************************************************************************************
	Author:         Dane Murray
	Date:           20180925
	Prerequisite:   Requires Innate Impulse postgres access.      
	Description:    populates Impulse Quote data in [db-au-cba]
	Parameters:     
	Change History: 
	20181220   RS    Implemented parsing logic in python and used the new table.
	20190131   RS    Added two more columns QuoteSource,cbaChannelID to [db-au-cba].dbo.[impQuotes] and [db-au-cba].[dbo].[impPolicies]
                               
	*************************************************************************************************************************************/
    set nocount on;
    declare
		@sql varchar(max),
        @batchid int,
        @start date,
        @end date,
        @name varchar(50),
        @sourcecount int,
        @insertcount int,
        @updatecount int,
		@ETLRunArea varchar(50) = 'IMPULSE Quotes - CBA'

    exec syssp_getrunningbatch
        @SubjectArea = @ETLRunArea,
        @BatchID = @batchid out,
        @StartDate = @start out,
        @EndDate = @end out

	
	--begin transaction
	begin try
		select @name = object_name(@@procid)
        
        exec syssp_genericerrorhandler 
            @LogToTable = 1,
            @ErrorCode = '0',
            @BatchID = @batchid,
            @PackageID = @name,
            @LogStatus = 'Running'
		
		--Get Data from Innate
		--if object_id('[db-au-stage].dbo.impulse_archive_sessions') is not null--Commented by Ratnesh
		--	drop table [db-au-stage].dbo.impulse_archive_sessions

		--select @sql= 'select sessiontoken, 
		--		CAST(sessiondata as varchar(max)) COLLATE Latin1_General_CI_AS as sessiondata,
		--		lastupdatetime
		--	into [db-au-stage].dbo.impulse_archive_sessions
		--from
		--	openquery
		--	(
		--		IMPULSE,
		--		''
		--		select 
		--			sessiontoken,
		--			sessiondata::varchar(1000000),
		--			lastupdatetime
		--		from
		--			cbaanalytics.cba.archive_sessions
		--		where 
		--			lastupdatetime >= ''''' + convert(varchar(10), @start , 112) + '''''
		--			AND
		--			lastupdatetime <= ''''' + convert(varchar(10), @end , 112) + '''''
		--		''
		--	) t'


		--print @sql
		--exec (@sql)

		/*select --top 10000 --commented by Ratnesh
			sessiontoken, 
			cast(sessiondata as nvarchar(max)) collate latin1_general_ci_as as sessiondata,
			lastupdatetime
		into [db-au-stage].dbo.impulse_archive_sessions
		from
			IMPULSE.cbaanalytics.cba.archive_sessions
		where
			len(cast(sessiondata as nvarchar(max))) < 30000 and
			lastupdatetime >= @start and
			lastupdatetime <  dateadd(day, 1, @end)*/

		/* 
			1. Get base Quote information 
		*/
		if object_id('[db-au-stage].dbo.impulse_Quotes') is not null
			drop table [db-au-stage].dbo.impulse_Quotes

select 
			id QuoteID,
			BusinessUnitID businessUnitID,quotedate quoteDateUTC,
			json_value([Issuer],'$.Consultant') issuerConsultant,
			json_value([Issuer],'$.AffiliateCode') issuerAffiliateCode,
			O.OutletAlphaKey,
			--case when Trip='null' then NULL else Trip end Trip,
			TRY_CAST(json_value(Trip,'$.StartDate') as date) tripStartDate,
			TRY_CAST(json_value(Trip,'$.EndDate') as date) tripEndDate,
			json_value(Trip,'$.RegionID') RegionID,
			TRY_CAST(IsPurchased as bit) isPurchased,
			TRY_CAST(json_value(Quote, '$.Excess') as float) quoteExcess,
			TRY_CAST(json_value(Quote, '$.PolicyPrice.Price.Gross') as float) quoteGross,
			TRY_CAST(json_value(Quote, '$.PolicyPrice.Price.DisplayPrice') as float) quoteDisplayPrice,
			TRY_CAST(json_value(Quote, '$.Duration') as float) quoteDuration,
			TRY_CAST(json_value(Quote, '$.ProductID') as float) quoteProductID,
			LastTransactionTime lastTransactionTime,
			CreatedDateTime createdDateTime,
			NULL domain,
			Token SessionID,
			s.ChannelID,
			CampaignID,
			PartnerTransactionID,
			SavedQuoteID,
			--'DUMMY SESSIONDATA' sessiondata,
			CAST(null as bigint) as BIRowID,
			Trip,
			policies,
			Travellers,
			Quote,
			Addons,
			Contact,
			appliedPromoCodes,
            PartnerMetadata,
			json_value(PartnerMetadata,'$.quoteSource') QuoteSource,
			json_value(PartnerMetadata,'$.cbaChannelID') cbaChannelID
			into [db-au-stage].dbo.impulse_Quotes
			from [db-au-stage].dbo.impulse_archive_sessions s
			left join [db-au-cba].dbo.penOutlet O on json_value(Issuer,'$.AffiliateCode') = O.AlphaCode AND O.OutletStatus = 'Current'

		update q
		set OutletAlphaKey = po.OutletAlphaKey
		--select Q.businessUnitID, bu.BusinessUnit, bu.Partner, po.Outletname, po.OutletAlphaKey
		from [db-au-stage].dbo.impulse_Quotes q
		left join [db-au-cba].dbo.cdgBusinessUnit bu on q.businessUnitID = bu.BusinessUnitID
		left join [db-au-cba].dbo.penOutlet po on CASE bu.BusinessUnit 
														WHEN 'CBA-Cardholder' THEN 'CBA0020'
														WHEN 'CBA-WL' THEN 'CBA0010'
														WHEN 'Bankwest-Cardholder' THEN 'BWA0005'
													END = po.AlphaCode AND po.OutletStatus = 'Current'
		where q.OutletAlphaKey is null

		if object_id('tempdb..#output') is not null
			drop table #output

		declare @output table (
			QuoteID varchar(50),
			birowid bigint,
			MergeAction varchar(20)
		)

		merge into [db-au-cba].dbo.[impQuotes] as tgt
		using [db-au-stage].dbo.impulse_Quotes as src
		on tgt.QuoteID = src.QuoteID
		when not matched then
			insert(QuoteID, OutletAlphaKey, businessUnitID, quoteDate, YAGOQuoteDate, quoteDateUTC, issuerConsultant, issuerAffiliateCode, tripStartDate, tripEndDate, RegionID, isPurchased, quoteExcess, quoteGross, quoteDisplayPrice, quoteDuration, quoteProductID, lastTransactionTime, createdDateTime, domain, SessionID, ChannelID, CampaignID, PartnerTransactionID, SavedQuoteID--, Data commmented by Ratnesh
			,Trip,policies,Travellers,Quote,Addons,Contact,appliedPromoCodes,PartnerMetadata,QuoteSource,cbaChannelID
			)
			values(	src.QuoteID,
					src.OutletAlphaKey,
					src.businessUnitID,
					CAST([db-au-cba].dbo.xfn_ConvertUTCToLocal(src.quoteDateUTC,'AUS Eastern Standard Time') as date),
					CAST(DateAdd(year,1,[db-au-cba].dbo.xfn_ConvertUTCToLocal(src.quoteDateUTC,'AUS Eastern Standard Time')) as date),
					src.quoteDateUTC,
					src.issuerConsultant,
					src.issuerAffiliateCode,
					src.tripStartDate,
					src.tripEndDate,
					src.RegionID,
					src.isPurchased,
					src.quoteExcess,
					src.quoteGross,
					src.quoteDisplayPrice,
					src.quoteDuration,
					src.quoteProductID,
					src.lastTransactionTime,
					src.createdDateTime,
					src.domain,
					src.SessionID,
					src.ChannelID,
					src.CampaignID,
					src.PartnerTransactionID,
					src.SavedQuoteID--, commented by Ratnesh
					--src.SessionData
					,src.Trip
					,src.policies
					,src.Travellers
					,src.Quote
					,src.Addons
					,src.Contact
			        ,src.appliedPromoCodes
                    ,src.PartnerMetadata
					,src.QuoteSource
					,src.cbaChannelID
				)
		when matched then
			update set
				OutletAlphaKey = src.OutletAlphaKey,
				businessUnitID = src.businessUnitID, 
				quoteDate = CAST([db-au-cba].dbo.xfn_ConvertUTCToLocal(src.quoteDateUTC,'AUS Eastern Standard Time') as date),
				YAGOQuoteDate = CAST(DateAdd(year,1,[db-au-cba].dbo.xfn_ConvertUTCToLocal(src.quoteDateUTC,'AUS Eastern Standard Time')) as date),
				quoteDateUTC = src.quoteDateUTC, 
				issuerConsultant = src.issuerConsultant, 
				issuerAffiliateCode = src.issuerAffiliateCode, 
				tripStartDate = src.tripStartDate, 
				tripEndDate = src.tripEndDate, 
				RegionID = src.RegionID, 
				isPurchased = src.isPurchased, 
				quoteExcess = src.quoteExcess, 
				quoteGross = src.quoteGross, 
				quoteDisplayPrice = src.quoteDisplayPrice, 
				quoteDuration = src.quoteDuration, 
				quoteProductID = src.quoteProductID, 
				lastTransactionTime = src.lastTransactionTime, 
				createdDateTime = src.createdDateTime, 
				domain = src.domain, 
				SessionID = src.SessionID, 
				ChannelID = src.ChannelID, 
				CampaignID = src.CampaignID, 
				PartnerTransactionID = src.PartnerTransactionID, 
				SavedQuoteID = src.SavedQuoteID--,  Commented by Ratnesh
				--Data = src.SessionData
				,Trip=src.Trip
				,policies=src.policies
				,Travellers=src.Travellers
				,Quote=src.Quote
				,Addons=src.Addons
				,Contact=src.Contact
			    ,appliedPromoCodes=src.appliedPromoCodes
                ,PartnerMetadata=src.PartnerMetadata
				,QuoteSource=src.QuoteSource
				,cbaChannelID=src.cbaChannelID
		output inserted.QuoteID, inserted.BIRowID, $action into @output
			;

		UPDATE q
		set BIRowID = o.birowid
		--select * 
		from @output o
		join [db-au-stage].dbo.impulse_Quotes Q on o.QuoteID = Q.QuoteID

		/* 
			2. Get the list of Destinations for each Quote 
		*/
		if object_id('[db-au-stage].dbo.impulse_QuoteDestinations') is not null
			drop table [db-au-stage].dbo.impulse_QuoteDestinations

		select	q.BIRowID as QuoteSK,
				q.QuoteID,
				TRY_CAST(d.[key] as int) as DestinationOrdered,
				d.[Value] as Destination
		into [db-au-stage].dbo.impulse_QuoteDestinations
		from [db-au-stage].dbo.impulse_Quotes q
		--cross apply openjson(q.[sessiondata], '$.Trip.DestinationCountryCodes') d
		cross apply openjson(Trip, '$.DestinationCountryCodes') d


		/* 
			3. Get the Policy ID for sold Quotes. Built to take into account multiple policies 
		*/
		if object_id('[db-au-stage].dbo.impulse_QuotePolicies') is not null
			drop table [db-au-stage].dbo.impulse_QuotePolicies

		select	q.BIRowID as QuoteSK,
				q.QuoteID,
				TRY_CAST(p.[key] as int) as PolicyOrder,
				p.value as PolicyID
		into [db-au-stage].dbo.impulse_QuotePolicies
		from [db-au-stage].dbo.impulse_Quotes q
		--cross apply openjson(q.[sessiondata], '$.Policies') p
		cross apply openjson(q.[policies]) p

		/* 
			4. Get the all the Travellers for each Quote 
		*/
		if object_id('[db-au-stage].dbo.impulse_QuoteTravellers') is not null
			drop table [db-au-stage].dbo.impulse_QuoteTravellers

		select 
			q.BIRowID as QuoteSK,
			q.QuoteID,
			TRY_CAST(t.[key] as int) as TravellerOrder,
			json_value(t.value,'$.Identifier') as TravellerIdentifier,
			json_value(t.value,'$.Title') as Title,
			json_value(t.value,'$.FirstName') as firstName,
			json_value(t.value,'$.LastName') as lastName,
			json_value(t.value,'$.MemberId') as memberId,
			json_value(t.value,'$.IsPrimary') as PrimaryTraveller,
			json_value(t.value,'$.Age') as age,
			json_value(t.value,'$.IsPlaceholderAge') as isPlaceholderAge,
			CAST(json_value(t.value,'$.DateOfBirth') as date) as dateOfBirth,
			json_value(t.value,'$.BinNumber') as BinNumber,
			json_value(t.value,'$.PersonalIdentifiers.partnerUniqueId') as PartnerUniqueId
		into [db-au-stage].dbo.impulse_QuoteTravellers
		from [db-au-stage].dbo.impulse_Quotes q
		cross apply openjson(q.Travellers) t

		--BUG FIX - Remove travellers that have the same identifier on 1 quote (eg 2x adult1 or 2xchild1)
		;with travellers as (
			select QuoteSK
			from [db-au-stage].dbo.impulse_QuoteTravellers t
			group by QuoteSK, TravellerIdentifier
			having COUNT(*) > 1)
		delete t
		from [db-au-stage].dbo.impulse_QuoteTravellers t
		join travellers x on t.QuoteSK = X.quoteSK


		/* 5. Get all Traveller Addons and pricing */
		if object_id('[db-au-stage].dbo.impulse_QuoteTravellerAddons') is not null
			drop table [db-au-stage].dbo.impulse_QuoteTravellerAddons

		if object_id('tempdb..#TravellerAddonPricing') is not null
			drop table #TravellerAddonPricing

		if object_id('tempdb..#TravellerAddons') is not null
			drop table #TravellerAddons

		/* 5(a). Get the specific Addon pricing for each Traveller on Quote */
		select 
			q.BIRowID as QuoteSK,
			q.QuoteID, 
			json_value(t.value,'$.Traveller.Identifier') as  TravellerIdentifier,
			json_value(ta.value,'$.LineCategoryCode') as AddonCode,
			json_value(ta.value,'$.LineTitle') as AddonName,
			TRY_CAST(json_value(ta.value,'$.LineGrossPrice') as float) as AddonGrossPrice,
			TRY_CAST(json_value(ta.value,'$.LineActualGross') as float) as AddonActualGross,
			TRY_CAST(json_value(ta.value,'$.LineDiscountPercent') as float) as discountRate,
			TRY_CAST(json_value(ta.value,'$.LineDiscountedGross') as float) as AddonDiscountedGross,
			json_value(ta.value,'$.LineFormattedActualGross') as AddonFormattedActualGross
		into #TravellerAddonPricing
		from [db-au-stage].dbo.impulse_Quotes q
		cross apply openjson(q.Quote, '$.PolicyPrice.TravellerPrices') t
		cross apply openjson(t.value, '$.TravelerCostStatement.LineItems') ta

		/* 5(b). Get the all the Addons for each Traveller (non-EMC) on Quote */
		select DISTINCT
			q.BIRowID as QuoteSK,
			q.QuoteID, 
			json_value(t.value,'$.Traveller.Identifier') as  TravellerIdentifier,
			json_value(ta.value,'$.Addon.Code') as AddonCode,
			json_value(ta.value,'$.Addon.Name') as AddonName,
			json_value(ta.value,'$.Addon.AppliedLevel') as AppliedLevel,
			json_value(ta.value,'$.Addon.ChosenLevel') as ChosenLevel,
			cast(null as varchar(50)) as EMCAssessmentID,
			cast(null as varchar(50)) as EMCAccepted
		into #TravellerAddons
			from [db-au-stage].dbo.impulse_Quotes q 
			cross apply openjson(q.Quote, '$.PolicyPrice.TravellerPrices') t
			cross apply openjson(t.value, '$.Traveller.Addons') ta
		UNION ALL
			/* 5(c). Get the all the Addons for each Traveller (EMC) on Quote */
		select 
			distinct --added on 2019-03-22
			q.BIRowID as QuoteSK,
			q.QuoteID, 
			json_value(t.value,'$.Traveller.Identifier') as  TravellerIdentifier,
			'EMC' as AddonCode,
			'Existing Medical Condition' as AddonName,
			'T' as AppliedLevel,
			'T' as ChosenLevel,
			json_value(t.value,'$.Traveller.Emc.AssessmentID') as EMCAssessmentID,
			json_value(t.value,'$.Traveller.Emc.Accepted') as EMCAccepted
			from [db-au-stage].dbo.impulse_Quotes q
			cross apply openjson(q.Quote, '$.PolicyPrice.TravellerPrices') t
			where json_value(t.value,'$.Traveller.Emc.Accepted') is not null
		UNION ALL
			/* 5(c). Get the all the BASE Premium for each Traveller on Quote */
		select 
			distinct --added on 2019-03-22
			q.BIRowID as QuoteSK,
			q.QuoteID, 
			json_value(t.value,'$.Traveller.Identifier') as  TravellerIdentifier,
			'BASE' as AddonCode,
			'Traveller Premium' as AddonName,
			'T' as AppliedLevel,
			'T' as ChosenLevel,
			null as EMCAssessmentID,
			null  as EMCAccepted
			from [db-au-stage].dbo.impulse_Quotes q
			cross apply openjson(q.Quote, '$.PolicyPrice.TravellerPrices') t

		/* 
			5(d). Finally add each Traveller Addon and Pricing together 
		*/
		select	distinct --added on 2019-03-22
				ta.QuoteSK,
				ta.QuoteID,
				ta.TravellerIdentifier,
				ta.AddonCode,
				ta.AddonName,
				ta.AppliedLevel,
				ta.ChosenLevel,
				ta.EMCAccepted,
				ta.EMCAssessmentID,
				tap.AddonGrossPrice,
				tap.AddonActualGross,
				tap.discountRate,
				tap.AddonDiscountedGross,
				tap.AddonFormattedActualGross
		into [db-au-stage].dbo.impulse_QuoteTravellerAddons
		from #TravellerAddons ta
		left join #TravellerAddonPricing tap on ta.QuoteSK = tap.QuoteSK AND ta.TravellerIdentifier = tap.TravellerIdentifier AND ta.AddonCode = tap.AddonCode
		order by ta.QuoteID, ta.TravellerIdentifier, ta.AddonCode

		/* Get All Quote addons & Pricing */
		if object_id('[db-au-stage].dbo.impulse_QuotePolicyAddons') is not null
			drop table [db-au-stage].dbo.impulse_QuotePolicyAddons

		if object_id('tempdb..#PolicyAddons') is not null
			drop table #PolicyAddons

		if object_id('tempdb..#PolicyAddonPricing') is not null
			drop table #PolicyAddonPricing

		/* 6(a). Get All Addons associated with Policy (non-Traveller) */
		select	q.BIRowID as QuoteSK,
				q.QuoteID,
				json_value(a.value,'$.Addon.Code') as AddonCode,
				json_value(a.value,'$.Addon.Name') as AddonName
		into #PolicyAddons
		from [db-au-stage].dbo.impulse_Quotes q
		--cross apply openjson(q.[sessiondata], '$.Addons') a
		cross apply openjson(q.Addons) a

		/* 6(b). Get Pricing for ALL addons (including Traveller addons) */
		select	q.BIRowID as QuoteSK,
				q.QuoteID,
				json_value(t.value,'$.LineCategoryCode') as AddonCode,
				json_value(t.value,'$.LineTitle') as AddonName,
				TRY_CAST(json_value(t.value,'$.LineGrossPrice') as float) as lineGrossPrice,
				TRY_CAST(json_value(t.value,'$.LineActualGross') as float) as lineActualGross,
				TRY_CAST(json_value(t.value,'$.LineDiscountPercent') as float) as lineDiscountPercent,
				TRY_CAST(json_value(t.value,'$.LineDiscountedGross') as float) as lineDiscountedGross,
				json_value(t.value,'$.LineFormattedActualGross') as lineFormattedActualGross
		into #PolicyAddonPricing
		from [db-au-stage].dbo.impulse_Quotes q
		--cross apply openjson(q.[sessiondata], '$.Quote.PolicyCostStatement.LineItems') t
		cross apply openjson(q.Quote, '$.PolicyCostStatement.LineItems') t

		/* 
			6(c). Finally add each Policy Addon and Pricing together 
		*/
		select 
			ap.QuoteSK,
			ap.QuoteID,
			ap.AddonCode,
			isNull(a.AddonName, ap.AddonName) as AddonName,
			SUM(ap.lineGrossPrice) as lineGrossPrice,
			SUM(ap.lineActualGross) as lineActualGross,
			SUM(ap.lineDiscountPercent) as lineDiscountPercent,
			SUM(ap.lineDiscountedGross) as lineDiscountedGross,
			max(ap.lineFormattedActualGross) as lineFormattedActualGross
		into [db-au-stage].dbo.impulse_QuotePolicyAddons
		from #PolicyAddonPricing ap
		left join #PolicyAddons a on ap.QuoteID = a.QuoteID AND ap.AddonCode = a.AddonCode
		GROUP BY ap.QuoteSK, ap.QuoteID, ap.AddonCode, isNull(a.AddonName, ap.AddonName)

		/* 7. Get Traveller contact info */
		if object_id('[db-au-stage].dbo.impulse_QuoteContact') is not null
			drop table [db-au-stage].dbo.impulse_QuoteContact

		if object_id('[db-au-stage].dbo.impulse_QuoteContactPhone') is not null
			drop table [db-au-stage].dbo.impulse_QuoteContactPhone

		/*
			7(a). Get Quote contact information
		*/
		select	q.BIRowID as QuoteSK,
				q.QuoteID,
				json_value(q.Contact,'$.Email') as email,
				json_value(q.Contact,'$.Address.City') as city,
				json_value(q.Contact,'$.Address.State') as state,
				json_value(q.Contact,'$.Address.Suburb') as suburb,
				json_value(q.Contact,'$.Address.Country') as country,
				json_value(q.Contact,'$.Address.Street1') as street1,
				json_value(q.Contact,'$.Address.Street2') as street2,
				json_value(q.Contact,'$.Address.PostCode') as postCode,
				json_value(q.Contact,'$.OptInMarketing') as optInMarketing
		into [db-au-stage].dbo.impulse_QuoteContact
		from [db-au-stage].dbo.impulse_Quotes q

		/*
			7(b). Get Quote contact information
		*/
		select	q.BIRowID as QuoteSK,
				q.QuoteID,
				json_value(t.value,'$.Type') as type,
				json_value(t.value,'$.Number') as number
		into [db-au-stage].dbo.impulse_QuoteContactPhone
		from [db-au-stage].dbo.impulse_Quotes q
		cross apply openjson(q.Contact, '$.PhoneNumbers') t

		/*
			8. Get Quote Promo Codes
		*/
		if object_id('[db-au-stage].dbo.impulse_QuotePromo') is not null
			drop table [db-au-stage].dbo.impulse_QuotePromo

		select	q.BIRowID as QuoteSK,
				q.QuoteID,
				TRY_CAST(d.[key] as int) as PromoOrder,
				d.[Value] as PromoCode
		into [db-au-stage].dbo.impulse_QuotePromo
		from [db-au-stage].dbo.impulse_Quotes q
		cross apply openjson(q.appliedPromoCodes) d

		/*
			9. Get Partner Metadata
		*/

		if object_id('[db-au-stage].dbo.impulse_QuotePartnerMetaData') is not null
			drop table [db-au-stage].dbo.impulse_QuotePartnerMetaData


		SELECT	q.BIRowID as QuoteSK, 
				Q.QuoteID, 
				CAST(x.[key] as varchar(50)) COLLATE Latin1_General_CI_AS as [JSONKey] ,  
				X.value as ValueText, 
				try_cast(nullif(X.Value,'') as date) as ValueDate
		into [db-au-stage].dbo.impulse_QuotePartnerMetaData
		FROM [db-au-stage].dbo.impulse_Quotes q
		--cross apply OPENJSON(q.[sessiondata], '$.PartnerMetadata') X;
		cross apply OPENJSON(q.PartnerMetadata) X;

		------------------------------------------------------------------------------------------------------------------------

		merge into [db-au-cba].dbo.impQuoteDestinations as tgt
		using [db-au-stage].dbo.impulse_QuoteDestinations as src
		on tgt.QuoteSK = src.QuoteSK AND tgt.[DestinationOrdered] = src.[DestinationOrdered]
		when not matched then
			insert (QuoteSK, [QuoteID], [DestinationOrdered], [Destination])
			values (src.QuoteSK, src.[QuoteID], src.[DestinationOrdered], src.[Destination])
		when matched then
			update set
				 [Destination] = src.[Destination]
			;

		merge into [db-au-cba].dbo.impQuotePolicies as tgt
		using [db-au-stage].dbo.impulse_QuotePolicies as src
		on tgt.QuoteSK = src.QuoteSK AND tgt.PolicyOrder = src.PolicyOrder
		when not matched then
			insert(QuoteSK, [QuoteID], [PolicyOrder], [PolicyID])
			values(src.QuoteSK, src.[QuoteID], src.[PolicyOrder], src.[PolicyID])
		when matched then
			update set
				PolicyID = src.PolicyID
			;

		merge into [db-au-cba].dbo.impQuoteTravellers as tgt
		using [db-au-stage].dbo.impulse_QuoteTravellers as src
		on tgt.QuoteSK = src.QuoteSK AND tgt.TravellerIdentifier = src.TravellerIdentifier
		when not matched then
			insert (QuoteSK, QuoteID, TravellerIdentifier, firstName, lastName, memberId, PrimaryTraveller, age, isPlaceholderAge, dateOfBirth, BinNumber, PartnerUniqueId)
			values (src.QuoteSK, src.QuoteID, src.TravellerIdentifier, src.firstName, src.lastName, src.memberId, src.PrimaryTraveller, src.age, src.isPlaceholderAge, src.dateOfBirth, src.BinNumber, src.PartnerUniqueId)
		when matched then
			update set 
				firstName = src.firstName,
				lastName = src.lastName,
				memberID = src.memberID,
				PrimaryTraveller = src.PrimaryTraveller,
				Age = src.age,
				IsPlaceHolderAge = src.IsPlaceHolderAge,
				dateofBirth = src.dateOfbirth,
				BinNumber = src.BinNumber,
				PartnerUniqueId = src.PartnerUniqueId
			;

		merge into [db-au-cba].dbo.impQuoteTravellerAddons as tgt
		using [db-au-stage].dbo.impulse_QuoteTravellerAddons as src
		on tgt.QuoteSK = src.QuoteSK AND tgt.TravellerIdentifier = src.TravellerIdentifier AND tgt.AddonCode = src.AddonCode
		when not matched then
			insert(QuoteSK, QuoteID, TravellerIdentifier, AddonCode, AddonName, AppliedLevel, ChosenLevel, EMCAccepted, EMCAssessmentID, AddonGrossPrice, AddonActualGross, discountRate, AddonDiscountedGross, AddonFormattedActualGross)
			values(src.QuoteSK, src.QuoteID, src.TravellerIdentifier, src.AddonCode, src.AddonName, src.AppliedLevel, src.ChosenLevel, src.EMCAccepted, src.EMCAssessmentID, src.AddonGrossPrice, src.AddonActualGross, src.discountRate, src.AddonDiscountedGross, src.AddonFormattedActualGross)
		when matched then
			update
				set AddonName = src.AddonName,
					AppliedLevel = src.AppliedLevel,
					ChosenLevel = src.ChosenLevel,
					EMCAccepted = src.EMCAccepted,
					EMCAssessmentID = src.EMCAssessmentID,
					AddonGrossPrice = src.AddonGrossPrice,
					AddonActualGross = src.AddonActualGross,
					discountRate = src.discountRate,
					AddonDiscountedGross = src.AddonDiscountedGross,
					AddonFormattedActualGross = src.AddonFormattedActualGross
			;

		merge into [db-au-cba].dbo.impQuotePolicyAddons as tgt
		using [db-au-stage].dbo.impulse_QuotePolicyAddons as src
		on tgt.QuoteSK = src.QuoteSK AND tgt.AddonCode = src.AddonCode
		when not matched then
			insert (QuoteSK, QuoteID, AddonCode, AddonName, lineGrossPrice, lineActualGross, lineDiscountPercent, lineDiscountedGross, lineFormattedactualGross)
			values (src.QuoteSK, src.QuoteID, src.AddonCode, src.AddonName, src.lineGrossPrice, src.lineActualGross, src.lineDiscountPercent, src.lineDiscountedGross, src.lineFormattedactualGross)
		when matched then
			update set
				AddonName = src.AddonName ,
				lineGrossPrice = src.lineGrossPrice ,
				lineActualGross = src.lineActualGross ,
				lineDiscountPercent = src.lineDiscountPercent ,
				lineDiscountedGross = src.lineDiscountedGross ,
				lineFormattedactualGross = src.lineFormattedactualGross
			;

		merge into [db-au-cba].dbo.impQuoteContact tgt
		using [db-au-stage].dbo.impulse_QuoteContact as src
		on tgt.QuoteSK = src.QuoteSK
		when not matched then 
			insert (QuoteSK, QuoteID, email, city, state, suburb, country, street1, street2, postCode, optInMarketing)
			values (src.QuoteSK, src.QuoteID, src.email, src.city, src.state, src.suburb, src.country, src.street1, src.street2, src.postCode, src.optInMarketing)
		when matched then
			update set
				email = src.email ,
				city = src.city ,
				state = src.state ,
				suburb = src.suburb ,
				country = src.country ,
				street1 = src.street1 ,
				street2 = src.street2 ,
				postCode = src.postCode ,
				optInMarketing = src.optInMarketing
			;

		merge into [db-au-cba].dbo.impQuoteContactPhone as tgt
		using [db-au-stage].dbo.impulse_QuoteContactPhone as src
		on tgt.QuoteSK = src.QuoteSK and tgt.type = src.type
		when not matched then
			insert (QuoteSK, QuoteID, Type, number)
			values (src.QuoteSK, src.QuoteID, src.Type, src.number)
		when matched then
			update set
				number = src.number
			;

		merge into [db-au-cba].dbo.impQuotePromo as tgt
		using [db-au-stage].dbo.impulse_QuotePromo as src
		on tgt.QuoteSK = src.QuoteSK AND tgt.PromoOrder = src.PromoOrder
		when not matched then 
			insert (QuoteSK, QuoteID, PromoOrder, PromoCode)
			values (src.QuoteSK, src.QuoteID, src.PromoOrder, src.PromoCode)
		when matched then
			update set
				PromoCode = src.PromoCode
			;

		merge into [db-au-cba].dbo.impQuotePartnerMetadata as tgt
		using [db-au-stage].dbo.impulse_QuotePartnerMetaData as src
		on tgt.QuoteSK = src.QuoteSK AND tgt.[JSONKey] = src.[JSONKey]
		when not matched then 
			insert (QuoteSK, QuoteID, [JSONKey], [ValueText], [ValueDate])
			values(src.QuoteSK, src.QuoteID, src.[JSONKey], src.[ValueText], try_convert(datetime, src.ValueDate))
		when matched then
			update set
				ValueText = src.ValueText,
				ValueDate = try_convert(datetime, src.ValueDate)
			;

		-- Update the PartnerUniqueId onto impQuotes from impQuoteTraveller (primary Traveller)

		UPDATE Q
		SET PartnerUniqueId = T.PartnerUniqueId
		--select *
		from [db-au-cba].dbo.impQuoteTravellers T
		JOIN [db-au-cba].dbo.impQuotes Q ON t.QuoteSK = Q.BIRowID
		where T.PrimaryTraveller = 'true'

		--Ratnesh NO CHANGES MADE TO THE POLICIES PROCESSING.

		--Get Policy Data from Impulse and match against Quotes
/* -- commenting this to load the file
		if object_id('[db-au-stage].dbo.impulse_archive_policies') is not null
			drop table [db-au-stage].dbo.impulse_archive_policies

		select @sql= 'select sessiontoken, 
			policydata = cast(policydata as varchar(max)),
			lastupdatetime as lastupdatetimeUTC
		into [db-au-stage].dbo.impulse_archive_policies
		from
		openquery
		(
	        IMPULSE,
		    ''
			select 
				sessiontoken,
				policydata,
				lastupdatetime
			from
	            cbaanalytics.cba.archive_policies
			where 
					lastupdatetime >= ''''' + convert(varchar(10), @start , 112) + '''''
					AND
					lastupdatetime <= ''''' + convert(varchar(10), @end , 112) + '''''
			''
		) t'
		print @sql
		exec (@sql)
	
*/
		if object_id('tempdb..#policysrc') is not null
			drop table #policysrc

		select	json_value(policydata, '$.Id') as PolicyId,
				json_value(policydata, '$.Number') as PolicyNumber,
				pp.PolicyKey,
				json_value(policydata, '$.SessionID') as QuoteSessionID,
				Q.BIRowID as QuoteSK,
				Q.QuoteID as [QuoteId],
				json_value(policydata,'$.PartnerMetadata.quoteSource') QuoteSource,
                json_value(policydata,'$.PartnerMetadata.cbaChannelID') cbaChannelID
		into #policysrc
		from [db-au-stage].dbo.impulse_archive_policies p
		left join [db-au-cba].dbo.impQuotes Q ON json_value(policydata, '$.SessionID') = q.QuoteID
		LEFT JOIN [db-au-cba].dbo.penPolicy pp on json_value(policydata, '$.Number') = pp.PolicyNumber 
				AND json_value(policyData, '$.Issuer.AffiliateCode') = pp.AlphaCode
				AND json_value(policyData, '$.Domain') = pp.CountryKey
				AND pp.CompanyKey = 'CM'

		;merge into [db-au-cba].[dbo].[impPolicies] as tgt
		using #policysrc as src
		on tgt.ImpulsePolicyID = src.PolicyID
		when not matched then
			insert (ImpulsePolicyID, PolicyNumber, PolicyKey, ImpulsePolicyQuoteID, QuoteSK, QuoteID,QuoteSource,cbaChannelID)
			values (src.PolicyID, src.PolicyNumber, src.PolicyKey, src.QuoteSessionID, src.QuoteSK, src.QuoteId,src.QuoteSource,src.cbaChannelID)
		when matched then
			update set
				PolicyNumber = src.PolicyNumber, 
				PolicyKey = src.PolicyKey, 
				ImpulsePolicyQuoteID = src.QuoteSessionID, 
				QuoteSK = src.QuoteSK, 
				QuoteID = src.QuoteId,
				QuoteSource=src.QuoteSource,
				cbaChannelID=src.cbaChannelID
			;
	
		--if object_id('[db-au-cba].dbo.usr_CMPolicyDestinations') is not null
		--	drop table [db-au-cba].dbo.usr_CMPolicyDestinations

		----Get top Destinations for CM purchased policies (ULDWH02)
		--select	identity(int,1,1) as BIRowID, 
		--		p.PrimaryCountry, 
		--		SUM(pts.BasePolicyCount) as PolicyCount
		--into [db-au-cba].dbo.usr_CMPolicyDestinations
		--from [uldwh02].[db-au-cmdwh].dbo.penPolicyTransSummary pts
		--JOIN [uldwh02].[db-au-cmdwh].dbo.penPolicy p on pts.PolicyKey = p.PolicyKey
		--where pts.CountryKey = 'AU'
		--AND pts.PostingDate between CAST(DateAdd(month,-3,GetDate()) as date) and CAST(DateAdd(day,-1, GetDate()) as date)
		--and pts.TransactionType = 'BASE'
		--GROUP BY p.PrimaryCountry


		select 
			@insertcount = 
				sum(
					case
						when MergeAction = 'insert' then 1
						else 0
					end
				),
			@updatecount = 
				sum(
					case
						when MergeAction = 'update' then 1
						else 0
					end
				)
		from
			@output

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
        
            --if @@trancount > 0
            --    rollback transaction
                
            exec syssp_genericerrorhandler 
                @SourceInfo = 'Impulse Quote data refresh failed',
                @LogToTable = 1,
                @ErrorCode = '-100',
                @BatchID = @batchid,
                @PackageID = @name
            
	end catch    

	--if @@trancount > 0
	--	commit transaction

end



GO
