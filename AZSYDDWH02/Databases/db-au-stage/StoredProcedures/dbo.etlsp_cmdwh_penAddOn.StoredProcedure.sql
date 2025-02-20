USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penAddOn]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penAddOn]
as
begin


/*
20130617 - LS - TFS 7664/8556/8557, UK Penguin
20130726 - LT - Amended proceudre to cater for UK Penguin ETL/Refresh window.
20140612 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
20140617 - LS - TFS 12416, schema and index cleanup
20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
20160321 - LT - Penguin 18.0, Added US penguin instance
20180913 - LT - Customised for CBA
*/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penAddon') is not null
        drop table etl_penAddon

   select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, a.AddOnID) AddOnKey,
        a.AddOnID,
        a.DomainID,
        a.AddOnTypeID,
        a.AddOnCode,
        a.AddOnName,
        a.AllowMultiple,
        a.DisplayName,
        a.isRateCardBased,
        a.AddOnGroupID,
        a.ControlLabel,
        a.[Description],
        a.AddOnControlTypeID,
        a.DefaultValue,
        a.isMandatory
    into etl_penAddon
    from
        penguin_tblAddOn_aucm a
        cross apply dbo.fn_GetDomainKeys(a.DomainId, 'CM', 'AU') dk


    if object_id('[db-au-cba].dbo.penAddOn') is null
    begin

        create table [db-au-cba].dbo.[penAddOn]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [AddOnKey] varchar(41) null,
            [AddOnID] int null,
            [DomainID] int null,
            [AddOnTypeID] int null,
            [AddOnCode] nvarchar(50) null,
            [AddOnName] nvarchar(50) null,
            [AllowMultiple] bit null,
            [DisplayName] nvarchar(100) null,
            [isRateCardBased] bit null,
            [AddOnGroupID] int null,
            [ControlLabel] nvarchar(500) null,
            [Description] nvarchar(500) null,
            [AddOnControlTypeID] int null,
            [DefaultValue] nvarchar(50) null,
            [isMandatory] bit not null,
            [DomainKey] varchar(41) null
        )

        create clustered index idx_penAddOn_AddOnKey on [db-au-cba].dbo.penAddOn(AddOnKey)
        create nonclustered index idx_penAddOn_CountryKey on [db-au-cba].dbo.penAddOn(CountryKey,CompanyKey,AddOnID)

    end
    else
    begin

        delete a
        from
            [db-au-cba].dbo.penAddon a
            inner join etl_penAddon b on
                a.AddonKey = b.AddonKey

    end

    insert [db-au-cba].dbo.penAddOn with(tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        AddOnKey,
        AddOnID,
        DomainID,
        AddOnTypeID,
        AddOnCode,
        AddOnName,
        AllowMultiple,
        DisplayName,
        isRateCardBased,
        AddOnGroupID,
        ControlLabel,
        [Description],
        AddOnControlTypeID,
        DefaultValue,
        isMandatory
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        AddOnKey,
        AddOnID,
        DomainID,
        AddOnTypeID,
        AddOnCode,
        AddOnName,
        AllowMultiple,
        DisplayName,
        isRateCardBased,
        AddOnGroupID,
        ControlLabel,
        [Description],
        AddOnControlTypeID,
        DefaultValue,
        isMandatory
    from
        etl_penAddon

end



GO
