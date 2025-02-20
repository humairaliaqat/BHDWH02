USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_clmAuditClaim_rollup]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_cmdwh_clmAuditClaim_rollup]
as
begin

/*
20121214 - LS - Case 18105
                change from dimension to fact (incremental)
20140805, LS,   T12242 Global Claim
                use batch logging
20140918, LS,   T13338 Claim UTC
20141111, LS,   T14092 Claims.Net Global
                add new UK data set
20150506, LT,	changed PolicyPlanCode length from varchar(6) to varchar(50)                
20160530, LS,	changed GroupName length
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

    if object_id('[db-au-cba].dbo.clmAuditClaim') is null
    begin

        create table [db-au-cba].dbo.clmAuditClaim
        (
            [CountryKey] varchar(2) not null,
            [AuditKey] varchar(50) not null,
            [ClaimKey] varchar(40) not null,
            [AuditUserName] nvarchar(150) null,
            [AuditDateTime] datetime not null,
            [AuditAction] char(1) not null,
            [ClaimNo] int not null,
            [CreatedBy] varchar(30) null,
            [CreateDate] datetime null,
            [OfficerName] nvarchar(150) null,
            [StatusCode] varchar(4) null,
            [StatusDesc] varchar(50) null,
            [ReceivedDate] datetime null,
            [Authorisation] varchar(1) null,
            [ActionDate] datetime null,
            [ActionCode] int null,
            [FinalisedDate] datetime null,
            [ArchiveBox] varchar(20) null,
            [PolicyID] int null,
            [PolicyNo] varchar(50) null,
            [PolicyProduct] varchar(4) null,
            [AgencyCode] varchar(7) null,
            [PolicyPlanCode] varchar(50) null,
            [IntDom] varchar(3) null,
            [Excess] money null,
            [SingleFamily] varchar(1) null,
            [PolicyIssuedDate] datetime null,
            [AccountingDate] datetime null,
            [DepartureDate] datetime null,
            [ArrivalDate] datetime null,
            [NumberOfDays] int null,
            [ITCPremium] float null,
            [EMCApprovalNo] varchar(15) null,
            [GroupPolicy] tinyint null,
            [LuggageFlag] tinyint null,
            [HRisk] tinyint null,
            [CaseNo] varchar(14) null,
            [Comment] ntext null,
            [ClaimProduct] varchar(5) null,
            [ClaimPlan] varchar(10) null,
            [RecoveryType] tinyint null,
            [RecoveryTypeDesc] varchar(255) null,
            [RecoveryOutcome] tinyint null,
            [RecoveryOutcomeDesc] varchar(255) null,
            [CultureCode] nvarchar(10) null,
            [DomainID] int null,
            [BIRowID] int not null identity(1,1),
            [CreateBatchID] int null,
            [UpdateBatchID] int null,
            [AuditDateTimeUTC] datetime null,
            [CreateDateTimeUTC] datetime null,
            [ReceivedDateTimeUTC] datetime null,
            [ActionDateTimeUTC] datetime null,
            [FinalisedDateTimeUTC] datetime null,
			[PolicyOffline] bit null,
			[MasterPolicyNumber] varchar(20) null,
			[GroupName] nvarchar(200) null,
			[AgencyName] nvarchar(200) null
        )

        create clustered index idx_clmAuditClaim_BIRowID on [db-au-cba].dbo.clmAuditClaim(BIRowID)
        create nonclustered index idx_clmAuditClaim_ClaimKey on [db-au-cba].dbo.clmAuditClaim(ClaimKey) include (AuditDateTime,ClaimNo)
        create nonclustered index idx_clmAuditClaim_ClaimNo on [db-au-cba].dbo.clmAuditClaim(ClaimNo,CountryKey) include (AuditDateTime,ClaimKey)
        create nonclustered index idx_clmAuditClaim_AuditDateTime on [db-au-cba].dbo.clmAuditClaim(AuditDateTime) include (ClaimKey)
        create nonclustered index idx_clmAuditClaim_AuditKey on [db-au-cba].dbo.clmAuditClaim(AuditKey)

    end

    if object_id('etl_audit_claims') is not null
        drop table etl_audit_claims

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar, c.KLCLAIM) + '-' + left(c.AUDIT_ACTION, 1) collate database_default + replace(replace(replace(replace(convert(varchar, c.AUDIT_DATETIME, 126), ':', ''), '-', ''), '.', ''), 'T', '') collate database_default + convert(varchar, binary_checksum(*)) AuditKey,
        dk.CountryKey + '-' + convert(varchar, c.KLCLAIM) ClaimKey,
        c.AUDIT_USERNAME AuditUserName,
        c.AUDIT_ACTION AuditAction,
        dbo.xfn_ConvertUTCtoLocal(c.AUDIT_DATETIME, dk.TimeZone) AuditDateTime,
        dbo.xfn_ConvertUTCtoLocal(c.KLCREATED, dk.TimeZone) CreateDate,
        dbo.xfn_ConvertUTCtoLocal(c.KLRECEIVED, dk.TimeZone) ReceivedDate,
        dbo.xfn_ConvertUTCtoLocal(c.KLACTIONDATE, dk.TimeZone) ActionDate,
        dbo.xfn_ConvertUTCtoLocal(c.KLFINALDATE, dk.TimeZone) FinalisedDate,
        c.AUDIT_DATETIME AuditDateTimeUTC,
        c.KLCREATED CreateDateTimeUTC,
        c.KLRECEIVED ReceivedDateTimeUTC,
        c.KLACTIONDATE ActionDateTimeUTC,
        c.KLFINALDATE FinalisedDateTimeUTC,
        c.KLCLAIM ClaimNo,
        (
            select top 1
                KSNAME
            from
                claims_klsecurity_au
            where
                KS_ID = c.KLCREATEDBY_ID
        ) CreatedBy,
        (
            select top 1
                KSNAME
            from
                claims_klsecurity_au
            where
                KS_ID = c.KLOFFICER_ID
        ) OfficerName,
        cs.StatusCode,
        cs.StatusDesc,
        c.KLAUTH Authorisation,
        c.KLACTION ActionCode,
        c.KLARCBOX ArchiveBox,
        c.KLPOL_ID PolicyID,
        c.KLPOLICY PolicyNo,
        c.KLPRODUCT PolicyProduct,
        c.KLALPHA AgencyCode,
        c.KLPLAN PolicyPlanCode,
        c.KLINTDOM IntDom,
        c.KLEXCESS Excess,
        c.KLSF SingleFamily,
        c.KLDISS PolicyIssuedDate,
        c.KLACT AccountingDate,
        c.KLDEP DepartureDate,
        c.KLRET ArrivalDate,
        c.KLDAYS NumberOfDays,
        c.KLITCPREM ITCPremium,
        convert(varchar(15), c.KLEMCAPPROV) EMCApprovalNo,
        c.KLGROUPPOL GroupPolicy,
        c.KLLUGG LuggageFlag,
        c.KLHRISK HRisk,
        c.KLCASE CaseNo,
        c.KLCOMMENT Comment,
        (
            select top 1
                KPPRODUCT
            from
                claims_klproducts_au
            where
                KPProd_ID = c.KLPROD_ID
        ) ClaimProduct,
        (
            select top 1
                KLPLANCODE
            from
                claims_klproductplan_au
            where
                KLPLAN_ID = c.KLPLAN_ID
        ) ClaimPlan,
        c.KLRECOVERY RecoveryType,
        null RecoveryTypeDesc,
        c.KLREC_OUTCOMEID RecoveryOutcome,
        (
            select top 1
                KTDESC
            from
                claims_klstatus_au
            where
                KT_ID = c.KLREC_OUTCOMEID
        ) RecoveryOutcomeDesc,
        c.CultureCode,
        c.KLDOMAINID DomainID,
		NULL KLPolicyOffline,
		NULL KLMASTERPOLICYNUMBER,
		NULL KLGroupName,
		NULL KLAgencyName
    into etl_audit_claims
    from
        claims_AUDIT_KLREG_au c
        --audit data wasn't updated with domain information
        cross apply
        (
            select top 1
                KLDOMAINID
            from
                claims_KLREG_au dc
            where
                dc.KLCLAIM = c.KLCLAIM
        ) dc
        cross apply dbo.fn_GetDomainKeys(dc.KLDOMAINID, 'CM', 'AU') dk
        outer apply
        (
            select top 1
                KTSTATUS StatusCode,
                KTDESC StatusDesc
            from
                claims_klstatus_au
            where
                KT_ID = c.KLSTATUS_ID and
                KTTABLE = 'KLREG'
        ) cs
        



    set @sourcecount = @@rowcount

    begin transaction

    begin try

        merge into [db-au-cba].dbo.clmAuditClaim with(tablock) t
        using etl_audit_claims s on
            s.AuditKey = t.AuditKey

        when
            matched and
            s.AuditUserName <> 'adm_brankos' /* 216 duplicate manual audit entires done by Branko, skip */
        then

            update
            set
                ClaimKey = s.ClaimKey,
                AuditUserName = s.AuditUserName,
                AuditDateTime = s.AuditDateTime,
                AuditAction = s.AuditAction,
                ClaimNo = s.ClaimNo,
                CreatedBy = s.CreatedBy,
                CreateDate = s.CreateDate,
                OfficerName = s.OfficerName,
                StatusCode = s.StatusCode,
                StatusDesc = s.StatusDesc,
                ReceivedDate = s.ReceivedDate,
                Authorisation = s.Authorisation,
                ActionDate = s.ActionDate,
                ActionCode = s.ActionCode,
                FinalisedDate = s.FinalisedDate,
                ArchiveBox = s.ArchiveBox,
                PolicyID = s.PolicyID,
                PolicyNo = s.PolicyNo,
                PolicyProduct = s.PolicyProduct,
                AgencyCode = s.AgencyCode,
                PolicyPlanCode = s.PolicyPlanCode,
                IntDom = s.IntDom,
                Excess = s.Excess,
                SingleFamily = s.SingleFamily,
                PolicyIssuedDate = s.PolicyIssuedDate,
                AccountingDate = s.AccountingDate,
                DepartureDate = s.DepartureDate,
                ArrivalDate = s.ArrivalDate,
                NumberOfDays = s.NumberOfDays,
                ITCPremium = s.ITCPremium,
                EMCApprovalNo = s.EMCApprovalNo,
                GroupPolicy = s.GroupPolicy,
                LuggageFlag = s.LuggageFlag,
                HRisk = s.HRisk,
                CaseNo = s.CaseNo,
                Comment = s.Comment,
                ClaimProduct = s.ClaimProduct,
                ClaimPlan = s.ClaimPlan,
                RecoveryType = s.RecoveryType,
                RecoveryTypeDesc = s.RecoveryTypeDesc,
                RecoveryOutcome = s.RecoveryOutcome,
                RecoveryOutcomeDesc = s.RecoveryOutcomeDesc,
                CultureCode = s.CultureCode,
                DomainID = s.DomainID,
                AuditDateTimeUTC = s.AuditDateTimeUTC,
                CreateDateTimeUTC = s.CreateDateTimeUTC,
                ReceivedDateTimeUTC = s.ReceivedDateTimeUTC,
                ActionDateTimeUTC = s.ActionDateTimeUTC,
                FinalisedDateTimeUTC = s.FinalisedDateTimeUTC,
                UpdateBatchID = @batchid,
				PolicyOffline = KLPolicyOffline,
				MasterPolicyNumber = s.KLMasterPolicyNumber,
				GroupName = s.KLGroupName,
				Agencyname = s.KLAgencyName

        when not matched by target then
            insert
            (
                CountryKey,
                AuditKey,
                ClaimKey,
                AuditUserName,
                AuditDateTime,
                AuditAction,
                ClaimNo,
                CreatedBy,
                CreateDate,
                OfficerName,
                StatusCode,
                StatusDesc,
                ReceivedDate,
                Authorisation,
                ActionDate,
                ActionCode,
                FinalisedDate,
                ArchiveBox,
                PolicyID,
                PolicyNo,
                PolicyProduct,
                AgencyCode,
                PolicyPlanCode,
                IntDom,
                Excess,
                SingleFamily,
                PolicyIssuedDate,
                AccountingDate,
                DepartureDate,
                ArrivalDate,
                NumberOfDays,
                ITCPremium,
                EMCApprovalNo,
                GroupPolicy,
                LuggageFlag,
                HRisk,
                CaseNo,
                Comment,
                ClaimProduct,
                ClaimPlan,
                RecoveryType,
                RecoveryTypeDesc,
                RecoveryOutcome,
                RecoveryOutcomeDesc,
                CultureCode,
                DomainID,
                AuditDateTimeUTC,
                CreateDateTimeUTC,
                ReceivedDateTimeUTC,
                ActionDateTimeUTC,
                FinalisedDateTimeUTC,
                CreateBatchID,
				PolicyOffline,
				MasterPolicyNumber,
				GroupName,
				AgencyName
            )
            values
            (
                s.CountryKey,
                s.AuditKey,
                s.ClaimKey,
                s.AuditUserName,
                s.AuditDateTime,
                s.AuditAction,
                s.ClaimNo,
                s.CreatedBy,
                s.CreateDate,
                s.OfficerName,
                s.StatusCode,
                s.StatusDesc,
                s.ReceivedDate,
                s.Authorisation,
                s.ActionDate,
                s.ActionCode,
                s.FinalisedDate,
                s.ArchiveBox,
                s.PolicyID,
                s.PolicyNo,
                s.PolicyProduct,
                s.AgencyCode,
                s.PolicyPlanCode,
                s.IntDom,
                s.Excess,
                s.SingleFamily,
                s.PolicyIssuedDate,
                s.AccountingDate,
                s.DepartureDate,
                s.ArrivalDate,
                s.NumberOfDays,
                s.ITCPremium,
                s.EMCApprovalNo,
                s.GroupPolicy,
                s.LuggageFlag,
                s.HRisk,
                s.CaseNo,
                s.Comment,
                s.ClaimProduct,
                s.ClaimPlan,
                s.RecoveryType,
                s.RecoveryTypeDesc,
                s.RecoveryOutcome,
                s.RecoveryOutcomeDesc,
                s.CultureCode,
                s.DomainID,
                s.AuditDateTimeUTC,
                s.CreateDateTimeUTC,
                s.ReceivedDateTimeUTC,
                s.ActionDateTimeUTC,
                s.FinalisedDateTimeUTC,
                @batchid,
				s.KLPolicyOffline,
				s.KLMasterPolicyNumber,
				s.KLGroupName,
				s.KLAgencyName
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
            @SourceInfo = 'clmAuditClaim data refresh failed',
            @LogToTable = 1,
            @ErrorCode = '-100',
            @BatchID = @batchid,
            @PackageID = @name

    end catch

    if @@trancount > 0
        commit transaction

end




GO
