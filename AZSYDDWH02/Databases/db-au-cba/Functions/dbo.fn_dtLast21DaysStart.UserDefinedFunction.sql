USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLast21DaysStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLast21DaysStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLast21DaysStart
-- Author:			Saurabh Date
-- Dependancies:	
-- Description:		This function returns the last 21 days start date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select dateadd(d,-21,@date)
  )
end
GO
