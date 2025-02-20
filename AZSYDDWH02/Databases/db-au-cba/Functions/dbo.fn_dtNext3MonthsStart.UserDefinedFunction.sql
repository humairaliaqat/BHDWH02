USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtNext3MonthsStart]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtNext3MonthsStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtNext3MonthsStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the next 3 months start date based on the input date
--
/*****************************************************************************/

begin
  return
  (
	select convert(datetime,convert(varchar(8),dateadd(month,3,@date),120) + '01')
  )
end

GO
