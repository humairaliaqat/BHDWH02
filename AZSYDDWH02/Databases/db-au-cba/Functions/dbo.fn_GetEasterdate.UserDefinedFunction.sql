USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetEasterdate]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create FUNCTION [dbo].[fn_GetEasterdate](@year INT)
RETURNS CHAR (8)
AS
BEGIN	
	DECLARE @A INT,@B INT,@C INT,@D INT,@E INT,@F INT,@G INT,
		@H INT,@I INT,@K INT,@L INT,@M INT,@O INT,@R INT				
					
	SET @A = @YEAR%19
	SET @B = @YEAR / 100
	SET @C = @YEAR%100
	SET @D = @B / 4
	SET @E = @B%4
	SET @F = (@B + 8) / 25
	SET @G = (@B - @F + 1) / 3
	SET @H = ( 19 * @A + @B - @D - @G + 15)%30
	SET @I = @C / 4
	SET @K = @C%4
	SET @L = (32 + 2 * @E + 2 * @I - @H - @K)%7
	SET @M = (@A + 11 * @H + 22 * @L) / 451
	SET @O = 22 + @H + @L - 7 * @M

	IF @O > 31
	BEGIN
		SET @R = @O - 31 + 400 + @YEAR * 10000
	END
	ELSE
	BEGIN
		SET @R = @O + 300 + @YEAR * 10000
	END 
	RETURN @R
END

--EXEC proc_update_calendardays '20100101', '20101231'

GO
