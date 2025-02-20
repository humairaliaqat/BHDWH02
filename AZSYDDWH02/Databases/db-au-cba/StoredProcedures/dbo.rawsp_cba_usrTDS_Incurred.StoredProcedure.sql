USE [db-au-cba]
GO
/****** Object:  StoredProcedure [dbo].[rawsp_cba_usrTDS_Incurred]    Script Date: 20/02/2025 10:13:02 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[rawsp_cba_usrTDS_Incurred]
    @Group varchar(5) = 'CB',
    @OverrideStart date = null,
    @OverrideEnd date = null

as
begin

/****************************************************************************************************/
--  Name:           rawsp_cba_usrTDS_Incurred
--  Author:         Saurabh Date
--  Date Created:   20180816
--  Description:    Inserts CBA policy records into the CBA usrTDS_Incurred table for the TDS exports
--                    
--  Parameters:     @batchid: required. 
--                  
--  Change History: 
--                  20180816 - SD - Created
--                  20180817 - SD - changed vesion from one digit (1,2,3) to 3 digit value (001,002,003) and also added it ot the file name.
--                  20180821 - SD - Changed row eliminator to "0X0A", which will remove carriage return and have only new line character.
--                  20180919 - LL - adjusted for cba database structure
--                                  batch handling
--					20190516 - SD - Summarise the incurred data based on claim_number, incurred_date, cost_type and Paid_date field
/****************************************************************************************************/

--CBA TDS, logic: All claim incurred details having incurred date on day - 1

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


    if object_id('[db-au-cba].[dbo].[usrTDS_Incurred]') is null
    begin

        create table [db-au-cba].[dbo].[usrTDS_Incurred]
        (
            BIRowID bigint not null identity(1,1),
            BatchID int,
            claim_number varchar(20) not null,
            incurred_date datetime,
            cost_type varchar(20),
            paid_date datetime,
            outstanding_movement money,
            payment_movement money,
            incurred_movement money,
            outstanding_end_of_day money,
            payment_end_of_day money,
            incurred_end_of_day money
        )
        
        create unique clustered index ucidx_usrTDS_Incurred on [db-au-cba].[dbo].[usrTDS_Incurred](BIRowID)
        create nonclustered index idx_usrTDS_Incurred_BatchID on [db-au-cba].[dbo].[usrTDS_Incurred](BatchID)

    end

    begin transaction 

    begin try
        
        if object_id('tempdb..#incurred') is not null
            drop table #incurred

        select 
            isnull(cl.ClaimNo,'') [claim_number],
            csi.IncurredDate [incurred_date],
            isnull(cs.SectionCode,'') [cost_type],
            csi.IncurredDate [paid_date],
            sum(isnull(csi.EstimateDelta,0)) [outstanding_movement],
            sum(isnull(csi.PaymentDelta,0)) [payment_movement],
            sum(isnull(csi.IncurredDelta,0)) [incurred_movement],
            sum(isnull(csi.Estimate,0)) [outstanding_end_of_day],
            sum(isnull(csi.Paid,0)) [payment_end_of_day],
            sum(isnull(csi.IncurredValue,0)) [incurred_end_of_day]
        Into 
            #incurred
        from 
            [db-au-cba].[dbo].[clmClaim] cl
            inner join [db-au-cba].[dbo].[penOutlet] o on
                o.OutletKey = cl.OutletKey and
                o.OutletStatus = 'Current'
            inner join [db-au-cba].[dbo].[clmSection] cs on
                cs.ClaimKey = cl.ClaimKey
            inner join [db-au-cba].[dbo].[vclmClaimSectionIncurred] csi on
                csi.SectionKey = cs.SectionKey
        where
            o.CountryKey = 'AU' and
            o.GroupCode in ('CB','BW') and
            o.GroupCode = @Group and
            csi.IncurredDate >= @start and
            csi.IncurredDate <  dateadd(day, 1, @end)
		Group By
			isnull(cl.ClaimNo,''),
            csi.IncurredDate,
            isnull(cs.SectionCode,''),
            csi.IncurredDate

        --delete existing data from current batch (just in case)
        delete
        from
            [db-au-cba].[dbo].[usrTDS_Incurred]
        where
            BatchID = @batchid


        insert into [db-au-cba].[dbo].[usrTDS_Incurred]
        (
            BatchID,
            claim_number,
            incurred_date,
            cost_type,
            paid_date,
            outstanding_movement,
            payment_movement,
            incurred_movement,
            outstanding_end_of_day,
            payment_end_of_day,
            incurred_end_of_day
        )
        select
            @batchid,
            claim_number,
            incurred_date,
            cost_type,
            paid_date,
            outstanding_movement,
            payment_movement,
            incurred_movement,
            outstanding_end_of_day,
            payment_end_of_day,
            incurred_end_of_day
        from
            #incurred

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'TDS Incurred failed',
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
    set @name = 'COVERMORE_TRAVEL_INS_CLAIMINCURRED'

    set @version = isnull(@version, '001')
    set @OutputPath = isnull(@OutputPath, 'E:\ETL\Data\CBA\')
    set @Outputfilename = @name + '_' + convert(varchar, @timestamp, 112) + '_' + @version + '.DAT'


    --putting all the field into temp table for final export
      if object_id('tempdb..#incurredfinal') is not null
        drop table #incurredfinal

    select
        claim_number,
        incurred_date,
        cost_type,
        paid_date,
        outstanding_movement,
        payment_movement,
        incurred_movement,
        outstanding_end_of_day,
        payment_end_of_day,
        incurred_end_of_day
    into
        #incurredfinal
    from
        [db-au-cba].[dbo].[usrTDS_Incurred]
    where
        batchid = @batchid

    select @recordcount = count(*) from #incurredfinal

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
        isnull(claim_number,'') + @dlt + 
        isnull(convert(varchar,incurred_date,112),'') + @dlt + 
        isnull(cost_type,'') + @dlt + 
        isnull(convert(varchar,paid_date,112),'') + @dlt + 
        isnull(convert(varchar,outstanding_movement),'') + @dlt + 
        isnull(convert(varchar,payment_movement),'') + @dlt + 
        isnull(convert(varchar,incurred_movement),'') + @dlt + 
        isnull(convert(varchar,outstanding_end_of_day),'') + @dlt + 
        isnull(convert(varchar,payment_end_of_day),'') + @dlt + 
        isnull(convert(varchar,incurred_end_of_day),'')
    from 
        #incurredfinal

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

    if object_id('[db-au-workspace].dbo.TDSIncurred_Output') is null
        select 
            data, 
            LineID 
        into [db-au-workspace].dbo.TDSIncurred_Output 
        from 
            @dump 

    --select * from [db-au-workspace].dbo.TDSIncurred_Output order by LineID

    declare @SQL varchar(8000)

    --output data file
    set @SQL = 'bcp "select Data from [db-au-workspace].dbo.TDSIncurred_Output order by LineID" queryout "'+ @OutputPath + @Outputfilename + '" -c -t -T -S AZSYDDWH02 -r "0x0A"'

    --print @SQL
    execute master.dbo.xp_cmdshell @SQL

    drop table [db-au-workspace].dbo.TDSIncurred_Output

    exec syssp_genericerrorhandler
        @LogToTable = 1,
        @ErrorCode = '0',
        @BatchID = @batchid,
        @PackageID = @Outputfilename,
        @LogInsertCount = @recordcount,
        @SourceTable = '[METADATA]'

end
GO
