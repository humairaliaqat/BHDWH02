USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_StagingIndex_EMC]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[etlsp_StagingIndex_EMC]
as
begin
/*
    20140317, LS,   TFS 9410, create
*/

    set nocount on

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_Companies_AU_Compid')
        create index idx_emc_EMC_Companies_AU_Compid on emc_EMC_Companies_AU(Compid) include(ParentCompanyid, DomainID)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblParentCompany_AU_ParentCompanyid')
        create index idx_emc_EMC_tblParentCompany_AU_ParentCompanyid on emc_EMC_tblParentCompany_AU(ParentCompanyid) include(ParentCompanyCode)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblSubCompanies_AU_Compid')
        create index idx_emc_EMC_tblSubCompanies_AU_Compid on emc_EMC_tblSubCompanies_AU(Compid) include(SubCompid, SubCompCode)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblSecurity_AU_UserID')
        create index idx_emc_EMC_tblSecurity_AU_UserID on emc_EMC_tblSecurity_AU(UserID) include(FullName)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblSecurity_AU_Login')
        create index idx_emc_EMC_tblSecurity_AU_Login on emc_EMC_tblSecurity_AU(Login) include(UserID, FullName)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblPolicyTypes_AU_PolTypeID')
        create index idx_emc_EMC_tblPolicyTypes_AU_PolTypeID on emc_EMC_tblPolicyTypes_AU(PolTypeID) include(PolCode, PolType)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblEMCNames_AU_ClientID')
        create index idx_emc_EMC_tblEMCNames_AU_ClientID on emc_EMC_tblEMCNames_AU(ClientID)
        include(
            ContType,
            MedicalRisk,
            ScreeningVersion,
            eMailResponse,
            isAnnualMultiTrip,
            isWinterSport
        )

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblEmcPenguinAreaMapping_AU_AreaMappingID')
        create index idx_emc_EMC_tblEmcPenguinAreaMapping_AU_AreaMappingID on emc_EMC_tblEmcPenguinAreaMapping_AU(AreaMappingID) include(AreaName, AreaCode)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblMedicalTreatment_AU_ClientID')
        create index idx_emc_EMC_tblMedicalTreatment_AU_ClientID on emc_EMC_tblMedicalTreatment_AU(ClientID) include(RxTypeID, RxRecd)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblMedicalTreatmentTypes_AU_RxTypeCode')
        create index idx_emc_EMC_tblMedicalTreatmentTypes_AU_RxTypeCode on emc_EMC_tblMedicalTreatmentTypes_AU(RxTypeCode) include(RxType)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblMedicalExtraQuestionDetails_AU_ClientID')
        create index idx_emc_EMC_tblMedicalExtraQuestionDetails_AU_ClientID on emc_EMC_tblMedicalExtraQuestionDetails_AU(ClientID) include(QId, QVal)

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblEMCApplications_AU_ClientID')
        create index idx_emc_EMC_tblEMCApplications_AU_ClientID on emc_EMC_tblEMCApplications_AU(ClientID)
        include(
            DeptDt,
            HeightUnitsID,
            WeightUnitsID,
            MedsChanged,
            MedsChangedHow,
            CompID
        )

    if not exists (select null from sys.indexes where name = 'idx_emc_EMC_tblEMCNames_AU_ClientID')
        create index idx_emc_EMC_tblEMCNames_AU_ClientID on emc_EMC_tblEMCNames_AU(ClientID, ContType)
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
        create index idx_emc_EMC_tblMedicalExtraQuestionDetails_AU_ClientID on emc_EMC_tblMedicalConditionsGroup_AU(Counter) include(CreateDate, DeniedAccepted, Score)

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_Companies_UK_Compid')
        create index idx_emc_UKEMC_Companies_UK_Compid on emc_UKEMC_Companies_UK(Compid) include(ParentCompanyid, DomainID)

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblParentCompany_UK_ParentCompanyid')
        create index idx_emc_UKEMC_tblParentCompany_UK_ParentCompanyid on emc_UKEMC_tblParentCompany_UK(ParentCompanyid) include(ParentCompanyCode)

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblSubCompanies_UK_Compid')
        create index idx_emc_UKEMC_tblSubCompanies_UK_Compid on emc_UKEMC_tblSubCompanies_UK(Compid) include(SubCompid, SubCompCode)

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblSecurity_UK_UserID')
        create index idx_emc_UKEMC_tblSecurity_UK_UserID on emc_UKEMC_tblSecurity_UK(UserID) include(FullName)

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblSecurity_UK_Login')
        create index idx_emc_UKEMC_tblSecurity_UK_Login on emc_UKEMC_tblSecurity_UK(Login) include(UserID, FullName)

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblPolicyTypes_UK_PolTypeID')
        create index idx_emc_UKEMC_tblPolicyTypes_UK_PolTypeID on emc_UKEMC_tblPolicyTypes_UK(PolTypeID) include(PolCode, PolType)

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblEMCNames_UK_ClientID')
        create index idx_emc_UKEMC_tblEMCNames_UK_ClientID on emc_UKEMC_tblEMCNames_UK(ClientID)
        include(
            ContType,
            MedicalRisk,
            ScreeningVersion,
            eMailResponse,
            isAnnualMultiTrip,
            isWinterSport
        )

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblEmcPenguinAreaMapping_UK_AreaMappingID')
        create index idx_emc_UKEMC_tblEmcPenguinAreaMapping_UK_AreaMappingID on emc_UKEMC_tblEmcPenguinAreaMapping_UK(AreaMappingID) include(AreaName, AreaCode)

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblMedicalTreatment_UK_ClientID')
        create index idx_emc_UKEMC_tblMedicalTreatment_UK_ClientID on emc_UKEMC_tblMedicalTreatment_UK(ClientID) include(RxTypeID, RxRecd)

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblMedicalTreatmentTypes_UK_RxTypeCode')
        create index idx_emc_UKEMC_tblMedicalTreatmentTypes_UK_RxTypeCode on emc_UKEMC_tblMedicalTreatmentTypes_UK(RxTypeCode) include(RxType)

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblMedicalExtraQuestionDetails_UK_ClientID')
        create index idx_emc_UKEMC_tblMedicalExtraQuestionDetails_UK_ClientID on emc_UKEMC_tblMedicalExtraQuestionDetails_UK(ClientID) include(QId, QVal)

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblEMCApplications_UK_ClientID')
        create index idx_emc_UKEMC_tblEMCApplications_UK_ClientID on emc_UKEMC_tblEMCApplications_UK(ClientID)
        include(
            DeptDt,
            HeightUnitsID,
            WeightUnitsID,
            MedsChanged,
            MedsChangedHow
        )

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblEMCNames_UK_ClientID')
        create index idx_emc_UKEMC_tblEMCNames_UK_ClientID on emc_UKEMC_tblEMCNames_UK(ClientID, ContType)
        include(
            ContID,
            Firstname,
            Surname,
            Relationship,
            PhoneBH,
            Fax,
            Email
        )

    if not exists (select null from sys.indexes where name = 'idx_emc_UKEMC_tblMedicalExtraQuestionDetails_UK_ClientID')
        create index idx_emc_UKEMC_tblMedicalExtraQuestionDetails_UK_ClientID on emc_UKEMC_tblMedicalConditionsGroup_UK(Counter) include(CreateDate, DeniedAccepted, Score)
		
end

GO
