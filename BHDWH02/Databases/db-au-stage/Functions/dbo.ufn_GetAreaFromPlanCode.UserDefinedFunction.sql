USE [db-au-stage]
GO
/****** Object:  UserDefinedFunction [dbo].[ufn_GetAreaFromPlanCode]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[ufn_GetAreaFromPlanCode]
(@string VARCHAR(10))
RETURNS VARCHAR(4)

AS
BEGIN

declare @result varchar(4)
set @result = ''

      WHILE PATINDEX('%[0-9]%', @string) > 0
    BEGIN
              set @result = @result + substring(@string, PATINDEX('%[0-9]%',@string), 1)
        SET @string = STUFF(@string, PATINDEX('%[0-9]%', @string), 1, 'X')
    END

RETURN(@result)
END

GO
