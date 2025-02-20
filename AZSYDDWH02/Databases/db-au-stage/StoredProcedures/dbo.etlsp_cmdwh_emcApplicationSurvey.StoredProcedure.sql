USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_emcApplicationSurvey]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_emcApplicationSurvey]
as
begin
/*
    20140317, LS,   TFS 9410, UK data
*/

    set nocount on

    exec etlsp_StagingIndex_EMC

    if object_id('[db-au-cba].dbo.emcApplicationSurvey') is null
    begin

        create table [db-au-cba].dbo.emcApplicationSurvey
        (
            CountryKey varchar(2) not null,
            ApplicationKey varchar(15) null,
            ApplicationSurveyKey varchar(15) null,
            ApplicationID int null,
            ApplicationSurveyID int not null,
            CreateDate datetime null,
            SurveyCategory varchar(40) null,
            Question varchar(255) null,
            Answer varchar(255) null
        )

        create clustered index idx_emcApplicationSurvey_ApplicationSurveyKey on [db-au-cba].dbo.emcApplicationSurvey(ApplicationSurveyKey)
        create index idx_emcApplicationSurvey_CountryKey on [db-au-cba].dbo.emcApplicationSurvey(CountryKey)
        create index idx_emcApplicationSurvey_CreateDate on [db-au-cba].dbo.emcApplicationSurvey(CreateDate, CountryKey)

    end

    if object_id('etl_emcApplicationSurvey') is not null
        drop table etl_emcApplicationSurvey

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar(12), es.ClientID) ApplicationKey,
        dk.CountryKey + '-' + convert(varchar(12), es.sah_id) ApplicationSurveyKey,
        es.ClientID ApplicationID,
        es.sah_id ApplicationSurveyID,
        es.CreatedDt CreateDate,
        SurveyName SurveyCategory,
        Question,
        Answer
    into etl_emcApplicationSurvey
    from
        emc_CBA_EMC_tblAppSurveys_AU es
        outer apply dbo.fn_GetEMCDomainKeys(es.ClientID, 'AU') dk
        inner join emc_CBA_EMC_tblSurveys_AU s on
            s.SurveyID = es.SurveyID
        inner join emc_CBA_EMC_tblSurveyQuestions_AU q on
            q.QuesID = es.QuesID and
            q.SurveyID = s.SurveyID
        inner join emc_CBA_EMC_tblSurveyAnswers_AU a on
            a.AnswerID = es.AnsID and
            a.QuesID = q.QuesID and
            a.SurveyID = s.SurveyID

    

    delete eas
    from
        [db-au-cba].dbo.emcApplicationSurvey eas
        inner join etl_emcApplicationSurvey t on
            t.ApplicationSurveyKey = eas.ApplicationSurveyKey


    insert into [db-au-cba].dbo.emcApplicationSurvey with (tablock)
    (
        CountryKey,
        ApplicationKey,
        ApplicationSurveyKey,
        ApplicationID,
        ApplicationSurveyID,
        CreateDate,
        SurveyCategory,
        Question,
        Answer
    )
    select
        CountryKey,
        ApplicationKey,
        ApplicationSurveyKey,
        ApplicationID,
        ApplicationSurveyID,
        CreateDate,
        SurveyCategory,
        Question,
        Answer
    from
        etl_emcApplicationSurvey

end

GO
