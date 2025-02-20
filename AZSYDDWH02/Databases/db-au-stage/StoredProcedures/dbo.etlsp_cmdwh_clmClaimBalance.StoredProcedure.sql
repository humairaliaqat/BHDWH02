USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmClaimBalance]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_clmClaimBalance]
    @MonthStart date

as
begin

--20160901, LL, create
--20180927, LT, Customised for CBA


    if object_id('[db-au-cba].dbo.clmClaimBalance') is null
    begin

        create table [db-au-cba].dbo.clmClaimBalance
        (

            [BIRowID] int not null identity(1,1),
	        [ClaimKey] [varchar](41) not null,
	        [OpeningDate] [date] not null,
            [EstimateOpening] [money] null,
            [ActiveOpening] smallint
        )

        create clustered index idx_clmClaimBalance_BIRowID on [db-au-cba].dbo.clmClaimBalance(BIRowID)
        create nonclustered index idx_clmClaimBalance_ClaimKey on [db-au-cba].dbo.clmClaimBalance(ClaimKey,OpeningDate desc) include(EstimateOpening,ActiveOpening)
        create nonclustered index idx_clmClaimBalance_Date on [db-au-cba].dbo.clmClaimBalance(OpeningDate,ClaimKey) include(EstimateOpening,ActiveOpening)

    end


    begin transaction

    begin try
    
        delete 
        from 
            [db-au-cba]..clmClaimBalance
        where
            [OpeningDate] = @MonthStart

        insert into [db-au-cba].dbo.clmClaimBalance with(tablock)
        (
	        [ClaimKey],
	        [OpeningDate],
	        [EstimateOpening],
	        [ActiveOpening]
        )
        select
            ClaimKey,
            @MonthStart OpeningDate,
            sum(EstimateDelta) EstimateOpening,
            case
                when sum(NewCount + ReopenedCount - ClosedCount) > 0 then 1
                else 0
            end ActiveOpening
        from
            [db-au-cba]..clmClaimIntradayMovement cim
            outer apply
            (
                select
                    max(cb.OpeningDate) LastBalanceDate
                from
                    [db-au-cba].dbo.clmClaimBalance cb
                where
                    cb.ClaimKey = cim.ClaimKey and
                    cb.OpeningDate < @MonthStart
            ) lb
            outer apply
            (
                select top 1
                    1 CreateBalance
                from
                    [db-au-cba]..clmClaimIntradayMovement r
                where
                    r.ClaimKey = cim.ClaimKey and
                    r.IncurredDate >= lb.LastBalanceDate and
                    r.IncurredDate <  @MonthStart
            ) r
        where
            cim.IncurredDate < @MonthStart and
            (
                lb.LastBalanceDate is null or
                r.CreateBalance = 1
            )
        group by
            ClaimKey

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'clmClaimBalance data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = -1,
            @PackageID = 'clmClaimBalance'

    end catch

    if @@trancount > 0
        commit transaction

end

GO
