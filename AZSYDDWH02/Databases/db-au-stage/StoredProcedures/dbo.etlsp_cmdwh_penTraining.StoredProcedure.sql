USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penTraining]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penTraining]
as
begin

/*
20130617 - LS - TFS 7664/8556/8557, UK Penguin
20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
20140617 - LS - TFS 12416, schema and index cleanup
20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
20160321 - LT - Penguin 18.0, added US Penguin instance
20160602 - LT - Penguin 19.0, fixed CompanyKey calculation
*/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penTraining') is not null
        drop table etl_penTraining

    ;with cte_course
    as
    (
        select
            case
                when charindex('.', Title) = 0 then 'AU'
                else left(Title, charindex('.', Title) - 1)
            end collate database_default CountryKey,
			ltrim(rtrim(replace(substring(Title,charindex('.',Title)+1,3),'.',''))) as CompanyKey,
            --case
            --    when charindex('.', Title) = 0 then ''
            --    else substring(Title, charindex('.', Title) + 1, charindex('.', Title, charindex('.', Title) + 1) - charindex('.', Title) - 1)
            --end collate database_default CompanyKey,
            s.SurveyID,
            v.VoterID,
            ContextUserName collate database_default UserLogin,
            CreationDate CourseCreateDate,
            OpenDate CourseStartDate,
            CloseDate CourseEndDate,
            Title collate database_default Title,
            charindex('.', Title, charindex('.', Title) + 1) + 1 GroupStart,
            charindex('.', Title, charindex('.', Title, charindex('.', Title) + 1) + 1) + 1 NumberStart,
            charindex('.', Title, charindex('.', Title, charindex('.', Title, charindex('.', Title) + 1) + 1) + 1) + 1 CodeStart,
            charindex('.', Title, charindex('.', Title, charindex('.', Title, charindex('.', Title, charindex('.', Title) + 1) + 1) + 1) + 1) + 1 NameStart,
            len(Title) TitleLength,
            v.StartDate ExamStartTime,
            v.VoteDate ExamFinishTime,
            case
                when Passed = 1 then 'PASS'
                else 'FAIL'
            end ExamResult,
            AlphaCode collate database_default AlphaCode
        from
            penguin_vts_tbSurvey_aucm s
            inner join penguin_vts_tbVoter_aucm v on
                v.SurveyID = s.SurveyID
        where
            s.Activated = 1
    )
    select
        dk.CountryKey,
        t.CompanyKey,
        o.DomainKey,
        PrefixKey + convert(varchar, SurveyID) + '-' + convert(varchar, VoterID) TrainingKey,
        o.OutletAlphakey,
        o.UserKey,
        SurveyID,
        t.AlphaCode,
        UserLogin,
        case
            when NameStart > CodeStart then substring(Title, CodeStart, NameStart - CodeStart - 1)
            else ''
        end CourseCode,
        case
            when NameStart > 0 then substring(Title, NameStart, TitleLength - NameStart + 1)
            else ''
        end CourseName,
        case
            when NumberStart > GroupStart then substring(Title, GroupStart, NumberStart - GroupStart - 1)
            else ''
        end CourseAgencyGroup,
        CourseCreateDate,
        CourseStartDate,
        CourseEndDate,
        ExamStartTime,
        ExamFinishTime,
        ExamResult
    into etl_penTraining
    from
        cte_course t
        outer apply
        (
            select top 1
                o.DomainID,
                o.DomainKey,
                o.OutletAlphaKey,
                u.UserKey
            from
                [db-au-cba].dbo.penOutlet o
                inner join [db-au-cba].dbo.penUser u on
                    u.OutletKey = o.OutletKey
            where
                o.OutletStatus = 'Current' and
                u.UserStatus = 'Current' and
                u.Login = t.UserLogin and
                o.CountryKey = t.CountryKey and
                o.CompanyKey collate database_default = t.CompanyKey collate database_default and
                o.AlphaCode = t.AlphaCode
        ) o
        cross apply dbo.fn_GetDomainKeys(o.DomainID, t.CompanyKey, 'AU') dk


    if object_id('[db-au-cba].dbo.penTraining') is null
    begin

        create table [db-au-cba].dbo.[penTraining]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) null,
            [TrainingKey] varchar(20) not null,
            [OutletAlphakey] nvarchar(50) null,
            [UserKey] varchar(41) null,
            [SurveyID] int null,
            [AlphaCode] nvarchar(50) null,
            [UserLogin] nvarchar(50) null,
            [CourseCode] nvarchar(255) null,
            [CourseName] nvarchar(255) null,
            [CourseAgencyGroup] varchar(5) null,
            [CourseCreateDate] datetime null,
            [CourseStartDate] datetime null,
            [CourseEndDate] datetime null,
            [ExamStartTime] datetime null,
            [ExamFinishTime] datetime null,
            [ExamResult] varchar(4) not null,
            [DomainKey] varchar(41) null
        )

        create clustered index idx_penTraining_TrainingKey on [db-au-cba].dbo.penTraining(TrainingKey)
        create nonclustered index idx_penTraining_CourseDate on [db-au-cba].dbo.penTraining(CourseStartDate,CourseEndDate)
        create nonclustered index idx_penTraining_ExamTime on [db-au-cba].dbo.penTraining(ExamStartTime)
        create nonclustered index idx_penTraining_OutletAlphakey on [db-au-cba].dbo.penTraining(OutletAlphakey)
        create nonclustered index idx_penTraining_UserKey on [db-au-cba].dbo.penTraining(UserKey)

    end
    else
    begin

        delete [db-au-cba].dbo.penTraining
        where
            TrainingKey in
            (
                select distinct TrainingKey
                from
                    etl_penTraining
            )

    end

    insert into [db-au-cba].dbo.penTraining with (tablock)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        TrainingKey,
        OutletAlphakey,
        UserKey,
        SurveyID,
        AlphaCode,
        UserLogin,
        CourseCode,
        CourseName,
        CourseAgencyGroup,
        CourseCreateDate,
        CourseStartDate,
        CourseEndDate,
        ExamStartTime,
        ExamFinishTime,
        ExamResult
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        TrainingKey,
        OutletAlphakey,
        UserKey,
        SurveyID,
        AlphaCode,
        UserLogin,
        CourseCode,
        CourseName,
        CourseAgencyGroup,
        CourseCreateDate,
        CourseStartDate,
        CourseEndDate,
        ExamStartTime,
        ExamFinishTime,
        ExamResult
    from
        etl_penTraining

end



GO
