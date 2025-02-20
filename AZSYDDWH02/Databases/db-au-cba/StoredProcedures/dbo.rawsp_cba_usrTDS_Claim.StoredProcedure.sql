USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rawsp_cba_usrTDS_Claim]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rawsp_cba_usrTDS_Claim]  
    @Group varchar(5) = 'CB',  
    @OverrideStart date = null,  
    @OverrideEnd date = null  
  
as  
begin  
  
/****************************************************************************************************/  
--  Name:           rawsp_cba_usrTDS_Claim  
--  Author:         Saurabh Date  
--  Date Created:   20180816  
--  Description:    Inserts CBA Claim records into the CBA usrTDS_Claim table for the TDS exports  
--                      
--  Parameters:     @batchid: required.   
--                    
--  Change History:   
--                  20180816 - SD - Created  
--                  20180817 - SD - changed vesion from one digit (1,2,3) to 3 digit value (001,002,003) and also added it ot the file name.  
--                  20180821 - SD - Changed row eliminator to "0X0A", which will remove carriage return and have only new line character.  
--                  20180919 - LL - adjusted for cba database structure  
--                                  batch handling  
--     20181029 - SD - Changed logic to fetch travel Insurance Reference ID, and also changed incident country, location and description reference from clmClaimFlags to clmOnlineClaimEvent  
--                  20190409 - LL - handle old style external reference  
--     20190516 - SD - Change the logic to fetch Latest event details only. Also included logic to lookup quote fo travel insurance reference ID, if its not available in policy.  
--     20190527 - SD - Clearing spaces, new line tabs from incident description and incident location  
--     20190603 - SD - Changed legnth of export fields for Incident Description to 3000, and Incident location to 500, as requested by CBA (Change applied while exporting data only)  
/****************************************************************************************************/  
  
--CBA TDS, logic: All claim details having claim received on day - 1  
  
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
  
  
    if object_id('[db-au-cba].[dbo].[usrTDS_Claim]') is null  
    begin  
  
        create table [db-au-cba].[dbo].[usrTDS_Claim]  
        (  
            BIRowID bigint not null identity(1,1),  
            BatchID int,  
            claim_number varchar(20) not null,  
            travel_insurance_ref_id varchar(255),  
            policy_number varchar(20) not null,  
            claim_status_code varchar(10) not null,  
            incident_category varchar(60),  
            special_claim_category varchar(50),  
            incident_created_date datetime,  
            incident_date datetime,  
            incident_country varchar(50),  
            incident_description varchar(4000),  
            incident_location varchar(1000),  
            document_rec_date datetime,  
            total_incurred money,  
            total_outstanding money,  
            total_paid money  
        )  
          
        create unique clustered index ucidx_usrTDS_Claim on [db-au-cba].[dbo].[usrTDS_Claim](BIRowID)  
        create nonclustered index idx_usrTDS_Claim_BatchID on [db-au-cba].[dbo].[usrTDS_Claim](BatchID)  
  
    end  
  
    begin transaction   
  
    begin try  
          
        if object_id('tempdb..#claim') is not null  
            drop table #claim  
  
        select   
            isnull(cl.ClaimNo,'') [claim_number],  
   case  
                when p.saved_tid <> '' and p.saved_tid <> p.PolicyNumber then p.saved_tid  
    when len(isnull(pq.PartnerTransactionID, '')) = 36 then isnull(pq.PartnerTransactionID, '')   
                else isnull(p.ExternalReference,'')  
            end [travel_insurance_ref_id],  
            isnull(cl.PolicyNo,'') [policy_number],  
            isnull(cl.statusCode,'')[claim_status_code],  
            isnull(ce.PerilDesc, '') [incident_category],  
            isnull(ce.CatastropheShortDesc,'') [special_claim_category],  
            isnull(ce.CreateDate,'') [incident_created_date],  
            isnull(ce.EventDate,'') [incident_date],  
            isnull(coe.EventCountry,'') [incident_country],  
            isnull(left(coe.Detail, 4000),'') [incident_description],  
            isnull(coe.EventLocation,'') [incident_location],  
            isnull(ce.CreateDate,'') [document_rec_date],  
            sum(isnull(ci.Incurred,0)) [total_incurred],  
            sum(isnull(ci.Estimate,0)) [total_outstanding],  
            sum(isnull(ci.Paid,0)) [total_paid]  
        Into   
            #claim  
        from   
            [db-au-cba].[dbo].[clmClaim] cl  
            inner join [db-au-cba].[dbo].[penOutlet] o   
                on o.OutletKey = cl.OutletKey   
                    and o.OutletStatus = 'Current'  
            --inner join [db-au-cba].[dbo].[clmEvent] ce on  
            --    ce.ClaimKey = cl.ClaimKey  
            left join [db-au-cba].[dbo].[clmOnlineClaimEvent] coe on  
                coe.ClaimKey = cl.ClaimKey  
            cross apply  
            (  
                select  
                    sum(ci.EstimateDelta) Estimate,  
                    sum(ci.PaymentDelta) Paid,  
                    sum(ci.IncurredDelta) Incurred  
                from  
                    [db-au-cba].[dbo].[vclmClaimIncurred] ci  
                where  
                    ci.ClaimKey = cl.ClaimKey  
            ) ci  
   outer apply  
   (  
    select   
     top 1  
     ce.PerilDesc,  
     ce.CatastropheShortDesc,  
     ce.CreateDate,  
     ce.EventDate  
    From  
     clmEvent ce  
    where  
     ce.ClaimKey = cl.ClaimKey  
    order by  
     ce.CreateDate desc  
   ) ce  
            outer apply  
            (  
                select top 1   
                    ptv.MemberNumber CustomerID,  
     pt.PolicyKey  
                from  
                    [db-au-cba].[dbo].[penPolicyTransSummary] pt  
                    inner join [db-au-cba].[dbo].[penPolicyTraveller] ptv on  
                        ptv.PolicyKey = pt.PolicyKey  
                where  
                    pt.PolicyTransactionKey = cl.PolicyTransactionKey and  
                    ptv.isPrimary = 1  
            ) c  
            outer apply  
            (  
                select top 1  
                    'CMCN_' + convert(nvarchar, cn.NameID) [customer_id]  
                from  
                    [db-au-cba].[dbo].[clmName] cn  
                where  
                    cn.ClaimKey = cl.ClaimKey and  
                    cn.isPrimary = 1 and  
                    isnull(cn.isThirdParty, 0) = 0  
            ) cn  
   outer apply  
   (  
    select  
     top 1  
     p.ExternalReference,  
     p.PolicyNumber,  
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
    where  
     p.PolicyKey = c.PolicyKey  
   ) p  
   Outer Apply  
   (  
    select top 1  
                    q.PartnerTransactionID  
    From   
     impPolicies pq  
                    left join impQuotes q on  
                        q.QuoteID = pq.QuoteID  
    Where  
     pq.PolicyNumber = p.PolicyNumber  
   ) pq  
        where  
            o.CountryKey = 'AU' and  
            o.GroupCode in ('CB', 'BW') and  
            o.GroupCode = @Group and  
            cl.ClaimKey in  
            (  
                select   
                    r.ClaimKey  
                from  
                    [db-au-cba].[dbo].[vclmClaimIncurred] r  
                where  
                    r.IncurredDate >= @start and  
                    r.IncurredDate <  dateadd(day, 1, @end)  
            )  
        group by  
            isnull(cl.ClaimNo,''),  
   case  
                when p.saved_tid <> '' and p.saved_tid <> p.PolicyNumber then p.saved_tid  
    when len(isnull(pq.PartnerTransactionID, '')) = 36 then isnull(pq.PartnerTransactionID, '')   
                else isnull(p.ExternalReference,'')  
            end,  
            isnull(cl.PolicyNo,''),  
            isnull(cl.statusCode,''),  
            isnull(ce.PerilDesc, ''),  
            isnull(ce.CatastropheShortDesc,''),  
            isnull(ce.CreateDate,''),  
            isnull(ce.EventDate,''),  
            isnull(coe.EventCountry,''),  
            isnull(left(coe.Detail, 4000),''),  
            isnull(coe.EventLocation,''),  
            isnull(ce.CreateDate,'')  
  
  
        --delete existing data from current batch (just in case)  
        delete  
        from  
            [db-au-cba].[dbo].[usrTDS_Claim]  
        where  
            BatchID = @batchid  
  
        insert Into [db-au-cba].[dbo].[usrTDS_Claim]  
        (  
            BatchID,  
            claim_number,  
   travel_insurance_ref_id,  
            policy_number,  
            claim_status_code,  
            incident_category,  
            special_claim_category,  
            incident_created_date,  
            incident_date,  
            incident_country,  
            incident_description,  
            incident_location,  
            document_rec_date,  
            total_incurred,  
            total_outstanding,  
            total_paid  
        )  
        select  
            @batchid,  
            claim_number,  
   travel_insurance_ref_id,  
            policy_number,  
            claim_status_code,  
            incident_category,  
            special_claim_category,  
            incident_created_date,  
            incident_date,  
            incident_country,  
            incident_description,  
            incident_location,  
            document_rec_date,  
            total_incurred,  
            total_outstanding,  
            total_paid  
        from  
            #claim  
  
    end try  
  
    begin catch  
  
        if @@trancount > 0  
            rollback transaction  
  
        exec syssp_genericerrorhandler  
            @SourceInfo = 'TDS Claims failed',  
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
    set @name = 'COVERMORE_TRAVEL_INS_CLAIMS'  
  
    set @version = isnull(@version, '001')  
    set @OutputPath = isnull(@OutputPath, 'E:\ETL\Data\CBA\')  
    set @Outputfilename = @name + '_' + convert(varchar, @timestamp, 112) + '_' + @version + '.DAT'  
  
  
  
    --putting all the field, including travel_insurance_ref_id into temp table for final export  
    if object_id('tempdb..#claimfinal') is not null  
        drop table #claimfinal  
  
    select  
        claim_number,  
        travel_insurance_ref_id,  
        policy_number,  
        claim_status_code,  
        incident_category,  
        special_claim_category,  
        incident_created_date,  
        incident_date,  
        incident_country,  
        incident_description,  
        incident_location,  
        document_rec_date,  
        total_incurred,  
        total_outstanding,  
        total_paid  
    Into  
        #claimfinal  
    from  
        [db-au-cba].[dbo].[usrTDS_Claim]  
    Where  
        batchid = @batchid  
  
    select  
        @recordcount = count(*)   
    from   
        #claimfinal  
  
    --header  
    insert into @dump(Data)  
    select  
        'H' + @dlt +                                        --header record type  
        @name + @dlt +                                      --File Name  
        convert(varchar, @timestamp, 112) + @dlt +          --Business date  
        convert(varchar, @version)  
  
    --detail  
    insert into @dump(Data)  
    select  
        'D' + @dlt +   
        isnull(convert(varchar,claim_number),'') + @dlt +    
        Case   
   when len(travel_insurance_ref_id) <> 36 then ''  
   Else isnull(travel_insurance_ref_id,'')  
  End + @dlt +   
        isnull(policy_number,'') + @dlt +   
        isnull(claim_status_code,'') + @dlt +   
        isnull(incident_category,'') + @dlt +   
        isnull(special_claim_category,'') + @dlt +   
        isnull(convert(varchar,incident_created_date,112),'') + @dlt +   
        isnull(convert(varchar,incident_date,112),'') + @dlt +   
        isnull(incident_country,'') + @dlt +   
        isnull(convert(varchar(3000),dbo.fn_CleanSpaces(incident_description)),'') + @dlt +   
        isnull(convert(varchar(500),dbo.fn_CleanSpaces(incident_location)),'') + @dlt +   
        isnull(convert(varchar,document_rec_date,112),'') + @dlt +   
        isnull(convert(varchar,total_incurred),'') + @dlt +   
        isnull(convert(varchar,total_outstanding),'') + @dlt +   
        isnull(convert(varchar,total_paid),'')  
    from   
        #Claimfinal  
  
  
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
  
    if object_id('[db-au-workspace].dbo.TDSClaim_Output') is null  
        select   
            data,   
            LineID   
        into [db-au-workspace].dbo.TDSClaim_Output   
        from   
            @dump   
  
    --select * from [db-au-workspace].dbo.TDSClaim_Output order by LineID  
  
    declare @SQL varchar(8000)  
  
    --output data file  
    set @SQL = 'bcp "select Data from [db-au-workspace].dbo.TDSClaim_Output order by LineID" queryout "'+ @OutputPath + @Outputfilename + '" -c -t -T -S AZSYDDWH02  -r "0x0A"'  
  
    --print @SQL  
  
    execute master.dbo.xp_cmdshell @SQL  
  
    drop table [db-au-workspace].dbo.TDSClaim_Output  
  
    exec syssp_genericerrorhandler  
        @LogToTable = 1,  
        @ErrorCode = '0',  
        @BatchID = @batchid,  
        @PackageID = @Outputfilename,  
        @LogInsertCount = @recordcount,  
        @SourceTable = '[METADATA]'  
  
  
end  
  
GO
