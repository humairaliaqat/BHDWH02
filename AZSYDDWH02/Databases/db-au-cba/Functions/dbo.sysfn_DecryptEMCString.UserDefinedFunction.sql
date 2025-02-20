USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[sysfn_DecryptEMCString]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[sysfn_DecryptEMCString](@EncryptedString varbinary(max))
returns varbinary(max)
as
begin

    return decryptbykeyautocert(cert_id('EMCCertificate'), null, @EncryptedString, 0, null)
    
end
GO
