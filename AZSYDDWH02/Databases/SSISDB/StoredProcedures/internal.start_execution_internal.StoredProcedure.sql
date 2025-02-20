USE [SSISDB]
GO
/****** Object:  StoredProcedure [internal].[start_execution_internal]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [internal].[start_execution_internal]
	@project_id [bigint],
	@execution_id [bigint],
	@version_id [bigint],
	@use32BitRuntime [smallint]
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [ISSERVER].[Microsoft.SqlServer.IntegrationServices.Server.ServerApi].[StartExecutionInternal]
GO
