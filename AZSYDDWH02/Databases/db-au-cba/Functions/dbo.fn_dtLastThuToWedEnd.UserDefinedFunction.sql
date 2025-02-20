USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastThuToWedEnd]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLastThuToWedEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastThuToWedEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last Thursday to Wedneday end date based on the input date 
--
/*****************************************************************************/



begin
  return
  (
	select case datepart(dw,@date) when 1 then dateadd(d,-4,@date)			--Sunday
								   when 2 then dateadd(d,-5,@date)			--Monday
								   when 3 then dateadd(d,-6,@date)			--Tuesday
								   when 4 then dateadd(d,-7,@date)			--Wednesday
								   when 5 then dateadd(d,-1,@date)			--Thursday
								   when 6 then dateadd(d,-2,@date)			--Friday
								   when 7 then dateadd(d,-3,@date)			--Saturday
		   end
  )			
end


GO
