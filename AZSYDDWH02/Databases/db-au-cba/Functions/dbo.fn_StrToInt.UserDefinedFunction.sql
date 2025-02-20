USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_StrToInt]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_StrToInt](@String varchar(8000))
returns bigint
as
begin
  
  declare @IncorrectCharLoc smallint
  
  set @IncorrectCharLoc = patindex('%[^0-9]%', @String)
  
  while @IncorrectCharLoc > 0
  begin
  
    set @String = stuff(@String, @IncorrectCharLoc, 1, '')
    set @IncorrectCharLoc = patindex('%[^0-9]%', @String)
  
  end
  
  if len(@String) > 15
    set @String = '0'
  
  return convert(bigint, @String)
  
end




GO
