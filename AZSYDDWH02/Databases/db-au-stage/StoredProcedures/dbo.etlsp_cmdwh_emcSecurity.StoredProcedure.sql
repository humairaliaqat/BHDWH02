USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_emcSecurity]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[etlsp_cmdwh_emcSecurity]
as
begin

/*
    20140217, LS,   change truncate to delete, prepare for UK
    20140317, LS,   TFS 9410, UK data
*/

    set nocount on

    exec etlsp_StagingIndex_EMC

    if object_id('[db-au-cba].dbo.emcSecurity') is null
    begin

        create table [db-au-cba].dbo.emcSecurity
        (
            CountryKey varchar(2) not null,
            UserKey varchar(10) null,
            UserID int null,
            Login varchar(50) null,
            FullName varchar(255) null,
            Initial varchar(5) null,
            SecurityLevel varchar(5) null,
            Phone varchar(15) null,
            Email varchar(50) null,
            ValidFrom datetime null,
            ValidTo datetime null
        )

        create clustered index idx_emcSecurity_UserKey on [db-au-cba].dbo.emcSecurity(UserKey)
        create index idx_emcSecurity_CountryKey on [db-au-cba].dbo.emcSecurity(CountryKey)
        create index idx_emcSecurity_Login on [db-au-cba].dbo.emcSecurity(Login, CountryKey)
        create index idx_emcSecurity_ValidDates on [db-au-cba].dbo.emcSecurity(ValidFrom, ValidTo)

    end

    if object_id('etl_emcSecurity') is not null
        drop table etl_emcSecurity

    select
        'AU' CountryKey,
        'AU-' + convert(varchar(7), UserID) UserKey,
        UserID,
        Login,
        FullName,
        Initial,
        SecLevel SecurityLevel,
        Phone,
        Email,
        ValidFrom,
        ValidTo
    into etl_emcSecurity
    from
        emc_CBA_EMC_tblSecurity_AU

   

    delete s
    from
        [db-au-cba].dbo.emcSecurity s
        inner join etl_emcSecurity t on
            t.UserKey = s.UserKey


    insert into [db-au-cba].dbo.emcSecurity with (tablock)
    (
        CountryKey,
        UserKey,
        UserID,
        [Login],
        FullName,
        Initial,
        SecurityLevel,
        Phone,
        Email,
        ValidFrom,
        ValidTo
    )
    select
        CountryKey,
        UserKey,
        UserID,
        [Login],
        FullName,
        Initial,
        SecurityLevel,
        Phone,
        Email,
        ValidFrom,
        ValidTo
    from
        etl_emcSecurity

end

GO
