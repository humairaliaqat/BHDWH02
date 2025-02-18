USE [SSISDB]
GO
/****** Object:  StoredProcedure [internal].[validate_package_internal]    Script Date: 18/02/2025 2:36:19 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [internal].[validate_package_internal]
	@project_id [bigint],
	@package_id [bigint],
	@version_id [bigint],
	@validation_id [bigint],
	@environment_scope [nchar](1),
	@use32bitruntime [smallint]
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [ISSERVER].[Microsoft.SqlServer.IntegrationServices.Server.ServerApi].[ValidatePackageInternal]
GO
