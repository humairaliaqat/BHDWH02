USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_Telephony_factCalls]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_Telephony_factCalls]
as
begin


/************************************************************************************************************************************
Author:         Leo
Date:           20141217
Prerequisite:   Verint, Cisco
Description:    
Change History:
                20141217 - LS - created
                20150129 - LT - added OutletSK to factCalls table. 
								The assumption is CSQName in ('CS_AAA_RACQ_SALES','CS_AAA_SALES','CS_AP_Sales','CS_CM_Sales','CS_IAL_Sales','CS_YG_Sales') are
								mapped to 'CMN0000' alpha Cover-More Phonesales
                20150227 - LS - prioritise the non deleted LDAP accounts
                
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

    if object_id('[db-au-star].dbo.factCalls') is null
    begin

        create table [db-au-star].dbo.factCalls
        (
            BIRowID int not null identity(1,1),
            DateSK int not null,
            EmployeeSK int not null,
            SupervisorSK int not null,
            TeamSK int not null,
            CSQSK int not null,
            OutletSK int not null,
            CallsPresented int not null,
            CallsHandled int not null,
            CallsAbandoned int not null,
            RingTime int not null,
            TalkTime int not null,
            HoldTime int not null,
            WorkTime int not null,
            WrapUpTime int not null,
            QueueTime int not null,
            MetServiceLevel int not null,
            Transfered int not null,
            Redirect int not null,
            Conference int not null,
            RingNoAnswer int not null,
            CreateBatchID int
        )
        
        create clustered index idx_factCalls_BIRowID on [db-au-star].dbo.factCalls(BIRowID)
        create nonclustered index idx_factCalls_DateSK on [db-au-star].dbo.factCalls(DateSK)
        
    end
    
    if object_id('tempdb..#factCalls') is not null
        drop table #factCalls

    select 
        isnull(Date_SK, -1) DateSK,
        isnull(e.EmployeeSK, -1) EmployeeSK,
        isnull(es.SupervisorSK, -1) SupervisorSK,
        isnull(t.TeamSK, -1) TeamSK,
        isnull(csq.CSQSK, -1) CSQSK,
        isnull(csq.OutletSK, -1) as OutletSK,
        isnull(cd.CallsPresented, 0) CallsPresented,
        isnull(cd.CallsHandled, 0) CallsHandled,
        isnull(cd.CallsAbandoned, 0) CallsAbandoned,
        isnull(cd.RingTime, 0) RingTime,
        isnull(cd.TalkTime, 0) TalkTime,
        isnull(cd.HoldTime, 0) HoldTime,
        isnull(cd.WorkTime, 0) WorkTime,
        isnull(cd.WrapUpTime, 0) WrapUpTime,
        isnull(cd.QueueTime, 0) QueueTime,
        isnull(convert(int, cd.MetServiceLevel), 0) MetServiceLevel,
        isnull(convert(int, cd.Transfer), 0) Transfered,
        isnull(convert(int, cd.Redirect), 0) Redirect,
        isnull(convert(int, cd.Conference), 0) Conference,
        convert(int, 0) RingNoAnswer
    into #factCalls
    from
        [db-au-cba]..cisCallData cd
        inner join [db-au-cba]..cisAgent ca on 
            ca.AgentKey = cd.AgentKey 
        outer apply
        (
            select top 1 
                Date_SK 
            from
                [db-au-star]..Dim_Date d
            where
                d.[Date] = convert(date, cd.CallStartDateTime)
        ) d
        outer apply
        (
            select top 1 
                EmployeeSK
            from
                [db-au-star]..dimEmployee e
            where
                e.EmployeeID = ca.AgentLogin
        ) e
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
                        e.UserID SupervisorID
                    from
                        [db-au-cba]..verEmployee ves 
                        outer apply
                        (
                            select top 1 
                                UserID
                            from
                                [db-au-cba]..usrLDAP l
                            where
                                l.UserName = ves.UserName
                            order by 
                                case
                                    when DeleteDateTime is null then 0
                                    else 1
                                end                 
                        ) e
                    where
                        ves.EmployeeKey = vat.SupervisorEmployeeKey
                ) s
            where
                ve.UserName = ca.AgentLogin and 
                vat.ActivityStartTime >= convert(date, cd.CallStartDateTime) and 
                vat.ActivityStartTime <  dateadd(day, 1, convert(date, cd.CallStartDateTime))
        ) s
        outer apply
        (
            select top 1 
                EmployeeSK SupervisorSK
            from
                [db-au-star]..dimEmployee e
            where
                e.EmployeeID = s.SupervisorID
        ) es
        outer apply
        (
            select top 1
                TeamSK
            from
                [db-au-star]..dimTeam t
            where
                t.TeamID = s.TeamID
        ) t
        outer apply
        (
            select top 1
                csq.CSQSK, o.OutletSK
            from
                [db-au-star]..dimCSQ csq
                inner join [db-au-star].dbo.dimOutlet o on
					(case when csq.CSQName in ('CS_AAA_RACQ_SALES','CS_AAA_SALES','CS_AP_Sales','CS_CM_Sales','CS_IAL_Sales','CS_YG_Sales') then 'CMN0000'
						  else 'UNKNOWN'
				     end) = o.AlphaCode and o.isLatest = 'Y'
            where
                csq.CSQID = cd.CSQKey
        ) csq
    where
        cd.CallStartDateTime >= @start and
        cd.CallStartDateTime <  dateadd(day, 1, @end)
        
    union all
    
    select 
        isnull(Date_SK, -1) DateSK,
        isnull(e.EmployeeSK, -1) EmployeeSK,
        isnull(es.SupervisorSK, -1) SupervisorSK,
        isnull(t.TeamSK, -1) TeamSK,
        isnull(csq.CSQSK, -1) CSQSK,
        isnull(csq.OutletSK, -1) OutletSK,
        0 CallsPresented,
        0 CallsHandled,
        0 CallsAbandoned,
        0 RingTime,
        0 TalkTime,
        0 HoldTime,
        0 WorkTime,
        0 WrapUpTime,
        0 QueueTime,
        0 MetServiceLevel,
        0 Transfered,
        0 Redirect,
        0 Conference,
        isnull(convert(int, cd.RingNoAnswer), 0) RingNoAnswer
    from
        [db-au-cba]..cisRNA cd
        inner join [db-au-cba]..cisAgent ca on 
            ca.AgentKey = cd.AgentKey 
        outer apply
        (
            select top 1 
                Date_SK 
            from
                [db-au-star]..Dim_Date d
            where
                d.[Date] = convert(date, cd.CallStartDateTime)
        ) d
        outer apply
        (
            select top 1 
                EmployeeSK
            from
                [db-au-star]..dimEmployee e
            where
                e.EmployeeID = ca.AgentLogin
        ) e
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
                        e.UserID SupervisorID
                    from
                        [db-au-cba]..verEmployee ves 
                        outer apply
                        (
                            select top 1 
                                UserID
                            from
                                [db-au-cba]..usrLDAP l
                            where
                                l.UserName = ves.UserName
                            order by 
                                case
                                    when DeleteDateTime is null then 0
                                    else 1
                                end                 
                        ) e
                    where
                        ves.EmployeeKey = vat.SupervisorEmployeeKey
                ) s
            where
                ve.UserName = ca.AgentLogin and 
                vat.ActivityStartTime >= convert(date, cd.CallStartDateTime) and 
                vat.ActivityStartTime <  dateadd(day, 1, convert(date, cd.CallStartDateTime))
        ) s
        outer apply
        (
            select top 1 
                EmployeeSK SupervisorSK
            from
                [db-au-star]..dimEmployee e
            where
                e.EmployeeID = s.SupervisorID
        ) es
        outer apply
        (
            select top 1
                TeamSK
            from
                [db-au-star]..dimTeam t
            where
                t.TeamID = s.TeamID
        ) t
        outer apply
        (
            select top 1
                csq.CSQSK, o.OutletSK
            from
                [db-au-star]..dimCSQ csq
                inner join [db-au-star].dbo.dimOutlet o on
					(case when csq.CSQName in ('CS_AAA_RACQ_SALES','CS_AAA_SALES','CS_AP_Sales','CS_CM_Sales','CS_IAL_Sales','CS_YG_Sales') then 'CMN0000'
						  else 'UNKNOWN'
				     end) = o.AlphaCode and o.isLatest = 'Y'
            where
                csq.CSQID = cd.CSQKey
        ) csq
    where
        cd.CallStartDateTime >= @start and
        cd.CallStartDateTime <  dateadd(day, 1, @end)
    
            
    set @sourcecount = @@rowcount

    begin transaction

    begin try
    
        delete from [db-au-star].dbo.factCalls
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
            
        insert into [db-au-star].dbo.factCalls with (tablock)
        (
            DateSK,
            EmployeeSK,
            SupervisorSK,
            TeamSK,
            CSQSK,
            OutletSK,
            CallsPresented,
            CallsHandled,
            CallsAbandoned,
            RingTime,
            TalkTime,
            HoldTime,
            WorkTime,
            WrapUpTime,
            QueueTime,
            MetServiceLevel,
            Transfered,
            Redirect,
            Conference,
            RingNoAnswer,
            CreateBatchID
        )
        select 
            DateSK,
            EmployeeSK,
            SupervisorSK,
            TeamSK,
            CSQSK,
            OutletSK,
            sum(CallsPresented),
            sum(CallsHandled),
            sum(CallsAbandoned),
            sum(RingTime),
            sum(TalkTime),
            sum(HoldTime),
            sum(WorkTime),
            sum(WrapUpTime),
            sum(QueueTime),
            sum(MetServiceLevel),
            sum(Transfered),
            sum(Redirect),
            sum(Conference),
            sum(RingNoAnswer),
            @batchid
        from
            #factCalls
        group by
            DateSK,
            EmployeeSK,
            SupervisorSK,
            TeamSK,
            CSQSK,
            OutletSK
        

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
