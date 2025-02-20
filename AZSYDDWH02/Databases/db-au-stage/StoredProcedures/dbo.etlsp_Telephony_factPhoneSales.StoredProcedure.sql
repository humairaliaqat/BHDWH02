USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_Telephony_factPhoneSales]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_Telephony_factPhoneSales]
as
begin
/************************************************************************************************************************************
Author:         Leo
Date:           20141217
Prerequisite:   Verint, Cisco, LDAP, Policy Cube
Description:    
Change History:
                20141217 - LS - created

*************************************************************************************************************************************/

    set nocount on

    declare
        @batchid int,
        @start date,
        @end date,
        @name varchar(50),
        @sourcecount int,
        @insertcount int,
        @updatecount int

    declare @mergeoutput table (MergeAction varchar(20))

    exec syssp_getrunningbatch
        @SubjectArea = 'Telephony STAR',
        @BatchID = @batchid out,
        @StartDate = @start out,
        @EndDate = @end out

    select
        @name = object_name(@@procid)

    exec syssp_genericerrorhandler
        @LogToTable = 1,
        @ErrorCode = '0',
        @BatchID = @batchid,
        @PackageID = @name,
        @LogStatus = 'Running'

    if object_id('[db-au-star].dbo.factPhoneSales') is null
    begin

        create table [db-au-star].dbo.factPhoneSales
        (
            BIRowID int not null identity(1,1),
            DateSK int not null,
            EmployeeSK int not null,
            SupervisorSK int not null,
            TeamSK int not null,
            Premium float not null,
            SellPrice float not null,
            CreateBatchID int,
        )
        
        create clustered index idx_factPhoneSales_BIRowID on [db-au-star].dbo.factPhoneSales(BIRowID)
        create nonclustered index idx_factPhoneSales_DateSK on [db-au-star].dbo.factPhoneSales(DateSK)
        
    end
    
    if object_id('tempdb..#factPhoneSales') is not null
        drop table #factPhoneSales

    select
        pt.DateSK,
        isnull(de.EmployeeSK, -1) EmployeeSK,
        isnull(ds.SupervisorSK, -1) SupervisorSK,
        isnull(t.TeamSK, -1) TeamSK,
        Premium, 
        SellPrice
    into #factPhoneSales
    from
        [db-au-star]..factPolicyTransaction pt 
        inner join [db-au-star]..dimOutlet o on 
            o.OutletSK = pt.OutletSK 
        inner join [db-au-star]..dimConsultant c on 
            c.ConsultantSK = pt.ConsultantSK 
        cross apply
        (
            select top 1 
                EmployeeSK,
                EmployeeID
            from 
                [db-au-star]..dimEmployee de
            where
                de.EmployeeID = replace(c.UserName, '_AU', '') or
                (
                    de.FirstName = c.Firstname and 
                    de.LastName = c.Lastname
                )
        ) de 
        outer apply
        (
            select top 1 
                SupervisorID, 
                vat.OrganisationKey TeamID
            from
                [db-au-cba]..verEmployee ve 
                inner join [db-au-cba]..verActivityTimeline vat on 
                    vat.EmployeeKey = ve.EmployeeKey 
                outer apply
                (
                    select top 1 
                        ves.UserName SupervisorID
                    from
                        [db-au-cba]..verEmployee ves 
                    where
                        ves.EmployeeKey = vat.SupervisorEmployeeKey
                ) s
            where
                ve.UserName = de.EmployeeID and 
                vat.ActivityStartTime >= convert(date, pt.PostingDate) and 
                vat.ActivityStartTime <  dateadd(day, 1, convert(date, pt.PostingDate))
        ) s
        outer apply
        (
            select top 1 
                t.TeamSK
            from
                [db-au-star]..dimTeam t
            where
                t.TeamID = s.TeamID
        ) t
        outer apply
        (
            select top 1 
                de.EmployeeSK SupervisorSK
            from
                [db-au-star]..dimEmployee de
            where
                de.EmployeeID = s.SupervisorID
        ) ds
    where
        pt.DateSK in
        (
            select
                dt.Date_SK
            from
                [db-au-star].dbo.Dim_Date dt
            where
                dt.[Date] >= @start and
                dt.[Date] <  dateadd(day, 1, @end)
        ) and
        o.Country = 'AU' and
        o.GroupCode = 'CM'
        
            
    set @sourcecount = @@rowcount

    begin transaction

    begin try
    
        delete from [db-au-star].dbo.factPhoneSales
        where
            DateSK in
            (
                select
                    dt.Date_SK
                from
                    [db-au-star].dbo.Dim_Date dt
                where
                    dt.[Date] >= @start and
                    dt.[Date] <  dateadd(day, 1, @end)
            )
            
        insert into [db-au-star].dbo.factPhoneSales with (tablock)
        (
            DateSK,
            EmployeeSK,
            SupervisorSK,
            TeamSK,
            Premium,
            SellPrice,
            CreateBatchID
        )
        select 
            DateSK,
            EmployeeSK,
            SupervisorSK,
            TeamSK,
            sum(Premium),
            sum(SellPrice),
            @batchid
        from
            #factPhoneSales
        group by
            DateSK,
            EmployeeSK,
            SupervisorSK,
            TeamSK        

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

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'Failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end

GO
