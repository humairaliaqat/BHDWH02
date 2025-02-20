USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtNextFiscalYearEnd]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtNextFiscalYearEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtNextFiscalYearEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the next fiscal year end date based on the input date
--
/*****************************************************************************/

begin
  return
  (
	select case when datepart(month,@date) between 7 and 12 then convert(datetime,convert(varchar(5),dateadd(year,2,@date),120) + '06-30')
				else convert(datetime,convert(varchar(5),dateadd(year,1,@date),120) + '06-30')
		   end
  )
end

GO
