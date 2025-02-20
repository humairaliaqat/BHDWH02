USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtLast2MonthsStart]    Script Date: 20/02/2025 10:13:00 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_dtLast2MonthsStart] (@date datetime)  
returns datetime  
as  
  
/*****************************************************************************/  
-- Title:         dbo.fn_dtLast2MonthsStart  
-- Author:        Leonardus Setyabudi  
-- Dependencies:   
-- Description:   This function returns last 2 months start date 
--                based on the input date
--  
/*****************************************************************************/  
  
begin  
  return  
  (  
    select convert(datetime, convert(varchar(8), dateadd(month, -2, @date), 120) + '01')  
  )  
end

GO
