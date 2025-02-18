USE [SSISDB]
GO
/****** Object:  StoredProcedure [internal].[set_system_informations]    Script Date: 18/02/2025 2:36:19 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [internal].[set_system_informations]
	@operation_id [bigint]
WITH EXECUTE AS CALLER
AS
EXTERNAL NAME [ISSERVER].[Microsoft.SqlServer.IntegrationServices.Server.SystemInformations].[SetSystemInformations]
GO
