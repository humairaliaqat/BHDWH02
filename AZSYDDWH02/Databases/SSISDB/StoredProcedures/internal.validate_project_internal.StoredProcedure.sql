USE [SSISDB]
GO
/****** Object:  StoredProcedure [internal].[validate_project_internal]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [internal].[validate_project_internal]
	@project_id [bigint],
	@version_id [bigint],
	@validation_id [bigint],
	@environment_scope [nchar](1),
	@use32bitruntime [smallint]
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [ISSERVER].[Microsoft.SqlServer.IntegrationServices.Server.ServerApi].[ValidateProjectInternal]
GO
