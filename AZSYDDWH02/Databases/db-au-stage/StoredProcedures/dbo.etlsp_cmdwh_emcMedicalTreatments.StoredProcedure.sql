USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_emcMedicalTreatments]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_emcMedicalTreatments]
as
begin
/*
    20140317, LS,   TFS 9410, UK data
*/

    set nocount on

    exec etlsp_StagingIndex_EMC

    if object_id('[db-au-cba].dbo.emcMedicalTreatments') is null
    begin

        create table [db-au-cba].dbo.emcMedicalTreatments
        (
            CountryKey varchar(2) not null,
            ApplicationKey varchar(15) not null,
            ApplicationID int not null,
            MedicalTreatmentID int not null,
            Category varchar(35) null,
            TreatmentDate datetime null,
            TreatmentDetails varchar(2000) null
        )

        create clustered index idx_emcMedicalTreatments_ApplicationKey on [db-au-cba].dbo.emcMedicalTreatments(ApplicationKey)
        create index idx_emcMedicalTreatments_ApplicationID on [db-au-cba].dbo.emcMedicalTreatments(ApplicationID, CountryKey)
        create index idx_emcMedicalTreatments_MedicalTreatmentID on [db-au-cba].dbo.emcMedicalTreatments(MedicalTreatmentID, CountryKey)
        create index idx_emcMedicalTreatments_TreatmentDate on [db-au-cba].dbo.emcMedicalTreatments(TreatmentDate, CountryKey)

    end

    if object_id('etl_emcMedicalTreatments') is not null
        drop table etl_emcMedicalTreatments

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar(12), mt.ClientID) ApplicationKey,
        mt.ClientID ApplicationID,
        mt.MedRxID MedicalTreatmentID,
        RxType Category,
        RxDate TreatmentDate,
        RxDetails TreatmentDetails
    into etl_emcMedicalTreatments
    from
        emc_CBA_EMC_tblMedicalTreatment_AU mt
        outer apply dbo.fn_GetEMCDomainKeys(mt.ClientID, 'AU') dk
        inner join emc_CBA_EMC_tblMedicalTreatmentDetails_AU mtd on
            mtd.MedRxID = mt.MedRxID
        inner join emc_CBA_EMC_tblMedicalTreatmentTypes_AU mtt on
            mtt.RxTypeCode = mt.RxTypeID

    

    delete emt
    from
        [db-au-cba].dbo.emcMedicalTreatments emt
        inner join etl_emcMedicalTreatments t on
            t.ApplicationKey = emt.ApplicationKey


    insert into [db-au-cba].dbo.emcMedicalTreatments with (tablock)
    (
        CountryKey,
        ApplicationKey,
        ApplicationID,
        MedicalTreatmentID,
        Category,
        TreatmentDate,
        TreatmentDetails
    )
    select
        CountryKey,
        ApplicationKey,
        ApplicationID,
        MedicalTreatmentID,
        Category,
        TreatmentDate,
        TreatmentDetails
    from
        etl_emcMedicalTreatments

end

GO
