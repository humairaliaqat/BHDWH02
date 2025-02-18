USE [SSISDB]
GO
/****** Object:  StoredProcedure [internal].[check_schema_version_internal]    Script Date: 18/02/2025 2:36:19 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [internal].[check_schema_version_internal]
	@operationId [bigint],
	@use32bitruntime [smallint],
	@serverBuild [nvarchar](1024) OUTPUT,
	@schemaVersion [int] OUTPUT,
	@schemaBuild [nvarchar](1024) OUTPUT,
	@assemblyBuild [nvarchar](1024) OUTPUT,
	@componentVersion [nvarchar](1024) OUTPUT,
	@compatibilityStatus [smallint] OUTPUT
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [ISSERVER].[Microsoft.SqlServer.IntegrationServices.Server.ServerApi].[CheckSchemaVersionInternal]
GO
