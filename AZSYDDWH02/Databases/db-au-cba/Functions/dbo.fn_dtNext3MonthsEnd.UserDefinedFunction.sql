USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtNext3MonthsEnd]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtNext3MonthsEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtNext3MonthsEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the next 3 months end date based on the input date
--
/*****************************************************************************/

begin
  return
  (
	select dateadd(d,-1,convert(datetime,convert(varchar(8),dateadd(m,4,@date),120) + '01'))
  )
end

GO
