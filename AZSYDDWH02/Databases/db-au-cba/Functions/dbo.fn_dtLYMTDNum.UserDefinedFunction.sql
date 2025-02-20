USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLYMTDNum]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLYMTDNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLYMTDNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Last year month-to-date Month number date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select datepart(month,dateadd(year,-1,@date))
  )
end

GO
