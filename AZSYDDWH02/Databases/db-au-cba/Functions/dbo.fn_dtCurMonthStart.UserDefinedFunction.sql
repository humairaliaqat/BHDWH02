USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtCurMonthStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtCurMonthStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtCurMonthStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the current month start date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select convert(datetime,convert(varchar(8),@date,120) + '01')
  )
end

GO
