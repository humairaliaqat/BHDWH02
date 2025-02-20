USE [db-au-actuary]
GO
/****** Object:  StoredProcedure [dbo].[spClaimIncurred]    Script Date: 20/02/2025 10:01:19 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spClaimIncurred]
as
begin

    if object_id('tempdb..#incurredmovement') is not null
        drop table #incurredmovement

    --print 'start'
    --print convert(varchar(20), getdate(), 120)

    --00:12:00
    if object_id('tempdb..#incurred') is not null
        drop table #incurred

    select
        ClaimKey,
        SectionKey,
        SectionCode,
        EstimateDate IncurredDate,
        null PaymentKey,
        Currency,
        FXRate,
        EstimateMovement,
        0 PaymentMovement,
        0 RecoveryMovement,
        0 NetPaymentMovement,
        0 NetRecoveryMovement,
        0 NetRealRecoveryMovement,
        0 NetApprovedPaymentMovement
    into #incurred
    from
        [db-au-actuary].ws.ClaimEstimateMovement
    where
        ClaimKey in
        (
            select
                Claimkey
            from
                ws.UpdatedClaim
        )

    union all

    select
        cpm.ClaimKey,
        cpm.SectionKey,
        cpm.SectionCode,
        cpm.PaymentDate IncurredDate,
        cpm.PaymentKey,
        cpm.Currency,
        cpm.FXRate,
        case
            when cpm.asEstimate = 1 then cpm.PaymentMovement
            else 0
        end EstimateMovement,
        case
            when cpm.asEstimate = 0 and cpm.asRecovery = 0 then cpm.PaymentMovement
            else 0
        end PaymentMovement,
        case
            when cpm.asRecovery > 0 then cpm.PaymentMovement
            else 0
        end RecoveryMovement,
        case
            when cpm.asEstimate = 0 and cpm.asRecovery = 0 then cpm.NetPaymentMovement
            else 0
        end NetPaymentMovement,
        case
            --when cpm.asRecovery = 2 then cpm.NetPaymentMovement
            --20170720, LL, NetRecoveryMovement should contain real recovery too
            when cpm.asRecovery > 0 then cpm.NetPaymentMovement
            else 0
        end NetRecoveryMovement,
        case
            when cpm.asRecovery = 1 then cpm.NetPaymentMovement
            else 0
        end NetRealRecoveryMovement,
        case
            when cpm.asEstimate = 1 then cpm.NetPaymentMovement
            else 0
        end ApprovedPaymentMovement
    from
        [db-au-actuary].ws.ClaimPaymentMovement cpm with(nolock)
    where
        ClaimKey in
        (
            select
                Claimkey
            from
                ws.UpdatedClaim
        )

    select --top 10000
        cl.CountryKey [Domain Country],
    
        cast(null as varchar(5)) Company,
        cast(null as varchar(41)) PolicyKey,
	    cast(null as varchar(50)) BasePolicyNumber,
        cast(null as datetime) IssueDate,

        cl.OutletKey,

        cl.ClaimKey,
        cl.PolicyKey TRIPSPolicyKey,
        cl.PolicyTransactionKey PenguinTransKey,
        cl.AgencyCode ClaimAlpha,
        cl.ClaimNo,
        cl.PolicyNo,
        cl.PolicyIssuedDate,
        cl.PolicyProduct ClaimProduct,

        case
            when cl.ReceivedDate is null then cl.CreateDate
            when cl.ReceivedDate > dateadd(day, 1, convert(date, cl.CreateDate)) then cl.CreateDate
            else cl.ReceivedDate
        end ReceiptDate,
        cl.CreateDate RegisterDate,
    
        isnull(ce.EventID, 0) EventID,
        case
            when ce.CatastropheCode in ('CC', 'REC') then ''
            else isnull(ce.CatastropheCode, '') 
        end CATCode,
        ce.EventCountryCode,
        ce.EventCountryName,
        isnull(ce.PerilCode, 'OTH') PerilCode,

        ce.EventDate LossDate,    

        case
            when rtrim(isnull(ce.CaseID, '')) <> '' then 1
            else 0
        end MedicalAssistanceClaimFlag,
        case
            when isnull(cl.OnlineClaim, 0) = 1 then 1
            else 0
        end OnlineClaimFlag,

        isnull(ce.CaseID, '') CustomerCareID,
        isnull(cs.SectionID, cas.SectionID) SectionID,
        csd.SectionDate,
        ci.SectionCode,
        coalesce(cs.BenefitSectionKey, cas.BenefitSectionKey) BenefitSectionKey,
        cp.PaymentID, --leave null values

        ci.IncurredDate IncurredTime,
        isnull(we.StatusAtEndOfDay, 'Unknown') StatusAtEndOfDay,
        isnull(wem.StatusAtEndOfMonth, 'Unknown') StatusAtEndOfMonth,

        ci.Currency,
        ci.FXRate,
        ci.EstimateMovement,
        ci.PaymentMovement,
        ci.RecoveryMovement,
        ci.NetPaymentMovement,
        ci.NetRecoveryMovement,
        ci.NetRealRecoveryMovement,
        ci.NetApprovedPaymentMovement,
        --csi.Bucket SectionCategory,

        cast
        (
            case
                when cl.CountryKey = 'AU' then 'AUD'
                when cl.CountryKey = 'NZ' then 'NZD'
                when cl.CountryKey = 'UK' then 'GBP'
                when cl.CountryKey = 'SG' then 'SGD'
                when cl.CountryKey = 'MY' then 'MYR'
                when cl.CountryKey = 'ID' then 'IDR'
                when cl.CountryKey = 'CN' then 'RMB'
                when cl.CountryKey = 'IN' then 'INR'
                when cl.CountryKey = 'US' then 'USD'
                else 'AUD'
            end
            as varchar(5)
        ) LocalCurrencyCode,
        cast('' as varchar(5)) ForeignCurrencyCode,
        cast('' as varchar(5)) ExposureCurrencyCode,
        cast(1 as decimal(25,10)) ForeignCurrencyRate,
        cast(null as decimal(25,10)) USDRate,
        cast(null as date) ForeignCurrencyRateDate
    into #incurredmovement
    from
        #incurred ci
        inner join [db-au-cba]..clmClaim cl with(nolock) on
            cl.ClaimKey = ci.ClaimKey
        outer apply
        (
            select top 1
                cs.EventKey,
                cs.SectionID,
                cs.BenefitSectionKey
            from
                [db-au-cba]..clmSection cs with(nolock)
            where
                cs.SectionKey = ci.SectionKey
        ) cs
        outer apply
        (
            select top 1
                cs.EventKey,
                cs.SectionID,
                cs.BenefitSectionKey
            from
                [db-au-cba]..clmAuditSection cs with(nolock)
            where
                cs.SectionKey = ci.SectionKey
        ) cas
        outer apply
        (
            select top 1
                cp.EventKey,
                cp.PaymentID
            from
                [db-au-cba]..clmPayment cp with(nolock)
            where
                cp.PaymentKey = ci.PaymentKey
        ) cp
        left join [db-au-cba]..clmEvent ce with(nolock) on
            ce.EventKey = coalesce(cs.EventKey, cas.EventKey, cp.EventKey)
        outer apply
        (
            select
                min(SectionDate) SectionDate
            from
                (
                    select
                        min(eh.EHCreateDate) SectionDate
                    from
                        [db-au-cba]..clmEstimateHistory eh with(nolock)
                    where
                        eh.SectionKey = ci.SectionKey

                    union

                    select top 1
                        min(AuditDateTime) SectionDate
                    from
                        [db-au-cba]..clmAuditSection rcs with(nolock)
                    where
                        rcs.SectionKey = ci.SectionKey
                ) csm
        ) csd
        outer apply
        (
            select top 1
                we.StatusName StatusAtEndOfDay
            from
                [db-au-cba]..e5Work w with(nolock)
                inner join [db-au-cba]..e5WorkEvent we with(nolock) on
                    we.Work_ID = w.Work_ID
            where
                w.ClaimKey = cl.ClaimKey and
                w.WorkType like '%claim%' and
                w.WorkType not like '%audit%' and
                we.EventDate < convert(date, dateadd(day, 1, ci.IncurredDate))
            order by
                we.EventDate desc
        ) we
        outer apply
        (
            select top 1
                we.StatusName StatusAtEndOfMonth
            from
                [db-au-cba]..e5Work w with(nolock)
                inner join [db-au-cba]..e5WorkEvent we with(nolock) on
                    we.Work_ID = w.Work_ID
            where
                w.ClaimKey = cl.ClaimKey and
                w.WorkType like '%claim%' and
                w.WorkType not like '%audit%' and
                we.EventDate < dateadd(month, 1, convert(varchar(8), ci.IncurredDate, 120) + '01')
            order by
                we.EventDate desc
        ) wem

    --print 'dump'
    --print convert(varchar(20), getdate(), 120)

    
    --update cim
    --set
    --    cim.PolicyKey = null
    --from
    --    [db-au-actuary].ws.ClaimIncurredMovement cim


    --corporate
    --00:01:00
    update cim
    set
        cim.Company = 'CM',
        cim.PolicyKey = r.PolicyKey,
        cim.BasePolicyNumber = r.BasePolicyNo,
        cim.IssueDate = r.BaseIssueDate,
        cim.OutletKey = o.OutletKey
    from
        #incurredmovement cim
        outer apply
        (
            select top 1
                q.QuoteKey PolicyKey,
                q.PolicyNo BasePolicyNo,
                q.IssuedDate BaseIssueDate,
                q.AgencyCode AlphaCode
            from
                [db-au-cba]..corpQuotes q with(nolock)
            where
                q.CountryKey = cim.[Domain Country] and
                q.PolicyNo = cim.PolicyNo
            order by
                abs(datediff(day, q.IssuedDate, cim.PolicyIssuedDate))
        ) r
        outer apply
        (
            select top 1 
                o.OutletKey
            from
                [db-au-cba]..penOutlet o with(nolock)
            where
                o.OutletStatus = 'Current' and
                o.CountryKey = cim.[Domain Country] and
                o.CompanyKey = 'CM' and
                o.AlphaCode = r.AlphaCode
        ) o
    where
        ClaimProduct = 'CMC'

    --print 'corporate'
    --print convert(varchar(20), getdate(), 120)


    --TRIPS
    --00:05:00
    update cim
    set
        cim.Company = pl.AncestorCompanyKey,
        cim.PolicyKey = pl.AncestorPolicyKey,
        cim.BasePolicyNumber = pl.AncestorPolicyNo,
        cim.IssueDate = pl.AncestorIssueDate,
        cim.OutletKey = o.OutletKey
    from
        #incurredmovement cim
        inner join [db-au-cba]..Policy p with(nolock) on
            p.CountryPolicyKey = cim.TRIPSPolicyKey
        cross apply
        (
            select top 1 
                AncestorPolicyKey,
                AncestorPolicyNo,
                r.CompanyKey AncestorCompanyKey,
                r.AgencyCode AncestorAgencyCode,
                r.IssuedDate AncestorIssueDate
            from
                [db-au-actuary].ws.PolicyLineage pl with(nolock)
                inner join [db-au-cba]..Policy r with(nolock) on
                    r.PolicyKey = pl.AncestorPolicyKey
            where
                pl.PolicyKey = p.PolicyKey
        ) pl
        outer apply
        (
            select top 1 
                o.OutletKey
            from
                [db-au-cba]..penOutlet o with(nolock)
            where
                o.OutletStatus = 'Current' and
                o.CountryKey = cim.[Domain Country] and
                o.CompanyKey = pl.AncestorCompanyKey and
                o.AlphaCode = pl.AncestorAgencyCode
        ) o
    where
        isnull(cim.PolicyKey, '') = '' and
        isnull(p.isTripsPolicy, 0) = 1 and
        cim.RegisterDate >= pl.AncestorIssueDate
        

    --print 'trips'
    --print convert(varchar(20), getdate(), 120)


    --Penguin
    --00:03:00
    update cim
    set
        cim.Company = pt.CompanyKey,
        cim.PolicyKey = pt.PolicyKey,
        cim.BasePolicyNumber = p.PolicyNumber,
        cim.IssueDate = p.IssueDate,
        cim.OutletKey = o.OutletKey
    from
        #incurredmovement cim
        inner join [db-au-cba]..penPolicyTransSummary pt with(nolock) on
            pt.PolicyTransactionKey = cim.PenguinTransKey
        inner join [db-au-cba]..penPolicy p with(nolock) on
            p.PolicyKey = pt.PolicyKey
        outer apply
        (
            select top 1 
                o.OutletKey
            from
                [db-au-cba]..penOutlet o with(nolock)
            where
                o.OutletStatus = 'Current' and
                o.OutletAlphaKey = pt.OutletAlphaKey
        ) o
    where
        isnull(cim.PolicyKey, '') = '' 

    --print 'penguin'
    --print convert(varchar(20), getdate(), 120)

    --update loss date
    update #incurredmovement
    set
        LossDate =
            convert
            (
                date,
                case
                    when LossDate is null then RegisterDate
                    when LossDate < convert(date, isnull(IssueDate, PolicyIssuedDate)) then convert(date, isnull(IssueDate, PolicyIssuedDate))
                    when LossDate > dateadd(day, 1, RegisterDate) then RegisterDate
                    else LossDate
                end
            ) 

    --correct invalid FX codes
    --;with cte_fx as
    --(
    --    select 
    --        Currency,
    --        count(*) TransCount
    --    from
    --        [db-au-actuary].ws.ClaimIncurredMovement
    --    group by
    --        Currency
    --),
    --cte_ref as
    --(
    --    select distinct
    --        ForeignCode
    --    from
    --        [db-au-cba]..fxHistoryAverage r
    --)
    --select 
    --    *,
    --    (
    --        select top 1
    --            EventCountryName
    --        from
    --            [db-au-actuary].ws.ClaimIncurredMovement rr
    --        where
    --            rr.Currency = t.Currency
    --        group by
    --            EventCountryName
    --        order by
    --            count(*) desc
    --    ) EventCountries
    --from
    --    cte_fx t
    --    left join cte_ref r on
    --        r.ForeignCode = t.Currency
    --where
    --    r.ForeignCode is null
    --order by TransCount desc

    --00:05:00
    update #incurredmovement
    set
        ForeignCurrencyCode = isnull([db-au-actuary].dbo.fSASMapping('InvalidCurrency', Currency), Currency)

    --print 'invalid currency'
    --print convert(varchar(20), getdate(), 120)

    --00:04:00
    update #incurredmovement
    set
        ExposureCurrencyCode = 
            upper(
            isnull(rtrim(ltrim(
            case
                when 
                    ForeignCurrencyCode = LocalCurrencyCode and 
                    EventCountryCode <> 
                    case
                        when [Domain Country] = 'AU' then 'AUS' 
                        when [Domain Country] = 'NZ' then 'NZL'
                        when [Domain Country] = 'UK' then 'GBR'
                        when [Domain Country] = 'MY' then 'MYS'
                        when [Domain Country] = 'SG' then 'SGP'
                        when [Domain Country] = 'ID' then 'INA'
                        when [Domain Country] = 'CN' then 'CHN'
                        when [Domain Country] = 'IN' then 'IND'
                        when [Domain Country] = 'US' then 'USA'
                    end
                then 
                    (
                        select top 1 
                            CurrencyCode
                        from
                            [db-au-actuary].ws.CountryCurrency r
                        where
                            r.CountryISO3Code = [db-au-actuary].dbo.fSASMapping('CountryCodeISO3', EventCountryCode)
                    )
                else ForeignCurrencyCode
            end
            )), ''))

    update t
    set
        t.ExposureCurrencyCode = 'USD'
    from
        #incurredmovement t
    where
        not exists
        (
            select 
                null
            from
                [db-au-actuary].ws.CountryCurrency r
            where
                r.CurrencyCode = t.ExposureCurrencyCode and
                r.CurrencyCode <> ''
        )


    --print 'country currency'
    --print convert(varchar(20), getdate(), 120)

    --00:02:00
    update c
    set
        ForeignCurrencyRate =
            case
                when c.LocalCurrencyCode = c.ExposureCurrencyCode then 1
                when c.LocalCurrencyCode = c.ForeignCurrencyCode and c.LocalCurrencyCode <> c.ExposureCurrencyCode then cfx.ExposureFXRate
                when cfx.ExposureFXRate = 0 then c.FXRate
                when abs(c.FXRate - cfx.ExposureFXRate) / cfx.ExposureFXRate * 1.0000 > 0.15 then cfx.ExposureFXRate
                else c.FXRate
            end,
        ForeignCurrencyRateDate =
            case
                when c.LocalCurrencyCode = c.ExposureCurrencyCode then c.IncurredTime
                when c.LocalCurrencyCode = c.ForeignCurrencyCode and c.LocalCurrencyCode <> c.ExposureCurrencyCode then cfx.ExposureFXDate
                when cfx.ExposureFXRate = 0 then c.IncurredTime
                when abs(c.FXRate - cfx.ExposureFXRate) / cfx.ExposureFXRate * 1.0000 > 0.15 then cfx.ExposureFXDate
                else c.IncurredTime
            end
    from
        #incurredmovement c
        outer apply [db-au-actuary].dbo.fn_GetFXRate(c.LocalCurrencyCode, c.ExposureCurrencyCode, c.IncurredTime, default) fx
        outer apply
        (
            select 
                coalesce(fx.FXRate, c.FXRate, 1) ExposureFXRate,
                coalesce(fx.FXDate, c.IncurredTime) ExposureFXDate
        ) cfx

    update c
    set
        USDRate = fx.FXRate
    from
        #incurredmovement c
        outer apply [db-au-actuary].dbo.fn_GetFXRate(c.LocalCurrencyCode, 'USD', c.IncurredTime, default) fx


    --print 'fx rate'
    --print convert(varchar(20), getdate(), 120)

    if object_id('[db-au-actuary].ws.ClaimIncurredMovement') is null
    begin

        create table [db-au-actuary].ws.ClaimIncurredMovement
        (
            [BIRowID] bigint not null identity(1,1),
	        [Domain Country] [varchar](2) not null,
	        [Company] [varchar](5) null,
	        [PolicyKey] [varchar](41) null,
	        [BasePolicyNumber] [varchar](50) null,
	        [IssueDate] [datetime] null,
	        [OutletKey] [varchar](41) null,
	        [ClaimKey] [varchar](40) not null,
	        [TRIPSPolicyKey] [varchar](55) null,
	        [PenguinTransKey] [varchar](41) null,
	        [ClaimAlpha] [varchar](7) null,
	        [ClaimNo] [int] not null,
	        [PolicyNo] [varchar](50) null,
	        [PolicyIssuedDate] [datetime] null,
	        [ClaimProduct] [varchar](4) null,
	        [ReceiptDate] [datetime] null,
	        [RegisterDate] [datetime] null,
	        [EventID] [int] not null,
	        [CATCode] [varchar](3) not null,
	        [EventCountryCode] [varchar](3) null,
	        [EventCountryName] [nvarchar](45) null,
	        [PerilCode] [varchar](3) not null,
	        [LossDate] [datetime] null,
	        [MedicalAssistanceClaimFlag] [int] not null,
	        [OnlineClaimFlag] [int] not null,
	        [CustomerCareID] [varchar](15) not null,
	        [SectionID] [int] null,
	        [SectionDate] [datetime] null,
	        [SectionCode] [varchar](25) null,
	        [BenefitSectionKey] [varchar](40) null,
	        [PaymentID] [int] null,
	        [IncurredTime] [datetime] null,
	        [StatusAtEndOfDay] [nvarchar](100) not null,
	        [StatusAtEndOfMonth] [nvarchar](100) not null,
	        [Currency] [varchar](3) null,
	        [FXRate] decimal(25,10) null,
	        [EstimateMovement] decimal(20,6) null,
	        [PaymentMovement] decimal(20,6) null,
	        [RecoveryMovement] decimal(20,6) null,
	        [NetPaymentMovement] decimal(20,6) null,
	        [NetRecoveryMovement] decimal(20,6) null,
	        [NetRealRecoveryMovement] decimal(20,6) null,
	        [NetApprovedPaymentMovement] decimal(20,6) null,
	        [LocalCurrencyCode] [varchar](5) null,
	        [ForeignCurrencyCode] [varchar](5) null,
	        [ExposureCurrencyCode] [varchar](5) null,
	        [ForeignCurrencyRate] decimal(25,10) null,
	        [USDRate] decimal(25,10) null,
	        [ForeignCurrencyRateDate] [date] null,
            constraint PK_ClaimIncurredMovement primary key clustered (BIRowID)
        )

        create unique clustered index cidx on [db-au-actuary].ws.ClaimIncurredMovement (BIRowID)
        create index idx on [db-au-actuary].ws.ClaimIncurredMovement (ClaimKey,SectionID,IncurredTime) include (EstimateMovement,PaymentMovement,RecoveryMovement,NetPaymentMovement,NetRecoveryMovement)
        create index idx_domain on [db-au-actuary].ws.ClaimIncurredMovement ([Domain Country],[IncurredTime]) 
            include 
            (
                [Company],
                [PolicyKey],
                [BasePolicyNumber],
                [IssueDate],
                [OutletKey],
                [ClaimKey],
                [ClaimNo],
                [PolicyNo],
                [PolicyIssuedDate],
                [ReceiptDate],
                [RegisterDate],
                [EventID],
                [CATCode],
                [EventCountryCode],
                [EventCountryName],
                [PerilCode],
                [LossDate],
                [MedicalAssistanceClaimFlag],
                [OnlineClaimFlag],
                [CustomerCareID],
                [SectionID],
                [SectionDate],
                [SectionCode],
                [BenefitSectionKey],
                [PaymentID],
                [StatusAtEndOfDay],
                [StatusAtEndOfMonth],
                [Currency],
                [FXRate],
                [EstimateMovement],
                [PaymentMovement],
                [RecoveryMovement],
                [NetPaymentMovement],
                [NetRecoveryMovement],
                [NetRealRecoveryMovement],
                [NetApprovedPaymentMovement],
                [LocalCurrencyCode],
                [ForeignCurrencyCode],
                [ExposureCurrencyCode],
                [ForeignCurrencyRate],
                [USDRate],
                [ForeignCurrencyRateDate]
            )

    end
    else
        delete
        from
            [db-au-actuary].ws.ClaimIncurredMovement
        where
            ClaimKey in
            (
                select
                    Claimkey
                from
                    ws.UpdatedClaim
            )


    insert into [db-au-actuary].ws.ClaimIncurredMovement
    (
	    [Domain Country],
	    [Company],
	    [PolicyKey],
	    [BasePolicyNumber],
	    [IssueDate],
	    [OutletKey],
	    [ClaimKey],
	    [TRIPSPolicyKey],
	    [PenguinTransKey],
	    [ClaimAlpha],
	    [ClaimNo],
	    [PolicyNo],
	    [PolicyIssuedDate],
	    [ClaimProduct],
	    [ReceiptDate],
	    [RegisterDate],
	    [EventID],
	    [CATCode],
	    [EventCountryCode],
	    [EventCountryName],
	    [PerilCode],
	    [LossDate],
	    [MedicalAssistanceClaimFlag],
	    [OnlineClaimFlag],
	    [CustomerCareID],
	    [SectionID],
	    [SectionDate],
	    [SectionCode],
	    [BenefitSectionKey],
	    [PaymentID],
	    [IncurredTime],
	    [StatusAtEndOfDay],
	    [StatusAtEndOfMonth],
	    [Currency],
	    [FXRate],
        [USDRate],
	    [EstimateMovement],
	    [PaymentMovement],
	    [RecoveryMovement],
	    [NetPaymentMovement],
	    [NetRecoveryMovement],
	    [NetRealRecoveryMovement],
	    [NetApprovedPaymentMovement],
	    [LocalCurrencyCode],
	    [ForeignCurrencyCode],
	    [ExposureCurrencyCode],
	    [ForeignCurrencyRate],
	    [ForeignCurrencyRateDate]
    )
    select
	    [Domain Country],
	    [Company],
	    [PolicyKey],
	    [BasePolicyNumber],
	    [IssueDate],
	    [OutletKey],
	    [ClaimKey],
	    [TRIPSPolicyKey],
	    [PenguinTransKey],
	    [ClaimAlpha],
	    [ClaimNo],
	    [PolicyNo],
	    [PolicyIssuedDate],
	    [ClaimProduct],
	    [ReceiptDate],
	    [RegisterDate],
	    [EventID],
	    [CATCode],
	    [EventCountryCode],
	    [EventCountryName],
	    [PerilCode],
	    [LossDate],
	    [MedicalAssistanceClaimFlag],
	    [OnlineClaimFlag],
	    [CustomerCareID],
	    [SectionID],
	    [SectionDate],
	    [SectionCode],
	    [BenefitSectionKey],
	    [PaymentID],
	    [IncurredTime],
	    [StatusAtEndOfDay],
	    [StatusAtEndOfMonth],
	    [Currency],
	    [FXRate],
        [USDRate],
	    [EstimateMovement],
	    [PaymentMovement],
	    [RecoveryMovement],
	    [NetPaymentMovement],
	    [NetRecoveryMovement],
	    [NetRealRecoveryMovement],
	    [NetApprovedPaymentMovement],
	    [LocalCurrencyCode],
	    [ForeignCurrencyCode],
	    [ExposureCurrencyCode],
	    [ForeignCurrencyRate],
	    [ForeignCurrencyRateDate]
    from
        #incurredmovement

end

GO
