USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastFiscalYearNum]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLastFiscalYearNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastFiscalYearNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last fiscal year number based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select case when datepart(month,@date) between 7 and 12 then datepart(year,@date)
				else datepart(year,dateadd(year,-1,@date))
		   end
  )
end

GO
