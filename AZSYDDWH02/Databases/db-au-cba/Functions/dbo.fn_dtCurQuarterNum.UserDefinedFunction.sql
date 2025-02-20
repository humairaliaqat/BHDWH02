USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtCurQuarterNum]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtCurQuarterNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtCurQuarterNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the current quarter number based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select datepart(quarter,@date)
  )
end

GO
