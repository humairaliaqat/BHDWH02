USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastWeekNum]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLastWeekNum] (@date datetime)
returns int
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastWeekNum
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last week number based 
--					on the input date
/*****************************************************************************/

begin
  return(select datepart(week,dateadd(week,-1,@date)))
end

GO
