USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penPolicyTransPricing]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penPolicyTransPricing]
    @Country varchar(10) = 'AUNZSGMY',    --Required. AUNZSGMY, or UK, or US
    @ReportingPeriod varchar(30),       --Required. Default value 'Last 30 Days'
    @StartDate varchar(10),             --Optional. Format YYYY-MM-DD
    @EndDate varchar(10)                --Optional. Format YYYY-MM-DD

as
begin


/************************************************************************************************************************************
Author:         Linus Tor
Date:           20120209
Prerequisite:   Requires Penguin ETL successfully transferred from  Penguin production database.
Description:    This procedure transforms and summarises a number of transaction tables.
                - penPolicyTransTax: holds taxes per policy transaction
                - penPolicyTransTravellerPrice: holds traveller prices per policy transaction per traveller
                - penPolicyTransPolicyPrice: holds policy prices per policy Transaction
                - penPolicyTransTravellerAddOnPrice: holds traveller addon prices per policy transaction per addon
                - tblPolicyTransEMCPrice: holds EMC prices per policy transaction
                - penPolicyTransAddOn: holds addon gross premiums on transaction level

Change History:
                20120209 - LT - Procedure created
                20120321 - LT - Amended pricing transaction summaries to ensure only distinct records are summed
                20120629 - LS - Optimize index usage
                20120701 - LS - optimize run time, use temporary table to remove redundant calls to penPolicyTransaction
                20121101 - LS - add unadjusted taxes
                20121107 - LS - refactoring & domain related changes
                20130412 - LS - case 18432, summarise addon premium on transaction level to replace views
                20130728 - LT - Add Country parameter to cater for UK ETL.
                                Include Country filter in etl_penPolicyTransaction query
                20130731 - LS - Set default value for Country so it doesn't break other process calling this
                20130819 - LS - case 19018, critical bug found on penPolicyPrice, UK data causes duplicate data
                                include countrykey in join condition
                20131204 - LS - case 19524, stamp duty & gst bug, use new pricing calculation
                                include TransactionDateTime in 'to process selection'
                20131212 - LS - fix circular dependencies, change penPolicyTransSummary - > penPolicyTransaction
                20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                                synced roll up
                20140617 - LS - TFS 12416, schema and index cleanup
                20140715 - LS - F 21325, use transaction, other session will not see data gets deleted until after it's replaced (intraday refresh)
                20140725 - LS - F21428, sas data verification, use vpenPolicyPriceComponent instead duplicating code all over the place
				20160321 - LT - Penguin 18.0, Added US penguin instance

*************************************************************************************************************************************/

--uncomment to debug
--declare @Country varchar(10)
--declare @ReportingPeriod varchar(30)
--declare @StartDate varchar(10)
--declare @EndDate varchar(10)
--select
--    @Country = 'AUNZSGMY',
--    @ReportingPeriod = '_User Defined',
--    @StartDate = '2018-09-01',
--    @EndDate = '2018-09-30'


    set nocount on

    declare @rptStartDate datetime
    declare @rptEndDate datetime

    /* get reporting dates */
    if @ReportingPeriod = '_User Defined'
        select
            @rptStartDate = convert(smalldatetime,@StartDate),
            @rptEndDate = convert(smalldatetime,@EndDate)

    else
        select
            @rptStartDate = StartDate,
            @rptEndDate = EndDate
        from
            [db-au-cba].dbo.vDateRange
        where
            DateRange = @ReportingPeriod


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

        if object_id('etl_penPolicyTransAddon') is not null
            drop table etl_penPolicyTransAddon

        select
            pt.PolicyTransactionKey,
            pt.CountryKey,
            pt.CompanyKey
        into
            etl_penPolicyTransAddon
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

    end

    else
    /* dump records in date range */
    begin

        if object_id('etl_penPolicyTransAddon') is not null
            drop table etl_penPolicyTransAddon

        select
            pt.PolicyTransactionKey,
            pt.CountryKey,
            pt.CompanyKey
        into
            etl_penPolicyTransAddon
        from
            [db-au-cba].dbo.penPolicyTransaction pt
        where
            CountryKey  collate database_default in (select Country from #Country) AND
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

    create index idx on etl_penPolicyTransAddon(PolicyTransactionKey) include (CountryKey, CompanyKey)


    /* all penPolicyTrans tables removed */

    /******************************/
    --PolicyTransAddOn
    /******************************/
    if object_id('[db-au-cba].dbo.penPolicyTransAddOn') is null
    begin

        create table [db-au-cba].dbo.[penPolicyTransAddOn]
        (
            [CountryKey] varchar(2) null,
            [CompanyKey] varchar(5) null,
            [PolicyTransactionKey] varchar(41) null,
            [AddOnGroup] nvarchar(50) null,
            [AddOnText] nvarchar(500) null,
            [CoverIncrease] money null,
            [GrossPremium] money null,
            [UnAdjGrossPremium] money null
        )

        create clustered index idx_penPolicyTransAddOn_PolicyTransactionKey on [db-au-cba].dbo.penPolicyTransAddOn(PolicyTransactionKey)
        create nonclustered index idx_penPolicyTransAddOn_AddOnGroup on [db-au-cba].dbo.penPolicyTransAddOn(AddOnGroup)
        create nonclustered index idx_penPolicyTransAddOn_AddOnPrice on [db-au-cba].dbo.penPolicyTransAddOn(PolicyTransactionKey) include (AddOnGroup,GrossPremium,UnAdjGrossPremium)

    end

    if object_id('tempdb..#penPolicyTransAddOn') is not null
        drop table #penPolicyTransAddOn

    select
        pt.CountryKey,
        pt.CompanyKey,
        t.PolicyTransactionKey,
        case
            when t.PriceCategory = 'EMC' then 'Medical'
            else t.PriceCategory
        end AddOnGroup,
        t.AddOnText,
        t.CoverIncrease,
        sum(t.GrossPremiumAfterDiscount) GrossPremium,
        sum(t.GrossPremiumBeforeDiscount) UnAdjGrossPremium
    into #penPolicyTransAddOn
    from
        [db-au-cba]..vpenPolicyPriceComponent t
        inner join etl_penPolicyTransAddon pt on
            pt.PolicyTransactionKey = t.PolicyTransactionKey
    where
        t.PriceCategory <> 'Base Rate'
    group by
        pt.CountryKey,
        pt.CompanyKey,
        t.PolicyTransactionKey,
        PriceCategory,
        AddOnText,
        CoverIncrease


    begin transaction penPolicyTransAddOn

    begin try

        delete [db-au-cba].dbo.penPolicyTransAddOn
        where
            PolicyTransactionKey in
            (
                select distinct
                    PolicyTransactionKey
                from
                    etl_penPolicyTransAddon
            )

        insert into [db-au-cba].dbo.penPolicyTransAddOn with(tablockx)
        (
            CountryKey,
            CompanyKey,
            PolicyTransactionKey,
            AddOnGroup,
            AddOnText,
            CoverIncrease,
            GrossPremium,
            UnAdjGrossPremium
        )
        select
            CountryKey,
            CompanyKey,
            PolicyTransactionKey,
            AddOnGroup,
            AddOnText,
            CoverIncrease,
            GrossPremium,
            UnAdjGrossPremium
        from
            #penPolicyTransAddOn

    end try

    begin catch

        if @@trancount > 0
            rollback transaction penPolicyTransAddOn

        exec syssp_genericerrorhandler 'penPolicyTransAddOn data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction penPolicyTransAddOn


    if object_id('tempdb..#penPolicyTransAddOn') is not null
        drop table #penPolicyTransAddOn

    if object_id('etl_penPolicyTransAddon') is not null
        drop table etl_penPolicyTransAddon

    if object_id('tempdb..#Country') is not null
        drop table #Country

end




GO
