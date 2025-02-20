USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLYFiscalQuarterStart]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLYFiscalQuarterStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLYFiscalQuarterStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Last year fiscal quarter start based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select dateadd(quarter,datediff(quarter,0,dateadd(year,-1,dateadd(d,-1,@date))),0)
  )
end

GO
