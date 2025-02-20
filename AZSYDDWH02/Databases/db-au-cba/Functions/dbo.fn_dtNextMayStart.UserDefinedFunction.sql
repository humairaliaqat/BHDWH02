USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtNextMayStart]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtNextMayStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtNextMayStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns next May start date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select case when month(@date) < 5 then convert(datetime,convert(varchar(5),dateadd(year,0,@date),120)+'05-01')
				else convert(datetime,convert(varchar(5),dateadd(year,1,@date),120)+'05-01')
			end
  )
end

GO
