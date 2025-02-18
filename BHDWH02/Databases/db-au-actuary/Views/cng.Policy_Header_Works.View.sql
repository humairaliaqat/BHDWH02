USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Header_Works]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Header_Works] AS 

WITH 
Policy_Header AS (
    SELECT 
         *
        ,CASE 
            WHEN CAST([Issue Date] as date) <= '2022-01-18' AND [JV Description]     IN ('Phone Sales','Websales')                       THEN -1
            WHEN CAST([Issue Date] as date) <= '2022-01-20' AND [JV Description] NOT IN ('Phone Sales','Websales')                       THEN -1
            WHEN CAST([Issue Date] as date) <= '2022-01-31' AND [JV Description] NOT IN ('Phone Sales','Websales') AND [Lead Time] >= 21 THEN -1
            WHEN CAST([Issue Date] as date) >= '2022-01-19' 
             AND [Lead Time]  >= 21
             AND [JV Description]     IN ('Phone Sales','Websales') 
             AND [Domain Country]     IN ('AU')   
             AND [Product Code]       IN ('ABD','ABI','ABW','AHM','AIN','AIO','AIR','AIW','ANC','ANF','ATO','BJD','BJI','BJW','CCP','CMB','CMC','CMH','CMW'
                                         ,'CPC','DII','DIT','DTP','FRG','FYI','FYP','GTS','ICC','MBC','MHA','NPP','PCR','VAS','VAW','VDC','VTC','WII','WJP'
                                         ,'IAL','NRI')
             AND [Product Plan] NOT LIKE '%-Med%'
             AND [Product Plan] NOT LIKE '%Medical%'
             AND [Product Plan] NOT LIKE '%Ess-%'
             AND [Product Plan] NOT LIKE '%Inbound%'
            THEN 1
            WHEN CAST([Issue Date] as date) >= '2022-01-19'
             AND [Lead Time]  >= 21
             AND [JV Description]     IN ('Phone Sales','Websales')
             AND [Domain Country]     IN ('NZ')   
             AND [Product Code]       IN ('AIA','AIW','AND','ANF','ANI','ETI','IAG','MHN','NZO','WDI','WII','WTI','WTP','YTI')
             AND [Product Plan] NOT LIKE '%-Med%'
             AND [Product Plan] NOT LIKE '%Medical%'
             AND [Product Plan] NOT LIKE '%Ess-%'
             AND [Product Plan] NOT LIKE '%Inbound%'
            THEN 1
            WHEN CAST([Issue Date] as date) >= '2022-02-01'
             AND [Lead Time]  >= 21
             AND [JV Description] NOT IN ('Phone Sales','Websales')
             AND [Domain Country]     IN ('AU')   
             AND [Product Code]       IN ('ABD','ABI','ABW','AHM','AIN','AIO','AIR','AIW','ANC','ANF','ATO','BJD','BJI','BJW','CCP','CMB','CMC','CMH','CMW'
                                         ,'CPC','DII','DIT','DTP','FRG','FYI','FYP','GTS','ICC','MBC','MHA','NPP','PCR','VAS','VAW','VDC','VTC','WII','WJP'
                                         ,'IAL','NRI')
             AND [Product Plan] NOT LIKE '%-Med%'
             AND [Product Plan] NOT LIKE '%Medical%'
             AND [Product Plan] NOT LIKE '%Ess-%'
             AND [Product Plan] NOT LIKE '%Inbound%'
            THEN 1
            WHEN CAST([Issue Date] as date) >= '2022-02-01'
             AND [Lead Time] >= 21
             AND [JV Description] NOT IN ('Phone Sales','Websales')
             AND [Domain Country]     IN ('NZ')   
             AND [Product Code]       IN ('AIA','AIW','AND','ANF','ANI','ETI','IAG','MHN','NZO','WDI','WII','WTI','WTP','YTI')
             AND [Product Plan] NOT LIKE '%-Med%'
             AND [Product Plan] NOT LIKE '%Medical%'
             AND [Product Plan] NOT LIKE '%Ess-%'
             AND [Product Plan] NOT LIKE '%Inbound%'
            THEN 1
            ELSE 0
         END AS [Has Pre-Trip]
        ,CASE WHEN [Has COVID19] = 1 THEN
            CASE WHEN [Domain Country] = ('AU') AND [Product Code] IN ('FYP','FYE','NPG')       AND CAST([Issue Date] as date) >= '2022-04-06' AND [Has Cruise] = 1 THEN 1
                 WHEN [Domain Country] = ('AU') AND [Product Code] IN ('NPP')                   AND CAST([Issue Date] as date) >= '2022-04-06' 
                                                                                                AND CAST([Issue Date] as date) <= '2022-06-28'                      THEN 1
                 WHEN [Domain Country] = ('AU') AND [Product Code] IN ('CBI','CPC','ICC','IEC') AND CAST([Issue Date] as date) >= '2022-04-20' AND [Has Cruise] = 1 THEN 1
                 WHEN [Domain Country] = ('AU') AND [Product Code] IN ('BCR','CCR','PCR')       AND CAST([Issue Date] as date) >= '2022-05-18'                      THEN 1
                 WHEN [Domain Country] = ('AU') AND [Product Code] IN ('AHM','MBC','MBM')       AND CAST([Issue Date] as date) >= '2022-05-18' AND [Has Cruise] = 1 THEN 1
                 WHEN [Domain Country] = ('AU') AND [Product Code] IN ('CMB','CMC')             AND CAST([Issue Date] as date) >= '2022-06-15'                      THEN 1
                 WHEN [Domain Country] = ('AU') AND [Product Code] IN ('NRI')                   AND CAST([Issue Date] as date) >= '2022-06-15' AND [Has Cruise] = 1 THEN 1
                 WHEN [Domain Country] = ('AU') AND [Product Code] IN ('NPP')                   AND CAST([Issue Date] as date) >= '2022-06-29' AND [Has Cruise] = 1 THEN 1
                 WHEN [Domain Country] = ('AU') AND [Product Code] IN ('WJP')                   AND CAST([Issue Date] as date) >= '2022-06-29' AND [Has Cruise] = 1 THEN 1
                 WHEN [Domain Country] = ('NZ') AND [Product Code] IN ('IAG','NZO','YTI')       AND CAST([Issue Date] as date) >= '2022-04-27' AND [Has Cruise] = 1 THEN 1 
                 ELSE 0
            END
            ELSE 0
         END AS [Has COVID19 Cruise]
        ,(SELECT MAX(v) 
          FROM (VALUES (CASE WHEN [Charged Traveller 1 Has EMC]  > 0 THEN [Charged Traveller 1 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 2 Has EMC]  > 0 THEN [Charged Traveller 2 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 3 Has EMC]  > 0 THEN [Charged Traveller 3 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 4 Has EMC]  > 0 THEN [Charged Traveller 4 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 5 Has EMC]  > 0 THEN [Charged Traveller 5 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 6 Has EMC]  > 0 THEN [Charged Traveller 6 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 7 Has EMC]  > 0 THEN [Charged Traveller 7 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 8 Has EMC]  > 0 THEN [Charged Traveller 8 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 9 Has EMC]  > 0 THEN [Charged Traveller 9 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 10 Has EMC] > 0 THEN [Charged Traveller 10 DOB] ELSE NULL END)
               ) AS value(v)
         ) AS [Youngest EMC DOB]
        ,(SELECT MIN(v) 
          FROM (VALUES (CASE WHEN [Charged Traveller 1 Has EMC]  > 0 THEN [Charged Traveller 1 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 2 Has EMC]  > 0 THEN [Charged Traveller 2 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 3 Has EMC]  > 0 THEN [Charged Traveller 3 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 4 Has EMC]  > 0 THEN [Charged Traveller 4 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 5 Has EMC]  > 0 THEN [Charged Traveller 5 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 6 Has EMC]  > 0 THEN [Charged Traveller 6 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 7 Has EMC]  > 0 THEN [Charged Traveller 7 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 8 Has EMC]  > 0 THEN [Charged Traveller 8 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 9 Has EMC]  > 0 THEN [Charged Traveller 9 DOB]  ELSE NULL END),
                       (CASE WHEN [Charged Traveller 10 Has EMC] > 0 THEN [Charged Traveller 10 DOB] ELSE NULL END)
               ) AS value(v)
         ) AS [Oldest EMC DOB]
    FROM [db-au-actuary].[cng].[Policy_Header_Table]
  --FROM [db-au-actuary].[cng].[Policy_Header]
),

UW_Premium_Ratio AS (
    SELECT
         [Domain Country]
        ,EOMONTH([Issue Date]) AS [Issue Month]
        ,[JV Description]
        ,[Product Code]
        ,[Policy Type]
        ,[Plan Type]
        ,[Trip Type]
        ,SUM([Premium])     AS [Premium]
        ,SUM([UW Premium])  AS [UW Premium]
        ,SUM([UW Premium])/SUM([Premium]) AS [UW Premium %]
        ,SUM([UW Premium Current])  AS [UW Premium Current]
        ,SUM([UW Premium Current])/SUM([Premium]) AS [UW Premium Current %]
    FROM [db-au-actuary].[cng].[Policy_Header_Table]
    WHERE 
        EOMONTH([Issue Date]) = (SELECT MAX(EOMONTH([Issue Date])) FROM [db-au-actuary].[cng].[Policy_Header_Table] WHERE [UW Premium] > 0) AND 
        [Premium]    > 0 AND 
        [UW Premium] > 0
    GROUP BY 
         [Domain Country]
        ,EOMONTH([Issue Date])
        ,[JV Description]
        ,[Product Code]
        ,[Policy Type]
        ,[Plan Type]
        ,[Trip Type]
),

penPolicyAddOn AS (
    SELECT 
         [PolicyKey]
	    ,[ProductCode] AS [Product Code]

	    ,SUM(CASE WHEN [AddOnGroup] IN ('Adventure Activities','Adventure Activities 2','Adventure Activities3','Adventure Plus')   THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Adventure Activities]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Aged Cover')                                                                               THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Aged Cover]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Ancillary Products')                                                                       THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Ancillary Products]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Cancel For Any Reason')                                                                    THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Cancel For Any Reason]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Cancellation')                                                                             THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Cancellation]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Cancellation Plus Cover')                                                                  THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Cancellation Plus]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('COVID-19 Cover')                                                                           THEN [GrossPremium] ELSE 0 END) AS [Gross Premium COVID-19]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Cruise','Cruise Cover2')                                                                   THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Cruise]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Electronics')                                                                              THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Electronics]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Freely Activity Packs','Freely Benefit Packs')                                             THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Freely Packs]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Medical')                                                                                  THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Medical]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Motorcycle','Motorcycle/Moped Riding')                                                     THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Motorcycle]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Luggage','Premium Luggage Cover','Optional Luggage Cover')                                 THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Luggage]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Rental Car','Self-Skippered Boat Excess')                                                  THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Rental Car]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Winter Sport','Snow Sports','Snow Sports +','Snow Sports3','Snow Extras')                  THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Winter Sport]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('TICKET')                                                                                   THEN [GrossPremium] ELSE 0 END) AS [Gross Premium Ticket]

	    ,SUM(CASE WHEN [AddOnGroup] IN ('Adventure Activities','Adventure Activities 2','Adventure Activities3','Adventure Plus')   THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Adventure Activities]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Aged Cover')                                                                               THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Aged Cover]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Ancillary Products')                                                                       THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Ancillary Products]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Cancel For Any Reason')                                                                    THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Cancel For Any Reason]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Cancellation')                                                                             THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Cancellation]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Cancellation Plus Cover')                                                                  THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Cancellation Plus]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('COVID-19 Cover')                                                                           THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium COVID-19]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Cruise','Cruise Cover2')                                                                   THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Cruise]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Electronics')                                                                              THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Electronics]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Freely Activity Packs','Freely Benefit Packs')                                             THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Freely Packs]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Medical')                                                                                  THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Medical]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Motorcycle','Motorcycle/Moped Riding')                                                     THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Motorcycle]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Luggage','Premium Luggage Cover','Optional Luggage Cover')                                 THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Luggage]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Rental Car','Self-Skippered Boat Excess')                                                  THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Rental Car]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Winter Sport','Snow Sports','Snow Sports +','Snow Sports3','Snow Extras')                  THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Winter Sport]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('TICKET')                                                                                   THEN [UnAdjGrossPremium] ELSE 0 END) AS [UnAdj Gross Premium Ticket]

	    ,SUM(CASE WHEN [AddOnGroup] IN ('Adventure Activities','Adventure Activities 2','Adventure Activities3','Adventure Plus')   AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Adventure Activities]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Aged Cover')                                                                               AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Aged Cover]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Ancillary Products')                                                                       AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Ancillary Products]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Cancel For Any Reason')                                                                    AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Cancel For Any Reason]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Cancellation')                                                                             AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Cancellation]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Cancellation Plus Cover')                                                                  AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Cancellation Plus]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('COVID-19 Cover')                                                                           AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count COVID-19]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Cruise','Cruise Cover2')                                                                   AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Cruise]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Electronics')                                                                              AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Electronics]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Freely Activity Packs','Freely Benefit Packs')                                             AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Freely Packs]
        ,SUM(CASE WHEN [AddOnGroup] IN ('Medical')                                                                                  AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Medical]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Motorcycle','Motorcycle/Moped Riding')                                                     AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Motorcycle]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Luggage','Premium Luggage Cover','Optional Luggage Cover')                                 AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Luggage]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Rental Car','Self-Skippered Boat Excess')                                                  AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Rental Car]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('Winter Sport','Snow Sports','Snow Sports +','Snow Sports3','Snow Extras')                  AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Winter Sport]
	    ,SUM(CASE WHEN [AddOnGroup] IN ('TICKET')                                                                                   AND [GrossPremium] <> 0 THEN [AddonCount] ELSE 0 END) AS [Addon Count Ticket]

    FROM [db-au-actuary].[cng].[penPolicyTransAddOn] --[ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransAddon]
    GROUP BY [PolicyKey],[ProductCode]
),

promoCode AS (
    SELECT 
         [PolicyKey]
        ,[ProductCode]      AS [Product Code]
        ,[PromoCode]        AS [Promo Code]
        ,[PromoName]        AS [Promo Name]
        ,[PromoType]        AS [Promo Type]
        ,[PromoDiscount]    AS [Promo Discount]
    FROM [db-au-actuary].[cng].[penPolicyTransSummary]
    WHERE [AutoComments] = 'Base Policy Issued' AND [PromoCode] IS NOT NULL
    GROUP BY [PolicyKey],[ProductCode],[PromoCode],[PromoName],[PromoType],[PromoDiscount]
),

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
    SELECT CAST(MAX([Posting Date]) AS date) AS [Run Date]
    FROM [db-au-actuary].[cng].[Policy_Transactions]
    WHERE [Product Name] <> 'Corporate'
)

SELECT 
     ph.[BIRowID]
    ,ph.[Domain Country]
    ,ph.[Company]
    ,ph.[PolicyKey]
    ,ph.[Base Policy No]
    ,ph.[Policy Status]
    ,ph.[Issue Date]
    ,ph.[Posting Date]
    ,ph.[Last Transaction Issue Date]
    ,ph.[Last Transaction Posting Date]
    ,ph.[Transaction Type]
    ,ph.[Departure Date]
    ,ph.[Return Date]
    ,ph.[Lead Time]
    ,ph.[Trip Duration]
    ,ph.[Trip Length]
    ,ph.[Maximum Trip Length]
    ,ph.[Area Name]
    ,ph.[Area Number]
    ,ph.[Area]
    ,ph.[AreaCode]
    ,ph.[Destination]
    ,ph.[Multi Destination]
    ,ph.[Excess]
    ,ph.[Group Policy]
    ,ph.[Has Rental Car]
    ,ph.[Has Motorcycle]
    ,ph.[Has Wintersport]
    ,ph.[Has Medical]
    ,ph.[Single/Family]
    ,ph.[Purchase Path]
    ,ph.[TRIPS Policy]
    ,ph.[Product Code]
    ,ph.[Plan Code]
    ,ph.[Product Name]
    ,ph.[Product Plan]
    ,ph.[Product Type]
    ,ph.[Product Group]
    ,ph.[Policy Type]
    ,ph.[Plan Type]
    ,ph.[Trip Type]
    ,ph.[Product Classification]
    ,ph.[Finance Product Code]
    ,ph.[OutletKey]
    ,ph.[Alpha Code]
    ,ph.[Customer Post Code]
    ,ph.[Unique Traveller Count]
    ,ph.[Unique Charged Traveller Count]
    ,ph.[Traveller Count]
    ,ph.[Charged Traveller Count]
    ,ph.[Adult Traveller Count]
    ,ph.[EMC Traveller Count]
    ,ph.[Youngest Charged DOB]
    ,ph.[Oldest Charged DOB]
    ,ph.[Youngest Age]
    ,ph.[Oldest Age]
    ,ph.[Youngest Charged Age]
    ,ph.[Oldest Charged Age]
    ,ph.[Max EMC Score]
    ,ph.[Total EMC Score]
    ,ph.[Gender]
    ,ph.[Has EMC]
    ,ph.[Has Manual EMC]
    ,ph.[Charged Traveller 1 Gender]
    ,ph.[Charged Traveller 1 DOB]
    ,ph.[Charged Traveller 1 Has EMC]
    ,ph.[Charged Traveller 1 Has Manual EMC]
    ,ph.[Charged Traveller 1 EMC Score]
    ,ph.[Charged Traveller 1 EMC Reference]
    ,ph.[Charged Traveller 2 Gender]
    ,ph.[Charged Traveller 2 DOB]
    ,ph.[Charged Traveller 2 Has EMC]
    ,ph.[Charged Traveller 2 Has Manual EMC]
    ,ph.[Charged Traveller 2 EMC Score]
    ,ph.[Charged Traveller 2 EMC Reference]
    ,ph.[Charged Traveller 3 Gender]
    ,ph.[Charged Traveller 3 DOB]
    ,ph.[Charged Traveller 3 Has EMC]
    ,ph.[Charged Traveller 3 Has Manual EMC]
    ,ph.[Charged Traveller 3 EMC Score]
    ,ph.[Charged Traveller 3 EMC Reference]
    ,ph.[Charged Traveller 4 Gender]
    ,ph.[Charged Traveller 4 DOB]
    ,ph.[Charged Traveller 4 Has EMC]
    ,ph.[Charged Traveller 4 Has Manual EMC]
    ,ph.[Charged Traveller 4 EMC Score]
    ,ph.[Charged Traveller 4 EMC Reference]
    ,ph.[Charged Traveller 5 Gender]
    ,ph.[Charged Traveller 5 DOB]
    ,ph.[Charged Traveller 5 Has EMC]
    ,ph.[Charged Traveller 5 Has Manual EMC]
    ,ph.[Charged Traveller 5 EMC Score]
    ,ph.[Charged Traveller 5 EMC Reference]
    ,ph.[Charged Traveller 6 Gender]
    ,ph.[Charged Traveller 6 DOB]
    ,ph.[Charged Traveller 6 Has EMC]
    ,ph.[Charged Traveller 6 Has Manual EMC]
    ,ph.[Charged Traveller 6 EMC Score]
    ,ph.[Charged Traveller 6 EMC Reference]
    ,ph.[Charged Traveller 7 Gender]
    ,ph.[Charged Traveller 7 DOB]
    ,ph.[Charged Traveller 7 Has EMC]
    ,ph.[Charged Traveller 7 Has Manual EMC]
    ,ph.[Charged Traveller 7 EMC Score]
    ,ph.[Charged Traveller 7 EMC Reference]
    ,ph.[Charged Traveller 8 Gender]
    ,ph.[Charged Traveller 8 DOB]
    ,ph.[Charged Traveller 8 Has EMC]
    ,ph.[Charged Traveller 8 Has Manual EMC]
    ,ph.[Charged Traveller 8 EMC Score]
    ,ph.[Charged Traveller 8 EMC Reference]
    ,ph.[Charged Traveller 9 Gender]
    ,ph.[Charged Traveller 9 DOB]
    ,ph.[Charged Traveller 9 Has EMC]
    ,ph.[Charged Traveller 9 Has Manual EMC]
    ,ph.[Charged Traveller 9 EMC Score]
    ,ph.[Charged Traveller 9 EMC Reference]
    ,ph.[Charged Traveller 10 Gender]
    ,ph.[Charged Traveller 10 DOB]
    ,ph.[Charged Traveller 10 Has EMC]
    ,ph.[Charged Traveller 10 Has Manual EMC]
    ,ph.[Charged Traveller 10 EMC Score]
    ,ph.[Charged Traveller 10 EMC Reference]
    ,ph.[Commission Tier]
    ,ph.[Volume Commission]
    ,ph.[Discount]
    ,ph.[Base Base Premium]
    ,ph.[Base Premium]
    ,ph.[Canx Premium]
    ,ph.[Undiscounted Canx Premium]
    ,ph.[Rental Car Premium]
    ,ph.[Motorcycle Premium]
    ,ph.[Luggage Premium]
    ,ph.[Medical Premium]
    ,ph.[Winter Sport Premium]
    ,ph.[Luggage Increase]
    ,ph.[Trip Cost]
    ,ph.[Unadjusted Sell Price]
    ,ph.[Unadjusted GST on Sell Price]
    ,ph.[Unadjusted Stamp Duty on Sell Price]
    ,ph.[Unadjusted Agency Commission]
    ,ph.[Unadjusted GST on Agency Commission]
    ,ph.[Unadjusted Stamp Duty on Agency Commission]
    ,ph.[Unadjusted Admin Fee]
    ,ph.[Sell Price]
    ,ph.[GST on Sell Price]
    ,ph.[Stamp Duty on Sell Price]
    ,ph.[Premium]
    ,ph.[Risk Nett]
    ,ph.[GUG]
    ,ph.[Agency Commission]
    ,ph.[GST on Agency Commission]
    ,ph.[Stamp Duty on Agency Commission]
    ,ph.[Admin Fee]
    ,ph.[NAP]
    ,ph.[NAP (incl Tax)]
    ,ph.[Policy Count]
    ,ph.[Price Beat Policy]
    ,ph.[Competitor Name]
    ,ph.[Competitor Price]
    ,ph.[Category]
    ,ph.[Rental Car Increase]
    ,ph.[ActuarialPolicyID]
    ,ph.[EMC Tier Oldest Charged]
    ,ph.[EMC Tier Youngest Charged]
    ,ph.[Has Cruise]
    ,ph.[Cruise Premium]
    ,ph.[Plan Name]
    ,ph.[Has COVID19]
    ,ph.[Has Pre-Trip]
    ,ph.[Has COVID19 Cruise]
    ,ph.[Country or Area]
    ,ph.[Intermediate Region Name]
    ,ph.[Region Name]
    ,ph.[Customer State]
    ,ph.[Policy Count Fix]
    ,ph.[TripStart]
    ,ph.[TripEnd]
    ,ph.[LeadTime]
    ,ph.[TripDuration]
    ,ph.[UW Policy Status]
  --,ph.[UW Premium]
    ,IIF(ph.[UW Premium] IS NULL
        ,uw.[UW Premium %] * ph.[Premium]
        ,ph.[UW Premium]) AS [UW Premium]
    ,IIF(ph.[UW Premium Current] IS NULL
        ,uw.[UW Premium Current %] * ph.[Premium]
        ,ph.[UW Premium Current]) AS [UW Premium Current]
    ,ph.[UW Premium COVID19]
    ,CASE
        WHEN ph.[Policy Status] = 'Active' AND ph.[Has COVID19] = 1 THEN CASE
            --AU Trans-Tasman
            WHEN ph.[Domain Country] = 'AU' AND ph.[Plan Type] NOT IN ('Domestic','Domestic Inbound') AND ph.[Destination] IN ('New Zealand') THEN CASE 
				-- 2023-07-01 202307 Review
				WHEN CAST(ph.[Issue Date] as date) >= '2023-07-01'                                                                                                          THEN 0
                -- 2023-05-01 202305 Review - Cruise
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMB'                                                  THEN (23.73 * 0.95 + 22.71 * 0.15) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMB'                                                  THEN (31.14 * 0.95 + 22.71 * 0.15) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMC'                                                  THEN (23.73 * 0.95 + 22.71 * 0.03) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMC'                                                  THEN (31.14 * 0.95 + 22.71 * 0.03) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (23.73 * 0.95 + 22.71)        * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (31.14 * 0.95 + 22.71)        * 1.00 / 0.8800
                -- 2023-05-01 202305 Review
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   4.63 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   6.07 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  23.73 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  31.14 * 0.95 * 1.00           / 0.8800
                -- 2023-01-01 202301 Review - Cruise
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMB'                                                  THEN (20.33 * 0.95 + 45.43 * 0.15) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMB'                                                  THEN (29.03 * 0.95 + 45.43 * 0.15) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMC'                                                  THEN (20.33 * 0.95 + 45.43 * 0.03) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMC'                                                  THEN (29.03 * 0.95 + 45.43 * 0.03) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (20.33 * 0.95 + 45.43)        * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (29.03 * 0.95 + 45.43)        * 1.00 / 0.8800
                -- 2023-01-01 202301 Review
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   5.08 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   7.26 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  20.33 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  29.03 * 0.95 * 1.00           / 0.8800
                ---- 2022-11-01 202211 Review - Cruise
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMB'                                                  THEN (20.33 * 0.95 + 45.43 * 0.15) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMB'                                                  THEN (29.03 * 0.95 + 45.43 * 0.15) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMC'                                                  THEN (20.33 * 0.95 + 45.43 * 0.03) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMC'                                                  THEN (29.03 * 0.95 + 45.43 * 0.03) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (20.33 * 0.95 + 45.43)        * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (29.03 * 0.95 + 45.43)        * 1.01 / 0.8800
                ---- 2022-11-01 202211 Review
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   5.08 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   7.26 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  20.33 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  29.03 * 0.95 * 1.01           / 0.8800
                ---- 2022-07-01 2022H2 Review - Cruise
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMB'                                                  THEN (24.33 * 0.95 + 83.26 * 0.15) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMB'                                                  THEN (43.08 * 0.95 + 83.26 * 0.15) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMC'                                                  THEN (24.33 * 0.95 + 83.26 * 0.03) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMC'                                                  THEN (43.08 * 0.95 + 83.26 * 0.03) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (24.33 * 0.95 + 83.26)        * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (43.08 * 0.95 + 83.26)        * 1.01 / 0.8800
                ---- 2022-07-01 2022H2 Review
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  17.18 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  24.68 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  24.33 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  43.08 * 0.95 * 1.01           / 0.8800
                ---- 2022-06-15 Cruise Cover - CMB/CMC
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-06-15' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMB'                                                  THEN (17.45 * 0.95 + 83.26 * 0.15)  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-06-15' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMB'                                                  THEN (34.11 * 0.95 + 83.26 * 0.15)  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-06-15' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMC'                                                  THEN (17.45 * 0.95 + 83.26 * 0.03)  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-06-15' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMC'                                                  THEN (34.11 * 0.95 + 83.26 * 0.03)  / 0.8800
                ---- 2022-04-06 Cruise Cover
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-04-06' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'NPP'                                                  THEN (17.45 * 0.95 + 83.26 * 0.20)  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-04-06' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'NPP'                                                  THEN (34.11 * 0.95 + 83.26 * 0.20)  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-04-06' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (17.45 * 0.95 + 83.26)         / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-04-06' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (34.11 * 0.95 + 83.26)         / 0.8800
                ---- 2022-03-01 Lower Rates - Non Webjet
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   9.44 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  17.77 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  17.45 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  34.11 * 0.95                  / 0.8800
                ---- 2022-02-09 Lower Rates - Webjet
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN   9.44 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  17.77 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  17.45 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  34.11 * 0.95                  / 0.8800
                ---- 2022-01-19 Pre-Trip Cover
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-01-19' AND ph.[Has Pre-Trip] = 0                                                                                THEN   0.064211538 * 0.95           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-01-19' AND ph.[Has Pre-Trip] = 1                                                                                THEN  36.956103430 * 0.95           / 0.8800
                ---- 2021 Lower 88% TLR
                --WHEN CAST(ph.[Issue Date] as date) >= '2021-01-01' AND ph.[Has Pre-Trip] =-1 AND ph.[Has Cruise] = 1                                                        THEN  12.575823071 * 0.95           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2021-01-01' AND ph.[Has Pre-Trip] =-1                                                                                THEN   4.625823071 * 0.95           / 0.8800
                ---- 2020 92.75% TLR
                --WHEN CAST(ph.[Issue Date] as date) >= '2020-01-01' AND ph.[Has Pre-Trip] =-1 AND ph.[Has Cruise] = 1                                                        THEN  12.575823071 * 0.95           / 0.9275
                --WHEN CAST(ph.[Issue Date] as date) >= '2020-01-01' AND ph.[Has Pre-Trip] =-1                                                                                THEN   4.625823071 * 0.95           / 0.9275
            END

            --AU International
            WHEN ph.[Domain Country] = 'AU' AND ph.[Plan Type] NOT IN ('Domestic','Domestic Inbound') AND ph.[Destination] NOT IN ('New Zealand') THEN CASE 
				-- 2023-07-01 202307 Review
				WHEN CAST(ph.[Issue Date] as date) >= '2023-07-01'                                                                                                          THEN 0
                -- 2023-05-01 202305 Review - Cruise
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMB'                                                  THEN (21.26 * 0.95 + 22.71 * 0.15) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMB'                                                  THEN (26.25 * 0.95 + 22.71 * 0.15) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMC'                                                  THEN (21.26 * 0.95 + 22.71 * 0.03) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMC'                                                  THEN (26.25 * 0.95 + 22.71 * 0.03) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (21.26 * 0.95 + 22.71)        * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (26.25 * 0.95 + 22.71)        * 1.00 / 0.8800
                -- 2023-05-01 202305 Review
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   7.88 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   8.38 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  21.26 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  26.25 * 0.95 * 1.00           / 0.8800
                -- 2023-01-01 202301 Review - Cruise
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMB'                                                  THEN (37.04 * 0.95 + 45.43 * 0.15) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMB'                                                  THEN (47.63 * 0.95 + 45.43 * 0.15) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMC'                                                  THEN (37.04 * 0.95 + 45.43 * 0.03) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMC'                                                  THEN (47.63 * 0.95 + 45.43 * 0.03) * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (37.04 * 0.95 + 45.43)        * 1.00 / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (47.63 * 0.95 + 45.43)        * 1.00 / 0.8800
                -- 2023-01-01 202301 Review
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  13.78 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  16.43 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  37.04 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  47.63 * 0.95 * 1.00           / 0.8800
                ---- 2022-11-01 202211 Review - Cruise
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMB'                                                  THEN (37.04 * 0.95 + 45.43 * 0.15) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMB'                                                  THEN (47.63 * 0.95 + 45.43 * 0.15) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMC'                                                  THEN (37.04 * 0.95 + 45.43 * 0.03) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMC'                                                  THEN (47.63 * 0.95 + 45.43 * 0.03) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (37.04 * 0.95 + 45.43)        * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (47.63 * 0.95 + 45.43)        * 1.01 / 0.8800
                ---- 2022-11-01 202211 Review
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  13.78 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  16.43 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  37.04 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  47.63 * 0.95 * 1.01           / 0.8800
                ---- 2022-07-01 2022H2 Review - Cruise
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMB'                                                  THEN (61.05 * 0.95 + 83.26 * 0.15) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMB'                                                  THEN (87.30 * 0.95 + 83.26 * 0.15) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMC'                                                  THEN (61.05 * 0.95 + 83.26 * 0.03) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMC'                                                  THEN (87.30 * 0.95 + 83.26 * 0.03) * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (61.05 * 0.95 + 83.26)        * 1.01 / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (87.30 * 0.95 + 83.26)        * 1.01 / 0.8800
                ---- 2022-07-01 2022H2 Review
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  48.21 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  61.34 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  61.05 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  87.30 * 0.95 * 1.01           / 0.8800
                ---- 2022-06-15 Cruise Cover - CMB/CMC
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-06-15' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMB'                                                  THEN (67.23 * 0.95 + 83.26 * 0.15)  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-06-15' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMB'                                                  THEN (98.59 * 0.95 + 83.26 * 0.15)  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-06-15' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'CMC'                                                  THEN (67.23 * 0.95 + 83.26 * 0.03)  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-06-15' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'CMC'                                                  THEN (98.59 * 0.95 + 83.26 * 0.03)  / 0.8800
                ---- 2022-04-06 Cruise Cover
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-04-06' AND ph.[Has Pre-Trip] = 0 AND ph.[Product Code] = 'NPP'                                                  THEN (67.23 * 0.95 + 83.26 * 0.20)  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-04-06' AND ph.[Has Pre-Trip] = 1 AND ph.[Product Code] = 'NPP'                                                  THEN (98.59 * 0.95 + 83.26 * 0.20)  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-04-06' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (67.23 * 0.95 + 83.26)         / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-04-06' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (98.59 * 0.95 + 83.26)         / 0.8800
                ---- 2022-03-01 Lower Rates - Non Webjet
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  41.57 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  57.25 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  67.23 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  98.59 * 0.95                  / 0.8800
                ---- 2022-02-09 Lower Rates - Webjet
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  41.57 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  57.25 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  67.23 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  98.59 * 0.95                  / 0.8800
                ---- 2022-01-19 Pre-Trip Cover
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-01-19' AND ph.[Has Pre-Trip] = 0                                                                                THEN  81.080169740 * 0.95           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-01-19' AND ph.[Has Pre-Trip] = 1                                                                                THEN 137.647737300 * 0.95           / 0.8800
                ---- 2021 Lower 88% TLR
                --WHEN CAST(ph.[Issue Date] as date) >= '2021-01-01' AND ph.[Has Pre-Trip] =-1                                                                                THEN  10.107576010 * 0.95           / 0.8800
                ---- 2020 92.75% TLR
                --WHEN CAST(ph.[Issue Date] as date) >= '2020-01-01' AND ph.[Has Pre-Trip] =-1                                                                                THEN  10.107576010 * 0.95           / 0.9275
            END

            --AU Domestic
            WHEN ph.[Domain Country] = 'AU' AND ph.[Plan Type] IN ('Domestic','Domestic Inbound') THEN CASE 
				-- 2023-07-01 202307 Review
				WHEN CAST(ph.[Issue Date] as date) >= '2023-07-01'                                                                                                          THEN 0
                -- 2023-05-01 202305 Review
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   0.77 * 1.00 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   1.14 * 1.00 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  12.91 * 1.00 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  19.00 * 1.00 * 1.00           / 0.8800
                -- 2023-01-01 202301 Review
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   2.33 * 1.00 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   3.39 * 1.00 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  23.33 * 1.00 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  33.92 * 1.00 * 1.00           / 0.8800
                ---- 2022-11-01 202211 Review
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   2.33 * 1.00 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   3.39 * 1.00 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  23.33 * 1.00 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-11-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  33.92 * 1.00 * 1.01           / 0.8800
                ---- 2022-07-01 2022H2 Review
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   5.00 * 1.00 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   6.91 * 1.00 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  10.05 * 1.00 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  29.18 * 1.00 * 1.01           / 0.8800
                ---- 2022-03-01 Lower Rates - Non Webjet
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   7.25 * 1.00                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  14.60 * 1.00                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  13.07 * 1.00                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  27.77 * 1.00                  / 0.8800
                ---- 2022-02-09 Lower Rates - Webjet
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN   7.25 * 1.00                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  14.60 * 1.00                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  13.07 * 1.00                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  27.77 * 1.00                  / 0.8800
                ---- 2022-01-19 Pre-Trip Cover
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-01-19' AND ph.[Has Pre-Trip] = 0                                                                                THEN  26.514782610 * 1.00           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-01-19' AND ph.[Has Pre-Trip] = 1                                                                                THEN  55.001739130 * 1.00           / 0.8800
                ---- 2021 Lower 88% TLR
                --WHEN CAST(ph.[Issue Date] as date) >= '2021-01-01' AND ph.[Has Pre-Trip] =-1                                                                                THEN   4.370000000 * 1.00           / 0.8800
                ---- 2020 92.75% TLR
                --WHEN CAST(ph.[Issue Date] as date) >= '2020-01-01' AND ph.[Has Pre-Trip] =-1                                                                                THEN   4.370000000 * 1.00           / 0.9275
            END

            --NZ Trans-Tasman
            WHEN ph.[Domain Country] = 'NZ' AND ph.[Plan Type] NOT IN ('Domestic','Domestic Inbound') AND ph.[Destination] IN ('Australia') THEN CASE 
				-- 2023-07-01 202307 Review
				WHEN CAST(ph.[Issue Date] as date) >= '2023-07-01'                                                                                                          THEN 0
                -- 2023-05-01 202305 Review - Cruise
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN ( 6.53 * 0.95 + 18.89) * 1.00  / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (13.04 * 0.95 + 18.89) * 1.00  / 0.8800
                -- 2023-05-01 202305 Review
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   1.63 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   3.26 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN   6.53 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  13.04 * 0.95 * 1.00           / 0.8800
                -- 2023-01-01 2023H1 Review - Cruise
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (15.81 * 0.95 + 47.23) * 1.00  / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (28.00 * 0.95 + 47.23) * 1.00  / 0.8800
                -- 2023-01-01 2023H1 Review
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   3.44 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   4.94 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  15.81 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  28.00 * 0.95 * 1.00           / 0.8800
                ---- 2022-07-01 2022H2 Review - Cruise
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (24.33 * 0.95 + 83.26) * 1.01  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (43.08 * 0.95 + 83.26) * 1.01  / 0.8800
                ---- 2022-07-01 2022H2 Review
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  17.18 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  24.68 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  24.33 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  43.08 * 0.95 * 1.01           / 0.8800
                ---- 2022-04-27 Cruise Cover
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-04-27' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (13.26 * 0.95 + 83.26)         / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-04-27' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (31.70 * 0.95 + 83.26)         / 0.8800
                ---- 2022-03-01 Lower Rates - Non Webjet
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   9.70 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  18.92 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  13.26 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  31.70 * 0.95                  / 0.8800
                ---- 2022-02-09 Lower Rates - Webjet
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN   9.70 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  18.92 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  13.26 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  31.70 * 0.95                  / 0.8800
                ---- 2022-01-19 Pre-Trip Cover
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-01-19' AND ph.[Has Pre-Trip] = 0                                                                                THEN  18.735652170 * 0.95           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-01-19' AND ph.[Has Pre-Trip] = 1                                                                                THEN  18.782094480 * 0.95           / 0.8800
                ---- 2021 Lower 88% TLR
                --WHEN CAST(ph.[Issue Date] as date) >= '2021-01-01' AND ph.[Has Pre-Trip] =-1 AND ph.[Has Cruise] = 1                                                        THEN  11.483464354 * 0.95           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2021-01-01' AND ph.[Has Pre-Trip] =-1                                                                                THEN   3.533464354 * 0.95           / 0.8800
                ---- 2020 92.75% TLR
                --WHEN CAST(ph.[Issue Date] as date) >= '2020-01-01' AND ph.[Has Pre-Trip] =-1 AND ph.[Has Cruise] = 1                                                        THEN  11.483464354 * 0.95           / 0.9275
                --WHEN CAST(ph.[Issue Date] as date) >= '2020-01-01' AND ph.[Has Pre-Trip] =-1                                                                                THEN   3.533464354 * 0.95           / 0.9275
            END
          
            --NZ International
            WHEN ph.[Domain Country] = 'NZ' AND ph.[Plan Type] NOT IN ('Domestic','Domestic Inbound') AND ph.[Destination] NOT IN ('Australia') THEN CASE 
				-- 2023-07-01 202307 Review
				WHEN CAST(ph.[Issue Date] as date) >= '2023-07-01'                                                                                                          THEN 0
                -- 2023-05-01 202305 Review - Cruise
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (18.73 * 0.95 + 18.89) * 1.00  / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (22.32 * 0.95 + 18.89) * 1.00  / 0.8800
                -- 2023-05-01 202305 Review
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   9.34 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  10.50 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  18.73 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  22.32 * 0.95 * 1.00           / 0.8800
                -- 2023-01-01 2023H1 Review - Cruise
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (34.63 * 0.95 + 47.23) * 1.00  / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (49.52 * 0.95 + 47.23) * 1.00  / 0.8800
                -- 2023-01-01 2023H1 Review
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   9.64 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  12.27 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  34.63 * 0.95 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  49.52 * 0.95 * 1.00           / 0.8800
                ---- 2022-07-01 2022H2 Review - Cruise
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (61.05 * 0.95 + 83.26) * 1.01  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (87.30 * 0.95 + 83.26) * 1.01  / 0.8800
                ---- 2022-07-01 2022H2 Review
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  48.21 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  61.34 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  61.05 * 0.95 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  87.30 * 0.95 * 1.01           / 0.8800
                ---- 2022-04-27 Cruise Cover
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-04-27' AND ph.[Has Pre-Trip] = 0 AND ph.[Has COVID19 Cruise] = 1                                                THEN (48.04 * 0.95 + 83.26)         / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-04-27' AND ph.[Has Pre-Trip] = 1 AND ph.[Has COVID19 Cruise] = 1                                                THEN (76.32 * 0.95 + 83.26)         / 0.8800
                ---- 2022-03-01 Lower Rates - Non Webjet
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  33.71 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  47.85 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  48.04 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  76.32 * 0.95                  / 0.8800
                ---- 2022-02-09 Lower Rates - Webjet
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  33.71 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  47.85 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  48.04 * 0.95                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  76.32 * 0.95                  / 0.8800
                ---- 2022-01-19 Pre-Trip Cover
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-01-19' AND ph.[Has Pre-Trip] = 0                                                                                THEN  51.700000000 * 0.95           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-01-19' AND ph.[Has Pre-Trip] = 1                                                                                THEN  51.764615380 * 0.95           / 0.8800
                ---- 2021 Lower 88% TLR
                --WHEN CAST(ph.[Issue Date] as date) >= '2021-01-01' AND ph.[Has Pre-Trip] =-1                                                                                THEN   9.315217295 * 0.95           / 0.8800
                ---- 2020 92.75% TLR
                --WHEN CAST(ph.[Issue Date] as date) >= '2020-01-01' AND ph.[Has Pre-Trip] =-1                                                                                THEN   9.315217295 * 0.95           / 0.9275
            END

            --NZ Domestic
            WHEN ph.[Domain Country] = 'NZ' AND ph.[Plan Type] IN ('Domestic','Domestic Inbound') THEN CASE 
				-- 2023-07-01 202307 Review
				WHEN CAST(ph.[Issue Date] as date) >= '2023-07-01'                                                                                                          THEN 0
                -- 2023-05-01 202305 Review
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   1.32 * 1.00 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   2.18 * 1.00 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  11.49 * 1.00 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-05-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  18.96 * 1.00 * 1.00           / 0.8800
                -- 2023-01-01 2023H1 Review
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   1.00 * 1.00 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   1.38 * 1.00 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  10.05 * 1.00 * 1.00           / 0.8800
                WHEN CAST(ph.[Issue Date] as date) >= '2023-01-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  29.18 * 1.00 * 1.00           / 0.8800
                ---- 2022-07-01 2022H2 Review
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   5.00 * 1.00 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   6.91 * 1.00 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  10.05 * 1.00 * 1.01           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-07-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  29.18 * 1.00 * 1.01           / 0.8800
                ---- 2022-03-01 Lower Rates - Non Webjet
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN   9.70 * 1.00                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated'                                        THEN  16.82 * 1.00                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  13.26 * 1.00                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-03-01' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated'                                        THEN  27.50 * 1.00                  / 0.8800
                ---- 2022-02-09 Lower Rates - Webjet
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel]  = 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN   9.70 * 1.00                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel]  = 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  16.82 * 1.00                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 0 AND ph.[Outlet Channel] <> 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  13.26 * 1.00                  / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-02-09' AND ph.[Has Pre-Trip] = 1 AND ph.[Outlet Channel] <> 'Integrated' AND ph.[JV Description]  = 'Webjet'    THEN  27.50 * 1.00                  / 0.8800
                ---- 2022-01-19 Pre-Trip Cover
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-01-19' AND ph.[Has Pre-Trip] = 0                                                                                THEN   0.034125000 * 1.00           / 0.8800
                --WHEN CAST(ph.[Issue Date] as date) >= '2022-01-19' AND ph.[Has Pre-Trip] = 1                                                                                THEN   0.068451923 * 1.00           / 0.8800
                ---- 2021 Lower 88% TLR
                --WHEN CAST(ph.[Issue Date] as date) >= '2021-01-01' AND ph.[Has Pre-Trip] =-1                                                                                THEN   3.330000000 * 1.00           / 0.8800
                ---- 2020 92.75% TLR
                --WHEN CAST(ph.[Issue Date] as date) >= '2020-01-01' AND ph.[Has Pre-Trip] =-1                                                                                THEN   3.330000000 * 1.00           / 0.9275
            END
          END
        ELSE 0
     END AS [UW Premium COVID19 Estimate]
  --,ph.[Previous Policy Status]
  --,ph.[Previous UW Premium]
  --,ph.[UW Movement]
    ,ph.[UW Domain Country]
    ,ph.[UW Issue Month]
    ,ph.[UW Rating Group]
    ,ph.[UW JV Description Orig]
    ,ph.[UW JV Group]
    ,ph.[UW Product Code]
    ,ph.[Outlet Name]
    ,ph.[Outlet Sub Group Code]
    ,ph.[Outlet Sub Group Name]
    ,ph.[Outlet Group Code]
    ,ph.[Outlet Group Name]
    ,ph.[Outlet Super Group]
    ,ph.[Outlet Channel]
    ,ph.[Outlet BDM]
    ,ph.[Outlet Post Code]
    ,ph.[Outlet Sales State Area]
    ,ph.[Outlet Trading Status]
    ,ph.[Outlet Type]
    ,ph.[JV Code]
    ,ph.[JV Description]
    ,ph.[Underwriter]
    ,ph.[ClaimCount]
    ,ph.[SectionCount]
    ,ph.[NetIncurredMovementIncRecoveries]
    ,ph.[NetPaymentMovementIncRecoveries]
    ,ph.[Sections MED]
    ,ph.[Payments MED]
    ,ph.[Incurred MED]
    ,ph.[Sections MED_LGE]
    ,ph.[Payments MED_LGE]
    ,ph.[Incurred MED_LGE]
    ,ph.[Sections CAN]
    ,ph.[Payments CAN]
    ,ph.[Incurred CAN]
    ,ph.[Sections CAN_LGE]
    ,ph.[Payments CAN_LGE]
    ,ph.[Incurred CAN_LGE]
    ,ph.[Sections ADD]
    ,ph.[Payments ADD]
    ,ph.[Incurred ADD]
    ,ph.[Sections ADD_LGE]
    ,ph.[Payments ADD_LGE]
    ,ph.[Incurred ADD_LGE]
    ,ph.[Sections MIS]
    ,ph.[Payments MIS]
    ,ph.[Incurred MIS]
    ,ph.[Sections MIS_LGE]
    ,ph.[Payments MIS_LGE]
    ,ph.[Incurred MIS_LGE]
    ,ph.[Sections CAT]
    ,ph.[Payments CAT]
    ,ph.[Incurred CAT]
    ,ph.[Sections COV]
    ,ph.[Payments COV]
    ,ph.[Incurred COV]
    ,ph.[Sections OTH]
    ,ph.[Payments OTH]
    ,ph.[Incurred OTH]
    ,ph.[Youngest EMC DOB]
    ,ph.[Oldest EMC DOB]
    ,CASE WHEN ph.[Issue Date] IS NULL OR ph.[Youngest EMC DOB] IS NULL THEN -1
          ELSE FLOOR((DATEDIFF(MONTH,ph.[Youngest EMC DOB],[Issue Date]) - CASE WHEN DATEPART(DAY,ph.[Issue Date]) < DATEPART(DAY,ph.[Youngest EMC DOB]) THEN 1 ELSE 0 END) / 12 )
     END [Youngest EMC Age]
    ,CASE WHEN ph.[Issue Date] IS NULL OR ph.[Oldest EMC DOB] IS NULL THEN -1
          ELSE FLOOR((DATEDIFF(MONTH,ph.[Oldest EMC DOB],[Issue Date]) - CASE WHEN DATEPART(DAY,ph.[Issue Date]) < DATEPART(DAY,ph.[Oldest EMC DOB]) THEN 1 ELSE 0 END) / 12 )
     END [Oldest EMC Age]

    ,pa.[Gross Premium Adventure Activities]
    ,pa.[Gross Premium Aged Cover]
    ,pa.[Gross Premium Ancillary Products]
    ,pa.[Gross Premium Cancel For Any Reason]
    ,pa.[Gross Premium Cancellation]
    ,pa.[Gross Premium COVID-19]
    ,pa.[Gross Premium Cruise]
    ,pa.[Gross Premium Electronics]
    ,pa.[Gross Premium Freely Packs]
    ,pa.[Gross Premium Luggage]
    ,pa.[Gross Premium Medical]
    ,pa.[Gross Premium Motorcycle]
    ,pa.[Gross Premium Rental Car]
    ,pa.[Gross Premium Ticket]
    ,pa.[Gross Premium Winter Sport]

    ,pa.[UnAdj Gross Premium Adventure Activities]
    ,pa.[UnAdj Gross Premium Aged Cover]
    ,pa.[UnAdj Gross Premium Ancillary Products]
    ,pa.[UnAdj Gross Premium Cancel For Any Reason]
    ,pa.[UnAdj Gross Premium Cancellation]
    ,pa.[UnAdj Gross Premium COVID-19]
    ,pa.[UnAdj Gross Premium Cruise]
    ,pa.[UnAdj Gross Premium Electronics]
    ,pa.[UnAdj Gross Premium Freely Packs]
    ,pa.[UnAdj Gross Premium Luggage]
    ,pa.[UnAdj Gross Premium Medical]
    ,pa.[UnAdj Gross Premium Motorcycle]
    ,pa.[UnAdj Gross Premium Rental Car]
    ,pa.[UnAdj Gross Premium Ticket]
    ,pa.[UnAdj Gross Premium Winter Sport]

    ,pa.[Addon Count Adventure Activities]
    ,pa.[Addon Count Aged Cover]
    ,pa.[Addon Count Ancillary Products]
    ,pa.[Addon Count Cancel For Any Reason]
    ,pa.[Addon Count Cancellation]
    ,pa.[Addon Count COVID-19]
    ,pa.[Addon Count Cruise]
    ,pa.[Addon Count Electronics]
    ,pa.[Addon Count Freely Packs]
    ,pa.[Addon Count Luggage]
    ,pa.[Addon Count Medical]
    ,pa.[Addon Count Motorcycle]
    ,pa.[Addon Count Rental Car]
    ,pa.[Addon Count Ticket]
    ,pa.[Addon Count Winter Sport]

    ,pc.[Promo Code]
    ,pc.[Promo Name]
    ,pc.[Promo Type]
    ,pc.[Promo Discount]

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
          WHEN ph.[Policy Status] = 'Active' AND pt.[First Cancelled Date - Base] IS NULL AND ph.[TripEnd]   <  rd.[Run Date] THEN 'Active - Returned'
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

 FROM      Policy_Header        ph
 LEFT JOIN penPolicyAddOn       pa ON ph.[PolicyKey] = pa.[PolicyKey] AND ph.[Product Code] = pa.[Product Code]
 LEFT JOIN promoCode            pc ON ph.[PolicyKey] = pc.[PolicyKey] AND ph.[Product Code] = pc.[Product Code]
 LEFT JOIN Policy_Transactions  pt ON ph.[PolicyKey] = pt.[PolicyKey] AND ph.[Product Code] = pt.[Product Code]
 LEFT JOIN penPolicyCreditNote  cn ON ph.[PolicyKey] = cn.[OriginalPolicyKey] AND ph.[Product Code] = cn.[OriginalProductCode] AND cn.[Rank] = 1
 LEFT JOIN UW_Premium_Ratio     uw ON ph.[Domain Country] = uw.[Domain Country] AND
                                      ph.[Issue Date]     > uw.[Issue Month]    AND
                                      ph.[JV Description] = uw.[JV Description] AND
                                      ph.[Product Code]   = uw.[Product Code]   AND
                                      ph.[Policy Type]    = uw.[Policy Type]    AND
                                      ph.[Plan Type]      = uw.[Plan Type]      AND
                                      ph.[Trip Type]      = uw.[Trip Type]
CROSS JOIN Run_Date             rd

--OUTER APPLY (
--    SELECT *
--    FROM penPolicyAddOn pa 
--    WHERE ph.[PolicyKey]    = pa.[PolicyKey]   AND 
--          ph.[Product Code] = pa.[Product Code]
--    ) pa
--OUTER APPLY (
--    SELECT *
--    FROM promoCode pc 
--    WHERE ph.[PolicyKey]    = pc.[PolicyKey]   AND 
--          ph.[Product Code] = pc.[Product Code]
--    ) pc
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
