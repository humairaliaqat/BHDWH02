USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLYFiscalMTDEnd]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLYFiscalMTDEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLYFiscalMTDEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Last year fiscal month-to-date end date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select convert(datetime,convert(varchar(10),dateadd(year,-1,dateadd(d,-1,@date)),120))
  )
end

GO
