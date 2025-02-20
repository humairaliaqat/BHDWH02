USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL049_factClaimActivity]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_ETL049_factClaimActivity]
    @DateRange varchar(30),
    @StartDate date = null,
    @EndDate date = null

as
begin
--20150723, LS, put in stored procedure

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
    
    set @name = 'etlsp_ETL049_factClaimActivity'

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

    if object_id('[db-au-star].dbo.factClaimActivity') is null
    begin

        create table [db-au-star].dbo.factClaimActivity
        (
            [BIRowID] bigint not null identity(1,1),
            [ActivityID] varchar(50) not null,
            [Date_SK] int not null,
            [DomainSK] int not null,
            [OutletSK] int not null,
            [AreaSK] int not null,
            [ProductSK] int not null,
            [ClaimSK] bigint not null,
            [ClaimEventSK] bigint not null,
            [ClaimKey] varchar(40) null,
            [PolicyTransactionKey] varchar(41) null,
            [e5Reference] int null,
            [Activity] nvarchar(100) null,
            [CompletionDate] date null,
            [CompletionUser] nvarchar(100) null,
            [ActivityOutcome] nvarchar(400) null,
            [CreateBatchID] int
        )

        create clustered index idx_factClaimActivity_BIRowID on [db-au-star].dbo.factClaimActivity(BIRowID)
        create nonclustered index idx_factClaimActivity_ClaimKey on [db-au-star].dbo.factClaimActivity(ClaimKey)

    end

    /*what has changed during the period*/
    exec etlsp_ETL049_helper_UpdatedClaim
        @StartDate = @start,
        @EndDate = @end
        
    if object_id('etl_UpdatedClaim') is null
        create table etl_UpdatedClaim (ClaimKey varchar(40))


    if object_id('tempdb..#factClaimActivity') is not null
        drop table #factClaimActivity

    select
        wa.ID ActivityID,
        isnull(d.Date_SK, -1) Date_SK,
        isnull(dd.DomainSK, -1) DomainSK,
        isnull(o.OutletSK, -1) OutletSK,
        isnull(fpt.AreaSK, -1) AreaSK,
        isnull(fpt.ProductSK, -1) ProductSK,
        dcl.ClaimSK,
        isnull(dce.ClaimEventSK, -1) ClaimEventSK,
        cl.ClaimKey,
        cl.PolicyTransactionKey,
        w.Reference e5Reference,
        wa.CategoryActivityName Activity,
        wa.CompletionDate,
        wa.CompletionUser,
        wa.AssessmentOutcome ActivityOutcome
    into #factClaimActivity
    from
        [db-au-cba]..clmClaim cl
        inner join [db-au-cba]..e5Work w on
            w.ClaimKey = cl.ClaimKey
        inner join [db-au-cba]..e5WorkActivity wa on
            wa.Work_ID = w.Work_ID
        cross apply
        (
            select top 1 
                dcl.ClaimSK
            from
                [db-au-star]..dimClaim dcl
            where
                dcl.ClaimKey = cl.ClaimKey
        ) dcl
        outer apply
        (
            select top 1 
                Date_SK
            from
                [db-au-star]..dim_date d with(nolock)
            where
                d.[Date] = convert(date, wa.CompletionDate)
        ) d
        outer apply
        (
            select top 1 
                o.OutletSK,
                o.Country
            from
                [db-au-star]..dimOutlet o with(nolock)
            where
                o.OutletKey = cl.OutletKey and
                o.isLatest = 'Y'
        ) o
        outer apply
        (
            select top 1
                DomainSK
            from
                [db-au-star]..dimDomain dd
            where
                dd.CountryCode = cl.CountryKey
        ) dd
        outer apply
        (
            select top 1 
                ClaimEventSK
            from
                [db-au-cba]..clmEvent ce
                outer apply
                (
                    select top 1 
                        dce.ClaimEventSK
                    from
                        [db-au-star]..dimClaimEvent dce
                    where
                        dce.EventKey = ce.EventKey
                ) dce
            where
                ce.ClaimKey = cl.ClaimKey
        ) dce
        outer apply
        (
            select top 1 
                ProductSK,
                AreaSK
            from
                [db-au-star]..factPolicyTransaction fpt
            where
                fpt.PolicyTransactionKey = cl.PolicyTransactionKey
        ) fpt
    where
        cl.ClaimKey in
        (
            select
                ClaimKey
            from
                etl_UpdatedClaim
        ) and
        wa.CompletionDate is not null

    set @sourcecount = @@rowcount

    begin transaction

    begin try

        delete 
        from
            [db-au-star]..factClaimActivity
        where
            ClaimKey in
            (
                select
                    ClaimKey
                from
                    etl_UpdatedClaim
            )

        insert into [db-au-star]..factClaimActivity with(tablock)
        (
            [ActivityID],
            [Date_SK],
            [DomainSK],
            [OutletSK],
            [AreaSK],
            [ProductSK],
            [ClaimSK],
            [ClaimEventSK],
            [ClaimKey],
            [PolicyTransactionKey],
            [e5Reference],
            [Activity],
            [CompletionDate],
            [CompletionUser],
            [ActivityOutcome],
            [CreateBatchID]
        )
        select
            [ActivityID],
            [Date_SK],
            [DomainSK],
            [OutletSK],
            [AreaSK],
            [ProductSK],
            [ClaimSK],
            [ClaimEventSK],
            [ClaimKey],
            [PolicyTransactionKey],
            [e5Reference],
            [Activity],
            [CompletionDate],
            [CompletionUser],
            [ActivityOutcome],
            @batchid
        from
            #factClaimActivity

        set @insertcount = @@rowcount

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
            @SourceInfo = 'factClaimActivity data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end

GO
