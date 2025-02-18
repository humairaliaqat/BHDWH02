USE [db-au-actuary]
GO
/****** Object:  View [cng].[Destination_Summary]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Destination_Summary] AS
SELECT [Domain Country],[Plan Type],[Region Name],[Intermediate Region Name],[Country or Area],[Destination],COUNT(*) AS [Count]
FROM      [db-au-actuary].[cng].[Policy_Header_Works_Table]
WHERE [Issue Date] >= '2018-01-01' AND [Product Group] = 'Travel'
GROUP BY [Domain Country],[Plan Type],[Region Name],[Intermediate Region Name],[Country or Area],[Destination]
;
GO
