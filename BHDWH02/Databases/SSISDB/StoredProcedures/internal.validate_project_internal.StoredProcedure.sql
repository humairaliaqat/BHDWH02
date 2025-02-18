USE [SSISDB]
GO
/****** Object:  StoredProcedure [internal].[validate_project_internal]    Script Date: 18/02/2025 2:36:19 PM ******/
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
