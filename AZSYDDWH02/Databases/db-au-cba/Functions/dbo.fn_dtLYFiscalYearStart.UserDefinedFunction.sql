USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLYFiscalYearStart]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLYFiscalYearStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLYFiscalYearStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Last year fiscal year start date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select case when datepart(month,dateadd(year,-1,@date)) between 7 and 12 then convert(datetime,convert(varchar(5),dateadd(year,-1,@date),120) + '07-01')
				else convert(datetime,convert(varchar(5),dateadd(year,-2,@date),120) + '07-01')
		   end
  )
end

GO
