USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetXMLElement]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_GetXMLElement]
(
	@XML varchar(max),
	@Element varchar(100)
)
returns varchar(8000)
as

/****************************************************************************************************/
--  Name:           dbo.fn_GetXMLElement
--  Author:         Linus Tor 
--  Date Created:   20150618
--  Description:    This function returns an element value from an XML string
--
--  Parameters:     @XML: XML string
--					@Element: element tag 
--   
--  Change History: 20150618 - LT - Created
--                  
/****************************************************************************************************/

begin

	declare	@i int
	declare	@j int
	declare @Value varchar(8000)

	--get opening tag
	select @i = charindex('<' + @Element + '>', @XML)
	
	--get closing tag
	select @j = charindex('</' + @Element + '>', @XML)
	
	if @i <> 0 and @j > @i
	begin
		select @i = @i + len('<' + @Element + '>')
		select @Value = substring(@XML, @i, @j - @i)
	end
	
	return @Value

end



GO
