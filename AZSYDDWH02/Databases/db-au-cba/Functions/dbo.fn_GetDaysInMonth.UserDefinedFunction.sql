USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetDaysInMonth]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetDaysInMonth] ( @pDate    DATETIME )
RETURNS INT
AS
BEGIN

    SET @pDate = CONVERT(VARCHAR(10), @pDate, 101)
    SET @pDate = @pDate - DAY(@pDate) + 1

    RETURN DATEDIFF(DD, @pDate, DATEADD(MM, 1, @pDate))
END

GO
