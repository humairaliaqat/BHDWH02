USE [db-au-actuary]
GO
/****** Object:  View [cng].[Table_Update_Check]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Table_Update_Check] AS 
(SELECT 'DWHDataSet'            AS [Table], MAX(a.[Issue Date])   AS [Date] FROM [db-au-actuary].[ws].[DWHDataSet]            a)
    UNION ALL
(SELECT 'DWHDataSet_CBA'        AS [Table], MAX(a.[Issue Date])   AS [Date] FROM [db-au-actuary].[ws].[DWHDataSet_CBA]        a)
    UNION ALL
(SELECT 'DWHDataSetSummary'     AS [Table], MAX(a.[Issue Date])   AS [Date] FROM [db-au-actuary].[ws].[DWHDataSetSummary]     a)
    UNION ALL
(SELECT 'DWHDataSetSummary_CBA' AS [Table], MAX(a.[Issue Date])   AS [Date] FROM [db-au-actuary].[ws].[DWHDataSetSummary_CBA] a)
--    UNION ALL
--(SELECT 'penPolicyTransAddon'   AS [Table], MAX(a.[Issue Date])   AS [Date] FROM [db-au-actuary].[ws].[DWHDataSetSummary]     a INNER JOIN [db-au-actuary].[cng].[penPolicyTransAddon] b ON a.PolicyKey = b.PolicyKey)
    UNION ALL
(SELECT 'Claim_Header_Table'    AS [Table], MAX(a.[IncurredTime]) AS [Date] FROM [db-au-actuary].[cng].[Claim_Header_Table]   a)
--    UNION ALL
--(SELECT 'Claim_Header'          AS [Table], MAX(a.[IncurredTime]) AS [Date] FROM [db-au-actuary].[cng].[Claim_Header]         a)
--    UNION ALL
--(SELECT 'Claim_Transactions'    AS [Table], MAX(a.[IncurredTime]) AS [Date] FROM [db-au-actuary].[cng].[Claim_Transactions]   a)
;
GO
