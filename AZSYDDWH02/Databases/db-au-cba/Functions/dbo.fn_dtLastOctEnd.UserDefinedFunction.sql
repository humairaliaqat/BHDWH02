USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastOctEnd]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLastOctEnd] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastOctEnd
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns last October end date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select case when month(@date) <= 10 then dateadd(d,-1,dateadd(m,1,convert(datetime,convert(varchar(5),dateadd(year,-1,@date),120) + '10-01')))
				else dateadd(d,-1,dateadd(m,1,convert(datetime,convert(varchar(5),@date,120) + '10-01')))
		   end
  )
end

GO
