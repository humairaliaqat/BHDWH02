USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtCurYearEnd]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtCurYearEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtCurYearEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the current year end date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select convert(datetime,convert(varchar(5),@date,120) + '12-31')
  )
end

GO
