USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL049_helper_UpdatedClaim]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE procedure [dbo].[etlsp_ETL049_helper_UpdatedClaim]
    @StartDate date,
    @EndDate date

as
begin

    if object_id('etl_UpdatedClaim') is not null
        drop table etl_UpdatedClaim

    select
        ClaimKey
    into etl_UpdatedClaim
    from
        [db-au-cba].dbo.clmClaim
    where
        (
            CreateDate >= @StartDate and
            CreateDate <  dateadd(day, 1, @EndDate)
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
    union

    select 
        w.ClaimKey
    from
        [db-au-cba].dbo.e5WorkEvent we
        inner join [db-au-cba].dbo.e5Work w on
            w.Work_ID = we.Work_ID
    where
        we.EventDate >= @StartDate and
        we.EventDate <  dateadd(day, 1, @EndDate)
end
GO
