USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penCRMUser]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penCRMUser]
as
begin


/************************************************************************************************************************************
Author:         Linus Tor
Date:           20120125
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    CRM User table contains users of B2B/B2C/CRM attribute details.
                This transformation adds essential key fields and slow changing dimensions
Change History:
                20120430 - LT - Procedure created
                20121105 - LS - refactoring & domain related changes
                20121115 - LS - bug fix, duplicate values on penCRMUsers. Change roles (1 - m) to csv format
                20130614 - LS - TFS 7664/8556/8557, tblCRMUser.[Status] changed from datetime to varchar(15)
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20130723 - LS - TFS 7664/8556/8557, CRM User can be assigned to multiple department, limit to 1 for now
                20130726 - LT - Amended proceudre to cater for UK Penguin ETL/Refresh window
                20130807 - LS - bug fix on UK's data, domain should be set to 11
                20140325 - LS - bug fix, no related data for non AU countries in transaction sourced from AU_CM database
                20140613 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
				20141216 - LS - P11.5, username from 50 to 100 nvarchar
				20150107 - LT - F22718 - Added UPDATE statement to fix CRM user department to correct value where user belong to more than 1
								departments, and the top 1 department is not their actual department.
				20160321 - LT - Penguin 18.0, added US Penguin instance
				20190528 - RS - Penguin Release 35.5 Added column PhoneNumber
*************************************************************************************************************************************/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penCRMUser') is not null
        drop table etl_penCRMUser

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, u.ID) CRMUserKey,
        7 as DomainID,
        u.ID as CRMUserID,
        u.FirstName,
        u.Inital as Initial,
        u.LastName,
        u.UserName,
        case
            when [Status] <> 'ACTIVE' then dbo.xfn_ConvertUTCtoLocal(u.UpdateDateTime, TimeZone)
            else null
        end [Status],
        [Status] StatusDescription,
        d.DepartmentID,
        dbo.fn_GetReferenceValueByID(d.DepartmentID, CompanyKey, CountrySet) Department,
        d.AccessLevel as AccessLevelID,
        dbo.fn_GetReferenceValueByID(d.AccessLevel, CompanyKey, CountrySet) AccessLevel,
        (
            select
                dbo.fn_GetReferenceValueByID(r.RoleID, CompanyKey, CountrySet) +
                case
                    when r.RoleID <> max(r.RoleID) over () then ','
                    else ''
                end
            from
                penguin_tblCRMUserRole_aucm r
            where
                u.ID = r.CRMUserID
            order by r.RoleID
            for xml path('')
        ) UserRole,
		u.PhoneNumber
    into etl_penCRMUser
    from
        penguin_tblCRMUser_aucm u
        cross apply
        (
            select
                DomainId
            from
                [db-au-cba]..usrDomain
            where
                CountryCode <> 'UK'
        ) dm
        cross apply dbo.fn_GetDomainKeys(dm.DomainId, 'CM', 'AU') dk
        outer apply
        (
            select top 1 *
            from
                penguin_tblCRMUserDepartment_aucm d
            where
                u.ID = d.CRMUserID
            order by
                d.ID
        ) d



	--20150107_LT_F22718 - The following UPDATE statement is to fix CRM users with multiple departments where the top 1 department is not their actual department
	Update etl_penCRMUser
	set
		Department = case when UserRole = 'BDM' and Department = 'Finance' then 'SALES'
						  when UserRole = 'Account Manager' and Department = 'Finance' then 'SALES SUPPORT'
						  else Department
					 end
	where 
		CountryKey = 'AU' and 
		CompanyKey = 'CM' and
		StatusDescription = 'ACTIVE'
						 

    if object_id('[db-au-cba].dbo.penCRMUser') is null
    begin

        create table [db-au-cba].dbo.[penCRMUser]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [CRMUserKey] varchar(41) not null,
            [CRMUserID] int not null,
            [FirstName] nvarchar(50) null,
            [LastName] nvarchar(50) null,
            [Initial] nvarchar(10) null,
            [UserName] nvarchar(100) null,
            [Status] datetime null,
            [DepartmentID] int null,
            [Department] nvarchar(50) null,
            [AccessLevelID] int null,
            [AccessLevel] nvarchar(50) null,
            [UserRole] nvarchar(512) null,
            [DomainKey] varchar(41) null,
            [DomainID] int null,
            [StatusDescription] varchar(15) null,
			[PhoneNumber] NVARCHAR(100) null
        )

        create clustered index idx_penCRMUser_CRMUserKey on [db-au-cba].dbo.penCRMUser(CRMUserKey)
        create nonclustered index idx_penCRMUser_CountryKey on [db-au-cba].dbo.penCRMUser(CountryKey)
        create nonclustered index idx_penCRMUser_CRMUserID on [db-au-cba].dbo.penCRMUser(CRMUserID)
        create nonclustered index idx_penCRMUser_StatusDescription on [db-au-cba].dbo.penCRMUser(StatusDescription)

    end
    else
    begin

        delete a
        from
            [db-au-cba].dbo.penCRMUser a
            inner join etl_penCRMUser b on
                a.CRMUserKey = b.CRMUserKey

    end

    insert into [db-au-cba].dbo.penCRMUser with(tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        CRMUserKey,
        DomainID,
        CRMUserID,
        FirstName,
        LastName,
        Initial,
        UserName,
        [Status],
        StatusDescription,
        DepartmentID,
        Department,
        AccessLevelID,
        AccessLevel,
        UserRole,
		PhoneNumber
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        CRMUserKey,
        DomainID,
        CRMUserID,
        FirstName,
        LastName,
        Initial,
        UserName,
        [Status],
        StatusDescription,
        DepartmentID,
        Department,
        AccessLevelID,
        AccessLevel,
        left(UserRole, 512),
		PhoneNumber
    from
        etl_penCRMUser

end



GO
