USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmName_rollup]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_clmName_rollup]
as
begin
/*
    20140415, LS,   20728 Refactoring, change to incremental
    20140506, LS,   delete based on KLREG
                    metadata has been updated to make sure all related tables are at the same base KLREG
    20140811, LS,   T12242 Global Claim
                    use batch logging
                    use merge instead of deleting the whole names in a claim
    20141111, LS,   T14092 Claims.Net Global
                    add new UK data set
                    enlarge bank name
    20141111, LS,   T14092 Claims.Net Global
                    add new UK data set
	20180927, LT,	Customised for CBA
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

    if object_id('[db-au-cba].dbo.clmName') is null
    begin

        create table [db-au-cba].dbo.clmName
        (
            [CountryKey] varchar(2) not null,
            [NameKey] varchar(40) null,
            [ClaimKey] varchar(40) null,
            [NameID] int not null,
            [ClaimNo] int null,
            [Num] smallint null,
            [Surname] nvarchar(100) null,
            [Firstname] nvarchar(100) null,
            [Title] nvarchar(50) null,
            [DOB] datetime null,
            [AddressStreet] nvarchar(100) null,
            [AddressSuburb] nvarchar(50) null,
            [AddressState] nvarchar(100) null,
            [AddressCountry] nvarchar(100) null,
            [AddressPostCode] nvarchar(50) null,
            [HomePhone] nvarchar(50) null,
            [WorkPhone] nvarchar(50) null,
            [Fax] varchar(20) null,
            [Email] nvarchar(255) null,
            [isDirectCredit] bit null,
            [AccountNo] varchar(20) null,
            [AccountName] nvarchar(100) null,
            [BSB] nvarchar(15) null,
            [isPrimary] bit null,
            [isThirdParty] bit null,
            [isForeign] bit null,
            [ProviderID] int null,
            [BusinessName] nvarchar(100) null,
            [isEmailOK] bit null,
            [PaymentMethodID] int null,
            [EMC] varchar(10) null,
            [ITC] bit null,
            [ITCPCT] float null,
            [isGST] bit null,
            [GSTPercentage] float null,
            [GoodsSupplier] bit null,
            [ServiceProvider] bit null,
            [SupplyBy] int null,
            [EncryptAccount] varbinary(256) null,
            [EncryptBSB] varbinary(256) null,
            [isPayer] bit null,
            [BankName] nvarchar(50) null,
            [BIRowID] int not null identity(1,1),
            [CreateBatchID] int null,
            [UpdateBatchID] int null
        )

        create clustered index idx_clmName_BIRowID on [db-au-cba].dbo.clmName(BIRowID)
        create nonclustered index idx_clmName_ClaimKey on [db-au-cba].dbo.clmName(ClaimKey) include(isPrimary,NameKey,NameID,Title,Firstname,Surname,DOB,Email,isThirdParty)
        create nonclustered index idx_clmName_NameKey on [db-au-cba].dbo.clmName(NameKey) include(ClaimKey,isPrimary,NameID,Title,Firstname,Surname,DOB,Email,BusinessName,AddressStreet,AddressSuburb,AddressState,AddressPostCode,isThirdParty)

    end

    if object_id('etl_claims_name') is not null
        drop table etl_claims_name

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, n.KNCLAIM_ID) + '-' + convert(varchar, n.KN_ID) NameKey,
        dk.CountryKey + '-' + convert(varchar, n.KNCLAIM_ID) ClaimKey,
        n.KN_ID NameID,
        n.KNCLAIM_ID ClaimNo,
        n.KNNUM Num,
        n.KNSURNAME Surname,
        n.KNFIRST Firstname,
        n.KNTITLE Title,
        n.KNDOB DOB,
        n.KNSTREET AddressStreet,
        n.KNSUBURB AddressSuburb,
        n.KNSTATE AddressState,
        n.KNCOUNTRY AddressCountry,
        n.KNPCODE AddressPostCode,
        n.KNHPHONE HomePhone,
        n.KNWPHONE WorkPhone,
        n.KNFAX Fax,
        n.KNEMAIL Email,
        n.KNDIRECTCRED isDirectCredit,
        n.KNACCT AccountNo,
        n.KNACCTNAME AccountName,
        n.KNBSB BSB,
        n.KNPRIMARY isPrimary,
        n.KNTHIRDPARTY isThirdParty,
        n.KNFOREIGN isForeign,
        n.KNPROV_ID ProviderID,
        n.KNBUSINESSNAME BusinessName,
        n.KNEMAILOK isEmailOK,
        n.KNPAYMENTMETHODID PaymentMethodID,
        n.KNEMC EMC,
        n.KNITC ITC,
        n.KNITCPCT ITCPCT,
        n.KPGST isGST,
        n.KPGSTPERC GSTPercentage,
        n.KPGOODSSUPPLIER GoodsSupplier,
        n.KPSERVPROV ServiceProvider,
        n.KPSUPPLYBY SupplyBy,
        n.KNEncryptACCT EncryptAccount,
        n.KNEncryptBSB EncryptBSB,
        n.KNPAYER isPayer,
        n.KPBANKNAME BankName
    into etl_claims_name
    from
        claims_klnames_au n
        outer apply
        (
            select top 1
                KLDOMAINID
            from
                claims_KLREG_au c
            where
                c.KLCLAIM = n.KNCLAIM_ID
        ) c
        cross apply dbo.fn_GetDomainKeys(c.KLDOMAINID, 'CM', 'AU') dk


    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-cba].dbo.clmName with(tablock) t
        using etl_claims_name s on
            s.NameKey = t.NameKey

        when matched then

            update
            set
                ClaimKey = s.ClaimKey,
                NameID = s.NameID,
                ClaimNo = s.ClaimNo,
                Num = s.Num,
                Surname = s.Surname,
                Firstname = s.Firstname,
                Title = s.Title,
                DOB = s.DOB,
                AddressStreet = s.AddressStreet,
                AddressSuburb = s.AddressSuburb,
                AddressState = s.AddressState,
                AddressCountry = s.AddressCountry,
                AddressPostCode = s.AddressPostCode,
                HomePhone = s.HomePhone,
                WorkPhone = s.WorkPhone,
                Fax = s.Fax,
                Email = s.Email,
                isDirectCredit = s.isDirectCredit,
                AccountNo = s.AccountNo,
                AccountName = s.AccountName,
                BSB = s.BSB,
                isPrimary = s.isPrimary,
                isThirdParty = s.isThirdParty,
                isForeign = s.isForeign,
                ProviderID = s.ProviderID,
                BusinessName = s.BusinessName,
                isEmailOK = s.isEmailOK,
                PaymentMethodID = s.PaymentMethodID,
                EMC = s.EMC,
                ITC = s.ITC,
                ITCPCT = s.ITCPCT,
                isGST = s.isGST,
                GSTPercentage = s.GSTPercentage,
                GoodsSupplier = s.GoodsSupplier,
                ServiceProvider = s.ServiceProvider,
                SupplyBy = s.SupplyBy,
                EncryptAccount = s.EncryptAccount,
                EncryptBSB = s.EncryptBSB,
                isPayer = s.isPayer,
                BankName = s.BankName,
                UpdateBatchID = @batchid

        when not matched by target then
            insert
            (
                CountryKey,
                NameKey,
                ClaimKey,
                NameID,
                ClaimNo,
                Num,
                Surname,
                Firstname,
                Title,
                DOB,
                AddressStreet,
                AddressSuburb,
                AddressState,
                AddressCountry,
                AddressPostCode,
                HomePhone,
                WorkPhone,
                Fax,
                Email,
                isDirectCredit,
                AccountNo,
                AccountName,
                BSB,
                isPrimary,
                isThirdParty,
                isForeign,
                ProviderID,
                BusinessName,
                isEmailOK,
                PaymentMethodID,
                EMC,
                ITC,
                ITCPCT,
                isGST,
                GSTPercentage,
                GoodsSupplier,
                ServiceProvider,
                SupplyBy,
                EncryptAccount,
                EncryptBSB,
                isPayer,
                BankName,
                CreateBatchID
            )
            values
            (
                s.CountryKey,
                s.NameKey,
                s.ClaimKey,
                s.NameID,
                s.ClaimNo,
                s.Num,
                s.Surname,
                s.Firstname,
                s.Title,
                s.DOB,
                s.AddressStreet,
                s.AddressSuburb,
                s.AddressState,
                s.AddressCountry,
                s.AddressPostCode,
                s.HomePhone,
                s.WorkPhone,
                s.Fax,
                s.Email,
                s.isDirectCredit,
                s.AccountNo,
                s.AccountName,
                s.BSB,
                s.isPrimary,
                s.isThirdParty,
                s.isForeign,
                s.ProviderID,
                s.BusinessName,
                s.isEmailOK,
                s.PaymentMethodID,
                s.EMC,
                s.ITC,
                s.ITCPCT,
                s.isGST,
                s.GSTPercentage,
                s.GoodsSupplier,
                s.ServiceProvider,
                s.SupplyBy,
                s.EncryptAccount,
                s.EncryptBSB,
                s.isPayer,
                s.BankName,
                @batchid
            )

        output $action into @mergeoutput
        ;

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

        --fix invalid claimant flag (no primary or multiple primaries)
        create index idx_primary on etl_claims_name (ClaimKey) include (NameKey,NameID,isPrimary,isThirdParty)

        update [db-au-cba].dbo.clmName
        set
            isPrimary = 0
        where
            ClaimKey in
            (
                select distinct
                    s.ClaimKey
                from
                    etl_claims_name s
            )

        update [db-au-cba].dbo.clmName
        set
            isPrimary = 1
        where
            NameKey in
            (
                select distinct
                    pcn.NameKey
                from
                    etl_claims_name s
                    cross apply
                    (
                        select top 1
                            NameKey
                        from
                            etl_claims_name pcn
                        where
                            pcn.ClaimKey = s.ClaimKey
                        order by
                            isPrimary desc,
                            isThirdParty,
                            NameID
                    ) pcn
            )

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
            @SourceInfo = 'clmName data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end

GO
