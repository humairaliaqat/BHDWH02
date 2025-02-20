USE [SSISDB]
GO
/****** Object:  UserDefinedFunction [internal].[convert_value]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [internal].[convert_value](@origin_value [sql_variant], @data_type [nvarchar](128))
RETURNS [sql_variant] WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [ISSERVER].[Microsoft.SqlServer.IntegrationServices.Server.ServerApi].[ConvertValue]
GO
