USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtCurWeekNum]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtCurWeekNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtCurWeekNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the current week number based on the input date
--
/*****************************************************************************/

begin
  return
  (
	select datepart(week,@date)
  )
end

GO
