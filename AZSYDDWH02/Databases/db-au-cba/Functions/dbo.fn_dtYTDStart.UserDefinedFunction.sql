USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtYTDStart]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtYTDStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtYTDStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the year-to-date start date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select convert(datetime,convert(varchar(5),dateadd(d,-1,@date),120) + '01-01')
  )
end

GO
