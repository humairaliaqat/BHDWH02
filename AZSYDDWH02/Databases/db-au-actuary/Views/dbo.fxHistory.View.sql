USE [db-au-actuary]
GO
/****** Object:  View [dbo].[fxHistory]    Script Date: 20/02/2025 10:01:18 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE view [dbo].[fxHistory] as
select *
from
    [db-au-cba]..fxHistory
GO
