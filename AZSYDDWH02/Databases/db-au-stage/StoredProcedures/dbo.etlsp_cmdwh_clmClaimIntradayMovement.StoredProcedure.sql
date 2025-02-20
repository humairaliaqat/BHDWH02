USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmClaimIntradayMovement]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_clmClaimIntradayMovement]
    @DateRange varchar(30),
    @StartDate date = null,
    @EndDate date = null

as
begin

--20160901, LS, create, materialised view
--20160902, LL, use movementsequence to handle movement with exact same time
--20160906, LL, always process to date
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
    
    select @name = 'etlsp_cmdwh_clmClaimIntradayMovement' --object_name(@@procid)

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

    select @EndDate = convert(date, getdate())


    if object_id('[db-au-cba].dbo.clmClaimIntradayMovement') is null
    begin

        create table [db-au-cba].dbo.clmClaimIntradayMovement
        (
            [BIRowID] int not null identity(1,1),
            [ClaimKey] [varchar](40) not null,
            [FirstIncurredDate] date,
            [AbsoluteAge] int,
            [PreviousAbsoluteAge] int,
            [IncurredDate] [date] null,
            [IncurredTime] [datetime] null,
            [IncurredAge] int,
            [Estimate] decimal(20,6) null,
            [Paid] decimal(20,6) null,
            [IncurredValue] decimal(20,6) null,
            [PreviousEstimate] decimal(20,6) null,
            [PreviousPaid] decimal(20,6) null,
            [PreviousIncurred] decimal(20,6) null,
            [EstimateDelta] decimal(20,6) null,
            [PaymentDelta] decimal(20,6) null,
            [IncurredDelta] decimal(20,6) null,
            [NewCount] int,
            [ReopenedCount] int,
            [ClosedCount] int,
            [BatchID] int null
        )

        create clustered index idx_clmClaimIntradayMovement_BIRowID on [db-au-cba].dbo.clmClaimIntradayMovement(BIRowID)
        create nonclustered index idx_clmClaimIntradayMovement_ClaimKey on [db-au-cba].dbo.clmClaimIntradayMovement(ClaimKey,IncurredDate) include(EstimateDelta,PaymentDelta,IncurredDelta,NewCount,ReopenedCount,ClosedCount)
        create nonclustered index idx_clmClaimIntradayMovement_IncurredDate on [db-au-cba].dbo.clmClaimIntradayMovement(IncurredDate,ClaimKey) include(EstimateDelta,PaymentDelta,IncurredDelta,NewCount,ReopenedCount,ClosedCount)

    end

    
    begin transaction

    begin try
    
        delete 
        from 
            [db-au-cba]..clmClaimIntradayMovement
        where
            IncurredDate >= @StartDate and
            IncurredDate <  dateadd(day, 1, @EndDate)

        insert into [db-au-cba].dbo.clmClaimIntradayMovement with(tablock)
        (
            [ClaimKey],
            [FirstIncurredDate],
            [AbsoluteAge],
            [PreviousAbsoluteAge],
            [IncurredDate],
            [IncurredTime],
            [IncurredAge],
            [Estimate],
            [Paid],
            [IncurredValue],
            [PreviousEstimate] ,
            [PreviousPaid],
            [PreviousIncurred],
            [EstimateDelta],
            [PaymentDelta],
            [IncurredDelta],
            [NewCount],
            [ReopenedCount],
            [ClosedCount],
            [BatchID]
        )
        select 
            ClaimKey,
            FirstIncurredDate,
            datediff(d, FirstIncurredDate, IncurredDate) AbsoluteAge,
            datediff(d, FirstIncurredDate, isnull(PreviousDate, IncurredDate)) PreviousAbsoluteAge,
            IncurredDate,
            IncurredTime,
            datediff(d, isnull(PreviousDate, IncurredDate), IncurredDate) IncurredAge,
            Estimate,
            Paid,
            IncurredValue,
            Estimate - EstimateMovement PreviousEstimate,
            Paid - PaymentMovement PreviousPaid,
            IncurredValue - IncurredMovement PreviousIncurred,
            EstimateMovement EstimateDelta,
            PaymentMovement PaymentDelta,
            IncurredMovement IncurredDelta,
            case
                --the first incurred movement is an open
                when FirstMovement = 1 then 1
                else 0
            end NewCount,
            case
                --the first incurred movement is an open, thus it's not a reopen
                when FirstMovement = 1 then 0
                --if new estimate is now positive from previous estimate that's 0 and there has been negative estimate movement (i.e. closed) then it's a reopen
                when 
                    Estimate > 0 and 
                    (Estimate - EstimateMovement) = 0 and
                    --leave this block as is, not using 'exists' as sql use index scan for it instead of index seek with this form
                    (
                        select
                            max(r.IncurredDate)
                        from
                            [db-au-cba]..clmClaimIncurredMovement r with(nolock)
                        where
                            r.ClaimKey = t.ClaimKey and
                            r.IncurredDate <= t.IncurredDate and
                            r.MovementSequence < t.MovementSequence and
                            r.EstimateMovement < 0
                    ) is not null
                then 1
                --if the estimate is 0 and there's no estimate movement on the day, the first payment of the day is a reopen (to be closed at the same time), as long as it's not an open
                when 
                    Estimate = 0 and
                    (
                        select
                            max(r.IncurredDate)
                        from
                            [db-au-cba]..clmClaimIncurredMovement r with(nolock)
                        where
                            r.ClaimKey = t.ClaimKey and
                            r.IncurredDate = t.IncurredDate and
                            r.EstimateMovement <> 0
                    ) is null and
                    PaymentMovement <> 0 and
                    FirstMovement = 0 and
                    FirstMovementInDay = 1
                then 1
                else 0
            end ReopenedCount,
            case
                --estimate movement to 0 from non 0 estimate is a close
                when Estimate = 0 and (Estimate - EstimateMovement) <> 0 then 1
                --if the estimate is 0 and there's no estimate movement on the day, the first payment of the day is a reopen (to be closed at the same time), as long as it's not an open
                when 
                    Estimate = 0 and
                    (
                        select
                            max(r.IncurredDate)
                        from
                            [db-au-cba]..clmClaimIncurredMovement r with(nolock)
                        where
                            r.ClaimKey = t.ClaimKey and
                            r.IncurredDate = t.IncurredDate and
                            r.EstimateMovement <> 0
                    ) is null and
                    PaymentMovement <> 0 and
                    FirstMovement = 0 and
                    FirstMovementInDay = 1
                then 1
                --if there's only 1 record ever and it's been a while and estimate = 0 then it's a close
                when 
                    Estimate = 0 and
                    IncurredDate < dateadd(month, -4, getdate()) and
                    count(IncurredDate) over (partition by ClaimKey) = 1
                then 1
                --if it's an old record with no positive estimate movement, the first one (open) is also a close
                when 
                    (
                        select
                            max(r.IncurredDate)
                        from
                            [db-au-cba]..clmClaimIncurredMovement r with(nolock)
                        where
                            r.ClaimKey = t.ClaimKey and
                            r.EstimateMovement > 0
                    ) is null and
                    IncurredDate < dateadd(month, -4, getdate()) and
                    FirstMovement = 1
                then 1
                else 0
            end ClosedCount,
            @batchid
        from
            [db-au-cba]..clmClaimIncurredMovement t with(nolock)
            cross apply
            (
                select
                    (EstimateMovement + PaymentMovement) IncurredMovement
            ) i
            cross apply
            (
                select
                    sum(EstimateMovement) Estimate,
                    sum(PaymentMovement) Paid,
                    sum(EstimateMovement + PaymentMovement) IncurredValue
                from
                    [db-au-cba]..clmClaimIncurredMovement r with(nolock)
                where
                    r.ClaimKey = t.ClaimKey and
                    r.IncurredDate <= t.IncurredDate and
                    r.IncurredTime <= t.IncurredTime and
                    r.MovementSequence <= t.MovementSequence
            ) r
            outer apply
            (
                select 
                    max(IncurredDate) PreviousDate
                from
                    [db-au-cba]..clmClaimIncurredMovement r with(nolock)
                where
                    r.ClaimKey = t.ClaimKey and
                    r.IncurredDate < t.IncurredDate and
                    r.IncurredTime < t.IncurredTime
            ) pd
            outer apply
            (
                select 
                    min(IncurredDate) FirstIncurredDate
                from
                    [db-au-cba]..clmClaimIncurredMovement r with(nolock)
                where
                    r.ClaimKey = t.ClaimKey
            ) fd
        where
            ClaimKey like '%' and --leave this here
            IncurredDate >= @StartDate and
            IncurredDate <  dateadd(day, 1, @EndDate)

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'clmClaimIntradayMovement data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = -1,
            @PackageID = 'clmClaimIntradayMovement'

    end catch

    if @@trancount > 0
        commit transaction

end


GO
