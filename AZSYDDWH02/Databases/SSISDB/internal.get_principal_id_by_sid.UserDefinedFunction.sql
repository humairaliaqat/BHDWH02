USE [SSISDB]
GO
/****** Object:  UserDefinedFunction [internal].[get_principal_id_by_sid]    Script Date: 20/02/2025 10:29:28 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [internal].[get_principal_id_by_sid]
(
        @sid        [internal].[adt_sid] 
)
RETURNS INT
AS
BEGIN
	DECLARE @Result INT
	select @Result = [principal_id] from [sys].[database_principals] where [sid]=@sid;
	RETURN @Result
END

GO
