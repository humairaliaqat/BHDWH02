USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastFriToSunStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLastFriToSunStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastFriToSunStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last friday start date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select case datepart(dw,@date) when 1 then dateadd(d,-9,@date)			--Sunday
								   when 2 then dateadd(d,-3,@date)			--Monday
								   when 3 then dateadd(d,-4,@date)			--Tuesday
								   when 4 then dateadd(d,-5,@date)			--Wednesday
								   when 5 then dateadd(d,-6,@date)			--Thursday
								   when 6 then dateadd(d,-7,@date)			--Friday
								   when 7 then dateadd(d,-8,@date)			--Saturday
		   end
  )			
end

GO
