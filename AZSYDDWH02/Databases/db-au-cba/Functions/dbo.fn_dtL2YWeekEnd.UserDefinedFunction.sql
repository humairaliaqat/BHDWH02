USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtL2YWeekEnd]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtL2YWeekEnd] (@date datetime)  
returns datetime  
as  
  
/*****************************************************************************/  
-- Title:   		dbo.fn_dtL2YWeekEnd  
-- Author:   		Leonardus Setyabudi  
-- Dependancies:   
-- Description:  	This function returns the Last 2 year 
--					week end date based on the input date   
--  
/*****************************************************************************/  
  
begin  
  return  
  (  
	select dateadd(d,7-datepart(dw,dateadd(year,-2,@date)),dateadd(year,-2,@date)) 
  )  
end

GO
