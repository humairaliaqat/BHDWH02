USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_RemoveNonASCII]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_RemoveNonASCII] (@nstring varchar(4000)) RETURNS varchar(4000)
with schemabinding
--SD - 20190613 - This function removes nonASCII characters

AS

BEGIN

	DECLARE @Result varchar(4000)

	SET @Result = ''

	DECLARE @nchar nvarchar(1)

	DECLARE @position int

	SET @position = 1

	WHILE @position <= LEN(@nstring)

	BEGIN

		SET @nchar = SUBSTRING(@nstring, @position, 1)

		--Unicode & ASCII are the same from 1 to 255.

		--Only Unicode goes beyond 255

		--0 to 31 are non-printable characters

		IF UNICODE(@nchar) between 32 and 127

			SET @Result = @Result + @nchar

		SET @position = @position + 1

	END

	RETURN @Result

END

GO
