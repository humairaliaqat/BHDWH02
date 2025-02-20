USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penArea]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penArea]
as
begin
/*
20130617 - LS - TFS 7664/8556/8557, UK Penguin
20130726 - LT - Amended proceudre to cater for UK Penguin ETL/Refresh window.
20140613 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
20140617 - LS - TFS 12416, schema and index cleanup
20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
20160321 - LT - Penguin 18.0, added US penguin instance
20170419 - LT - Penguin 24.0, increased AreaName to nvarchar(100)
20180913 - LT - Customised for CBA
*/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penArea') is not null
        drop table etl_penArea

    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, AreaID) AreaKey,
        a.AreaID,
        DomainID,
        Area as AreaName,
        Domestic,
        MinimumDuration,
        ChildAreaID,
        AreaGroup,
        NonResident,
        Weighting,
        case
            when a.Area like '%Inbound%' and a.Domestic = 0 then 'Domestic (Inbound)'
            when a.Domestic = 1 then 'Domestic'
            else 'International'
        end as AreaType,
        'Area ' + cast(a.Weighting as varchar) as AreaNumber,
        AreaSetID,
        Code AreaCode
    into etl_penArea
    from
        penguin_tblArea_aucm a
        cross apply dbo.fn_GetDomainKeys(a.DomainId, 'CM', 'AU') dk




    if object_id('[db-au-cba].dbo.penArea') is null
    begin

        create table [db-au-cba].dbo.[penArea]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [AreaKey] varchar(41) null,
            [AreaID] int null,
            [DomainID] int null,
            [AreaName] nvarchar(100) null,
            [Domestic] bit null,
            [MinimumDuration] numeric(5,4) null,
            [ChildAreaID] int null,
            [AreaGroup] int null,
            [NonResident] bit null,
            [Weighting] int null,
            [DomainKey] varchar(41) null,
            [AreaType] varchar(50) null,
            [AreaNumber] varchar(20) null,
            [AreaSetID] int null,
            [AreaCode] nvarchar(3) null
        )

        create clustered index idx_penArea_AreaKey on [db-au-cba].dbo.penArea(AreaKey)
        create nonclustered index idx_penArea_CountryKey on [db-au-cba].dbo.penArea(CountryKey,CompanyKey,AreaName) include (AreaID)

    end
    else
    begin

        delete a
        from
            [db-au-cba].dbo.penArea a
            inner join etl_penArea b on
                a.AreaKey = b.AreaKey

    end

    insert [db-au-cba].dbo.penArea with(tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        AreaKey,
        AreaID,
        DomainID,
        AreaName,
        Domestic,
        MinimumDuration,
        ChildAreaID,
        AreaGroup,
        NonResident,
        Weighting,
        AreaType,
        AreaNumber,
        AreaSetId,
        AreaCode
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        AreaKey,
        AreaID,
        DomainID,
        AreaName,
        Domestic,
        MinimumDuration,
        ChildAreaID,
        AreaGroup,
        NonResident,
        Weighting,
        AreaType,
        AreaNumber,
        AreaSetId,
        AreaCode
    from
        etl_penArea

end



GO
