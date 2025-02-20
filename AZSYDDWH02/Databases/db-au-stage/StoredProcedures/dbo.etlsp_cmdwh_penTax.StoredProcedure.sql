USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penTax]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_cmdwh_penTax]
as
begin
/*
20130617 - LS - TFS 7664/8556/8557, UK Penguin
20140616 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
20140617 - LS - TFS 12416, schema and index cleanup
20140618 - LS - TFS 12416, do not truncate surrogate key, let it fail and known instead of producing invalid data
20160321 - LT - Penguin 18.0, added US penguin instance
*/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('etl_penTax') is not null
        drop table etl_penTax

    --get GST
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey + convert(varchar, tt.TaxID) TaxKey,
        td.DomainID,
        null as RegionID,
        null as Region,
        tt.TaxId,
        tt.TaxName,
        tt.TaxRate,
        ttt.TaxType
    into etl_penTax
    from
        penguin_tblTax_aucm tt
        inner join penguin_tblDomain_aucm td on
            td.DomainId = tt.DomainId
        inner join penguin_tblTaxType_aucm ttt on
            ttt.DomainId = td.DomainId and ttt.TaxTypeId = tt.TaxTypeId
        cross apply dbo.fn_GetDomainKeys(td.DomainID, 'CM', 'AU')
    where
        tt.TaxRate is not null

   


    if object_id('[db-au-cba].dbo.penTax') is null
    begin

        create table [db-au-cba].dbo.[penTax]
        (
            [CountryKey] varchar(2) not null,
            [CompanyKey] varchar(5) not null,
            [TaxKey] varchar(41) null,
            [DomainID] int not null,
            [RegionID] int null,
            [Region] nvarchar(50) null,
            [TaxId] int not null,
            [TaxName] nvarchar(50) null,
            [TaxRate] numeric(18,5) null,
            [TaxType] nvarchar(50) null,
            [DomainKey] varchar(41) null
        )

        create clustered index idx_penTax_TaxKey on [db-au-cba].dbo.penTax(TaxKey)
        create nonclustered index idx_penTax_CountryKey on [db-au-cba].dbo.penTax(CountryKey)

    end
    else
    begin

        delete [db-au-cba].dbo.penTax
        where
            TaxKey in
            (
                select
                    TaxKey
                from
                    etl_penTax
            )

    end

    insert [db-au-cba].dbo.penTax with(tablockx)
    (
        CountryKey,
        CompanyKey,
        DomainKey,
        TaxKey,
        DomainID,
        RegionID,
        Region,
        TaxId,
        TaxName,
        TaxRate,
        TaxType
    )
    select
        CountryKey,
        CompanyKey,
        DomainKey,
        TaxKey,
        DomainID,
        RegionID,
        Region,
        TaxId,
        TaxName,
        TaxRate,
        TaxType
    from
        etl_penTax

end



GO
