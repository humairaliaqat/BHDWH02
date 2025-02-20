USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLast2YearStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLast2YearStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLast2YearStart
-- Author:			Leonardus Setyabudi
-- Dependancies:	
-- Description:		This function returns the Last 2 year start date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select convert(datetime,convert(varchar(5),dateadd(year,-2,@date),120) + '01-01')
  )
end

GO
