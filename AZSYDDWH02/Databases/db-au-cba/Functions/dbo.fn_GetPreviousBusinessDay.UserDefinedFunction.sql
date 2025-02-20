USE [db-au-cba]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetPreviousBusinessDay]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [dbo].[fn_GetPreviousBusinessDay] (@date datetime)
returns datetime
as

--this date function assumes Sunday is the first day of week (SQL Server default)

begin
	declare @PrevDay datetime

	--subtract a single day
	select @PrevDay = dateadd(d,-1,@date)
	
	select @PrevDay = case datepart(dw,@PrevDay) when 1 then dateadd(d,-2,@PrevDay)
												 when 7 then dateadd(d,-1,@PrevDay)
												 else @PrevDay
					  end

	--look up holiday dates in Calendar table, and loop to the next business weekday
	while exists(select [date] from [db-au-cba].dbo.Calendar where isHoliday = 1 and isWeekday = 1 and [date] = @PrevDay)
	begin
		select @PrevDay = dateadd(d,-1,@PrevDay)
		
		select @PrevDay = case datepart(dw,@PrevDay) when 1 then dateadd(d,-2,@PrevDay)
													 when 7 then dateadd(d,-1,@PrevDay)
													 else @PrevDay
						  end
	end
	
	--return the previous business date
	return @PrevDay
end

GO
