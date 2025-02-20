USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtL2YFiscalYTDStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtL2YFiscalYTDStart] (@date datetime)  
returns datetime  
as  
  
/*****************************************************************************/  
-- Title:   		dbo.fn_dtL2YFiscalYTDStart  
-- Author:   		Leonardus Setyabudi  
-- Dependancies:   
-- Description:  	This function returns the Last 2 year 
--					fiscal year-to-date start date based on the input date   
--  
/*****************************************************************************/  
  
begin  
  return  
  (  

	select 
		case 
			when datepart(month,dateadd(year,-2,dateadd(d,-1,@date))) between 7 and 12 then convert(datetime,convert(varchar(5),dateadd(year,-2,dateadd(d,-1,@date)),120) + '07-01')
			else convert(datetime,convert(varchar(5),dateadd(year,-3,@date),120) + '07-01')
		end
  )  
end

GO
