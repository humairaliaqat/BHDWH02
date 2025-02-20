USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penPolicyTransSummary_BKP20240229]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_cmdwh_penPolicyTransSummary_BKP20240229]
    @Country varchar(10) = 'AUNZSGMY',  --Required. AUNZSGMY or UK or US
    @ReportingPeriod varchar(30),       --Required. Default value 'Last 30 Days'
    @StartDate date,                    --Optional. Format YYYY-MM-DD
    @EndDate date                       --Optional. Format YYYY-MM-DD

as
begin


/************************************************************************************************************************************
Author:         Linus Tor
Date:           20120209
Prerequisite:   Requires Penguin ETL successfully transferred from  Penguin production database,
                and etlsp_cmdwh_penPolicyTransPricing successfully run.
Description:    This procedure selects the whole of policy transaction table, and adds summarised policy transaction and traveller transaction columns
                - penPolicyTransSummary: aggregate associated policy transaction components to the PolicyTransactionKey level.
                - penTravellerTransSummary: aggregate associate traveller transaction components to the TravellerTransactionKey level.

                NOTE: penPolicyTransSummary excludes "Edit Traveller Detail" type transactions. Therefore it will contain less records than penPolicyTransactions

Change History:
                20120210 - LT - Procedure created
                20120608 - LT - Amended AdjustedNet and UnadjustedNet columns to (GrossPremium - Commission - AdminFee)
                20120625 - LS - Add OutletAlphaKey & OutletSKey
                20120629 - LS - Add other metrics, optimize code
                20120701 - LS - optimize run time
                20120724 - LS - Add additional fields
                20120815 - LS - Add IssueTime
                20121101 - LS - Add ExternalReference
                                Add Unadjusted Taxes
                20121107 - LS - refactoring & domain related changes
                20121129 - LS - add currency code & symbol
                20130424 - LS - add YAGOIssueDate
                20130728 - LT - Add Country parameter to cater for UK ETL.
                                Include Country filter in etl_penPolicyTransaction query
                20130731 - LS - Set default value for Country
                20130820 - LT - Added new count metrics:
                                    InboundPolicyCount
                                    InboundTravellersCount
                                    InboundAdultsCount
                                    InboundChildrenCount
                                    InboundChargedAdultsCount
                                Changed CANXPolicyCount metric to use penPolicy.isCancellation flag
                20130827 - LS - Populate payment date based on last allocation (monthly processed allocations don't have payment date)
                20130905 - LS - add import date
                20130930 - LS - add IPT as GST type (UK issue)
                20131010 - LT - amended SinglefamilyFlag calculation for AAA single/duo/family flag
                20131111 - LS - add PostingDate
                                logic:
                                equals to IssueDate when there's no ImportDate
                                equals to ImportDate when ImportDate exists
                                this logic will be replaced with creation timestamp, need to confirm with dev team on past data treatment
                20131127 - LS - Penguin 7.8, change PostingDate to TransactionDateTime if it's not null (new records)
                20131204 - LS - case 19524, stamp duty & gst bug, use new pricing calculation
                                include TransactionDateTime in 'to process selection'
                20131231 - LS - add YAGOPostingDate
                20140128 - LS - case 20020, out of sync summary roll up, fix: check existence of global temp table
                20140201 - LS - add PostingTime
                                change PostingDate
                                logic:
                                equals to TransactionDateTime if it's after 01/12/2013
                                else equals to ImportDate when ImportDate exists
                                else equals to IssueDate
                20140209 - LT - changed Policy Count metrics to use Base policy. Will need to update Universes to reflect this change
                20140220 - LS - case 19851, add competitor data
                20140320 - LS - case 20561, the fix on 20020 doesn't work all the time (e.g. UK)
                                this is due to the global temporary table usage, changing this to a disk table
                20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                20140617 - LS - TFS 12416, schema and index cleanup
                20140714 - LS - F 21325, data can be 'missing' while this etl runs
                                temporary workaround:
                                    move deletion closer to insert
                                    create temp table to store transformation so delay between delete and insert is more instantaneous
                                this will be redone using upsert later on
                20140715 - LS - F 21325, use transaction, other session will not see data gets deleted until after it's replaced (intraday refresh)
                20140725 - LS - sas data verification, fix variation count for standalone variation transactions
                                by logic a transaction can never be Base & Variation at the same time thus the count will be using Base + Variation count
                                this logic is tested against production where no data having (Base + Variation) > 1
                20140805 - LT - TFS 13021, changed PolicyNumber from bigint to varchar(50), changed PolicyNoKey from varchar(41) to varchar(100)
                20141216 - LS - P11.5, username from 50 to 100 nvarchar
                20150227 - LS - F23236, add CanxCover with the integer value of TripCost
                                update penPolicy CancellationCover & TripCost to be the sum of all transactional CanxCover
                20150808 - LS - TFS 15452, add PaymentMode & PointsRedeemed\
				20151027 - DM - Penguin v16 release, Added column GigyaID to Summary
				20160321 - LT - Penguin 18.0, added US Penguin instance
                20160504 - LS - Handle FC US TripCost
                20161021 - LS - Penguin 2x.? IssuingConsultantID
                                Penguin 21.5 LeadTimeDate
				20170105 - LT - Increased the following columns to numeric(15,9):
									[CommissionRatePolicyPrice] 
									[DiscountRatePolicyPrice] 
									[CommissionRateTravellerPrice] 
									[DiscountRateTravellerPrice] 
									[CommissionRateTravellerAddOnPrice] 
									[DiscountRateTravellerAddOnPrice] 
									[CommissionRateEMCPrice] 
									[DiscountRateEMCPrice] 
									[UnAdjBasePremium] money null,
									[UnAdjGrossPremium] money null,
									[UnAdjCommission] money null,
									[UnAdjDiscountPolicyTrans] money null,
									[UnAdjGrossAdminFee] money null,
									[UnAdjAdjustedNet] money null,
									[UnAdjCommissionRatePolicyPrice] 
									[UnAdjDiscountRatePolicyPrice] 
									[UnAdjCommissionRateTravellerPrice] 
									[UnAdjDiscountRateTravellerPrice] 
									[UnAdjCommissionRateTravellerAddOnPrice] 
									[UnAdjDiscountRateTravellerAddOnPrice] 
									[UnAdjCommissionRateEMCPrice] 
									[UnAdjDiscountRateEMCPrice] 
                20170509 - LL - moved update block out of transaction block
                                try_convert on FC US canx value, somehow the code failed there
				20181024 - LT - Penguin 32.0, added RefundTransactionID, RefundTransactionKey columns
				20190319 - RS - Increased width of ExternalReference column from 50 to 100

*************************************************************************************************************************************/

--uncomment to debug
/*
declare @Country varchar(10)
declare @ReportingPeriod varchar(30)
declare @StartDate date
declare @EndDate date
select
    @Country = 'AUNZSGMY',
    @ReportingPeriod = '_User Defined',
    @StartDate = '2018-09-01',
    @EndDate = '2018-09-30'
*/

    set nocount on

    /* get dates */
    if @ReportingPeriod <> '_User Defined'
        select
            @StartDate = StartDate,
            @EndDate = EndDate
        from
            [db-au-cba].dbo.vDateRange
        where
            DateRange = @ReportingPeriod

    /* prepare temporary tables */
    if object_id('etl_penPolicyTrans') is not null
        drop table etl_penPolicyTrans

    if object_id('etl_penPolicyCounts') is not null
        drop table etl_penPolicyCounts

    if object_id('etl_penPolicyAddOns') is not null
        drop table etl_penPolicyAddOns

    if object_id('etl_penPolicyTransMetrics') is not null
        drop table etl_penPolicyTransMetrics

    --populate temp table with country values
    if object_id('tempdb..#Country') is null
        create table #Country (Country varchar(2) null)
    else
        truncate table #Country

    insert #Country values('AU')


    /* synced rollup */
    if object_id('etl_penPolicyTransaction_sync') is null
        create table etl_penPolicyTransaction_sync
        (
            PolicyTransactionKey varchar(41) null
        )

    if exists (select null from etl_penPolicyTransaction_sync where PolicyTransactionKey is not null)
    begin

        select
            pt.*
        into
            etl_penPolicyTrans
        from
            [db-au-cba].dbo.penPolicyTransaction pt
        where
            pt.PolicyTransactionKey in
            (
                select
                    PolicyTransactionKey
                from
                    etl_penPolicyTransaction_sync
            )

        truncate table etl_penPolicyTransaction_sync

    end

    else
    /* dump records in date range */
    begin

        select *
        into
            etl_penPolicyTrans
        from
            [db-au-cba].dbo.penPolicyTransaction pt
        where
            CountryKey collate database_default in (select Country from #Country) AND
            (
                (
                    pt.IssueDate >= @StartDate and
                    pt.IssueDate <  dateadd(day, 1, @EndDate)
                ) or
                (
                    pt.PaymentDate >= @StartDate and
                    pt.PaymentDate <  dateadd(day, 1, @EndDate)
                ) or
                (
                    TransactionDateTime >= @StartDate and
                    TransactionDateTime <  dateadd(day, 1, @EndDate)
                )
            )

    end

    create clustered index idx on etl_penPolicyTrans(PolicyTransactionKey)

    if object_id('[db-au-cba].dbo.penPolicyTransSummary') is null
    begin

        create table [db-au-cba].dbo.[penPolicyTransSummary]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [PolicyTransactionKey] varchar(41) not null,
            [PolicyKey] varchar(41) null,
            [PolicyNoKey] varchar(100) null,
            [UserKey] varchar(41) null,
            [UserSKey] bigint null,
            [PolicyTransactionID] int not null,
            [PolicyID] int not null,
            [PolicyNumber] varchar(50) null,
            [TransactionTypeID] int not null,
            [TransactionType] varchar(50) null,
            [IssueDate] date not null,
            [AccountingPeriod] datetime not null,
            [CRMUserID] int null,
            [CRMUserName] nvarchar(100) null,
            [TransactionStatusID] int not null,
            [TransactionStatus] nvarchar(50) null,
            [Transferred] bit not null,
            [UserComments] nvarchar(1000) null,
            [CommissionTier] varchar(50) null,
            [VolumeCommission] numeric(18,9) null,
            [Discount] numeric(18,9) null,
            [isExpo] bit not null,
            [isPriceBeat] bit not null,
            [NoOfBonusDaysApplied] int null,
            [isAgentSpecial] bit not null,
            [ParentID] int null,
            [ConsultantID] int null,
            [isClientCall] bit null,
            [RiskNet] money null,
            [AutoComments] nvarchar(2000) null,
            [TripCost] nvarchar(50) null,
            [AllocationNumber] int null,
            [PaymentDate] datetime null,
            [TransactionStart] datetime null,
            [TransactionEnd] datetime null,
            [TaxAmountSD] money null,
            [TaxOnAgentCommissionSD] money null,
            [TaxAmountGST] money null,
            [TaxOnAgentCommissionGST] money null,
            [BasePremium] money null,
            [GrossPremium] money null,
            [Commission] money null,
            [DiscountPolicyTrans] money null,
            [GrossAdminFee] money null,
            [AdjustedNet] money null,
            [CommissionRatePolicyPrice] numeric(15,9) null,
            [DiscountRatePolicyPrice] numeric(15,9) null,
            [CommissionRateTravellerPrice] numeric(15,9) null,
            [DiscountRateTravellerPrice] numeric(15,9) null,
            [CommissionRateTravellerAddOnPrice] numeric(15,9) null,
            [DiscountRateTravellerAddOnPrice] numeric(15,9) null,
            [CommissionRateEMCPrice] numeric(15,9) null,
            [DiscountRateEMCPrice] numeric(15,9) null,
            [UnAdjBasePremium] money null,
            [UnAdjGrossPremium] money null,
            [UnAdjCommission] money null,
            [UnAdjDiscountPolicyTrans] money null,
            [UnAdjGrossAdminFee] money null,
            [UnAdjAdjustedNet] money null,
            [UnAdjCommissionRatePolicyPrice] numeric(15,9) null,
            [UnAdjDiscountRatePolicyPrice] numeric(15,9) null,
            [UnAdjCommissionRateTravellerPrice] numeric(15,9) null,
            [UnAdjDiscountRateTravellerPrice] numeric(15,9) null,
            [UnAdjCommissionRateTravellerAddOnPrice] numeric(15,9) null,
            [UnAdjDiscountRateTravellerAddOnPrice] numeric(15,9) null,
            [UnAdjCommissionRateEMCPrice] numeric(15,9) null,
            [UnAdjDiscountRateEMCPrice] numeric(15,9) null,
            [StoreCode] varchar(10) null,
            [OutletAlphaKey] nvarchar(50) null,
            [OutletSKey] bigint null,
            [NewPolicyCount] int not null default ((0)),
            [BasePolicyCount] int not null default ((0)),
            [AddonPolicyCount] int not null default ((0)),
            [ExtensionPolicyCount] int not null default ((0)),
            [CancelledPolicyCount] int not null default ((0)),
            [CancelledAddonPolicyCount] int not null default ((0)),
            [CANXPolicyCount] int not null default ((0)),
            [DomesticPolicyCount] int not null default ((0)),
            [InternationalPolicyCount] int not null default ((0)),
            [TravellersCount] int not null default ((0)),
            [AdultsCount] int not null default ((0)),
            [ChildrenCount] int not null default ((0)),
            [ChargedAdultsCount] int not null default ((0)),
            [DomesticTravellersCount] int not null default ((0)),
            [DomesticAdultsCount] int not null default ((0)),
            [DomesticChildrenCount] int not null default ((0)),
            [DomesticChargedAdultsCount] int not null default ((0)),
            [InternationalTravellersCount] int not null default ((0)),
            [InternationalAdultsCount] int not null default ((0)),
            [InternationalChildrenCount] int not null default ((0)),
            [InternationalChargedAdultsCount] int not null default ((0)),
            [NumberofDays] int not null default ((0)),
            [LuggageCount] int not null default ((0)),
            [MedicalCount] int not null default ((0)),
            [MotorcycleCount] int not null default ((0)),
            [RentalCarCount] int not null default ((0)),
            [WintersportCount] int not null default ((0)),
            [AttachmentCount] int not null default ((0)),
            [EMCCount] int not null default ((0)),
            [InternationalNewPolicyCount] int not null default ((0)),
            [InternationalCANXPolicyCount] int not null default ((0)),
            [ProductCode] nvarchar(50) null,
            [PurchasePath] nvarchar(50) null,
            [SingleFamilyFlag] int null,
            [isAMT] bit null,
            [IssueTime] datetime null,
            [ExternalReference] nvarchar(100) null,
            [UnAdjTaxAmountSD] money null,
            [UnAdjTaxOnAgentCommissionSD] money null,
            [UnAdjTaxAmountGST] money null,
            [UnAdjTaxOnAgentCommissionGST] money null,
            [DomainKey] varchar(41) null,
            [DomainID] int null,
            [IssueTimeUTC] datetime null,
            [PaymentDateUTC] datetime null,
            [TransactionStartUTC] datetime null,
            [TransactionEndUTC] datetime null,
            [CurrencyCode] varchar(3) null,
            [CurrencySymbol] varchar(10) null,
            [YAGOIssueDate] date null,
            [InboundPolicyCount] int not null default ((0)),
            [InboundTravellersCount] int not null default ((0)),
            [InboundAdultsCount] int not null default ((0)),
            [InboundChildrenCount] int not null default ((0)),
            [InboundChargedAdultsCount] int not null default ((0)),
            [ImportDate] datetime null,
            [PostingDate] datetime null,
            [YAGOPostingDate] date null,
            [PostingTime] datetime null,
            [CompetitorName] nvarchar(50) null,
            [CompetitorPrice] money null,
            [CanxCover] int null,
            [PaymentMode] nvarchar(20) null,
            [PointsRedeemed] money null,
			[GigyaId] nvarchar(300) null,
            [IssuingConsultantID] int null,
            [LeadTimeDate] date null,
			[RefundTransactionID] int null,
			[RefundTransactionKey] varchar(41) null
        )

        create clustered index idx_penPolicyTransSummary_IssueDate on [db-au-cba].dbo.penPolicyTransSummary(IssueDate)
        create nonclustered index idx_penPolicyTransSummary_AccountingPeriod on [db-au-cba].dbo.penPolicyTransSummary(OutletAlphaKey,AccountingPeriod,PaymentDate) include (GrossPremium,Commission,GrossAdminFee,PolicyTransactionKey,AllocationNumber)
        create nonclustered index idx_penPolicyTransSummary_Competitor on [db-au-cba].dbo.penPolicyTransSummary(CompetitorName) include (PolicyTransactionKey,CompetitorPrice)
        create nonclustered index idx_penPolicyTransSummary_ExternalReference on [db-au-cba].dbo.penPolicyTransSummary(ExternalReference)
        create nonclustered index idx_penPolicyTransSummary_ImportDate on [db-au-cba].dbo.penPolicyTransSummary(ImportDate) include (PolicyNumber,IssueDate,GrossPremium,OutletAlphaKey)
        create nonclustered index idx_penPolicyTransSummary_OutletAlphaKey on [db-au-cba].dbo.penPolicyTransSummary(OutletAlphaKey,PaymentDate) include (PolicyTransactionKey,IssueDate,PostingDate,AccountingPeriod,GrossPremium,Commission,GrossAdminFee)
        create nonclustered index idx_penPolicyTransSummary_OutletSKey on [db-au-cba].dbo.penPolicyTransSummary(OutletSKey)
        create nonclustered index idx_penPolicyTransSummary_PaymentDate on [db-au-cba].dbo.penPolicyTransSummary(PaymentDate,IssueDate)
        create nonclustered index idx_penPolicyTransSummary_PolicyKey on [db-au-cba].dbo.penPolicyTransSummary(PolicyKey) include (PolicyTransactionKey,PolicyTransactionID,TransactionStatus,ParentID)
        create nonclustered index idx_penPolicyTransSummary_PolicyNumber on [db-au-cba].dbo.penPolicyTransSummary(PolicyNumber,CountryKey) include (PolicyTransactionKey,OutletAlphaKey)
        create nonclustered index idx_penPolicyTransSummary_PolicyTransactionKey on [db-au-cba].dbo.penPolicyTransSummary(PolicyTransactionKey) include (IssueDate,PostingDate,PolicyKey,PolicyNumber,ParentID,OutletAlphaKey,UnAdjGrossPremium,UnAdjTaxAmountGST,UnAdjTaxAmountSD,UnAdjCommission,UnAdjGrossAdminFee,UnAdjTaxOnAgentCommissionGST,UnAdjTaxOnAgentCommissionSD,GrossPremium,TaxAmountGST,TaxAmountSD,Commission,GrossAdminFee,TaxOnAgentCommissionGST,TaxOnAgentCommissionSD,RiskNet)
        create nonclustered index idx_penPolicyTransSummary_PostingDate on [db-au-cba].dbo.penPolicyTransSummary(PostingDate,OutletAlphaKey) include (PolicyTransactionKey,IssueDate,PolicyKey,UserKey)
        create nonclustered index idx_penPolicyTransSummary_UserKey on [db-au-cba].dbo.penPolicyTransSummary(UserKey) include (IssueDate)
        create nonclustered index idx_penPolicyTransSummary_YAGOIssueDate on [db-au-cba].dbo.penPolicyTransSummary(YAGOIssueDate)
        create nonclustered index idx_penPolicyTransSummary_YAGOPostingDate on [db-au-cba].dbo.penPolicyTransSummary(YAGOPostingDate,OutletAlphaKey) include (PolicyTransactionKey,YAGOIssueDate,PolicyKey,UserKey)

    end


    /* calculate policy counts */
    select
        pt.PolicyTransactionKey,
        pt.PolicyKey,
        case
            when pt.TransactionType = 'Base' and pt.TransactionStatus = 'Active' then 1
            when pt.TransactionType = 'Base' and pt.TransactionStatus like 'Cancelled%' then -1
            else 0
        end NewPolicyCount,
        case
            when pt.TransactionType = 'Base' and pt.TransactionStatus = 'Active' then 1
            when pt.TransactionType = 'Base' and pt.TransactionStatus like 'Cancelled%' then -1
            else 0
        end BasePolicyCount,
        case
            when pt.TransactionType = 'Variation' and pt.TransactionStatus = 'Active' then 1
            when pt.TransactionType = 'Variation' and pt.TransactionStatus like 'Cancelled%' then -1
            else 0
        end AddonPolicyCount,
        case
            when pt.TransactionType in ('Extend', 'Upgrade AMT Max Trip Duration') and pt.TransactionStatus = 'Active' then 1
            when pt.TransactionType in ('Extend', 'Upgrade AMT Max Trip Duration') and pt.TransactionStatus like 'Cancelled%' then -1
            else 0
        end ExtensionPolicyCount,
        --LT: is 'Upgrade AMT Max Trip Duration' considered an extension?
        --LS: this was inline with legacy TRIPS data push that maps 'Upgrade AMT Max Trip Duration' to policy type E,
        --    no further business rules to supplant this defined as yet
        case
            when pt.TransactionType = 'Base' and pt.TransactionStatus like 'Cancelled%' then 1
            else 0
        end CancelledPolicyCount,
        case
            when pt.TransactionType = 'Variation' and pt.TransactionStatus like 'Cancelled%' then 1
            else 0
        end CancelledAddonPolicyCount,
        case
            when
                pt.TransactionType = 'Base' and
                p.isCancellation = 1 and
                pt.TransactionStatus = 'Active'
                then 1
            when
                pt.TransactionType = 'Base' and
                p.isCancellation = 1 and
                pt.TransactionStatus like 'Cancelled%'
                then -1
            else 0
        end CANXPolicyCount,
        case
            when
                pt.TransactionType = 'Base' and
                p.AreaType = 'Domestic' and
                pt.TransactionStatus = 'Active'
                then 1
            when
                pt.TransactionType = 'Base' and
                p.AreaType = 'Domestic' and
                pt.TransactionStatus like 'Cancelled%'
                then -1
            else 0
        end DomesticPolicyCount,
        case
            when
                pt.TransactionType = 'Base' and
                p.AreaType = 'Domestic (Inbound)' and
                pt.TransactionStatus = 'Active'
                then 1
            when
                pt.TransactionType = 'Base' and
                p.AreaType = 'Domestic (Inbound)' and
                pt.TransactionStatus like 'Cancelled%'
                then -1
            else 0
        end InboundPolicyCount,
        case
            when
                pt.TransactionType = 'Base' and
                p.AreaType = 'International' and
                pt.TransactionStatus = 'Active'
                then 1
            when
                pt.TransactionType = 'Base' and
                p.AreaType = 'International' and
                pt.TransactionStatus like 'Cancelled%'
                then -1
            else 0
        end InternationalPolicyCount,
        case
            when pt.TransactionType = 'Base' and pt.TransactionStatus = 'Active' then ptv.TravellerCount
            when pt.TransactionType = 'Base' and pt.TransactionStatus like 'Cancelled%' then -ptv.TravellerCount
            else 0
        end TravellersCount,
        case
            when pt.TransactionType = 'Base' and pt.TransactionStatus = 'Active' then ptv.AdultCount
            when pt.TransactionType = 'Base' and pt.TransactionStatus like 'Cancelled%' then -ptv.AdultCount
            else 0
        end AdultsCount,
        case
            when pt.TransactionType = 'Base' and pt.TransactionStatus = 'Active' then ptv.ChildrenCount
            when pt.TransactionType = 'Base' and pt.TransactionStatus like 'Cancelled%' then -ptv.ChildrenCount
            else 0
        end ChildrenCount,
        case
            when pt.TransactionType = 'Base' and pt.TransactionStatus = 'Active' then ptv.AdultChargeCount
            when pt.TransactionType = 'Base' and pt.TransactionStatus like 'Cancelled%' then -ptv.AdultChargeCount
            else 0
        end ChargedAdultsCount,
        case
            when pt.TransactionType = 'Base' and pt.TransactionStatus = 'Active' then p.DaysCovered
            when pt.TransactionType = 'Base' and pt.TransactionStatus like 'Cancelled%' then -p.DaysCovered
            else 0
        end NumberofDays,
        0 LuggageCount,
        0 MedicalCount,
        0 MotorcycleCount,
        0 RentalCarCount,
        0 WintersportCount,
        0 AttachmentCount,
        0 EMCCount,
        0 InternationalNewPolicyCount,
        0 InternationalCANXPolicyCount
    into etl_penPolicyCounts
    from
        etl_penPolicyTrans pt
        inner join [db-au-cba].dbo.penPolicy p on
            p.PolicyKey = pt.PolicyKey
        outer apply
        (
            select
                count(ptv.PolicyTravellerKey) TravellerCount,
                sum(
                    case
                        when ptv.isAdult = 1 then 1
                        else 0
                    end
                ) AdultCount,
                sum(
                    case
                        when ptv.isAdult = 0 then 1
                        else 0
                    end
                ) ChildrenCount,
                sum(
                    case
                        when ptv.AdultCharge >= 1 then 1
                        else 0
                    end
                ) AdultChargeCount
            from
                [db-au-cba].dbo.penPolicyTraveller ptv
            where
                ptv.PolicyKey = p.PolicyKey
        ) ptv

    /* calculate add-on counts */
    select
        pt.PolicyTransactionKey,
        pa.AddOnGroup
    into etl_penPolicyAddOns
    from
        etl_penPolicyCounts pt
        inner join [db-au-cba].dbo.penPolicyAddOn pa
            on pa.PolicyTransactionKey = pt.PolicyTransactionKey

    union

    select
        pt.PolicyTransactionKey,
        pta.AddOnGroup
    from
        etl_penPolicyCounts pt
        inner join [db-au-cba].dbo.penPolicyTraveller ptv on
            ptv.PolicyKey = pt.PolicyKey
        inner join [db-au-cba].dbo.penPolicyTravellerTransaction ptt on
            ptt.PolicyTransactionKey = pt.PolicyTransactionKey and
            ptt.PolicyTravellerKey = ptv.PolicyTravellerKey
        inner join [db-au-cba].dbo.penPolicyTravellerAddOn pta on
            pta.PolicyTravellerTransactionKey = ptt.PolicyTravellerTransactionKey

    union

    select
        pt.PolicyTransactionKey,
        'Medical' AddOnGroup
    from
        etl_penPolicyCounts pt
        inner join [db-au-cba].dbo.penPolicyTravellerTransaction ptt on
            ptt.PolicyTransactionKey = pt.PolicyTransactionKey
        inner join [db-au-cba].dbo.penPolicyEMC pe on
            pe.PolicyTravellerTransactionKey = ptt.PolicyTravellerTransactionKey

    create clustered index idx on etl_penPolicyAddOns(PolicyTransactionKey, AddOnGroup)

    /* create metrics */
    select
        PolicyTransactionKey,
        NewPolicyCount,
        BasePolicyCount,
        AddonPolicyCount,
        ExtensionPolicyCount,
        CancelledPolicyCount,
        CancelledAddonPolicyCount,
        CANXPolicyCount,
        DomesticPolicyCount,
        InboundPolicyCount,
        InternationalPolicyCount,
        TravellersCount,
        AdultsCount,
        ChildrenCount,
        ChargedAdultsCount,
        DomesticPolicyCount * abs(TravellersCount) DomesticTravellersCount,
        DomesticPolicyCount * abs(AdultsCount) DomesticAdultsCount,
        DomesticPolicyCount * abs(ChildrenCount) DomesticChildrenCount,
        DomesticPolicyCount * abs(ChargedAdultsCount) DomesticChargedAdultsCount,
        InboundPolicyCount * abs(TravellersCount) InboundTravellersCount,
        InboundPolicyCount * abs(AdultsCount) InboundAdultsCount,
        InboundPolicyCount * abs(ChildrenCount) InboundChildrenCount,
        InboundPolicyCount * abs(ChargedAdultsCount) InboundChargedAdultsCount,
        InternationalPolicyCount * abs(TravellersCount) InternationalTravellersCount,
        InternationalPolicyCount * abs(AdultsCount) InternationalAdultsCount,
        InternationalPolicyCount * abs(ChildrenCount) InternationalChildrenCount,
        InternationalPolicyCount * abs(ChargedAdultsCount) InternationalChargedAdultsCount,
        NumberofDays,
        case
            when
                exists
                (
                    select null
                    from  etl_penPolicyAddOns a
                    where
                        a.PolicyTransactionKey = t.PolicyTransactionKey and
                        a.AddOnGroup = 'Luggage'
                )
                then BasePolicyCount + AddonPolicyCount
            else 0
        end LuggageCount,
        case
            when
                exists
                (
                    select null
                    from  etl_penPolicyAddOns a
                    where
                        a.PolicyTransactionKey = t.PolicyTransactionKey and
                        a.AddOnGroup = 'Medical'
                )
                then BasePolicyCount + AddonPolicyCount
            else 0
        end MedicalCount,
        case
            when
                exists
                (
                    select null
                    from  etl_penPolicyAddOns a
                    where
                        a.PolicyTransactionKey = t.PolicyTransactionKey and
                        a.AddOnGroup = 'Motorcycle'
                )
                then BasePolicyCount + AddonPolicyCount
            else 0
        end MotorcycleCount,
        case
            when
                exists
                (
                    select null
                    from  etl_penPolicyAddOns a
                    where
                        a.PolicyTransactionKey = t.PolicyTransactionKey and
                        a.AddOnGroup = 'Rental Car'
                )
                then BasePolicyCount + AddonPolicyCount
            else 0
        end RentalCarCount,
        case
            when
                exists
                (
                    select null
                    from  etl_penPolicyAddOns a
                    where
                        a.PolicyTransactionKey = t.PolicyTransactionKey and
                        a.AddOnGroup = 'Winter Sport'
                )
                then BasePolicyCount + AddonPolicyCount
            else 0
        end WintersportCount,
        case
            when
                exists
                (
                    select null
                    from  etl_penPolicyAddOns a
                    where
                        a.PolicyTransactionKey = t.PolicyTransactionKey and
                        a.AddOnGroup <> 'Cancellation' and
                        a.AddOnGroup is not null
                )
                then BasePolicyCount + AddonPolicyCount
            else 0
        end AttachmentCount,
        case
            when
                exists
                (
                    select null
                    from  etl_penPolicyAddOns a
                    where
                        a.PolicyTransactionKey = t.PolicyTransactionKey and
                        a.AddOnGroup = 'Medical'
                )
                then BasePolicyCount + AddonPolicyCount
            else 0
        end EMCCount,
        case
            when BasePolicyCount <> 0 then InternationalPolicyCount
            else 0
        end InternationalNewPolicyCount,
        case
            when InternationalPolicyCount <> 0 then CANXPolicyCount
            else 0
        end InternationalCANXPolicyCount
    into etl_penPolicyTransMetrics
    from
        etl_penPolicyCounts t

    create clustered index idx on etl_penPolicyTransMetrics(PolicyTransactionKey)

    /* combine summary and metrics, save to table */
    --put in temp table to eliminate lag further between delete and insert
    if object_id('tempdb..#penPolicyTransSummary') is not null
        drop table #penPolicyTransSummary

    select
        pt.CountryKey,
        pt.CompanyKey,
        pt.DomainKey,
        pt.PolicyTransactionKey,
        pt.PolicyKey,
        pt.PolicyNoKey,
        p.OutletAlphaKey,
        p.OutletSKey,
        pt.UserKey,
        pt.UserSKey,
        pt.DomainID,
        pt.PolicyTransactionID,
        pt.PolicyID,
        pt.PolicyNumber,
        p.ExternalReference,
        pt.TransactionTypeID,
        pt.TransactionType,
        convert(date, pt.IssueDate) IssueDate,
        convert(date, dateadd(year, 1, pt.IssueDate)) YAGOIssueDate,
        ppi.ImportDate,
        convert(date, pttm.PostingTime) PostingDate,
        pttm.PostingTime,
        convert(date, dateadd(year, 1, pttm.PostingTime)) YAGOPostingDate,
        pt.IssueDate IssueTime,
        pt.IssueDateUTC IssueTimeUTC,
        pt.AccountingPeriod,
        pt.CRMUserID,
        pt.CRMUserName,
        pt.TransactionStatusID,
        pt.TransactionStatus,
        pt.Transferred,
        pt.UserComments,
        pt.CommissionTier,
        pt.VolumeCommission,
        pt.Discount,
        p.ProductCode,
        p.PurchasePath,
        ppp.SingleFamilyFlag,
        ppp.isAMT,
        pt.isExpo,
        pt.isPriceBeat,
        pt.NoOfBonusDaysApplied,
        pt.isAgentSpecial,
        pt.ParentID,
        pt.ConsultantID,
        pt.isClientCall,
        pt.RiskNet,
        pt.AutoComments,
        pt.TripCost,
        pt.AllocationNumber,
        case
            when pt.AllocationNumber is not null and pt.PaymentDate is null then ppta.PaymentDate
            else pt.PaymentDate
        end PaymentDate,
        pt.TransactionStart,
        pt.TransactionEnd,
        pt.PaymentDateUTC,
        pt.TransactionStartUTC,
        pt.TransactionEndUTC,

        isnull(StampDutyAfterDiscount, 0) TaxAmountSD,
        isnull(CommStampDutyAfterDiscount, 0) TaxOnAgentCommissionSD,
        isnull(GSTAfterDiscount, 0) TaxAmountGST,
        isnull(CommGSTAfterDiscount, 0) TaxOnAgentCommissionGST,
        isnull(BasePremiumAfterDiscount, 0) BasePremium,
        isnull(GrossPremiumAfterDiscount, 0) GrossPremium,
        isnull(CommissionAfterDiscount, 0) Commission,
        isnull(DiscountAfterDiscount, 0) DiscountPolicyTrans,
        isnull(GrossAdminFeeAfterDiscount, 0) GrossAdminFee,
        isnull(GrossPremiumAfterDiscount, 0) - isnull(CommissionAfterDiscount, 0) - isnull(GrossAdminFeeAfterDiscount, 0) AdjustedNet,
        /*not sure what significant values these hold*/
        case
            when isnull(BaseRateCount, 0) = 0 then 0
            else isnull(CommissionRateAfterDiscount, 0) / BaseRateCount
        end CommissionRatePolicyPrice,
        case
            when isnull(BaseRateCount, 0) = 0 then 0
            else isnull(DiscountRateAfterDiscount, 0) / BaseRateCount
        end DiscountRatePolicyPrice,
        case
            when isnull(BaseRateCount, 0) = 0 then 0
            else isnull(CommissionRateAfterDiscount, 0) / BaseRateCount
        end CommissionRateTravellerPrice,
        case
            when isnull(BaseRateCount, 0) = 0 then 0
            else isnull(DiscountRateAfterDiscount, 0) / BaseRateCount
        end DiscountRateTravellerPrice,
        case
            when isnull(BaseRateCount, 0) = 0 then 0
            else isnull(CommissionRateAfterDiscount, 0) / BaseRateCount
        end CommissionRateTravellerAddOnPrice,
        case
            when isnull(BaseRateCount, 0) = 0 then 0
            else isnull(DiscountRateAfterDiscount, 0) / BaseRateCount
        end DiscountRateTravellerAddOnPrice,
        case
            when isnull(EMCRateCount, 0) = 0 then 0
            else isnull(EMCCommissionRateAfterDiscount, 0) / EMCRateCount
        end CommissionRateEMCPrice,
        case
            when isnull(EMCRateCount, 0) = 0 then 0
            else isnull(EMCDiscountRateAfterDiscount, 0) / EMCRateCount
        end DiscountRateEMCPrice,
        /*--*/
        isnull(StampDutyBeforeDiscount, 0) UnAdjTaxAmountSD,
        isnull(CommStampDutyBeforeDiscount, 0) UnAdjTaxOnAgentCommissionSD,
        isnull(GSTBeforeDiscount, 0) UnAdjTaxAmountGST,
        isnull(CommGSTBeforeDiscount, 0) UnAdjTaxOnAgentCommissionGST,
        isnull(BasePremiumBeforeDiscount, 0) UnAdjBasePremium,
        isnull(GrossPremiumBeforeDiscount, 0) UnAdjGrossPremium,
        isnull(CommissionBeforeDiscount, 0) UnAdjCommission,
        isnull(DiscountBeforeDiscount, 0) UnAdjDiscountPolicyTrans,
        isnull(GrossAdminFeeBeforeDiscount, 0) UnAdjGrossAdminFee,
        isnull(GrossPremiumBeforeDiscount, 0) - isnull(CommissionBeforeDiscount, 0) - isnull(GrossAdminFeeBeforeDiscount, 0) UnAdjAdjustedNet,
        case
            when isnull(BaseRateCount, 0) = 0 then 0
            else isnull(CommissionRateBeforeDiscount, 0) / BaseRateCount
        end UnAdjCommissionRatePolicyPrice,
        case
            when isnull(BaseRateCount, 0) = 0 then 0
            else isnull(DiscountRateBeforeDiscount, 0) / BaseRateCount
        end UnAdjDiscountRatePolicyPrice,
        case
            when isnull(BaseRateCount, 0) = 0 then 0
            else isnull(CommissionRateBeforeDiscount, 0) / BaseRateCount
        end UnAdjCommissionRateTravellerPrice,
        case
            when isnull(BaseRateCount, 0) = 0 then 0
            else isnull(DiscountRateBeforeDiscount, 0) / BaseRateCount
        end UnAdjDiscountRateTravellerPrice,
        case
            when isnull(BaseRateCount, 0) = 0 then 0
            else isnull(CommissionRateBeforeDiscount, 0) / BaseRateCount
        end UnAdjCommissionRateTravellerAddOnPrice,
        case
            when isnull(BaseRateCount, 0) = 0 then 0
            else isnull(DiscountRateBeforeDiscount, 0) / BaseRateCount
        end UnAdjDiscountRateTravellerAddOnPrice,
        case
            when isnull(EMCRateCount, 0) = 0 then 0
            else isnull(EMCCommissionRateBeforeDiscount, 0) / EMCRateCount
        end UnAdjCommissionRateEMCPrice,
        case
            when isnull(EMCRateCount, 0) = 0 then 0
            else isnull(EMCDiscountRateBeforeDiscount, 0) / EMCRateCount
        end UnAdjDiscountRateEMCPrice,

        pt.StoreCode,
        isnull(e.NewPolicyCount, 0) NewPolicyCount,
        isnull(e.BasePolicyCount, 0) BasePolicyCount,
        isnull(e.AddonPolicyCount, 0) AddonPolicyCount,
        isnull(e.ExtensionPolicyCount, 0) ExtensionPolicyCount,
        isnull(e.CancelledPolicyCount, 0) CancelledPolicyCount,
        isnull(e.CancelledAddonPolicyCount, 0) CancelledAddonPolicyCount,
        isnull(e.CANXPolicyCount, 0) CANXPolicyCount,
        isnull(e.DomesticPolicyCount, 0) DomesticPolicyCount,
        isnull(e.InternationalPolicyCount, 0) InternationalPolicyCount,
        isnull(e.TravellersCount, 0) TravellersCount,
        isnull(e.AdultsCount, 0) AdultsCount,
        isnull(e.ChildrenCount, 0) ChildrenCount,
        isnull(e.ChargedAdultsCount, 0) ChargedAdultsCount,
        isnull(e.DomesticTravellersCount, 0) DomesticTravellersCount,
        isnull(e.DomesticAdultsCount, 0) DomesticAdultsCount,
        isnull(e.DomesticChildrenCount, 0) DomesticChildrenCount,
        isnull(e.DomesticChargedAdultsCount, 0) DomesticChargedAdultsCount,
        isnull(e.InternationalTravellersCount, 0) InternationalTravellersCount,
        isnull(e.InternationalAdultsCount, 0) InternationalAdultsCount,
        isnull(e.InternationalChildrenCount, 0) InternationalChildrenCount,
        isnull(e.InternationalChargedAdultsCount, 0) InternationalChargedAdultsCount,
        isnull(e.NumberofDays, 0) NumberofDays,
        isnull(e.LuggageCount, 0) LuggageCount,
        isnull(e.MedicalCount, 0) MedicalCount,
        isnull(e.MotorcycleCount, 0) MotorcycleCount,
        isnull(e.RentalCarCount, 0) RentalCarCount,
        isnull(e.WintersportCount, 0) WintersportCount,
        isnull(e.AttachmentCount, 0) AttachmentCount,
        isnull(e.EMCCount, 0) EMCCount,
        isnull(e.InternationalNewPolicyCount, 0) InternationalNewPolicyCount,
        isnull(e.InternationalCANXPolicyCount, 0) InternationalCANXPolicyCount,
        d.CurrencyCode,
        d.CurrencySymbol,
        isnull(e.InboundPolicyCount,0) InboundPolicyCount,
        isnull(e.InboundTravellersCount, 0) InboundTravellersCount,
        isnull(e.InboundAdultsCount, 0) InboundAdultsCount,
        isnull(e.InboundChildrenCount, 0) InboundChildrenCount,
        isnull(e.InboundChargedAdultsCount, 0) InboundChargedAdultsCount,

        ppc.CompetitorName,
        ppc.CompetitorPrice,

        pt.PaymentMode,
        pt.PointsRedeemed,
		pt.GigyaId,
        pt.IssuingConsultantId,
        pt.LeadTimeDate,
		pt.RefundTransactionID,
		pt.RefundTransactionKey
    into #penPolicyTransSummary
    from
        etl_penPolicyTrans pt
        inner join [db-au-cba].dbo.penPolicy p on
            p.PolicyKey = pt.PolicyKey
        outer apply
        (
            select top 1
                CurrencyCode,
                CurrencySymbol
            from
                [db-au-cba].dbo.penDomain d
            where
                d.DomainKey = p.DomainKey
        ) d
        outer apply
        (
            select top 1
                case
                    when pp.PlanName like '%Single%' then 0
                    when pp.PlanName like '%Family%' then 1
                    when pp.TravellerSetName like '%Single%' then 0
                    when pp.TravellerSetName like '%Duo%' then 2
                    when pp.TravellerSetName like '%Family%' then 1
                    else 3
                end SingleFamilyFlag,
                case
                    when pp.PlanName like '%AMT%' then 1
                    else 0
                end isAMT
            from
                [db-au-cba].dbo.penOutlet po
                inner join [db-au-cba].dbo.penProductPlan pp on
                    pp.OutletKey = po.OutletKey and
                    pp.ProductId = p.ProductID and
                    pp.UniquePlanId = p.UniquePlanId
            where
                po.OutletAlphaKey = p.OutletAlphaKey and
                po.OutletStatus = 'Current'
        ) ppp
        left join etl_penPolicyTransMetrics e on
            e.PolicyTransactionKey = pt.PolicyTransactionKey
        outer apply
        (
            select
                max(pa.CreateDateTime) PaymentDate
            from
                [db-au-cba].dbo.penPaymentAllocation pa
            where
                pa.CountryKey = pt.CountryKey and
                pa.CompanyKey = pt.CompanyKey and
                pa.PaymentAllocationID = pt.AllocationNumber
        ) ppta
        outer apply
        (
            select
                convert(date, max(CreateDateTime)) ImportDate
            from
                [db-au-cba].dbo.penPolicyImport ppi
            where
                ppi.Status = 'DONE' and
                ppi.CountryKey = pt.CountryKey and
                ppi.PolicyNumber = pt.PolicyNumber
        ) ppi
        /* all penPolicyTrans tables reference removed */
        outer apply
        (
            select
                /*after discount*/
                sum(StampDutyAfterDiscount) StampDutyAfterDiscount,
                sum(CommStampDutyAfterDiscount) CommStampDutyAfterDiscount,
                sum(GSTAfterDiscount) GSTAfterDiscount,
                sum(CommGSTAfterDiscount) CommGSTAfterDiscount,
                sum(BasePremiumAfterDiscount) BasePremiumAfterDiscount,
                sum(GrossPremiumAfterDiscount) GrossPremiumAfterDiscount,
                sum(CommissionAfterDiscount) CommissionAfterDiscount,
                sum(DiscountAfterDiscount) DiscountAfterDiscount,
                sum(GrossAdminFeeAfterDiscount) GrossAdminFeeAfterDiscount,
                sum(
                    case
                        when PriceCategory = 'Base Rate' then 1
                        else 0
                    end
                ) BaseRateCount,
                sum(
                    case
                        when PriceCategory = 'EMC' then 1
                        else 0
                    end
                ) EMCRateCount,
                sum(
                    case
                        when PriceCategory = 'Base Rate' then CommissionRateAfterDiscount
                        else 0
                    end
                ) CommissionRateAfterDiscount,
                sum(
                    case
                        when PriceCategory = 'Base Rate' then DiscountRateAfterDiscount
                        else 0
                    end
                ) DiscountRateAfterDiscount,
                sum(
                    case
                        when PriceCategory = 'EMC' then CommissionRateAfterDiscount
                        else 0
                    end
                ) EMCCommissionRateAfterDiscount,
                sum(
                    case
                        when PriceCategory = 'EMC' then DiscountRateAfterDiscount
                        else 0
                    end
                ) EMCDiscountRateAfterDiscount,
                /*before discount*/
                sum(StampDutyBeforeDiscount) StampDutyBeforeDiscount,
                sum(CommStampDutyBeforeDiscount) CommStampDutyBeforeDiscount,
                sum(GSTBeforeDiscount) GSTBeforeDiscount,
                sum(CommGSTBeforeDiscount) CommGSTBeforeDiscount,
                sum(BasePremiumBeforeDiscount) BasePremiumBeforeDiscount,
                sum(GrossPremiumBeforeDiscount) GrossPremiumBeforeDiscount,
                sum(CommissionBeforeDiscount) CommissionBeforeDiscount,
                sum(DiscountBeforeDiscount) DiscountBeforeDiscount,
                sum(GrossAdminFeeBeforeDiscount) GrossAdminFeeBeforeDiscount,
                sum(
                    case
                        when PriceCategory = 'Base Rate' then CommissionRateBeforeDiscount
                        else 0
                    end
                ) CommissionRateBeforeDiscount,
                sum(
                    case
                        when PriceCategory = 'Base Rate' then DiscountRateBeforeDiscount
                        else 0
                    end
                ) DiscountRateBeforeDiscount,
                sum(
                    case
                        when PriceCategory = 'EMC' then CommissionRateBeforeDiscount
                        else 0
                    end
                ) EMCCommissionRateBeforeDiscount,
                sum(
                    case
                        when PriceCategory = 'EMC' then DiscountRateBeforeDiscount
                        else 0
                    end
                ) EMCDiscountRateBeforeDiscount
            from
                [db-au-cba].dbo.vpenPolicyPriceComponent vpc
            where
                vpc.PolicyTransactionKey = pt.PolicyTransactionKey
        ) vpc
        cross apply
        (
            select
                case
                    when pt.TransactionDateTime is not null and pt.TransactionDateTime >= '2013-12-01' then pt.TransactionDateTime
                    else isnull(ppi.ImportDate, pt.IssueDate)
                end PostingTime
        ) pttm
        outer apply
        (
            select top 1
                CompetitorName,
                CompetitorPrice
            from
                [db-au-cba].dbo.penPolicyCompetitor ppc
            where
                pt.TransactionType = 'Base' and
                pt.TransactionStatus = 'Active' and
                ppc.PolicyKey = p.PolicyKey
            order by
                ppc.PolicyKey
        ) ppc
        where
            pt.PolicyNumber is not null and
            pt.PolicyNumber <> '0'

    begin transaction penPolicyTransSummary

    begin try

        --bring delete and insert closer before implementing upsert
        delete pts
        from
            [db-au-cba].dbo.penPolicyTransSummary pts
            inner join etl_penPolicyTrans pt on
                pt.PolicyTransactionKey = pts.PolicyTransactionKey

        insert [db-au-cba].dbo.penPolicyTransSummary with(tablockx)
        (
            CountryKey,
            CompanyKey,
            DomainKey,
            PolicyTransactionKey,
            PolicyKey,
            PolicyNoKey,
            OutletAlphaKey,
            OutletSKey,
            UserKey,
            UserSKey,
            DomainID,
            PolicyTransactionID,
            PolicyID,
            PolicyNumber,
            ExternalReference,
            TransactionTypeID,
            TransactionType,
            IssueDate,
            YAGOIssueDate,
            ImportDate,
            PostingDate,
            PostingTime,
            YAGOPostingDate,
            IssueTime,
            IssueTimeUTC,
            AccountingPeriod,
            CRMUserID,
            CRMUserName,
            TransactionStatusID,
            TransactionStatus,
            Transferred,
            UserComments,
            CommissionTier,
            VolumeCommission,
            Discount,
            ProductCode,
            PurchasePath,
            SingleFamilyFlag,
            isAMT,
            isExpo,
            isPriceBeat,
            NoOfBonusDaysApplied,
            isAgentSpecial,
            ParentID,
            ConsultantID,
            isClientCall,
            RiskNet,
            AutoComments,
            TripCost,
            AllocationNumber,
            PaymentDate,
            TransactionStart,
            TransactionEnd,
            PaymentDateUTC,
            TransactionStartUTC,
            TransactionEndUTC,
            TaxAmountSD,
            TaxOnAgentCommissionSD,
            TaxAmountGST,
            TaxOnAgentCommissionGST,
            BasePremium,
            GrossPremium,
            Commission,
            DiscountPolicyTrans,
            GrossAdminFee,
            AdjustedNet,
            CommissionRatePolicyPrice,
            DiscountRatePolicyPrice,
            CommissionRateTravellerPrice,
            DiscountRateTravellerPrice,
            CommissionRateTravellerAddOnPrice,
            DiscountRateTravellerAddOnPrice,
            CommissionRateEMCPrice,
            DiscountRateEMCPrice,
            UnAdjTaxAmountSD,
            UnAdjTaxOnAgentCommissionSD,
            UnAdjTaxAmountGST,
            UnAdjTaxOnAgentCommissionGST,
            UnAdjBasePremium,
            UnAdjGrossPremium,
            UnAdjCommission,
            UnAdjDiscountPolicyTrans,
            UnAdjGrossAdminFee,
            UnAdjAdjustedNet,
            UnAdjCommissionRatePolicyPrice,
            UnAdjDiscountRatePolicyPrice,
            UnAdjCommissionRateTravellerPrice,
            UnAdjDiscountRateTravellerPrice,
            UnAdjCommissionRateTravellerAddOnPrice,
            UnAdjDiscountRateTravellerAddOnPrice,
            UnAdjCommissionRateEMCPrice,
            UnAdjDiscountRateEMCPrice,
            StoreCode,
            NewPolicyCount,
            BasePolicyCount,
            AddonPolicyCount,
            ExtensionPolicyCount,
            CancelledPolicyCount,
            CancelledAddonPolicyCount,
            CANXPolicyCount,
            DomesticPolicyCount,
            InternationalPolicyCount,
            TravellersCount,
            AdultsCount,
            ChildrenCount,
            ChargedAdultsCount,
            DomesticTravellersCount,
            DomesticAdultsCount,
            DomesticChildrenCount,
            DomesticChargedAdultsCount,
            InternationalTravellersCount,
            InternationalAdultsCount,
            InternationalChildrenCount,
            InternationalChargedAdultsCount,
            NumberofDays,
            LuggageCount,
            MedicalCount,
            MotorcycleCount,
            RentalCarCount,
            WintersportCount,
            AttachmentCount,
            EMCCount,
            InternationalNewPolicyCount,
            InternationalCANXPolicyCount,
            CurrencyCode,
            CurrencySymbol,
            InboundPolicyCount,
            InboundTravellersCount,
            InboundAdultsCount,
            InboundChildrenCount,
            InboundChargedAdultsCount,
            CompetitorName,
            CompetitorPrice,
            CanxCover,
            PaymentMode,
            PointsRedeemed,
			GigyaID,
            IssuingConsultantID,
            LeadTimeDate,
			RefundTransactionID,
			RefundTransactionKey
        )
        select
            CountryKey,
            CompanyKey,
            DomainKey,
            PolicyTransactionKey,
            PolicyKey,
            PolicyNoKey,
            OutletAlphaKey,
            OutletSKey,
            UserKey,
            UserSKey,
            DomainID,
            PolicyTransactionID,
            PolicyID,
            PolicyNumber,
            ExternalReference,
            TransactionTypeID,
            TransactionType,
            IssueDate,
            YAGOIssueDate,
            ImportDate,
            PostingDate,
            PostingTime,
            YAGOPostingDate,
            IssueTime,
            IssueTimeUTC,
            AccountingPeriod,
            CRMUserID,
            CRMUserName,
            TransactionStatusID,
            TransactionStatus,
            Transferred,
            UserComments,
            CommissionTier,
            VolumeCommission,
            Discount,
            ProductCode,
            PurchasePath,
            SingleFamilyFlag,
            isAMT,
            isExpo,
            isPriceBeat,
            NoOfBonusDaysApplied,
            isAgentSpecial,
            ParentID,
            ConsultantID,
            isClientCall,
            RiskNet,
            AutoComments,
            TripCost,
            AllocationNumber,
            PaymentDate,
            TransactionStart,
            TransactionEnd,
            PaymentDateUTC,
            TransactionStartUTC,
            TransactionEndUTC,
            TaxAmountSD,
            TaxOnAgentCommissionSD,
            TaxAmountGST,
            TaxOnAgentCommissionGST,
            BasePremium,
            GrossPremium,
            Commission,
            DiscountPolicyTrans,
            GrossAdminFee,
            AdjustedNet,
            CommissionRatePolicyPrice,
            DiscountRatePolicyPrice,
            CommissionRateTravellerPrice,
            DiscountRateTravellerPrice,
            CommissionRateTravellerAddOnPrice,
            DiscountRateTravellerAddOnPrice,
            CommissionRateEMCPrice,
            DiscountRateEMCPrice,
            UnAdjTaxAmountSD,
            UnAdjTaxOnAgentCommissionSD,
            UnAdjTaxAmountGST,
            UnAdjTaxOnAgentCommissionGST,
            UnAdjBasePremium,
            UnAdjGrossPremium,
            UnAdjCommission,
            UnAdjDiscountPolicyTrans,
            UnAdjGrossAdminFee,
            UnAdjAdjustedNet,
            UnAdjCommissionRatePolicyPrice,
            UnAdjDiscountRatePolicyPrice,
            UnAdjCommissionRateTravellerPrice,
            UnAdjDiscountRateTravellerPrice,
            UnAdjCommissionRateTravellerAddOnPrice,
            UnAdjDiscountRateTravellerAddOnPrice,
            UnAdjCommissionRateEMCPrice,
            UnAdjDiscountRateEMCPrice,
            StoreCode,
            NewPolicyCount,
            BasePolicyCount,
            AddonPolicyCount,
            ExtensionPolicyCount,
            CancelledPolicyCount,
            CancelledAddonPolicyCount,
            CANXPolicyCount,
            DomesticPolicyCount,
            InternationalPolicyCount,
            TravellersCount,
            AdultsCount,
            ChildrenCount,
            ChargedAdultsCount,
            DomesticTravellersCount,
            DomesticAdultsCount,
            DomesticChildrenCount,
            DomesticChargedAdultsCount,
            InternationalTravellersCount,
            InternationalAdultsCount,
            InternationalChildrenCount,
            InternationalChargedAdultsCount,
            NumberofDays,
            LuggageCount,
            MedicalCount,
            MotorcycleCount,
            RentalCarCount,
            WintersportCount,
            AttachmentCount,
            EMCCount,
            InternationalNewPolicyCount,
            InternationalCANXPolicyCount,
            CurrencyCode,
            CurrencySymbol,
            InboundPolicyCount,
            InboundTravellersCount,
            InboundAdultsCount,
            InboundChildrenCount,
            InboundChargedAdultsCount,
            CompetitorName,
            CompetitorPrice,
            case
                when TripCost like '%unlimited%' then 1000000
                when TripCost like '%null%' then 250000
                when TripCost like '%object%' then 250000
                when TripCost like '%init%' then 250000
                else [db-au-cba].dbo.fn_StrToInt(CleanTripCost)
            end *
            case
                when pt.IssueDate < '2011-10-01' then 1
                when pt.BasePolicyCount < 0 then 0
                when pt.TransactionType = 'Base' and pt.TransactionStatus <> 'Active' then 0
                else pt.BasePolicyCount + pt.AddonPolicyCount
            end CanxCover,
            PaymentMode,
            PointsRedeemed,
			GigyaID,
            IssuingConsultantID,
            LeadTimeDate,
			RefundTransactionID,
			RefundTransactionKey
        from
            #penPolicyTransSummary pt
            cross apply
            (
                select
                    replace
                    (
                        replace
                        (
                            replace
                            (
                                ltrim(isnull(TripCost, '')),
                                '.00',
                                ''
                            ),
                            'DA-$',
                            ''
                        ),
                        'D-$',
                        ''
                    ) CleanTripCost
            ) tc

    end try

    begin catch

        if @@trancount > 0
            rollback transaction penPolicyTransSummary

        exec syssp_genericerrorhandler 'penPolicyTransSummary data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction penPolicyTransSummary


    --update penPolicyTransSummary CanxCover for FC US
    ;with cte_us as
    (
        select
            p.PolicyKey,
            pt.PolicyTransactionKey,
            pt.PolicyTransactionID,
            pt.CountryKey + '-' + pt.CompanyKey + convert(varchar(5), pt.DomainID) + '-' + convert(varchar(40), pt.ParentID) ParentTransactionKey,
            pt.PostingTime,
            pt.TransactionStatus,
            pt.TransactionType,
            tc.TripCost *
            case
                when TransactionType = 'Base' and TransactionStatus = 'Active' then 1
                when TransactionStatus = 'Active' then 1
                else 0
            end CalculatedTripCost
        from
            [db-au-cba]..penPolicy p
            inner join [db-au-cba]..penOutlet o on
                o.OutletAlphaKey = p.OutletAlphaKey
            inner join [db-au-cba]..penPolicyTransSummary pt on
                pt.PolicyKey = p.PolicyKey
            cross apply
            (
                select 
                    sum(isnull(try_convert(float, replace(replace(rtrim(ltrim(isnull(pta.AddOnText, ''))), '$', ''), ',', '')), 0)) TripCost
                from
                    [db-au-cba]..penPolicyTraveller ptv 
                    inner join [db-au-cba]..penPolicyTravellerTransaction ptt on
                        ptt.PolicyTravellerKey = ptv.PolicyTravellerKey
                    inner join [db-au-cba]..penPolicyTravellerAddOn pta on
                        pta.PolicyTravellerTransactionKey = ptt.PolicyTravellerTransactionKey
                where
                    ptv.PolicyKey = p.PolicyKey and
                    ptt.PolicyTransactionKey = pt.PolicyTransactionKey
            ) tc
        where
            o.OutletStatus = 'Current' and
            o.CountryKey = 'US' and
            o.GroupCode = 'FL' and
            p.PolicyKey in
            (
                select
                    PolicyKey
                from
                    #penPolicyTransSummary
            )
    ),
    cte_calculated as
    (
        select 
            t.PolicyKey,
            t.PolicyTransactionKey,
            t.ParentTransactionKey,
            t.PostingTime,
            t.TransactionType,
            t.TransactionStatus,
            t.CalculatedTripCost,
            isnull(PreviousTripCost, 0) PreviousTripCost,
            case
                when t.TransactionStatus = 'Active' then t.CalculatedTripCost - isnull(PreviousTripCost, 0) 
                else 0
            end VarTripCost
        from
            cte_us t
            outer apply
            (
                select top 1
                    CalculatedTripCost PreviousTripCost
                from
                    cte_us r
                where
                    r.PolicyKey = t.PolicyKey and
                    r.PostingTime < t.PostingTime
                order by
                    r.PostingTime desc
            ) r
    ),
    cte_test as
    (
        select 
            t.PolicyKey,
            t.PolicyTransactionKey,
            t.PostingTime,
            t.ParentTransactionKey,
            t.TransactionStatus,
            case
                when t.TransactionStatus = 'Active' then t.VarTripCost
                when t.TransactionType = 'Base' and t.TransactionStatus <> 'Active' then 0
                when t.TransactionStatus <> 'Active' then isnull(CancelledTripCost, 0)
                else 0
            end TransactionTripCost
        from
            cte_calculated t
            outer apply
            (
                select top 1 
                    -VarTripCost CancelledTripCost
                from
                    cte_calculated r
                where
                    t.TransactionType <> 'Base' and
                    t.TransactionStatus = 'Cancelled' and
                    r.PolicyTransactionKey = t.ParentTransactionKey
            ) r
        --order by
        --    1, 3
    )
    update pt
    set
        pt.CanxCover = TotalTripCost
    from
        [db-au-cba]..penPolicyTransSummary pt
        inner join [db-au-cba]..penOutlet o on
            o.OutletAlphaKey = pt.OutletAlphaKey and
            o.OutletStatus = 'Current'
        cross apply
        (
            select 
                sum(TransactionTripCost) TotalTripCost
            from
                cte_test t
            where
                t.PolicyTransactionKey = pt.PolicyTransactionKey
        ) t
    where
        o.CountryKey = 'US' and
        o.GroupCode = 'FL'


    --update penPolicy CancellationCover & TripCost
    update p
    set
        p.CancellationCover = CanxCover,
        p.TripCost = CanxCover
    from
        [db-au-cba]..penPolicy p
        cross apply
        (
            select
                case
                    when sum(pt.CanxCover) > 1000000 then 1000000
                    else sum(pt.CanxCover)
                end CanxCover
            from
                [db-au-cba]..penPolicyTransSummary pt
            where
                pt.PolicyKey = p.PolicyKey
        ) pt
    where
        p.PolicyKey in
        (
            select
                PolicyKey
            from
                #penPolicyTransSummary
        )


    /* cleanup temporary tables */
    if object_id('etl_penPolicyTrans') is not null
        drop table etl_penPolicyTrans

    if object_id('etl_penPolicyCounts') is not null
        drop table etl_penPolicyCounts

    if object_id('etl_penPolicyAddOns') is not null
        drop table etl_penPolicyAddOns

    if object_id('etl_penPolicyTransMetrics') is not null
        drop table etl_penPolicyTransMetrics

    if object_id('tempdb..#Country') is not null
        drop table #Country

    if object_id('tempdb..#penPolicyTransSummary') is not null
        drop table #penPolicyTransSummary

end



GO
