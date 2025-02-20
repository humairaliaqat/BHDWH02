USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL032_factPolicyTransaction]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_ETL032_factPolicyTransaction] 
    @DateRange varchar(30),
    @StartDate varchar(10),
    @EndDate varchar(10)
    
as
begin
/************************************************************************************************************************************
Author:         Linus Tor
Date:           20131115
Prerequisite:   Requires Penguin Data Model ETL successfully run.
                Requires [db-au-cba].dbo.penPolicyTransSummary table available
Description:    factPolicyTransaction dimension table contains Policy attributes.
Parameters:     @DateRange:     Required. Standard date range or _User Defined
                @StartDate:     Required if _User Defined. Format YYYY-MM-DD eg. 2013-01-01
                @EndDate:       Required if _User Defined. Format YYYY-MM-DD eg. 2013-01-01
Change History:
                20131115 - LT - Procedure created
                20140827 - LT - Changed TransactionNumber to varchar(50)
                20140828 - LT - Changed penPayment left join to outer apply join with selec top 1. Removed pts.PolicyTransactionKey <> 'AU-CM7-2540646' filter
                20140905 - LS - refactoring
                                load missing consultant, replacing aggresive load
                                add auto identity, ease up delete process removing the need to physically re-sort data
                20150204 - LS - replace batch codes with standard batch logging
                20151001 - LS - do not include partial day data
                20180412 - LL - materialise addons
                20180413 - LL - materialise some derived columns in vfactPolicyTransaction
                20180418 - LL - materialise additional date sks
                20180419 - LL - prepare many to many bridge for policy addons dimension
                20190411 - LL - fix null IssueDateSK (remove time)

*************************************************************************************************************************************/

--uncomment to debug
/*
declare @DateRange varchar(30)
declare @StartDate varchar(10)
declare @EndDate varchar(10)
select 
    @DateRange = '_User Defined', 
    @StartDate = '2011-07-01', 
    @EndDate = '2011-07-01'
*/

    set nocount on

    declare
        @batchid int,
        @start date,
        @end date,
        @rptStartDate date,
        @rptEndDate date,
        @name varchar(50),
        @sourcecount int,
        @insertcount int,
        @updatecount int

    declare @mergeoutput table (MergeAction varchar(20))

    select
        @name = object_name(@@procid)

    begin try
    
        --check if this is running on batch

        exec syssp_getrunningbatch
            @SubjectArea = 'Policy Star',
            @BatchID = @batchid out,
            @StartDate = @start out,
            @EndDate = @end out

        exec syssp_genericerrorhandler
            @LogToTable = 1,
            @ErrorCode = '0',
            @BatchID = @batchid,
            @PackageID = @name,
            @LogStatus = 'Running'

        select 
            @rptStartDate = @start, 
            @rptEndDate = @end

    end try
    
    begin catch
    
        --or manually
    
        set @batchid = -1

        --get date range
        if @DateRange = '_User Defined'
            select 
                @rptStartDate = @StartDate, 
                @rptEndDate = @EndDate
        else
            select 
                @rptStartDate = StartDate,
                @rptEndDate = EndDate
            from 
                [db-au-cba].dbo.vDateRange
            where 
                DateRange = @DateRange

    end catch


    if object_id('[db-au-stage].dbo.etl_factPolicyTransactionTemp') is not null 
        drop table [db-au-stage].dbo.etl_factPolicyTransactionTemp
        
    select
        pts.CountryKey as Country,
        pts.OutletAlphaKey,
        pol.AlphaCode,
        pol.DomainID,
        pol.PolicyKey,
        pol.PolicyNumber,
        case 
            when pol.CountryKey = 'AU' and pol.AreaType = 'Domestic (Inbound)' then 'Australia Inbound'
            when pol.CountryKey = 'NZ' and pol.AreaType = 'Domestic (Inbound)' then 'New Zealand Inbound'
            when pol.CountryKey = 'NZ' and pol.AreaType = 'Domestic' and pol.AreaName like 'New Zealand%' then 'New Zealand'
            when pol.CountryKey = 'MY' and pol.AreaType = 'Domestic' and pol.AreaName = 'Domestic' then 'Malaysia'
            when pol.CountryKey = 'UK' and pol.AreaType = 'Domestic' and pol.AreaName = 'Domestic Dummy' then 'United Kingdom'
            else pol.AreaName
        end as AreaName,
        pol.AreaType,
        pol.PrimaryCountry,
        promo.PromoKey as PromotionKey,
        pay.PaymentKey,
        isnull(pol.CountryKey,'') + '-' + isnull(pol.CompanyKey,'') + '' + convert(varchar,isnull(pol.DomainID,0)) + '-' + isnull(pol.ProductCode,'') + '-' + isnull(pol.ProductName,'') + '-' + isnull(pol.ProductDisplayName,'') + '-' + isnull(pp.PlanName,isnull(pol.PlanDisplayName,'')) as ProductKey,
        pol.ProductCode,
        pol.ProductName,
        pol.ProductDisplayName,
        pol.PlanID,
        pol.PlanName,
        pol.PlanDisplayName,
        pol.TripDuration,
        pol.CancellationCover,
        pol.TripType,
        pol.isCancellation,
        poltrav.PolicyTravellerKey,
        poltrav.Age,
        pts.UserKey,
        u.UserName,
        pts.ConsultantID,
        pts.IssueDate,
        convert(date,pts.PostingDate) as PostingDate,
        pts.PaymentDate,
        pts.PolicyTransactionKey,
        pts.PolicyNumber as TransactionNumber,
        pts.TransactionType,
        pts.TransactionStatus,
        case 
            when pts.isExpo = 1 then 'Y' 
            else 'N' 
        end as isExpo,
        case 
            when pts.isPriceBeat = 1 then 'Y' 
            else 'N' 
        end as isPriceBeat,
        case 
            when pts.isAgentSpecial = 1 then 'Y' 
            else 'N' 
        end as isAgentSpecial,
        pts.NoOfBonusDaysApplied as BonusDays,
        case 
            when pts.isClientCall = 1 then 'Y' 
            else 'N' 
        end as isClientCall,
        pts.AllocationNumber,
        isnull(pts.RiskNet,0) RiskNet,
        (pts.GrossPremium - pts.TaxAmountSD - pts.TaxAmountGST) as Premium,
        pts.UnAdjGrossPremium as BookPremium,
        pts.GrossPremium as SellPrice,
        pts.AdjustedNet as NetPrice,
        pts.TaxAmountSD as PremiumSD,
        pts.TaxAmountGST as PremiumGST,
        pts.Commission,
        pts.TaxOnAgentCommissionSD as CommissionSD,
        pts.TaxOnAgentCommissionGST as CommissionGST,
        (pts.UnAdjGrossPremium - pts.GrossPremium) as PremiumDiscount,
        pts.GrossAdminFee as AdminFee,
        (pts.Commission + pts.GrossAdminFee) as AgentPremium,
        pts.UnadjGrossPremium as UnadjustedSellPrice,
        pts.UnadjAdjustedNet as UnadjustedNetPrice,
        pts.UnadjCommission as UnadjustedCommission,
        pts.UnadjGrossAdminFee as UnadjustedAdminFee,
        pts.BasePolicyCount as PolicyCount,
        pts.AddonPolicyCount,
        pts.ExtensionPolicyCount,
        --pts.CancelledPolicyCount,
		Case when pol.StatusCode=2 and pts.TransactionStatusID <> 1  then 1 else 0 end as PreCancelledPolicyCount,--Added for CHGXXXX
		Case when pts.TransactionStatusID <> 1 then 1 else 0 end as CancelledTransactionCount,--Added for CHGXXXX
        pts.CancelledAddonPolicyCount,
        pts.CANXPolicyCount,
        pts.DomesticPolicyCount,
        pts.InternationalPolicyCount,
        pts.InboundPolicyCount,
        pts.TravellersCount,
        pts.AdultsCount,
        pts.ChildrenCount,
        pts.ChargedAdultsCount,
        pts.DomesticTravellersCount,
        pts.DomesticAdultsCount,
        pts.DomesticChildrenCount,
        pts.DomesticChargedAdultsCount,
        pts.InboundTravellersCount,
        pts.InboundAdultsCount,
        pts.InboundChildrenCount,
        pts.InboundChargedAdultsCount,
        pts.InternationalTravellersCount,
        pts.InternationalAdultsCount,
        pts.InternationalChildrenCount,
        pts.InternationalChargedAdultsCount,
        pts.LuggageCount,
        pts.MedicalCount,
        pts.MotorcycleCount,
        pts.RentalCarCount,
        pts.WintersportCount,
        pts.AttachmentCount,
        pts.EMCCount,
        pts.CRMUserName,
        isnull
        (
            rtrim(
                (
                    select distinct
                        pta.AddonGroup + '|'
                    from
                        [db-au-cba]..penPolicyTransAddOn pta with(nolock)
                    where
                        pta.PolicyTransactionKey = pts.PolicyTransactionKey
                    order by 1
                    for xml path('')
                )
            ),
            'No Addon'
        ) AddonGroups
    into [db-au-stage].dbo.etl_factPolicyTransactionTemp
    from
        [db-au-cba].dbo.penPolicyTransSummary pts
        left join [db-au-cba].dbo.penPolicy pol on
            pts.PolicyKey = pol.PolicyKey
        outer apply
        (
            select top 1
                poltrav.PolicyTravellerKey,
                poltrav.Age
            from
                [db-au-cba].dbo.penPolicyTraveller poltrav
            where
                pol.PolicyKey = poltrav.PolicyKey and
                poltrav.isPrimary = 1
        ) poltrav
        outer apply
        (
            select top 1 
                isnull([Login], 'UNKNOWN') as UserName 
            from 
                [db-au-cba].dbo.penUser 
            where 
                UserKey = pts.UserKey
        ) u
        outer apply
        (
            select top 1
                promo.PromoKey
            from
                [db-au-cba].dbo.penPolicyTransactionPromo promo
            where
                pts.PolicyTransactionKey = promo.PolicyTransactionKey and
                promo.isApplied = 1
        ) promo
        outer apply
        (
            select top 1 
                PaymentKey
            from 
                [db-au-cba].dbo.penPayment
            where 
                PolicyTransactionKey = pts.PolicyTransactionKey
        ) pay
        outer apply
        (
            select top 1 
                pp.PlanName
            from 
                [db-au-cba].dbo.penProductPlan pp
            where
                pol.CountryKey = pp.CountryKey and
                pol.CompanyKey = pp.CompanyKey and
                pol.ProductID = pp.ProductID and
                pol.UniquePLanID = pp.UniquePLanID
        ) pp
    where
        pts.PostingDate >= @rptStartDate and 
        pts.PostingDate <  dateadd(day, 1, @rptEndDate) and
        pts.PostingDate <  convert(date, getdate()) --do not include partial day data


    --addons bridge
    if object_id('[db-au-star].dbo.dimAddonGroup') is null
    begin

        create table [db-au-star].dbo.dimAddonGroup
        (
            AddonGroupSK bigint not null identity(1,1),
            AddonGroup varchar(100)
        )

        create unique clustered index cidx_dimAddonGroup on [db-au-star].dbo.dimAddonGroup (AddonGroupSK)
        create unique nonclustered index idx_dimAddonGroup_AddonGroup on [db-au-star].dbo.dimAddonGroup (AddonGroup) include (AddonGroupSK)

        insert into [db-au-star].dbo.dimAddonGroup (AddonGroup) values ('No Addon')

    end

    insert into [db-au-star].dbo.dimAddonGroup
    (
        AddonGroup
    )
    select distinct
        ltrim(rtrim(AddonGroup))
    from
        [db-au-cba].dbo.penPolicyTransAddon t
    where
        not exists
        (
            select 
                null
            from
                [db-au-star].dbo.dimAddonGroup r
            where
                r.AddonGroup = t.AddonGroup 
        )

    if object_id('[db-au-star].dbo.dimAddonGroups') is null
    begin

        create table [db-au-star].dbo.dimAddonGroups
        (
            AddonGroupsSK bigint not null identity(1,1),
            AddonGroups varchar(max)
        )

        create unique clustered index cidx_dimAddonGroups on [db-au-star].dbo.dimAddonGroups (AddonGroupsSK)
        --create unique nonclustered index idx_dimAddonGroups_AddonGroups on [db-au-star].dbo.dimAddonGroups (AddonGroups) include (AddonGroupsSK)

        insert into [db-au-star].dbo.dimAddonGroups (AddonGroups) values ('No Addon|')

    end

    insert into [db-au-star].dbo.dimAddonGroups
    (
        AddonGroups
    )
    select distinct
        AddonGroups
    from
        [db-au-stage].dbo.etl_factPolicyTransactionTemp t
    where
        not exists
        (
            select
                null
            from
                [db-au-star].dbo.dimAddonGroups r 
            where
                r.AddonGroups = t.AddonGroups
        )

    --load missing consultant, replacing aggresive load on dimConsultant
    insert [db-au-star]..dimConsultant with(tablock)
    (
        Country,
        ConsultantKey,
        OutletAlphaKey,
        Firstname,
        Lastname,
        ConsultantName,
        UserName,
        ASICNumber,
        AgreementDate,
        [Status],
        InactiveDate,
        RefereeName,
        AccreditationDate,
        DeclaredDate,
        PreviouslyKnownAs,
        YearsOfExperience,
        DateOfBirth,
        ASICCheck,
        Email,
        FirstSellDate,
        LastSellDate,
        LoadDate,
        updateDate,
        LoadID,
        UpdateID,
        HashKey
    )
    select distinct
        Country,
        tt.ConsultantKey,
        tt.OutletAlphaKey,
        tt.FirstName,
        tt.LastName,
        tt.ConsultantName,
        tt.UserName,
        0 ASICNumber,
        null AgreementDate,
        'UNKNOWN' [Status],
        null InactiveDate,
        '' RefereeName,
        null AccreditationDate,
        null DeclaredDate,
        '' PreviouslyKnownAs,
        '' YearsOfExperience,
        null DateOfBirth,
        '' ASICCheck,
        '' Email,
        null FirstSellDate,
        null LastSellDate,
        getdate() LoadDate,
        null UpdateDate,
        @batchid LoadID,
        null updateID,
        binary_checksum(
            Country, 
            tt.ConsultantKey,
            tt.OutletAlphaKey,
            tt.FirstName,
            tt.LastName,
            tt.ConsultantName,
            tt.UserName,
            0,
            null,
            '',
            null,
            '',
            null,
            null,
            '',
            '',
            null,
            '',
            '',
            null,
            null
        ) HashKey
    from
        [db-au-stage].dbo.etl_factPolicyTransactionTemp t
        outer apply
        (
            select top 1
                crm.FirstName,
                crm.LastName,
                crm.FirstName + ' ' + crm.LastName ConsultantName
            from
                [db-au-cba]..penCRMUser crm
            where
                crm.UserName = t.CRMUserName
        ) crm
        outer apply
        (
            select
                Country + isnull(AlphaCode, '') + isnull(convert(varchar, ConsultantID), isnull(CRMUserName, '')) ConsultantKey,
                isnull(OutletAlphaKey, Country + isnull(AlphaCode, '')) OutletAlphaKey,
                isnull(crm.FirstName, isnull(convert(varchar, ConsultantID), isnull(CRMUserName, 'UNKNOWN'))) FirstName,
                isnull(crm.LastName, isnull(convert(varchar, ConsultantID), isnull(CRMUserName, 'UNKNOWN'))) LastName,
                isnull(crm.ConsultantName, isnull(convert(varchar, ConsultantID), isnull(CRMUserName, 'UNKNOWN'))) ConsultantName,
                isnull(convert(varchar, ConsultantID), isnull(CRMUserName, '')) UserName
        ) tt
    where
        not exists
        (
            select null
            from
                [db-au-star].dbo.dimConsultant con
            where
                con.ConsultantKey = t.UserKey or
                con.ConsultantKey = tt.ConsultantKey
        ) 

    if object_id('[db-au-stage].dbo.etl_factPolicyTransaction') is not null 
        drop table [db-au-stage].dbo.etl_factPolicyTransaction
        
    select
        dt.Date_SK as DateSK,
        isnull(dom.DomainSK,-1) as DomainSK,
        isnull(o.OutletSK,-1) as OutletSK,
        isnull(pol.PolicySK,-1) as PolicySK,
        isnull(con.ConsultantSK, isnull(dcon.ConsultantSK, -1)) as ConsultantSK,
        isnull(pay.PaymentSK,-1) as PaymentSK,
        isnull(area.AreaSK,-1) as AreaSK,
        isnull(dest.DestinationSK,-1) as DestinationSK,
        isnull(duration.DurationSK,-1) as DurationSK,
        isnull(product.ProductSK,-1) as ProductSK,
        isnull(age.AgeBandSK,-1) as AgeBandSK,
        isnull(promo.PromotionSK,-1) as PromotionSK,
        isnull(tts.TransactionTypeStatusSK, -1) TransactionTypeStatusSK,
        pts.IssueDate,
        pts.PostingDate,
        pts.PolicyTransactionKey,
        pts.TransactionNumber,
        pts.TransactionType,
        pts.TransactionStatus,
        pts.isExpo,
        pts.isPriceBeat,
        pts.isAgentSpecial,
        pts.BonusDays,
        pts.isClientCall,
        pts.AllocationNumber,
        pts.RiskNet,
        pts.Premium,
        pts.BookPremium,
        pts.SellPrice,
        pts.NetPrice,
        pts.PremiumSD,
        pts.PremiumGST,
        pts.Commission,
        pts.CommissionSD,
        pts.CommissionGST,
        pts.PremiumDiscount,
        pts.AdminFee,
        pts.AgentPremium,
        pts.UnadjustedSellPrice,
        pts.UnadjustedNetPrice,
        pts.UnadjustedCommission,
        pts.UnadjustedAdminFee,
        pts.PolicyCount,
        pts.AddonPolicyCount,
        pts.ExtensionPolicyCount,
        --pts.CancelledPolicyCount,
		case when pts.PreCancelledPolicyCount =1 and row_number() over (partition by pts.PreCancelledPolicyCount,pol.policysk order by pts.TransactionNumber)=1 then 1 else 0 end as CancelledPolicyCount, --Added for ChangeXXXX
		pts.CancelledTransactionCount,--Added for ChangeXXXX
        pts.CancelledAddonPolicyCount,
        pts.CANXPolicyCount,
        pts.DomesticPolicyCount,
        pts.InternationalPolicyCount,
        pts.InboundPolicyCount,
        pts.TravellersCount,
        pts.AdultsCount,
        pts.ChildrenCount,
        pts.ChargedAdultsCount,
        pts.DomesticTravellersCount,
        pts.DomesticAdultsCount,
        pts.DomesticChildrenCount,
        pts.DomesticChargedAdultsCount,
        pts.InboundTravellersCount,
        pts.InboundAdultsCount,
        pts.InboundChildrenCount,
        pts.InboundChargedAdultsCount,
        pts.InternationalTravellersCount,
        pts.InternationalAdultsCount,
        pts.InternationalChildrenCount,
        pts.InternationalChargedAdultsCount,
        pts.LuggageCount,
        pts.MedicalCount,
        pts.MotorcycleCount,
        pts.RentalCarCount,
        pts.WintersportCount,
        pts.AttachmentCount,
        pts.EMCCount,
        pol.LeadTime,
        pol.Duration,
        pol.CancellationCover,
        pol.PolicyIssueDate,
        pol.DepartureDate,
        pol.ReturnDate,
        pol.UnderwriterCode,
        (
            select
                r.DateSK
            from
                [db-au-star]..v_ic_dimGeneralDate r
            where
                r.DateSK = convert(date, pol.DepartureDate)
        ) DepartureDateSK,
        (
            select
                r.DateSK
            from
                [db-au-star]..v_ic_dimGeneralDate r
            where
                r.DateSK = convert(date, pol.ReturnDate)
        ) ReturnDateSK,
        (
            select
                r.DateSK
            from
                [db-au-star]..v_ic_dimGeneralDate r
            where
                r.DateSK = convert(date, pol.PolicyIssueDate)
        ) IssueDateSK,
        pts.AddonGroups
    into [db-au-stage].dbo.etl_factPolicyTransaction
    from
        [db-au-stage].dbo.etl_factPolicyTransactionTemp pts
        cross apply
        (
            select 
                Country + isnull(AlphaCode, '') + isnull(convert(varchar, ConsultantID), isnull(CRMUserName, '')) DerivedConsultantKey
        ) dc
        outer apply
        (
            select top 1
                dt.Date_SK
            from
                [db-au-star].dbo.Dim_Date dt
            where
                pts.PostingDate = dt.[Date]
        ) dt
        outer apply
        (
            select top 1
                o.OutletSK
            from
                [db-au-star].dbo.dimOutlet o
            where
                o.OutletAlphaKey = isnull(pts.OutletAlphaKey,'') and
                pts.PostingDate >= o.ValidStartDate and 
                pts.PostingDate <  dateadd(day, 1, o.ValidEndDate)
        ) o
        outer apply
        (
            select top 1
                dom.DomainSK
            from
                [db-au-star].dbo.dimDomain dom
            where
                pts.DomainID = dom.DomainID
        ) dom
        outer apply
        (
            select top 1
                p.PolicySK,
                case
                    when datediff([day], p.issuedate, p.tripstart) < -1 then -1
                    when datediff([day], p.issuedate, p.tripstart) > 2000 then -1
                    else isnull(datediff([day], p.issuedate, p.tripstart), -1)
                end LeadTime,
                datediff([day], p.tripstart, p.tripend) + 1 Duration,
                convert(money, isnull(p.CancellationCover, 0)) CancellationCover,
                p.IssueDate PolicyIssueDate,
                p.TripStart DepartureDate,
                p.TripEnd ReturnDate,
                isnull(p.Underwriter, 'OTHER') UnderwriterCode
            from 
                [db-au-star].dbo.dimPolicy p
            where
                pts.PolicyKey = p.PolicyKey
        ) pol
        outer apply
        (
            select top 1
                con.ConsultantSK
            from
                [db-au-star].dbo.dimConsultant con
            where
                pts.UserKey = con.ConsultantKey
        ) con
        outer apply
        (
            select top 1
                con.ConsultantSK
            from
                [db-au-star].dbo.dimConsultant con
            where
                con.ConsultantKey = dc.DerivedConsultantKey
        ) dcon
        outer apply
        (
            select top 1 
                pay.PaymentSK
            from 
                [db-au-star].dbo.dimPayment pay
            where
                pay.Country = pts.Country and
                pay.PolicyTransactionKey = pts.PolicyTransactionKey
        ) pay
        outer apply
        (
            select top 1
                area.AreaSK
            from
                [db-au-star].dbo.dimArea area
            where
                pts.Country = area.Country and
                pts.AreaName = area.AreaName and
                pts.AreaType = area.AreaType
        ) area
        outer apply
        (
            select top 1
                dest.DestinationSK
            from
                [db-au-star].dbo.dimDestination dest
            where
                pts.PrimaryCountry = dest.Destination
            order by
                dest.DestinationSK desc
        ) dest
        outer apply
        (
            select top 1
                duration.DurationSK
            from
                [db-au-star].dbo.dimDuration duration
            where
                pts.TripDuration = duration.Duration
        ) duration
        outer apply
        (
            select top 1
                product.ProductSK
            from
                [db-au-star].dbo.dimProduct product
            where
                pts.ProductKey = product.ProductKey
        ) product
        outer apply
        (
            select top 1
                age.AgeBandSK
            from
                [db-au-star].dbo.dimAgeBand age
            where
                pts.Age = age.Age
        ) age
        outer apply
        (
            select top 1
                promo.PromotionSK
            from
                [db-au-star].dbo.dimPromotion promo
            where
                pts.PromotionKey = promo.PromotionKey
        ) promo
        outer apply
        (
            select top 1 
                tts.TransactionTypeStatusSK
            from
                [db-au-star].dbo.dimTransactionTypeStatus tts
            where
                tts.TransactionType = pts.TransactionType and
                tts.TransactionStatus = pts.TransactionStatus
        ) tts

    --create factPolicyTransaction if table does not exist
    if object_id('[db-au-star].dbo.factPolicyTransaction') is null
    begin
    
        create table [db-au-star].dbo.factPolicyTransaction
        (
            BIRowID bigint not null identity(1,1),
            DateSK int not null,
            DomainSK int not null,
            OutletSK int not null,
            PolicySK int not null,
            ConsultantSK int not null,
            PaymentSK int not null,
            AreaSK int not null,
            DestinationSK int not null,
            DurationSK int not null,
            ProductSK int not null,
            AgeBandSK int not null,
            PromotionSK int not null,
            IssueDate datetime null,
            PostingDate datetime null,
            PolicyTransactionKey nvarchar(50) null,
            TransactionNumber varchar(50) null,
            TransactionType nvarchar(50) null,
            TransactionStatus nvarchar(50) null,
            isExpo nvarchar(1) null,
            isPriceBeat nvarchar(1) null,
            isAgentSpecial nvarchar(1) null,
            BonusDays int null,
            isClientCall nvarchar(1) null,
            AllocationNumber int null,
            RiskNet float null,
            Premium float null,
            BookPremium float null,
            SellPrice float null,
            NetPrice float null,
            PremiumSD float null,
            PremiumGST float null,
            Commission float null,
            CommissionSD float null,
            CommissionGST float null,
            PremiumDiscount float null,
            AdminFee float null,
            AgentPremium float null,
            UnadjustedSellPrice float null,
            UnadjustedNetPrice float null,
            UnadjustedCommission float null,
            UnadjustedAdminFee float null,
            PolicyCount int null,
            AddonPolicyCount int null,
            ExtensionPolicyCount int null,
            CancelledPolicyCount int null,
			CancelledTransactionCount int null, --Added for ChangeXXXX
            CancelledAddonPolicyCount int null,
            CANXPolicyCount int null,
            DomesticPolicyCount int null,
            InternationalPolicyCount int null,
            InboundPolicyCount int null,
            TravellersCount int null,
            AdultsCount int null,
            ChildrenCount int null,
            ChargedAdultsCount int null,
            DomesticTravellersCount int null,
            DomesticAdultsCount int null,
            DomesticChildrenCount int null,
            DomesticChargedAdultsCount int null,
            InboundTravellersCount int null,
            InboundAdultsCount int null,
            InboundChildrenCount int null,
            InboundChargedAdultsCount int null,
            InternationalTravellersCount int null,
            InternationalAdultsCount int null,
            InternationalChildrenCount int null,
            InternationalChargedAdultsCount int null,
            LuggageCount int null,
            MedicalCount int null,
            MotorcycleCount int null,
            RentalCarCount int null,
            WintersportCount int null,
            AttachmentCount int null,
            EMCCount int null,
            LoadDate datetime not null,
            LoadID int not null,
            updateDate datetime null,
            updateID int null,
            LeadTime int,
            Duration int,
            CancellationCover money,
            PolicyIssueDate date,
            DepartureDate date,
            ReturnDate date,
            UnderwriterCode varchar(100),
            TransactionTypeStatusSK bigint,
            DepartureDateSK date,
            ReturnDateSK date,
            IssueDateSK date

        )
        
        create clustered index idx_factPolicyTransaction_BIRowID on [db-au-star].dbo.factPolicyTransaction(BIRowID)
        create nonclustered index idx_factPolicyTransaction_DateSK on [db-au-star].dbo.factPolicyTransaction(DateSK,OutletSK) include (DomainSK,Premium,Commission,PolicyCount)
        create nonclustered index idx_factPolicyTransaction_DomainSK on [db-au-star].dbo.factPolicyTransaction(DomainSK)
        create nonclustered index idx_factPolicyTransaction_OutletSK on [db-au-star].dbo.factPolicyTransaction(OutletSK)
        create nonclustered index idx_factPolicyTransaction_PolicySK on [db-au-star].dbo.factPolicyTransaction(PolicySK)
        create nonclustered index idx_factPolicyTransaction_ConsultantSK on [db-au-star].dbo.factPolicyTransaction(ConsultantSK) include(OutletSK,DateSK)
        create nonclustered index idx_factPolicyTransaction_PaymentSK on [db-au-star].dbo.factPolicyTransaction(PaymentSK)
        create nonclustered index idx_factPolicyTransaction_AreaSK on [db-au-star].dbo.factPolicyTransaction(AreaSK)
        create nonclustered index idx_factPolicyTransaction_DestinationSK on [db-au-star].dbo.factPolicyTransaction(DestinationSK)
        create nonclustered index idx_factPolicyTransaction_DurationSK on [db-au-star].dbo.factPolicyTransaction(DurationSK)
        create nonclustered index idx_factPolicyTransaction_ProductSK on [db-au-star].dbo.factPolicyTransaction(ProductSK)
        create nonclustered index idx_factPolicyTransaction_AgeBandSK on [db-au-star].dbo.factPolicyTransaction(AgeBandSK)
        create nonclustered index idx_factPolicyTransaction_PromotionSK on [db-au-star].dbo.factPolicyTransaction(PromotionSK)
        create nonclustered index idx_factPolicyTransaction_IssueDate on [db-au-star].dbo.factPolicyTransaction(IssueDate)
        create nonclustered index idx_factPolicyTransaction_PostingDate on [db-au-star].dbo.factPolicyTransaction(PostingDate)

    end
    

    select
        @sourcecount = count(*)
    from
        [db-au-stage].dbo.etl_factPolicyTransaction

    begin transaction
    begin try
    
        delete [db-au-star].dbo.factPolicyTransaction
        from
            [db-au-star].dbo.factPolicyTransaction b
            join [db-au-stage].dbo.etl_factPolicyTransaction a on
                b.DateSK = a.DateSK and
                b.DomainSK = a.DomainSK

        insert into [db-au-star].dbo.factPolicyTransaction with (tablockx)
        (
            DateSK,
            DomainSK,
            OutletSK,
            PolicySK,
            ConsultantSK,
            PaymentSK,
            AreaSK,
            DestinationSK,
            DurationSK,
            ProductSK,
            AgeBandSK,
            PromotionSK,
            TransactionTypeStatusSK,
            IssueDate,
            PostingDate,
            PolicyTransactionKey,
            TransactionNumber,
            TransactionType,
            TransactionStatus,
            isExpo,
            isPriceBeat,
            isAgentSpecial,
            BonusDays,
            isClientCall,
            AllocationNumber,
            RiskNet,
            Premium,
            BookPremium,
            SellPrice,
            NetPrice,
            PremiumSD,
            PremiumGST,
            Commission,
            CommissionSD,
            CommissionGST,
            PremiumDiscount,
            AdminFee,
            AgentPremium,
            UnadjustedSellPrice,
            UnadjustedNetPrice,
            UnadjustedCommission,
            UnadjustedAdminFee,
            PolicyCount,
            AddonPolicyCount,
            ExtensionPolicyCount,
            CancelledPolicyCount,
			CancelledTransactionCount, --Added for ChangeXXXX
            CancelledAddonPolicyCount,
            CANXPolicyCount,
            DomesticPolicyCount,
            InternationalPolicyCount,
            InboundPolicyCount,
            TravellersCount,
            AdultsCount,
            ChildrenCount,
            ChargedAdultsCount,
            DomesticTravellersCount,
            DomesticAdultsCount,
            DomesticChildrenCount,
            DomesticChargedAdultsCount,
            InboundTravellersCount,
            InboundAdultsCount,
            InboundChildrenCount,
            InboundChargedAdultsCount,
            InternationalTravellersCount,
            InternationalAdultsCount,
            InternationalChildrenCount,
            InternationalChargedAdultsCount,
            LuggageCount,
            MedicalCount,
            MotorcycleCount,
            RentalCarCount,
            WintersportCount,
            AttachmentCount,
            EMCCount,
            LoadDate,
            LoadID,
            updateDate,
            updateID,
            LeadTime,
            Duration,
            CancellationCover,
            PolicyIssueDate,
            DepartureDate,
            ReturnDate,
            UnderwriterCode,
            DepartureDateSK,
            ReturnDateSK,
            IssueDateSK
        )
        select
            DateSK,
            DomainSK,
            OutletSK,
            PolicySK,
            ConsultantSK,
            PaymentSK,
            AreaSK,
            DestinationSK,
            DurationSK,
            ProductSK,
            AgeBandSK,
            PromotionSK,
            TransactionTypeStatusSK,
            IssueDate,
            PostingDate,
            PolicyTransactionKey,
            TransactionNumber,
            TransactionType,
            TransactionStatus,
            isExpo,
            isPriceBeat,
            isAgentSpecial,
            BonusDays,
            isClientCall,
            AllocationNumber,
            RiskNet,
            Premium,
            BookPremium,
            SellPrice,
            NetPrice,
            PremiumSD,
            PremiumGST,
            Commission,
            CommissionSD,
            CommissionGST,
            PremiumDiscount,
            AdminFee,
            AgentPremium,
            UnadjustedSellPrice,
            UnadjustedNetPrice,
            UnadjustedCommission,
            UnadjustedAdminFee,
            PolicyCount,
            AddonPolicyCount,
            ExtensionPolicyCount,
            CancelledPolicyCount,
			CancelledTransactionCount, --Added for ChangeXXXX
            CancelledAddonPolicyCount,
            CANXPolicyCount,
            DomesticPolicyCount,
            InternationalPolicyCount,
            InboundPolicyCount,
            TravellersCount,
            AdultsCount,
            ChildrenCount,
            ChargedAdultsCount,
            DomesticTravellersCount,
            DomesticAdultsCount,
            DomesticChildrenCount,
            DomesticChargedAdultsCount,
            InboundTravellersCount,
            InboundAdultsCount,
            InboundChildrenCount,
            InboundChargedAdultsCount,
            InternationalTravellersCount,
            InternationalAdultsCount,
            InternationalChildrenCount,
            InternationalChargedAdultsCount,
            LuggageCount,
            MedicalCount,
            MotorcycleCount,
            RentalCarCount,
            WintersportCount,
            AttachmentCount,
            EMCCount,
            getdate() as LoadDate,
            @batchid as LoadID,
            null as updateDate,
            null as updateID,
            LeadTime,
            Duration,
            CancellationCover,
            PolicyIssueDate,
            DepartureDate,
            ReturnDate,
            UnderwriterCode,
            DepartureDateSK,
            ReturnDateSK,
            IssueDateSK
        from
            [db-au-stage].dbo.etl_factPolicyTransaction




                
        if @batchid <> - 1
            exec syssp_genericerrorhandler
                @LogToTable = 1,
                @ErrorCode = '0',
                @BatchID = @batchid,
                @PackageID = @name,
                @LogStatus = 'Finished',
                @LogSourceCount = @sourcecount

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        if @batchid <> - 1
            exec syssp_genericerrorhandler
                @SourceInfo = 'data refresh failed',
                @LogToTable = 1,
                @ErrorCode = '-100',
                @BatchID = @batchid,
                @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction


    --addons

    --create factPolicyTransactionAddons if table does not exist
    if object_id('[db-au-star].dbo.factPolicyTransactionAddons') is null
    begin
    
        create table [db-au-star].dbo.factPolicyTransactionAddons
        (
            BIRowID bigint not null identity(1,1),
            DateSK int not null,
            DomainSK int not null,
            OutletSK int not null,
            PolicySK int not null,
            ConsultantSK int not null,
            AreaSK int not null,
            DestinationSK int not null,
            DurationSK int not null,
            ProductSK int not null,
            AgeBandSK int not null,
            PromotionSK int not null,
            LeadTime int not null,
            PolicyIssueDate date,
            DepartureDate date,
            ReturnDate date,
            UnderwriterCode varchar(100),
            PolicyTransactionKey nvarchar(50) null,
            AddonGroup nvarchar(50) not null,
            AddonCount int,
            SellPrice decimal(15,2),
            UnadjustedSellPrice decimal(15,2),
            DepartureDateSK date,
            ReturnDateSK date,
            IssueDateSK date
        )
        
        create clustered index idx_factPolicyTransactionAddons_BIRowID on [db-au-star].dbo.factPolicyTransactionAddons(BIRowID)
        create nonclustered index idx_factPolicyTransactionAddons_PolicySK on [db-au-star].dbo.factPolicyTransactionAddons(PolicySK,AddonGroup) include (AddonCount,SellPrice,UnadjustedSellPrice)
        create nonclustered index idx_factPolicyTransactionAddons_AddonGroup on [db-au-star].dbo.factPolicyTransactionAddons(AddonGroup) include (PolicySK,AddonCount,SellPrice,UnadjustedSellPrice)
        create nonclustered index idx_factPolicyTransactionAddons_DateSK on [db-au-star].dbo.factPolicyTransactionAddons(DateSK,DomainSK)
        create nonclustered index idx_factPolicyTransactionAddons_PolicyTransactionKey on [db-au-star].dbo.factPolicyTransactionAddons(PolicyTransactionKey)

    end

    begin transaction
    begin try
    
        delete b
        from
            [db-au-star].dbo.factPolicyTransactionAddons b
        where
            b.DateSK in 
            (
                select
                    DateSK
                from
                    [db-au-stage].dbo.etl_factPolicyTransaction
            ) and
            b.DomainSK in
            (
                select
                    DomainSK
                from
                    [db-au-stage].dbo.etl_factPolicyTransaction
            )

        insert into [db-au-star].dbo.factPolicyTransactionAddons with(tablock)
        (
            DateSK,
            DomainSK,
            OutletSK,
            PolicySK,
            ConsultantSK,
            AreaSK,
            DestinationSK,
            DurationSK,
            ProductSK,
            AgeBandSK,
            PromotionSK ,
            LeadTime,
            PolicyIssueDate,
            DepartureDate,
            ReturnDate,
            UnderwriterCode,
            PolicyTransactionKey,
            AddonGroup,
            AddonCount,
            SellPrice,
            UnadjustedSellPrice,
            DepartureDateSK,
            ReturnDateSK,
            IssueDateSK
        )
        select 
            pt.DateSK,
            pt.DomainSK,
            pt.OutletSK,
            pt.PolicySK,
            pt.ConsultantSK,
            pt.AreaSK,
            pt.DestinationSK,
            pt.DurationSK,
            pt.ProductSK,
            pt.AgeBandSK,
            pt.PromotionSK ,
            case
                when datediff([day], p.issuedate, p.tripstart) < -1 then -1
                when datediff([day], p.issuedate, p.tripstart) > 2000 then -1
                else isnull(datediff([day], p.issuedate, p.tripstart), -1)
            end LeadTime,
            p.IssueDate PolicyIssueDate,
            p.TripStart DepartureDate,
            p.TripEnd ReturnDate,
            isnull(p.Underwriter, 'OTHER') UnderwriterCode,
            pt.PolicyTransactionKey,
            isnull(pta.AddonGroup, 'No Addon') AddonGroup,
            isnull(pt.PolicyCount + pt.AddonPolicyCount, 0) AddonCount,
            isnull(pta.GrossPremium, 0) SellPrice,
            isnull(pta.UnAdjGrossPremium, 0) UnadjustedSellPrice,
            pt.DepartureDateSK,
            pt.ReturnDateSK,
            pt.IssueDateSK
        from
            [db-au-stage].dbo.etl_factPolicyTransaction pt
            inner join [db-au-star].dbo.dimPolicy p with(nolock) on
                p.PolicySK = pt.PolicySK
            left join [db-au-cba]..penPolicyTransAddOn pta with(nolock) on
                pt.PolicyTransactionKey = pta.PolicyTransactionKey

    end try

    begin catch

        if @@trancount > 0
            rollback transaction

        if @batchid <> - 1
            exec syssp_genericerrorhandler
                @SourceInfo = 'data refresh failed',
                @LogToTable = 1,
                @ErrorCode = '-100',
                @BatchID = @batchid,
                @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction


    --n to n bridge
    --if object_id('[db-au-star].dbo.dimPolicyAddonsGroup') is null
    --begin

    --    create table [db-au-star].dbo.dimPolicyAddonsGroup
    --    (
    --        PolicyAddonsGroupSK bigint not null identity(1,1),
    --        PolicySK bigint,
    --        AddonsGroup varchar(max)
    --    )

    --    create unique clustered index cidx_dimPolicyAddonsGroup on [db-au-star].dbo.dimPolicyAddonsGroup (PolicyAddonsGroupSK)
    --    create unique nonclustered index idx_dimPolicyAddonsGroup_PolicySK on [db-au-star].dbo.dimPolicyAddonsGroup (PolicySK) include (AddonsGroup)

    --end

    --delete 
    --from
    --    [db-au-star].dbo.dimPolicyAddonsGroup
    --where
    --    PolicySK in
    --    (
    --        select
    --            PolicySK
    --        from
    --            [db-au-stage].dbo.etl_factPolicyTransaction
    --    )

    --insert into [db-au-star].dbo.dimPolicyAddonsGroup
    --(
    --    PolicySK,
    --    AddonsGroup
    --)
    --select 
    --    dp.PolicySK,
    --    isnull
    --    (
    --        rtrim(
    --            (
    --                select distinct
    --                    pta.AddonGroup + '| '
    --                from
    --                    [db-au-star].dbo.factPolicyTransactionAddons pta with(nolock)
    --                where
    --                    pta.PolicySK = dp.PolicySK
    --                order by 1
    --                for xml path('')
    --            )
    --        ),
    --        'No Addon'
    --    ) AddonGroup
    --from
    --    [db-au-star].dbo.dimPolicy dp
    --where
    --    dp.PolicySK in
    --    (
    --        select 
    --            pt.PolicySK
    --        from
    --            [db-au-stage].dbo.etl_factPolicyTransaction pt
    --    )

end

GO
