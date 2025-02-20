USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rawsp_cba_usrTDS_Quote_Test]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rawsp_cba_usrTDS_Quote_Test]
    @Group varchar(5) = 'CB',
    @OverrideStart date = null,
    @OverrideEnd date = null

as
begin

/****************************************************************************************************/
--  Name:           rawsp_cba_usrTDS_Quote
--  Author:         Saurabh Date
--  Date Created:   20180816
--  Description:    Inserts CBA Quote records into the CBA usrTDS_Quote table for the TDS exports
--                    
--  Parameters:     @batchid: required. 
--                  
--  Change History: 
--                  20180816 - SD - Created
--                  20180817 - SD - changed vesion from one digit (1,2,3) to 3 digit value (001,002,003) and also added it ot the file name. Also changed travel countries to show ISO3 Code.
--                  20180821 - SD - Changed row eliminator to "0X0A", which will remove carriage return and have only new line character.
--                  20180822 - SD - Removed CIF ID, as we will get Hashed CIF ID only.
--                  20180920 - LL - adjusted for cba database structure
--                                  batch handling
--                  20190306 - LL - REQ-1014, modify channel, transaction id

/****************************************************************************************************/

--CBA TDS, logic: All Quote details having Quote Date on day - 1

    declare 
        @batchid int,
        @spname varchar(50),
        @start date,
        @end date


    --get active batch
    exec [db-au-stage]..syssp_getrunningbatch
        @SubjectArea = 'CBA TDS',
        @BatchID = @batchid out,
        @StartDate = @start out,
        @EndDate = @end out

    select
        @spname = object_name(@@procid)

    exec syssp_genericerrorhandler
        @LogToTable = 1,
        @ErrorCode = '0',
        @BatchID = @batchid,
        @PackageID = @spname,
        @LogStatus = 'Running'

    --override
    if 
        @batchid = -1 and
        @OverrideStart is not null and
        @OverrideEnd is not null
        select
            @start = @OverrideStart,
            @end = @OverrideEnd



     if object_id('[db-au-cba].[dbo].[usrTDS_Quote]') is null
    begin

        create table [db-au-cba].[dbo].[usrTDS_Quote]
        (
            BIRowID bigint not null identity(1,1),
            BatchID int,
            quote_reference varchar(50) not null,
            quote_date datetime not null,
            travel_insurance_ref_id varchar(50),
            hashed_cif_id varchar(256),
            type_code varchar(10) not null,
            initiating_channel_code varchar(10),
            csr_reference varchar(50),
            travel_departure_date datetime not null,
            travel_return_date datetime not null,
            travel_countries varchar(200) not null,
            promo_code varchar(50),
            excess money,
            trip_cost money,
            total_premium money,
            base_premium money,
            medical_premium money,
            emc_premium money,
            cruise_premium money,
            luggage_premium money,
            winter_sport_premium money,
            business_premium money,
            age_cover_premium money,
            rental_car_premium money,
            motorcycle_premium money,
            other_packs_premium money,
            discount money
        )
        
        create unique clustered index ucidx_usrTDS_Quote on [db-au-cba].[dbo].[usrTDS_Quote](BIRowID)
        create nonclustered index idx_usrTDS_Quote_BatchID on [db-au-cba].[dbo].[usrTDS_Quote](BatchID)

    end

    begin transaction 

    begin try

        if object_id('tempdb..#quote') is not null
            drop table #quote

        select 
			isnull(Q.QuoteID,'') [quote_reference],
			dbo.xfn_ConvertUTCToLocal(Q.quoteDateUTC,'AUS Eastern Standard Time') [quote_date],
			isnull(q.PartnerTransactionID,'') [travel_insurance_ref_id],
			isnull(pt.PIDValue,'') [hashed_cif_id],
			isnull(Case
						When po.SubGroupName like '%Whitelabel%' then 'WL'
						When po.SubGroupName like '%NAC%' then 'NAC'
					End,'') [type_code],
            isnull(q.cbaChannelID, '')  [initiating_channel_code],
			isnull(Q.issuerAffiliateCode,'') [csr_reference],
			CAST(Q.tripStartDate as Date) [travel_departure_date],
			CAST(Q.tripEndDate as Date) [travel_return_date],
			isnull(QD.Destination,'') [travel_countries],
			isnull(QP.PromoCode,'') promo_code,
			isnull(Q.quoteExcess,'') excess,
			0 trip_cost,
			try_cast(Q.quoteDisplayPrice as money) total_premium,
			IsNull(QA.[base],0) base_premium,
			0 medical_premium,
			IsNull(QA.[EMC],0) emc_premium,
			IsNull(QA.[CRS],0) cruise_premium,
			IsNull(QA.[LUGG],0) luggage_premium,
			IsNull(QA.[WNTS],0) winter_sport_premium,
			0 business_premium,
			0 age_cover_premium,
			IsNull(QA.[RTCR],0) rental_car_premium,
			IsNull(QA.[MTCL],0) motorcycle_premium,
			isNull((try_cast(Q.quoteDisplayPrice as money) -
					IsNull(QA.[base],0) -
					IsNull(QA.[EMC],0) -
					IsNull(QA.[CRS],0) -
					IsNull(QA.[LUGG],0) -
					IsNull(QA.[WNTS],0) -
					IsNull(QA.[RTCR],0) -
					IsNull(QA.[MTCL],0)
					),0)  other_packs_premium,
			IsNull(QPA.DiscountedAmount,0) discount
        into 
            #quote
        From
			impQuotes Q
			inner join impQuoteTravellers T
				on T.QuoteSK = Q.BIRowID
					AND T.PrimaryTraveller = 'True'
			inner join [db-au-cba].dbo.cdgBusinessUnit bu 
				on Q.businessUnitID = bu.businessUnitID
			left join penOutlet po 
				ON Q.issuerAffiliateCode = po.AlphaCode 
					AND po.OutletStatus = 'Current'
			outer apply 
			(
				select 
					COUNT(*) as TravellerCount
				FROM 
					impQuoteTravellers QT
				where 
					Q.BIRowID = QT.QuoteSK
			) QT
			outer apply
			(
				select 
					top 1 
					QD.Destination
				FROM 
					impQuoteDestinations QD 
				WHERE 
					QD.QuoteSK = Q.BIRowID 
			) QD
			outer apply 
			(
				select 
					Top 1
					P.PromoCode
				from 
					impQuotePromo P
				where 
					Q.BIRowID = P.QuoteSK
				Order By
					P.PromoOrder
			) QP
			LEFT JOIN (
						select 
							QuoteSK, 
							[BASE],
							[CANX],
							[CRS],
							[ELEC],
							[EMC],
							[EMCT1],
							[EMCT2],
							[EMCT3],
							[EMCT4],
							[LUGG],
							[MTCL],
							[RTCR],
							[SSB],
							[SSBE],
							[TAX],
							[TCKT],
							[WNTS]
						from 
							(select 
								QuoteSK, 
								AddonCode, 
								LineDiscountedGross 
							from 
								impQuotePolicyAddons) src
								pivot(
										SUM(LineDiscountedGross)
										FOR AddonCode IN ([BASE],[CANX],[CRS],[ELEC],[EMC],[EMCT1],[EMCT2],[EMCT3],[EMCT4],[LUGG],[MTCL],[RTCR],[SSB],[SSBE],[TAX],[TCKT],[WNTS])
									) pvt
						) QA 
				ON Q.BIRowID = QA.QuoteSK
			outer apply 
			(
				select 
					SUM(QPA.lineGrossPrice - QPA.lineDiscountedGross) as DiscountedAmount
				from 
					impQuotePolicyAddons QPA
				WHERE 
					Q.BIRowID = QPA.QuoteSK
			) QPA
			outer apply
			(
				select
					top 1
					p.Policykey,
					isnull(p.ExternalReference,'') ExternalReference
				From
					penPolicy p
					inner join impPolicies ip
						on p.POlicyKey = ip.POlicyKey
				Where
					ip.QuoteSK = q.BIRowID
			) p
			outer apply
			(
				select top 1
					isnull(pt.PIDValue,'') PIDValue
				From
					penPOlicyTraveller pt
				where
					pt.PolicyKey = p.PolicyKey
					and pt.isPrimary = 1
			) pt
        where
            T.memberId is not null
			AND dbo.xfn_ConvertUTCToLocal(Q.quoteDateUTC,'AUS Eastern Standard Time') >= @start 
			and dbo.xfn_ConvertUTCToLocal(Q.quoteDateUTC,'AUS Eastern Standard Time') < dateadd(day, 1, @end)
			and bu.Partner = 'Commonwealth Bank'
			AND 
			(
				(
					@Group = 'CB' and
					bu.BusinessUnit in ('Commonwealth Bank', 'CBA-Cardholder', 'CBA-WL')
				) or
				(
					@Group = 'BW' and
					bu.BusinessUnit in ('Bank West')
				) 
			)
			AND Bu.Domain = 'AU'



        --delete existing data from current batch (just in case)
        delete
        from
            [db-au-cba].[dbo].[usrTDS_Quote]
        where
            BatchID = @batchid


        insert Into [db-au-cba].[dbo].[usrTDS_Quote]
        (
            BatchID,
            quote_reference,
            quote_date,
			travel_insurance_ref_id,
            hashed_cif_id,
            type_code,
            initiating_channel_code,
            csr_reference,
            travel_departure_date,
            travel_return_date,
            travel_countries,
            promo_code,
            excess,
            trip_cost,
            total_premium,
            base_premium,
            medical_premium,
            emc_premium,
            cruise_premium,
            luggage_premium,
            winter_sport_premium,
            business_premium,
            age_cover_premium,
            rental_car_premium,
            motorcycle_premium,
            other_packs_premium,
            discount
        )
        select
            @batchid,
            quote_reference,
            quote_date,
			travel_insurance_ref_id,
            hashed_cif_id,
            type_code,
            initiating_channel_code,
            csr_reference,
            travel_departure_date,
            travel_return_date,
            travel_countries,
            promo_code,
            excess,
            trip_cost,
            total_premium,
            base_premium,
            medical_premium,
            emc_premium,
            cruise_premium,
            luggage_premium,
            winter_sport_premium,
            business_premium,
            age_cover_premium,
            rental_car_premium,
            motorcycle_premium,
            other_packs_premium,
            discount
        from
            #quote

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'TDS Quote failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @spname

    end catch

    if @@trancount > 0
        commit transaction 

--putting all the field, including travel_insurance_ref_id into temp table for final export
    if object_id('tempdb..#quotefinal') is not null
        drop table #quotefinal

    select
        quote_reference,
        quote_date,
        travel_insurance_ref_id,
        hashed_cif_id,
        type_code,
        initiating_channel_code,
        csr_reference,
        travel_departure_date,
        travel_return_date,
        travel_countries,
        promo_code,
        excess,
        trip_cost,
        total_premium,
        base_premium,
        medical_premium,
        emc_premium,
        cruise_premium,
        luggage_premium,
        winter_sport_premium,
        business_premium,
        age_cover_premium,
        rental_car_premium,
        motorcycle_premium,
        other_packs_premium,
        discount
    into
        #quotefinal
    from
        [db-au-cba].[dbo].[usrTDS_Quote]
    Where
        batchid = @batchid

    --Formatter for file
    declare
        @dlt varchar(1),
        @recordcount int,
        @timestamp datetime,
        @version char(3),
        @name varchar(50),
        @Outputfilename varchar(100),
        @OutputPath varchar(200)

    declare
        @dump table
            (
                LineID int not null identity(1,1),
                Data nvarchar(max)
            )
            
    select 
        @version = Package_Status
    from
        [db-au-log]..Package_Run_Details
    where
        Batch_ID = @batchid and
        Package_ID = '[FILE_VERSION]'

    select 
        @OutputPath = Package_Status
    from
        [db-au-log]..Package_Run_Details
    where
        Batch_ID = @batchid and
        Package_ID = '[OUTPUT_PATH]'

    --constants
    set @dlt = '|'
    set @timestamp = getdate()
    set @name = 'COVERMORE_TRAVEL_INS_QUOTES'

    set @version = isnull(@version, '001')
    set @OutputPath = isnull(@OutputPath, 'E:\ETL\Data\CBA\')
    set @Outputfilename = @name + '_' + convert(varchar, @timestamp, 112) + '_' + @version + '.DAT'



    select 
        @recordcount = count(*) 
    from 
        #quotefinal


    --header
    insert into @dump(Data)
    select
        'H' + @dlt +                                                --header record type
        @name + @dlt +                                              --File Name
        convert(varchar, @timestamp, 112) + @dlt +                  --Business date
        convert(varchar, @version)                                  

    --detail
    insert into @dump(Data)
    select
        'D' + @dlt + 
        isnull(convert(varchar,quote_reference),'') + @dlt + 
        isnull(convert(varchar,quote_date,112),'') + @dlt + 
        isnull(convert(varchar,travel_insurance_ref_id),'') + @dlt + 
        isnull(convert(varchar,hashed_cif_id),'') + @dlt + 
        isnull(convert(varchar,type_code),'') + @dlt + 
        isnull(convert(varchar,initiating_channel_code),'') + @dlt + 
        isnull(convert(varchar,csr_reference),'') + @dlt + 
        isnull(convert(varchar,travel_departure_date,112),'') + @dlt + 
        isnull(convert(varchar,travel_return_date,112),'') + @dlt + 
        isnull(convert(varchar,travel_countries),'') + @dlt + 
        isnull(convert(varchar,promo_code),'') + @dlt + 
        isnull(convert(varchar,excess),'') + @dlt + 
        isnull(convert(varchar,trip_cost),'') + @dlt + 
        isnull(convert(varchar,total_premium),'') + @dlt + 
        isnull(convert(varchar,base_premium),'') + @dlt + 
        isnull(convert(varchar,medical_premium),'') + @dlt + 
        isnull(convert(varchar,emc_premium),'') + @dlt + 
        isnull(convert(varchar,cruise_premium),'') + @dlt + 
        isnull(convert(varchar,luggage_premium),'') + @dlt + 
        isnull(convert(varchar,winter_sport_premium),'') + @dlt + 
        isnull(convert(varchar,business_premium),'') + @dlt + 
        isnull(convert(varchar,age_cover_premium),'') + @dlt + 
        isnull(convert(varchar,rental_car_premium),'') + @dlt + 
        isnull(convert(varchar,motorcycle_premium),'') + @dlt + 
        isnull(convert(varchar,other_packs_premium),'') + @dlt + 
        isnull(convert(varchar,discount),'')
    from 
        #quotefinal


    --trailer
    insert into @dump(Data)
    select
        'T' + @dlt +
        convert(varchar,@recordcount)

    --To check output data, path and file name
    --select 
    --       Data,
    --       @Outputfilename OutputFileName,
    --    @OutputPath OutputPath
    --   from
    --       @dump
    --   order by
    --       LineID

    if object_id('[db-au-workspace].dbo.TDSQuote_Output') is null
        select 
            data, 
            LineID 
        into [db-au-workspace].dbo.TDSQuote_Output 
        from 
            @dump 

    --select * from [db-au-workspace].dbo.TDSQuote_Output order by LineID

    declare @SQL varchar(8000)

    --output data file
    select @SQL = 'bcp "select Data from [db-au-workspace].dbo.TDSQuote_Output order by LineID" queryout "'+ @OutputPath + @Outputfilename + '" -c -t -T -S AZSYDDWH02 -r "0x0A"'

    --select @SQL

    execute master.dbo.xp_cmdshell @SQL

    drop table [db-au-workspace].dbo.TDSQuote_Output

    exec syssp_genericerrorhandler
        @LogToTable = 1,
        @ErrorCode = '0',
        @BatchID = @batchid,
        @PackageID = @Outputfilename,
        @LogInsertCount = @recordcount,
        @SourceTable = '[METADATA]'
end
GO
