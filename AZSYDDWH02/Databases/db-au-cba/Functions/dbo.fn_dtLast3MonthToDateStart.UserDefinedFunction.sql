USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLast3MonthToDateStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLast3MonthToDateStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtLast3MonthToDateStart
-- Author:			Leonardus Setyabudi
-- Dependencies:	
-- Description:		This function returns the last 3 month start date based 
--					on the input date
/*****************************************************************************/

begin
  return
  (
	select convert(datetime, convert(varchar(10), dateadd(m, -3, @date), 120))
  )
end

GO
