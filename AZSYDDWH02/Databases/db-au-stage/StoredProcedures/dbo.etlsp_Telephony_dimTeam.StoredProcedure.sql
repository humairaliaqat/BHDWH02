USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_Telephony_dimTeam]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_Telephony_dimTeam]
as
begin
/************************************************************************************************************************************
Author:         Leo
Date:           20141217
Prerequisite:   Verint
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

    if object_id('[db-au-star].dbo.dimTeam') is null
    begin

        create table [db-au-star].dbo.dimTeam
        (
            TeamSK int not null identity(1,1),
            TeamID int null,
            TeamName nvarchar(255),
            TeamDescription nvarchar(255),
            Timezone nvarchar(50),
            CreateBatchID int,
            UpdateBatchID int
        )
        
        create clustered index idx_dimTeam_TeamSK on [db-au-star].dbo.dimTeam(TeamSK)
        create nonclustered index idx_dimTeam_TeamID on [db-au-star].dbo.dimTeam(TeamID)
        
        set identity_insert [db-au-star].dbo.dimTeam on

        insert [db-au-star].[dbo].dimTeam
        (
            TeamSK,
            TeamID,
            TeamName,
            TeamDescription,
            Timezone,
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
            @batchid,
            @batchid
        )

        set identity_insert [db-au-star].dbo.dimTeam off
        
    end
    
    if object_id('tempdb..#dimTeam') is not null
        drop table #dimTeam

    select 
        OrganisationKey TeamID,
        OrganisationName TeamName,
        OrganisationDescription TeamDescription,
        Timezone
    into #dimTeam
    from
        [db-au-cba]..verOrganisation
    
    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-star].dbo.dimTeam with(tablock) t
        using #dimTeam s on
            s.TeamID = t.TeamID

        when
            matched and
            binary_checksum(
                t.TeamName,
                t.TeamDescription,
                t.Timezone
            ) <>
            binary_checksum(
                s.TeamName,
                s.TeamDescription,
                s.Timezone
            )
        then

            update
            set
                TeamName = s.TeamName,
                TeamDescription = s.TeamDescription,
                Timezone = s.Timezone,
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                TeamID,
                TeamName,
                TeamDescription,
                Timezone,
                CreateBatchID
            )
            values
            (
                s.TeamID,
                s.TeamName,
                s.TeamDescription,
                s.Timezone,
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
