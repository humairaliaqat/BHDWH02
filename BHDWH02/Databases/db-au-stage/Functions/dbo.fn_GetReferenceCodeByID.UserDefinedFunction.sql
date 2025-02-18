USE [db-au-stage]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetReferenceCodeByID]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_GetReferenceCodeByID]
(
    @ReferenceID int,
    @CompanyKey varchar(5),
    @CountrySet varchar(5)
)
returns nvarchar(50)
as
begin
/*
20130619 - LS - Created
20140613 - LS - TFS 12416, Penguin 9.0 / China (Unicode)
20160321 - LT - Penguin 18.0, added US penguin instance
20160720 - LT - ETL 2.0 redesign
*/

    declare @output nvarchar(50)

    if @CountrySet = 'AU'
    begin

        if @CompanyKey = 'CM'
            select top 1
                @output = Code
            from
                AU_PenguinSharp_Active_tblReferenceValue
            where
                ID = @ReferenceID

        else if @CompanyKey = 'TIP'
            select top 1
                @output = Code
            from
                AU_TIP_PenguinSharp_Active_tblReferenceValue
            where
                ID = @ReferenceID

    end

    else if @CountrySet = 'UK'
    begin

        select top 1
            @output = Code
        from
            UK_PenguinSharp_Active_tblReferenceValue
        where
            ID = @ReferenceID

    end

    else if @CountrySet = 'US'
    begin

        select top 1
            @output = Code
        from
            US_PenguinSharp_Active_tblReferenceValue
        where
            ID = @ReferenceID

    end

    return @output

end


GO
