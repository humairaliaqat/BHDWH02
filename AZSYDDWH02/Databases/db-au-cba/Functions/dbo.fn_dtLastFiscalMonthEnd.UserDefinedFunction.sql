USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastFiscalMonthEnd]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLastFiscalMonthEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastFiscalMonthEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last fiscal month end date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select dateadd(d,-1,convert(datetime,convert(varchar(8),@date,120) + '01'))
  )
end

GO
