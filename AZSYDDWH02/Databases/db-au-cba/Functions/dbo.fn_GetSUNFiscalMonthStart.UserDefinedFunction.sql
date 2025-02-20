USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetSUNFiscalMonthStart]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_GetSUNFiscalMonthStart] (@period varchar(7))
returns datetime
as


/*****************************************************************************/
-- Title:			dbo.fn_GetSUNFiscalMonthStart
-- Author:			Linus Tor
-- Dependancies:	
-- Description:		This function returns SUN fiscal month start based on the input sun fiscal period value
--
/*****************************************************************************/

--uncomment to debug
/*
declare @period varchar(7)
select @period = '2012004'
*/
begin
	declare @CalPeriod varchar(7)
	select @CalPeriod = case when right(@period,3) between '001' and '006' then convert(varchar(4),cast(left(@period,4) as int)-1) + right(@period,3)
					   else @period
				  end
  return
  (
	select case right(@CalPeriod,3) when '001' then convert(datetime,left(@CalPeriod,4) + '-07-01')
							   when '002' then convert(datetime,left(@CalPeriod,4) + '-08-01')
							   when '003' then convert(datetime,left(@CalPeriod,4) + '-09-01')
							   when '004' then convert(datetime,left(@CalPeriod,4) + '-10-01')
							   when '005' then convert(datetime,left(@CalPeriod,4) + '-11-01')
							   when '006' then convert(datetime,left(@CalPeriod,4) + '-12-01')
							   when '007' then convert(datetime,left(@CalPeriod,4) + '-01-01')
							   when '008' then convert(datetime,left(@CalPeriod,4) + '-02-01')
							   when '009' then convert(datetime,left(@CalPeriod,4) + '-03-01')
							   when '010' then convert(datetime,left(@CalPeriod,4) + '-04-01')
							   when '011' then convert(datetime,left(@CalPeriod,4) + '-05-01')
							   when '012' then convert(datetime,left(@CalPeriod,4) + '-06-01')
							   
		   end						 							 							 							 							 							 							 							 							 							 
  )
end

GO
