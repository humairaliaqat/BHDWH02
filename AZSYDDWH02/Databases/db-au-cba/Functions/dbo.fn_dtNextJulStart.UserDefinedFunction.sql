USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtNextJulStart]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtNextJulStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtNextJulStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns Next July start date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select case when month(@date) < 7 then convert(datetime,convert(varchar(5),dateadd(year,0,@date),120)+'07-01')
				else convert(datetime,convert(varchar(5),dateadd(year,1,@date),120)+'07-01')
			end
  )
end

GO
