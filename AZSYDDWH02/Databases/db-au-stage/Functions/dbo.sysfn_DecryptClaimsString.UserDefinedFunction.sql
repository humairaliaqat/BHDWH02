USE [db-au-stage]
GO
/****** Object:  UserDefinedFunction [dbo].[sysfn_DecryptClaimsString]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[sysfn_DecryptClaimsString](@EncryptedString varbinary(max))
returns varbinary(max)
as
begin

    return [db-au-log].dbo.[sysfn_DecryptClaimsString](@EncryptedString)

end

GO
