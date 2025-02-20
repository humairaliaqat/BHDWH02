USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtNextFiscalYearNum]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtNextFiscalYearNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtNextFiscalYearNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the next fiscal year number based on the input date
--
/*****************************************************************************/

begin
  return
  (
	select case when datepart(month,@date) between 7 and 12 then datepart(year,dateadd(year,2,@date))
				else datepart(year,dateadd(year,1,@date))
		   end	
  )
end

GO
