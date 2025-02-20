USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_FormatPhone]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_FormatPhone] (@PhoneNumber varchar(100))
returns varchar(100)
as
begin

    declare @res varchar(100)
    
    set @res = ltrim(rtrim(@PhoneNumber))
    if @res like '00%'
        set @res = right(@res, len(@res) - 1)

    if len(@res) > 8
    begin

        if @res like '04%'
            set @res = left(@res, 4) + ' ' + substring(@res, 5, 3) + ' ' + right(@res, len(@res) - len(left(@res, 4) + substring(@res, 5, 3)))
            
        else 
            set @res = '(' + left(@res, 2) + ') ' + substring(@res, 3, 4) + ' ' + right(@res, len(@res) - len(left(@res, 2) + substring(@res, 3, 4)))

    end
    
    else
        set @res = 'x' + @res

    return @res

end

GO
