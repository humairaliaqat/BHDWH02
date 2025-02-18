USE [SSISDB]
GO
/****** Object:  UserDefinedFunction [internal].[get_isserver_processes]    Script Date: 18/02/2025 2:36:18 PM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [internal].[get_isserver_processes]()
RETURNS  TABLE (
	[process_id] [bigint] NULL
) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [ISSERVER].[Microsoft.SqlServer.IntegrationServices.Server.StartupApi].[GetISServerProcesses]
GO
