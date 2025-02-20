USE [db-au-star]
GO
/****** Object:  View [dbo].[dimDateRange]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--create
CREATE  view [dbo].[dimDateRange]
as
select 
    '{[Date].[Date].&[' + replace(convert(varchar(10), StartDate, 120), '-', '') + ']:[Date].[Date].&[' + replace(convert(varchar(10), EndDate, 120), '-', '') + ']}' MDX,
    [DateRange]
from
    [db-au-cba].dbo.vdaterange
where
    [DateRange] <> '_User Defined'

GO
