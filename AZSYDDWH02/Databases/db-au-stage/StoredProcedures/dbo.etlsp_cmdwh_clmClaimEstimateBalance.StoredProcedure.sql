USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmClaimEstimateBalance]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_clmClaimEstimateBalance]
    @MonthStart date

as
begin

--20150722, LS, release to prod
--20160901, LL, drop UTC
--20180927, LT, Customised for CBA

    if object_id('[db-au-cba].dbo.clmClaimEstimateBalance') is null
    begin

        create table [db-au-cba].dbo.clmClaimEstimateBalance
        (

            [BIRowID] int not null identity(1,1),
	        [CountryKey] [varchar](2) not null,
	        [Date] [date] not null,
	        [BenefitCategory] [varchar](35) not null,
	        [SectionCode] [varchar](25) null,
            [EstimateBalance] [money] null,
            [RecoveryEstimateBalance] [money] null
        )

        create clustered index idx_clmClaimEstimateBalance_BIRowID on [db-au-cba].dbo.clmClaimEstimateBalance(BIRowID)
        create nonclustered index idx_clmClaimEstimateBalance_Date on [db-au-cba].dbo.clmClaimEstimateBalance(Date,CountryKey) include(BenefitCategory,SectionCode,EstimateBalance,RecoveryEstimateBalance)

    end


    begin transaction

    begin try
    
        delete 
        from 
            [db-au-cba]..clmClaimEstimateBalance
        where
            [Date] = @MonthStart

        insert into [db-au-cba].dbo.clmClaimEstimateBalance with(tablock)
        (
	        CountryKey,
	        Date,
	        BenefitCategory,
	        SectionCode,
            EstimateBalance,
            RecoveryEstimateBalance
        )
        select 
            left(ClaimKey, 2) CountryKey,
            @MonthStart,
            BenefitCategory,
            SectionCode,
            sum(EstimateMovement) Estimate,
            sum(RecoveryEstimateMovement) RecoveryEstimate
        from
            [db-au-cba]..clmClaimEstimateMovement
        where
            EstimateDate < @MonthStart
        group by
            left(ClaimKey, 2),
            BenefitCategory,
            SectionCode


             
    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'clmClaimEstimateBalance data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = -1,
            @PackageID = 'clmClaimEstimateBalance'

    end catch

    if @@trancount > 0
        commit transaction

end

GO
