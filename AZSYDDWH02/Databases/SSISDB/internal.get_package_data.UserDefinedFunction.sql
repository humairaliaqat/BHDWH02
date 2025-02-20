USE [SSISDB]
GO
/****** Object:  UserDefinedFunction [internal].[get_package_data]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [internal].[get_package_data](@key_name [nvarchar](255), @KEY [varbinary](8000), @IV [varbinary](8000), @project_version_lsn [bigint], @project_id [bigint])
RETURNS  TABLE (
	[name] [nvarchar](260) NULL,
	[package_data] [varbinary](max) NULL
) WITH EXECUTE AS N'AllSchemaOwner'
AS 
EXTERNAL NAME [ISSERVER].[Microsoft.SqlServer.IntegrationServices.Server.Security.CryptoGraphy].[GetDecryptedPackageData]
GO
