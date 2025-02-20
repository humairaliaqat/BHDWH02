USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rawsp_cba_usrTDS_Traveller_test_daily]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rawsp_cba_usrTDS_Traveller_test_daily]    
    @Group varchar(5) = 'CB',    
    @OverrideStart date = null,    
    @OverrideEnd date = null    
    
as    
begin    
    
/****************************************************************************************************/    
--  Name:           rawsp_cba_usrTDS_Traveller    
--  Author:         Saurabh Date    
--  Date Created:   20180816    
--  Description:    Inserts CBA Traveller records into the CBA usrTDS_Traveller table for the TDS exports    
--         
--  Parameters:     @batchid: required.     
--                      
--  Change History:     
--                  20180816 - SD - Created    
--     20180817 - SD - Changed vesion from one digit (1,2,3) to 3 digit value (001,002,003) and also added it ot the file name.    
--     20180821 - SD - Changed row eliminator to "0X0A", which will remove carriage return and have only new line character.    
--     20180822 - SD - Removed CIF ID, as we will get Hashed CIF ID only.    
--                  20180919 - LL - adjusted for cba database structure    
--                                  batch handling    
--     20180928 - SD - adjusted structure for quote travellers    
--     20181002 - SD - Removed NUllif from the script    
--     20181012 - SD - Added PolicyNUmber Field    
--     20190326 - SD - Change the character length fro travel_reference_id from 50 to 55, also updated the logic to get the value    
--     20190329 - SD - Check Travel Ref ID, if length is not equal to 36 then change it to blank    
--                  20190409 - LL - handle old style external reference    
--     20190507 - SD - Check the lookup from impPolicies to be based on 'PolicyNumber'    
--     20190516 - SD - Included filter requested by CBA, to exclude quotes with both policy_number and hashed_cif_id empty.     
--     20190516 - SD - Also added logic to lookup quote for travel_insurance_ref_id, if not available in policy    
--                  20191024 - LL - REQ-2338, clean pipe    
/****************************************************************************************************/    
    
--CBA TDS, logic: All traveller details having policy postingdate on day - 1    
    
    
    declare     
        @batchid int,    
        @spname varchar(50),    
        @start date,    
        @end date    
    
    
    --get active batch    
    exec [db-au-stage]..syssp_getrunningbatch    
        @SubjectArea = 'CBA TDS Test',    
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
    
    
    
    
    if object_id('[db-au-cba].[dbo].[usrTDS_Traveller_test]') is null    
    begin    
    
     create table [db-au-cba].[dbo].[usrTDS_Traveller_test]    
     (    
      BIRowID bigint not null identity(1,1),    
      BatchID int,    
   policy_number varchar(20) not null,    
      travel_insurance_ref_id varchar(55),    
      traveller_id varchar(10) not null,    
      hashed_cif_id varchar(255),    
      role_code varchar(15) not null,    
      pre_existing char(1),    
      Title varchar(20),    
      first_name varchar(100),    
      last_name varchar(100),    
      DOB datetime,    
      address_line_1 varchar(100),    
      address_line_2 varchar(100),    
      post_code varchar(50),    
      Suburb varchar(50),    
      State varchar(20),    
      country varchar(50),    
      home_phone varchar(20),    
      work_phone varchar(20),    
      Mobilephone varchar(20),    
      email_address varchar(200),    
      opted_contact varchar(5)    
     )    
            
        create unique clustered index ucidx_usrTDS_Traveller on [db-au-cba].[dbo].[usrTDS_Traveller_test](BIRowID)    
        create nonclustered index idx_usrTDS_Traveller_BatchID on [db-au-cba].[dbo].[usrTDS_Traveller_test](BatchID)    
    
    end    
    
    begin transaction     
    
    begin try    
    
            
        if object_id('tempdb..#traveller') is not null    
            drop table #traveller    
    
  select    
   isnull(p.PolicyNumber,'') [policy_number],     
   case    
                when p.saved_tid <> '' and p.saved_tid <> p.PolicyNumber then p.saved_tid    
    when len(isnull(pq.PartnerTransactionID, '')) = 36 then isnull(pq.PartnerTransactionID, '')     
                else isnull(p.ExternalReference,'')    
            end [travel_insurance_ref_id],    
   isnull(t.memberId,'') [traveller_id],    
   isnull(pt.PIDValue,'') [hashed_cif_id],    
   Case    
    when t.PrimaryTraveller = 'true' then 'PRI'    
    Else 'ADD'    
   End [role_code],    
   Case    
    when isnull(emc.EMCAssessmentID,'') <> '' then 'Y'    
    Else 'N'    
   End [pre_existing],    
   isnull(t.Title,'') [Title],    
   isnull(t.firstName,'') [first_name],    
   isnull(t.lastName,'') [last_name],    
   t.dateOfBirth [DOB],    
   isnull(c.street1,'') [address_line_1],    
   isnull(c.street2,'') [address_line_2],    
   isnull(c.postCode,'') [post_code],    
   isnull(c.suburb,'') [Suburb],    
   isnull(c.state,'') [State],    
   isnull(c.country,'') [country],    
   isnull(hp.number,'') [home_phone],    
   isnull(wp.number,'') [work_phone],    
   isnull(mp.number,'') [Mobilephone],    
   isnull(c.email,'') [email_address],    
   case     
    when optInMarketing = 'false' then 'N'    
    when optInMarketing = 'true' then 'Y'    
   end [opted_contact]    
  Into     
   #traveller    
  from     
   impQuotes_test q    
   inner join impQuoteTravellers_test t    
    on q.BIRowID = t.QuoteSK    
   inner join [db-au-cba].dbo.cdgBusinessUnit bu     
      on q.businessUnitID = bu.businessUnitID    
   left join penOutlet po     
    ON q.issuerAffiliateCode = po.AlphaCode     
     AND po.OutletStatus = 'Current'    
   outer apply     
   (    
    select     
     top 1     
     c.*    
    from     
     impQuoteContact_test c    
    where     
     c.QuoteSK = t.QuoteSK    
   ) c    
   outer apply     
   (    
    select     
     top 1     
     hp.*    
    from     
     impQuoteContactPhone_test hp    
    where     
     hp.QuoteSK = t.QuoteSK    
     and hp.type = 'home'    
     and isnull(hp.number,'') <> ''     
   ) hp    
   outer apply     
   (    
    select     
     top 1     
     mp.*    
    from     
     impQuoteContactPhone_test mp    
    where     
     mp.QuoteSK = t.QuoteSK    
     and mp.type = 'mobile'    
     and isnull(mp.number,'') <> ''     
   ) mp    
   outer apply     
   (    
    select     
     top 1     
     wp.*    
    from     
     impQuoteContactPhone_test wp    
    where     
     wp.QuoteSK = t.QuoteSK    
     and wp.type = 'work'    
     and isnull(wp.number,'') <> ''     
   ) wp    
   outer apply    
   (    
    select    
     top 1    
     emc.*    
    From    
     impQuoteTravellerAddons_test emc    
    Where    
     emc.QuoteSK = t.QuoteSK    
     and emc.TravellerIdentifier = t.TravellerIdentifier    
   ) emc    
   outer apply    
   (    
    select    
     top 1    
     p.PolicyNumber,    
     p.Policykey,    
     p.AlphaCode,    
     p.CountryKey,    
                    p.ExternalReference,    
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
    From    
     penPolicy p    
     inner join impPolicies_test ip    
      on p.PolicyNumber = ip.PolicyNumber    
    Where    
     ip.QuoteSK = q.BIRowID    
   ) p    
   Outer Apply    
   (    
    select top 1    
                    q.PartnerTransactionID    
    From     
     impPolicies_test pq    
                    left join impQuotes_test q on    
                        q.QuoteID = pq.QuoteID    
    Where    
     pq.PolicyNumber = p.PolicyNumber    
   ) pq    
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
  Where    
   T.memberId is not null    
   and dbo.xfn_ConvertUTCToLocal(q.quoteDateUTC,'AUS Eastern Standard Time') >= @start     
   and dbo.xfn_ConvertUTCToLocal(q.quoteDateUTC,'AUS Eastern Standard Time') < dateadd(day, 1, @end)    
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
   --Included below filter on 16/05/2019, as requested by CBA, to exclude quotes with both policy_number and hashed_cif_id empty.    
   AND isnull(isnull(p.PolicyNumber,''), isnull(case    
              when p.saved_tid <> '' and p.saved_tid <> p.PolicyNumber then p.saved_tid    
              else isnull(p.ExternalReference,'')     
             end, '')) <> ''    
    
  Union    
    
  select     
   isnull(p.PolicyNumber,'') [policy_number],    
   case    
                when rtrim(replace(replace(p.ExternalReference, p.PolicyNumber + '-' + p.CountryKey + '-' + left(p.AlphaCode, 2) + '-', ''), p.CountryKey + '-' + left(p.AlphaCode, 2) + '-' + p.PolicyNumber, '')) <> '' and rtrim(replace(replace(p.ExternalReference, p.PolicyNumber + '-' + p.CountryKey + '-' + left(p.AlphaCode, 2) + '-', ''), p.CountryKey + '-' + left(p.AlphaCode, 2) + '-' + p.PolicyNumber, '')) <> p.PolicyNumber then rtrim(replace(replace(p.ExternalReference, p.PolicyNumber + '-' + p.CountryKey + '-' + left(p.AlphaCode, 2) + '-', ''), p.CountryKey + '-' + left(p.AlphaCode, 2) + '-' + p.PolicyNumber, ''))    
    when len(isnull(pq.PartnerTransactionID, '')) = 36 then isnull(pq.PartnerTransactionID, '')     
                else isnull(p.ExternalReference,'')    
            end [travel_insurance_ref_id],    
   isnull(pt.MemberNumber,'') [traveller_id],    
   isnull(pt2.PIDValue,'') [hashed_cif_id],    
   case     
    when pt.isPrimary = 1 then 'PRI'    
    else 'ADD'    
   end [role_code],    
   Case    
    when pt.EMCRef <> '' and pt.EMCRef is not null then 'Y'    
    Else 'N'    
   End [pre_existing],    
   isnull(pt.Title,'') [Title],    
   isnull(pt.firstName,'') [first_name],    
   isnull(pt.lastName,'') [last_name],    
   pt.DOB [DOB],    
   isnull(pt.AddressLine1,'') [address_line_1],    
   isnull(pt.AddressLine2,'') [address_line_2],    
   isnull(pt.PostCode,'') [post_code],    
   isnull(pt.Suburb,'') [Suburb],    
   isnull(pt.[State],'') [State],    
   isnull(pt.Country,'') [country],    
   isnull(pt.HomePhone,'') [home_phone],    
   isnull(pt.WorkPhone,'') [work_phone],    
   isnull(pt.MobilePhone,'') [Mobilephone],    
   isnull(pt.EmailAddress,'') [email_address],    
   case     
    when pt.OptFurtherContact = 1 then 'Y'    
    when pt.OptFurtherContact = 0 then 'N'    
   end [opted_contact]    
  from     
   penPolicy p    
   inner join penOutlet po    
    on p.OutletAlphaKey = po.OutletAlphaKey    
   inner join penPolicyTraveller pt    
    on p.PolicyKey = pt.PolicyKey    
   outer apply    
   (    
    select top 1    
     isnull(pt2.PIDValue,'') PIDValue    
    From    
     penPOlicyTraveller pt2    
    where    
     pt2.PolicyKey = p.PolicyKey    
     and pt2.isPrimary = 1     
   ) pt2    
   Outer Apply    
   (    
    select top 1    
                    q.PartnerTransactionID    
    From     
     impPolicies_test pq    
                    left join impQuotes_test q on    
                        q.QuoteID = pq.QuoteID    
    Where    
     pq.PolicyNumber = p.PolicyNumber    
   ) pq    
  where     
   pt.MemberNumber is not null    
   and po.CountryKey = 'AU'     
   and po.Groupcode in ('CB', 'BW')    
   and po.Groupcode = @group    
   and po.OutletStatus = 'Current'    
   and p.IssueDate >= @start    
   and p.IssueDate < dateadd(day, 1, @end)    
    
    
    
        --delete existing data from current batch (just in case)    
        delete    
        from    
            [db-au-cba].[dbo].[usrTDS_Traveller_test]    
        where    
            BatchID = @batchid    
    
          Insert Into [db-au-cba].[dbo].[usrTDS_Traveller_test]    
        (    
         BatchID,    
   policy_number,    
   travel_insurance_ref_id,    
         traveller_id,    
         hashed_cif_id,    
         role_code,    
         pre_existing,    
         Title,    
         first_name,    
         last_name,    
         DOB,    
         address_line_1,    
         address_line_2,    
         post_code,    
         Suburb,    
         State,    
         country,    
         home_phone,    
         work_phone,    
         Mobilephone,    
         email_address,    
         opted_contact    
        )    
        select    
         @batchid,    
   policy_number,    
   travel_insurance_ref_id,    
         traveller_id,    
         hashed_cif_id,    
         role_code,    
         pre_existing,    
         Title,    
         first_name,    
         last_name,    
         DOB,    
         address_line_1,    
         address_line_2,    
         post_code,    
         Suburb,    
         State,    
         country,    
         home_phone,    
         work_phone,    
         Mobilephone,    
         email_address,    
         opted_contact    
        from    
         #traveller    
    
    end try    
    
    begin catch    
    
        if @@trancount > 0    
            rollback transaction    
    
        exec syssp_genericerrorhandler    
            @SourceInfo = 'TDS Traveler failed',    
            @LogToTable = 1,    
            @ErrorCode = '-100',    
            @BatchID = @batchid,    
            @PackageID = @spname    
    
    end catch    
    
    if @@trancount > 0    
        commit transaction     
    
    --putting all the field, including travel_insurance_ref_id into temp table for final export    
    if object_id('tempdb..#travellerfinal') is not null    
        drop table #travellerfinal    
    
    
    select    
  policy_number,    
     travel_insurance_ref_id,    
     traveller_id,    
     hashed_cif_id,    
     role_code,    
     pre_existing,    
     dbo.fn_CleanSpaces(Title) Title,    
     dbo.fn_CleanSpaces(first_name) first_name,    
     dbo.fn_CleanSpaces(last_name) last_name,    
     DOB,    
     dbo.fn_CleanSpaces(address_line_1) address_line_1,    
     dbo.fn_CleanSpaces(address_line_2) address_line_2,    
     dbo.fn_CleanSpaces(post_code) post_code,    
     dbo.fn_CleanSpaces(Suburb) Suburb,    
     dbo.fn_CleanSpaces(State) State,    
     dbo.fn_CleanSpaces(country) country,    
     dbo.fn_CleanSpaces(home_phone) home_phone,    
     dbo.fn_CleanSpaces(work_phone) work_phone,    
     dbo.fn_CleanSpaces(Mobilephone) Mobilephone,    
     dbo.fn_CleanSpaces(email_address) email_address,    
     opted_contact    
    Into    
     #travellerfinal    
    from    
     [db-au-cba].[dbo].[usrTDS_Traveller_test]    
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
    set @name = 'COVERMORE_TRAVEL_INS_POLICIES_TRAVELLERS'    
    
    set @version = isnull(@version, '001')    
    set @OutputPath = isnull(@OutputPath, 'E:\ETL\Data\CBA\')    
    set @Outputfilename = @name + '_' + convert(varchar, @timestamp, 112) + '_' + @version + '.DAT'    
    
    select @recordcount = count(*) from #travellerfinal    
    
    
    --header    
    insert into @dump(Data)    
    select    
        'H' + @dlt +                                                   --header record type    
        @name + @dlt +           --File Name    
        convert(varchar, @timestamp, 112) + @dlt +           --Business date    
  convert(varchar, @version)    
    
    --detail    
 insert into @dump(Data)    
    select    
        'D' + @dlt +     
  isnull(policy_number,'') + @dlt +     
  Case     
   when len(travel_insurance_ref_id) <> 36 then ''    
   Else isnull(travel_insurance_ref_id,'')    
  End + @dlt +     
  isnull(traveller_id,'') + @dlt +     
  isnull(hashed_cif_id,'') + @dlt +     
  isnull(role_code,'') + @dlt +     
  isnull(pre_existing,'') + @dlt +     
  isnull(Title,'') + @dlt +     
  isnull(first_name,'') + @dlt +     
  isnull(last_name,'') + @dlt +     
  isnull(convert(varchar,DOB,112),'') + @dlt +     
  isnull(address_line_1,'') + @dlt +     
  isnull(address_line_2,'') + @dlt +     
  isnull(post_code,'') + @dlt +     
  isnull(Suburb,'') + @dlt +     
  isnull(State,'') + @dlt +     
  isnull(country,'') + @dlt +     
  isnull(home_phone,'') + @dlt +     
  isnull(work_phone,'') + @dlt +     
  isnull(Mobilephone,'') + @dlt +     
  isnull(email_address,'') + @dlt +     
  isnull(opted_contact,'')    
 from     
  #travellerfinal    
    
    
    
    --trailer    
 insert into @dump(Data)    
    select    
        'T' + @dlt +    
  convert(varchar,@recordcount)    
    
    --To check output data, path and file name    
    --select     
    --       Data,    
    --       @Outputfilename OutputFileName,    
    -- @OutputPath OutputPath    
    --   from    
    --       @dump    
    --   order by    
    --       LineID    
    
    if object_id('[db-au-workspace].dbo.TDSTraveller_Output_test') is null    
        select     
            data,     
            LineID     
        into     
            [db-au-workspace].dbo.TDSTraveller_Output_test     
        from     
            @dump     
    
    --select * from [db-au-workspace].dbo.TDSTraveller_Output order by LineID    
    
    declare @SQL varchar(8000)    
    
    
    --output data file    
    select @SQL = 'bcp "select Data from [db-au-workspace].dbo.TDSTraveller_Output_test order by LineID" queryout "'+ @OutputPath + @Outputfilename + '" -c -t -T -S AZSYDDWH02  -r "0x0A"'    
    
    --select @SQL    
    
    execute master.dbo.xp_cmdshell @SQL    
    
    drop table [db-au-workspace].dbo.TDSTraveller_Output_test    
    
    exec syssp_genericerrorhandler    
        @LogToTable = 1,    
        @ErrorCode = '0',    
        @BatchID = @batchid,    
        @PackageID = @Outputfilename,    
        @LogInsertCount = @recordcount,    
        @SourceTable = '[METADATA]'    
end    
    
    
    
    
    
GO
