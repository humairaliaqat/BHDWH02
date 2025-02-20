USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtNextWeekStart]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtNextWeekStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtNextWeekStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the next week start date based on the input date (mon-sun)
--
/*****************************************************************************/

begin
  return
  (
	select case datepart(dw,@date)	when 1 then dateadd(d,7,@date)
									when 2 then dateadd(d,6,@date)
									when 3 then dateadd(d,5,@date)
									when 4 then dateadd(d,4,@date)
									when 5 then dateadd(d,3,@date)
									when 6 then dateadd(d,2,@date)
									when 7 then dateadd(d,1,@date)
			end
  )
end

GO
