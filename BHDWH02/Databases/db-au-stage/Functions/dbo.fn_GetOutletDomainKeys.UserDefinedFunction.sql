USE [db-au-stage]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetOutletDomainKeys]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_GetOutletDomainKeys]
(
    @OutletID int,
    @CompanyKey varchar(5),
    @CountrySet varchar(5)
)
returns @output table
(
	CountrySet varchar(5),
    CountryKey varchar(2),
    CompanyKey varchar(5),
    DomainKey varchar(41),
    PrefixKey varchar(41),
    TimeZone varchar(50),
    DomainID int
)
as
begin
/*
20130614 - LS - TFS 7664/8556/8557, UK Penguin
20160321 - LT - Penguin 18.0, added US Penguin instance
20160720 - LT - ETL 2.0 redesign
*/

    declare @domainid int

	if @CountrySet = 'AU'
	begin
	
        if @CompanyKey = 'CM'
            select top 1
                @domainid = o.DomainID
            from
                AU_PenguinSharp_Active_tblOutlet o
            where
                o.OutletID = @OutletID

        else if @CompanyKey = 'TIP'
            select top 1
                @domainid = o.DomainID
            from
                AU_TIP_PenguinSharp_Active_tblOutlet o
            where
                o.OutletID = @OutletID
    
    end
    
	else if @CountrySet = 'UK'
	begin
	
        select top 1
            @domainid = o.DomainID
        from
            UK_PenguinSharp_Active_tblOutlet o
        where
            o.OutletID = @OutletID
			
	end
	else if @CountrySet = 'US'
	begin
	
        select top 1
            @domainid = o.DomainID
        from
            US_PenguinSharp_Active_tblOutlet o
        where
            o.OutletID = @OutletID
			
	end

    insert into @output
    (
		CountrySet,
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey,
        TimeZone,
        DomainID
    )
    select
		CountrySet,
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey,
        TimeZone,
        @domainid DomainID
    from
        dbo.fn_GetDomainKeys(@domainid, @CompanyKey, @CountrySet)

    return

end

GO
