USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_Telephony_dimEmployee]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_Telephony_dimEmployee]
as
begin
/************************************************************************************************************************************
Author:         Leo
Date:           20141217
Prerequisite:   LDAP, Verint
Description:    
Change History:
                20141217 - LS - created
                20150227 - LS - filter out deleted ldap accounts

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

    if object_id('[db-au-star].dbo.dimEmployee') is null
    begin

        create table [db-au-star].dbo.dimEmployee
        (
            EmployeeSK int not null identity(1,1),
            ManagerSK int null,
            EmployeeID nvarchar(320),
            ManagerID nvarchar(320),
            EmailAddress nvarchar(320),
            EmployeeName nvarchar(640),
            FirstName nvarchar(320),
            LastName nvarchar(320),
            Department nvarchar(255),
            Company nvarchar(255),
            JobTitle nvarchar(255),
            isCSRAgent bit,
            isActive bit,
            CreateBatchID int,
            UpdateBatchID int
        )
        
        create clustered index idx_dimEmployee_EmployeeSK on [db-au-star].dbo.dimEmployee(EmployeeSK)
        create nonclustered index idx_dimEmployee_EmployeeID on [db-au-star].dbo.dimEmployee(EmployeeID)
        
        set identity_insert [db-au-star].dbo.dimEmployee on

        insert [db-au-star].[dbo].dimEmployee
        (
            EmployeeSK,
            ManagerSK,
            EmployeeID,
            ManagerID,
            EmailAddress,
            EmployeeName,
            FirstName,
            LastName,
            Department,
            Company,
            JobTitle,
            isCSRAgent,
            isActive,
            CreateBatchID,
            UpdateBatchID
        )
        values
        (
            -1,
            null,
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            1,
            0,
            @batchid,
            @batchid
        )

        set identity_insert [db-au-star].dbo.dimEmployee off
        
    end
    
    if object_id('tempdb..#dimEmployee') is not null
        drop table #dimEmployee

    select 
        a.UserName EmployeeID,
        m.UserName ManagerID,
        a.EmailAddress,
        a.DisplayName EmployeeName,
        a.FirstName,
        a.LastName,
        a.Department,
        a.Company,
        a.JobTitle,
        case
            when ve.BIRowID is not null then 1
            else 0
        end isCSRAgent,
        a.isActive
    into #dimEmployee
    from
        [db-au-cba]..usrLDAP a
        left join [db-au-cba]..usrLDAP m on
            m.UserID = a.ManagerID and
            m.DeleteDateTime is null
        outer apply
        (
            select top 1
                e.BIRowID
            from
                [db-au-cba]..verEmployee e
            where
                e.UserName = a.UserName
        ) ve
    where
        a.DeleteDateTime is null
    
    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-star].dbo.dimEmployee with(tablock) t
        using #dimEmployee s on
            s.EmployeeID = t.EmployeeID

        when
            matched and
            binary_checksum(
                t.ManagerID,
                t.EmailAddress,
                t.EmployeeName,
                t.Department,
                t.Company,
                t.JobTitle,
                t.isCSRAgent,
                t.isActive
            ) <>
            binary_checksum(
                s.ManagerID,
                s.EmailAddress,
                s.EmployeeName,
                s.Department,
                s.Company,
                s.JobTitle,
                s.isCSRAgent,
                s.isActive
            )
        then

            update
            set
                ManagerID = s.ManagerID,
                EmailAddress = s.EmailAddress,
                EmployeeName = s.EmployeeName,
                FirstName = s.FirstName,
                LastName = s.LastName,
                Department = s.Department,
                Company = s.Company,
                JobTitle = s.JobTitle,
                isCSRAgent = s.isCSRAgent,
                isActive = s.isActive,
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                EmployeeID,
                ManagerID,
                EmailAddress,
                EmployeeName,
                FirstName,
                LastName,
                Department,
                Company,
                JobTitle,
                isCSRAgent,
                isActive,
                CreateBatchID
            )
            values
            (
                s.EmployeeID,
                s.ManagerID,
                s.EmailAddress,
                s.EmployeeName,
                s.FirstName,
                s.LastName,
                s.Department,
                s.Company,
                s.JobTitle,
                s.isCSRAgent,
                s.isActive,
                @batchid
            )

        output $action into @mergeoutput
        ;

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
            @mergeoutput

        exec syssp_genericerrorhandler
            @LogToTable = 1,
            @ErrorCode = '0',
            @BatchID = @batchid,
            @PackageID = @name,
            @LogStatus = 'Finished',
            @LogSourceCount = @sourcecount,
            @LogInsertCount = @insertcount,
            @LogUpdateCount = @updatecount
            
        update t
        set
            t.ManagerSK = r.ManagerSK
        from
            [db-au-star].dbo.dimEmployee t
            outer apply
            (
                select top 1
                    EmployeeSK ManagerSK
                from
                    [db-au-star].dbo.dimEmployee r
                where
                    r.EmployeeID = t.ManagerID
            ) r

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
