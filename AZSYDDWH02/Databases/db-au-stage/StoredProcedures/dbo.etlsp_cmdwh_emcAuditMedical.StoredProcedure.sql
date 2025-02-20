USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_emcAuditMedical]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_emcAuditMedical]
as
begin
/*
    20140317, LS,   TFS 9410, UK data
*/

    set nocount on

    exec etlsp_StagingIndex_EMC

    if object_id('[db-au-cba].dbo.emcAuditMedical') is null
    begin

        create table [db-au-cba].dbo.emcAuditMedical
        (
            CountryKey varchar(2) not null,
            ApplicationKey varchar(15) not null,
            AuditMedicalKey varchar(15) not null,
            ApplicationID int not null,
            AuditMedicalID int not null,
            AuditDate datetime null,
            AuditUserLogin varchar(50) null,
            AuditUser varchar(255) null,
            AuditAction varchar(5) null,
            AssessorID int null,
            Condition varchar(250) null,
            DiagnosisDate datetime null,
            ConditionStatus varchar(20) null,
            Medication varchar(2000) null,
            OnlineCondition varchar(2000) null
        )

        create clustered index idx_emcAuditMedical_ApplicationKey on [db-au-cba].dbo.emcAuditMedical(ApplicationKey)
        create index idx_emcAuditMedical_AuditMedicalKey on [db-au-cba].dbo.emcAuditMedical(AuditMedicalKey)
        create index idx_emcAuditMedical_CountryKey on [db-au-cba].dbo.emcAuditMedical(CountryKey)
        create index idx_emcAuditMedical_AuditMedicalID on [db-au-cba].dbo.emcAuditMedical(AuditMedicalID, CountryKey)
        create index idx_emcAuditMedical_AuditDate on [db-au-cba].dbo.emcAuditMedical(AuditDate, CountryKey)

    end

    if object_id('etl_emcAuditMedical') is not null
        drop table etl_emcAuditMedical

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar(12), m.ClientID) ApplicationKey,
        dk.CountryKey + '-' + convert(varchar(12), m.Counter) AuditMedicalKey,
        m.ClientID ApplicationID,
        m.Counter AuditMedicalID,
        AUDIT_DATETIME AuditDate,
        AUDIT_USERNAME AuditUserLogin,
        s.FullName AuditUser,
        AUDIT_ACTION AuditAction,
        AssessorID,
        m.Condition,
        DiagnosisDate,
        case m.DeniedAccepted
            when 'A' then 'Approved'
            when 'D' then 'Denied'
            when 'N' then 'Not Assessed'
            when 'P' then 'Awaiting Assessment'
            when 'U' then 'Auto Accept'
        end ConditionStatus,
        Meds_Dose_Freq Medication,
        OnlineCondition
    into etl_emcAuditMedical
    from
        emc_CBA_EMC_AUDIT_MEDICAL_AU m
        outer apply dbo.fn_GetEMCDomainKeys(m.ClientID, 'AU') dk
        left join emc_CBA_EMC_tblSecurity_AU s on
            s.Login = m.AUDIT_USERNAME

   


    delete eam
    from
        [db-au-cba].dbo.emcAuditMedical eam
        inner join etl_emcAuditMedical t on
            t.AuditMedicalKey = eam.AuditMedicalKey


    insert into [db-au-cba].dbo.emcAuditMedical with (tablock)
    (
        CountryKey,
        ApplicationKey,
        AuditMedicalKey,
        ApplicationID,
        AuditMedicalID,
        AuditDate,
        AuditUserLogin,
        AuditUser,
        AuditAction,
        AssessorID,
        Condition,
        DiagnosisDate,
        ConditionStatus,
        Medication,
        OnlineCondition
    )
    select
        CountryKey,
        ApplicationKey,
        AuditMedicalKey,
        ApplicationID,
        AuditMedicalID,
        AuditDate,
        AuditUserLogin,
        AuditUser,
        AuditAction,
        AssessorID,
        Condition,
        DiagnosisDate,
        ConditionStatus,
        Medication,
        OnlineCondition
    from
        etl_emcAuditMedical

end

GO
