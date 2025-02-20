USE [SSISDB]
GO
/****** Object:  UserDefinedFunction [internal].[is_valid_name]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [internal].[is_valid_name](@object_name [nvarchar](max))
RETURNS [bit] WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [ISSERVER].[Microsoft.SqlServer.IntegrationServices.Server.ServerApi].[IsValidName]
GO
