USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmClaimIncurredMovement]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_clmClaimIncurredMovement]
    @DateRange varchar(30),
    @StartDate date = null,
    @EndDate date = null

as
begin

--20160830, LS, create, materialised combined estimate & payment movement
--20160902, LL, add movement sequence to handle records with same time e.g. deletion
--20180927, LT, Customised for CBA

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
    
    set @name = object_name(@@procid)

    /* get dates */
    /* check if this is running on a batch or standalone */
    if @DateRange <> '_User Defined'
        select
            @StartDate = StartDate,
            @EndDate = EndDate
        from
            [db-au-cba].dbo.vDateRange
        where
            DateRange = @DateRange

    begin try
    
        exec syssp_getrunningbatch
            @SubjectArea = 'Claim ODS',
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

    /* synced rollup with main Claim etl */
    
    if object_id('etl_clmClaim_sync') is null
        create table etl_clmClaim_sync
        (
            ClaimKey varchar(40) null
        )

    if exists 
    (
        select 
            null 
        from 
            etl_clmClaim_sync 
        where 
            ClaimKey is not null
    )
    begin

        /* prepare created/updated claims to roll up */
        if object_id('etl_clmClaimIncurredMovement') is not null
            drop table etl_clmClaimIncurredMovement

        select
            ClaimKey
        into etl_clmClaimIncurredMovement
        from
            etl_clmClaim_sync

    end

    else
    begin

        /* prepare created/updated claims to roll up */
        if object_id('etl_clmClaimIncurredMovement') is not null
            drop table etl_clmClaimIncurredMovement

        select
            ClaimKey
        into etl_clmClaimIncurredMovement
        from
            [db-au-cba].dbo.clmClaim
        where
            (
                CreateDate >= @StartDate and
                CreateDate <  dateadd(day, 1, @EndDate)
            ) 
            or
            (
                FinalisedDate >= @StartDate and
                FinalisedDate <  dateadd(day, 1, @EndDate)
            )

        union
        
        select
            ClaimKey
        from
            [db-au-cba].dbo.clmAuditClaim
        where
            AuditDateTime >= @StartDate and
            AuditDateTime <  dateadd(day, 1, @EndDate)

        union

        select
            ClaimKey
        from
            [db-au-cba].dbo.clmAuditPayment
        where
            AuditDateTime >= @StartDate and
            AuditDateTime <  dateadd(day, 1, @EndDate)

        union

        select
            ClaimKey
        from
            [db-au-cba].dbo.clmPayment
        where
            ModifiedDate >= @StartDate and
            ModifiedDate <  dateadd(day, 1, @EndDate)

        union

        select
            ClaimKey
        from
            [db-au-cba].dbo.clmAuditSection
        where
            AuditDateTime >= @StartDate and
            AuditDateTime <  dateadd(day, 1, @EndDate)

        union

        select
            ClaimKey
        from
            [db-au-cba].dbo.clmEstimateHistory eh
        where
            EHCreateDate >= @StartDate and
            EHCreateDate <  dateadd(day, 1, @EndDate)

    end


    if object_id('[db-au-cba].dbo.clmClaimIncurredMovement') is null
    begin

        create table [db-au-cba].dbo.clmClaimIncurredMovement
        (
            [BIRowID] int not null identity(1,1),
	        [ClaimKey] [varchar](40) not null,
	        [IncurredTime] [datetime] null,
	        [IncurredDate] [date] null,
	        [EstimateMovement] decimal(20,6) null,
	        [RecoveryEstimateMovement] decimal(20,6) null,
	        [PaymentMovement] decimal(20,6) null,
            [MovementSequence] bigint,
            [FirstMovement] bit,
            [FirstMovementInDay] bit,
            [BatchID] int null
        )

        create clustered index idx_clmClaimIncurredMovement_BIRowID on [db-au-cba].dbo.clmClaimIncurredMovement(BIRowID)
        create nonclustered index idx_clmClaimIncurredMovement_ClaimKey on [db-au-cba].dbo.clmClaimIncurredMovement(ClaimKey,IncurredTime) include(IncurredDate,EstimateMovement,RecoveryEstimateMovement,PaymentMovement,FirstMovement,FirstMovementInDay,MovementSequence)
        create nonclustered index idx_clmClaimIncurredMovement_ClaimKeyDate on [db-au-cba].dbo.clmClaimIncurredMovement(ClaimKey,IncurredDate) include(IncurredTime,EstimateMovement,PaymentMovement,MovementSequence)
        create nonclustered index idx_clmClaimIncurredMovement_IncurredDate on [db-au-cba].dbo.clmClaimIncurredMovement(IncurredDate,ClaimKey) include(IncurredTime,EstimateMovement,RecoveryEstimateMovement,PaymentMovement,FirstMovement,FirstMovementInDay,MovementSequence)

    end
    
    
    begin transaction

    begin try
    
        delete 
        from 
            [db-au-cba]..clmClaimIncurredMovement
        where
            ClaimKey in
            (
                select 
                    ClaimKey
                from
                    etl_clmClaimIncurredMovement
            )

        insert into [db-au-cba].dbo.clmClaimIncurredMovement with(tablock)
        (
            ClaimKey,
            IncurredTime,
            IncurredDate,
            EstimateMovement,
            RecoveryEstimateMovement,
            PaymentMovement,
            MovementSequence,
            FirstMovement,
            FirstMovementInDay,
            BatchID
        )
        select 
            ClaimKey,
            IncurredTime,
            IncurredDate,
            EstimateMovement,
            RecoveryEstimateMovement,
            PaymentMovement,
            row_number() over (partition by ClaimKey order by IncurredTime) MovementSequence,
            case
                when row_number() over (partition by ClaimKey order by IncurredTime) = 1 then 1
                else 0
            end FirstMovement,
            case
                when row_number() over (partition by ClaimKey, IncurredDate order by IncurredTime) = 1 then 1
                else 0
            end FirstMovementInDay,
            @batchid
        from
            (
                select 
                    ClaimKey,
                    EstimateDateTime IncurredTime,
                    convert(date, EstimateDateTime) IncurredDate,
                    EstimateMovement,
                    RecoveryEstimateMovement,
                    0 PaymentMovement
                from
                    [db-au-cba]..clmClaimEstimateMovement with(nolock)
                where
                    ClaimKey in
                    (
                        select
                            ClaimKey
                        from
                            etl_clmClaimIncurredMovement
                    )

                union all
                
                select 
                    ClaimKey,
                    PaymentDateTime IncurredTime,
                    convert(date, PaymentDateTime) IncurredDate,
                    0 EstimateMovement,
                    0 RecoveryEstimateMovement,
                    PaymentMovement + RecoveryPaymentMovement PaymentMovement
                from
                    [db-au-cba]..clmClaimPaymentMovement with(nolock)
                where
                    ClaimKey in
                    (
                        select
                            ClaimKey
                        from
                            etl_clmClaimIncurredMovement
                    )
            ) t

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'clmClaimIncurredMovement data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = -1,
            @PackageID = 'clmClaimIncurredMovement'

    end catch

    if @@trancount > 0
        commit transaction

end


GO
