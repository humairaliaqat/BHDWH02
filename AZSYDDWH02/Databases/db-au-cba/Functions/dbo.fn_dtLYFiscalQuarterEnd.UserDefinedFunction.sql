USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLYFiscalQuarterEnd]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLYFiscalQuarterEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLYFiscalQuarterEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Last year quarter end based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select dateadd(quarter,datediff(quarter,-1,dateadd(year,-1,@date)),-1)
  )
end

GO
