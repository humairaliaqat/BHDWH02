USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[sysfn_BinToHexString]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[sysfn_BinToHexString] (@bin varbinary(max))
returns varchar(max)
as
begin

  return convert(varchar(max), @bin, 1)
  
end  


GO
