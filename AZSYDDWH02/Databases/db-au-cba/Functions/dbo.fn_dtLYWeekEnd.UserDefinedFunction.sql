USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLYWeekEnd]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLYWeekEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLYWeekEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Last year week end date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select case datepart(dw,dateadd(year,-1,@date))	when 1 then dateadd(d,6,dateadd(year,-1,@date))
												when 2 then dateadd(d,5,dateadd(year,-1,@date))
												when 3 then dateadd(d,4,dateadd(year,-1,@date))
												when 4 then dateadd(d,3,dateadd(year,-1,@date))
												when 5 then dateadd(d,2,dateadd(year,-1,@date))
												when 6 then dateadd(d,1,dateadd(year,-1,@date))
												when 7 then dateadd(d,0,dateadd(year,-1,@date))
					end
  )
end

GO
