USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtL2YCurMonthEnd]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtL2YCurMonthEnd] (@date datetime)  
returns datetime  
as  
  
/*****************************************************************************/  
-- Title:   		dbo.fn_dtL2YCurMonthEnd  
-- Author:   		Leonardus Setyabyudi
-- Dependancies:   
-- Description:  	This function returns the Last 2 year 
--					Current month end date based on the input date   
--  
/*****************************************************************************/  
  
begin  
  return  
  (  
	select dateadd(d,-1,dateadd(m,1,convert(datetime,convert(varchar(8),dateadd(year,-2,@date),120) + '01')))  
  )  
end

GO
