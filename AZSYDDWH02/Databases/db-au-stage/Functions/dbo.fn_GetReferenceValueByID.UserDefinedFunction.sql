USE [db-au-stage]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetReferenceValueByID]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_GetReferenceValueByID]
(
    @ReferenceID int,
    @CompanyKey varchar(5),
    @CountrySet varchar(5)
)
returns nvarchar(50)
as
begin
/*
20130617 - LS - TFS 7664/8556/8557, UK Penguin
20140613 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
20160321 - LT - Penguin 18.0, added US Penguin instance
*/

    declare @output nvarchar(50)

    if @CountrySet = 'AU'
    begin

        if @CompanyKey = 'CM'
            select top 1
                @output = Value
            from
                penguin_tblReferenceValue_aucm
            where
                ID = @ReferenceID

        else if @CompanyKey = 'TIP'
            select top 1
                @output = Value
            from
                penguin_tblReferenceValue_autp
            where
                ID = @ReferenceID

    end

    else if @CountrySet = 'UK'
    begin

        select top 1
            @output = Value
        from
            penguin_tblReferenceValue_ukcm
        where
            ID = @ReferenceID

    end

    else if @CountrySet = 'US'
    begin

        select top 1
            @output = Value
        from
            penguin_tblReferenceValue_uscm
        where
            ID = @ReferenceID

    end

    return @output

end



GO
