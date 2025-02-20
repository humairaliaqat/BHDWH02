USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastMayEnd]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLastMayEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastMayEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns last May end date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select case when month(@date) <= 5 then dateadd(d,-1,dateadd(m,1,convert(datetime,convert(varchar(5),dateadd(year,-1,@date),120) + '05-01')))
				else dateadd(d,-1,dateadd(m,1,convert(datetime,convert(varchar(5),@date,120) + '05-01')))
		   end
  )
end

GO
