USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLYMTDStart]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLYMTDStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLYMTDStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Last year month-to-date start date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select convert(datetime,convert(varchar(8),dateadd(year,-1,@date),120) + '01')
  )
end

GO
