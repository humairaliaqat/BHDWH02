USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtCurMonthNum]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtCurMonthNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtCurMonthNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the current month number based on the input date (sun-sat)
--
/*****************************************************************************/


begin
  return
  (
	select datepart(month,@date)
  )
end

GO
