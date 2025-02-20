USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmOnlineClaimCosts]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_clmOnlineClaimCosts]
as
begin
/*
    20160620, LL, create
	20180927, LT, Customised for CBA
*/

    set nocount on

    exec etlsp_StagingIndex_Claim

    declare
        @batchid int,
        @start date,
        @end date,
        @name varchar(50),
        @sourcecount int,
        @insertcount int,
        @updatecount int

    declare @mergeoutput table (MergeAction varchar(20))

    exec syssp_getrunningbatch
        @SubjectArea = 'Claim ODS',
        @BatchID = @batchid out,
        @StartDate = @start out,
        @EndDate = @end out

    select
        @name = object_name(@@procid)

    exec syssp_genericerrorhandler
        @LogToTable = 1,
        @ErrorCode = '0',
        @BatchID = @batchid,
        @PackageID = @name,
        @LogStatus = 'Running'


    if object_id('[db-au-cba].dbo.clmOnlineClaimCosts') is null
    begin

        create table [db-au-cba].dbo.clmOnlineClaimCosts
        (
            BIRowID bigint identity(1,1) not null,
            CountryKey varchar(2) not null,
            ClaimKey varchar(40),
            OnlineClaimKey varchar(40) not null,
            ClaimNo int,
            OnlineClaimID int not null,
            ExpenseType varchar(15),
            isActual bit,
            ExpenseDate date,
            CostDescription varchar(max),
            CostReason varchar(max),
            Amount money,
            AmountRefunded money,
            AmountClaimable money,
            AmendmentCosts money,
            Currency varchar(20),
            Excess money,
            ExcessCurrency varchar(20),
            Paid bit,
            TravelAgentLiaise bit,
            TravelAgent varchar(max),
            PlaceOfPurchase varchar(max),
            ProofAttached bit,
            Replaced bit
        )

        create clustered index idx_clmOnlineClaimCosts_BIRowID on [db-au-cba].dbo.clmOnlineClaimCosts(BIRowID)
        create nonclustered index idx_clmOnlineClaimCosts_ClaimKey on [db-au-cba].dbo.clmOnlineClaimCosts(ClaimKey) include(BIRowID,ExpenseType,CostReason,CostDescription,ExpenseDate,isActual,ProofAttached,Amount)
        create nonclustered index idx_clmOnlineClaimCosts_ClaimNo on [db-au-cba].dbo.clmOnlineClaimCosts(ClaimNo) include(BIRowID)
        create nonclustered index idx_clmOnlineClaimCosts_OnlineClaimKey on [db-au-cba].dbo.clmOnlineClaimCosts(OnlineClaimKey)
        create nonclustered index idx_clmOnlineClaimCosts_ExpenseDate on [db-au-cba].dbo.clmOnlineClaimCosts(ExpenseDate,ExpenseType)
        create nonclustered index idx_clmOnlineClaimCosts_ExpenseType on [db-au-cba].dbo.clmOnlineClaimCosts(ExpenseType)

    end
    



    if object_id('tempdb..#onlineclaimscosts') is not null
        drop table #onlineclaimscosts

    select
        CountryKey,
        ClaimKey,
        OnlineClaimKey,
        ClaimNo,
        OnlineClaimID,
        ExpenseType,
        isActual,
        ExpenseDate,
        CostDescription,
        CostReason,
        Amount,
        AmountRefunded,
        AmountClaimable,
        AmendmentCosts,
        Currency,
        Excess,
        ExcessCurrency,
        Paid,
        TravelAgentLiaise,
        TravelAgent,
        PlaceOfPurchase,
        ProofAttached,
        Replaced
    into #onlineclaimscosts
    from
        [db-au-cba].dbo.clmOnlineClaimCosts
    where 
        1 = 0

    --addex, actual expenses
    insert into #onlineclaimscosts
    select-- top 100
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, oc.ClaimId) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, oc.OnlineClaimID) OnlineClaimKey,
        oc.ClaimId ClaimNo,
        oc.OnlineClaimID,
        'Additional' ExpenseType,
        1 isActual,
        null ExpenseDate,
        expa.value('CostDescription[1]', 'varchar(max)') CostDescription,
        '' CostReason,
        try_convert(money, expa.value('Amount[1]', 'varchar(max)')) Amount,
        0 AmountRefunded,
        try_convert(money, expa.value('Amount[1]', 'varchar(max)')) AmountClaimable,
        0 AmendmentCosts,
        expa.value('Currency[1]', 'varchar(max)') Currency,
        0 Excess,
        expa.value('Currency[1]', 'varchar(max)') ExcessCurrency,
        null Paid,
        0 TravelAgentLiaise,
        '' TravelAgent,
        '' PlaceOfPurchase,
        0 ProofAttached,
        0 Replaced
    from
        claims_tblOnlineClaims_au oc 
        cross apply dbo.fn_GetDomainKeys(oc.KLDOMAINID, 'CM', 'AU') dk
        inner join claims_tblOnlineClaimEventSections_au ocs on
            ocs.CauseId = oc.ClaimCauseId
        cross apply
        (
            select
                try_convert(xml, ocs.SectionDetails) SectionXML
        ) cx
        cross apply SectionXML.nodes('/ClaimSections/EXPDetails/ActualExpenses/DetailAdditionalExpenseActual') as expa(expa)

    insert into #onlineclaimscosts
    select-- top 100
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, oc.ClaimId) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, oc.OnlineClaimID) OnlineClaimKey,
        oc.ClaimId ClaimNo,
        oc.OnlineClaimID,
        'Additional' ExpenseType,
        1 isActual,
        try_convert(date, expa.value('DateExpenseOccured[1]', 'varchar(max)')) ExpenseDate,
        expa.value('ActualCostDescription[1]', 'varchar(max)') CostDescription,
        '' CostReason,
        try_convert(money, expa.value('ActualAmount[1]', 'varchar(max)')) Amount,
        0 AmountRefunded,
        try_convert(money, expac.value('ClaimAmount[1]', 'varchar(max)')) AmountClaimable,
        0 AmendmentCosts,
        expa.value('ActualCurrency[1]', 'varchar(max)') Currency,
        0 Excess,
        expa.value('ActualCurrency[1]', 'varchar(max)') ExcessCurrency,
        null Paid,
        0 TravelAgentLiaise,
        '' TravelAgent,
        '' PlaceOfPurchase,
        0 ProofAttached,
        0 Replaced
    from
        claims_tblOnlineClaims_au oc 
        cross apply dbo.fn_GetDomainKeys(oc.KLDOMAINID, 'CM', 'AU') dk
        inner join claims_tblOnlineClaimEventSections_au ocs on
            ocs.CauseId = oc.ClaimCauseId
        cross apply
        (
            select
                try_convert(xml, ocs.SectionDetails) SectionXML
        ) cx
        cross apply SectionXML.nodes('/ClaimSections/EXPDetails/Expenses/DetailAdditionalExpense') as expa(expa)
        outer apply SectionXML.nodes('/ClaimSections/EXPDetails') as expac(expac)

    --addex, planned expenses
    insert into #onlineclaimscosts
    select-- top 100
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, oc.ClaimId) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, oc.OnlineClaimID) OnlineClaimKey,
        oc.ClaimId ClaimNo,
        oc.OnlineClaimID,
        'Additional' ExpenseType,
        0 isActual,
        null ExpenseDate,
        expa.value('CostDescription[1]', 'varchar(max)') CostDescription,
        '' CostReason,
        try_convert(money, expa.value('Amount[1]', 'varchar(max)')) Amount,
        0 AmountRefunded,
        try_convert(money, expa.value('Amount[1]', 'varchar(max)')) AmountClaimable,
        0 AmendmentCosts,
        expa.value('Currency[1]', 'varchar(max)') Currency,
        0 Excess,
        expa.value('Currency[1]', 'varchar(max)') ExcessCurrency,
        null Paid,
        0 TravelAgentLiaise,
        '' TravelAgent,
        '' PlaceOfPurchase,
        0 ProofAttached,
        0 Replaced
    from
        claims_tblOnlineClaims_au oc 
        cross apply dbo.fn_GetDomainKeys(oc.KLDOMAINID, 'CM', 'AU') dk
        inner join claims_tblOnlineClaimEventSections_au ocs on
            ocs.CauseId = oc.ClaimCauseId
        cross apply
        (
            select
                try_convert(xml, ocs.SectionDetails) SectionXML
        ) cx
        cross apply SectionXML.nodes('/ClaimSections/EXPDetails/PlannedExpenses/DetailAdditionalExpensePlanned') as expa(expa)

    insert into #onlineclaimscosts
    select-- top 100
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, oc.ClaimId) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, oc.OnlineClaimID) OnlineClaimKey,
        oc.ClaimId ClaimNo,
        oc.OnlineClaimID,
        'Additional' ExpenseType,
        0 isActual,
        try_convert(date, expa.value('DateExpenseOccured[1]', 'varchar(max)')) ExpenseDate,
        expa.value('PlannedCostDescription[1]', 'varchar(max)') CostDescription,
        '' CostReason,
        try_convert(money, expa.value('PlannedAmount[1]', 'varchar(max)')) Amount,
        0 AmountRefunded,
        0 AmountClaimable,
        0 AmendmentCosts,
        expa.value('PlannedCurrency[1]', 'varchar(max)') Currency,
        0 Excess,
        expa.value('PlannedCurrency[1]', 'varchar(max)') ExcessCurrency,
        null Paid,
        0 TravelAgentLiaise,
        '' TravelAgent,
        '' PlaceOfPurchase,
        0 ProofAttached,
        0 Replaced
    from
        claims_tblOnlineClaims_au oc 
        cross apply dbo.fn_GetDomainKeys(oc.KLDOMAINID, 'CM', 'AU') dk
        inner join claims_tblOnlineClaimEventSections_au ocs on
            ocs.CauseId = oc.ClaimCauseId
        cross apply
        (
            select
                try_convert(xml, ocs.SectionDetails) SectionXML
        ) cx
        cross apply SectionXML.nodes('/ClaimSections/EXPDetails/Expenses/DetailAdditionalExpense') as expa(expa)

    --medical
    insert into #onlineclaimscosts
    select-- top 100
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, oc.ClaimId) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, oc.OnlineClaimID) OnlineClaimKey,
        oc.ClaimId ClaimNo,
        oc.OnlineClaimID,
        'Medical' ExpenseType,
        1 isActual,
        try_convert(date, med.value('Date[1]', 'varchar(max)')) ExpenseDate,
        med.value('Name[1]', 'varchar(max)') CostDescription,
        '' CostReason,
        try_convert(money, med.value('Amount[1]', 'varchar(max)')) Amount,
        0 AmountRefunded,
        try_convert(money, med.value('Amount[1]', 'varchar(max)')) AmountClaimable,
        0 AmendmentCosts,
        med.value('Currency[1]', 'varchar(max)') Currency,
        0 Excess,
        med.value('Currency[1]', 'varchar(max)') ExcessCurrency,
        isnull(try_convert(bit, med.value('Paid[1]', 'varchar(max)')), 0) Paid,
        0 TravelAgentLiaise,
        '' TravelAgent,
        '' PlaceOfPurchase,
        0 ProofAttached,
        0 Replaced
    from
        claims_tblOnlineClaims_au oc 
        cross apply dbo.fn_GetDomainKeys(oc.KLDOMAINID, 'CM', 'AU') dk
        inner join claims_tblOnlineClaimEventSections_au ocs on
            ocs.CauseId = oc.ClaimCauseId
        cross apply
        (
            select
                try_convert(xml, ocs.SectionDetails) SectionXML
        ) cx
        cross apply SectionXML.nodes('/ClaimSections/MEDDetails/DetailMedicalExpense') as med(med)

    --delayed luggage 
    insert into #onlineclaimscosts
    select-- top 100 
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, oc.ClaimId) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, oc.OnlineClaimID) OnlineClaimKey,
        oc.ClaimId ClaimNo,
        oc.OnlineClaimID,
        'Delayed Luggage' ExpenseType,
        1 isActual,
        null ExpenseDate,
        dlug.value('Description[1]', 'varchar(max)') CostDescription,
        '' CostReason,
        try_convert(money, dlug.value('Amount[1]', 'varchar(max)')) Amount,
        0 AmountRefunded,
        try_convert(money, dlug.value('Amount[1]', 'varchar(max)')) AmountClaimable,
        0 AmendmentCosts,
        dlug.value('Currency[1]', 'varchar(max)') Currency,
        0 Excess,
        dlug.value('Currency[1]', 'varchar(max)') ExcessCurrency,
        null Paid,
        0 TravelAgentLiaise,
        '' TravelAgent,
        '' PlaceOfPurchase,
        0 ProofAttached,
        0 Replaced
    from
        claims_tblOnlineClaims_au oc 
        cross apply dbo.fn_GetDomainKeys(oc.KLDOMAINID, 'CM', 'AU') dk
        inner join claims_tblOnlineClaimEventSections_au ocs on
            ocs.CauseId = oc.ClaimCauseId
        cross apply
        (
            select
                try_convert(xml, ocs.SectionDetails) SectionXML
        ) cx
        cross apply SectionXML.nodes('/ClaimSections/DELUGDetails/DetailDelayedLug') as dlug(dlug)

    --delays
    insert into #onlineclaimscosts
    select-- top 100 
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, oc.ClaimId) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, oc.OnlineClaimID) OnlineClaimKey,
        oc.ClaimId ClaimNo,
        oc.OnlineClaimID,
        'Travel Delays' ExpenseType,
        1 isActual,
        null ExpenseDate,
        dly.value('CostDesc[1]', 'varchar(max)') CostDescription,
        '' CostReason,
        try_convert(money, dly.value('Cost[1]', 'varchar(max)')) Amount,
        0 AmountRefunded,
        try_convert(money, dly.value('Cost[1]', 'varchar(max)')) AmountClaimable,
        0 AmendmentCosts,
        dly.value('Currency[1]', 'varchar(max)') Currency,
        0 Excess,
        dly.value('Currency[1]', 'varchar(max)') ExcessCurrency,
        null Paid,
        0 TravelAgentLiaise,
        '' TravelAgent,
        '' PlaceOfPurchase,
        0 ProofAttached,
        0 Replaced
    from
        claims_tblOnlineClaims_au oc 
        cross apply dbo.fn_GetDomainKeys(oc.KLDOMAINID, 'CM', 'AU') dk
        inner join claims_tblOnlineClaimEventSections_au ocs on
            ocs.CauseId = oc.ClaimCauseId
        cross apply
        (
            select
                try_convert(xml, ocs.SectionDetails) SectionXML
        ) cx
        cross apply SectionXML.nodes('/ClaimSections/TDELDetails/DetailTravelDelay') as dly(dly)

    --other
    insert into #onlineclaimscosts
    select-- top 100 
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, oc.ClaimId) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, oc.OnlineClaimID) OnlineClaimKey,
        oc.ClaimId ClaimNo,
        oc.OnlineClaimID,
        'Other' ExpenseType,
        1 isActual,
        null ExpenseDate,
        oth.value('CostDesc[1]', 'varchar(max)') CostDescription,
        '' CostReason,
        try_convert(money, oth.value('Cost[1]', 'varchar(max)')) Amount,
        0 AmountRefunded,
        try_convert(money, oth.value('Cost[1]', 'varchar(max)')) AmountClaimable,
        0 AmendmentCosts,
        oth.value('Currency[1]', 'varchar(max)') Currency,
        0 Excess,
        oth.value('Currency[1]', 'varchar(max)') ExcessCurrency,
        null Paid,
        0 TravelAgentLiaise,
        '' TravelAgent,
        '' PlaceOfPurchase,
        0 ProofAttached,
        0 Replaced
    from
        claims_tblOnlineClaims_au oc 
        cross apply dbo.fn_GetDomainKeys(oc.KLDOMAINID, 'CM', 'AU') dk
        inner join claims_tblOnlineClaimEventSections_au ocs on
            ocs.CauseId = oc.ClaimCauseId
        cross apply
        (
            select
                try_convert(xml, ocs.SectionDetails) SectionXML
        ) cx
        cross apply SectionXML.nodes('/ClaimSections/OTHDetails/DetailOther') as oth(oth)

    --rental car
    insert into #onlineclaimscosts
    select-- top 100 
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, oc.ClaimId) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, oc.OnlineClaimID) OnlineClaimKey,
        oc.ClaimId ClaimNo,
        oc.OnlineClaimID,
        'Rental Car' ExpenseType,
        1 isActual,
        case
            when ocs.SectionDetails not like '%ExpenseDate%' then null
            else try_convert(date, car.value('ExpenseDate[1]', 'varchar(max)')) 
        end ExpenseDate,
        '' CostDescription,
        '' CostReason,
        try_convert(money, car.value('Cost[1]', 'varchar(max)')) Amount,
        0 AmountRefunded,
        try_convert(money, car.value('Cost[1]', 'varchar(max)')) AmountClaimable,
        0 AmendmentCosts,
        car.value('CostCurrency[1]', 'varchar(max)') CostCurrency,
        try_convert(money, car.value('Excess[1]', 'varchar(max)')) Excess,
        car.value('ExcessCurrency[1]', 'varchar(max)') ExcessCurrency,
        null Paid,
        0 TravelAgentLiaise,
        '' TravelAgent,
        '' PlaceOfPurchase,
        0 ProofAttached,
        0 Replaced
    from
        claims_tblOnlineClaims_au oc 
        cross apply dbo.fn_GetDomainKeys(oc.KLDOMAINID, 'CM', 'AU') dk
        inner join claims_tblOnlineClaimEventSections_au ocs on
            ocs.CauseId = oc.ClaimCauseId
        cross apply
        (
            select
                try_convert(xml, ocs.SectionDetails) SectionXML
        ) cx
        cross apply SectionXML.nodes('/ClaimSections/CARDetails/DetailRentalCarExcess') as car(car)

    --canx 
    insert into #onlineclaimscosts
    select-- top 100 
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, oc.ClaimId) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, oc.OnlineClaimID) OnlineClaimKey,
        oc.ClaimId ClaimNo,
        oc.OnlineClaimID,
        'Cancellation' ExpenseType,
        1 isActual,
        try_convert(date, canx.value('DateAmendCancel[1]', 'varchar(max)')) ExpenseDate,
        canxc.value('TravelArrangement[1]', 'varchar(max)') CostDescription,
        canx.value('ReasonNotAmendTravelArrangements[1]', 'varchar(max)') CostReason,
        try_convert(money, canxc.value('AmountPaid[1]', 'varchar(max)')) Amount,
        try_convert(money, canxc.value('AmountRefunded[1]', 'varchar(max)')) AmountRefunded,
        try_convert(money, canxc.value('AmountClaimable[1]', 'varchar(max)')) AmountClaimable,
        try_convert(money, canxc.value('AmendmentCosts[1]', 'varchar(max)')) AmendmentCosts,
        '' CostCurrency,
        0 Excess,
        '' ExcessCurrency,
        null Paid,
        isnull(try_convert(bit, canx.value('TravelAgentLiaise[1]', 'varchar(max)')), 0) TravelAgentLiaise,
        canx.value('TravelAgent[1]', 'varchar(max)') TravelAgent,
        '' PlaceOfPurchase,
        0 ProofAttached,
        0 Replaced
    from
        claims_tblOnlineClaims_au oc 
        cross apply dbo.fn_GetDomainKeys(oc.KLDOMAINID, 'CM', 'AU') dk
        inner join claims_tblOnlineClaimEventSections_au ocs on
            ocs.CauseId = oc.ClaimCauseId
        cross apply
        (
            select
                try_convert(xml, ocs.SectionDetails) SectionXML
        ) cx
        cross apply SectionXML.nodes('/ClaimSections/CANXDetails') as canx(canx)
        outer apply SectionXML.nodes('/ClaimSections/CANXDetails/AmendmentCancellationCosts/AmendmentCancellationCost') as canxc(canxc)

    --luggage 
    insert into #onlineclaimscosts
    select-- top 100 
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, oc.ClaimId) ClaimKey,
        dk.CountryKey + '-' + convert(varchar, oc.OnlineClaimID) OnlineClaimKey,
        oc.ClaimId ClaimNo,
        oc.OnlineClaimID,
        'Luggage' ExpenseType,
        1 isActual,
        try_convert(date, lug.value('DatePurchased[1]', 'varchar(max)')) ExpenseDate,
        lug.value('Description[1]', 'varchar(max)') CostDescription,
        lug.value('ItemType[1]', 'varchar(max)') CostReason,
        try_convert(money, lug.value('OriginalPrice[1]', 'varchar(max)')) Amount,
        0 AmountRefunded,
        try_convert(money, lug.value('OriginalPrice[1]', 'varchar(max)')) AmountClaimable,
        0 AmendmentCosts,
        lug.value('OriginalCurrency[1]', 'varchar(max)') OriginalCurrency,
        0 Excess,
        lug.value('OriginalCurrency[1]', 'varchar(max)') OriginalCurrency,
        null Paid,
        0 TravelAgentLiaise,
        '' TravelAgent,
        lug.value('PlaceOfPurchase[1]', 'varchar(max)') PlaceOfPurchase,
        isnull(try_convert(bit, lug.value('ProofAttached[1]', 'varchar(max)')), 0) ProofAttached,
        isnull(try_convert(bit, lug.value('Replaced[1]', 'varchar(max)')), 0) Replaced
    from
        claims_tblOnlineClaims_au oc 
        cross apply dbo.fn_GetDomainKeys(oc.KLDOMAINID, 'CM', 'AU') dk
        inner join claims_tblOnlineClaimEventSections_au ocs on
            ocs.CauseId = oc.ClaimCauseId
        cross apply
        (
            select
                try_convert(xml, ocs.SectionDetails) SectionXML
        ) cx
        cross apply SectionXML.nodes('/ClaimSections/LUGGDetails/DetailLugTravelDocs') as lug(lug)


    set @sourcecount = @@rowcount

    begin transaction

    begin try

        delete 
        from
            [db-au-cba].dbo.clmOnlineClaimCosts
        where
            OnlineClaimKey in
            (
                select
                    OnlineClaimKey
                from
                    #onlineclaimscosts
            )

        insert into [db-au-cba].dbo.clmOnlineClaimCosts with (tablock)
        (
            CountryKey,
            ClaimKey,
            OnlineClaimKey,
            ClaimNo,
            OnlineClaimID,
            ExpenseType,
            isActual,
            ExpenseDate,
            CostDescription,
            CostReason,
            Amount,
            AmountRefunded,
            AmountClaimable,
            AmendmentCosts,
            Currency,
            Excess,
            ExcessCurrency,
            Paid,
            TravelAgentLiaise,
            TravelAgent,
            PlaceOfPurchase,
            ProofAttached,
            Replaced
        )
        select
            CountryKey,
            ClaimKey,
            OnlineClaimKey,
            ClaimNo,
            OnlineClaimID,
            ExpenseType,
            isActual,
            ExpenseDate,
            CostDescription,
            CostReason,
            Amount,
            AmountRefunded,
            AmountClaimable,
            AmendmentCosts,
            Currency,
            Excess,
            ExcessCurrency,
            Paid,
            TravelAgentLiaise,
            TravelAgent,
            PlaceOfPurchase,
            ProofAttached,
            Replaced
        from
            #onlineclaimscosts

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
            @SourceInfo = 'clmOnlineClaimCosts data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end



GO
