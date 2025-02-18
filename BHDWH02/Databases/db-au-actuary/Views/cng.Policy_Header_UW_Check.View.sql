USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Header_UW_Check]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Header_UW_Check] AS
 
WITH CTE AS (
SELECT TOP (10000) a.*,b.[UW_Premium],ROUND(a.[UW Premium Actual] - b.[UW_Premium],2) AS [Error],ROUND(a.[UW Premium Actual]/b.[UW_Premium],2) AS [Error %]
FROM [db-au-actuary].[cng].[Policy_Header_UW_GLM] a
LEFT JOIN [db-au-actuary].[cng].[UWPremium_202109_Final] b ON a.[PolicyKey] = b.[PolicyKey] AND a.[Product Code] = b.[Product_Code]
WHERE [Policy Status] ='Active' AND [Issue Date] <= '2020-12-31' AND b.[UW_Premium] > 0
)

SELECT TOP 10000 [Error %],COUNT(*) AS [Count]
FROM CTE
GROUP BY [Error %]
ORDER BY [Error %]
;
GO
