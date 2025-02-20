USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastQuarterEnd]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLastQuarterEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastQuarterEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last quarter end date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select dateadd(quarter,datediff(quarter,-1,dateadd(quarter,-1,@date)),-1)
  )
end

GO
