USE [db-au-workspace]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_cleanexcel]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_cleanexcel](@Input varchar(max))
returns varchar(max)
as
begin
    
    declare @output varchar(max)

    set @output = replace(@Input, char(9), ' ')
    set @output = replace(@output, char(10), ' ')
    set @output = replace(@output, char(13), ' ')
    set @output = replace(@output, '  ', ' ')

    --while patindex('%[^a-z ]%', @output) > 0
    --    set @output = stuff(@output, patindex('%[^a-z ]%', @output), 1, ' ')

    return @output

end
GO
