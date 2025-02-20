USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtNext7DaysStart]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtNext7DaysStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtNext7DaysStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the start date of the next
--					7 days based on the input date
/*****************************************************************************/

begin
  return(select dateadd(d,1,@date))
end

GO
