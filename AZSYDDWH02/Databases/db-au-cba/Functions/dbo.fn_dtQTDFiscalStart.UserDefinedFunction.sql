USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_dtQTDFiscalStart]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_dtQTDFiscalStart] (@date datetime)
returns datetime
as

/*****************************************************************************/
-- Title:			dbo.fn_dtQTDFiscalStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns the Quarter-to-date fiscal start date based on the input date 
--
/*****************************************************************************/


begin
  return
  (
	select dateadd(quarter,datediff(quarter,0,dateadd(d,-1,@date)),0)
  )
end

GO
