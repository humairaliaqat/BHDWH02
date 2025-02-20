USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLYFiscalYTDEnd]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLYFiscalYTDEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLYFiscalYTDEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Last year fiscal year-to-date end date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select convert(datetime,convert(varchar(10),dateadd(year,-1,dateadd(d,-1,@date)),120))
  )
end

GO
