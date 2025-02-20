USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastMonthStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLastMonthStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastMonthStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the last month start date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select convert(datetime,convert(varchar(8),dateadd(m,-1,@date),120)+'01')
  )
end

GO
