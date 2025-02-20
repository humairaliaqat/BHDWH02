USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtNextDecEnd]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtNextDecEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtNextDecEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns next December end date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select case when month(@date) < 12 then dateadd(d,-1,dateadd(m,1,convert(datetime,convert(varchar(5),dateadd(year,0,@date),120) + '12-01')))
				else dateadd(d,-1,dateadd(m,1,convert(datetime,convert(varchar(5),dateadd(year,1,@date),120) + '12-01')))
		   end
  )
end

GO
