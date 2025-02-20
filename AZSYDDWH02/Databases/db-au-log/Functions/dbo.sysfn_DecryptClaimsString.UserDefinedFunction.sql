USE [db-au-log]
GO
/****** Object:  UserDefinedFunction [dbo].[sysfn_DecryptClaimsString]    Script Date: 20/02/2025 10:24:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [dbo].[sysfn_DecryptClaimsString](@EncryptedString varbinary(max))
returns varbinary(max)
as
begin

    return decryptbykeyautocert(cert_id('ClaimsCertificate'), null, @EncryptedString, 0, null)

end


GO
