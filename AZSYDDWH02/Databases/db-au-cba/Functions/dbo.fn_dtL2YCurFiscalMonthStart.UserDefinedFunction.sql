USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtL2YCurFiscalMonthStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtL2YCurFiscalMonthStart] (@date datetime)  
returns datetime  
as  
  
/*****************************************************************************/  
-- Title:   		dbo.fn_dtL2YCurFiscalMonthStart  
-- Author:   		Leonardus Setyabudi
-- Dependancies:   
-- Description:  	This function returns the Last 2 year 
--					Current fiscal month start date based on the input date   
--  
/*****************************************************************************/  
  
begin  
  return  
  (  
	select convert(datetime,convert(varchar(8),dateadd(year,-2,@date),120) + '01')  
  )  
end

GO
