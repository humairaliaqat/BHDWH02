USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtPreviousDay]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtPreviousDay] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtPreviousDay
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the previous day date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select dateadd(d,-1,@date)
  )
end

GO
