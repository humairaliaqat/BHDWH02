USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Header_Cancel]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Header_Cancel] AS 

WITH 
Policy_Transactions AS (
    SELECT
         [PolicyKey]
        ,[Product Code]

        ,SUM([Sell Price]) AS [Sell Price - Total]

        ,SUM(CASE WHEN [Transaction Status] =  'Active'                                                                  THEN [Sell Price] ELSE 0 END) AS [Sell Price - Active]
        ,SUM(CASE WHEN [Transaction Status] =  'Active' AND [Transaction Type]     IN ('Base','Partial Refund','Refund') THEN [Sell Price] ELSE 0 END) AS [Sell Price - Active Base]
        ,SUM(CASE WHEN [Transaction Status] =  'Active' AND [Transaction Type] NOT IN ('Base','Partial Refund','Refund') THEN [Sell Price] ELSE 0 END) AS [Sell Price - Active Extension]

        ,SUM(CASE WHEN [Transaction Status] <> 'Active'                                                                  THEN [Sell Price] ELSE 0 END) AS [Sell Price - Cancelled]
        ,SUM(CASE WHEN [Transaction Status] <> 'Active' AND [Transaction Type]     IN ('Base','Partial Refund','Refund') THEN [Sell Price] ELSE 0 END) AS [Sell Price - Cancelled Base]
        ,SUM(CASE WHEN [Transaction Status] <> 'Active' AND [Transaction Type] NOT IN ('Base','Partial Refund','Refund') THEN [Sell Price] ELSE 0 END) AS [Sell Price - Cancelled Extension]

        ,SUM([Premium]) AS [Premium - Total]

        ,SUM(CASE WHEN [Transaction Status] =  'Active'                                                                  THEN [Premium] ELSE 0 END) AS [Premium - Active]
        ,SUM(CASE WHEN [Transaction Status] =  'Active' AND [Transaction Type]     IN ('Base','Partial Refund','Refund') THEN [Premium] ELSE 0 END) AS [Premium - Active Base]
        ,SUM(CASE WHEN [Transaction Status] =  'Active' AND [Transaction Type] NOT IN ('Base','Partial Refund','Refund') THEN [Premium] ELSE 0 END) AS [Premium - Active Extension]

        ,SUM(CASE WHEN [Transaction Status] <> 'Active'                                                                  THEN [Premium] ELSE 0 END) AS [Premium - Cancelled]
        ,SUM(CASE WHEN [Transaction Status] <> 'Active' AND [Transaction Type]     IN ('Base','Partial Refund','Refund') THEN [Premium] ELSE 0 END) AS [Premium - Cancelled Base]
        ,SUM(CASE WHEN [Transaction Status] <> 'Active' AND [Transaction Type] NOT IN ('Base','Partial Refund','Refund') THEN [Premium] ELSE 0 END) AS [Premium - Cancelled Extension]

        ,MIN(CASE WHEN [Transaction Status] =  'Active'                                                                  THEN [Transaction Issue Date] ELSE NULL END) AS [First Active Date]
        ,MIN(CASE WHEN [Transaction Status] =  'Active' AND [Transaction Type]     IN ('Base','Partial Refund','Refund') THEN [Transaction Issue Date] ELSE NULL END) AS [First Active Date - Base]
        ,MIN(CASE WHEN [Transaction Status] =  'Active' AND [Transaction Type] NOT IN ('Base','Partial Refund','Refund') THEN [Transaction Issue Date] ELSE NULL END) AS [First Active Date - Extension]
        ,MAX(CASE WHEN [Transaction Status] =  'Active'                                                                  THEN [Transaction Issue Date] ELSE NULL END) AS [Last Active Date]
        ,MAX(CASE WHEN [Transaction Status] =  'Active' AND [Transaction Type]     IN ('Base','Partial Refund','Refund') THEN [Transaction Issue Date] ELSE NULL END) AS [Last Active Date - Base]
        ,MAX(CASE WHEN [Transaction Status] =  'Active' AND [Transaction Type] NOT IN ('Base','Partial Refund','Refund') THEN [Transaction Issue Date] ELSE NULL END) AS [Last Active Date - Extension]

        ,MIN(CASE WHEN [Transaction Status] <> 'Active'                                                                  THEN [Transaction Issue Date] ELSE NULL END) AS [First Cancelled Date]
        ,MIN(CASE WHEN [Transaction Status] <> 'Active' AND [Transaction Type]     IN ('Base','Partial Refund','Refund') THEN [Transaction Issue Date] ELSE NULL END) AS [First Cancelled Date - Base]
        ,MIN(CASE WHEN [Transaction Status] <> 'Active' AND [Transaction Type] NOT IN ('Base','Partial Refund','Refund') THEN [Transaction Issue Date] ELSE NULL END) AS [First Cancelled Date - Extension]
        ,MAX(CASE WHEN [Transaction Status] <> 'Active'                                                                  THEN [Transaction Issue Date] ELSE NULL END) AS [Last Cancelled Date]
        ,MAX(CASE WHEN [Transaction Status] <> 'Active' AND [Transaction Type]     IN ('Base','Partial Refund','Refund') THEN [Transaction Issue Date] ELSE NULL END) AS [Last Cancelled Date - Base]
        ,MAX(CASE WHEN [Transaction Status] <> 'Active' AND [Transaction Type] NOT IN ('Base','Partial Refund','Refund') THEN [Transaction Issue Date] ELSE NULL END) AS [Last Cancelled Date - Extension]

    FROM [db-au-actuary].[cng].[Policy_Transactions]
    WHERE [UserComments] <> 'Topup Remediation'
    GROUP BY [PolicyKey],[Product Code]
),

penPolicyCreditNote AS (
    SELECT 
         *
        ,SUM([RedeemAmount]) OVER (PARTITION BY [CreditNoteNumber] ORDER BY [UpdateDateTime])      AS [RedeemAmountTotal]
        ,ROW_NUMBER()        OVER (PARTITION BY [CreditNoteNumber] ORDER BY [UpdateDateTime] DESC) AS [Rank]
    FROM [db-au-actuary].[cng].[penPolicyCreditNote]
),

Run_Date AS (
    SELECT CAST(MAX([Transaction Issue Date]) AS date) AS [Run Date]
    FROM [db-au-actuary].[cng].[Policy_Transactions]
    WHERE [Product Name] <> 'Corporate'
)

SELECT 
     ph.*

    ,pt.[Sell Price - Total]
    ,pt.[Sell Price - Active]
    ,pt.[Sell Price - Active Base]
    ,pt.[Sell Price - Active Extension]
    ,pt.[Sell Price - Cancelled]
    ,pt.[Sell Price - Cancelled Base]
    ,pt.[Sell Price - Cancelled Extension]

    ,pt.[Premium - Total]
    ,pt.[Premium - Active]
    ,pt.[Premium - Active Base]
    ,pt.[Premium - Active Extension]
    ,pt.[Premium - Cancelled]
    ,pt.[Premium - Cancelled Base]
    ,pt.[Premium - Cancelled Extension]

    ,pt.[First Active Date]
    ,pt.[First Active Date - Base]
    ,pt.[First Active Date - Extension]
    ,pt.[Last Active Date]
    ,pt.[Last Active Date - Base]
    ,pt.[Last Active Date - Extension]

    ,pt.[First Cancelled Date]
    ,pt.[First Cancelled Date - Base]
    ,pt.[First Cancelled Date - Extension]
    ,pt.[Last Cancelled Date]
    ,pt.[Last Cancelled Date - Base]
    ,pt.[Last Cancelled Date - Extension]

    ,DATEDIFF(DAY,ph.[Issue Date],pt.[First Cancelled Date - Base])     AS [Days to Cancelled]
    ,DATEDIFF(DAY,ph.[Issue Date],pt.[First Cancelled Date - Base])
     - 2 * (DATEPART(WEEK,pt.[First Cancelled Date - Base]) - DATEPART(WEEK,ph.[Issue Date]))
     - IIF(DATEPART(WEEKDAY,ph.[Issue Date])                  = 1,1,0) 
     - IIF(DATEPART(WEEKDAY,pt.[First Cancelled Date - Base]) = 7,1,0)  AS [Work Days to Cancelled]

    ,CASE WHEN ph.[Policy Status] = 'Active' AND pt.[First Cancelled Date - Base] IS NULL AND ph.[TripStart] >  rd.[Run Date] THEN 'Active - Pre-Trip'
          WHEN ph.[Policy Status] = 'Active' AND pt.[First Cancelled Date - Base] IS NULL AND ph.[TripEnd]   >= rd.[Run Date] THEN 'Active - On-Trip'
          WHEN ph.[Policy Status] = 'Active' AND pt.[First Cancelled Date - Base] IS NULL                                     THEN 'Active - Returned'
          WHEN ph.[Sell Price] <= 0          AND pt.[Sell Price - Cancelled] <  0 THEN 'Cancelled - Full Refund'
          WHEN ph.[Sell Price] >  0          AND pt.[Sell Price - Cancelled] <  0 THEN 'Cancelled - Partial Refund'
          WHEN pt.[Sell Price - Active] >  0 AND pt.[Sell Price - Cancelled] >= 0 THEN 'Cancelled - No Refund'
          WHEN pt.[Sell Price - Active] <= 0 AND pt.[Sell Price - Cancelled] >= 0 THEN 'Cancelled - No Premium to Refund'
                                                                                  ELSE 'Error'
     END AS [Policy Status Detailed]

    ,cn.[CreditNoteNumber]                                                  AS [Credit Note Number]
    ,cn.[CreateDateTime]                                                    AS [Credit Note Issue Date]
    ,cn.[CreditNoteStartDate]                                               AS [Credit Note Start Date]
    ,cn.[CreditNoteExpiryDate]                                              AS [Credit Note Expiry Date]
    ,CASE WHEN cn.[Amount] - COALESCE(cn.[RedeemAmount],0) = 0
          THEN 'Redeemed'
          ELSE cn.[Status]
     END                                                                    AS [Credit Note Status]
    ,cn.[RedeemAmountTotal] + cn.[Amount] - COALESCE(cn.[RedeemAmount],0)   AS [Credit Note Amount]
  --,cn.[RedeemAmountTotal]                                                 AS [Credit Note Amount Redeemed]
    ,CASE WHEN cn.[Status] = 'Expired' 
          THEN cn.[RedeemAmountTotal] + cn.[Amount] - COALESCE(cn.[RedeemAmount],0)
          ELSE cn.[RedeemAmountTotal]
     END                                                                    AS [Credit Note Amount Redeemed]
  --,cn.[Amount] - COALESCE(cn.[RedeemAmount],0)                            AS [Credit Note Amount Remaining]
    ,CASE WHEN cn.[Status] = 'Expired' 
          THEN 0
          ELSE cn.[Amount] - COALESCE(cn.[RedeemAmount],0)
     END                                                                    AS [Credit Note Amount Remaining]

  --,rd.[Run Date]

 FROM      [db-au-actuary].[cng].[Policy_Header] ph
 LEFT JOIN Policy_Transactions                   pt ON ph.[PolicyKey] = pt.[PolicyKey] AND ph.[Product Code] = pt.[Product Code]
 LEFT JOIN penPolicyCreditNote                   cn ON ph.[PolicyKey] = cn.[OriginalPolicyKey] AND ph.[Product Code] = cn.[OriginalProductCode] AND cn.[Rank] = 1
CROSS JOIN Run_Date                              rd

--OUTER APPLY (
--    SELECT *
--    FROM Policy_Transactions pt
--    WHERE ph.[PolicyKey]    = pt.[PolicyKey]   AND 
--          ph.[Product Code] = pt.[Product Code]
--    ) pt
--OUTER APPLY (
--    SELECT *
--    FROM penPolicyCreditNote cn
--    WHERE ph.[PolicyKey]    = cn.[OriginalPolicyKey]   AND 
--          ph.[Product Code] = cn.[OriginalProductCode] AND 
--          cn.[Rank] = 1
--    --ORDER BY [UpdateDateTime] DESC
--    ) cn
--OUTER APPLY (
--    SELECT *
--    FROM Run_Date rd
--    ) rd
;
GO
