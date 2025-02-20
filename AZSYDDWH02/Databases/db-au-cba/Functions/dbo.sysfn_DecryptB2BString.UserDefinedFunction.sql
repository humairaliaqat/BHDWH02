USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[sysfn_DecryptB2BString]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[sysfn_DecryptB2BString](@EncryptedString varbinary(128))
returns varchar(50)
as
begin

  declare @output varchar(50)
  
  select @output = AlphaCode
  from usrSHAOutlet
  where HashedAlphaCode = convert(varchar(max), @EncryptedString, 1)

  return @output
  
end  



GO
