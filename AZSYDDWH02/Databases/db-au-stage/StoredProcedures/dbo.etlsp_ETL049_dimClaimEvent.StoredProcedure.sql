USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL049_dimClaimEvent]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_ETL049_dimClaimEvent]
    @DateRange varchar(30),
    @StartDate date = null,
    @EndDate date = null

as
begin
--20150722, LS, put in stored procedure

--uncomment to debug
--declare @DateRange varchar(30)
--declare @StartDate date
--declare @EndDate date
--select @DateRange = 'Last 30 Days'

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
    
    set @name = 'etlsp_ETL049_dimClaimEvent'

    /* get dates */
    select
        @start = @StartDate,
        @end = @EndDate

    if @DateRange <> '_User Defined'
        select
            @start = StartDate,
            @end = EndDate
        from
            [db-au-cba].dbo.vDateRange
        where
            DateRange = @DateRange

    /* check if this is running on a batch or standalone */
    begin try
    
        exec syssp_getrunningbatch
            @SubjectArea = 'Claim STAR',
            @BatchID = @batchid out,
            @StartDate = @start out,
            @EndDate = @end out
        
        exec syssp_genericerrorhandler
            @LogToTable = 1,
            @ErrorCode = '0',
            @BatchID = @batchid,
            @PackageID = @name,
            @LogStatus = 'Running'
            
    end try
    
    begin catch
    
        set @batchid = -1
    
    end catch

    if object_id('[db-au-star].dbo.dimClaimEvent') is null
    begin

        create table [db-au-star].dbo.dimClaimEvent
        (
            [ClaimEventSK] bigint not null identity(1,1),
            [ClaimKey] varchar(40) not null,
            [EventKey] varchar(40) not null,
            [EventType] varchar(15) not null,
            [EventCountryCode] varchar(10) not null,
            [EventCountryName] nvarchar(45) not null,
            [CatastropheCode] varchar(10) not null,
            [Catastrophe] nvarchar(20) not null,
            [PerilCode] varchar(10) not null,
            [Peril] nvarchar(65) not null,
            [CreateBatchID] int,
            [UpdateBatchID] int
        )

        create clustered index idx_dimClaimEvent_ClaimEventSK on [db-au-star].dbo.dimClaimEvent(ClaimEventSK)
        create nonclustered index idx_dimClaimEvent_EventKey on [db-au-star].dbo.dimClaimEvent(EventKey)
        create nonclustered index idx_dimClaimEvent_ClaimKey on [db-au-star].dbo.dimClaimEvent(ClaimKey)

        set identity_insert [db-au-star].dbo.dimClaimEvent on

        insert into [db-au-star].dbo.dimClaimEvent
        (
            [ClaimEventSK],
            [ClaimKey],
            [EventKey],
            [EventType],
            [EventCountryCode],
            [EventCountryName],
            [CatastropheCode],
            [Catastrophe],
            [PerilCode],
            [Peril],
            [CreateBatchID],
            [UpdateBatchID]
        )
        select 
            -1 ClaimEventSK,
            'Unknown' ClaimKey,
            'Unknown' EventKey,
            'Unknown' EventType,
            'Unknown' EventCountryCode,
            'Unknown' EventCountryName,
            'Unknown' CatastropheCode,
            'Unknown' Catastrophe,
            'Unknown' PerilCode,
            'Unknown' Peril,
            -1 CreateBatchID,
            -1 UpdateBatchID

        set identity_insert [db-au-star].dbo.dimClaimEvent off

    end

    /*what has changed during the period*/
    exec etlsp_ETL049_helper_UpdatedClaim
        @StartDate = @start,
        @EndDate = @end
        
    if object_id('etl_UpdatedClaim') is null
        create table etl_UpdatedClaim (ClaimKey varchar(40))

    if object_id('tempdb..#dimClaimEvent') is not null
        drop table #dimClaimEvent

    select 
        ce.ClaimKey,
        ce.EventKey,
        case
            when rtrim(isnull(CatastropheCode, '')) in ('', 'CC', 'REC') then 'Non-Catastrophe'
            else 'Catastrophe'
        end EventType,
        isnull(convert(varchar(10), ce.EventCountryCode), 'Unknown') EventCountryCode,
        isnull(cecn.EventCountryName, 'Unknown') EventCountryName,
        isnull(ce.CatastropheCode, 'N/A') CatastropheCode,
        isnull(cec.CatastropheDescription, 'N/A') Catastrophe,
        isnull(convert(varchar(10), ce.PerilCode), 'Unknown') PerilCode,
        isnull(cep.PerilDescription, 'Unknown') Peril
    into #dimClaimEvent
    from
        [db-au-cba]..clmEvent ce
        outer apply
        (
            select top 1 
                CatastropheShortDesc CatastropheDescription
            from
                [db-au-cba]..clmEvent p
            where
                p.CatastropheCode = ce.CatastropheCode
            group by
                CatastropheShortDesc
            order by
                count(p.EventKey) desc
        ) cec
        outer apply
        (
            select top 1 
                EventCountryName
            from
                [db-au-cba]..clmEvent p
            where
                p.EventCountryCode = ce.EventCountryCode
            group by
                EventCountryName
            order by
                count(p.EventKey) desc
        ) cecn
        outer apply
        (
            select top 1 
                PerilDesc PerilDescription
            from
                [db-au-cba]..clmEvent p
            where
                p.PerilCode = ce.PerilCode
            group by
                PerilDesc
            order by
                count(p.EventKey) desc
        ) cep
    where
        ce.ClaimKey in
        (
            select
                ClaimKey
            from
                etl_UpdatedClaim
        )

    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-star].dbo.dimClaimEvent with(tablock) t
        using #dimClaimEvent s on
            s.EventKey = t.EventKey

        when matched then

            update
            set
                ClaimKey = s.ClaimKey,
                EventType = s.EventType,
                EventCountryCode = s.EventCountryCode,
                EventCountryName = s.EventCountryName,
                CatastropheCode = s.CatastropheCode,
                Catastrophe = s.Catastrophe,
                PerilCode = s.PerilCode,
                Peril = s.Peril,
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                ClaimKey,
                EventKey,
                EventType,
                EventCountryCode,
                EventCountryName,
                CatastropheCode,
                Catastrophe,
                PerilCode,
                Peril,
                CreateBatchID
            )
            values
            (
                s.ClaimKey,
                s.EventKey,
                s.EventType,
                s.EventCountryCode,
                s.EventCountryName,
                s.CatastropheCode,
                s.Catastrophe,
                s.PerilCode,
                s.Peril,
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
            @SourceInfo = 'dimClaimEvent data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end

GO
