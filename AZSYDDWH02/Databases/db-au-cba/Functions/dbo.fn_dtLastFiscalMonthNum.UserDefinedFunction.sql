USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastFiscalMonthNum]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLastFiscalMonthNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastFiscalMonthNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last fiscal month number based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select case datepart(month,dateadd(m,-1,@date)) when 7 then 1
													when 8 then 2
													when 9 then 3
													when 10 then 4
													when 11 then 5
													when 12 then 6
													when 1 then 7
													when 2 then 8
													when 3 then 9
													when 4 then 10
													when 5 then 11
													when 6 then 12
			end
  )
end

GO
