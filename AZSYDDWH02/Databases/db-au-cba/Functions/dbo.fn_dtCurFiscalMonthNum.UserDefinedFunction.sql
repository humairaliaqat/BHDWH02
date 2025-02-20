USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtCurFiscalMonthNum]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtCurFiscalMonthNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtCurFiscalMonthNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the current fiscal month number based on the input date (sun-sat)
--
/*****************************************************************************/


begin
  return
  (
	select case when datepart(month,@date) = 7 then 1
				when datepart(month,@date) = 8 then 2
				when datepart(month,@date) = 9 then 3
				when datepart(month,@date) = 10 then 4
				when datepart(month,@date) = 11 then 5
				when datepart(month,@date) = 12 then 6
				when datepart(month,@date) = 1 then 7
				when datepart(month,@date) = 2 then 8
				when datepart(month,@date) = 3 then 9
				when datepart(month,@date) = 4 then 10
				when datepart(month,@date) = 5 then 11
				when datepart(month,@date) = 6 then 12
			end
  )
end

GO
