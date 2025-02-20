USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_emcNotes]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_emcNotes]
as
begin
/*
    20140317, LS,   TFS 9410, UK data
*/

    set nocount on

    exec etlsp_StagingIndex_EMC

    if object_id('[db-au-cba].dbo.emcNotes') is null
    begin

        create table [db-au-cba].dbo.emcNotes
        (
            CountryKey varchar(2) not null,
            ApplicationKey varchar(15) null,
            UserKey varchar(10) null,
            NoteKey varchar(15) not null,
            ApplicationID int null,
            NoteID int not null,
            CreateDate datetime null,
            NoteType varchar(20) null,
            Author varchar(50) null,
            NoteLogin varchar(20) null
        )

        create clustered index idx_emcNotes_ApplicationKey on [db-au-cba].dbo.emcNotes(ApplicationKey)
        create index idx_emcNotes_CountryKey on [db-au-cba].dbo.emcNotes(CountryKey)
        create index idx_emcNotes_ApplicationID on [db-au-cba].dbo.emcNotes(ApplicationID, CountryKey)
        create index idx_emcNotes_NoteID on [db-au-cba].dbo.emcNotes(NoteID, CountryKey)
        create index idx_emcNotes_UserKey on [db-au-cba].dbo.emcNotes(UserKey)

    end

    if object_id('etl_emcNotes') is not null
        drop table etl_emcNotes

    select
        dk.CountryKey,
        dk.CountryKey + '-' + convert(varchar(12), ClientID) ApplicationKey,
        'AU-' + convert(varchar(7), UserID) UserKey,
        dk.CountryKey + '-' + convert(varchar(12), NoteID) NoteKey,
        ClientID ApplicationID,
        NoteID NoteID,
        NoteDt CreateDate,
        nt.NoteType,
        FullName Author,
        NoteAuthor NoteLogin
    into etl_emcNotes
    from
        emc_CBA_EMC_tblEMCNotes_AU n
        outer apply dbo.fn_GetEMCDomainKeys(n.ClientID, 'AU') dk
        left join emc_CBA_EMC_tblNoteTypes_AU nt on
            nt.NoteTypeID = n.NoteTypeID
        outer apply
        (
            select top 1
                UserID,
                FullName
            from
                emc_CBA_EMC_tblSecurity_AU s
            where
                s.Login = n.NoteAuthor
        ) s

    

    delete en
    from
        [db-au-cba].dbo.emcNotes en
        inner join etl_emcNotes t on
            t.NoteKey = en.NoteKey

    insert into [db-au-cba].dbo.emcNotes with (tablock)
    (
        CountryKey,
        ApplicationKey,
        UserKey,
        NoteKey,
        ApplicationID,
        NoteID,
        CreateDate,
        NoteType,
        Author,
        NoteLogin
    )
    select
        CountryKey,
        ApplicationKey,
        UserKey,
        NoteKey,
        ApplicationID,
        NoteID,
        CreateDate,
        NoteType,
        Author,
        NoteLogin
    from
        etl_emcNotes

end

GO
