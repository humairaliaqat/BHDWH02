USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penUserAudit]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penUserAudit]
as
begin

/************************************************************************************************************************************
Author:         Leonardus Setyabudi
Date:           20130322
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    User audit table contains historical records of consultant attribute details.
Change History:
                20130322 - LS - Procedure created
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                                not gonna store password anymore
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
				20141216 - LS - P11.5, login from 50 to 100 nvarchar
				20160321 - LT - Penguin 18.0, added US penguin instance
*************************************************************************************************************************************/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penUserAudit') is not null
        drop table etl_penUserAudit

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, u.UserAuditID) UserAuditKey,
        PrefixKey + convert(varchar, u.UserID) UserKey,
        PrefixKey + convert(varchar, u.OutletID) OutletKey,
        DomainID,
        u.UserAuditId,
        dbo.xfn_ConvertUTCtoLocal(u.AuditDateTime, TimeZone) AuditDateTime,
        u.AuditDateTime AuditDateTimeUTC,
        u.UserID,
        u.OutletID,
        u.FirstName,
        u.LastName,
        u.[Login],
        null [Password],
        u.Initial,
        u.ASICNumber,
        dbo.xfn_ConvertUTCtoLocal(u.AgreementDate, TimeZone) AgreementDate,
        u.AccessLevel,
        dbo.fn_GetReferenceValueByID(u.AccessLevel, CompanyKey, CountrySet) AccessLevelName,
        u.AccreditationNumber,
        u.AllowAdjustPricing,
        case
            when u.[Status] is null then 'Active'
            else 'Inactive'
        end as [Status],
        dbo.xfn_ConvertUTCtoLocal(u.[Status], TimeZone) InactiveDate,
        u.AgentCode,
        dbo.xfn_ConvertUTCtoLocal(u.DateOfBirth, TimeZone) DateOfBirth,
        dbo.fn_GetReferenceValueByID(u.ASICCheck, CompanyKey, CountrySet) ASICCheck,
        u.Email,
        dbo.xfn_ConvertUTCtoLocal(u.CreateDateTime, TimeZone) CreateDateTime,
        dbo.xfn_ConvertUTCtoLocal(u.UpdateDateTime, TimeZone) UpdateDateTime,
        u.MustChangePassword,
        u.AccountLocked,
        u.LoginFailedTimes,
        u.IsSuperUser,
        u.LastUpdateUserId,
        u.LastUpdateCrmUserId,
        dbo.xfn_ConvertUTCtoLocal(u.LastLoggedInDateTime, TimeZone) LastLoggedIn,
        u.LastLoggedInDateTime LastLoggedInUTC
    into etl_penUserAudit
    from
        penguin_tblUser_Audit_aucm u
        cross apply dbo.fn_GetOutletDomainKeys(u.OutletId, 'CM', 'AU') dk

 


    if object_id('[db-au-cba].dbo.penUserAudit') is null
    begin

        create table [db-au-cba].dbo.[penUserAudit]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [DomainKey] varchar(41) null,
            [UserAuditKey] varchar(41) not null,
            [UserKey] varchar(41) not null,
            [OutletKey] varchar(41) not null,
            [DomainID] int null,
            [UserAuditID] int not null,
            [AuditDateTime] datetime not null,
            [AuditDateTimeUTC] datetime not null,
            [UserID] int not null,
            [OutletID] int not null,
            [FirstName] nvarchar(50) not null,
            [LastName] nvarchar(50) not null,
            [Login] nvarchar(100) not null,
            [Password] varchar(255) null,
            [Initial] nvarchar(50) null,
            [ASICNumber] int null,
            [AgreementDate] datetime null,
            [AccessLevel] int not null,
            [AccessLevelName] nvarchar(50) null,
            [AccreditationNumber] varchar(50) null,
            [AllowAdjustPricing] bit null,
            [Status] varchar(20) null,
            [InactiveDate] datetime null,
            [AgentCode] nvarchar(50) null,
            [DateOfBirth] datetime null,
            [ASICCheck] nvarchar(50) null,
            [Email] nvarchar(200) null,
            [CreateDateTime] datetime null,
            [UpdateDateTime] datetime null,
            [MustChangePassword] bit null,
            [AccountLocked] bit null,
            [LoginFailedTimes] int null,
            [IsSuperUser] bit null,
            [LastUpdateUserID] int null,
            [LastUpdateCRMUserID] int null,
            [LastLoggedIn] datetime null,
            [LastLoggedInUTC] datetime null
        )

        create clustered index idx_penUserAudit_UserAuditKey on [db-au-cba].dbo.penUserAudit(UserAuditKey)
        create nonclustered index idx_penUserAudit_AuditDateTime on [db-au-cba].dbo.penUserAudit(AuditDateTime)
        create nonclustered index idx_penUserAudit_UserKey on [db-au-cba].dbo.penUserAudit(UserKey)

    end
    else
    begin

        delete ua
        from
            [db-au-cba].dbo.penUserAudit ua
            inner join etl_penUserAudit t on
                ua.UserAuditKey = t.UserAuditKey

    end

    insert into [db-au-cba].dbo.penUserAudit with(tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        UserAuditKey,
        UserKey,
        OutletKey,
        DomainID,
        UserAuditID,
        AuditDateTime,
        AuditDateTimeUTC,
        UserID,
        OutletID,
        FirstName,
        LastName,
        [Login],
        [Password],
        Initial,
        ASICNumber,
        AgreementDate,
        AccessLevel,
        AccessLevelName,
        AccreditationNumber,
        AllowAdjustPricing,
        [Status],
        InactiveDate,
        AgentCode,
        DateOfBirth,
        ASICCheck,
        Email,
        CreateDateTime,
        UpdateDateTime,
        MustChangePassword,
        AccountLocked,
        LoginFailedTimes,
        IsSuperUser,
        LastUpdateUserID,
        LastUpdateCRMUserID,
        LastLoggedIn,
        LastLoggedInUTC
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        UserAuditKey,
        UserKey,
        OutletKey,
        DomainID,
        UserAuditID,
        AuditDateTime,
        AuditDateTimeUTC,
        UserID,
        OutletID,
        FirstName,
        LastName,
        [Login],
        [Password],
        Initial,
        ASICNumber,
        AgreementDate,
        AccessLevel,
        AccessLevelName,
        AccreditationNumber,
        AllowAdjustPricing,
        [Status],
        InactiveDate,
        AgentCode,
        DateOfBirth,
        ASICCheck,
        Email,
        CreateDateTime,
        UpdateDateTime,
        MustChangePassword,
        AccountLocked,
        LoginFailedTimes,
        IsSuperUser,
        LastUpdateUserID,
        LastUpdateCRMUserID,
        LastLoggedIn,
        LastLoggedInUTC
    from
        etl_penUserAudit


end


GO
