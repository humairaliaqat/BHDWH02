USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastJulStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLastJulStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastJulStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns last July start date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select case when month(@date) <= 7 then convert(datetime,convert(varchar(5),dateadd(year,-1,@date),120)+'07-01')
				else convert(datetime,convert(varchar(5),@date,120)+'07-01')
			end
  )
end

GO
