USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmClaimSummary]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_clmClaimSummary]
    @DateRange varchar(30),
    @StartDate varchar(10) = null,
    @EndDate varchar(10) = null

as
begin

/*
    20130315, LS,   claim schema changes
    20140509, LS,   synced rollup
    20140813, LS,   T12242 Global Claim
                    use batch logging
                    change agency detail to lookup policy (penguin, trips, corporate in this order) and fallback to claim when not available
    20140818, LS,   NZ area code translation error (TRIPS)
    20141008, LS,   F22107, exclude deleted payments
    20141014, LS,   duplicate policies (reseeded penguin addons), rely on PolicyTransactionkey from clmClaim
    20141117, LS,   bug fix,
                        wrong link to penPolicyTransSummary
                        wrong link to Policy
                    enable running without batch
    20150217, LS,   F23177, set section metrics to be 0 when it's deleted
    20150519, LS,   change benefit category to use view (shared logic with payment & estimate movement)
    20150722, LS,   add Simas Net as UW
    20150917, LS,   remove deleted section & payment from ClaimValue
	20151211, LT,	bug fix, since clmClaim.PolicyNo is now varchar(50), linking this directly to corpQuote.PolicyNo will produce an int overflow error.
					converted corpQuotes.PolicyNo to varchar(50) in where clause (convert(varchar(50),q.PolicyNo) = cl.PolicyNo)
    20160128, LS,   use clmClaim.OutletKey when it's null (CMC policies)
	20170601, LT,	updated UW definition as party of Zurich UW changeover
	20170630, LT,	updated UW definition for APOTC
	20171101, LT,	updated UW definition for ETI and ERV
    20180213, LL,   move UW to function (centralised business rule)
	20180927, LT,	Customised for CBA
	20181011, SD,	Corrected Summary data, by doing left join between clmClaim and clmSection
*/

--uncomment to debug
--declare @DateRange varchar(30)
--declare @StartDate varchar (10)
--declare @EndDate varchar (10)
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

    select
        @name = object_name(@@procid)

    /* get dates */
    if @DateRange <> '_User Defined'
        select
            @StartDate = convert(varchar(10), StartDate, 120),
            @EndDate = convert(varchar(10), EndDate, 120)
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


    /* synced rollup */
    if object_id('etl_clmClaim_sync') is null
        create table etl_clmClaim_sync
        (
            ClaimKey varchar(40) null
        )

    if exists (select null from etl_clmClaim_sync where ClaimKey is not null)
    begin

        /* prepare created/updated claims to roll up */
        if object_id('etl_clmClaimSummary') is not null
            drop table etl_clmClaimSummary

        select
            ClaimKey
        into etl_clmClaimSummary
        from
            etl_clmClaim_sync

        truncate table etl_clmClaim_sync

    end

    else
    begin

        /* prepare created/updated claims to roll up */
        if object_id('etl_clmClaimSummary') is not null
            drop table etl_clmClaimSummary

        select
            ClaimKey
        into etl_clmClaimSummary
        from
            [db-au-cba].dbo.clmAuditClaim
        where
            AuditDateTime >= @StartDate and
            AuditDateTime <  dateadd(day, 1, @EndDate)

        union

        select
            ClaimKey
        from
            [db-au-cba].dbo.clmClaim
        where
            (
                CreateDate >= @StartDate and
                CreateDate <  dateadd(day, 1, @EndDate)
            ) or
            (
                FinalisedDate >= @StartDate and
                FinalisedDate <  dateadd(day, 1, @EndDate)
            )

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

    if object_id('[db-au-cba].dbo.clmClaimSummary') is null
    begin

        create table [db-au-cba].dbo.clmClaimSummary
        (
            [CountryKey] varchar(2) not null,
            [ClaimKey] varchar(40) not null,
            [ClaimNo] int not null,
            [CreateDate] datetime null,
            [ReceivedDate] datetime null,
            [FinalisedDate] datetime null,
            [PolicyTransactionKey] varchar(41) null,
            [PolicyKey] varchar(55) null,
            [PolicyNo] varchar(50) null,
            [PolicySource] varchar(25) null,
            [IssuedDate] datetime null,
            [ProductCode] nvarchar(50) null,
            [PlanCode] nvarchar(50) null,
            [Underwriter] nvarchar(10) null,
            [AgencyKey] varchar(50) null,
            [OutletKey] varchar(33) null,
            [AgencyCode] varchar(7) null,
            [AgencyName] nvarchar(50) null,
            [AgencySuperGroupName] nvarchar(25) null,
            [AgencyGroupName] nvarchar(50) null,
            [AgencySubGroupName] nvarchar(50) null,
            [AgencyGroupState] nvarchar(50) null,
            [NumberOfCharged] int null,
            [NumberOfAdults] int null,
            [NumberOfChildren] int null,
            [NumberOfPersons] int null,
            [DepartureDate] datetime null,
            [ReturnDate] datetime null,
            [NumberOfDays] int null,
            [Area] nvarchar(50) null,
            [AreaType] varchar(25) null,
            [Destination] nvarchar(100) null,
            [TripCost] nvarchar(50) null,
            [CancellationCoverValue] nvarchar(50) null,
            [CancellationPremium] money null,
            [Excess] money null,
            [NameKey] varchar(40) null,
            [Title] nvarchar(50) null,
            [FirstName] nvarchar(100) null,
            [Surname] nvarchar(100) null,
            [DOB] datetime null,
            [BusinessName] nvarchar(100) null,
            [IsGroupPolicy] bit null,
            [IsLuggageClaim] bit null,
            [IsHighRisk] bit null,
            [IsOnlineClaim] bit null,
            [IsPotentialRecovery] bit null,
            [IsFinalised] bit null,
            [OnlineAlpha] nvarchar(20) null,
            [OnlineConsultant] nvarchar(50) null,
            [EventKey] varchar(40) null,
            [EventID] int null,
            [CustomerCareID] nvarchar(15) null,
            [EventDate] datetime null,
            [EventDescription] nvarchar(100) null,
            [CatastropheCode] varchar(3) null,
            [Catastrophe] nvarchar(60) null,
            [EventCountryCode] varchar(3) null,
            [EventCountryName] nvarchar(45) null,
            [PerilCode] varchar(3) null,
            [Peril] nvarchar(65) null,
            [SectionKey] varchar(40) null,
            [SectionID] int null,
            [SectionCode] varchar(25) null,
            [Benefit] nvarchar(255) null,
            [BenefitCategory] nvarchar(50) null,
            [EstimateValue] money null,
            [RecoveryEstimateValue] money null,
            [FirstEstimateDate] datetime null,
            [FirstEstimateCreator] nvarchar(150) null,
            [FirstEstimateValue] money null,
            [FirstNilEstimateDate] datetime null,
            [FirstNilEstimateCreator] nvarchar(150) null,
            [FirstPayment] datetime null,
            [LastPayment] datetime null,
            [PaidPayment] money null,
            [RecoveredPayment] money null,
            [PaidRecoveredPayment] money null,
            [ClaimValue] money null,
            [ApprovedPayment] money null,
            [PendingApprovalPayment] money null,
            [FailedPayment] money null,
            [StoppedPayment] money null,
            [DeclinedPayment] money null,
            [RejectedPayment] money null,
            [PendingAuthorityPayment] money null,
            [CancelledPayment] money null,
            [ReturnedPayment] money null,
            [BIRowID] int not null identity(1,1),
            [CreateBatchID] int null,
            [UpdateBatchID] int null
        )

        create clustered index idx_clmClaimSummary_BIRowID on [db-au-cba].dbo.clmClaimSummary(BIRowID)
        create nonclustered index idx_clmClaimSummary_ClaimKey on [db-au-cba].dbo.clmClaimSummary(ClaimKey) include(BenefitCategory,FirstEstimateDate,FirstNilEstimateDate,EstimateValue,RecoveryEstimateValue,PaidPayment,RecoveredPayment,PaidRecoveredPayment,ClaimValue)
        create nonclustered index idx_clmClaimSummary_ClaimNo on [db-au-cba].dbo.clmClaimSummary(ClaimNo,CountryKey) include(ClaimKey,BenefitCategory,FirstEstimateDate,FirstNilEstimateDate,EstimateValue,RecoveryEstimateValue,PaidPayment,RecoveredPayment,PaidRecoveredPayment,ClaimValue)
        create nonclustered index idx_clmClaimSummary_CreateDate on [db-au-cba].dbo.clmClaimSummary(CreateDate,CountryKey) include(ClaimKey,BenefitCategory,FirstEstimateDate,FirstNilEstimateDate,EstimateValue,RecoveryEstimateValue,PaidPayment,RecoveredPayment,PaidRecoveredPayment,ClaimValue)
        create nonclustered index idx_clmClaimSummary_ReceivedDate on [db-au-cba].dbo.clmClaimSummary(ReceivedDate,CountryKey) include(ClaimKey,BenefitCategory,FirstEstimateDate,FirstNilEstimateDate,EstimateValue,RecoveryEstimateValue,PaidPayment,RecoveredPayment,PaidRecoveredPayment,ClaimValue)
        create nonclustered index idx_clmClaimSummary_FinalisedDate on [db-au-cba].dbo.clmClaimSummary(FinalisedDate,CountryKey) include(ClaimKey,BenefitCategory,FirstEstimateDate,FirstNilEstimateDate,EstimateValue,RecoveryEstimateValue,PaidPayment,RecoveredPayment,PaidRecoveredPayment,ClaimValue)
        create nonclustered index idx_clmClaimSummary_PolicyNo on [db-au-cba].dbo.clmClaimSummary(PolicyNo,CountryKey) include(ClaimKey,ClaimNo,CreateDate,BenefitCategory,FirstEstimateDate,FirstNilEstimateDate,EstimateValue,RecoveryEstimateValue,PaidPayment,RecoveredPayment,PaidRecoveredPayment,ClaimValue)
        create nonclustered index idx_clmClaimSummary_PolicyTransactionKey on [db-au-cba].dbo.clmClaimSummary(PolicyTransactionKey) include(ClaimKey,ClaimNo,CreateDate,BenefitCategory,FirstEstimateDate,FirstNilEstimateDate,EstimateValue,RecoveryEstimateValue,PaidPayment,RecoveredPayment,PaidRecoveredPayment,ClaimValue)
        create nonclustered index idx_clmClaimSummary_SectionKey on [db-au-cba].dbo.clmClaimSummary(SectionKey) include(ClaimKey)
        create nonclustered index idx_clmClaimSummary_AgencyKey on [db-au-cba].dbo.clmClaimSummary(AgencyKey) include(ClaimKey)
        create nonclustered index idx_clmClaimSummary_OutletKey on [db-au-cba].dbo.clmClaimSummary(OutletKey) include(ClaimKey)
        create nonclustered index idx_clmClaimSummary_Trips on [db-au-cba].dbo.clmClaimSummary(DepartureDate,ReturnDate) include(CountryKey,ClaimKey)
        create nonclustered index idx_clmClaimSummary_EventDate on [db-au-cba].dbo.clmClaimSummary(EventDate,CountryKey) include(ClaimKey,ClaimNo,CatastropheCode,BenefitCategory)
        create nonclustered index idx_clmClaimSummary_FirstNilEstimateDate on [db-au-cba].dbo.clmClaimSummary(FirstNilEstimateDate,CountryKey) include(ClaimKey,FirstEstimateDate)
        create nonclustered index idx_clmClaimSummary_FirstEstimateDate on [db-au-cba].dbo.clmClaimSummary(FirstEstimateDate,CountryKey) include(ClaimKey,FirstNilEstimateDate)
        create nonclustered index idx_clmClaimSummary_CustomerCareID on [db-au-cba].dbo.clmClaimSummary(CustomerCareID) include(ClaimKey,ClaimNo,CreateDate)

    end

    if object_id('tempdb..#clmClaimSummary') is not null
        drop table #clmClaimSummary

    select
        cl.CountryKey,
        cl.ClaimKey,
        cl.ClaimNo,
        cl.CreateDate,
        cl.ReceivedDate,
        cl.FinalisedDate,

        /* policy */
        peng.PolicyTransactionKey,
        peng.PolicyKey,
        cl.PolicyNo,
        comb.PolicySource,
        comb.IssuedDate,
        comb.ProductCode,
        comb.PlanCode,

        /* outlet */
        drvd.Underwriter,
        isnull(peng.OutletKey, cl.OutletKey) OutletKey,
        comb.AgencyKey,
        comb.AgencyCode,
        comb.AgencyName,
        comb.AgencySuperGroupName,
        comb.AgencyGroupName,
        comb.AgencySubGroupName,
        comb.AgencyGroupState,

        /* trips */
        comb.NumberOfCharged,
        comb.NumberOfAdults,
        comb.NumberOfChildren,
        comb.NumberOfPersons,
        comb.DepartureDate,
        comb.ReturnDate,
        comb.NumberOfDays,
        comb.Area,
        comb.AreaType,
        comb.Destination,
        comb.TripCost,
        comb.CancellationCoverValue,
        comb.CancellationPremium,
        comb.Excess,

        /* primary claimant */
        cn.NameKey,
        cn.Title,
        cn.FirstName,
        cn.Surname,
        cn.DOB,
        cn.BusinessName,

        /* claim details */
        cl.OnlineAlpha,
        cl.OnlineConsultant,
        isnull(cl.GroupPolicy, 0) IsGroupPolicy,
        isnull(cl.LuggageFlag, 0) IsLuggageClaim,
        isnull(cl.HRisk, 0) IsHighRisk,
        isnull(cl.OnlineClaim, 0) IsOnlineClaim,
        isnull(cl.RecoveryType, 0) IsPotentialRecovery,
        case
            when cl.FinalisedDate is null then 0
            else 1
        end IsFinalised,

        /* event */
        ce.EventKey,
        ce.EventID,
        ce.CaseID CustomerCareID,
        convert(date, ce.EventDate) EventDate,
        ce.CatastropheCode,
        ce.CatastropheShortDesc Catastrophe,
        ce.EventCountryCode,
        ce.EventCountryName,
        ce.EventDesc EventDescription,
        ce.PerilCode,
        ce.PerilDesc Peril,

        /* section */
        cs.SectionKey,
        cs.SectionID,
        cs.SectionCode,
        cbb.BenefitDesc Benefit,
        cbb.BenefitCategory,
        isnull(cs.EstimateValue, 0) * (1 - cs.isDeleted) EstimateValue,
        isnull(cs.RecoveryEstimateValue, 0) * (1 - cs.isDeleted) RecoveryEstimateValue,
        fe.FirstEstimateDate,
        fe.FirstEstimateCreator,
        fe.FirstEstimateValue,
        fne.FirstNilEstimateDate,
        fne.FirstNilEstimateCreator,

        /* payment */
        cp.FirstPayment,
        cp.LastPayment,
        isnull(cp.PaidPayment, 0) * (1 - cs.isDeleted) PaidPayment,
        isnull(cp.RecoveredPayment, 0) * (1 - cs.isDeleted) RecoveredPayment,
        (isnull(cp.PaidPayment, 0) + isnull(cp.RecoveredPayment, 0)) * (1 - cs.isDeleted) PaidRecoveredPayment,
        (isnull(cp.PaidPayment, 0) + isnull(cp.RecoveredPayment, 0) + isnull(cs.EstimateValue, 0) - isnull(cs.RecoveryEstimateValue, 0)) * (1 - cs.isDeleted) ClaimValue,
        isnull(cp.ApprovedPayment, 0) * (1 - cs.isDeleted) ApprovedPayment,
        isnull(cp.PendingApprovalPayment, 0) * (1 - cs.isDeleted) PendingApprovalPayment,
        isnull(cp.FailedPayment, 0) * (1 - cs.isDeleted) FailedPayment,
        isnull(cp.StoppedPayment, 0) * (1 - cs.isDeleted) StoppedPayment,
        isnull(cp.DeclinedPayment, 0) * (1 - cs.isDeleted) DeclinedPayment,
        isnull(cp.RejectedPayment, 0) * (1 - cs.isDeleted) RejectedPayment,
        isnull(cp.PendingAuthorityPayment, 0) * (1 - cs.isDeleted) PendingAuthorityPayment,
        isnull(cp.CancelledPayment, 0) * (1 - cs.isDeleted) CancelledPayment,
        isnull(cp.ReturnedPayment, 0) * (1 - cs.isDeleted) ReturnedPayment

    into #clmClaimSummary
    from
        [db-au-cba].dbo.clmClaim cl
        /* flip event & section due to the null recy workaround */
        left join [db-au-cba].dbo.clmSection cs on
            cs.ClaimKey = cl.ClaimKey
        left join [db-au-cba].dbo.clmEvent ce on
            ce.EventKey = cs.EventKey
        left join [db-au-cba]..vclmBenefitCategory cbb on
            cbb.BenefitSectionKey = cs.BenefitSectionKey
        outer apply
        (
            select top 1
                eh.EHCreateDate FirstEstimateDate,
                eh.EHEstimateValue FirstEstimateValue,
                eh.EHCreatedBy FirstEstimateCreator
            from
                [db-au-cba].dbo.clmEstimateHistory eh
            where
                eh.SectionKey = cs.SectionKey
            order by
                eh.EHCreateDate
        ) fe
        outer apply
        (
            select top 1
                eh.EHCreateDate FirstNilEstimateDate,
                eh.EHCreatedBy FirstNilEstimateCreator
            from
                [db-au-cba].dbo.clmEstimateHistory eh
            where
                eh.SectionKey = cs.SectionKey and
                eh.EHEstimateValue = 0
            order by
                eh.EHCreateDate
        ) fne
        outer apply
        (
            select top 1
                cn.NameKey,
                cn.Title,
                cn.Firstname,
                cn.Surname,
                cn.DOB,
                cn.BusinessName
            from
                [db-au-cba].dbo.clmName cn
            where
                cn.ClaimKey = cl.ClaimKey
            order by
                cn.isPrimary desc,
                cn.Num
        ) cn
        outer apply
        (
            select
                min(
                    case
                        when PaymentStatus = 'PAID' then ModifiedDate
                        else null
                    end
                ) FirstPayment,
                max(
                    case
                        when PaymentStatus = 'PAID' then ModifiedDate
                        else null
                    end
                ) LastPayment,
                sum(
                    case
                        when cp.PaymentStatus = 'PAID' then cp.PaymentAmount
                        else 0
                    end
                ) PaidPayment,
                sum(
                    case
                        when cp.PaymentStatus = 'RECY' then cp.PaymentAmount
                        else 0
                    end
                ) RecoveredPayment,
                sum(
                    case
                        when cp.PaymentStatus = 'APPR' then cp.PaymentAmount
                        else 0
                    end
                ) ApprovedPayment,
                sum(
                    case
                        when cp.PaymentStatus = 'PAAP' then cp.PaymentAmount
                        else 0
                    end
                ) PendingApprovalPayment,
                sum(
                    case
                        when cp.PaymentStatus = 'FAIL' then cp.PaymentAmount
                        else 0
                    end
                ) FailedPayment,
                sum(
                    case
                        when cp.PaymentStatus = 'STOP' then cp.PaymentAmount
                        else 0
                    end
                ) StoppedPayment,
                sum(
                    case
                        when cp.PaymentStatus = 'DECL' then cp.PaymentAmount
                        else 0
                    end
                ) DeclinedPayment,
                sum(
                    case
                        when cp.PaymentStatus = 'REJC' then cp.PaymentAmount
                        else 0
                    end
                ) RejectedPayment,
                sum(
                    case
                        when cp.PaymentStatus = 'APHA' then cp.PaymentAmount
                        else 0
                    end
                ) PendingAuthorityPayment,
                sum(
                    case
                        when cp.PaymentStatus = 'CANX' then cp.PaymentAmount
                        else 0
                    end
                ) CancelledPayment,
                sum(
                    case
                        when cp.PaymentStatus = 'RTND' then cp.PaymentAmount
                        else 0
                    end
                ) ReturnedPayment
            from
                [db-au-cba].dbo.clmPayment cp
            where
                cp.SectionKey = cs.SectionKey and
                cp.isDeleted = 0
        ) cp
        outer apply
        (
            select top 1
                'Penguin' PolicySource,
                pt.PolicyTransactionKey,
				pt.PolicyKey,
                pt.CompanyKey,
                pt.IssueDate,
                p.ProductCode,
                pp.PlanCode,
                o.OutletKey,
                o.AlphaCode AgencyCode,
                o.OutletName,
                o.SuperGroupName SuperGroup,
                o.GroupName,
                o.SubGroupName SubGroup,
                o.StateSalesArea GroupState,
                pt.ChargedAdultsCount NumberOfCharged,
                pt.AdultsCount NumberOfAdults,
                pt.ChildrenCount NumberOfChildren,
                pt.TravellersCount NumberOfPersons,
                isnull(tc.TransactionStart, p.TripStart) DepartureDate,
                isnull(tc.TransactionEnd, p.TripEnd) ReturnDate,
                datediff(day, isnull(tc.TransactionStart, p.TripStart), isnull(tc.TransactionEnd, p.TripEnd)) + 1 NumberOfDays,
                p.AreaNumber Area,
                p.AreaType,
                p.PrimaryCountry Destination,
                isnull(tc.TripCost, p.TripCost) TripCost,
                p.CancellationCover CancellationCoverValue,
                addon.GrossPremiumAfterDiscount CancellationPremium,
                p.Excess
            from
                [db-au-cba].dbo.penPolicyTransSummary pt
                inner join [db-au-cba].dbo.penPolicy p on
                    p.PolicyKey = pt.PolicyKey
                inner join [db-au-cba].dbo.vpenPolicyPlanCode pp on
                    pp.PolicyTransactionKey = pt.PolicyTransactionKey
                inner join [db-au-cba].dbo.penOutlet o on
                    o.OutletAlphaKey = pt.OutletAlphaKey and
                    o.OutletStatus = 'Current'
                cross apply
                (
                    select top 1
                        tc.TripCost,
                        tc.TransactionStart,
                        tc.TransactionEnd
                    from
                        [db-au-cba].dbo.penPolicyTransSummary tc
                    where
                        tc.PolicyKey = p.PolicyKey and
                        tc.TripCost is not null
                    order by
                        tc.IssueDate desc
                ) tc
                outer apply
                (
                    select top 1
                        ppc.GrossPremiumAfterDiscount
                    from
                        [db-au-cba].dbo.vpenPolicyPriceComponent ppc
                    where
                        ppc.PriceCategory = 'Cancellation' and
                        ppc.PolicyTransactionKey = pt.PolicyTransactionKey
                ) addon
            where
                pt.PolicyTransactionKey = cl.PolicyTransactionKey
        ) peng
        --outer apply
        --(
        --    select top 1
        --        'TRIPS' PolicySource,
        --        p.PolicyKey,
        --        p.IssuedDate,
        --        p.ProductCode,
        --        p.PlanCode,
        --        a.AgencyKey,
        --        a.AgencyCode,
        --        a.AgencyName OutletName,
        --        a.AgencySuperGroupName SuperGroup,
        --        a.AgencyGroupName GroupName,
        --        a.AgencySubGroupName SubGroup,
        --        a.AgencyGroupState GroupState,
        --        case
        --            when p.NumberOfAdults = 0 then p.NumberOfChildren
        --            else p.NumberOfAdults
        --        end NumberOfCharged,
        --        p.NumberOfAdults,
        --        p.NumberOfChildren,
        --        p.NumberOfPersons,
        --        p.DepartureDate,
        --        p.ReturnDate,
        --        p.NumberOfDays,
        --        case
        --            when p.CountryKey = 'AU' then
        --                case
        --                    when p.PlanCode in ('PBA5','CPBA5') then 'Area 6'
        --                    when p.PlanCode like '%1' and p.PlanCode not like '%D%' then 'Area 1'
        --                    when p.PlanCode like '%2' and p.PlanCode not like '%D%' then 'Area 2'
        --                    when p.PlanCode like '%3' and p.PlanCode not like '%D%' then 'Area 3'
        --                    when (p.PlanCode like '%4' or p.PlanCode like '%5') and p.PlanCode not like '%D%' then 'Area 4'
        --                    when (p.PlanCode in ('X','XM') or p.PlanCode like '%D%') then 'Area 5'
        --                    else 'Unknown'
        --                end
        --            when p.CountryKey = 'NZ' then
        --                case
        --                    when p.PlanCode like 'C%' or p.PlanCode like 'D%' then 'Area 8'
        --                    when p.PlanCode like 'A%' and p.Destination = 'Worldwide' then 'Area 10'
        --                    when p.PlanCode like 'A%' and p.Destination = 'Restricted Worldwide' then 'Area 11'
        --                    when p.PlanCode like 'A%' and p.Destination = 'South Pacific and Australia' then 'Area 12'
        --                    when p.PlanCode like 'A%' and p.Destination = 'New Zealand Only' then 'Area 13'
        --                    when p.PlanCode like 'A%' then 'Area 0'
        --                    when p.PlanCode like 'X%' or len(p.PlanCode) > 3 then
        --                    case
        --                        when patindex('%[0-9]%', p.PlanCode) > 0 and p.PlanCode like '%M%' then 'Area ' + convert(varchar, convert(int, substring(p.PlanCode, patindex('%[0-9]%', p.PlanCode), len(p.PlanCode) - patindex('%[0-9]%', p.PlanCode) + 1)) + 9)
        --                        else 'Area ' + substring(p.PlanCode, patindex('%[0-9]%', p.PlanCode), len(p.PlanCode) - patindex('%[0-9]%', p.PlanCode) + 1)
        --                    end
        --                    else 'Unknown'
        --                end
        --            else
        --            case
        --                when p.PlanCode like '%1' then 'Area 1'
        --                when p.PlanCode like '%2' then 'Area 2'
        --                when p.PlanCode like '%3' then 'Area 3'
        --                when p.PlanCode like '%4' then 'Area 4'
        --                when p.PlanCode like '%5' then 'Area 5'
        --                when p.PlanCode like '%6' then 'Area 6'
        --                when p.PlanCode like '%7' then 'Area 7'
        --                else 'Unknown'
        --            end
        --        end Area,
        --        case
        --            when p.CountryKey = 'NZ' then
        --                case
        --                    when p.PlanCode IN ('X',' XM', 'X15', 'X2', 'X4', 'X6', 'X8', 'XBA8', 'C', 'C2', 'C4', 'C6', 'C8', 'C15', 'PBA8') or p.PlanCode like '%D%' then 'Domestic'
        --                    else 'International'
        --                end
        --            else
        --                case
        --                    when p.PlanCode IN ('X',' XM', 'XBA5') OR p.PlanCode like '%D%' THEN 'Domestic'
        --                    when p.PlanCode like 'XA%' AND p.PlanCode NOT IN ('XA',' XA+') THEN 'Domestic'
        --                    when p.PlanCode IN ('PBA5', 'CPBA5') THEN 'Domestic (Inbound)'
        --                    else 'International'
        --                end
        --        end AreaType,
        --        p.Destination,
        --        p.TripCost,
        --        p.CancellationCoverValue,
        --        p.CancellationPremium,
        --        p.Excess
        --    from
        --        [db-au-cba].dbo.Policy p
        --        inner join [db-au-cba].dbo.Agency a on
        --            a.AgencyKey = p.AgencyKey and
        --            a.AgencyStatus = 'Current'
        --    where
        --        p.CountryPolicyKey = cl.PolicyKey
        --) trip
        outer apply
        (
            select top 1
                'Corporate' PolicySource,
                'CMC' ProductCode,
                '' PlanCode,
                q.IssuedDate,
                a.OutletAlphaKey as AgencyKey,
                a.AlphaCode as AgencyCode,
                a.OutletName as OutletName,
                a.SuperGroupName as SuperGroup,
                a.GroupName,
                a.SubGroupName SubGroup,
                a.StateSalesArea GroupState,
                0 NumberOfCharged,
                0 NumberOfAdults,
                0 NumberOfChildren,
                0 NumberOfPersons,
                q.PolicyStartDate DepartureDate,
                q.PolicyExpiryDate ReturnDate,
                datediff(day, q.PolicyStartDate, q.PolicyExpiryDate) + 1 NumberOfDays,
                '' Area,
                '' AreaType,
                '' Destination,
                '' TripCost,
                '' CancellationCoverValue,
                0 CancellationPremium,
                q.Excess
            from
                [db-au-cba].dbo.corpQuotes q
                inner join [db-au-cba].dbo.penOutlet a on
					a.CountryKey = q.CountryKey and
					a.AlphaCode = q.AgencyCode and
                    a.OutletStatus = 'Current'
            where
                q.CountryKey = cl.CountryKey and
                convert(varchar(50),q.PolicyNo) = cl.PolicyNo
        ) corp
        outer apply
        (
            select top 1
                a.OutletAlphaKey AgencyKey,
                a.AlphaCode AgencyCode,
                a.OutletName ,
                a.SuperGroupName SuperGroup,
                a.GroupName GroupName,
                a.SubGroupName SubGroup,
                a.StateSalesArea GroupState,
                0 NumberOfCharged,
                0 NumberOfAdults,
                0 NumberOfChildren,
                0 NumberOfPersons
            from
                [db-au-cba].dbo.penOutlet a
            where
                a.OutletStatus = 'Current' and
                a.CountryKey = cl.CountryKey and
                a.AlphaCode = cl.AgencyCode
        ) clagt
        cross apply
        (
            select
                coalesce(peng.IssueDate, corp.IssuedDate, cl.PolicyIssuedDate) IssuedDate,
                coalesce(peng.ProductCode, corp.ProductCode, cl.PolicyProduct) ProductCode,
                coalesce(peng.PlanCode, corp.PlanCode, cl.PolicyPlanCode) PlanCode,
                coalesce(peng.PolicySource, corp.PolicySource, 'Claim') PolicySource,
                coalesce(corp.AgencyKey, clagt.AgencyKey) AgencyKey,
                coalesce(peng.AgencyCode, corp.AgencyCode, clagt.AgencyCode) AgencyCode,
                coalesce(peng.OutletName, corp.OutletName, clagt.OutletName) AgencyName,
                coalesce(peng.SuperGroup, corp.SuperGroup, clagt.SuperGroup) AgencySuperGroupName,
                coalesce(peng.GroupName, corp.GroupName, clagt.GroupName) AgencyGroupName,
                coalesce(peng.SubGroup,corp.SubGroup, clagt.SubGroup) AgencySubGroupName,
                coalesce(peng.GroupState, corp.GroupState, clagt.GroupState) AgencyGroupState,
                coalesce(peng.NumberOfCharged,  corp.NumberOfCharged, clagt.NumberOfCharged) NumberOfCharged,
                coalesce(peng.NumberOfAdults,  corp.NumberOfAdults, clagt.NumberOfAdults) NumberOfAdults,
                coalesce(peng.NumberOfChildren,  corp.NumberOfChildren, clagt.NumberOfChildren) NumberOfChildren,
                coalesce(peng.NumberOfPersons,  corp.NumberOfPersons, clagt.NumberOfPersons) NumberOfPersons,
                coalesce(peng.DepartureDate,  corp.DepartureDate, cl.DepartureDate) DepartureDate,
                coalesce(peng.ReturnDate,  corp.ReturnDate, cl.ArrivalDate) ReturnDate,
                coalesce(peng.NumberOfDays,  corp.NumberOfDays, cl.NumberOfDays) NumberOfDays,
                coalesce(peng.Area,  corp.Area, '') Area,
                coalesce(peng.AreaType,  corp.AreaType, '') AreaType,
                coalesce(peng.Destination,  corp.Destination, '') Destination,
                coalesce(peng.TripCost, corp.TripCost, '') TripCost,
                coalesce(peng.CancellationCoverValue,  corp.CancellationCoverValue, '') CancellationCoverValue,
                coalesce(peng.CancellationPremium,  corp.CancellationPremium, 0) CancellationPremium,
                coalesce(peng.Excess, corp.Excess, 0) Excess
		) comb
        cross apply
        (
            select
                [db-au-cba].dbo.fn_GetUnderWriterCode
                (
                    peng.CompanyKey, 
                    cl.CountryKey, 
                    peng.AgencyCode, 
                    comb.IssuedDate
                ) Underwriter

     --           case
     --               when peng.CompanyKey = 'TIP' and (comb.IssuedDate < '2017-06-01' OR (peng.AgencyCode in ('APN0004','APN0005') and comb.IssuedDate < '2017-07-01')) then 'TIP-GLA'
					--when peng.CompanyKey = 'TIP' and (comb.IssuedDate >= '2017-06-01' OR (peng.AgencyCode in ('APN0004','APN0005') and comb.IssuedDate >= '2017-07-01')) then 'TIP-ZURICH'
     --               when cl.CountryKey in ('AU', 'NZ') and comb.IssuedDate >= '2009-07-01' and comb.IssuedDate < '2017-06-01' then 'GLA'
					--when cl.CountryKey in ('AU', 'NZ') and comb.IssuedDate >= '2017-06-01' then 'ZURICH'
     --               when cl.CountryKey in ('AU', 'NZ') and comb.IssuedDate <  '2009-07-01' then 'VERO'
     --               when cl.CountryKey in ('UK') and comb.IssuedDate >= '2009-09-01' and comb.IssuedDate < '2017-07-01' then 'ETI'
					--when cl.CountryKey in ('UK') and comb.IssuedDate >= '2017-07-01' then 'ERV'
     --               when cl.CountryKey in ('UK') and comb.IssuedDate <  '2009-09-01' then 'UKU'
     --               when cl.CountryKey in ('MY', 'SG') then 'ETIQA'
     --               when cl.CountryKey in ('CN') then 'CICC'
     --               when cl.CountryKey in ('ID') then 'Simas Net'
     --               else 'OTHER'
     --           end Underwriter
        ) drvd
    where
        cl.ClaimKey in
        (
            select
                ClaimKey
            from
                etl_clmClaimSummary
        )

    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-cba].dbo.clmClaimSummary with(tablock) t
        using #clmClaimSummary s on
            s.ClaimKey = t.Claimkey and
            s.SectionKey = t.SectionKey

        when matched then

            update
            set
                ClaimNo = s.ClaimNo,
                CreateDate = s.CreateDate,
                ReceivedDate = s.ReceivedDate,
                FinalisedDate = s.FinalisedDate,
                PolicyTransactionKey = s.PolicyTransactionKey,
                PolicyKey = s.PolicyKey,
                PolicyNo = s.PolicyNo,
                PolicySource = s.PolicySource,
                IssuedDate = s.IssuedDate,
                ProductCode = s.ProductCode,
                PlanCode = s.PlanCode,
                Underwriter = s.Underwriter,
                AgencyKey = s.AgencyKey,
                OutletKey = s.OutletKey,
                AgencyCode = s.AgencyCode,
                AgencyName = s.AgencyName,
                AgencySuperGroupName = s.AgencySuperGroupName,
                AgencyGroupName = s.AgencyGroupName,
                AgencySubGroupName = s.AgencySubGroupName,
                AgencyGroupState = s.AgencyGroupState,
                NumberOfCharged = s.NumberOfCharged,
                NumberOfAdults = s.NumberOfAdults,
                NumberOfChildren = s.NumberOfChildren,
                NumberOfPersons = s.NumberOfPersons,
                DepartureDate = s.DepartureDate,
                ReturnDate = s.ReturnDate,
                NumberOfDays = s.NumberOfDays,
                Area = s.Area,
                AreaType = s.AreaType,
                Destination = s.Destination,
                TripCost = s.TripCost,
                CancellationCoverValue = s.CancellationCoverValue,
                CancellationPremium = s.CancellationPremium,
                Excess = s.Excess,
                NameKey = s.NameKey,
                Title = s.Title,
                FirstName = s.FirstName,
                Surname = s.Surname,
                DOB = s.DOB,
                BusinessName = s.BusinessName,
                IsGroupPolicy = s.IsGroupPolicy,
                IsLuggageClaim = s.IsLuggageClaim,
                IsHighRisk = s.IsHighRisk,
                IsOnlineClaim = s.IsOnlineClaim,
                IsPotentialRecovery = s.IsPotentialRecovery,
                IsFinalised = s.IsFinalised,
                OnlineAlpha = s.OnlineAlpha,
                OnlineConsultant = s.OnlineConsultant,
                EventKey = s.EventKey,
                EventID = s.EventID,
                CustomerCareID = s.CustomerCareID,
                EventDate = s.EventDate,
                EventDescription = s.EventDescription,
                CatastropheCode = s.CatastropheCode,
                Catastrophe = s.Catastrophe,
                EventCountryCode = s.EventCountryCode,
                EventCountryName = s.EventCountryName,
                PerilCode = s.PerilCode,
                Peril = s.Peril,
                SectionID = s.SectionID,
                SectionCode = s.SectionCode,
                Benefit = s.Benefit,
                BenefitCategory = s.BenefitCategory,
                EstimateValue = s.EstimateValue,
                RecoveryEstimateValue = s.RecoveryEstimateValue,
                FirstEstimateDate = s.FirstEstimateDate,
                FirstEstimateCreator = s.FirstEstimateCreator,
                FirstEstimateValue = s.FirstEstimateValue,
                FirstNilEstimateDate = s.FirstNilEstimateDate,
                FirstNilEstimateCreator = s.FirstNilEstimateCreator,
                FirstPayment = s.FirstPayment,
                LastPayment = s.LastPayment,
                PaidPayment = s.PaidPayment,
                RecoveredPayment = s.RecoveredPayment,
                PaidRecoveredPayment = s.PaidRecoveredPayment,
                ClaimValue = s.ClaimValue,
                ApprovedPayment = s.ApprovedPayment,
                PendingApprovalPayment = s.PendingApprovalPayment,
                FailedPayment = s.FailedPayment,
                StoppedPayment = s.StoppedPayment,
                DeclinedPayment = s.DeclinedPayment,
                RejectedPayment = s.RejectedPayment,
                PendingAuthorityPayment = s.PendingAuthorityPayment,
                CancelledPayment = s.CancelledPayment,
                ReturnedPayment = s.ReturnedPayment,
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                CountryKey,
                ClaimKey,
                ClaimNo,
                CreateDate,
                ReceivedDate,
                FinalisedDate,
                PolicyTransactionKey,
                PolicyKey,
                PolicyNo,
                PolicySource,
                IssuedDate,
                ProductCode,
                PlanCode,
                Underwriter,
                AgencyKey,
                OutletKey,
                AgencyCode,
                AgencyName,
                AgencySuperGroupName,
                AgencyGroupName,
                AgencySubGroupName,
                AgencyGroupState,
                NumberOfCharged,
                NumberOfAdults,
                NumberOfChildren,
                NumberOfPersons,
                DepartureDate,
                ReturnDate,
                NumberOfDays,
                Area,
                AreaType,
                Destination,
                TripCost,
                CancellationCoverValue,
                CancellationPremium,
                Excess,
                NameKey,
                Title,
                FirstName,
                Surname,
                DOB,
                BusinessName,
                IsGroupPolicy,
                IsLuggageClaim,
                IsHighRisk,
                IsOnlineClaim,
                IsPotentialRecovery,
                IsFinalised,
                OnlineAlpha,
                OnlineConsultant,
                EventKey,
                EventID,
                CustomerCareID,
                EventDate,
                EventDescription,
                CatastropheCode,
                Catastrophe,
                EventCountryCode,
                EventCountryName,
                PerilCode,
                Peril,
                SectionKey,
                SectionID,
                SectionCode,
                Benefit,
                BenefitCategory,
                EstimateValue,
                RecoveryEstimateValue,
                FirstEstimateDate,
                FirstEstimateCreator,
                FirstEstimateValue,
                FirstNilEstimateDate,
                FirstNilEstimateCreator,
                FirstPayment,
                LastPayment,
                PaidPayment,
                RecoveredPayment,
                PaidRecoveredPayment,
                ClaimValue,
                ApprovedPayment,
                PendingApprovalPayment,
                FailedPayment,
                StoppedPayment,
                DeclinedPayment,
                RejectedPayment,
                PendingAuthorityPayment,
                CancelledPayment,
                ReturnedPayment,
                CreateBatchID
            )
            values
            (
                s.CountryKey,
                s.ClaimKey,
                s.ClaimNo,
                s.CreateDate,
                s.ReceivedDate,
                s.FinalisedDate,
                s.PolicyTransactionKey,
                s.PolicyKey,
                s.PolicyNo,
                s.PolicySource,
                s.IssuedDate,
                s.ProductCode,
                s.PlanCode,
                s.Underwriter,
                s.AgencyKey,
                s.OutletKey,
                s.AgencyCode,
                s.AgencyName,
                s.AgencySuperGroupName,
                s.AgencyGroupName,
                s.AgencySubGroupName,
                s.AgencyGroupState,
                s.NumberOfCharged,
                s.NumberOfAdults,
                s.NumberOfChildren,
                s.NumberOfPersons,
                s.DepartureDate,
                s.ReturnDate,
                s.NumberOfDays,
                s.Area,
                s.AreaType,
                s.Destination,
                s.TripCost,
                s.CancellationCoverValue,
                s.CancellationPremium,
                s.Excess,
                s.NameKey,
                s.Title,
                s.FirstName,
                s.Surname,
                s.DOB,
                s.BusinessName,
                s.IsGroupPolicy,
                s.IsLuggageClaim,
                s.IsHighRisk,
                s.IsOnlineClaim,
                s.IsPotentialRecovery,
                s.IsFinalised,
                s.OnlineAlpha,
                s.OnlineConsultant,
                s.EventKey,
                s.EventID,
                s.CustomerCareID,
                s.EventDate,
                s.EventDescription,
                s.CatastropheCode,
                s.Catastrophe,
                s.EventCountryCode,
                s.EventCountryName,
                s.PerilCode,
                s.Peril,
                s.SectionKey,
                s.SectionID,
                s.SectionCode,
                s.Benefit,
                s.BenefitCategory,
                s.EstimateValue,
                s.RecoveryEstimateValue,
                s.FirstEstimateDate,
                s.FirstEstimateCreator,
                s.FirstEstimateValue,
                s.FirstNilEstimateDate,
                s.FirstNilEstimateCreator,
                s.FirstPayment,
                s.LastPayment,
                s.PaidPayment,
                s.RecoveredPayment,
                s.PaidRecoveredPayment,
                s.ClaimValue,
                s.ApprovedPayment,
                s.PendingApprovalPayment,
                s.FailedPayment,
                s.StoppedPayment,
                s.DeclinedPayment,
                s.RejectedPayment,
                s.PendingAuthorityPayment,
                s.CancelledPayment,
                s.ReturnedPayment,
                @batchid
            )

        output $action into @mergeoutput
        ;


        if @batchid <> -1
        begin

            select
                @insertcount =
                    sum(
                        case
                            when MergeAction = 'insert' then 1
                            else 0
                        end
                    ),
                @updatecount =
                    sum(
                        case
                            when MergeAction = 'update' then 1
                            else 0
                        end
                    )
            from
                @mergeoutput

            exec syssp_genericerrorhandler
                @LogToTable = 1,
                @ErrorCode = '0',
                @BatchID = @batchid,
                @PackageID = @name,
                @LogStatus = 'Finished',
                @LogSourceCount = @sourcecount,
                @LogInsertCount = @insertcount,
                @LogUpdateCount = @updatecount

        end

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        exec syssp_genericerrorhandler
            @SourceInfo = 'clmClaimSummary data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end
GO
