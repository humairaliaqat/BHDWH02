USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_StagingIndex_EMC]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_StagingIndex_EMC]
as
begin
/*
    20140317, LS,   TFS 9410, create
*/

    set nocount on

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_Companies_AU_Compid')
        create index idx_emc_EMC_Companies_AU_Compid on emc_CBA_EMC_Companies_AU(Compid) include(ParentCompanyid, DomainID)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblParentCompany_AU_ParentCompanyid')
        create index idx_emc_EMC_tblParentCompany_AU_ParentCompanyid on emc_CBA_EMC_tblParentCompany_AU(ParentCompanyid) include(ParentCompanyCode)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblSubCompanies_AU_Compid')
        create index idx_emc_EMC_tblSubCompanies_AU_Compid on emc_CBA_EMC_tblSubCompanies_AU(Compid) include(SubCompid, SubCompCode)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblSecurity_AU_UserID')
        create index idx_emc_EMC_tblSecurity_AU_UserID on emc_CBA_EMC_tblSecurity_AU(UserID) include(FullName)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblSecurity_AU_Login')
        create index idx_emc_EMC_tblSecurity_AU_Login on emc_CBA_EMC_tblSecurity_AU(Login) include(UserID, FullName)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblPolicyTypes_AU_PolTypeID')
        create index idx_emc_EMC_tblPolicyTypes_AU_PolTypeID on emc_CBA_EMC_tblPolicyTypes_AU(PolTypeID) include(PolCode, PolType)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblEMCNames_AU_ClientID')
        create index idx_emc_EMC_tblEMCNames_AU_ClientID on emc_CBA_EMC_tblEMCNames_AU(ClientID)
        include(
            ContType,
            MedicalRisk,
            ScreeningVersion,
            eMailResponse,
            isAnnualMultiTrip,
            isWinterSport
        )

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblEmcPenguinAreaMapping_AU_AreaMappingID')
        create index idx_emc_EMC_tblEmcPenguinAreaMapping_AU_AreaMappingID on emc_CBA_EMC_tblEmcPenguinAreaMapping_AU(AreaMappingID) include(AreaName, AreaCode)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblMedicalTreatment_AU_ClientID')
        create index idx_emc_EMC_tblMedicalTreatment_AU_ClientID on emc_CBA_EMC_tblMedicalTreatment_AU(ClientID) include(RxTypeID, RxRecd)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblMedicalTreatmentTypes_AU_RxTypeCode')
        create index idx_emc_EMC_tblMedicalTreatmentTypes_AU_RxTypeCode on emc_CBA_EMC_tblMedicalTreatmentTypes_AU(RxTypeCode) include(RxType)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblMedicalExtraQuestionDetails_AU_ClientID')
        create index idx_emc_EMC_tblMedicalExtraQuestionDetails_AU_ClientID on emc_CBA_EMC_tblMedicalExtraQuestionDetails_AU(ClientID) include(QId, QVal)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblEMCApplications_AU_ClientID')
        create index idx_emc_EMC_tblEMCApplications_AU_ClientID on emc_CBA_EMC_tblEMCApplications_AU(ClientID)
        include(
            DeptDt,
            HeightUnitsID,
            WeightUnitsID,
            MedsChanged,
            MedsChangedHow,
            CompID
        )

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblEMCNames_AU_ClientID')
        create index idx_emc_EMC_tblEMCNames_AU_ClientID on emc_CBA_EMC_tblEMCNames_AU(ClientID, ContType)
        include(
            ContID,
            Firstname,
            Surname,
            Relationship,
            PhoneBH,
            Fax,
            Email
        )

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblMedicalExtraQuestionDetails_AU_ClientID')
        create index idx_emc_EMC_tblMedicalExtraQuestionDetails_AU_ClientID on emc_CBA_EMC_tblMedicalConditionsGroup_AU(Counter) include(CreateDate, DeniedAccepted, Score)

    
end

GO
