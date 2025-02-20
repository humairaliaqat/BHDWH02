USE [db-au-star]
GO
/****** Object:  View [dbo].[v_ic_dimGeneralDate]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE view [dbo].[v_ic_dimGeneralDate]
with schemabinding
as
select
    convert(date, [Date]) DateSK, 
    convert(varchar(11), [Date], 106) [DateName],
    Calendar_Year_Month, 
    Month_Name + ' ' + convert(varchar, Calendar_Year) CalendarMonthYear, 
    Calendar_Qtr, 
    'Quarter ' + convert(varchar(1), Calendar_Qtr) QuarterName, 
    Calendar_Year, 
    Calendar_Year_Qtr
from
    dbo.Dim_Date
where
    [Date] between '2000-01-01' and convert(varchar(10), convert(varchar(4), year(getdate()) + 4) + '-12-31')



GO
