USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[sysfn_DecryptClaimsString]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[sysfn_DecryptClaimsString](@EncryptedString varbinary(max))
returns varbinary(max)
as
begin

    return [db-au-stage].dbo.sysfn_DecryptClaimsString(@EncryptedString)
    
end
GO
