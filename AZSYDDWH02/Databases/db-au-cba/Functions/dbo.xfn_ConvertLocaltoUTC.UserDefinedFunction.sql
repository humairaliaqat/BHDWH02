USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[xfn_ConvertLocaltoUTC]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS OFF
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE FUNCTION [dbo].[xfn_ConvertLocaltoUTC](@DateTime [datetime], @LocalTimeZoneId [nvarchar](100))
RETURNS [datetime] WITH EXECUTE AS CALLER
AS 
EXTERNAL NAME [CoverMore.PenguinSharpDataBaseClr].[UserDefinedFunctions].[LocalToUtcTimeZone]
GO
