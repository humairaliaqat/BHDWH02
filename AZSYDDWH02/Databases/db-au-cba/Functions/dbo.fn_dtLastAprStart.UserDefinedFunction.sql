USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLastAprStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLastAprStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLastAprStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns last April start date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select case when month(@date) <= 4 then convert(datetime,convert(varchar(5),dateadd(year,-1,@date),120)+'04-01')
				else convert(datetime,convert(varchar(5),@date,120)+'04-01')
			end
  )
end

GO
