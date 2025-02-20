USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [dbo].[spClaimPayment]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spClaimPayment]
as
begin

    if object_id('tempdb..#payments') is not null
        drop table #payments

    if object_id('tempdb..#paymentmovement') is not null
        drop table #paymentmovement

    select 
        cap.ClaimKey,
        cap.SectionKey,
        isnull(cas.SectionCode, cs.SectionCode) SectionCode,
        cap.PaymentKey,
        cap.BIRowID,
        cap.AuditKey,
        cap.AuditAction,
        cap.AuditDateTime,
        cap.PaymentStatus,
        isnull(cap.PaymentAmount, 0) PaymentAmount,
        isnull(cap.GST, 0) + isnull(cap.DAMOutcome, 0) ITCDAM,
        isnull(cap.PaymentAmount, 0) - isnull(cap.GST, 0) - isnull(cap.DAMOutcome, 0) NetPayment,
        --isnull(cap.ITCOutcome, 0) + isnull(cap.DAMOutcome, 0) ITCDAM,
        --isnull(cap.PaymentAmount, 0) - isnull(cap.ITCOutcome, 0) - isnull(cap.DAMOutcome, 0) NetPayment,
        cap.CurrencyCode Currency,
        cap.Rate FXRate
    into #payments
    from
        [db-au-cba]..clmAuditPayment cap with(nolock)
        outer apply
        (
            select top 1
                cas.SectionCode
            from
                [db-au-cba]..clmAuditSection cas with(nolock)
            where
                cas.SectionKey = cap.SectionKey and
                cas.AuditDateTime < cap.AuditDateTime
            order by
                cas.AuditDateTime desc
        ) cas
        outer apply
        (
            select top 1
                cs.SectionCode
            from
                [db-au-cba]..clmSection cs with(nolock)
            where
                cs.SectionKey = cap.SectionKey
        ) cs
    where
        cap.ClaimKey in 
        (
            select 
                ClaimKey
            from
                ws.UpdatedClaim
        ) and
        CountryKey <> '' and
        exists
        (
            select
                null
            from
                [db-au-cba]..clmAuditPayment r with(nolock)
            where
                r.PaymentKey = cap.PaymentKey and
                r.AuditAction = 'I'
        )

    --ITCDAM fixes
    union all

    select --top 100
        cl.ClaimKey,
	    isnull(cp.SectionKey, '') SectionKey,
	    isnull(cs.SectionCode, '') SectionCode,
        cp.PaymentKey,
        9999999999 BIRowID,
        '' AuditKey,
        'U' AuditAction,
        --cap ITC fixes at the end of July 2017
        --somehow audit entries are still created for these old payments
        case
            when convert(datetime, convert(varchar(10), isnull(cap.LastAuditTime, cp.ModifiedDate), 120) + ' 23:59:59') >= '2017-08-01' then '2017-07-31 23:59:59'
            else convert(datetime, convert(varchar(10), isnull(cap.LastAuditTime, cp.ModifiedDate), 120) + ' 23:59:59')
        end AuditDateTime,
        cp.PaymentStatus,
        isnull(cp.PaymentAmount, 0) PaymentAmount,
        isnull(f.ITC_DAM, 0) ITCDAM,
        isnull(cp.PaymentAmount, 0) - isnull(f.ITC_DAM, 0) NetPayment,
        cp.CurrencyCode Currency,
        cp.Rate FXRate
    from
        [db-au-cba]..clmClaim cl with(nolock)
        inner join [db-au-cba]..clmPayment cp with(nolock) on
            cp.ClaimKey = cl.ClaimKey 
        outer apply
        (
            select 
                max(cap.AuditDateTime) LastAuditTime
            from
                [db-au-cba]..clmAuditPayment cap with(nolock)
            where
                cap.PaymentKey = cp.PaymentKey
        ) cap
        cross apply
        (
            select top 1
                f.ITC_DAM
            from
                [db-au-actuary].ws.itcdamfixes f
            where
                f.PaymentKey = cp.PaymentKey
        ) f
        left join [db-au-cba]..clmSection cs with(nolock) on
            cs.SectionKey = cp.SectionKey
    where
        cl.ClaimKey in 
        (
            select 
                ClaimKey
            from
                ws.UpdatedClaim
        ) and
        isnull(cs.isDeleted, 0) = 0 and
        cp.isDeleted = 0 and
        cp.PaymentStatus in ('PAID')

    create nonclustered index idx on #payments (PaymentKey,AuditDateTime desc,BIRowID desc) include (PaymentStatus,PaymentAmount,ITCDAM,NetPayment,AuditAction)

    ;with
    cte_movement as
    (
        select 
            t.ClaimKey,
            t.SectionKey,
            t.SectionCode,
            t.PaymentKey,
            t.AuditKey,
            t.AuditAction,
            t.AuditDateTime,
            t.Currency,
            t.FXRate,
            t.PaymentStatus,
            t.PaymentAmount,
            t.ITCDAM,
            t.NetPayment,
            isnull(r.PreviousStatus, '') PreviousStatus,
            isnull(r.PreviousAmount, 0) PreviousAmount,
            isnull(r.PreviousITCDAM, 0) PreviousITCDAM,
            isnull(r.PreviousNetPayment, 0) PreviousNetPayment
        from
            #payments t
            outer apply
            (
                select top 1 
                    r.PaymentStatus PreviousStatus,
                    r.PaymentAmount PreviousAmount,
                    r.ITCDAM PreviousITCDAM,
                    r.NetPayment PreviousNetPayment,
                    r.AuditAction PreviousAction
                from
                    #payments r
                where
                    r.PaymentKey = t.PaymentKey and
                    /*handle duplicate audit records*/
                    r.AuditDateTime <= t.AuditDateTime and
                    (
                        r.AuditDateTime < t.AuditDateTime or
                        r.BIRowID < t.BIRowID
                    )
                order by
                    r.AuditDateTime desc,
                    r.BIRowID desc
            ) r
        where
            --ignore double delete audit records
            not
            (
                AuditAction = 'D' and
                PreviousAction = 'D'
            )
    )
    --select *
    --from
    --    cte_movement
    --where
    --    claimkey = 'AU-558909'
    --order by
    --    PaymentKey,
    --    AuditDateTime
    ,
    cte_correctedmovement
    as
    (
        select 
            ClaimKey,
            SectionKey,
            SectionCode,
            PaymentKey,
            AuditKey,
            AuditDateTime PaymentDate,
            Currency,
            FXRate,
            PaymentStatus,
            PaymentAmount,
            ITCDAM,
            NetPayment,
            case
                when PaymentStatus in ('PAID', 'RECY') and AuditAction = 'D' then -PreviousAmount
                when PaymentStatus not in ('PAID', 'RECY') then -PreviousAmount
                when PaymentStatus = PreviousStatus then PaymentAmount - PreviousAmount
                else PaymentAmount
            end PaymentMovement,
            case
                when PaymentStatus in ('PAID', 'RECY') and AuditAction = 'D' then -PreviousITCDAM
                when PaymentStatus not in ('PAID', 'RECY') then -PreviousITCDAM
                when PaymentStatus = PreviousStatus then ITCDAM - PreviousITCDAM
                else ITCDAM
            end ITCDAMMovement,
            case
                when PaymentStatus in ('PAID', 'RECY') and AuditAction = 'D' then -PreviousNetPayment
                when PaymentStatus not in ('PAID', 'RECY') then -PreviousNetPayment
                when PaymentStatus = PreviousStatus then NetPayment - PreviousNetPayment
                else NetPayment
            end NetPaymentMovement,
            case
                when PaymentStatus = 'RECY' then 1
                when PreviousStatus = 'RECY' then 1
                when PreviousStatus = 'PAID' and PaymentStatus <> 'PAID' then 2
                else 0
            end asRecovery,
            0 asEstimate
        from
            cte_movement
        where
            (
                PaymentStatus in ('PAID', 'RECY') or
                PreviousStatus in ('PAID', 'RECY')
            )

        union all

        select 
            ClaimKey,
            SectionKey,
            SectionCode,
            PaymentKey,
            AuditKey,
            AuditDateTime PaymentDate,
            Currency,
            FXRate,
            PaymentStatus,
            PaymentAmount,
            ITCDAM,
            NetPayment,
            case
                when PaymentStatus in ('APHA', 'APPR', 'PAPP') and AuditAction = 'D' then -PreviousAmount
                when PaymentStatus not in ('APHA', 'APPR', 'PAPP') then -PreviousAmount
                when PaymentStatus in ('APHA', 'APPR', 'PAPP') and PreviousStatus in ('APHA', 'APPR', 'PAPP') then PaymentAmount - PreviousAmount
                else PaymentAmount
            end PaymentMovement,
            case
                when PaymentStatus in ('APHA', 'APPR', 'PAPP') and AuditAction = 'D' then -PreviousITCDAM
                when PaymentStatus not in ('APHA', 'APPR', 'PAPP') then -PreviousITCDAM
                when PaymentStatus in ('APHA', 'APPR', 'PAPP') and PreviousStatus in ('APHA', 'APPR', 'PAPP') then ITCDAM - PreviousITCDAM
                else ITCDAM
            end ITCDAMMovement,
            case
                when PaymentStatus in ('APHA', 'APPR', 'PAPP') and AuditAction = 'D' then -PreviousNetPayment
                when PaymentStatus not in ('APHA', 'APPR', 'PAPP') then -PreviousNetPayment
                when PaymentStatus in ('APHA', 'APPR', 'PAPP') and PreviousStatus in ('APHA', 'APPR', 'PAPP') then NetPayment - PreviousNetPayment
                else NetPayment
            end NetPaymentMovement,
            0 asRecovery,
            1 asEstimate
        from
            cte_movement
        where
            (
                PaymentStatus in ('APHA', 'APPR', 'PAPP') or
                PreviousStatus in ('APHA', 'APPR', 'PAPP')
            )

        union all

        select 
            cl.ClaimKey,
	        isnull(cp.SectionKey, '') SectionKey,
	        isnull(cs.SectionCode, '') SectionCode,
            cp.PaymentKey,
            '' AuditKey,
            coalesce(cp.ModifiedDate, cp.CreatedDate, cl.createdate) PaymentDate,
            cp.CurrencyCode,
            cp.Rate,
            cp.PaymentStatus,
            isnull(cp.PaymentAmount, 0) PaymentAmount,
            isnull(cp.GST, 0) + isnull(cp.DAMOutcome, 0) ITCDAM,
            isnull(cp.PaymentAmount, 0) - (isnull(cp.GST, 0) + isnull(cp.DAMOutcome, 0)) NetPayment,
            --isnull(cp.ITCOutcome, 0) + isnull(cp.DAMOutcome, 0) ITCDAM,
            --isnull(cp.PaymentAmount, 0) - isnull(cp.ITCOutcome, 0) - isnull(cp.DAMOutcome, 0) NetPayment,
            isnull(cp.PaymentAmount, 0) PaymentMovement,
            isnull(cp.GST, 0) + isnull(cp.DAMOutcome, 0) ITCDAMMovement,
            isnull(cp.PaymentAmount, 0) - (isnull(cp.GST, 0) + isnull(cp.DAMOutcome, 0)) NetPaymentMovement,
            --isnull(cp.ITCOutcome, 0) + isnull(cp.DAMOutcome, 0) ITCDAMMovement,
            --isnull(cp.PaymentAmount, 0) - (isnull(cp.ITCOutcome, 0) + isnull(cp.DAMOutcome, 0)) NetPaymentMovement,
            case
                when cp.PaymentStatus = 'RECY' then 1
                else 0
            end asRecovery,
            0 asEstimate
        from
            [db-au-cba]..clmClaim cl with(nolock)
            inner join [db-au-cba]..clmPayment cp with(nolock) on
                cp.ClaimKey = cl.ClaimKey 
            left join [db-au-cba]..clmSection cs with(nolock) on
                cs.SectionKey = cp.SectionKey
        where
            cl.ClaimKey in 
            (
                select 
                    ClaimKey
                from
                    ws.UpdatedClaim
            ) and
            isnull(cs.isDeleted, 0) = 0 and
            cp.isDeleted = 0 and
            not exists
            (
                select 
                    null
                from
                    [db-au-cba]..clmAuditPayment cap with(nolock)
                where
                    cap.PaymentKey = cp.PaymentKey and
                    cap.AuditAction = 'I'
            ) and
            cp.PaymentStatus in ('PAID', 'RECY') and
            not exists --don't double count payments without audit but has itc fix
            (
                select
                    null
                from
                    [db-au-actuary].ws.itcdamfixes f
                where
                    f.PaymentKey = cp.PaymentKey
            )
    )
    select --top 1000 
        *
    into #paymentmovement
    from
        cte_correctedmovement
    where
        (
            PaymentMovement <> 0 or
            ITCDAMMovement <> 0
        ) 
    
    --    and
    --    claimkey = 'AU-558909'


    --order by
    --    2,
    --    4,
    --    6


    if object_id('[db-au-actuary].ws.ClaimPaymentMovement') is null
    begin

        create table [db-au-actuary].ws.ClaimPaymentMovement
        (
            [BIRowID] bigint not null identity(1,1),
	        [ClaimKey] [varchar](40) not null,
	        [SectionKey] [varchar](40) null,
	        [SectionCode] [varchar](25) null,
	        [PaymentKey] [varchar](40) null,
	        [AuditKey] [varchar](50) not null,
	        [PaymentDate] [datetime] null,
	        [Currency] [varchar](3) null,
	        [FXRate] decimal(25,10) null,
	        [PaymentStatus] [varchar](4) null,
	        [PaymentAmount] decimal(20,6) not null,
	        [ITCDAM] decimal(20,6) null,
	        [NetPayment] decimal(20,6) null,
	        [PaymentMovement] decimal(20,6) null,
	        [ITCDAMMovement] decimal(20,6) null,
	        [NetPaymentMovement] decimal(20,6) null,
	        [asRecovery] [int] not null,
	        [asEstimate] [int] not null,
            constraint PK_ClaimPaymentMovement primary key clustered (BIRowID)
        )

        create unique clustered index cidx on [db-au-actuary].ws.ClaimPaymentMovement (BIRowID)
        create index idx on [db-au-actuary].ws.ClaimPaymentMovement (ClaimKey)
            
    end
    else
        delete
        from
            [db-au-actuary].ws.ClaimPaymentMovement
        where
            ClaimKey in 
            (
                select 
                    ClaimKey
                from
                    ws.UpdatedClaim
            )

    insert into [db-au-actuary].ws.ClaimPaymentMovement
    (
	    [ClaimKey],
	    [SectionKey],
	    [SectionCode],
	    [PaymentKey],
	    [AuditKey],
	    [PaymentDate],
	    [Currency],
	    [FXRate],
	    [PaymentStatus],
	    [PaymentAmount],
	    [ITCDAM],
	    [NetPayment],
	    [PaymentMovement],
	    [ITCDAMMovement],
	    [NetPaymentMovement],
	    [asRecovery],
	    [asEstimate]
    )
    select
	    [ClaimKey],
	    [SectionKey],
	    [SectionCode],
	    [PaymentKey],
	    [AuditKey],
	    [PaymentDate],
	    [Currency],
	    [FXRate],
	    [PaymentStatus],
	    [PaymentAmount],
	    [ITCDAM],
	    [NetPayment],
	    [PaymentMovement],
	    [ITCDAMMovement],
	    [NetPaymentMovement],
	    [asRecovery],
	    [asEstimate]
    from
        #paymentmovement

end

GO
