USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_ETL032_dimOutlet]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_ETL032_dimOutlet]
as
begin

/************************************************************************************************************************************
Author:         Linus Tor
Date:           20131114
Prerequisite:   Requires Penguin Data Model ETL successfully run.
                Requires [db-au-cba].dbo.penOutlet table available
Description:    dimOutlet dimension table contains agency attributes.
Parameters:     @LoadType: value is Migration or Incremental
Change History:
                20131114 - LT - Procedure created
                20140709 - PW - Added type 2 capability and consolidated Channels, Distributor, Supergroup and BDM Name
                20140710 - PW - Added merge function to perform update/insert operation
                20140904 - LT - Amended the conditions the MERGE statement will use to compare changes.
                                Amended the MATCHED criteria
                20140905 - LS - refactoring
                20140908 - LS - add initial unknown values
                20140909 - LS - modify idx_dimOutlet_OutletKey, it's being used in ODS to do JV mapping
                20141015 - LS - handle null group & subgroup name & code
                20141119 - LS - update non type 2 fields (type 1)
                                join should be on OutletAlphaKey instead of OutletKey as we combine data from TRIPS & Penguin (different OutletKey, same OutletAlphaKey)
                                the merge itself is using OutletAlphaKey, this causes multiple records error
				20150105 - LT - Fogbugz #22735 - Non-Type2 columns are not being updated as the script detects no BDM changes.
								Added UPDATE statement at the end of END CATCH statement to update non-type2 columns to latest
								values in [db-au-cba].dbo.penOutlet
                20150204 - LS - replace batch codes with standard batch logging
                20150330 - LS - F23793, add LatestOutletSK
                20150421 - LT - Changed ASICNumber column to nvarchar(50) in dimOutlet table definition
                20180412 - LL - move additional calculation from view to etl
				20180903 - LT - Use [db-au-cba].dbo.vpenOutletJV for JV information if excel JV information is null
*************************************************************************************************************************************/

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

    exec syssp_getrunningbatch
        @SubjectArea = 'Policy Star',
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


    --create dimOutlet if table does not exist
    if object_id('[db-au-star].dbo.dimOutlet') is null
    begin

        create table [db-au-star].dbo.dimOutlet
        (
            OutletSK int identity(1,1) not null,
            Country nvarchar(10) not null,
            JV nvarchar(20) null,
            JVDesc nvarchar(100) null,
            Distributor nvarchar(255) null,
            SuperGroupName nvarchar(255) null,
            Channel nvarchar(100) null,
            BDMName nvarchar(100) null,
            LatestBDMName nvarchar(100) null,
            NationalManager nvarchar(100) NULL,
            TerritoryManager nvarchar(100) NULL,
            DistributorManager nvarchar(100) NULL,
            OutletKey nvarchar(50) not null,
            OutletAlphaKey nvarchar(50) not null,
            OutletType nvarchar(50) null,
            OutletName nvarchar(50) null,
            AlphaCode nvarchar(20) null,
            TradingStatus nvarchar(50) null,
            CommencementDate datetime null,
            CloseDate datetime null,
            PreviousAlphaCode nvarchar(20) null,
            CloseReason nvarchar(50) null,
            ContactName nvarchar(150) null,
            ContactPhone nvarchar(50) null,
            ContactFax nvarchar(50) null,
            ContactEmail nvarchar(100) null,
            ContactStreet nvarchar(100) null,
            ContactSuburb nvarchar(50) null,
            ContactPostCode nvarchar(50) null,
            GroupName nvarchar(50) null,
            GroupCode nvarchar(50) null,
            GroupStartDate datetime null,
            GroupPhone nvarchar(50) null,
            GroupFax nvarchar(50) null,
            GroupEmail nvarchar(100) null,
            GroupStreet nvarchar(100) null,
            GroupSuburb nvarchar(50) null,
            GroupPostCode nvarchar(50) null,
            SubGroupName nvarchar(50) null,
            SubGroupCode nvarchar(50) null,
            SubGroupStartDate datetime null,
            SubGroupPhone nvarchar(50) null,
            SubGroupFax nvarchar(50) null,
            SubGroupEmail nvarchar(100) null,
            SubGroupStreet nvarchar(100) null,
            SubGroupSuburb nvarchar(50) null,
            SubGroupPostcode nvarchar(50) null,
            PaymentType nvarchar(50) Null,
            FSRType nvarchar(50) null,
            FSGCategory nvarchar(50) null,
            LegalEntityName nvarchar(100) null,
            ASICNumber nvarchar(50) null,
            ABN nvarchar(50) null,
            ASICCheckDate datetime null,
            AgreementDate datetime null,
            AdminExecutiveName nvarchar(150) null,
            ExternalID nvarchar(50) null,
            SalesSegment nvarchar(50) null,
            SalesTier nvarchar(50) null,
            Branch nvarchar(100) null,
            FCEGMNation nvarchar(50) null,
            FCNation nvarchar(50) null,
            FCArea nvarchar(50) null,
            StateSalesArea nvarchar(50) null,
            isLatest nvarchar(1) not null,
            ValidStartDate datetime not null,
            ValidEndDate datetime null,
            LoadDate datetime not null,
            updateDate datetime null,
            LoadID int not null,
            updateID int null,
            LatestOutletSK int null,
            AlphaLineage nvarchar(max),
            SalesQuadrant nvarchar(255),
            Quadrant  nvarchar(255),
            QuadrantPotential  nvarchar(255),
            DigitalStrategist  nvarchar(255)
        )
        
        create clustered index idx_dimOutlet_OutletSK on [db-au-star].dbo.dimOutlet(OutletSK,isLatest)
        create nonclustered index idx_dimOutlet_Country on [db-au-star].dbo.dimOutlet(Country)
        create nonclustered index idx_dimOutlet_OutletKey on [db-au-star].dbo.dimOutlet (OutletKey,isLatest) include (OutletSK,JV,JVDesc,Distributor,Channel)
        create nonclustered index idx_dimOutlet_OutletAlphaKey on [db-au-star].dbo.dimOutlet(OutletAlphaKey) include(OutletSK,ValidStartDate,ValidEndDate)
        create nonclustered index idx_dimOutlet_BDMName on [db-au-star].dbo.dimOutlet(BDMName)
        create nonclustered index idx_dimOutlet_OutletType on [db-au-star].dbo.dimOutlet(OutletType)
        create nonclustered index idx_dimOutlet_AlphaCode on [db-au-star].dbo.dimOutlet(AlphaCode)
        create nonclustered index idx_dimOutlet_TradingStatus on [db-au-star].dbo.dimOutlet(TradingStatus)
        create nonclustered index idx_dimOutlet_GroupName on [db-au-star].dbo.dimOutlet(GroupName)
        create nonclustered index idx_dimOutlet_SubGroupName on [db-au-star].dbo.dimOutlet(SubGroupName)
        create nonclustered index idx_dimOutlet_StateSalesArea on [db-au-star].dbo.dimOutlet(StateSalesArea)
        create nonclustered index idx_dimOutlet_SuperGroupName on [db-au-star].dbo.dimOutlet(SuperGroupName)
        create nonclustered index idx_dimOutlet_Distributor on [db-au-star].dbo.dimOutlet(Distributor)

        set identity_insert [db-au-star].dbo.dimOutlet on

        insert [db-au-star].dbo.dimOutlet
        (
            OutletSK,
            Country,
            JV,
            JVDesc,
            Distributor,
            SuperGroupName,
            Channel,
            BDMName,
            LatestBDMName,
            NationalManager,
            TerritoryManager,
            DistributorManager,
            OutletKey,
            OutletAlphaKey,
            OutletType,
            OutletName,
            AlphaCode,
            TradingStatus,
            PreviousAlphaCode,
            GroupName,
            GroupCode,
            GroupPostCode,
            SubGroupName,
            SubGroupCode,
            PaymentType,
            FCEGMNation,
            FCNation,
            FCArea,
            StateSalesArea,
            isLatest,
            ValidStartDate,
            LoadDate,
            LoadID
        )
        values
        (
            -1,
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            'UNKNOWN',
            '',
            '',
            '',
            '',
            'Y',
            getdate(),
            getdate(),
            @batchid
        )
        set identity_insert [db-au-star].dbo.dimOutlet off

    end


    if (select object_id('tempdb.dbo.#PO1')) is not null
        drop table #PO1;

    select *
    into #PO1
    from
        (
            select
                ROW_NUMBER() OVER (PARTITION BY OutletAlphaKey ORDER BY OutletStartDate) RNK
                ,o.CountryKey [Country]
                ,convert(nvarchar(20),'') [JV]
                ,convert(nvarchar(100),'') [JVDesc]
                ,convert(nvarchar(255),'') [Distributor]
                ,convert(nvarchar(255),'') [SuperGroupName]
                ,convert(nvarchar(100),'') [Channel]
                ,isnull(o.BDMName,'') BDMName
                ,convert(nvarchar(100),'') [LatestBDMName]
                ,convert(nvarchar(100),'') NationalManager
                ,convert(nvarchar(100),'') TerritoryManager
                ,convert(nvarchar(100),'') DistributorManager
                ,o.OutletStartDate
                ,o.OutletEndDate
                ,o.[OutletKey]
                ,o.[OutletAlphaKey]
                ,o.[OutletType]
                ,o.[OutletName]
                ,o.[AlphaCode]
                ,o.[TradingStatus]
                ,o.[CommencementDate]
                ,o.[CloseDate]
                ,isnull(o.PreviousAlpha,'') [PreviousAlphaCode]
                ,isnull(o.StatusRegion,'') [CloseReason]
                ,ltrim(rtrim(o.ContactFirstName)) + ' ' + ltrim(rtrim(o.ContactLastName)) [ContactName]
                ,o.[ContactPhone]
                ,isnull(o.[ContactFax],'') as ContactFax
                ,o.[ContactEmail]
                ,o.[ContactStreet]
                ,o.[ContactSuburb]
                ,o.[ContactPostCode]
                ,isnull(o.[GroupName],'') GroupName
                ,isnull(o.[GroupCode],'') GroupCode
                ,o.[GroupStartDate]
                ,isnull(o.[GroupPhone],'') as GroupPhone
                ,isnull(o.[GroupFax],'') GroupFax
                ,isnull(o.[GroupEmail],'') GroupEmail
                ,isnull(o.[GroupStreet],'') GroupStreet
                ,isnull(o.[GroupSuburb],'') GroupSuburb
                ,isnull(o.[GroupPostCode],'') GroupPostCode
                ,isnull(o.[SubGroupName],'') SubGroupName
                ,isnull(o.[SubGroupCode],'') SubGroupCode
                ,o.[SubGroupStartDate]
                ,isnull(o.[SubGroupPhone],'') SubGroupPhone
                ,isnull(o.[SubGroupFax],'')  SubGroupFax
                ,isnull(o.[SubGroupEmail],'') SubGroupEmail
                ,isnull(o.[SubGroupStreet],'') SubGroupStreet
                ,isnull(o.[SubGroupSuburb],'') SubGroupSuburb
                ,isnull(o.[SubGroupPostcode],'') SubGroupPostCode
                ,o.[PaymentType]
                ,o.[FSRType]
                ,isnull(o.[FSGCategory],'') FSGCategory
                ,isnull(o.[LegalEntityName],'') LegalEntityName
                ,o.[ASICNumber]
                ,isnull(o.[ABN],'') ABN
                ,o.[ASICCheckDate]
                ,o.[AgreementDate]
                ,o.AdminExecName [AdminExecutiveName]
                ,isnull(o.ExtID,'') [ExternalID]
                ,isnull(o.[SalesSegment],'') SalesSegment
                ,isnull(o.[SalesTier],'') SalesTier
                ,isnull(o.[Branch],'') Branch
                ,isnull(o.EGMNation,'') [FCEGMNation]
                ,isnull(o.[FCNation],'') FCNation
                ,isnull(o.[FCArea],'') FCArea
                ,isnull(o.[StateSalesArea],'') [StateSalesArea]
            from
                [db-au-cba].dbo.penOutlet o
        ) a

    if (select OBJECT_ID('tempdb.dbo.#PO2')) is not null
        drop table #PO2;

    select *
    into #PO2
    from
        (
            select
                ROW_NUMBER() OVER (PARTITION BY a.OutletAlphaKey ORDER BY a.OutletStartDate) RNK0,
                a.*
            from
                #PO1 a
                left join #PO1 b ON
                    a.OutletAlphaKey = b.OutletAlphaKey AND
                    a.RNK = b.RNK + 1
            where
                a.RNK = 1                            -- Always include first row as a change as well as BDM Name
                or a.BDMName <> b.BDMName
        ) a


    IF (SELECT OBJECT_ID('tempdb.dbo.#PO3')) is not null
        drop table #PO3;

    select
        a.*,
        CASE WHEN b.OutletStartDate IS NULL then 'Y' ELSE 'N' END [isLatest],
        CASE WHEN a.RNK0 = 1 then '1900-01-01' ELSE a.OutletStartDate END ValidStartDate,
        CASE WHEN b.OutletStartDate IS NULL then '2099-12-31' ELSE DATEADD(dd,-1,b.OutletStartDate) END ValidEndDate
    into #PO3
    from
        #PO2 a
        left join #PO2 b ON
            a.OutletAlphaKey = b.OutletAlphaKey AND a.RNK0 = b.RNK0 - 1

    -- Aggressively load outlets
    IF (SELECT OBJECT_ID('tempdb.dbo.#PO4')) is not null
        drop table #PO4;

    select
        isnull(SUBSTRING(OutletAlphaKey,1,2),'AU') Country
        ,'' [JV]
        ,'' [JVDesc]
        ,'' [Distributor]
        ,'' [SuperGroupName]
        ,'' [Channel]
        ,'' [BDMName]
        ,'' [LatestBDMName]
        ,'' NationalManager
        ,'' TerritoryManager
        ,'' DistributorManager
        ,'' [OutletKey]
        ,isnull(OutletAlphaKey,'') [OutletAlphaKey]
        ,'' [OutletType]
        ,isnull(OutletAlphaKey,'') [OutletName]
        ,isnull(RIGHT(OutletAlphaKey, CHARINDEX('-',REVERSE(OutletAlphaKey))-1),'') [AlphaCode]
        ,'' [TradingStatus]
        ,NULL [CommencementDate]
        ,NULL [CloseDate]
        ,'' [PreviousAlphaCode]
        ,'' [CloseReason]
        ,'' [ContactName]
        ,'' [ContactPhone]
        ,'' [ContactFax]
        ,'' [ContactEmail]
        ,'' [ContactStreet]
        ,'' [ContactSuburb]
        ,'' [ContactPostCode]
        ,'' [GroupName]
        ,'' [GroupCode]
        ,NULL [GroupStartDate]
        ,'' [GroupPhone]
        ,'' [GroupFax]
        ,'' [GroupEmail]
        ,'' [GroupStreet]
        ,'' [GroupSuburb]
        ,'' [GroupPostCode]
        ,'' [SubGroupName]
        ,'' [SubGroupCode]
        ,NULL [SubGroupStartDate]
        ,'' [SubGroupPhone]
        ,'' [SubGroupFax]
        ,'' [SubGroupEmail]
        ,'' [SubGroupStreet]
        ,'' [SubGroupSuburb]
        ,'' [SubGroupPostcode]
        ,'' [PaymentType]
        ,'' [FSRType]
        ,'' [FSGCategory]
        ,'' [LegalEntityName]
        ,'' [ASICNumber]
        ,'' [ABN]
        ,NULL [ASICCheckDate]
        ,NULL [AgreementDate]
        ,'' [AdminExecutiveName]
        ,'' [ExternalID]
        ,'' [SalesSegment]
        ,'' [SalesTier]
        ,'' [Branch]
        ,'' [FCEGMNation]
        ,'' [FCNation]
        ,'' [FCArea]
        ,'' [StateSalesArea]
        ,'Y' [isLatest]
        ,'1900-01-01' [ValidStartDate]
        ,'2099-12-31' [ValidEndDate]
    into #PO4
    from
        (
            select distinct
                UPPER(OutletAlphaKey) OutletAlphaKey
            from
                [db-au-cba].dbo.penPolicyTransSummary a
            where
                not exists
                (
                    select 1
                    from
                        #PO3 b
                    where
                        a.OutletAlphaKey = b.OutletAlphaKey
                )

            union

            select distinct
                UPPER(OutletAlphaKey) OutletAlphaKey
            from
                [db-au-cba].dbo.penQuote a
            where
                not exists
                (
                    select 1
                    from
                        #PO3 b
                    where
                        a.OutletAlphaKey = b.OutletAlphaKey
                )
        ) a



    select
        @sourcecount = count(*)
    from
        #PO3

    select
        @sourcecount = @sourcecount + count(*)
    from
        #PO4

    begin transaction
    begin try

        MERGE [db-au-star].dbo.dimOutlet AS T
        USING
        (
            select
                [Country]
                ,[JV]
                ,[JVDesc]
                ,[Distributor]
                ,[SuperGroupName]
                ,[Channel]
                ,[BDMName]
                ,[LatestBDMName]
                ,[NationalManager]
                ,[TerritoryManager]
                ,[DistributorManager]
                ,[OutletKey]
                ,[OutletAlphaKey]
                ,[OutletType]
                ,[OutletName]
                ,[AlphaCode]
                ,[TradingStatus]
                ,[CommencementDate]
                ,[CloseDate]
                ,[PreviousAlphaCode]
                ,[CloseReason]
                ,[ContactName]
                ,[ContactPhone]
                ,[ContactFax]
                ,[ContactEmail]
                ,[ContactStreet]
                ,[ContactSuburb]
                ,[ContactPostCode]
                ,[GroupName]
                ,[GroupCode]
                ,[GroupStartDate]
                ,[GroupPhone]
                ,[GroupFax]
                ,[GroupEmail]
                ,[GroupStreet]
                ,[GroupSuburb]
                ,[GroupPostCode]
                ,[SubGroupName]
                ,[SubGroupCode]
                ,[SubGroupStartDate]
                ,[SubGroupPhone]
                ,[SubGroupFax]
                ,[SubGroupEmail]
                ,[SubGroupStreet]
                ,[SubGroupSuburb]
                ,[SubGroupPostcode]
                ,[PaymentType]
                ,[FSRType]
                ,[FSGCategory]
                ,[LegalEntityName]
                ,[ASICNumber]
                ,[ABN]
                ,[ASICCheckDate]
                ,[AgreementDate]
                ,[AdminExecutiveName]
                ,[ExternalID]
                ,[SalesSegment]
                ,[SalesTier]
                ,[Branch]
                ,[FCEGMNation]
                ,[FCNation]
                ,[FCArea]
                ,[StateSalesArea]
                ,[isLatest]
                ,[ValidStartDate]
                ,[ValidEndDate]
                ,getdate() LoadDate
                ,@batchid LoadID
            from
                #PO3

            union all

            select
                [Country]
                ,[JV]
                ,[JVDesc]
                ,[Distributor]
                ,[SuperGroupName]
                ,[Channel]
                ,[BDMName]
                ,[LatestBDMName]
                ,[NationalManager]
                ,[TerritoryManager]
                ,[DistributorManager]
                ,[OutletKey]
                ,[OutletAlphaKey]
                ,[OutletType]
                ,[OutletName]
                ,[AlphaCode]
                ,[TradingStatus]
                ,[CommencementDate]
                ,[CloseDate]
                ,[PreviousAlphaCode]
                ,[CloseReason]
                ,[ContactName]
                ,[ContactPhone]
                ,[ContactFax]
                ,[ContactEmail]
                ,[ContactStreet]
                ,[ContactSuburb]
                ,[ContactPostCode]
                ,[GroupName]
                ,[GroupCode]
                ,[GroupStartDate]
                ,[GroupPhone]
                ,[GroupFax]
                ,[GroupEmail]
                ,[GroupStreet]
                ,[GroupSuburb]
                ,[GroupPostCode]
                ,[SubGroupName]
                ,[SubGroupCode]
                ,[SubGroupStartDate]
                ,[SubGroupPhone]
                ,[SubGroupFax]
                ,[SubGroupEmail]
                ,[SubGroupStreet]
                ,[SubGroupSuburb]
                ,[SubGroupPostcode]
                ,[PaymentType]
                ,[FSRType]
                ,[FSGCategory]
                ,[LegalEntityName]
                ,[ASICNumber]
                ,[ABN]
                ,[ASICCheckDate]
                ,[AgreementDate]
                ,[AdminExecutiveName]
                ,[ExternalID]
                ,[SalesSegment]
                ,[SalesTier]
                ,[Branch]
                ,[FCEGMNation]
                ,[FCNation]
                ,[FCArea]
                ,[StateSalesArea]
                ,[isLatest]
                ,[ValidStartDate]
                ,[ValidEndDate]
                ,getdate()
                ,@batchid
            from
                #PO4
        ) AS S
        ON
            (
                T.OutletAlphaKey = S.OutletAlphaKey AND
                T.ValidStartDate = S.ValidStartDate AND
                T.BDMName = S.BDMName
            )

        --there can only be 1 when matched block, this will be handled with case statement below
        --when matched and T.ValidEndDate <> S.ValidEndDate then
        --    update
        --    set
        --        T.ValidEndDate = S.ValidEndDate,
        --        T.isLatest = S.isLatest

        /*20141117 - LS - update non type 2 fields (type 1)*/
        /*some fields were omitted from this block because either they will be updated later on (below codes) or it doesn't make sense and improbable, e.g. Country, Alpha Code*/
        /*start*/
        when matched then
            update
            set
                T.OutletType = S.OutletType,
                T.OutletName = S.OutletName,
                --T.AlphaCode = S.AlphaCode,
                T.TradingStatus = S.TradingStatus,
                T.CommencementDate = S.CommencementDate,
                T.CloseDate = S.CloseDate,
                T.PreviousAlphaCode = S.PreviousAlphaCode,
                T.CloseReason = S.CloseReason,
                T.ContactName = S.ContactName,
                T.ContactPhone = S.ContactPhone,
                T.ContactFax = S.ContactFax,
                T.ContactEmail = S.ContactEmail,
                T.ContactStreet = S.ContactStreet,
                T.ContactSuburb = S.ContactSuburb,
                T.ContactPostCode = S.ContactPostCode,
                T.GroupName = S.GroupName,
                T.GroupCode = S.GroupCode,
                T.GroupStartDate = S.GroupStartDate,
                T.GroupPhone = S.GroupPhone,
                T.GroupFax = S.GroupFax,
                T.GroupEmail = S.GroupEmail,
                T.GroupStreet = S.GroupStreet,
                T.GroupSuburb = S.GroupSuburb,
                T.GroupPostCode = S.GroupPostCode,
                T.SubGroupName = S.SubGroupName,
                T.SubGroupCode = S.SubGroupCode,
                T.SubGroupStartDate = S.SubGroupStartDate,
                T.SubGroupPhone = S.SubGroupPhone,
                T.SubGroupFax = S.SubGroupFax,
                T.SubGroupEmail = S.SubGroupEmail,
                T.SubGroupStreet = S.SubGroupStreet,
                T.SubGroupSuburb = S.SubGroupSuburb,
                T.SubGroupPostcode = S.SubGroupPostcode,
                T.PaymentType = S.PaymentType,
                T.FSRType = S.FSRType,
                T.FSGCategory = S.FSGCategory,
                T.LegalEntityName = S.LegalEntityName,
                T.ASICNumber = S.ASICNumber,
                T.ABN = S.ABN,
                T.ASICCheckDate = S.ASICCheckDate,
                T.AgreementDate = S.AgreementDate,
                T.AdminExecutiveName = S.AdminExecutiveName,
                T.ExternalID = S.ExternalID,
                T.SalesSegment = S.SalesSegment,
                T.SalesTier = S.SalesTier,
                T.Branch = S.Branch,
                T.FCEGMNation = S.FCEGMNation,
                T.FCNation = S.FCNation,
                T.FCArea = S.FCArea,
                T.StateSalesArea = S.StateSalesArea,

                T.ValidEndDate =
                    case
                        when T.ValidEndDate <> S.ValidEndDate then S.ValidEndDate
                        else T.ValidEndDate
                    end,

                T.isLatest =
                    case
                        when T.ValidEndDate <> S.ValidEndDate then S.isLatest
                        else T.isLatest
                    end

        /*end*/

        when not matched by target then
            insert
            (
                [Country]
                ,[JV]
                ,[JVDesc]
                ,[Distributor]
                ,[SuperGroupName]
                ,[Channel]
                ,[BDMName]
                ,[LatestBDMName]
                ,[NationalManager]
                ,[TerritoryManager]
                ,[DistributorManager]
                ,[OutletKey]
                ,[OutletAlphaKey]
                ,[OutletType]
                ,[OutletName]
                ,[AlphaCode]
                ,[TradingStatus]
                ,[CommencementDate]
                ,[CloseDate]
                ,[PreviousAlphaCode]
                ,[CloseReason]
                ,[ContactName]
                ,[ContactPhone]
                ,[ContactFax]
                ,[ContactEmail]
                ,[ContactStreet]
                ,[ContactSuburb]
                ,[ContactPostCode]
                ,[GroupName]
                ,[GroupCode]
                ,[GroupStartDate]
                ,[GroupPhone]
                ,[GroupFax]
                ,[GroupEmail]
                ,[GroupStreet]
                ,[GroupSuburb]
                ,[GroupPostCode]
                ,[SubGroupName]
                ,[SubGroupCode]
                ,[SubGroupStartDate]
                ,[SubGroupPhone]
                ,[SubGroupFax]
                ,[SubGroupEmail]
                ,[SubGroupStreet]
                ,[SubGroupSuburb]
                ,[SubGroupPostcode]
                ,[PaymentType]
                ,[FSRType]
                ,[FSGCategory]
                ,[LegalEntityName]
                ,[ASICNumber]
                ,[ABN]
                ,[ASICCheckDate]
                ,[AgreementDate]
                ,[AdminExecutiveName]
                ,[ExternalID]
                ,[SalesSegment]
                ,[SalesTier]
                ,[Branch]
                ,[FCEGMNation]
                ,[FCNation]
                ,[FCArea]
                ,[StateSalesArea]
                ,[isLatest]
                ,[ValidStartDate]
                ,[ValidEndDate]
                ,LoadDate
                ,LoadID
            )
            VALUES
            (
                S.[Country]
                ,S.[JV]
                ,S.[JVDesc]
                ,S.[Distributor]
                ,S.[SuperGroupName]
                ,S.[Channel]
                ,S.[BDMName]
                ,S.[LatestBDMName]
                ,S.[NationalManager]
                ,S.[TerritoryManager]
                ,S.[DistributorManager]
                ,S.[OutletKey]
                ,S.[OutletAlphaKey]
                ,S.[OutletType]
                ,S.[OutletName]
                ,S.[AlphaCode]
                ,S.[TradingStatus]
                ,S.[CommencementDate]
                ,S.[CloseDate]
                ,S.[PreviousAlphaCode]
                ,S.[CloseReason]
                ,S.[ContactName]
                ,S.[ContactPhone]
                ,S.[ContactFax]
                ,S.[ContactEmail]
                ,S.[ContactStreet]
                ,S.[ContactSuburb]
                ,S.[ContactPostCode]
                ,S.[GroupName]
                ,S.[GroupCode]
                ,S.[GroupStartDate]
                ,S.[GroupPhone]
                ,S.[GroupFax]
                ,S.[GroupEmail]
                ,S.[GroupStreet]
                ,S.[GroupSuburb]
                ,S.[GroupPostCode]
                ,S.[SubGroupName]
                ,S.[SubGroupCode]
                ,S.[SubGroupStartDate]
                ,S.[SubGroupPhone]
                ,S.[SubGroupFax]
                ,S.[SubGroupEmail]
                ,S.[SubGroupStreet]
                ,S.[SubGroupSuburb]
                ,S.[SubGroupPostcode]
                ,S.[PaymentType]
                ,S.[FSRType]
                ,S.[FSGCategory]
                ,S.[LegalEntityName]
                ,S.[ASICNumber]
                ,S.[ABN]
                ,S.[ASICCheckDate]
                ,S.[AgreementDate]
                ,S.[AdminExecutiveName]
                ,S.[ExternalID]
                ,S.[SalesSegment]
                ,S.[SalesTier]
                ,S.[Branch]
                ,S.[FCEGMNation]
                ,S.[FCNation]
                ,S.[FCArea]
                ,S.[StateSalesArea]
                ,S.[isLatest]
                ,S.[ValidStartDate]
                ,S.[ValidEndDate]
                ,S.LoadDate
                ,S.LoadID
            )

        output $action into @mergeoutput;

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


        -- update dimension with excel hierarchy information
        update a
        set
            a.JV = isnull(isnull(po.JV,o.JV),''),
            a.JVDesc = isnull(isnull(po.[JV Desc],o.[JV Desc]),''),
            a.Distributor = isnull(o.Distributor,''),
            a.SuperGroupName = isnull(o.SuperGroupName,''),
            a.Channel = isnull(isnull(po.Channel,c.Channel),''),
            a.LatestBDMName = isnull(b.BDMName,'')
        from
            [db-au-star].dbo.dimOutlet a
            left join [db-au-stage].dbo.etl_excel_outlet o on
                a.AlphaCode = o.AlphaCode and
                a.Country = o.Country
            left join [db-au-stage].dbo.etl_excel_channel c on
                o.ChannelID = c.ChannelID
            left join [db-au-star].dbo.dimOutlet b on
                a.OutletAlphaKey = b.OutletAlphaKey and b.isLatest = 'Y'
			outer apply
			(
				select top 1
					jv.JVCode as JV,
					jv.JVDescription as [JV Desc],
					jv.[Channel] as Channel
				from
					[db-au-cba].dbo.vpenOutletJV jv
				where
					jv.OutletKey = a.OutletKey
			) po


        update a
        set
            a.NationalManager = isnull(s.NationalManager,''),
            a.TerritoryManager = isnull(s.TerritoryManager,''),
            a.DistributorManager = isnull(s.DistributorManager,'')
        from
            [db-au-star].dbo.dimOutlet a
            left join [db-au-stage].[dbo].[etl_excel_salesforce] s on
                ltrim(rtrim(a.LatestBDMName)) = ltrim(rtrim(isnull(s.BDMName,'')))
                and a.Country = s.Country;


	    --update non-type2 columns to reflect penOutlet latest values
	    update a
	    set 
		    a.OutletType = b.OutletType,
		    a.OutletName = b.OutletName,
		    a.TradingStatus = b.TradingStatus,
		    a.CommencementDate = b.CommencementDate,                    
		    a.CloseDate = b.CloseDate,                    
		    a.PreviousAlphaCode = isnull(b.PreviousAlpha,''),
		    a.CloseReason = isnull(b.StatusRegion,''),
		    a.ContactName = ltrim(rtrim(b.ContactFirstName)) + ' ' + ltrim(rtrim(b.ContactLastName)),
		    a.ContactPhone = b.ContactPhone,
		    a.ContactFax = isnull(b.ContactFax,''),
		    a.ContactEmail = b.ContactEmail,
		    a.ContactStreet = b.ContactStreet,
		    a.ContactSuburb = b.ContactSuburb,
		    a.ContactPostCode = b.ContactPostCode,
		    a.GroupName = isnull(b.GroupName,''),
		    a.GroupCode = isnull(b.GroupCode,''),
		    a.GroupStartDate = b.GroupStartDate,
		    a.GroupPhone = isnull(b.GroupPhone,''),
		    a.GroupFax = isnull(b.GroupFax,''),
		    a.GroupEmail = isnull(b.GroupEmail,''),
		    a.GroupStreet = isnull(b.GroupStreet,''),
		    a.GroupSuburb = isnull(b.GroupSuburb,''),
		    a.GroupPostCode = isnull(b.GroupPostCode,''),
		    a.SubGroupName = isnull(b.SubGroupName,''),
		    a.SubGroupCode = isnull(b.SubGroupCode,''),
		    a.SubGroupStartDate = b.SubGroupStartDate,
		    a.SubGroupPhone = isnull(b.SubGroupPhone,''),
		    a.SubGroupFax = isnull(b.SubGroupFax,''),
		    a.SubGroupEmail = isnull(b.SubGroupEmail,''),
		    a.SubGroupStreet = isnull(b.SubGroupStreet,''),
		    a.SubGroupSuburb = isnull(b.SubGroupSuburb,''),
		    a.SubGroupPostCode = isnull(b.SubGroupPostcode,''),
		    a.PaymentType = b.PaymentType,
		    a.FSRType = b.FSRType,
		    a.FSGCategory = isnull(b.FSGCategory,''),
		    a.LegalEntityName = isnull(b.LegalEntityName,''),
		    a.ASICNumber = b.ASICNumber,
		    a.ABN = isnull(b.ABN,''),
		    a.ASICCheckDate = b.ASICCheckDate,
		    a.AgreementDate = b.AgreementDate,
		    a.AdminExecutiveName = b.AdminExecName,
		    a.ExternalID = isnull(b.ExtID,''),
		    a.SalesSegment = isnull(b.SalesSegment,''),
		    a.SalesTier = isnull(b.SalesTier,''),
		    a.Branch = isnull(b.Branch,''),
		    a.FCEGMNation = isnull(b.EGMNation,''),
		    a.FCNation = isnull(b.FCNation,''),
		    a.FCArea = isnull(b.FCArea,''),
		    a.StateSalesArea = isnull(b.StateSalesArea,'')
	    from
		    [db-au-star].dbo.dimOutlet a
		    inner join [db-au-cba].dbo.penOutlet b on 
			    a.OutletAlphaKey = b.OutletAlphaKey and
			    b.OutletStatus = 'Current';



        -- update LatestOutletSK
        update do
        set
            /* assumption, if it is the last alpha in chain then keep the SK otherwise get the first SK of last alpha in chain */
            LatestOutletSK = 
                case
                    when isnull(LatestOutletKey, do.OutletKey) = do.OutletKey then OutletSK
                    else isnull(losk.LatestOutletSK, do.OutletSK)
                end 
        from
            [db-au-star]..dimOutlet do
            outer apply
            (
                select top 1
                    LatestOutletKey
                from
                    [db-au-cba]..penOutlet o
                where
                    o.OutletKey = do.OutletKey and
                    o.OutletStatus = 'Current'
            ) lok
            outer apply
            (
                select top 1 
                    ldo.OutletSK LatestOutletSK
                from
                    [db-au-star]..dimOutlet ldo
                where
                    ldo.OutletKey = LatestOutletKey
                order by
                    ValidStartDate
            ) losk

        --update alpha lineage
        update do
        set 
            do.AlphaLineage = isnull(ol.Lineage, '')
        from
            [db-au-star]..dimOutlet do
            outer apply
            (
                select top 1
                    Lineage
                from
                    [db-au-cba].dbo.penOutletLineage ol
                where
                    ol.OutletKey = do.OutletKey
            ) ol

        --update digital strategist
        update do
        set 
            do.DigitalStrategist = isnull(ds.Strategist, 'N/A')
        from
            [db-au-star]..dimOutlet do
            outer apply
            (
                select top 1
                    ds.Strategist
                from
                    [db-au-cba]..usrECOMTeam ds
                where
                    ds.[Country Code] = do.country and
                    ds.[Super Group Name] = do.SuperGroupName and
                    ds.[Group Name] = do.GroupName and
                    (
                        rtrim(isnull(ds.[Sub Group Name], '')) = '' or
                        ds.[Sub Group Name] = do.SubGroupName
                    ) and
                    do.Channel in ('Integrated', 'Website White-Label', 'Mobile')
            ) ds

        --update salesforce quadrant
        update do
        set 
            do.SalesQuadrant = isnull(sf.SalesQuadrant, 'Unknown'),
            do.Quadrant = isnull(sf.Quadrant, 'Unknown'),
            do.QuadrantPotential = isnull(sf.QuadrantPotential, 'Unknown')
        from
            [db-au-star]..dimOutlet do
            outer apply
            (
                select top 1 
                    SalesQuadrant,
                    Quadrant,
                    QuadrantPotential
                from
                    [db-au-cba]..sfAccount sf with(index(idx_sfAccount_AgencyID))
                where
                    sf.AgencyID = (do.Country + '.CMA.' + do.AlphaCode)
            ) sf


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
            @SourceInfo = 'data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end

GO
