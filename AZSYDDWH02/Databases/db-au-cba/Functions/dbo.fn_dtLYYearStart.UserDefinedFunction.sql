USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLYYearStart]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtLYYearStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLYYearStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Last year year start date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select convert(datetime,convert(varchar(5),dateadd(year,-1,@date),120) + '01-01')
  )
end

GO
