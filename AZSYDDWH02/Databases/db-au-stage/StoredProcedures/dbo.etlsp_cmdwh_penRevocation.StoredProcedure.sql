USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penRevocation]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penRevocation]
as
begin


/************************************************************************************************************************************
Author:         Leonardus Setyabudi
Date:           20130325
Prerequisite:   Requires DocGen ETL successfully run.
Description:    Parse revocation info from DocGen email log.
Change History:
                20130322 - LS - Procedure created
                20130409 - LS - updated to be agnostic to user/outlet revocation
                20130411 - LS - CRM User info for Outlet Revocation is stored in CRM Call Comment
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
                20140924 - LS - docgen's dates are not UTC @%@$#%!#%!@!@#$%%&*&
				20160321 - LT - Penguin 18.0, added US penguin instance

*************************************************************************************************************************************/

    set nocount on

    if object_id('etl_penRevocation') is not null
        drop table etl_penRevocation

    select
        o.CountryKey,
        o.CompanyKey,
        o.DomainKey,
        o.CountryKey + '-' + o.CompanyKey + convert(varchar, o.DomainID) + '-' + convert(varchar, l.Id) RevocationKey,
        o.OutletKey,
        l.Id RevocationID,
        l.CreateDateTime,
        dbo.xfn_ConvertLocaltoUTC(l.CreateDateTime, o.TimeZone) CreateDateTimeUTC,
        o.AlphaCode,
        ua.UserId,
        ua.FirstName + ' ' + ua.LastName UserName,
        ua.TemplateName
    into etl_penRevocation
    from
        penguin_Log_aucm l
        cross apply
        (
            select
                convert(xml, l.LogData).value('(/LogData/CountryCode)[1]', 'varchar(255)') CountryCode,
                convert(xml, l.LogData).value('(/LogData/AlphaCode)[1]', 'varchar(255)') AlphaCode,
                convert(xml, l.LogData).value('(/LogData/CompanyCode)[1]', 'varchar(255)') CompanyCode,
                convert(xml, l.LogData).value('(/LogData/UserId)[1]', 'varchar(255)') UserId,
                convert(xml, l.LogData).value('(/LogData/FirstName)[1]', 'varchar(255)') FirstName,
                convert(xml, l.LogData).value('(/LogData/LastName)[1]', 'varchar(255)') LastName,
                convert(xml, l.LogData).value('(/LogData/TemplateName)[1]', 'varchar(255)') TemplateName
        ) ua
        cross apply
        (
            select top 1
                o.CountryKey,
                o.CompanyKey,
                o.DomainKey,
                o.OutletKey,
                o.DomainID,
                o.AlphaCode,
                d.TimeZoneCode TimeZone
            from
                [db-au-cba].dbo.penOutlet o
                inner join [db-au-cba].dbo.penDomain d on
                    d.DomainKey = o.DomainKey
            where
                o.CountryKey = ua.CountryCode and
                o.CompanyKey = ua.CompanyCode and
                o.AlphaCode = ua.AlphaCode and
                o.OutletStatus = 'Current'
        ) o
    where
        l.DeliveryStatus = 'EMAILSENT'

 

    --create table if not exists
    if object_id('[db-au-cba].dbo.penRevocation') is null
    begin

        create table [db-au-cba].dbo.[penRevocation]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [DomainKey] varchar(41) null,
            [RevocationKey] varchar(41) null,
            [OutletKey] varchar(33) not null,
            [RevocationID] int not null,
            [CreateDateTime] datetime not null,
            [CreateDateTimeUTC] datetime not null,
            [AlphaCode] nvarchar(50) null,
            [UserID] int null,
            [UserName] nvarchar(101) null,
            [TemplateName] nvarchar(1000) null
        )

        create clustered index idx_penRevocationRevocationKey on [db-au-cba].dbo.penRevocation(RevocationKey)
        create nonclustered index idx_penRevocation_AlphaCode on [db-au-cba].dbo.penRevocation(AlphaCode,CountryKey)
        create nonclustered index idx_penRevocation_CreateDateTime on [db-au-cba].dbo.penRevocation(CreateDateTime)
        create nonclustered index idx_penRevocation_OutletKey on [db-au-cba].dbo.penRevocation(OutletKey,UserID)

    end
    else
    begin

        delete o
        from
            [db-au-cba].dbo.penRevocation o
            inner join etl_penRevocation t on
                t.RevocationKey = o.RevocationKey

    end

    --insert records
    insert into [db-au-cba].dbo.penRevocation with (tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        RevocationKey,
        OutletKey,
        RevocationID,
        CreateDateTime,
        CreateDateTimeUTC,
        AlphaCode,
        UserID,
        UserName,
        TemplateName
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        RevocationKey,
        OutletKey,
        RevocationID,
        CreateDateTime,
        CreateDateTimeUTC,
        AlphaCode,
        UserID,
        case
            when UserID is null then CRMUserName
            else UserName
        end UserName,
        TemplateName
    from
        etl_penRevocation t
        outer apply
        (
            select top 1
                cu.FirstName + ' ' + cu.LastName CRMUserName
            from
                [db-au-cba].dbo.penCRMCallComments cc
                inner join [db-au-cba].dbo.penCRMUser cu on
                    cc.CRMUserKey = cu.CRMUserKey
            where
                cc.CallDate < t.CreateDateTime and
                cc.OutletKey = t.OutletKey and
                cc.Category = 'Compliance' and
                cc.SubCategory = 'Revocation'
            order by
                cc.CallDate desc
        ) cc

end



GO
