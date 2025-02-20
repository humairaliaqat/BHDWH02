USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[sysfn_EncryptB2BString]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[sysfn_EncryptB2BString](@String varchar(64))
returns varbinary(max)
as
begin

  return hashbytes('SHA1', 'R8>D$)q}' + @String)
  
end  

GO
