USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Transactions_Addon]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Transactions_Addon] AS 

WITH 
penPolicyAddOn AS (
    SELECT 
         [PolicyTransactionKey]
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
    GROUP BY [PolicyTransactionKey],[ProductCode]
)

SELECT 
     pt.*

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

FROM      [db-au-actuary].[cng].[Policy_Transactions] pt
LEFT JOIN penPolicyAddOn                              pa ON pt.[PolicyTransactionKey] = pa.[PolicyTransactionKey] AND pt.[Product Code] = pa.[Product Code]

--OUTER APPLY (
--    SELECT *
--    FROM penPolicyAddOn pa 
--    WHERE pt.[PolicyTransactionKey] = pa.[PolicyTransactionKey]   AND 
--          pt.[Product Code]         = pa.[Product Code]
--    ) pa

;
GO
