USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penOutletOutgoingEmailInfo]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penOutletOutgoingEmailInfo]
as
begin

/************************************************************************************************************************************
Author:         Linus Tor
Date:           20120125
Prerequisite:   Requires Penguin Data Model ETL successfully run.
Description:    OutletOutgoingEmailInfo table contains agency email template details.
                This transformation adds essential key fields
Change History:
                20120125 - LT - Procedure created
                20121107 - LS - refactoring & domain related changes
                20130617 - LS - TFS 7664/8556/8557, UK Penguin
                20130728 - LT - Amended proceudre to cater for UK Penguin ETL/Refresh window.
                20140613 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
                20140617 - LS - TFS 12416, schema and index cleanup
                20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
				20160321 - LT - Penguin 18.0, Added US Penguin instance

*************************************************************************************************************************************/

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    set nocount on

    if object_id('etl_penOutletOutgoingEmailInfo') is not null
        drop table etl_penOutletOutgoingEmailInfo

    select
        CountryKey,
        CompanyKey,
        PrefixKey + cast(ooei.OutletID as varchar) as OutletKey,
        ooei.OutletID,
        ooei.EmailTypeID,
        dbo.fn_GetReferenceValueByID(ooei.EmailTypeID, CompanyKey, CountrySet) EmailType,
        ooei.EmailSubject,
        ooei.EmailFromDisplayName,
        ooei.EmailFromAddress,
        ooei.EmailCertOnPurchase
    into etl_penOutletOutgoingEmailInfo
    from
        penguin_tblOutletOutgoingEmailInfo_aucm ooei
        inner join penguin_tblOutlet_aucm o on
            o.OutletId = ooei.OutletID
        cross apply dbo.fn_GetOutletDomainKeys(o.OutletID, 'CM', 'AU') dk

   


    if object_id('[db-au-cba].dbo.penOutletOutgoingEmailInfo') is null
    begin

        create table [db-au-cba].dbo.[penOutletOutgoingEmailInfo]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [OutletKey] varchar(33) not null,
            [OutletID] int not null,
            [EmailTypeID] int null,
            [EmailType] nvarchar(50) null,
            [EmailSubject] nvarchar(250) null,
            [EmailFromDisplayName] nvarchar(50) null,
            [EmailFromAddress] varchar(50) not null,
            [EmailCertOnPurchase] bit null
        )

        create clustered index idx_penOutletOutgoingEmailInfo_OutletKey on [db-au-cba].dbo.penOutletOutgoingEmailInfo(OutletKey)
        create nonclustered index idx_penOutletOutgoingEmailInfo_CountryKey on [db-au-cba].dbo.penOutletOutgoingEmailInfo(CountryKey)

    end
    else
    begin

        delete a
        from
            [db-au-cba].dbo.penOutletOutgoingEmailInfo a
            inner join etl_penOutletOutgoingEmailInfo b on
                a.OutletKey = b.OutletKey

    end

    insert into [db-au-cba].dbo.penOutletOutgoingEmailInfo with(tablockx)
    (
        CountryKey,
        CompanyKey,
        OutletKey,
        OutletID,
        EmailTypeID,
        EmailType,
        EmailSubject,
        EmailFromDisplayName,
        EmailFromAddress,
        EmailCertOnPurchase
    )
    select
        CountryKey,
        CompanyKey,
        OutletKey,
        OutletID,
        EmailTypeID,
        EmailType,
        EmailSubject,
        EmailFromDisplayName,
        EmailFromAddress,
        EmailCertOnPurchase
    from
        etl_penOutletOutgoingEmailInfo

end



GO
