USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLYFiscalYearNum]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLYFiscalYearNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLYFiscalYearNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Last year fiscal year number based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select case when datepart(month,dateadd(year,-1,@date)) between 7 and 12 then datepart(year,@date)
							  else year(dateadd(year,-1,@date))
						 end
  )
end

GO
