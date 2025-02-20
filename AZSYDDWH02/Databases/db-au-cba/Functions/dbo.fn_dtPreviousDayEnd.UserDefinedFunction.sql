USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtPreviousDayEnd]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtPreviousDayEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtPreviousDayEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the previous day end date based on the input date
--
/*****************************************************************************/

begin
  return
  (
	select convert(datetime,convert(varchar(10),dateadd(d,-1,@date),120))
  )
end

GO
