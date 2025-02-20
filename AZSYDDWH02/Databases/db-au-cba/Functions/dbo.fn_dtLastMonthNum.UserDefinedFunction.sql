USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastMonthNum]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLastMonthNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastMonthNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last month number based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select datepart(month,dateadd(m,-1,@date))
  )
end

GO
