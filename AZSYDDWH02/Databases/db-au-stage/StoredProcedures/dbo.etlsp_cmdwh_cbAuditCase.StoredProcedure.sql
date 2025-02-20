USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_cbAuditCase]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_cbAuditCase]
as
begin


/*
20131014, LS,   add new risk columns
                flag deleted cases on main table based on audit action
20131129, LS,   read case type from master table
20131202, LS,    case management
20131216, LS,   bug fix, invalid expire dates
20140225, LS,   lookup program description from master table
                CaseType set to blank when null
20140331, LS,   bug fix, invalid departure dates
20140410, LS,   fix policy link
20140711, LS,   TFS 12109
                unicode, column width
20140714, LS,   TFS12109
                lookup master data for incident & catastrophe
20140715, LS,   use transaction (as carebase has intra-day refreshes)
20140820, LS,   use Client's DomainCode for Country
20150720, LS,   T16930, Carebase 4.6, additional columns
20151020, LT,   added error trapping for CC.POLICY_NO and CC.POLICYNO2
20161203, LT,	added more error trapping for CC.POLICY_NO and CC.POLICYNO2
*/


    set nocount on

    exec etlsp_StagingIndex_Carebase

    /* case */
    if object_id('[db-au-cba].dbo.cbAuditCase') is null
    begin

        create table [db-au-cba].dbo.cbAuditCase
        (
            [BIRowID] bigint not null identity(1,1),
            [AuditUser] nvarchar(255) null,
            [AuditDateTime] datetime null,
            [AuditDateTimeUTC] datetime null,
            [AuditAction] nvarchar(10) null,
            [CountryKey] nvarchar(2) not null,
            [CaseKey] nvarchar(20) not null,
            [LinkedCaseKey] nvarchar(20) null,
            [OpenedByKey] nvarchar(35) null,
            [ClosedByKey] nvarchar(35) null,
            [CaseNo] nvarchar(15) not null,
            [LinkedCaseNo] nvarchar(15) null,
            [CreateDate] datetime null,
            [CreateTimeUTC] datetime null,
            [OpenDate] datetime null,
            [OpenTime] datetime null,
            [OpenTimeUTC] datetime null,
            [CloseDate] datetime null,
            [CloseTimeUTC] datetime null,
            [FirstCloseDate] datetime null,
            [FirstCloseTimeUTC] datetime null,
            [FirstClosedByID] nvarchar(30) null,
            [FirstClosedBy] nvarchar(55) null,
            [OpenedByID] nvarchar(30) null,
            [OpenedBy] nvarchar(55) null,
            [ClosedByID] nvarchar(30) null,
            [ClosedBy] nvarchar(55) null,
            [TimeInCase] numeric(9,3) null,
            [Team] nvarchar(50) null,
            [CaseStatus] nvarchar(10) null,
            [CaseType] nvarchar(255) null,
            [CaseCode] nvarchar(5) null,
            [CaseDescription] nvarchar(4000) null,
            [TotalEstimate] int null,
            [IsDeleted] bit null,
            [DisorderType] nvarchar(100) null,
            [DisorderSubType] nvarchar(100) null,
            [MedicalCode] nvarchar(10) null,
            [DiagnosticCategory] nvarchar(250) null,
            [ARDRGRange] nvarchar(15) null,
            [MedicalSurgical] nvarchar(10) not null,
            [ResearchSpecific] nvarchar(100) null,
            [DisasterDate] datetime null,
            [Disaster] nvarchar(100) null,
            [DisasterCountry] nvarchar(25) null,
            [FirstName] nvarchar(100) null,
            [Surname] nvarchar(100) null,
            [Sex] nvarchar(1) null,
            [DOB] varbinary(100) null,
            [Location] nvarchar(200) null,
            [CountryCode] nvarchar(3) null,
            [Country] nvarchar(25) null,
            [ProtocolCode] nvarchar(1) null,
            [Protocol] nvarchar(10) not null,
            [ClientCode] nvarchar(2) null,
            [ClientName] nvarchar(100) null,
            [ProgramCode] nvarchar(2) null,
            [Program] nvarchar(35) null,
            [IncidentType] nvarchar(60) null,
            [ClaimNo] nvarchar(40) null,
            [Catastrophe] nvarchar(50) null,
            [UWCoverID] int null,
            [UWCoverStatus] nvarchar(100) null,
            [RiskLevel] nvarchar(50) null,
            [RiskReason] nvarchar(100) null,
            [isClosed] bit null,
            [isReopened] bit null,
            [isCaseTypeChanged] bit null,
            [isTotalEstimateChanged] bit null,
            [isProtocolChanged] bit null,
            [isIncidentTypeChanged] bit null,
            [isUWCoverChanged] bit null,
            [PreviousEstimate] int null,
            [PreviousCaseType] nvarchar(255) null,
            [PreviousProtocol] nvarchar(10) null,
            [PreviousIncidentType] nvarchar(60) null,
            [PreviousUWCoverStatus] nvarchar(100) null,
            [CultureCode] nvarchar(10) null,
            [CaseFee] money,
            [HasReviewCheck] bit,
            [HasReviewCompleted] bit,
            [HasSoughtMedicalCare] bit,
            [IsCustomerHospitalised] bit,
            [HasMedicalSteerageOccured] bit,
            [isMedicalSteerageChanged] bit null,
            [PreviousSoughtMedicalCare] bit,
            [PreviousCustomerHospitalised] bit,
            [PreviousMedicalSteerageOccured] bit,
            [isCaseFeeChanged] bit null,
            [PreviousCaseFee] money
        )

        create clustered index idx_cbAuditCase_BIRowID on [db-au-cba].dbo.cbAuditCase(BIRowID)
        create nonclustered index idx_cbAuditCase_AuditDateTime on [db-au-cba].dbo.cbAuditCase(AuditDateTime) include (CaseKey,AuditDateTimeUTC,IsDeleted,isClosed,isReopened,isCaseTypeChanged,isTotalEstimateChanged,isProtocolChanged,isIncidentTypeChanged,isUWCoverChanged,BIRowID,AuditAction)
        create nonclustered index idx_cbAuditCase_CaseKey on [db-au-cba].dbo.cbAuditCase(CaseKey,isUWCoverChanged) include (AuditDateTime,CreateDate,UWCoverStatus,IsDeleted,isClosed,isReopened,isCaseTypeChanged,isTotalEstimateChanged,isProtocolChanged,isIncidentTypeChanged,BIRowID,AuditUser)
        create nonclustered index idx_cbAuditCase_CaseNo on [db-au-cba].dbo.cbAuditCase(CaseNo)
        create nonclustered index idx_cbAuditCase_isCaseTypeChanged on [db-au-cba].dbo.cbAuditCase(isCaseTypeChanged,AuditDateTime)
        create nonclustered index idx_cbAuditCase_isClosed on [db-au-cba].dbo.cbAuditCase(isClosed,AuditDateTime)
        create nonclustered index idx_cbAuditCase_isIncidentTypeChanged on [db-au-cba].dbo.cbAuditCase(isIncidentTypeChanged,AuditDateTime)
        create nonclustered index idx_cbAuditCase_isProtocolChanged on [db-au-cba].dbo.cbAuditCase(isProtocolChanged,AuditDateTime)
        create nonclustered index idx_cbAuditCase_isReopened on [db-au-cba].dbo.cbAuditCase(isReopened,AuditDateTime)
        create nonclustered index idx_cbAuditCase_isTotalEstimateChanged on [db-au-cba].dbo.cbAuditCase(isTotalEstimateChanged,AuditDateTime)
        create nonclustered index idx_cbAuditCase_isUWCoverChanged on [db-au-cba].dbo.cbAuditCase(isUWCoverChanged,AuditDateTime)

    end

    if object_id('tempdb..#cbAuditCase') is not null
        drop table #cbAuditCase

    select
        AUDIT_USERNAME AuditUser,
        dbo.xfn_ConvertUTCtoLocal(AUDIT_DATETIME, 'AUS Eastern Standard Time') AuditDateTime,
        AUDIT_DATETIME AuditDateTimeUTC,
        AUDIT_ACTION AuditAction,
        isnull(DomainCountry, 'AU') CountryKey,
        left('AU-' + CASE_NO, 20) CaseKey,
        left('AU-' + LINKCASE_NO, 20) LinkedCaseKey,
        left('AU-' + AC, 35) OpenedByKey,
        left('AU-' + CLOSED_BY, 35) ClosedByKey,
        CASE_NO CaseNo,
        LINKCASE_NO LinkedCaseNo,
        dbo.xfn_ConvertUTCtoLocal(CREATED_DT, 'AUS Eastern Standard Time') CreateDate,
        CREATED_DT CreateTimeUTC,
        convert(date, dbo.xfn_ConvertUTCtoLocal(OPEN_DATE, 'AUS Eastern Standard Time')) OpenDate,
        dbo.xfn_ConvertUTCtoLocal(OPEN_DATE, 'AUS Eastern Standard Time') OpenTime,
        OPEN_DATE OpenTimeUTC,
        dbo.xfn_ConvertUTCtoLocal(CLOSE_DATE, 'AUS Eastern Standard Time') CloseDate,
        CLOSE_DATE CloseTimeUTC,
        AC OpenedByID,
        OpenedBy,
        CLOSED_BY ClosedByID,
        ClosedBy,
        TimeInCase,
        Team,
        case
            when STATUS = 'C' then 'Closed'
            when STATUS = 'O' then 'Open'
            when STATUS = 'T' then 'Incomplete'
        end CaseStatus,
        isnull(ct.CT_DESCRIPTION, '') CaseType,
        CASE_CODE CaseCode,
        case_descript CaseDescription,
        TOT_EST TotalEstimate,
        case
            when DELETED = 'Y' then 1
            else 0
        end IsDeleted,
        DisorderType,
        DisorderSubType,
        MedicalCode,
        DiagnosticCategory,
        ARDRGRange,
        case
            when MEDICAL_SURGICAL = 'M' then 'Medical'
            else 'Surgical'
        end MedicalSurgical,
        RESEARCH_SPECIFIC ResearchSpecific,
        DisasterDate,
        Disaster,
        DIsasterCountry,

        /* customer details */
        FIRST FirstName,
        SURNAME Surname,
        Sex,
        EncryptDOB DOB,
        LOC_DESC Location,
        CNTRY_CODE CountryCode,
        Country,

        /* claim details */
        PROB_TYPE ProtocolCode,
        case
            when PROB_TYPE = 'M' then 'Medical'
            when PROB_TYPE = 'T' then 'Technical'
            else 'Undefined'
        end Protocol,
        CLI_CODE ClientCode,
        ClientName,
        POL_CODE ProgramCode,
        ProgramDescription Program,
        isnull(IncidentType, INCIDENT_TYPE) IncidentType,
        CLAIM_NUM ClaimNo,
        isnull(Catastrophe, CAT_CODE) Catastrophe,
        UWCOVERSTATUS_ID UWCoverID,
        UWCoverStatus,
        RiskLevel,
        RiskReason,
        CultureCode,
        Case_Fee CaseFee,
        HasReviewCheck,
        HasReviewCompleted,
        MedicalCareSort HasSoughtMedicalCare,
        CustomerHospitalised IsCustomerHospitalised,
        MedicalSteerageOccured HasMedicalSteerageOccured
    into #cbAuditCase
    from
        carebase_AUDIT_CMN_MAIN_aucm cm
        left join carebase_UCT_CASETYPE_aucm ct on
            ct.CT_ID = cm.CASETYPE_ID
        outer apply
        (
            select top 1
                CLI_DESC ClientName,
                DomainCode DomainCountry
            from
                carebase_PCL_CLIENT_aucm cl
            where
                cl.CLI_CODE = cm.CLI_CODE
        ) cl
        outer apply
        (
            select top 1
                CNTRY_DESC Country
            from
                carebase_UCO_COUNTRY_aucm co
            where
                co.CNTRY_CODE = cm.CNTRY_CODE
        ) co
        outer apply
        (
            select top 1
                PREF_NAME + ' ' + SURNAME OpenedBy
            from
                carebase_ADM_USER_aucm u
            where
                u.USERID = cm.AC
        ) ob
        outer apply
        (
            select top 1
                PREF_NAME + ' ' + SURNAME ClosedBy
            from
                carebase_ADM_USER_aucm u
            where
                u.USERID = cm.CLOSED_BY
        ) cb
        outer apply
        (
            select top 1
                DISORDERDESC DisorderType
            from
                carebase_DISORDER_TYPE_aucm dt
            where
                dt.DISORDER_ID = cm.DISORDER_TYPE
        ) dt
        outer apply
        (
            select top 1
                SUBTYPEDESC DisorderSubType
            from
                carebase_DISORDER_SUBTYPE_aucm dst
            where
                dst.SUBTYPEID = cm.DISORDER_SUBTYPE
        ) dst
        outer apply
        (
            select top 1
                MDC MedicalCode,
                MDC_DESCRIPTION DiagnosticCategory,
                AR_DRG_RANGE ARDRGRange
            from
                carebase_DIAGNOSTIC_CATEGORY_aucm dx
            where
                dx.DX_CAT_ID = cm.DX_CAT_ID
        ) dx
        outer apply
        (
            select top 1
                DISASTER_DATE DisasterDate,
                DISASTER_DESC Disaster,
                CNTRY_DESC DIsasterCountry
            from
                carebase_DISASTERS_aucm ds
                left join carebase_UCO_COUNTRY_aucm co on
                    co.CNTRY_CODE = ds.CNTRY_CODE
            where
                ds.DISASTER_ID = cm.DISASTER_ID
        ) ds
        outer apply
        (
            select top 1
                TEAM_DESC Team
            from
                carebase_TEAMS_aucm tm
                inner join carebase_TEAMS_CLIENT_aucm tc on
                    tc.TEAM_ID = tm.TEAM_ID
            where
                tc.CLI_CODE = cm.CLI_CODE
        ) tm
        outer apply
        (
            select top 1
                [DESCRIPTION] UWCoverStatus
            from
                carebase_tblUWCoverStatus_aucm uw
            where
                uw.UWCOVERSTATUS_ID = cm.UWCOVERSTATUS_ID
        ) uw
        outer apply
        (
            select top 1
                rl.DESCRIPTION RiskLevel
            from
                carebase_tblRiskLevels_aucm rl
            where
                rl.RISKLEVEL_ID = cm.RISKLEVEL_ID
        ) rl
        outer apply
        (
            select top 1
                rr.DESCRIPTION RiskReason
            from
                carebase_tblRiskReasons_aucm rr
            where
                rr.RISKREASON_ID = cm.RISKREASON_ID
        ) rr
        outer apply
        (
            select top 1
                pd.POL_DESC ProgramDescription
            from
                carebase_POL_POLICY_aucm pd
            where
                pd.CLI_CODE = cm.CLI_CODE and
                pd.POL_CODE = cm.POL_CODE
        ) pd
        outer apply
        (
            select top 1
                it.INCIDENT_TYPE IncidentType
            from
                carebase_NIT_INCIDENTTYPE_aucm it
            where
                it.ID = cm.INCIDENTTYPE_ID
        ) it
        outer apply
        (
            select top 1
                cat.CAT_CODE Catastrophe
            from
                carebase_tblClientCatCodes_aucm cat
            where
                cat.CATCODE_ID = cm.CATCODE_ID
        ) cat

    begin transaction cbAuditCase

    begin try

        delete c
        from
            [db-au-cba].dbo.cbAuditCase c
            inner join carebase_AUDIT_CMN_MAIN_aucm r on
                c.CaseKey = left('AU-' + r.CASE_NO, 20) collate database_default and
                c.AuditDateTimeUTC = r.AUDIT_DATETIME

        insert into [db-au-cba].dbo.cbAuditCase with(tablock)
        (
            AuditUser,
            AuditDateTime,
            AuditDateTimeUTC,
            AuditAction,
            CountryKey,
            CaseKey,
            LinkedCaseKey,
            OpenedByKey,
            ClosedByKey,
            CaseNo,
            LinkedCaseNo,
            CreateDate,
            CreateTimeUTC,
            OpenDate,
            OpenTime,
            OpenTimeUTC,
            CloseDate,
            CloseTimeUTC,
            OpenedByID,
            OpenedBy,
            ClosedByID,
            ClosedBy,
            TimeInCase,
            Team,
            CaseStatus,
            CaseType,
            CaseCode,
            CaseDescription,
            TotalEstimate,
            IsDeleted,
            DisorderType,
            DisorderSubType,
            MedicalCode,
            DiagnosticCategory,
            ARDRGRange,
            MedicalSurgical,
            ResearchSpecific,
            DisasterDate,
            Disaster,
            DisasterCountry,
            FirstName,
            Surname,
            Sex,
            DOB,
            Location,
            CountryCode,
            Country,
            ProtocolCode,
            Protocol,
            ClientCode,
            ClientName,
            ProgramCode,
            Program,
            IncidentType,
            ClaimNo,
            Catastrophe,
            UWCoverID,
            UWCoverStatus,
            RiskLevel,
            RiskReason,
            CultureCode,
            CaseFee,
            HasReviewCheck,
            HasReviewCompleted,
            HasSoughtMedicalCare,
            IsCustomerHospitalised,
            HasMedicalSteerageOccured
        )
        select
            AuditUser,
            AuditDateTime,
            AuditDateTimeUTC,
            AuditAction,
            CountryKey,
            CaseKey,
            LinkedCaseKey,
            OpenedByKey,
            ClosedByKey,
            CaseNo,
            LinkedCaseNo,
            CreateDate,
            CreateTimeUTC,
            OpenDate,
            OpenTime,
            OpenTimeUTC,
            CloseDate,
            CloseTimeUTC,
            OpenedByID,
            OpenedBy,
            ClosedByID,
            ClosedBy,
            TimeInCase,
            Team,
            CaseStatus,
            CaseType,
            CaseCode,
            CaseDescription,
            TotalEstimate,
            IsDeleted,
            DisorderType,
            DisorderSubType,
            MedicalCode,
            DiagnosticCategory,
            ARDRGRange,
            MedicalSurgical,
            ResearchSpecific,
            DisasterDate,
            Disaster,
            DisasterCountry,
            FirstName,
            Surname,
            Sex,
            DOB,
            Location,
            CountryCode,
            Country,
            ProtocolCode,
            Protocol,
            ClientCode,
            ClientName,
            ProgramCode,
            Program,
            IncidentType,
            ClaimNo,
            Catastrophe,
            UWCoverID,
            UWCoverStatus,
            RiskLevel,
            RiskReason,
            CultureCode,
            CaseFee,
            HasReviewCheck,
            HasReviewCompleted,
            HasSoughtMedicalCare,
            IsCustomerHospitalised,
            HasMedicalSteerageOccured
        from
            #cbAuditCase

    end try

    begin catch

        if @@trancount > 0
            rollback transaction cbAuditCase

        exec syssp_genericerrorhandler 'cbAuditCase data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction cbAuditCase


    /* flag deleted cases */
    update c
    set
        IsDeleted = 1
    from
        [db-au-cba].dbo.cbCase c
        inner join carebase_AUDIT_CMN_MAIN_aucm r on
            c.CaseKey = left('AU-' + r.CASE_NO, 20) collate database_default and
            r.AUDIT_ACTION = 'D'

    /* update flags */
    update c
    set
        isClosed =
            case
                when c.CaseStatus = 'Closed' and isnull(pac.CaseStatus, 'Open') = 'Open' then 1
                else 0
            end,
        isReopened =
            case
                when c.CaseStatus = 'Open' and isnull(pac.CaseStatus, 'Open') = 'Closed' then 1
                else 0
            end,
        isCaseTypeChanged =
            case
                when c.CaseType <> isnull(pac.CaseType, '') then 1
                else 0
            end,
        isTotalEstimateChanged =
            case
                when c.TotalEstimate <> isnull(pac.TotalEstimate, 0) then 1
                else 0
            end,
        isProtocolChanged =
            case
                when c.Protocol <> isnull(pac.Protocol, '') then 1
                else 0
            end,
        isIncidentTypeChanged =
            case
                when c.IncidentType <> isnull(pac.IncidentType, '') then 1
                else 0
            end,
        isUWCoverChanged =
            case
                when c.UWCoverStatus <> isnull(pac.UWCoverStatus, '') then 1
                else 0
            end,
        PreviousCaseType = pac.CaseType,
        PreviousEstimate = pac.TotalEstimate,
        PreviousProtocol = pac.Protocol,
        PreviousIncidentType = pac.IncidentType,
        PreviousUWCoverStatus = pac.UWCoverStatus,
        isMedicalSteerageChanged =
            case
                when c.HasSoughtMedicalCare <> isnull(pac.HasSoughtMedicalCare, 0) then 1
                when c.IsCustomerHospitalised <> isnull(pac.IsCustomerHospitalised, 0) then 1
                when c.HasMedicalSteerageOccured <> isnull(pac.HasMedicalSteerageOccured, 0) then 1
            end,
        PreviousSoughtMedicalCare = pac.HasSoughtMedicalCare,
        PreviousCustomerHospitalised = pac.IsCustomerHospitalised,
        PreviousMedicalSteerageOccured = pac.HasMedicalSteerageOccured,
        PreviousCaseFee = pac.CaseFee,
        isCaseFeeChanged = 
            case
                when c.CaseFee <> isnull(pac.CaseFee, 0) then 1
                else 0
            end
    from
        [db-au-cba].dbo.cbAuditCase c
        inner join carebase_AUDIT_CMN_MAIN_aucm r on
            c.CaseKey = left('AU-' + r.CASE_NO, 20) collate database_default and
            c.AuditDateTime = dbo.xfn_ConvertUTCtoLocal(r.AUDIT_DATETIME, 'AUS Eastern Standard Time')
        outer apply
        (
            select top 1
                pac.CaseStatus,
                pac.CaseType,
                pac.TotalEstimate,
                pac.Protocol,
                pac.IncidentType,
                pac.UWCoverStatus,
                pac.HasSoughtMedicalCare,
                pac.IsCustomerHospitalised,
                pac.HasMedicalSteerageOccured,
                pac.CaseFee
            from
                [db-au-cba].dbo.cbAuditCase pac
            where
                pac.CaseKey = c.CaseKey and
                pac.AuditDateTime < c.AuditDateTime
            order by
                pac.AuditDateTime desc
        ) pac
    where
        c.AuditAction = 'U'


    /* policy */
    if object_id('[db-au-cba].dbo.cbAuditPolicy') is null
    begin

        create table [db-au-cba].dbo.cbAuditPolicy
        (
            [BIRowID] bigint not null identity(1,1),
            [AuditUser] nvarchar(255) null,
            [AuditDateTime] datetime null,
            [AuditDateTimeUTC] datetime null,
            [AuditAction] nvarchar(10) null,
            [CountryKey] nvarchar(2) not null,
            [CaseKey] nvarchar(20) not null,
            [TRIPSPolicyKey] nvarchar(41) null,
            [PolicyTransactionKey] nvarchar(41) null,
            [CaseNo] nvarchar(15) not null,
            [IsMainPolicy] bit not null,
            [PolicyNo] nvarchar(25) null,
            [IssueDate] datetime null,
            [ExpiryDate] datetime null,
            [VerifyDate] datetime null,
            [VerifiedBy] nvarchar(10) null,
            [ConsultantInitial] nvarchar(30) null,
            [PolicyType] nvarchar(25) null,
            [SingleFamily] nvarchar(15) null,
            [PlanCode] nvarchar(15) null,
            [DepartureDate] datetime null,
            [InsurerName] nvarchar(20) null,
            [Excess] int null,
            [ProductCode] nvarchar(3) null
        )

        create clustered index idx_cbAuditPolicy_BIRowID on [db-au-cba].dbo.cbAuditPolicy(BIRowID)
        create nonclustered index idx_cbAuditPolicy_AuditDateTime on [db-au-cba].dbo.cbAuditPolicy(AuditDateTime)
        create nonclustered index idx_cbAuditPolicy_CaseKey on [db-au-cba].dbo.cbAuditPolicy(CaseKey,AuditDateTime)

    end

    if object_id('tempdb..#cbAuditPolicy') is not null
        drop table #cbAuditPolicy

    select
        AUDIT_USERNAME AuditUser,
        convert(date, dbo.xfn_ConvertUTCtoLocal(AUDIT_DATETIME, 'AUS Eastern Standard Time')) AuditDateTime,
        AUDIT_DATETIME AuditDateTimeUTC,
        AUDIT_ACTION AuditAction,
        'AU' CountryKey,
        left('AU-' + CASE_NO, 20) CaseKey,
        p.TRIPSPolicyKey,
        pp.PolicyTransactionKey,
        CASE_NO CaseNo,
        1 IsMainPolicy,
        POLICY_NO PolicyNo,
        ISSUED IssueDate,
        case
            when year(EXPIRES) < 1900 then null
            else EXPIRES
        end ExpiryDate,
        DATE_VER1 VerifyDate,
        VER_BY1 VerifiedBy,
        POL_AC1 ConsultantInitial,
        TYPE_POL PolicyType,
        FAM_SING SingleFamily,
        POL_PLAN PlanCode,
        case
            when year(DEP_DATE) < 1900 then null
            else DEP_DATE
        end DepartureDate,
        NAME_INS1 InsurerName,
        POL_EXCESS Excess,
        CM_PRODCODE ProductCode
    into #cbAuditPolicy
    from
        carebase_AUDIT_CMN_MAIN_aucm cc
        cross apply
        (
            select
                case
                    when CLI_CODE in ('AI', 'AW', 'MN', 'NZ', 'TZ', 'WE') then 'NZ'
                    when CLI_CODE in ('UK') then 'UK'
                    when CLI_CODE in ('MM') then 'MY'
                    when CLI_CODE in ('MS') then 'SG'
                    else 'AU'
                end CountryKey,
                case
                    when CLI_CODE in ('AA', 'AU', 'ME') then 'TIP'
                    else 'CM'
                end CompanyKey
        ) keys
        outer apply
        (
            select top 1
                PolicyKey TRIPSPolicyKey
            from
                [db-au-cba].dbo.penPolicy p
            where
                p.CountryKey = keys.CountryKey and
                p.PolicyNumber = case
								when ltrim(rtrim(cc.POLICY_NO)) is null then null
								when ltrim(rtrim(cc.POLICY_NO)) like '% %' then null
								when ltrim(rtrim(cc.POLICY_NO)) like '%	%' then null
								when ltrim(rtrim(cc.POLICY_NO)) like '%  %' then null
								when ltrim(rtrim(cc.POLICY_NO)) like '%(%' then null
								when ltrim(rtrim(cc.POLICY_NO)) like '%)%' then null
								when ltrim(rtrim(cc.POLICY_NO)) like '%.%' then null
								when ltrim(rtrim(cc.POLICY_NO)) like '%,%' then null
								when ltrim(rtrim(cc.POLICY_NO)) like '%$%' then null
								when ltrim(rtrim(cc.POLICY_NO)) like '%\%' then null                                        --20151022_LT added error trapping for \
								when isnumeric(ltrim(rtrim(cc.POLICY_NO))) = 1 and len(ltrim(rtrim(cc.POLICY_NO))) < 10 then
									convert(varchar(25), cc.POLICY_NO)
								else null
							end collate database_default
        ) p
        outer apply
        (
            select top 1
                PolicyTransactionKey
            from
                [db-au-cba].dbo.penPolicyTransSummary pt
            where
                pt.CountryKey = keys.CountryKey and
                pt.PolicyNumber = convert(varchar(25),cc.POLICY_NO) collate database_default
        ) pp

    union all

    select
        AUDIT_USERNAME AuditUser,
        convert(date, dbo.xfn_ConvertUTCtoLocal(AUDIT_DATETIME, 'AUS Eastern Standard Time')) AuditDateTime,
        AUDIT_DATETIME AuditDateTimeUTC,
        AUDIT_ACTION AuditAction,
        'AU' CountryKey,
        left('AU-' + CASE_NO, 20) CaseKey,
        p.TRIPSPolicyKey,
        pp.PolicyTransactionKey,
        CASE_NO CaseNo,
        0 IsMainPolicy,
        POLICYNO2 PolicyNo,
        ISSUED2 IssueDate,
        case
            when year(EXPIRES2) < 1900 then null
            else EXPIRES2
        end ExpiryDate,
        DATE_VER2 VerifyDate,
        VER_BY2 VerifiedBy,
        POL_AC2 ConsultantInitial,
        TYPE_POL2 PolicyType,
        FAM_SING2 SingleFamily,
        POL_PLAN2 PlanCode,
        case
            when year(DEP_DATE2) < 1900 then null
            else DEP_DATE2
        end DepartureDate,
        NAME_INS2 InsurerName,
        0 Excess,
        '' ProductCode
    from
        carebase_AUDIT_CMN_MAIN_aucm cc
        cross apply
        (
            select
                case
                    when CLI_CODE in ('AI', 'AW', 'MN', 'NZ', 'TZ', 'WE') then 'NZ'
                    when CLI_CODE in ('UK') then 'UK'
                    when CLI_CODE in ('MM') then 'MY'
                    when CLI_CODE in ('MS') then 'SG'
                    else 'AU'
                end CountryKey,
                case
                    when CLI_CODE in ('AA', 'AU', 'ME') then 'TIP'
                    else 'CM'
                end CompanyKey
        ) keys
        outer apply
        (
            select top 1
                PolicyKey TRIPSPolicyKey
            from
                [db-au-cba].dbo.penPolicy p
            where
                p.CountryKey = keys.CountryKey and
                p.PolicyNumber =
                    case
                        when ltrim(rtrim(cc.POLICYNO2)) is null then null
						when ltrim(rtrim(cc.POLICYNO2)) like '% %' then null
						when ltrim(rtrim(cc.POLICYNO2)) like '%	%' then null
						when ltrim(rtrim(cc.POLICYNO2)) like '%  %' then null
                        when ltrim(rtrim(cc.POLICYNO2)) like '%(%' then null
                        when ltrim(rtrim(cc.POLICYNO2)) like '%)%' then null
                        when ltrim(rtrim(cc.POLICYNO2)) like '%.%' then null
                        when ltrim(rtrim(cc.POLICYNO2)) like '%,%' then null
                        when ltrim(rtrim(cc.POLICYNO2)) like '%$%' then null
                        when ltrim(rtrim(cc.POLICYNO2)) like '%\%' then null
                        when isnumeric(ltrim(rtrim(cc.POLICYNO2))) = 1 and len(ltrim(rtrim(cc.POLICYNO2))) < 10 then
                            convert(varchar(25), cc.POLICYNO2)
                        else null
                    end collate database_default
        ) p
        outer apply
        (
            select top 1
                PolicyTransactionKey
            from
                [db-au-cba].dbo.penPolicyTransSummary pt
            where
                pt.CountryKey = keys.CountryKey and
                pt.PolicyNumber = cc.POLICY_NO collate database_default
        ) pp
    where
        POLICYNO2 is not null


    begin transaction cbAuditPolicy

    begin try

        delete c
        from
            [db-au-cba].dbo.cbAuditPolicy c
            inner join carebase_AUDIT_CMN_MAIN_aucm r on
                c.CaseKey = left('AU-' + r.CASE_NO, 20) collate database_default and
                c.AuditDateTimeUTC = r.AUDIT_DATETIME

        insert into [db-au-cba].dbo.cbAuditPolicy with(tablock)
        (
            AuditUser,
            AuditDateTime,
            AuditDateTimeUTC,
            AuditAction,
            CountryKey,
            CaseKey,
            TRIPSPolicyKey,
            PolicyTransactionKey,
            CaseNo,
            IsMainPolicy,
            PolicyNo,
            IssueDate,
            ExpiryDate,
            VerifyDate,
            VerifiedBy,
            ConsultantInitial,
            PolicyType,
            SingleFamily,
            PlanCode,
            DepartureDate,
            InsurerName,
            Excess,
            ProductCode
        )
        select
            AuditUser,
            AuditDateTime,
            AuditDateTimeUTC,
            AuditAction,
            CountryKey,
            CaseKey,
            TRIPSPolicyKey,
            PolicyTransactionKey,
            CaseNo,
            IsMainPolicy,
            PolicyNo,
            IssueDate,
            ExpiryDate,
            VerifyDate,
            VerifiedBy,
            ConsultantInitial,
            PolicyType,
            SingleFamily,
            PlanCode,
            DepartureDate,
            InsurerName,
            Excess,
            ProductCode
        from
            #cbAuditPolicy

    end try

    begin catch

        if @@trancount > 0
            rollback transaction cbAuditPolicy

        exec syssp_genericerrorhandler 'cbAuditPolicy data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction cbAuditPolicy


    /* case management */
    if object_id('[db-au-cba].dbo.cbAuditCaseManagement') is null
    begin

        create table [db-au-cba].dbo.cbAuditCaseManagement
        (
            [BIRowID] bigint not null identity(1,1),
            [AuditUser] nvarchar(255) null,
            [AuditDateTime] datetime null,
            [AuditDateTimeUTC] datetime null,
            [AuditAction] nvarchar(10) null,
            [CountryKey] nvarchar(2) not null,
            [CaseKey] nvarchar(20) not null,
            [CaseManagementKey] nvarchar(20) null,
            [CaseNo] nvarchar(15) not null,
            [CaseManagementID] int not null,
            [CSIData] nvarchar(max) not null,
            [TemplateName] nvarchar(200) null,
            [CSIText] nvarchar(max) null,
            [CSIConverted] bit not null default ((0))
        )

        create clustered index idx_cbAuditCaseManagement_BIRowID on [db-au-cba].dbo.cbAuditCaseManagement(BIRowID)
        create nonclustered index idx_cbAuditCaseManagement_CaseKey on [db-au-cba].dbo.cbAuditCaseManagement(CaseKey)
        create nonclustered index idx_cbAuditCaseManagement_AuditDateTime on [db-au-cba].dbo.cbAuditCaseManagement(AuditDateTime)
        create nonclustered index idx_dirtycrap on [db-au-cba].dbo.cbAuditCaseManagement(CSIConverted) include (BIRowID)

    end

    if object_id('tempdb..#cbAuditCaseManagement') is not null
        drop table #cbAuditCaseManagement

    select
        AUDIT_USERNAME AuditUser,
        dbo.xfn_ConvertUTCtoLocal(AUDIT_DATETIME, 'AUS Eastern Standard Time') AuditDateTime,
        AUDIT_DATETIME AuditDateTimeUTC,
        AUDIT_ACTION AuditAction,
        'AU' CountryKey,
        left('AU-' + CASE_NO, 20) CaseKey,
        left('AU-' + convert(varchar, CaseMgtID), 20) CaseManagementKey,
        Case_No CaseNo,
        CaseMgtID CaseManagementID,
        CSIData,
        TemplateName
    into #cbAuditCaseManagement
    from
        carebase_AUDIT_tblCaseManagement_aucm cm
        inner join carebase_tblCMTemplates_aucm cmt on
            cmt.TemplateID = cm.TemplateID

    begin transaction cbAuditCaseManagement

    begin try

        delete c
        from
            [db-au-cba].dbo.cbAuditCaseManagement c
            inner join carebase_AUDIT_tblCaseManagement_aucm r on
                c.CaseManagementKey = left('AU-' + convert(varchar, CaseMgtID), 20) collate database_default and
                c.AuditDateTimeUTC = r.AUDIT_DATETIME

        insert into [db-au-cba].dbo.cbAuditCaseManagement with(tablock)
        (
            AuditUser,
            AuditDateTime,
            AuditDateTimeUTC,
            AuditAction,
            CountryKey,
            CaseKey,
            CaseManagementKey,
            CaseNo,
            CaseManagementID,
            CSIData,
            TemplateName
        )
        select
            AuditUser,
            AuditDateTime,
            AuditDateTimeUTC,
            AuditAction,
            CountryKey,
            CaseKey,
            CaseManagementKey,
            CaseNo,
            CaseManagementID,
            CSIData,
            TemplateName
        from
            #cbAuditCaseManagement

    end try

    begin catch

        if @@trancount > 0
            rollback transaction cbAuditCaseManagement

        exec syssp_genericerrorhandler 'cbAuditCaseManagement data refresh failed'

    end catch

    if @@trancount > 0
        commit transaction cbAuditCaseManagement

end

GO
