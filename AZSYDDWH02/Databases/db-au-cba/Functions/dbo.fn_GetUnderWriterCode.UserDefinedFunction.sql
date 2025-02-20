USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetUnderWriterCode]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_GetUnderWriterCode]
(
    @CompanyKey varchar(5),
    @CountryKey varchar(5),
    @AlphaCode varchar(50),
    @IssueDate date
)
returns varchar(50)
as
begin

    declare @code varchar(50)

    select
        @code =
        case 
            when @CompanyKey = 'TIP' and (@IssueDate < '2017-06-01' or (@AlphaCode in ('APN0004', 'APN0005') and @IssueDate < '2017-07-01')) then 'TIP-GLA'
            when @CompanyKey = 'TIP' and (@IssueDate >= '2017-06-01' or (@AlphaCode in ('APN0004', 'APN0005') and @IssueDate >= '2017-07-01')) then 'TIP-ZURICH'
            when @CountryKey in ('AU', 'NZ') and @IssueDate >= '2009-07-01' and @IssueDate < '2017-06-01' then 'GLA'
            when @CountryKey in ('AU', 'NZ') and @IssueDate >= '2017-06-01' then 'ZURICH' 
            when @CountryKey in ('AU', 'NZ') and @IssueDate <= '2009-06-30' then 'VERO' 
            when @CountryKey in ('UK') and @IssueDate >= '2009-09-01' then 'ETI' 
            when @CountryKey in ('UK') and @IssueDate < '2009-09-01' then 'UKU' 
            when @CountryKey in ('MY', 'SG') then 'ETIQA' 
            when @CountryKey in ('CN') then 'CCIC' 
            when @CountryKey in ('ID') then 'Simas Net' 
            when @CountryKey in ('US') then 'AON'
            else 'OTHER' 
        end 

    return @code

end
GO
