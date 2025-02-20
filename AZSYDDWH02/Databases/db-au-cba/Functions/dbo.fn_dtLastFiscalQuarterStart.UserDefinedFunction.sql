USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastFiscalQuarterStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLastFiscalQuarterStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastQuarterStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last fiscal quarter start date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select dateadd(quarter,datediff(quarter,0,dateadd(quarter,-1,@date)),0)
  )
end

GO
