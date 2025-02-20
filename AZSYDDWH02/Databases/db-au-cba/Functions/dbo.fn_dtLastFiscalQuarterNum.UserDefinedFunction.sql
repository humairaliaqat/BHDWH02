USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastFiscalQuarterNum]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLastFiscalQuarterNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastFiscalQuarterNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last fiscal quarter number based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select case datepart(quarter,dateadd(quarter,-1,@date)) when 1 then 3
															 when 2 then 4
															 when 3 then 1
															 when 4 then 2
		   end
  )
end

GO
