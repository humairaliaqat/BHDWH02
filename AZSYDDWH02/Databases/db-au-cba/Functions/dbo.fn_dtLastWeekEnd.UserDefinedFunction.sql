USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastWeekEnd]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLastWeekEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastWeekEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last week end date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select DATEADD(dd, 8-(DATEPART(dw, dateadd(week,-1,@date))), dateadd(week,-1,@date))
  )
end

GO
