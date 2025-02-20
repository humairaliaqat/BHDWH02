USE [SSISDB]
GO
/****** Object:  UserDefinedFunction [internal].[get_execution_perf_counters]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [internal].[get_execution_perf_counters](@execution_id [bigint], @execution_guid [uniqueidentifier])
RETURNS  TABLE (
	[execution_id] [bigint] NULL,
	[counter_name] [nvarchar](128) NULL,
	[counter_value] [bigint] NULL
) WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [ISSERVER].[Microsoft.SqlServer.IntegrationServices.Server.ExecPerfCounterApi].[GetExecPerfCounters]
GO
