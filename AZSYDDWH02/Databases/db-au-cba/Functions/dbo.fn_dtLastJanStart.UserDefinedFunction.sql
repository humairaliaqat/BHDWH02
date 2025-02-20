USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastJanStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLastJanStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastJanStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns last january start date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select case when month(@date) <= 1 then convert(datetime,convert(varchar(5),dateadd(year,-1,@date),120)+'01-01')
				else convert(datetime,convert(varchar(5),@date,120)+'01-01')
			end
  )
end

GO
