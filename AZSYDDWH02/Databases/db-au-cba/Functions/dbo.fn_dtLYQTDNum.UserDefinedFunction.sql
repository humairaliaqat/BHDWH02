USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLYQTDNum]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLYQTDNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLYQTDNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Last year quarter-to-date number based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select datepart(quarter,dateadd(year,-1,@date))
  )
end

GO
