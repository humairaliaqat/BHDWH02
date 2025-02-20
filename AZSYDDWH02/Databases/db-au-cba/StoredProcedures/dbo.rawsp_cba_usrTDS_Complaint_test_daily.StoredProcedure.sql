USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rawsp_cba_usrTDS_Complaint_test_daily]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rawsp_cba_usrTDS_Complaint_test_daily]    
    @Group varchar(5) = 'CB',    
    @OverrideStart date = null,    
    @OverrideEnd date = null    
    
as    
begin    
    
/****************************************************************************************************/    
--  Name:           rawsp_cba_usrTDS_Complaint    
--  Author:         Saurabh Date    
--  Date Created:   20180816    
--  Description:    Inserts CBA complaint records into the CBA usrTDS_Complaint table for the TDS exports    
--                        
--  Parameters:     @batchid: required.     
--                      
--  Change History:     
--                  20180816 - SD - Created    
--                  20180817 - SD - changed vesion from one digit (1,2,3) to 3 digit value (001,002,003) and also added it ot the file name.    
--                  20180821 - SD - Changed row eliminator to "0X0A", which will remove carriage return and have only new line character.    
--                  20180918 - SD - Changed the file name to prefix 'ANI'    
--                  20180919 - LL - adjusted for cba database structure    
--                                  batch handling    
--     20181029 - SD - Modified to incoporate correct hashed cif ID    
    
/****************************************************************************************************/    
    
--CBA TDS, logic: All complaint details having claim creation or completion date on day - 1    
    
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
    
    
    if object_id('[db-au-cba].[dbo].[usrTDS_Complaint_test]') is null    
    begin    
    
        create table [db-au-cba].[dbo].[usrTDS_Complaint_test]    
        (    
            BIRowID bigint not null identity(1,1),    
            BatchID int,    
            complaint_number varchar(20) not null,    
            hashed_cif_id varchar(256),    
            claim_number varchar(20),    
            policy_number varchar(20),    
            complaint_register_date datetime,    
            complaint_completion_date datetime,    
            complaint_type varchar(20),    
            case_manager varchar(20),    
            complaint_reason varchar(50),    
            idr_referral_reason varchar(50),    
            idr_decision_reason varchar(50),    
            idr_outcome varchar(20),    
            fos_reference varchar(10),    
            policy_value money,    
            claim_initial_estimate money,    
            claim_paid money,    
            fos_fee money    
        )    
            
        create unique clustered index ucidx_usrTDS_Complaint on [db-au-cba].[dbo].[usrTDS_Complaint_test](BIRowID)    
        create nonclustered index idx_usrTDS_Complaint_BatchID on [db-au-cba].[dbo].[usrTDS_Complaint_test](BatchID)    
    
    end    
    
    begin transaction     
    
    begin try    
    
            
        if object_id('tempdb..#complaint') is not null    
            drop table #complaint    
    
        select     
            convert(varchar(20),isnull(cl.Reference,'')) [complaint_number],    
            isnull(c.PIDValue,'') [hashed_cif_id],    
            convert(varchar(20),isnull(cl.ClaimNumber,'')) [claim_number],    
            convert(varchar(20),isnull(cl.PolicyNumber,'')) [policy_number],    
            cl.CreationDate [complaint_register_date],    
            cl.CompletionDate [complaint_completion_date],    
            convert(varchar(20),isnull(cl.Workclassname,'')) [complaint_type],    
 convert(varchar(20),isnull(cl.AssignedUser,'')) [case_manager],    
            convert(varchar(50),isnull(cpl_r.Name,'')) [complaint_reason],    
            convert(varchar(50),isnull(idr_r.Name,'')) [idr_referral_reason],    
            convert(varchar(50),isnull(idr_d.Name,'')) [idr_decision_reason],    
            convert(varchar(20),isnull(idr_o.Name,'')) [idr_outcome],    
            '' [fos_reference],    
            isnull(pts.GrossPremium,0) [policy_value],    
            isnull(est.Estimate,0) [claim_initial_estimate],    
            isnull(cp.Paid,0) [claim_paid],    
            0 [fos_fee]    
        into     
            #complaint    
        from     
            [db-au-cba].dbo.e5Work_v3 cl    
            inner join [db-au-cba].dbo.ve5WorkProperties wp     
                on (cl.Work_ID = wp.Work_ID)    
            inner join [db-au-cba].dbo.penPolicyTransSummary pts     
                on (pts.PolicyNumber = cl.PolicyNumber)    
            inner join [db-au-cba].dbo.penpolicy p     
                on (p.PolicyNumber = cl.PolicyNumber)    
            inner join [db-au-cba].dbo.penOutlet po     
                on (po.AlphaCode = p.AlphaCode)    
            cross apply     
                (    
                    select     
                        wi.Name    
                    from     
                        [db-au-cba].dbo.e5WorkProperties wp     
                        inner join [db-au-cba].dbo.e5WorkItems wi     
                            on (wp.PropertyValue = wi.ID)    
                    where     
                        wp.Work_ID = cl.Work_ID    
                        and    
                        wp.Property_ID = 'Reasonforcomplaint'    
                ) cpl_r    
            outer apply     
                (    
                    select     
                        wi.Name    
                    from     
                        [db-au-cba].dbo.e5WorkProperties wp     
                        inner join [db-au-cba].dbo.e5WorkItems wi     
                            on (wp.PropertyValue = wi.ID)    
                    where     
                        wp.Work_ID = cl.Work_ID    
                        and    
                        wp.Property_ID = 'ReasonforDispute'    
                ) idr_r    
            outer apply     
                (    
                    select     
                        wi.Name    
                    from     
                        [db-au-cba].dbo.e5WorkProperties wp     
                        inner join [db-au-cba].dbo.e5WorkItems wi     
                            on (wp.PropertyValue = wi.ID)    
                    where     
                        wp.Work_ID = cl.Work_ID    
                        and    
                        wp.Property_ID = 'PolicyExclusionifapplicable'    
                ) idr_d    
            outer apply     
                (    
                    select     
                        top 1 wi.Name    
                    from     
                        [db-au-cba].dbo.e5WorkActivity wa     
                        inner join [db-au-cba].dbo.e5WorkActivityProperties wap     
                            on (wa.Original_ID = wap.Original_WorkActivity_ID)    
                        inner join [db-au-cba].dbo.e5WorkItems wi     
                            on (wi.id = wap.PropertyValue)    
                    where    
                        wa.Work_ID = cl.Work_ID    
                        and    
                        wa.CategoryActivityName = 'IDR Outcome'    
                    order by wa.CompletionDate desc    
                ) idr_o    
            cross apply    
                (    
                    select     
                        top 1     
                        Estimate     
                    from     
                        [db-au-cba].dbo.vclmClaimIncurred  ci    
                    where     
                        ci.ClaimKey = cl.ClaimKey    
                    order by     
                        IncurredDate    
                ) est    
            cross apply    
                (    
                    select     
                        top 1    
                        Paid    
                    from     
             [db-au-cba].dbo.vclmClaimIncurred  ci    
                    where     
                        ci.ClaimKey = cl.ClaimKey    
                    order by     
                        IncurredDate desc    
                ) cp    
            outer apply    
                (    
                    select     
                        top 1     
                        ptv.MemberNumber CustomerID,    
      ptv.PIDValue    
                    from    
                        [db-au-cba].[dbo].[penPolicyTraveller] ptv    
                    where    
                        ptv.PolicyKey = p.PolicyKey and     
                        ptv.isPrimary = 1    
                ) c    
            outer apply    
                (    
                    select     
                        top 1    
                        'CMCP_' + convert(nvarchar, cn.NameID) [customer_id]    
                    from    
                        [db-au-cba].[dbo].[clmName] cn    
                    where    
                        cn.ClaimKey = cl.ClaimKey and    
                        cn.isPrimary = 1 and    
                        isnull(cn.isThirdParty, 0) = 0    
                ) cn    
        where    
            po.CountryKey = 'AU' and    
            po.GroupCode in ('CB', 'BW') and    
            po.GroupCode = @group and    
            po.OutletStatus = 'Current' and     
            cl.WorkType = 'Complaints' and     
            cl.StatusName <> 'Rejected' and    
            (    
                (    
                cl.CreationDate >= @start and     
                cl.CreationDate < dateadd(day, 1, @end)    
                )    
                OR    
                (    
                cl.CompletionDate >= @start and     
                cl.CompletionDate < dateadd(day, 1, @end)    
                )    
            )     
    
    
    
        --delete existing data from current batch (just in case)    
        delete    
        from    
            [db-au-cba].[dbo].[usrTDS_Complaint_test]    
        where    
            BatchID = @batchid    
    
    
        Insert Into [db-au-cba].[dbo].[usrTDS_Complaint_test]    
        (    
            BatchID,    
            complaint_number,    
            hashed_cif_id,    
            claim_number,    
            policy_number,    
            complaint_register_date,    
            complaint_completion_date,    
            complaint_type,    
            case_manager,    
            complaint_reason,    
            idr_referral_reason,    
            idr_decision_reason,    
            idr_outcome,    
            fos_reference,    
            policy_value,    
            claim_initial_estimate,    
            claim_paid,    
            fos_fee    
        )    
        select    
            @batchid,    
            complaint_number,    
            hashed_cif_id,    
            claim_number,    
            policy_number,    
            complaint_register_date,    
            complaint_completion_date,    
            complaint_type,    
            case_manager,    
            complaint_reason,    
            idr_referral_reason,    
            idr_decision_reason,    
            idr_outcome,    
            fos_reference,    
            policy_value,    
            claim_initial_estimate,    
            claim_paid,    
            fos_fee    
        from    
            #complaint    
    
    end try    
    
    begin catch    
    
        if @@trancount > 0    
            rollback transaction    
    
        exec syssp_genericerrorhandler    
            @SourceInfo = 'TDS Complaint failed',    
            @LogToTable = 1,    
            @ErrorCode = '-100',    
            @BatchID = @batchid,    
            @PackageID = @spname    
    
    end catch    
    
    if @@trancount > 0    
        commit transaction     
    
    --putting all the field into temp table for final export    
    if object_id('tempdb..#complaintfinal') is not null    
        drop table #complaintfinal    
    
    select    
        complaint_number,    
        hashed_cif_id,    
        claim_number,    
        policy_number,    
        complaint_register_date,    
        complaint_completion_date,    
        complaint_type,    
        case_manager,    
        complaint_reason,    
        idr_referral_reason,    
        idr_decision_reason,    
        idr_outcome,    
        fos_reference,    
        policy_value,    
        claim_initial_estimate,    
        claim_paid,    
        fos_fee    
    Into    
        #complaintfinal    
    from    
        [db-au-cba].[dbo].[usrTDS_Complaint_test]    
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
    set @name = 'ANI_COVERMORE_TRAVEL_INS_COMPLAINT'    
    
    set @version = isnull(@version, '001')    
    set @OutputPath = isnull(@OutputPath, 'E:\ETL\Data\CBA\')    
    set @Outputfilename = @name + '_' + convert(varchar, @timestamp, 112) + '_' + @version + '.DAT'    
    
    
    select @recordcount = count(*) from #complaintfinal    
    
    
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
        isnull(complaint_number,'') + @dlt +     
        isnull(hashed_cif_id,'') + @dlt +     
        isnull(claim_number,'') + @dlt +     
        isnull(policy_number,'') + @dlt +     
        isnull(convert(varchar,complaint_register_date,112),'') + @dlt +     
        isnull(convert(varchar,complaint_completion_date,112),'') + @dlt +     
        isnull(complaint_type,'') + @dlt +     
        isnull(case_manager,'') + @dlt +     
        isnull(complaint_reason,'') + @dlt +     
        isnull(idr_referral_reason,'') + @dlt +     
        isnull(idr_decision_reason,'') + @dlt +     
        isnull(idr_outcome,'') + @dlt +     
        isnull(fos_reference,'') + @dlt +     
        isnull(convert(varchar,policy_value),'') + @dlt +     
        isnull(convert(varchar,claim_initial_estimate),'') + @dlt +     
        isnull(convert(varchar,claim_paid),'') + @dlt +     
        isnull(convert(varchar,fos_fee),'')    
    from     
        #complaintfinal    
    
    
    
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
    
    if object_id('[db-au-workspace].dbo.TDSComplaint_Output_test') is null    
        select     
            data,     
            LineID     
        into [db-au-workspace].dbo.TDSComplaint_Output_test     
        from     
            @dump     
    
    --select * from [db-au-workspace].dbo.TDSComplaint_Output order by LineID    
    
    declare @SQL varchar(8000)    
    
    
    --output data file    
    select @SQL = 'bcp "select Data from [db-au-workspace].dbo.TDSComplaint_Output_test order by LineID" queryout "'+ @OutputPath + @Outputfilename + '" -c -t -T -S AZSYDDWH02  -r "0x0A"'    
    
    --select @SQL    
    
    execute master.dbo.xp_cmdshell @SQL    
    
    drop table [db-au-workspace].dbo.TDSComplaint_Output_test    
    
    exec syssp_genericerrorhandler    
        @LogToTable = 1,    
        @ErrorCode = '0',    
        @BatchID = @batchid,    
        @PackageID = @Outputfilename,    
        @LogInsertCount = @recordcount,    
        @SourceTable = '[METADATA]'    
    
end 
GO
