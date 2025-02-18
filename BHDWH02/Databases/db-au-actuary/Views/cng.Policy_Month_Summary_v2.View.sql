USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Month_Summary_v2]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Month_Summary_v2] AS

SELECT * FROM [db-au-actuary].[cng].[Policy_Month_Summary_Departure_Table_v2] WHERE [Month] >= '2017-06-01'
UNION ALL
SELECT * FROM [db-au-actuary].[cng].[Policy_Month_Summary_Exposure_Table_v2]  WHERE [Month] >= '2017-06-01'
UNION ALL
SELECT * FROM [db-au-actuary].[cng].[Policy_Month_Summary_Issue_Table_v2]     WHERE [Month] >= '2017-06-01'
UNION ALL
SELECT * FROM [db-au-actuary].[cng].[Policy_Month_Summary_Return_Table_v2]    WHERE [Month] >= '2017-06-01'
;
GO
