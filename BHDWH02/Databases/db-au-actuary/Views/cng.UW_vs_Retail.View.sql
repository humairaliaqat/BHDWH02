USE [db-au-actuary]
GO
/****** Object:  View [cng].[UW_vs_Retail]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[UW_vs_Retail] AS 

WITH 
Premiums AS (
    SELECT
         [Domain Country]                                           AS [Domain Country]
        ,[PolicyKey]                                                AS [PolicyKey]
        ,[Product Code]                                             AS [Product Code]
        ,EOMONTH([Issue Date],0)                                    AS [Issue Month]
        ,EOMONTH([Transaction Issue Date],0)                        AS [Transaction Month]
        ,[Policy Status]                                            AS [Policy Status]
        ,SUM([Premium])                                             AS [Premium]
        ,SUM(CASE WHEN [Premium]>0 THEN [Premium] ELSE 0 END)       AS [Premium +]
        ,SUM(CASE WHEN [Premium]<0 THEN [Premium] ELSE 0 END)       AS [Premium -]
        ,SUM(CASE WHEN [TopUp] = 1 THEN [Premium] ELSE 0 END)       AS [Premium Top Up Refund]
        ,SUM([Sell Price])                                          AS [Sell Price]
        ,SUM(CASE WHEN [Sell Price]>0 THEN [Sell Price] ELSE 0 END) AS [Sell Price +]
        ,SUM(CASE WHEN [Sell Price]<0 THEN [Sell Price] ELSE 0 END) AS [Sell Price -]
        ,SUM(CASE WHEN [TopUp] = 1    THEN [Sell Price] ELSE 0 END) AS [Sell Price Top Up Refund]
    FROM [db-au-actuary].[cng].[Policy_Transactions] 
    GROUP BY
         [Domain Country]
        ,[Base Policy No]
        ,[PolicyKey]
        ,[Product Code]
        ,[JV Description]
        ,EOMONTH([Issue Date],0)
        ,EOMONTH([Transaction Issue Date],0)
        ,[Policy Status]
),

UW_Premiums AS (
    SELECT 
         [Domain_Country]                                       AS [Domain Country]
        ,CONCAT([Domain_Country],SUBSTRING([PolicyKey],3,50))   AS [PolicyKey]
        ,[Product_Code]                                         AS [Product Code]
        ,EOMONTH([Issue_Mth],0)                                 AS [Issue Month]      
        ,[UW_Month]                                             AS [Transaction Month]
        ,[UW_Policy_Status]                                     AS [UW Policy Status]
        ,[Movement]                                             AS [UW Movement]
        ,CASE WHEN [Movement]>0 THEN [Movement] ELSE 0 END      AS [UW Movement +]
        ,CASE WHEN [Movement]<0 THEN [Movement] ELSE 0 END      AS [UW Movement -]
    FROM [db-au-actuary].[cng].[UW_Premiums]
    WHERE [Movement] <> 0 
),

Combined AS (
    SELECT
         COALESCE(a.[Domain Country]    ,b.[Domain Country]   ) AS [Domain Country]
        ,COALESCE(a.[PolicyKey]         ,b.[PolicyKey]        ) AS [PolicyKey]
        ,COALESCE(a.[Product Code]      ,b.[Product Code]     ) AS [Product Code]
        ,COALESCE(a.[Issue Month]       ,b.[Issue Month]      ) AS [Issue Month]
        ,COALESCE(a.[Transaction Month] ,b.[Transaction Month]) AS [Transaction Month]
        ,a.[Policy Status]
        ,a.[Premium]
        ,a.[Premium +]
        ,a.[Premium -]
        ,a.[Premium Top Up Refund]
        ,a.[Sell Price]
        ,a.[Sell Price +]
        ,a.[Sell Price -]
        ,a.[Sell Price Top Up Refund]
        ,b.[UW Policy Status]
        ,b.[UW Movement]
        ,b.[UW Movement +]
        ,b.[UW Movement -]
    FROM      Premiums    a
    LEFT JOIN UW_Premiums b ON a.[PolicyKey] = b.[PolicyKey] AND a.[Product Code] = b.[Product Code] AND a.[Transaction Month] = b.[Transaction Month]
)

SELECT 
         a.[Domain Country]
        ,b.[Base Policy No]
        ,a.[PolicyKey]
        ,a.[Product Code]
        ,b.[Product Plan]
        ,b.[JV Description] AS [JV]
        ,b.[UW Rating Group]
        ,a.[Issue Month]
        ,a.[Transaction Month]
        ,CASE WHEN EOMONTH(b.[First Cancelled Date - Base],0) <= a.[Transaction Month] 
              THEN EOMONTH(b.[First Cancelled Date - Base],0)
              ELSE NULL
         END AS [Cancelled Month]
        ,EOMONTH(b.[TripStart],0) AS [Departure Month]
        ,CASE WHEN b.[TripStart] > '2020-09-17'
              THEN 1
              ELSE 0
         END AS [Departure >17Sep20]
        ,CASE WHEN b.[TripStart] > '2020-12-17' 
              THEN 1
              ELSE 0
         END AS [Departure >17Dec20]
        ,a.[Policy Status]
        ,a.[Premium]
        ,a.[Premium +]
        ,a.[Premium -]
        ,a.[Premium Top Up Refund]
        ,a.[Sell Price]
        ,a.[Sell Price +]
        ,a.[Sell Price -]
        ,a.[Sell Price Top Up Refund]
        ,a.[UW Policy Status]
        ,a.[UW Movement]
        ,a.[UW Movement +]
        ,a.[UW Movement -]
FROM      Combined                                     a
LEFT JOIN [db-au-actuary].[cng].[Policy_Header_Cancel] b ON a.[PolicyKey] = b.[PolicyKey] AND a.[Product Code] = b.[Product Code]
;
GO
