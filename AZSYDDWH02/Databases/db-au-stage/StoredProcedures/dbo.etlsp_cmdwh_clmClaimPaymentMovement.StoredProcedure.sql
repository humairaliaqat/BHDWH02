USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmClaimPaymentMovement]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_clmClaimPaymentMovement]
    @DateRange varchar(30),
    @StartDate date = null,
    @EndDate date = null

as
begin

--20150722, LS, release to prod
--20151020, LS, left join to benefit
--20151021, LS, only use audit data if there's an I record
--20160219, LS, store time portion for payment date
--              don't enumerate cancelled payment statuses, use not in base payments instead
--              handle bad audit data with same audit timestamp but different status
--              handle bad pre-audit recoveries with no sections
--20160810, LL, flip benefit .. causing duplication bugs
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
        if object_id('etl_clmClaimPaymentMovement') is not null
            drop table etl_clmClaimPaymentMovement

        select
            ClaimKey
        into etl_clmClaimPaymentMovement
        from
            etl_clmClaim_sync

    end

    else
    begin

        /* prepare created/updated claims to roll up */
        if object_id('etl_clmClaimPaymentMovement') is not null
            drop table etl_clmClaimPaymentMovement

        select
            ClaimKey
        into etl_clmClaimPaymentMovement
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
    
    if object_id('[db-au-cba].dbo.clmClaimPaymentMovement') is null
    begin

        create table [db-au-cba].dbo.clmClaimPaymentMovement
        (
            [BIRowID] int not null identity(1,1),
	        [ClaimKey] [varchar](40) not null,
	        [SectionKey] [varchar](40) not null,
	        [PaymentKey] [varchar](40) not null,
	        [BenefitCategory] [varchar](35) not null,
	        [SectionCode] [varchar](25) null,
	        [FirstPayment] [bit] not null,
	        [FirstMonthPayment] [bit] not null,
	        [PaymentStatus] [varchar](4) null,
	        [PaymentDate] [date] null,
	        [PaymentDateTime] [datetime] null,
	        [PaymentDateUTC] [date] null,
	        [AllMovement] [money] null,
	        [PaymentMovement] [money] null,
	        [RecoveryPaymentMovement] [money] null,
            [BatchID] int null
        )

        create clustered index idx_clmClaimPaymentMovement_BIRowID on [db-au-cba].dbo.clmClaimPaymentMovement(BIRowID)
        create nonclustered index idx_clmClaimPaymentMovement_ClaimKey on [db-au-cba].dbo.clmClaimPaymentMovement(ClaimKey,PaymentDate) include(SectionKey,FirstPayment,FirstMonthPayment,BenefitCategory,PaymentStatus,PaymentMovement,RecoveryPaymentMovement,AllMovement,PaymentDateTime)
        create nonclustered index idx_clmClaimPaymentMovement_SectionKey on [db-au-cba].dbo.clmClaimPaymentMovement(SectionKey,PaymentDate) include(ClaimKey,FirstPayment,FirstMonthPayment,BenefitCategory,PaymentStatus,PaymentMovement,RecoveryPaymentMovement,AllMovement,PaymentDateTime)
        create nonclustered index idx_clmClaimPaymentMovement_ClaimKeyUTC on [db-au-cba].dbo.clmClaimPaymentMovement(ClaimKey,PaymentDateUTC) include(FirstPayment,FirstMonthPayment,BenefitCategory,PaymentStatus,PaymentMovement,RecoveryPaymentMovement,AllMovement,PaymentDateTime)
        create nonclustered index idx_clmClaimPaymentMovement_SectionKeyUTC on [db-au-cba].dbo.clmClaimPaymentMovement(SectionKey,PaymentDateUTC) include(FirstPayment,FirstMonthPayment,BenefitCategory,PaymentStatus,PaymentMovement,RecoveryPaymentMovement,AllMovement,PaymentDateTime)
        create nonclustered index idx_clmClaimPaymentMovement_PaymentDate on [db-au-cba].dbo.clmClaimPaymentMovement(PaymentDate,PaymentDateTime) include(ClaimKey,SectionKey,PaymentMovement,RecoveryPaymentMovement,AllMovement) 
        create nonclustered index idx_clmClaimPaymentMovement_PaymentDateUTC on [db-au-cba].dbo.clmClaimPaymentMovement(PaymentDateUTC) 

    end

    if object_id('tempdb..#paymentaudit') is not null
        drop table #paymentaudit
    
    /* crazy duplicates in audit data down to millisecond on 09/2014, there was big changes deployment in Claims.net at this period */
    select
        ClaimKey,
        SectionKey,
        PaymentKey,
        AuditAction,
        AuditDateTime,
        AuditDateTimeUTC,
        PaymentStatus,
        PaymentAmount,
        min(BIRowID) BIRowID
    into #paymentaudit
    from
        [db-au-cba]..clmAuditPayment
    where
        ClaimKey in
        (
            select 
                ClaimKey
            from
                etl_clmClaimPaymentMovement
        )
    group by
        ClaimKey,
        SectionKey,
        PaymentKey,
        AuditAction,
        AuditDateTime,
        AuditDateTimeUTC,
        PaymentStatus,
        PaymentAmount
        
    create nonclustered index idxs on #paymentaudit(SectionKey) include (PaymentKey,AuditAction,AuditDateTime,AuditDateTimeUTC,PaymentStatus,PaymentAmount)
    create nonclustered index idxc on #paymentaudit(ClaimKey) include (SectionKey,PaymentKey,AuditAction,AuditDateTime,AuditDateTimeUTC,PaymentStatus,PaymentAmount)
    create nonclustered index idxp on #paymentaudit(PaymentKey,AuditDateTime desc) include (PaymentStatus,PaymentAmount)
    
    begin transaction

    begin try
    
        delete 
        from 
            [db-au-cba]..clmClaimPaymentMovement
        where
            ClaimKey in
            (
                select 
                    ClaimKey
                from
                    etl_clmClaimPaymentMovement
            )

        insert into [db-au-cba].dbo.clmClaimPaymentMovement with(tablock)
        (
	        ClaimKey,
	        SectionKey,
	        PaymentKey,
	        BenefitCategory,
	        SectionCode,
	        FirstPayment,
	        FirstMonthPayment,
	        PaymentStatus,
	        PaymentDate,
            PaymentDateTime,
	        PaymentDateUTC,
            AllMovement,
	        PaymentMovement,
            RecoveryPaymentMovement,
            BatchID
        )
        select 
	        cl.ClaimKey,
	        fcp.SectionKey,
	        fcp.PaymentKey,
	        isnull(cbb.BenefitCategory, ''),
	        cs.SectionCode,
	        FirstPayment,
	        FirstMonthPayment,
	        PaymentStatus,
	        PaymentDate,
            PaymentDate PaymentDateTime,
	        PaymentDateUTC,
            AllMovement,
	        PaymentMovement,
            RecoveryPaymentMovement,
            @batchid
        from
            [db-au-cba]..clmClaim cl
            cross apply
            (
                select
                    cp.SectionKey,
                    cp.PaymentKey, 
                    case
                        when AuditDateTime = min(AuditDateTime) over (partition by cp.Sectionkey) then 1
                        else 0
                    end FirstPayment,
                    case
                        --not just first payment, but all payments in first payment's month
                        when convert(varchar(7), AuditDateTime, 120) = min(convert(varchar(7), AuditDateTime, 120)) over (partition by cp.Sectionkey) then 1
                        else 0
                    end FirstMonthPayment,
                    PaymentStatus,
                    AuditDateTime PaymentDate,
                    /* keeping the utc time as Actuaries use UTC */
                    AuditDateTimeUTC PaymentDateUTC,
                    case
                        when AuditAction = 'D' then -isnull(pcp.PreviousAmount, 0)
                        when PaymentStatus in ('APPR', 'PAID') and isnull(PreviousStatus, 'NULL') in ('NULL', 'APPR', 'PAID') then cp.PaymentAmount - isnull(pcp.PreviousAmount, 0)
                        when PaymentStatus in ('APPR', 'PAID') and isnull(PreviousStatus, 'NULL') not in ('NULL', 'APPR', 'PAID') then cp.PaymentAmount
                        when PaymentStatus = 'RECY' and isnull(PreviousStatus, 'NULL') in ('NULL', 'RECY') then cp.PaymentAmount - isnull(pcp.PreviousAmount, 0)
                        when PaymentStatus = 'RECY' and isnull(PreviousStatus, 'NULL') not in ('NULL', 'RECY') then cp.PaymentAmount
                        when PaymentStatus not in ('APPR', 'PAID', 'RECY') and PreviousStatus not in ('APPR', 'PAID', 'RECY') then -(cp.PaymentAmount - isnull(pcp.PreviousAmount, 0))
                        when PaymentStatus not in ('APPR', 'PAID', 'RECY') and PreviousStatus in ('APPR', 'PAID', 'RECY') then -cp.PaymentAmount
                        else 0
                    end AllMovement,
                    case
                        when AuditAction = 'D' and isnull(PreviousStatus, 'NULL') <> 'RECY' then -isnull(pcp.PreviousAmount, 0)
                        when PaymentStatus in ('APPR', 'PAID') and isnull(PreviousStatus, 'NULL') in ('NULL', 'APPR', 'PAID') then cp.PaymentAmount - isnull(pcp.PreviousAmount, 0)
                        when PaymentStatus in ('APPR', 'PAID') and isnull(PreviousStatus, 'NULL') not in ('NULL', 'APPR', 'PAID') then cp.PaymentAmount
                        when PaymentStatus not in ('APPR', 'PAID', 'RECY') and PreviousStatus not in ('APPR', 'PAID', 'RECY') then -(cp.PaymentAmount - isnull(pcp.PreviousAmount, 0))
                        when PaymentStatus not in ('APPR', 'PAID', 'RECY') and PreviousStatus in ('APPR', 'PAID') then -cp.PaymentAmount
                        else 0
                    end PaymentMovement,
                    case
                        when AuditAction = 'D' and isnull(PreviousStatus, 'NULL') = 'RECY' then -isnull(pcp.PreviousAmount, 0)
                        when PaymentStatus = 'RECY' and isnull(PreviousStatus, 'NULL') in ('NULL', 'RECY') then cp.PaymentAmount - isnull(pcp.PreviousAmount, 0)
                        when PaymentStatus = 'RECY' and isnull(PreviousStatus, 'NULL') not in ('NULL', 'RECY') then cp.PaymentAmount
                        when PaymentStatus not in ('APPR', 'PAID', 'RECY') and PreviousStatus in ('RECY') then -cp.PaymentAmount
                        else 0
                    end RecoveryPaymentMovement

                    /* using movement instead of first occurence of payment status as in RPT0390 */
                    /* new found out facts, this is due to existence of payment records with changed amount but not changed status, e.g. fx rate change */
                    /* code to check at the end of this proc */
                from
                    #paymentaudit cp
                    /* get previous state of payment */
                    outer apply
                    (
                        select top 1
                            PaymentStatus PreviousStatus,
                            PaymentAmount PreviousAmount
                        from
                            #paymentaudit pcp
                        where
                            pcp.PaymentKey = cp.PaymentKey and
                            pcp.AuditDateTime < cp.AuditDateTime
                        order by
                            pcp.AuditDateTime desc,
                            pcp.BIRowID desc
                    ) pcp
                where
                    cp.ClaimKey = cl.ClaimKey and
                    (
                        /* establish recognised base payment statuses, this is inline with actuarial */
                        cp.PaymentStatus in ('APPR', 'PAID', 'RECY') or
                        (
                            /* cancellation or failure is only valid if the previous status is recognised base payment */
                            isnull(cp.PaymentStatus, '') not in ('', 'APPR', 'PAID', 'RECY') and
                            pcp.PreviousStatus in ('APPR', 'PAID', 'RECY')
                        )
                    ) 
            ) fcp
            outer apply
            (
                select top 1
                    cas.SectionCode,
                    cas.BenefitSectionKey
                from
                    [db-au-cba]..clmAuditSection cas
                where
                    cas.SectionKey = fcp.SectionKey and
                    cas.AuditDateTime >= convert(date, fcp.PaymentDate)
                order by
                    cas.AuditDateTime
            ) cas
            outer apply
            (                
                select top 1
                    cs.SectionCode,
                    cs.BenefitSectionKey
                from
                    [db-au-cba]..clmSection cs
                where
                    cs.SectionKey = fcp.SectionKey
            ) css
            outer apply
            (
                select
                    isnull(cas.SectionCode, css.SectionCode) SectionCode,
                    isnull(cas.BenefitSectionKey, css.BenefitSectionKey) BenefitSectionKey
            ) cs
            left join [db-au-cba]..vclmBenefitCategory cbb on
                cbb.BenefitSectionKey = cs.BenefitSectionKey
        where
            cl.ClaimKey in
            (
                select 
                    ClaimKey
                from
                    etl_clmClaimPaymentMovement
            ) and
            /* only picks up movement */
            AllMovement <> 0 and
            /*must be created after audit system in place*/
            exists
            (
                select 
                    null
                from
                    [db-au-cba]..clmAuditPayment cap 
                where
                    cap.PaymentKey = fcp.PaymentKey and
                    cap.AuditAction = 'I'
            )

                        
        -- no audit data            
        insert into [db-au-cba].dbo.clmClaimPaymentMovement with(tablock)
        (
	        ClaimKey,
	        SectionKey,
	        PaymentKey,
	        BenefitCategory,
	        SectionCode,
	        FirstPayment,
	        FirstMonthPayment,
	        PaymentStatus,
	        PaymentDate,
            PaymentDateTime,
	        PaymentDateUTC,
            AllMovement,
	        PaymentMovement,
            RecoveryPaymentMovement,
            BatchID
        )
        select 
	        cl.ClaimKey,
	        cs.SectionKey,
	        cp.PaymentKey,
	        isnull(BenefitCategory, ''),
	        SectionCode,
            case
                when ModifiedDate = min(ModifiedDate) over (partition by cp.Sectionkey) then 1
                else 0
            end FirstPayment,
            case
                when convert(varchar(7), ModifiedDate, 120) = min(convert(varchar(7), ModifiedDate, 120)) over (partition by cp.Sectionkey) then 1
                else 0
            end FirstMonthPayment,
	        PaymentStatus,
	        coalesce(cp.ModifiedDate, cp.CreatedDate, cl.CreateDate) PaymentDate,
	        coalesce(cp.ModifiedDate, cp.CreatedDate, cl.CreateDate) PaymentDateTime,
	        coalesce(cp.ModifiedDateTimeUTC, cp.CreatedDate, cl.CreateDate) PaymentDateUTC,
            PaymentAmount AllMovement,
            case
                when PaymentStatus <> 'RECY' then PaymentAmount
                else 0
            end PaymentMovement,
            case
                when PaymentStatus = 'RECY' then PaymentAmount
                else 0
            end RecoveryPaymentMovement,
            @batchid
        from
            [db-au-cba]..clmClaim cl
            inner join [db-au-cba]..clmSection cs on
                cs.ClaimKey = cl.ClaimKey
            inner join [db-au-cba]..clmPayment cp on
                cp.SectionKey = cs.SectionKey
            left join [db-au-cba]..vclmBenefitCategory cbb on
                cbb.BenefitSectionKey = cs.BenefitSectionKey
        where
            cs.isDeleted = 0 and
            cp.isDeleted = 0 and
            cl.ClaimKey in
            (
                select 
                    ClaimKey
                from
                    etl_clmClaimPaymentMovement
            ) and
            not exists
            (
                select 
                    null
                from
                    [db-au-cba]..clmAuditPayment cap 
                where
                    cap.PaymentKey = cp.PaymentKey and
                    cap.AuditAction = 'I'
            ) and
            cp.PaymentStatus in ('APPR', 'PAID', 'RECY')
            
        -- no audit data            
        insert into [db-au-cba].dbo.clmClaimPaymentMovement with(tablock)
        (
	        ClaimKey,
	        SectionKey,
	        PaymentKey,
	        BenefitCategory,
	        SectionCode,
	        FirstPayment,
	        FirstMonthPayment,
	        PaymentStatus,
	        PaymentDate,
            PaymentDateTime,
	        PaymentDateUTC,
            AllMovement,
	        PaymentMovement,
            RecoveryPaymentMovement,
            BatchID
        )
        select 
	        cl.ClaimKey,
	        isnull(cp.SectionKey, ''),
	        cp.PaymentKey,
	        '',
	        '',
            case
                when ModifiedDate = min(ModifiedDate) over (partition by cp.Sectionkey) then 1
                else 0
            end FirstPayment,
            case
                when convert(varchar(7), ModifiedDate, 120) = min(convert(varchar(7), ModifiedDate, 120)) over (partition by cp.Sectionkey) then 1
                else 0
            end FirstMonthPayment,
	        PaymentStatus,
	        coalesce(cp.ModifiedDate, cp.CreatedDate, cl.CreateDate) PaymentDate,
	        coalesce(cp.ModifiedDate, cp.CreatedDate, cl.CreateDate) PaymentDateTime,
	        coalesce(cp.ModifiedDateTimeUTC, cp.CreatedDate, cl.CreateDate) PaymentDateUTC,
            PaymentAmount AllMovement,
            0 PaymentMovement,
            PaymentAmount RecoveryPaymentMovement,
            @batchid
        from
            [db-au-cba]..clmClaim cl
            inner join [db-au-cba]..clmPayment cp on
                cp.ClaimKey = cl.ClaimKey 
            left join [db-au-cba]..clmSection cs on
                cs.SectionKey = cp.SectionKey
        where
            cp.isDeleted = 0 and
            cl.ClaimKey in
            (
                select 
                    ClaimKey
                from
                    etl_clmClaimPaymentMovement
            ) and
            not exists
            (
                select 
                    null
                from
                    [db-au-cba]..clmAuditPayment cap 
                where
                    cap.PaymentKey = cp.PaymentKey and
                    cap.AuditAction = 'I'
            ) and
            cp.PaymentStatus in ('APPR', 'PAID', 'RECY') and
            cs.SectionKey is null

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'clmClaimPaymentMovement data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = -1,
            @PackageID = 'clmClaimPaymentMovement'

    end catch

    if @@trancount > 0
        commit transaction

end

GO
