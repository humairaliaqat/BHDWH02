USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rawsp_cba_usrTDS_Policy_20230424]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
  
CREATE procedure [dbo].[rawsp_cba_usrTDS_Policy_20230424]  
    @Group varchar(5) = 'CB',  
    @OverrideStart date = null,  
    @OverrideEnd date = null  
  
as  
begin  
  
/****************************************************************************************************/  
--  Name:           rawsp_cba_usrTDS_Policy  
--  Author:         Saurabh Date  
--  Date Created:   20180816  
--  Description:    Inserts CBA policy records into the CBA usrTDS_Policy table for the TDS exports  
--                      
--  Parameters:     @batchid: required.   
--                    
--  Change History:   
--                  20180816 - SD - Created  
--                  20180817 - SD - Changed vesion from one digit (1,2,3) to 3 digit value (001,002,003) and also added it ot the file name. Also changed travel countries to show ISO3 Code  
--                  20180821 - SD - Changed row eliminator to "0X0A", which will remove carriage return and have only new line character.  
--                  20180822 - SD - Added Hashed CIF ID  
--                  20180918 - SD - Added card_no (no mapping yet, just added the field)  
--                  20180919 - SD - Adjusted for CBA db structure, also done batch handling  
--     20180928 - SD - Adjusted Quote reference, CSR Reference adn Initiating channel code mapping  
--                  20190306 - LL - REQ-1014,   
--                                  modify channel  
--                                  modify card number  
--                                  modify transaction id  
--                                  add product name column (still empty at the moment)  
--                  20190307 - LL - modify crm user, get refrence from base policy  
--                                  modify initiating channel, trust recorded data when available otherwise apply logic  
--                  20190308 - SD - Removed Product Name  
--                  20190315 - LL - change the external reference stored format  
--     20190329 - SD - Check for travel insurance Ref ID, and change it to blank if length is not equal to 36  
--                  20190409 - LL - handle old style external reference  
--     20190507 - SD - Changed the lookup on impPolicies to be based on 'PolicyNumber', instead of 'PolicyKey'  
/****************************************************************************************************/  
  
--CBA TDS, logic: All policy details having postingdate on day - 1  
  
  
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
  
    if object_id('[db-au-cba].[dbo].[usrTDS_Policy]') is null  
    begin  
      
        create table [db-au-cba].[dbo].[usrTDS_Policy]  
        (  
            BIRowID bigint not null identity(1,1),  
            BatchID int,  
            travel_insurance_ref_id varchar(50),  
            travel_departure_date datetime not null,  
            travel_return_date datetime not null,  
            travel_countries varchar(200) not null,  
            policy_number varchar(20) not null,  
            hashed_cif_id varchar(255),  
            card_no varchar(20),  
            product_name varchar(20),  
            quote_reference varchar(50),  
            policy_status_code varchar(10) not null,  
            type_code varchar(50) not null,  
            promo_code varchar(20),  
            total_premium money,  
          total_cost_to_cba money,  
            commission money,  
            gst money,  
            stamp_duty money,  
            commission_gst money,  
            commission_stamp_duty money,  
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
            discount money,  
            policy_count int,  
            policy_pack_count int,  
            initiating_channel_code varchar(10),  
            csr_reference varchar(50),  
            customer_group_name varchar(100),  
            customer_travel_group varchar(15),  
            excess money,  
            trip_cost money,  
            issued_date datetime not null  
        )  
          
        create unique clustered index ucidx_usrTDS_Policy on [db-au-cba].[dbo].[usrTDS_Policy](BIRowID)  
        create nonclustered index idx_usrTDS_Policy_BatchID on [db-au-cba].[dbo].[usrTDS_Policy](BatchID)  
  
    end  
  
    begin transaction   
  
    begin try  
  
          
        if object_id('tempdb..#policy') is not null  
            drop table #policy  
  
        select   
            case  
                --AU-BW-718100398019   
                --ff69366d-2327-464b-84d7-3b38e49700e5  
                --AU-CB-ff69366d-2327-464b-84d7-3b38e49700e5  
                when sti.saved_tid <> '' and sti.saved_tid <> p.PolicyNumber then sti.saved_tid  
                else isnull(pq.PartnerTransactionID, '')   
            end [travel_insurance_ref_id],  
   p.TripStart [travel_departure_date],  
   p.TripEnd [travel_return_date],  
   Case  
    When right(rtrim((  
         select top 50 --maximum length of field / 4  
          c.ISO3Code +   
          case  
           when pd.DestinationOrder = max(pd.DestinationOrder) over () then ''  
           else ','  
          end  
         from  
          penPolicyDestination pd  
          outer apply  
          (  
           select top 1   
            ISO3Code  
           from  
            penCountry c  
           where  
            c.CountryKey = pd.CountryKey and  
            (  
             c.CountryID = pd.CountryID or  
             (  
              pd.CountryID is null and  
              c.CountryName = pd.Destination  
             )  
            )  
          ) c  
         where  
          pd.PolicyKey = p.PolicyKey  
         order by pd.DestinationOrder  
         for xml path('')  
        )),1) = ',' then substring(rtrim((  
                 select top 50 --maximum length of field / 4  
                  c.ISO3Code +   
                  case  
                   when pd.DestinationOrder = max(pd.DestinationOrder) over () then ''  
                   else ','  
                  end  
                 from  
                  penPolicyDestination pd  
                  outer apply  
                  (  
                   select top 1   
                    ISO3Code  
                   from  
                    penCountry c  
                   where  
                    c.CountryKey = pd.CountryKey and  
                    (  
                     c.CountryID = pd.CountryID or  
                     (  
                      pd.CountryID is null and  
                      c.CountryName = pd.Destination  
                     )  
                    )  
                  ) c  
                 where  
                  pd.PolicyKey = p.PolicyKey  
                 order by pd.DestinationOrder  
                 for xml path('')  
                )),1,len(rtrim((  
                    select top 50 --maximum length of field / 4  
                     c.ISO3Code +   
                     case  
                      when pd.DestinationOrder = max(pd.DestinationOrder) over () then ''  
                      else ','  
                     end  
                    from  
                     penPolicyDestination pd  
                     outer apply  
                     (  
                      select top 1   
                       ISO3Code  
                      from  
                       penCountry c  
                      where  
                       c.CountryKey = pd.CountryKey and  
                       (  
                        c.CountryID = pd.CountryID or  
                        (  
                         pd.CountryID is null and  
                         c.CountryName = pd.Destination  
                        )  
                       )  
                     ) c  
                    where  
                     pd.PolicyKey = p.PolicyKey  
                    order by pd.DestinationOrder  
                    for xml path('')  
                   )))-1)  
    Else  
     isnull((  
      select top 50 --maximum length of field / 4  
       c.ISO3Code +   
       case  
        when pd.DestinationOrder = max(pd.DestinationOrder) over () then ''  
        else ','  
       end  
      from  
       penPolicyDestination pd  
       outer apply  
       (  
        select top 1   
         ISO3Code  
        from  
         penCountry c  
        where  
         c.CountryKey = pd.CountryKey and  
         (  
          c.CountryID = pd.CountryID or  
          (  
           pd.CountryID is null and  
           c.CountryName = pd.Destination  
          )  
         )  
       ) c  
      where  
       pd.PolicyKey = p.PolicyKey  
      order by pd.DestinationOrder  
      for xml path('')  
     ),'')   
   End [travel_countries],  
   isnull(p.PolicyNumber,'') [policy_number],  
   isnull(pt.PIDValue,'') [hashed_cif_id],  
   isnull(pkv.BINNumber, '') [card_no],  
            '' product_name,  
   isnull(pq.QuoteReference,'') [quote_reference],  
   isnull(Case      
    When p.StatusDescription = 'Active' then 'A'  
    when p.StatusDescription = 'Cancelled' then 'C'  
   End,'') [policy_status_code],  
   isnull(Case  
      When po.SubGroupName like '%Whitelabel%' then 'WL'  
      When po.SubGroupName like '%NAC%' then 'NAC'  
     End,'') [type_code],  
   isnull(pro.PromoCode,'') [promo_code],  
   sum(isnull(pts.GrossPremium,0)) [total_premium],  
   (sum(isnull(pts.GrossPremium,0)) - sum(isnull(pts.Commission,0)) - sum(isnull(pts.GrossAdminFee,0))) [total_cost_to_cba],  
   (sum(isnull(pts.Commission,0)) + sum(isnull(pts.GrossAdminFee,0))) [commission],  
   sum(isnull(pts.TaxAmountGST,0)) [gst],  
   sum(isnull(pts.TaxAmountSD,0)) [stamp_duty],  
   sum(isnull(pts.TaxOnAgentCommissionGST,0)) [commission_gst],  
   sum(isnull(pts.TaxOnAgentCommissionSD,0)) [commission_stamp_duty],  
   (sum(isnull(pts.GrossPremium,0)) - sum(isnull(pts.TaxAmountGST,0)) - sum(isnull(pts.TaxAmountSD,0))) [base_premium],  
   sum(isnull(pta.MedicalGrossPremium,0)) [medical_premium],  
   sum(isnull(pta.EMCGroupGrossPremium,0)) [emc_premium],  
   sum(isnull(pta.CruiseGrossPremium,0)) [cruise_premium],  
   sum(isnull(pta.LuggageGrossPremium,0)) [luggage_premium],  
   sum(isnull(pta.WinterSportGrossPremium,0)) [winter_sport_premium],  
   sum(isnull(pta.BusinessGrossPremium,0)) [business_premium],  
   sum(isnull(pta.AgeCoverGrossPremium,0)) [age_cover_premium],  
   sum(isnull(pta.RentalCarGrossPremium,0)) [rental_car_premium],  
   sum(isnull(pta.MotorcycleGrossPremium,0)) [motorcycle_premium],  
   sum(isnull(pta.OtherPacksGrossPremium,0)) [other_packs_premium],  
   (sum(isnull(pts.UnAdjGrossPremium,0)) - sum(isnull(pts.GrossPremium,0))) [discount],  
   sum(isnull(pts.BasePolicyCount,0)) [policy_count],  
   sum(isnull(pts.AddonPolicyCount,0)) [policy_pack_count],  
            case  
                when pq.cbaChannelID is not null then pq.cbaChannelID  
                when crm.CRMUserID <> '' then 'CMPHONE'   
                else 'CBAWEB'   
            end [initiating_channel_code],  
   isnull(crm.CRMUserID,'') [csr_reference],  
   '' [customer_group_name],  
   Case  
    When sum(pts.TravellersCount) = 1 then 'Single'  
    When sum(pts.TravellersCount) = 2 then 'Couple'  
    When sum(pts.TravellersCount) > 2 and sum(pts.TravellersCount) <=6 then 'Family'  
    When sum(pts.TravellersCount) > 6 then 'Group'  
    Else 'Single'  
   End [customer_travel_group],  
   isnull(p.Excess,'') [excess],  
   isnull(p.TripCost,'') [trip_cost],  
   p.IssueDate [issued_date]  
        Into   
            #policy  
        from   
            penPolicy p  
            cross apply  
            (  
                select  
                    --rtrim(replace(p.ExternalReference, p.CountryKey + '-' + left(p.AlphaCode, 2) + '-', '')) saved_tid  
                    rtrim  
                    (  
                        replace  
                        (  
                            replace  
                            (  
                                p.ExternalReference,   
                                p.PolicyNumber + '-' + p.CountryKey + '-' + left(p.AlphaCode, 2) + '-',   
                                ''  
                            ),  
                            p.CountryKey + '-' + left(p.AlphaCode, 2) + '-' + p.PolicyNumber,  
                            ''  
                        )  
                    ) saved_tid  
            ) sti  
   inner join penOutlet po  
    on p.OutletAlphaKey = po.OutletAlphaKey  
   inner join penPolicyTransSummary pts  
    on pts.PolicyKey = p.PolicyKey  
   inner join (select  
       PolicyKey  
      From  
       penPolicyTransSummary pts2  
      Where  
       pts2.PostingDate >= @start  
       and pts2.PostingDate < dateadd(day, 1, @end)  
      ) pts2  
    on pts2.PolicyKey = p.PolicyKey  
   inner join penPolicyTraveller pt  
    on pt.PolicyKey = p.Policykey  
     and pt.isPrimary = 1  
   outer apply  
   (  
    select top 1  
     isnull(Convert(varchar(50),crm.CRMUserID),'') CRMUserID  
    From  
     penPolicyTransSummary crm  
    where  
     crm.PolicyKey = p.PolicyKey  
    order by  
     crm.IssueDate --base policy  
   ) crm  
   Outer Apply  
   (  
    select top 1  
     pq.QuoteID QuoteReference,  
                    pq.cbaChannelID,  
                    q.PartnerTransactionID  
    From   
     impPolicies pq  
                    left join impQuotes q on  
                        q.QuoteID = pq.QuoteID  
    Where  
     pq.PolicyNumber = p.PolicyNumber  
   ) pq  
   outer apply  
   (  
    select top 1  
     pro.PromoCode  
    From  
     penPolicyTransSummary r  
     inner join penPolicyTransactionPromo pro on  
      pro.PolicyTransactionKey = r.PolicyTransactionKey  
    Where  
     r.PolicyKey = p.PolicyKey and  
     r.TransactionType = 'Base' and  
     r.TransactionStatus = 'Active' and  
     pro.IsApplied = 1  
    order By  
     pro.ApplyOrder  
   ) pro  
   outer apply  
   (  
   select   
    sum(  
     case  
      when AddOnGroup = 'Winter Sport' then GrossPremium  
      else 0  
     end  
    ) WinterSportGrossPremium,  
    sum(  
     case  
      when AddOnGroup = 'Rental Car' then GrossPremium  
      else 0  
     end  
    ) RentalCarGrossPremium,  
    sum(  
     case  
      when AddOnGroup = 'Motorcycle' then GrossPremium  
      else 0  
     end  
    ) MotorcycleGrossPremium,  
    sum(  
     case  
      when AddOnGroup = 'Luggage' then GrossPremium  
      else 0  
     end  
    ) LuggageGrossPremium,  
    sum(  
     case  
      when AddOnGroup = 'Medical' then GrossPremium  
      else 0  
     end  
    ) MedicalGrossPremium,  
    sum(  
     case  
      when AddOnGroup = 'Cruise' then GrossPremium  
      else 0  
     end  
    ) CruiseGrossPremium,  
    sum(  
     case when AddonGroup = 'Business' then GrossPremium  
       else 0  
     end  
    ) BusinessGrossPremium,  
    sum(  
     case when AddonGroup = 'EMC Group' then GrossPremium  
       else 0  
     end  
    ) EMCGroupGrossPremium,  
    sum(  
     case when AddonGroup = 'Age Cover' then GrossPremium  
       else 0  
     end  
    ) AgeCoverGrossPremium,  
    sum(  
     case when AddonGroup not in ('Winter Sport','Rental Car','Motorcycle','Luggage','Medical','Cruise','Business','EMC Group','Age Cover') then GrossPremium  
       else 0  
     end  
    ) OtherPacksGrossPremium  
   from  
    penPolicyTransAddOn pta  
   where  
    pts.PolicyTransactionKey = pta.PolicyTransactionKey  
   ) pta  
            outer apply  
            (  
                select top 1   
                    pkv.KeyValue BINNumber  
                from  
                    penPolicyKeyValues pkv  
                where  
                    pkv.PolicyKey = p.PolicyKey and  
                    pkv.ValueType = 'BINNUMBER'  
            ) pkv  
        where  
            po.OutletStatus = 'Current'   
   and po.GroupCode = @group  
        Group By  
            case  
                when sti.saved_tid <> '' and sti.saved_tid <> p.PolicyNumber then sti.saved_tid  
                else isnull(pq.PartnerTransactionID, '')   
            end,  
   p.PolicyKey,  
   p.TripStart,  
   p.TripEnd,  
   p.PolicyNumber,  
   pt.PIDValue,  
            isnull(pkv.BINNumber, ''),  
   pq.QuoteReference,  
   isnull(Case      
    When p.StatusDescription = 'Active' then 'A'  
    when p.StatusDescription = 'Cancelled' then 'C'  
   End,''),  
   isnull(Case  
      When po.SubGroupName like '%Whitelabel%' then 'WL'  
      When po.SubGroupName like '%NAC%' then 'NAC'  
   End,''),  
   p.StatusDescription,  
   p.ProductName,  
   pro.PromoCode,  
   po.AlphaCode,  
   p.Excess,  
   p.TripCost,  
   p.IssueDate,  
            case   
                when pq.cbaChannelID is not null then pq.cbaChannelID  
                when crm.CRMUserID <> '' then 'CMPHONE'   
                else 'CBAWEB'   
            end,  
   isnull(crm.CRMUserID,'')  
  
  
delete from #policy where Policy_Number in ('723200010407','723200010409','723200010408')
        --delete existing data from current batch (just in case)  
        delete  
        from  
            [db-au-cba].[dbo].[usrTDS_Policy]  
        where  
            BatchID = @batchid  
  
  
        Insert Into [db-au-cba].[dbo].[usrTDS_Policy]  
        (  
            BatchID,  
            travel_insurance_ref_id,  
            travel_departure_date,  
            travel_return_date,  
            travel_countries,  
            policy_number,  
            hashed_cif_id,  
            card_no,  
            product_name,  
            quote_reference,  
            policy_status_code,  
            type_code,  
            promo_code,  
            total_premium,  
            total_cost_to_cba,  
            commission,  
            gst,  
            stamp_duty,  
            commission_gst,  
            commission_stamp_duty,  
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
            discount,  
            policy_count,  
            policy_pack_count,  
            initiating_channel_code,  
            csr_reference,  
            customer_group_name,  
            customer_travel_group,  
            excess,  
            trip_cost,  
            issued_date  
        )  
        select  
            @batchid,  
            travel_insurance_ref_id,  
            travel_departure_date,  
            travel_return_date,  
            travel_countries,  
            policy_number,  
            hashed_cif_id,  
            card_no,  
            product_name,  
            quote_reference,  
            policy_status_code,  
            type_code,  
            promo_code,  
            total_premium,  
            total_cost_to_cba,  
            commission,  
            gst,  
            stamp_duty,  
            commission_gst,  
            commission_stamp_duty,  
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
            discount,  
            policy_count,  
            policy_pack_count,  
            initiating_channel_code,  
            csr_reference,  
            customer_group_name,  
            customer_travel_group,  
            excess,  
            trip_cost,  
            issued_date  
        from  
            #policy  
  
    end try  
  
    begin catch  
  
        if @@trancount > 0  
            rollback transaction  
          
        exec syssp_genericerrorhandler  
            @SourceInfo = 'TDS Policy failed',  
            @LogToTable = 1,  
            @ErrorCode = '-100',  
            @BatchID = @batchid,  
            @PackageID = @spname  
   
  
    end catch  
  
    if @@trancount > 0  
        commit transaction   
  
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
    set @name = 'COVERMORE_TRAVEL_INS_POLICIES'  
  
    set @version = isnull(@version, '001')  
    set @OutputPath = isnull(@OutputPath, 'E:\ETL\Data\CBA\')  
    set @Outputfilename = @name + '_' + convert(varchar, @timestamp, 112) + '_' + @version + '.DAT'  
  
  
 --Capturing all the travel insurance ref ID with changes   
 if object_id('tempdb..#travel_ins_ref_id') is not null  
        drop table #travel_ins_ref_id  
  
 select   
  count(*) RecordCount,  
  travel_insurance_ref_id  
 Into   
  #travel_ins_ref_id  
 from  
  #policy   
   
 Where  
  len(travel_insurance_ref_id) = 36   
 group by   
  travel_insurance_ref_id  
 having   
  count(*) > 1  
     
      
  
    --putting all the field, including travel_insurance_ref_id into temp table for final export  
    if object_id('tempdb..#policyfinal') is not null  
        drop table #policyfinal  
 select  
  distinct  
        p2.travel_insurance_ref_id,  
        p2.travel_departure_date,  
        p2.travel_return_date,  
        p2.travel_countries,  
        p2.policy_number,  
        p2.hashed_cif_id,  
        p2.card_no,  
        p2.product_name,  
        p2.quote_reference,  
        p2.policy_status_code,  
        p2.type_code,  
        p2.promo_code,  
        p2.total_premium,  
        p2.total_cost_to_cba,  
        p2.commission,  
        p2.gst,  
        p2.stamp_duty,  
        p2.commission_gst,  
        p2.commission_stamp_duty,  
        p2.base_premium,  
        p2.medical_premium,  
        p2.emc_premium,  
        p2.cruise_premium,  
        p2.luggage_premium,  
        p2.winter_sport_premium,  
        p2.business_premium,  
        p2.age_cover_premium,  
        p2.rental_car_premium,  
        p2.motorcycle_premium,  
        p2.other_packs_premium,  
        p2.discount,  
        p2.policy_count,  
        p2.policy_pack_count,  
        p2.initiating_channel_code,  
        p2.csr_reference,  
        p2.customer_group_name,  
        p2.customer_travel_group,  
        p2.excess,  
        p2.trip_cost,  
        p2.issued_date  
 Into  
        #policyfinal  
    from  
        [db-au-cba].[dbo].[usrTDS_Policy] p1  
  outer apply  
  (  
   select top 1  
    p2.travel_insurance_ref_id,  
    p2.travel_departure_date,  
    p2.travel_return_date,  
    p2.travel_countries,  
    p2.policy_number,  
    p2.hashed_cif_id,  
    p2.card_no,  
    p2.product_name,  
    p2.quote_reference,  
    p2.policy_status_code,  
    p2.type_code,  
    p2.promo_code,  
    p2.total_premium,  
    p2.total_cost_to_cba,  
    p2.commission,  
    p2.gst,  
    p2.stamp_duty,  
    p2.commission_gst,  
    p2.commission_stamp_duty,  
    p2.base_premium,  
    p2.medical_premium,  
    p2.emc_premium,  
    p2.cruise_premium,  
    p2.luggage_premium,  
    p2.winter_sport_premium,  
    p2.business_premium,  
    p2.age_cover_premium,  
    p2.rental_car_premium,  
    p2.motorcycle_premium,  
    p2.other_packs_premium,  
    p2.discount,  
    p2.policy_count,  
    p2.policy_pack_count,  
    p2.initiating_channel_code,  
    p2.csr_reference,  
    p2.customer_group_name,  
    p2.customer_travel_group,  
    p2.excess,  
    p2.trip_cost,  
    p2.issued_date  
   From  
    [db-au-cba].[dbo].[usrTDS_Policy] p2  
   where  
    batchid = @batchid  
    and p2.travel_insurance_ref_id = p1.travel_insurance_ref_id  
   order by  
    issued_date desc  
  ) p2  
    Where  
        batchid = @batchid  
  and len(p1.travel_insurance_ref_id) = 36  
  and p1.travel_insurance_ref_id in (select travel_insurance_ref_id from #travel_ins_ref_id)  
  
Union  
  
select  
        travel_insurance_ref_id,  
        travel_departure_date,  
        travel_return_date,  
        travel_countries,  
        policy_number,  
        hashed_cif_id,  
        card_no,  
        product_name,  
        quote_reference,  
        policy_status_code,  
        type_code,  
        promo_code,  
        total_premium,  
        total_cost_to_cba,  
        commission,  
        gst,  
        stamp_duty,  
        commission_gst,  
        commission_stamp_duty,  
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
        discount,  
        policy_count,  
        policy_pack_count,  
        initiating_channel_code,  
        csr_reference,  
        customer_group_name,  
        customer_travel_group,  
        excess,  
        trip_cost,  
        issued_date  
    from  
  [db-au-cba].[dbo].[usrTDS_Policy]  
    Where  
        batchid = @batchid  
  and len(travel_insurance_ref_id) = 36  
  and travel_insurance_ref_id not in (select travel_insurance_ref_id from #travel_ins_ref_id)  
  
Union  
  
select  
        travel_insurance_ref_id,  
        travel_departure_date,  
        travel_return_date,  
        travel_countries,  
        policy_number,  
        hashed_cif_id,  
        card_no,  
        product_name,  
        quote_reference,  
        policy_status_code,  
        type_code,  
        promo_code,  
        total_premium,  
        total_cost_to_cba,  
        commission,  
        gst,  
        stamp_duty,  
        commission_gst,  
        commission_stamp_duty,  
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
        discount,  
        policy_count,  
        policy_pack_count,  
        initiating_channel_code,  
        csr_reference,  
        customer_group_name,  
        customer_travel_group,  
        excess,  
        trip_cost,  
        issued_date  
    from  
  [db-au-cba].[dbo].[usrTDS_Policy]  
    Where  
        batchid = @batchid  
  and len(travel_insurance_ref_id) <> 36  
  
  
    select   
        @recordcount = count(*)   
    from   
        #policyfinal  
  
  
    --header  
    insert into @dump(Data)  
    select  
        'H' + @dlt +                                                   --header record type  
        @name + @dlt +                                                 --File Name  
        convert(varchar, @timestamp, 112) + @dlt +                    --Business date  
        convert(varchar, @version)  
  
    --detail  
    insert into @dump(Data)  
    select  
        'D' + @dlt +   
        Case   
   when len(travel_insurance_ref_id) <> 36 then ''  
   Else isnull(travel_insurance_ref_id,'')  
  End + @dlt +   
        isnull(convert(varchar,travel_departure_date,112),'') + @dlt +   
        isnull(convert(varchar,travel_return_date,112),'') + @dlt +   
        isnull(travel_countries,'') + @dlt +   
        isnull(policy_number,'') + @dlt +   
        isnull(hashed_cif_id,'') + @dlt +   
        isnull(card_no,'') + @dlt +   
        --isnull(product_name,'') + @dlt +   
        isnull(quote_reference,'') + @dlt +   
        isnull(policy_status_code,'') + @dlt +   
        isnull(type_code,'') + @dlt +   
        isnull(promo_code,'') + @dlt +   
        isnull(convert(varchar,total_premium),'') + @dlt +   
        isnull(convert(varchar,total_cost_to_cba),'') + @dlt +   
        isnull(convert(varchar,commission),'') + @dlt +   
        isnull(convert(varchar,gst),'') + @dlt +   
        isnull(convert(varchar,stamp_duty),'') + @dlt +   
        isnull(convert(varchar,commission_gst),'') + @dlt +   
        isnull(convert(varchar,commission_stamp_duty),'') + @dlt +   
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
        isnull(convert(varchar,discount),'') + @dlt +   
        isnull(convert(varchar,policy_count),'') + @dlt +   
        isnull(convert(varchar,policy_pack_count),'') + @dlt +   
        isnull(initiating_channel_code,'') + @dlt +   
        isnull(csr_reference,'') + @dlt +   
        isnull(customer_group_name,'') + @dlt +   
        isnull(customer_travel_group,'') + @dlt +   
        isnull(convert(varchar,excess),'') + @dlt +   
        isnull(convert(varchar,trip_cost),'') + @dlt +   
        isnull(convert(varchar,issued_date,112),'')  
    from   
        #policyfinal  
  
  
  
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
  
    if object_id('[db-au-workspace].dbo.TDSPolicy_Output') is null  
        select   
            data,   
            LineID   
        into   
            [db-au-workspace].dbo.TDSPolicy_Output   
        from   
            @dump   
  
    --select * from [db-au-workspace].dbo.TDSPolicy_Output order by LineID  
  
    declare @SQL varchar(8000)  
  
  
    --output data file  
    select @SQL = 'bcp "select Data from [db-au-workspace].dbo.TDSPolicy_Output order by LineID" queryout "'+ @OutputPath + @Outputfilename + '" -c -t -T -S AZSYDDWH02 -r "0x0A"'  
  
    --print @SQL  
  
    execute master.dbo.xp_cmdshell @SQL  
  
    drop table [db-au-workspace].dbo.TDSPolicy_Output  
  
    exec syssp_genericerrorhandler  
        @LogToTable = 1,  
        @ErrorCode = '0',  
        @BatchID = @batchid,  
        @PackageID = @Outputfilename,  
        @LogInsertCount = @recordcount,  
        @SourceTable = '[METADATA]'  
  
end  
  
GO
