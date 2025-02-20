USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtNext30DaysEnd]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtNext30DaysEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtNext30DaysEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the next 30 days end date based on the input date
--
/*****************************************************************************/

begin
  return
  (
	select dateadd(d,30,@date)
  )
end

GO
