USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtYTDFiscalNum]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtYTDFiscalNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtYTDFiscalNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the year-to-date fiscal number based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select case when datepart(month,@date) between 7 and 12 then datepart(year,dateadd(year,1,@date))
						    else datepart(year,@date)
                      end
  )
end

GO
