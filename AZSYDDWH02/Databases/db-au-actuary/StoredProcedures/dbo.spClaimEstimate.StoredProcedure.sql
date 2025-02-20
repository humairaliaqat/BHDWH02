USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [dbo].[spClaimEstimate]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spClaimEstimate]
as
begin
--20180530, LL, change [always create a record for initial section creation of online claims]
--              into [always create a record for initial section creation of claims with no non-zero estimate]


    /* combine deleted estimates & estimate history */
    if object_id('tempdb..#estimates') is not null
        drop table #estimates

    select
        ClaimKey,
        SectionKey,
        SectionCode,
        dateadd(ms, convert(int, right(BIRowID, 2)), convert(datetime, convert(varchar(10), AuditDateTime, 120) + ' 23:59:59.800')) EstimateDate, --make section deletion to be the last thing to ever happen
        AuditAction,
        case
            when CountryKey = 'AU' then 'AUD'
            when CountryKey = 'NZ' then 'NZD'
            when CountryKey = 'UK' then 'GBP'
            when CountryKey = 'SG' then 'SGD'
            when CountryKey = 'MY' then 'MYR'
            when CountryKey = 'ID' then 'IDR'
            when CountryKey = 'CN' then 'CNY'
            when CountryKey = 'IN' then 'INR'
            when CountryKey = 'US' then 'USD'
            else 'AUD'
        end Currency,
        1.0000 FXRate,
        cast(EstimateValue as decimal(20,6)) EstimateValue,
        cast(isnull(RecoveryEstimateValue, 0) as decimal(20,6)) RecoveryEstimateValue
    into #estimates
    from
        [db-au-cba]..clmAuditSection with(nolock)
    where
        ClaimKey in 
        (
            select 
                ClaimKey
            from
                ws.UpdatedClaim
        ) and
        CountryKey <> '' and
        AuditAction = 'D'

    union

    select 
        eh.ClaimKey,
        eh.SectionKey,
        isnull(cs.SectionCode, cas.SectionCode) SectionCode,
        ehc.EHCreateDate,
        '' AuditAction,
        case
            when cl.CountryKey = 'AU' then 'AUD'
            when cl.CountryKey = 'NZ' then 'NZD'
            when cl.CountryKey = 'UK' then 'GBP'
            when cl.CountryKey = 'SG' then 'SGD'
            when cl.CountryKey = 'MY' then 'MYR'
            when cl.CountryKey = 'ID' then 'IDR'
            when cl.CountryKey = 'CN' then 'CNY'
            when cl.CountryKey = 'IN' then 'INR'
            when cl.CountryKey = 'US' then 'USD'
            else 'AUD'
        end Currency,
        1.0000 FXRate,
        EHEstimateValue EstimateValue,
        isnull(EHRecoveryEstimateValue, 0) RecoveryEstimateValue
    from
        [db-au-cba]..clmEstimateHistory eh with(nolock)
        inner join [db-au-cba]..clmClaim cl with(nolock) on
            cl.ClaimKey = eh.ClaimKey
        --bad UK estimate histories, multiple histories on same date (no time values)
        cross apply
        (
            select
                case
                    when EHCreateDate = convert(date, EHCreateDate) then dateadd(ms, convert(int, right(convert(varchar, eh.EstimateHistoryID), 2)) * 10, EHCreateDate)
                    else EHCreateDate
                end EHCreateDate
        ) ehc
        left join [db-au-cba]..clmSection cs with(nolock) on
            cs.SectionKey = eh.SectionKey
        outer apply
        (
            select top 1 
                cas.SectionCode
            from
                [db-au-cba]..clmAuditSection cas with(nolock)
            where
                cas.SectionKey = eh.SectionKey and
                cas.AuditDateTime < eh.EHCreateDate
            order by
                cas.AuditDateTime desc
        ) cas
    where
        cl.ClaimKey in 
        (
            select 
                ClaimKey
            from
                ws.UpdatedClaim
        ) and
        cl.CountryKey <> '' and
        (
            cl.CountryKey <> 'NZ' or
            cl.ClaimNo >= 800000
        )

    union

    select 
        eh.ClaimKey,
        eh.SectionKey,
        isnull(cs.SectionCode, cas.SectionCode) SectionCode,
        ehc.EHCreateDate,
        '' AuditAction,
        case
            when cl.CountryKey = 'AU' then 'AUD'
            when cl.CountryKey = 'NZ' then 'NZD'
            when cl.CountryKey = 'UK' then 'GBP'
            when cl.CountryKey = 'SG' then 'SGD'
            when cl.CountryKey = 'MY' then 'MYR'
            when cl.CountryKey = 'ID' then 'IDR'
            when cl.CountryKey = 'CN' then 'CNY'
            when cl.CountryKey = 'IN' then 'INR'
            when cl.CountryKey = 'US' then 'USD'
            else 'AUD'
        end Currency,
        1.0000 FXRate,
        EHEstimateValue EstimateValue,
        isnull(EHRecoveryEstimateValue, 0) RecoveryEstimateValue
    from
        [db-au-cba]..clmEstimateHistory eh with(nolock)
        inner join [db-au-cba]..clmClaim cl with(nolock) on
            cl.ClaimKey = eh.ClaimKey
        --bad old NZ estimate histories, ordered by id instead of date
        cross apply
        (
            select
                dateadd(ms, eh.EstimateHistoryID * 100, convert(datetime, convert(date, EHCreateDate))) EHCreateDate
        ) ehc
        left join [db-au-cba]..clmSection cs with(nolock) on
            cs.SectionKey = eh.SectionKey
        outer apply
        (
            select top 1 
                cas.SectionCode
            from
                [db-au-cba]..clmAuditSection cas with(nolock)
            where
                cas.SectionKey = eh.SectionKey and
                cas.AuditDateTime < eh.EHCreateDate
            order by
                cas.AuditDateTime desc
        ) cas
    where
        cl.ClaimKey in 
        (
            select 
                ClaimKey
            from
                ws.UpdatedClaim
        ) and
        eh.CountryKey = 'NZ' and
        cl.ClaimNo < 800000

    union

    select
        cs.ClaimKey,
        cs.SectionKey,
        cs.SectionCode,
        convert(varchar(10), LastEstimateDate, 120) + ' 23:59:59.900' EstimateDate, --make section deletion to be the last thing to ever happen
        'D' AuditAction,
        case
            when cs.CountryKey = 'AU' then 'AUD'
            when cs.CountryKey = 'NZ' then 'NZD'
            when cs.CountryKey = 'UK' then 'GBP'
            when cs.CountryKey = 'SG' then 'SGD'
            when cs.CountryKey = 'MY' then 'MYR'
            when cs.CountryKey = 'ID' then 'IDR'
            when cs.CountryKey = 'CN' then 'CNY'
            when cs.CountryKey = 'IN' then 'INR'
            when cs.CountryKey = 'US' then 'USD'
            else 'AUD'
        end Currency,
        1.0000 FXRate,
        isnull(LastEstimateValue, 0) EstimateValue,
        isnull(LastRecoveryValue, 0) RecoveryEstimateValue
    from
        [db-au-cba]..clmSection cs with(nolock)
        cross apply
        (
            select top 1
                leh.EHCreateDate LastEstimateDate,
                leh.EHCreateDateTimeUTC LastEstimateDateUTC,
                leh.EHEstimateValue LastEstimateValue,
                leh.EHRecoveryEstimateValue LastRecoveryValue
            from
                [db-au-cba]..clmEstimateHistory leh with(nolock)
            where
                leh.SectionKey = cs.SectionKey
            order by
                leh.EHCreateDate desc
        ) leh
    where
        cs.ClaimKey in 
        (
            select 
                ClaimKey
            from
                ws.UpdatedClaim
        ) and
        cs.CountryKey <> '' and
        isDeleted = 1 and
        not exists
        (
            select 
                null
            from
                [db-au-cba]..clmAuditSection cas with(nolock)
            where
                cas.SectionKey = cs.SectionKey and
                cas.AuditAction = 'D'
        )

    union

    --always create a record for initial section creation of online claims
    select
        cs.ClaimKey,
        cs.SectionKey,
        cs.SectionCode,
        EntryDate EstimateDate,
        'I' AuditAction,
        case
            when cs.CountryKey = 'AU' then 'AUD'
            when cs.CountryKey = 'NZ' then 'NZD'
            when cs.CountryKey = 'UK' then 'GBP'
            when cs.CountryKey = 'SG' then 'SGD'
            when cs.CountryKey = 'MY' then 'MYR'
            when cs.CountryKey = 'ID' then 'IDR'
            when cs.CountryKey = 'CN' then 'CNY'
            when cs.CountryKey = 'IN' then 'INR'
            when cs.CountryKey = 'US' then 'USD'
            else 'AUD'
        end Currency,
        1.0000 FXRate,
        cast(0.000001 as decimal(20,6)) EstimateValue,
        cast(0.000001 as decimal(20,6)) RecoveryEstimateValue
    from
        [db-au-cba]..clmSection cs with(nolock)
        inner join [db-au-cba]..clmClaim cl with(nolock) on
            cl.ClaimKey = cs.ClaimKey 
        cross apply
        (
            select 
                min(AuditDateTime) EntryDate
            from
                [db-au-cba]..clmAuditSection cas with(nolock)
            where
                cas.SectionKey = cs.SectionKey and
                cas.AuditAction = 'I'
        ) csa
    where
        cl.ClaimKey in 
        (
            select 
                ClaimKey
            from
                ws.UpdatedClaim
        ) and
        cs.CountryKey <> '' and
        csa.EntryDate is not null and
        (
            --20180530, LL, existing logic
            (
                cl.OnlineClaim = 1 and
                not exists
                (
                    select
                        null
                    from
                        [db-au-cba]..clmEstimateHistory ceh
                    where
                        ceh.SectionKey = cs.SectionKey and
                        ceh.EHCreateDate <= csa.EntryDate
                )
            ) or

            --20180530, LL, expand to cover claims that were created and directly denied (no estimate movement, no values)
            (
                isnull(cl.OnlineClaim, 0) <> 1 and
                not exists
                (
                    select
                        null
                    from
                        [db-au-cba]..clmEstimateHistory ceh
                    where
                        ceh.SectionKey = cs.SectionKey and
                        ceh.EHEstimateValue <> 0 and
                        ceh.EHCreateDate < dateadd(day, 1, convert(date, csa.EntryDate))
                )
            )
        )

    union

    select
        cs.ClaimKey,
        cs.SectionKey,
        cs.SectionCode,
        cl.CreateDate EstimateDate,
        'I' AuditAction,
        case
            when cs.CountryKey = 'AU' then 'AUD'
            when cs.CountryKey = 'NZ' then 'NZD'
            when cs.CountryKey = 'UK' then 'GBP'
            when cs.CountryKey = 'SG' then 'SGD'
            when cs.CountryKey = 'MY' then 'MYR'
            when cs.CountryKey = 'ID' then 'IDR'
            when cs.CountryKey = 'CN' then 'CNY'
            when cs.CountryKey = 'IN' then 'INR'
            when cs.CountryKey = 'US' then 'USD'
            else 'AUD'
        end Currency,
        1.0000 FXRate,
        cast(0.000001 as decimal(20,6)) EstimateValue,
        cast(0.000001 as decimal(20,6)) RecoveryEstimateValue
    from
        [db-au-cba]..clmSection cs with(nolock)
        inner join [db-au-cba]..clmClaim cl with(nolock) on
            cl.ClaimKey = cs.ClaimKey 
    where
        cl.ClaimKey in 
        (
            select 
                ClaimKey
            from
                ws.UpdatedClaim
        ) and
        cs.CountryKey <> '' and
        cl.OnlineClaim = 1 and
        not exists
        (
            select 
                null
            from
                [db-au-cba]..clmAuditSection cas with(nolock)
            where
                cas.SectionKey = cs.SectionKey and
                cas.AuditAction = 'I'
        ) and
        not exists
        (
            select
                null
            from
                [db-au-cba]..clmEstimateHistory ceh
            where
                ceh.SectionKey = cs.SectionKey and
                ceh.EHCreateDate <= cl.CreateDate
        )

    union

    --zero the estimate on online claim e5 completion or rejection
    select 
        cs.ClaimKey,
        cs.SectionKey,
        cs.SectionCode,
        isnull(we.FirstComplete, wer.FirstReject) EstimateDate,
        'U' AuditAction,
        case
            when cs.CountryKey = 'AU' then 'AUD'
            when cs.CountryKey = 'NZ' then 'NZD'
            when cs.CountryKey = 'UK' then 'GBP'
            when cs.CountryKey = 'SG' then 'SGD'
            when cs.CountryKey = 'MY' then 'MYR'
            when cs.CountryKey = 'ID' then 'IDR'
            when cs.CountryKey = 'CN' then 'CNY'
            when cs.CountryKey = 'IN' then 'INR'
            when cs.CountryKey = 'US' then 'USD'
            else 'AUD'
        end Currency,
        1.0000 FXRate,
        0 EstimateValue,
        0 RecoveryEstimateValue
    from
        [db-au-cba]..clmSection cs with(nolock)
        inner join [db-au-cba]..clmClaim cl with(nolock) on
            cl.ClaimKey = cs.ClaimKey
        outer apply
        (
            select top 1
                we.EventDate FirstComplete
            from
                [db-au-cba]..e5Work w with(nolock)
                inner join [db-au-cba]..e5WorkEvent we with(nolock) on
                    we.Work_ID = w.Work_ID
            where
                w.ClaimKey = cl.ClaimKey and
                w.WorkType like '%claim%' and
                w.WorkType not like '%audit%' and
                we.StatusName in ('Complete', 'Rejected')
            order by
                we.EventDate
        ) we
        outer apply
        (
            select top 1
                we.EventDate FirstReject
            from
                [db-au-cba]..e5Work w with(nolock)
                inner join [db-au-cba]..e5WorkEvent we with(nolock) on
                    we.Work_ID = w.Work_ID
            where
                w.ClaimKey = cl.ClaimKey and
                w.WorkType = 'Correspondence' and
                we.StatusName = 'Rejected' and
                not exists
                (
                    select
                        null
                    from
                        [db-au-cba]..e5Work r with(nolock)
                    where
                        r.ClaimKey = cl.ClaimKey and
                        r.WorkType like '%claim%' and
                        r.WorkType not like '%audit%'
                )
            order by
                we.EventDate
        ) wer
    where
        cl.ClaimKey in 
        (
            select 
                ClaimKey
            from
                ws.UpdatedClaim
        ) and
        cs.CountryKey <> '' and
        cl.OnlineClaim = 1 and
        not exists
        (
            select
                null
            from
                [db-au-cba]..clmEstimateHistory ceh
            where
                ceh.ClaimKey = cl.ClaimKey and
                ceh.SectionKey = cs.SectionKey and
                --ceh.EHCreateDate >= convert(date, we.FirstComplete) and
                --ceh.EHCreateDate <  dateadd(day, 1, convert(date, we.FirstComplete)) and

				--incomplete logic
				--but only fixing it after July 2017 for data consistency
				(
					(
						isnull(we.FirstComplete, wer.FirstReject) >= '2017-07-01' and
						ceh.EHCreateDate >= convert(date, isnull(we.FirstComplete, wer.FirstReject)) and
						ceh.EHCreateDate <  dateadd(day, 1, convert(date, isnull(we.FirstComplete, wer.FirstReject))) 
					) or
					(
						ceh.EHCreateDate >= convert(date, we.FirstComplete) and
						ceh.EHCreateDate <  dateadd(day, 1, convert(date, we.FirstComplete))
					)
				)				
				and

                ceh.EHEstimateValue = 0
        ) and
        not exists
        (
            select
                null
            from
                [db-au-cba]..clmEstimateHistory ceh
            where
                ceh.SectionKey = cs.SectionKey and

                --ceh.EHCreateDate < dateadd(day, 1, convert(date, we.FirstComplete))

				--incomplete logic
				--but only fixing it after July 2017 for data consistency
				(
					(
						isnull(we.FirstComplete, wer.FirstReject) >= '2017-07-01' and
						ceh.EHCreateDate <  dateadd(day, 1, convert(date, isnull(we.FirstComplete, wer.FirstReject))) 
					) or
					ceh.EHCreateDate < dateadd(day, 1, convert(date, we.FirstComplete))
				)				


        )

    create nonclustered index idx on #estimates (SectionKey,EstimateDate desc) include(SectionCode,EstimateValue,RecoveryEstimateValue,AuditAction)

--select top 10
--    SectionKey,
--    count(distinct convert(date, EstimateDate))
--from
--    #estimates
--group by
--    SectionKey
--order by 2 desc

--select *
--from
--    #estimates
--where
--    SectionKey = 'AU-896394-895785-1066641'

----test section change
--update
--    #estimates
--set 
--    BenefitSectionKey = 'AU-430'
--where
--    SectionKey = 'AU-650056-653140-772339' and
--    EstimateDate = '2012-12-12 15:33:01.220'



    if object_id('[db-au-actuary].ws.ClaimEstimateMovement') is null
    begin

        create table [db-au-actuary].ws.ClaimEstimateMovement
        (
            [BIRowID] bigint not null identity(1,1),
	        [ClaimKey] [varchar](40) not null,
	        [SectionKey] [varchar](40) not null,
	        [SectionCode] [varchar](25) null,
	        [EstimateDate] [datetime] null,
	        [Currency] [varchar](3) not null,
	        [FXRate] [numeric](5, 4) not null,
	        [EstimateValue] decimal(20,6) null,
	        [RecoveryEstimateValue] decimal(20,6) null,
	        [EstimateMovement] decimal(20,6) null,
	        [RecoveryEstimateMovement] decimal(20,6) null,
            constraint PK_ClaimEstimateMovement primary key clustered (BIRowID)
        )

        create unique clustered index cidx on [db-au-actuary].ws.ClaimEstimateMovement (BIRowID)
        create index idx on [db-au-actuary].ws.ClaimEstimateMovement (ClaimKey)
            
    end
    else

        delete 
        from
            [db-au-actuary].ws.ClaimEstimateMovement
        where
            ClaimKey in
            (
                select 
                    ClaimKey
                from
                    ws.UpdatedClaim
            )
    
    ;with 
    cte_estimate as
    (
        select 
            t.ClaimKey,
            t.SectionKey,
            t.SectionCode,
            t.EstimateDate,
            t.Currency,
            t.FXRate,
            isnull(t.EstimateValue, 0) * f.DeleteFlag EstimateValue,
            isnull(t.RecoveryEstimateValue, 0) * f.DeleteFlag RecoveryEstimateValue,
            t.AuditAction
        from
            #estimates t
            cross apply
            (
                select
                    case
                        when t.AuditAction = 'D' then 0
                        else 1
                    end DeleteFlag
            ) f
    ),
    cte_movement as
    (
        select 
            t.ClaimKey,
            t.SectionKey,
            t.SectionCode,
            t.EstimateDate,
            t.Currency,
            t.FXRate,
            t.EstimateValue,
            t.RecoveryEstimateValue,
            t.AuditAction,
            isnull(r.PreviousAuditAction, '') PreviousAuditAction,
            isnull(r.PreviousSectionCode, t.SectionCode) PreviousSectionCode,
            isnull(r.PreviousEstimate, 0) PreviousEstimate,
            isnull(r.PreviousRecoveryEstimate, 0) PreviousRecoveryEstimate
        from
            cte_estimate t
            outer apply
            (
                select top 1 
                    r.AuditAction PreviousAuditAction,
                    r.SectionCode PreviousSectionCode,
                    r.EstimateValue PreviousEstimate,
                    r.RecoveryEstimateValue PreviousRecoveryEstimate
                from
                    cte_estimate r
                where
                    r.SectionKey = t.SectionKey and
                    r.EstimateDate < t.EstimateDate
                order by
                    Sectionkey,
                    EstimateDate desc
            ) r

    ),
    cte_correctedmovement as
    (
        select 
            t.ClaimKey,
            t.SectionKey,
            t.SectionCode,
            t.EstimateDate,
            t.Currency,
            t.FXRate,
            t.EstimateValue,
            t.RecoveryEstimateValue,
            case
                when t.AuditAction = 'D' then -t.PreviousEstimate
                when t.SectionCode <> t.PreviousSectionCode then t.EstimateValue
                else t.EstimateValue - t.PreviousEstimate
            end EstimateMovement,
            case
                when t.AuditAction = 'D' then -t.PreviousRecoveryEstimate
                when t.SectionCode <> t.PreviousSectionCode then t.RecoveryEstimateValue
                else t.RecoveryEstimateValue - t.PreviousRecoveryEstimate
            end RecoveryEstimateMovement
        from
            cte_movement t

        union all

        select 
            t.ClaimKey,
            t.SectionKey,
            t.PreviousSectionCode SectionCode,
            dateadd(ms, -10, t.EstimateDate) EstimateDate,
            t.Currency,
            t.FXRate,
            0 EstimateValue,
            0 RecoveryEstimateValue,
            -t.PreviousEstimate EstimateMovement,
            -t.PreviousRecoveryEstimate RecoveryEstimateMovement
        from
            cte_movement t
        where
            t.SectionCode <> t.PreviousSectionCode
    )
    insert into [db-au-actuary].ws.ClaimEstimateMovement
    (
	    ClaimKey,
	    SectionKey,
	    SectionCode,
	    EstimateDate,
	    Currency,
	    FXRate,
	    EstimateValue,
	    RecoveryEstimateValue,
	    EstimateMovement,
	    RecoveryEstimateMovement
    )
    select
	    ClaimKey,
	    SectionKey,
	    SectionCode,
	    EstimateDate,
	    Currency,
	    FXRate,
	    EstimateValue,
	    RecoveryEstimateValue,
	    EstimateMovement,
	    RecoveryEstimateMovement
    from
        cte_correctedmovement
    where
        --ClaimKey = 'AU-896394' and
        (
            EstimateMovement <> 0 or
            RecoveryEstimateMovement <> 0
        )

end
GO
