USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtFirst15DaysOfNextMonthStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtFirst15DaysOfNextMonthStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLast14DaysOfMonth
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the first 15 days of next month based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select dateadd(m,1,convert(varchar(8),@date,120)+'01')
  )
end

GO
