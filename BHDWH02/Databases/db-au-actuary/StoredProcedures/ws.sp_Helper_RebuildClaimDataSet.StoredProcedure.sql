USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [ws].[sp_Helper_RebuildClaimDataSet]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [ws].[sp_Helper_RebuildClaimDataSet]
as
begin

    --truncate table ws.ClaimIncurredMovement

    declare 
        @start date,
        @end date,
        @err varchar(max)

    select 
        @start = convert(date, convert(varchar(8), min(CreateDate), 120) + '01')
    from
        [db-au-cmdwh]..clmClaim

    print @start

    while @start < convert(date, convert(varchar(8), getdate(), 120) + '01')
    begin

        set @end = dateadd(month, 12, @start)

        exec ws.sp_Helper_UpdatedClaim
            @BatchMode = 1,
            @StartDate = @start,
            @EndDate = @end

        exec dbo.spClaimEstimate

        exec dbo.spClaimPayment

        exec dbo.spClaimIncurred

        set @err = convert(varchar(10), @start, 120) + char(9) + convert(varchar, getdate(), 120)
        raiserror(@err, 1, 1) with nowait

        set @start = dateadd(month, 12, @start)

    end

end

GO
