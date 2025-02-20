USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtL2YLastWeekStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtL2YLastWeekStart] (@date datetime)  
returns datetime  
as  
  
/*****************************************************************************/  
-- Title:   		dbo.fn_dtL2YLastWeekStart  
-- Author:   		Leonardus Setyabudi  
-- Dependancies:   
-- Description:  	This function returns the Last 2 year 
--					last week start date based on the input date   
--  
/*****************************************************************************/  
  
begin  
  return  
  (  
	select dateadd(dd, -(datepart(dw, dateadd(week,-1,dateadd(year,-2,@date)))-2), dateadd(week,-1,dateadd(year,-2,@date)))  
  )  
end

GO
