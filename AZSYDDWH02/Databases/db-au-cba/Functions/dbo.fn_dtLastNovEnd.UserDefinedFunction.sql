USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastNovEnd]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLastNovEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastNovEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns last November end date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select case when month(@date) <= 11 then dateadd(d,-1,dateadd(m,1,convert(datetime,convert(varchar(5),dateadd(year,-1,@date),120) + '11-01')))
				else dateadd(d,-1,dateadd(m,1,convert(datetime,convert(varchar(5),@date,120) + '11-01')))
		   end
  )
end

GO
