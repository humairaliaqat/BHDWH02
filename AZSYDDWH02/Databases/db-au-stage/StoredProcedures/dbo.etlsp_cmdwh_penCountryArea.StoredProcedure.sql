USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_cmdwh_penCountryArea]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE procedure [dbo].[etlsp_cmdwh_penCountryArea]
as
begin


/*
20151113 - LT - Created
20160321 - LT - Penguin 18.0, added US Penguin instance
*/

    set nocount on

    /* staging index */
    exec etlsp_StagingIndex_Penguin

    if object_id('[db-au-stage].dbo.etl_penCountryArea') is not null
        drop table [db-au-stage].dbo.etl_penCountryArea

    select 
        CountryKey,
        CompanyKey,
        DomainKey,
		PrefixKey + convert(varchar, ca.CountryAreaID) CountryAreaKey,
		PrefixKey + convert(varchar, c.CountryID) DestinationKey,
		ca.CountryAreaID,
		c.CountryID,
        c.Country,
        ca.AreaID,
		a.Area,
		a.Weighting
    into [db-au-stage].dbo.etl_penCountryArea
    from
        [dbo].[penguin_tblCountry_aucm]  c
		inner join penguin_tblCountryArea_aucm ca on
			c.CountryID = ca.CountryID
		inner join penguin_tblArea_aucm a on ca.AreaID = a.AreaID
		cross apply dbo.fn_GetDomainKeys(a.DomainID, 'CM', 'AU') dk

    


    if object_id('[db-au-cba].dbo.penCountryArea') is null
    begin

        create table [db-au-cba].dbo.[penCountryArea]
        (
			CountryKey varchar(2) null,
			CompanyKey varchar(5) null,
			DomainKey varchar(41) null,
			CountryAreaKey varchar(41) null,
			DestinationKey varchar(41) null,
			CountryAreaID int null,
			CountryID int null,
			CountryName nvarchar(50) null,
			AreaID int null,
			Area nvarchar(100) null,
			Weighting int null
        )
        create clustered index idx_penCountryArea_CountryAreaKey on [db-au-cba].dbo.penCountryArea(CountryAreaKey)
		create nonclustered index idx_penCountryArea_DestinationKey on [db-au-cba].dbo.penCountryArea(DestinationKey)
        create nonclustered index idx_penCountryArea_CountryName on [db-au-cba].dbo.penCountryArea(CountryName)
		create nonclustered index idx_penCountryArea_Area on [db-au-cba].dbo.penCountryArea(Area)

    end
    else
		delete a
		from [db-au-cba].dbo.penCountryArea a
			join [db-au-stage].dbo.etl_penCountryArea b on
				a.CountryAreaKey = b.CountryAreaKey
		

		
    insert [db-au-cba].dbo.penCountryArea with(tablockx)
    (
		CountryKey,
		CompanyKey,
		DomainKey,
		CountryAreaKey,
		DestinationKey,
		CountryAreaID,
		CountryID,
		CountryName,
		AreaID,
		Area,
		Weighting
    )
    select
		CountryKey,
		CompanyKey,
		DomainKey,
		CountryAreaKey,
		DestinationKey,
		CountryAreaID,
		CountryID,
		Country as CountryName,
		AreaID,
		Area,
		Weighting
    from
      [db-au-stage].dbo.etl_penCountryArea

end


GO
