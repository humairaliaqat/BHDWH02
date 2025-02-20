USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastSatToFriStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[fn_dtLastSatToFriStart] (@date datetime)
returns datetime
as


/*****************************************************************************/
-- Title:			dbo.fn_dtLastSatToFriStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Last Saturday-To-Friday start date based on the input date 
--
/*****************************************************************************/

begin
  return
  (
	select case datepart(dw,@date) when 1 then dateadd(d,-8,@date)			--Sunday
								   when 2 then dateadd(d,-9,@date)			--Monday
								   when 3 then dateadd(d,-10,@date)			--Tuesday
								   when 4 then dateadd(d,-11,@date)			--Wednesday
								   when 5 then dateadd(d,-12,@date)			--Thursday
								   when 6 then dateadd(d,-13,@date)			--Friday
								   when 7 then dateadd(d,-7,@date)			--Saturday
		   end
  )			
end

GO
