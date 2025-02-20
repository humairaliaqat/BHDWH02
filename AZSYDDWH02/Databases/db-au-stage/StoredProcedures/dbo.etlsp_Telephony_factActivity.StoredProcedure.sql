USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_Telephony_factActivity]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_Telephony_factActivity]
as
begin
/************************************************************************************************************************************
Author:         Leo
Date:           20141217
Prerequisite:   Verint, Cisco, LDAP
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

    if object_id('[db-au-star].dbo.factActivity') is null
    begin

        create table [db-au-star].dbo.factActivity
        (
            BIRowID int not null identity(1,1),
            DateSK int not null,
            EmployeeSK int not null,
            SupervisorSK int not null,
            TeamSK int not null,
            ActivitySK int not null,
            ActualActivityTime float not null,
            ScheduledActivityTime float not null,
            ApprovedExceptionDuration int not null,
            UnapprovedExceptionDuration int not null,
            CreateBatchID int
        )
        
        create clustered index idx_factActivity_BIRowID on [db-au-star].dbo.factActivity(BIRowID)
        create nonclustered index idx_factActivity_DateSK on [db-au-star].dbo.factActivity(DateSK)
        
    end
    
    if object_id('tempdb..#factActivity') is not null
        drop table #factActivity

    select 
        isnull(d.Date_SK, -1) DateSK,
        isnull(de.EmployeeSK, -1) EmployeeSK,
        isnull(ds.SupervisorSK, -1) SupervisorSK,
        isnull(t.TeamSK, -1) TeamSK,
        isnull(a.ActivitySK, -1) ActivitySK,
        case 
            when TimeLineType = 'Actuals' then ActivityTime 
            else 0 
        end ActualActivityTime, 
        case 
            when TimeLineType = 'Actuals' then 0 
            else ActivityTime 
        end ScheduledActivityTime, 
        0 ApprovedExceptionDuration, 
        0 UnapprovedExceptionDuration
    into #factActivity
    from
        [db-au-cba]..verActivityTimeline vat 
        inner join [db-au-cba]..verEmployee e on 
            e.EmployeeKey = vat.EmployeeKey 
        outer apply
        (
            select top 1 
                Date_SK
            from
                [db-au-star]..Dim_Date d
            where
                d.[Date] = convert(date, vat.ActivityStartTime)
        ) d
        outer apply
        (
            select top 1 
                ActivitySK
            from
                [db-au-star]..dimActivity a
            where
                a.ActivityID = vat.ActivityKey
        ) a
        outer apply
        (
            select top 1 
                de.EmployeeSK
            from
                [db-au-star]..dimEmployee de
            where
                de.EmployeeID = e.UserName
        ) de
        outer apply
        (
            select top 1 
                t.TeamSK
            from
                [db-au-star]..dimTeam t
            where
                t.TeamID = vat.OrganisationKey
        ) t
        outer apply
        (
            select top 1 
                s.UserName SupervisorID
            from
                [db-au-cba]..verEmployee s 
            where
                s.EmployeeKey = vat.SupervisorEmployeeKey
        ) s
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
        vat.ActivityStartTime >= @start and
        vat.ActivityStartTime <  dateadd(day, 1, @end)

    union all

    select
        isnull(d.Date_SK, -1) DateSK,
        isnull(de.EmployeeSK, -1) EmployeeSK,
        isnull(ds.SupervisorSK, -1) SupervisorSK,
        isnull(t.TeamSK, -1) TeamSK,
        isnull(a.ActivitySK, -1) ActivitySK,
        0 ActualActivityTime, 
        0 ScheduledActivityTime, 
        ApprovedExceptionDuration, 
        UnapprovedExceptionDuration
    from
        [db-au-cba]..verAdherence va 
        inner join [db-au-cba]..verEmployee e on 
            e.EmployeeKey = va.EmployeeKey 
        outer apply
        (
            select top 1 
                Date_SK
            from
                [db-au-star]..Dim_Date d
            where
                d.[Date] = convert(date, va.ActivityStartTime)
        ) d
        outer apply
        (
            select top 1 
                ActivitySK
            from
                [db-au-star]..dimActivity a
            where
                a.ActivityID = va.ActivityKey
        ) a
        outer apply
        (
            select top 1 
                de.EmployeeSK
            from
                [db-au-star]..dimEmployee de
            where
                de.EmployeeID = e.UserName
        ) de
        outer apply
        (
            select top 1 
                t.TeamSK
            from
                [db-au-star]..dimTeam t
            where
                t.TeamID = va.OrganisationKey
        ) t
        outer apply
        (
            select top 1 
                s.UserName SupervisorID
            from
                [db-au-cba]..verEmployee s 
            where
                s.EmployeeKey = va.SupervisorEmployeeKey
        ) s
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
        va.ActivityStartTime >= @start and
        va.ActivityStartTime <  dateadd(day, 1, @end)
        
            
    set @sourcecount = @@rowcount

    begin transaction

    begin try
    
        delete from [db-au-star].dbo.factActivity
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
            
        insert into [db-au-star].dbo.factActivity with (tablock)
        (
            DateSK,
            EmployeeSK,
            SupervisorSK,
            TeamSK,
            ActivitySK,
            ActualActivityTime,
            ScheduledActivityTime,
            ApprovedExceptionDuration,
            UnapprovedExceptionDuration,
            CreateBatchID
        )
        select 
            DateSK,
            EmployeeSK,
            SupervisorSK,
            TeamSK,
            ActivitySK,
            sum(ActualActivityTime),
            sum(ScheduledActivityTime),
            sum(ApprovedExceptionDuration),
            sum(UnapprovedExceptionDuration),
            @batchid
        from
            #factActivity
        group by
            DateSK,
            EmployeeSK,
            SupervisorSK,
            TeamSK,
            ActivitySK
        

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
