USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLast14DaysEnd]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLast14DaysEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLast14DaysEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last 14 days end date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select dateadd(d,-1,@date)
  )
end

GO
