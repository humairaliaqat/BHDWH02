USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_CleanSpaces]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_CleanSpaces] 
(
    @s varchar(max)
) 
returns varchar(max)
with schemabinding
begin

    if @s is null
        return ''

    set @s = replace(@s, char(10), ' ')
    set @s = replace(@s, char(13), ' ')
    set @s = replace(@s, char(9), ' ')

    --REQ-2338, LL, 2019-10-24, replace | with blank
    set @s = replace(@s, '|', '')
    
    while @s like '%  %'
        set @s = replace(@s, '  ', ' ')

    set @s = ltrim(rtrim(@s))

    return @s

end
GO
