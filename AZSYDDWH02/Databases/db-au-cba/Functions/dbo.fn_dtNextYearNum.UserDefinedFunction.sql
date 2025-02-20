USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtNextYearNum]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtNextYearNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtNextYearNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the next year number based on the input date
--
/*****************************************************************************/

begin
  return
  (
	select datepart(year,dateadd(year,1,@date))
  )
end

GO
