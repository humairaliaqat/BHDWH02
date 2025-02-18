USE [db-au-stage]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetDomainKeys]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE function [dbo].[fn_GetDomainKeys]
(
    @DomainID int,
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
    TimeZone varchar(50)
)
as
begin
/*
20130614 - LS - TFS 7664/8556/8557, UK Penguin
20130821 - LS - catch condition if tblDomain get wiped (clash between 2 etls)
20160318 - LT - Penguin 18.0 release, added US penguin instance
20160720 - LT - ETL 2.0 rewrite.
*/

    declare
        @countrykey varchar(2),
        @domainkey varchar(41),
        @prefixkey varchar(41),
        @domainchar varchar(10),
        @tz varchar(50)

	if @CountrySet = 'AU'
	begin
	
		if @CompanyKey = 'CM'
			select top 1
				@countrykey = CountryCode,
				@domainchar = convert(varchar, d.DomainID),
				@tz = d.TimeZoneCode
			from
				AU_PenguinSharp_Active_tblDomain d
			where
				d.DomainID = @DomainID

		else if @CompanyKey = 'TIP'
			select top 1
				@countrykey = CountryCode,
				@domainchar = convert(varchar, d.DomainID),
				@tz = d.TimeZoneCode
			from
				AU_TIP_PenguinSharp_Active_tblDomain d
			where
				d.DomainID = @DomainID

	end

	else if @CountrySet = 'UK'
	begin
	
		select top 1
			@countrykey = CountryCode,
			@domainchar = convert(varchar, d.DomainID),
			@tz = d.TimeZoneCode
		from
			UK_PenguinSharp_Active_tblDomain d
		where
			d.DomainID = @DomainID
			
	end
	
	else if @CountrySet = 'US'
	begin
	
		select top 1
			@countrykey = CountryCode,
			@domainchar = convert(varchar, d.DomainID),
			@tz = d.TimeZoneCode
		from
			US_PenguinSharp_Active_tblDomain d
		where
			d.DomainID = @DomainID
			
	end

	/*pokemon*/
	if @countrykey is null
	begin
	    
		select top 1
			@countrykey = CountryCode,
			@domainchar = convert(varchar, d.DomainID),
			@tz = d.TimeZoneCode
		from
			[db-au-cmdwh]..usrDomain d
		where
			d.DomainID = @DomainID
	
	end
	
    set @countrykey = isnull(@countrykey, '')
    set @domainchar = isnull(@domainchar, '')
    set @domainkey = left(@countrykey + '-' + @CompanyKey + '-' + @domainchar, 41)
    set @tz = isnull(@tz, 'AUS Eastern Standard Time')
    set @prefixkey = @countrykey + '-' + @CompanyKey + @domainchar + '-'

    insert into @output
    (
		CountrySet,
        CountryKey,
        CompanyKey,
        DomainKey,
        PrefixKey,
        TimeZone
    )
    select
		@CountrySet,
        @countrykey,
        @CompanyKey,
        @domainkey,
        @prefixkey,
        @tz

    return

end



GO
