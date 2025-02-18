USE [db-au-actuary]
GO
/****** Object:  View [cng].[Credit_Note_Transactions]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Credit_Note_Transactions] AS
SELECT
     a.[CountryKey]                 AS [Country Key]
    ,a.[CompanyKey]                 AS [Company Key]
    ,a.[DomainId]                   AS [Domain Id]
    ,a.[DomainKey]                  AS [Domain Key]

    ,a.[CreditNoteNumber]           AS [Credit Note Number]
    ,a.[CreateDateTime]             AS [Credit Note Issue Date]
    ,d.[TripStartDate]              AS [Credit Note Start Date]
    ,d.[ExpiryDate]                 AS [Credit Note Expiry Date]

  --,a.[CreditNotePolicyKey]        AS [Credit Note PolicyKey]
  --,a.[ID]                         AS [Credit Note Transaction ID]
    ,a.[UpdateDateTime]             AS [Credit Note Transaction Date]
    ,a.[Status]                     AS [Credit Note Status]
  --,a.[Amount]                     AS [Credit Note Start Balance]
    ,COALESCE(a.[RedeemAmount]      ,0) AS [Credit Note Redeem Amount]
    ,COALESCE(a.[RedeemedCommission],0) AS [Credit Note Redeem Commission]

    ,SUM(COALESCE(a.[RedeemAmount]      ,0)) OVER (PARTITION BY a.[CreditNoteNumber] ORDER BY a.[UpdateDateTime], a.[Status] DESC)   AS [Credit Note Redeem Amount Total]
    ,SUM(COALESCE(a.[RedeemedCommission],0)) OVER (PARTITION BY a.[CreditNoteNumber] ORDER BY a.[UpdateDateTime], a.[Status] DESC)   AS [Credit Note Redeem Commission Total]

    ,a.[Amount]     - COALESCE(a.[RedeemAmount]      ,0)    AS [Credit Note Amount Balance]
    ,a.[Commission] - COALESCE(a.[RedeemedCommission],0)    AS [Credit Note Commission Balance]

    ,SUM(COALESCE(a.[RedeemAmount]      ,0)) OVER (PARTITION BY a.[CreditNoteNumber] ORDER BY a.[UpdateDateTime], a.[Status] DESC) + a.[Amount]     - COALESCE(a.[RedeemAmount]      ,0) AS [Credit Note Amount]
    ,SUM(COALESCE(a.[RedeemedCommission],0)) OVER (PARTITION BY a.[CreditNoteNumber] ORDER BY a.[UpdateDateTime], a.[Status] DESC) + a.[Commission] - COALESCE(a.[RedeemedCommission],0) AS [Credit Note Commission]

    ,REPLACE(a.[Comments],CHAR(10),' ')   AS [Credit Note Comments]

  --,b.[PolicyNoKey]                AS [Original PolicyNo Key]
    ,b.[PolicyNumber]               AS [Original Policy Number]
    ,b.[PolicyKey]                  AS [Original PolicyKey]
    ,a.[OriginalPolicyId]           AS [Original PolicyId]
    ,b.[StatusDescription]          AS [Original Policy Status]
    ,b.[ProductCode]                AS [Original Product Code]
    ,b.[AlphaCode]                  AS [Original Alpha Code]
    ,b.[IssueDate]                  AS [Original Issue Date]
    ,i.[OutletName]                 AS [Original Outlet Name]
    ,i.[JVCode]                     AS [Original JV Code]
    ,i.[JV]                         AS [Original JV]
    ,e2.[PaymentMode]               AS [Original Payment Mode]
    ,e1.[PolicyNumber]              AS [Original Transaction Number]
    ,e1.[IssueTimeUTC]              AS [Original Transaction Date]
    ,e1.[TransactionStatus]         AS [Original Transaction Status]
    ,g.[FirstName]                  AS [Original First Name]
    ,g.[LastName]                   AS [Original Last Name]
  --,n.[UW_Premium]                             AS [Original UW Premium]
  --,n.[Movement]                               AS [Original UW Premium Movement]
    ,l.[GrossPremium]                           AS [Original Gross Premium]
    ,l.[TaxAmountSD]                            AS [Original Tax Amount SD]
    ,l.[TaxAmountGST]                           AS [Original Tax Amount GST]
    ,l.[GrossPremium] 
    -l.[TaxAmountSD] 
    -l.[TaxAmountGST]                           AS [Original Premium]
    ,l.[Commission]                             AS [Original Commission]
    ,l.[TaxOnAgentCommissionSD]                 AS [Original Tax On Agent Commission SD]
    ,l.[TaxOnAgentCommissionGST]                AS [Original Tax On Agent Commission GST]
    ,l.[GrossPremium - Active]                  AS [Original Gross Premium - Active]
    ,l.[TaxAmountSD - Active]                   AS [Original Tax Amount SD - Active]
    ,l.[TaxAmountGST - Active]                  AS [Original Tax Amount GST - Active]
    ,l.[GrossPremium - Active] 
    -l.[TaxAmountSD - Active] 
    -l.[TaxAmountGST - Active]                  AS [Original Premium - Active]
    ,l.[Commission - Active]                    AS [Original Commission - Active]
    ,l.[TaxOnAgentCommissionSD - Active]        AS [Original Tax On Agent Commission SD - Active]
    ,l.[TaxOnAgentCommissionGST - Active]       AS [Original Tax On Agent Commission GST - Active]
    ,l.[GrossPremium - Cancelled]               AS [Original Gross Premium - Cancelled]
    ,l.[TaxAmountSD - Cancelled]                AS [Original Tax Amount SD - Cancelled]
    ,l.[TaxAmountGST - Cancelled]               AS [Original Tax Amount GST - Cancelled]
    ,l.[GrossPremium - Cancelled] 
    -l.[TaxAmountSD - Cancelled] 
    -l.[TaxAmountGST - Cancelled]               AS [Original Premium - Cancelled]
    ,l.[Commission - Cancelled]                 AS [Original Commission - Cancelled]
    ,l.[TaxOnAgentCommissionSD - Cancelled]     AS [Original Tax On Agent Commission SD - Cancelled]
    ,l.[TaxOnAgentCommissionGST - Cancelled]    AS [Original Tax On Agent Commission GST - Cancelled]
    ,l.[Last Posting Date]                      AS [Original Last Posting Date]

  --,c.[PolicyNoKey]                AS [Redeem PolicyNo Key]
    ,c.[PolicyNumber]               AS [Redeem Policy Number]
    ,c.[PolicyKey]                  AS [Redeem PolicyKey]
    ,a.[RedeemPolicyId]             AS [Redeem PolicyId]
    ,c.[StatusDescription]          AS [Redeem Policy Status]
    ,c.[ProductCode]                AS [Redeem Product Code]
    ,c.[AlphaCode]                  AS [Redeem Alpha Code]
    ,c.[IssueDate]                  AS [Redeem Issue Date]
    ,j.[OutletName]                 AS [Redeem Outlet Name]
    ,j.[JVCode]                     AS [Redeem JV Code]
    ,j.[JV]                         AS [Redeem JV]
    ,f3.[PaymentMode]               AS [Redeem Payment Mode]
    ,COALESCE(f1.[PolicyNumber]     ,f2.[PolicyNumber]     )        AS [Redeem Transaction Number]
    ,COALESCE(f1.[IssueTimeUTC]     ,f2.[IssueTimeUTC]     )        AS [Redeem Transaction Date]
    ,COALESCE(f1.[TransactionStatus],f2.[TransactionStatus])        AS [Redeem Transaction Status]
    ,COALESCE(f1.[AutoComments]     ,f2.[AutoComments]     )        AS [Redeem Auto Comments]
    ,COALESCE(f1.[GrossPremium]     ,f2.[GrossPremium]     )        AS [Redeem Transaction Gross Premium]
    ,COALESCE(f1.[TaxAmountSD]      ,f2.[TaxAmountSD]      )        AS [Redeem Transaction Tax Amount SD]
    ,COALESCE(f1.[TaxAmountGST]     ,f2.[TaxAmountGST]     )        AS [Redeem Transaction Tax Amount GST]
    ,COALESCE(f1.[GrossPremium]     ,f2.[GrossPremium]     )-
     COALESCE(f1.[TaxAmountSD]      ,f2.[TaxAmountSD]      )-
     COALESCE(f1.[TaxAmountGST]     ,f2.[TaxAmountGST]     )        AS [Redeem Transaction Premium]
    ,COALESCE(f1.[Commission]       ,f2.[Commission]       )        AS [Redeem Transaction Commission]
    ,k.[CreditNoteNumber]           AS [Redeem Credit Note Number]
    ,h.[FirstName]                  AS [Redeem First Name]
    ,h.[LastName]                   AS [Redeem Last Name]
  --,o.[UW_Premium]                             AS [Redeem UW Premium]
  --,o.[Movement]                               AS [Redeem UW Premium Movement]
    ,m.[GrossPremium]                           AS [Redeem Gross Premium]
    ,m.[TaxAmountSD]                            AS [Redeem Tax Amount SD]
    ,m.[TaxAmountGST]                           AS [Redeem Tax Amount GST]
    ,m.[GrossPremium] 
    -m.[TaxAmountSD] 
    -m.[TaxAmountGST]                           AS [Redeem Premium]
    ,m.[Commission]                             AS [Redeem Commission]
    ,m.[TaxOnAgentCommissionSD]                 AS [Redeem Tax On Agent Commission SD]
    ,m.[TaxOnAgentCommissionGST]                AS [Redeem Tax On Agent Commission GST]
    ,m.[GrossPremium - Active]                  AS [Redeem Gross Premium - Active]
    ,m.[TaxAmountSD - Active]                   AS [Redeem Tax Amount SD - Active]
    ,m.[TaxAmountGST - Active]                  AS [Redeem Tax Amount GST - Active]
    ,m.[GrossPremium - Active] 
    -m.[TaxAmountSD - Active] 
    -m.[TaxAmountGST - Active]                  AS [Redeem Premium - Active]
    ,m.[Commission - Active]                    AS [Redeem Commission - Active]
    ,m.[TaxOnAgentCommissionSD - Active]        AS [Redeem Tax On Agent Commission SD - Active]
    ,m.[TaxOnAgentCommissionGST - Active]       AS [Redeem Tax On Agent Commission GST - Active]
    ,m.[GrossPremium - Cancelled]               AS [Redeem Gross Premium - Cancelled]
    ,m.[TaxAmountSD - Cancelled]                AS [Redeem Tax Amount SD - Cancelled]
    ,m.[TaxAmountGST - Cancelled]               AS [Redeem Tax Amount GST - Cancelled]
    ,m.[GrossPremium - Cancelled] 
    -m.[TaxAmountSD - Cancelled] 
    -m.[TaxAmountGST - Cancelled]               AS [Redeem Premium - Cancelled]
    ,m.[Commission - Cancelled]                 AS [Redeem Commission - Cancelled]
    ,m.[TaxOnAgentCommissionSD - Cancelled]     AS [Redeem Tax On Agent Commission SD - Cancelled]
    ,m.[TaxOnAgentCommissionGST - Cancelled]    AS [Redeem Tax On Agent Commission GST - Cancelled]
    ,m.[Last Posting Date]                      AS [Redeem Last Posting Date]
    
    ,COUNT(c.[PolicyNumber]) OVER (PARTITION BY a.[CreditNoteNumber] ORDER BY a.[UpdateDateTime])                 AS [Redeem Policy Count]
    ,ROW_NUMBER()            OVER (PARTITION BY a.[CreditNoteNumber] ORDER BY a.[UpdateDateTime] DESC,a.[Status]) AS [Rank]

FROM      [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyCreditNote] a WITH(NOLOCK) 
LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penPolicy]           b WITH(NOLOCK) ON a.[OriginalPolicyId] = b.[PolicyID] AND a.[CountryKey] = b.[CountryKey] AND a.[CompanyKey] = b.[CompanyKey] AND a.[DomainId] = b.[DomainId] AND a.[OriginalPolicyId] <> 0
LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penPolicy]           c WITH(NOLOCK) ON a.[RedeemPolicyId]   = c.[PolicyID] AND a.[CountryKey] = c.[CountryKey] AND a.[CompanyKey] = c.[CompanyKey] AND a.[DomainId] = c.[DomainId] AND a.[RedeemPolicyId]   <> 0
LEFT JOIN (SELECT * FROM [ULSQLAGR03].[AU_PenguinSharp_Active]    .[dbo].[tblPolicyCreditNote] WITH(NOLOCK) 
           UNION ALL
           SELECT * FROM [ULSQLAGR03].[AU_TIP_PenguinSharp_Active].[dbo].[tblPolicyCreditNote] WITH(NOLOCK) 
           ) d ON a.[ID] = d.[ID] AND a.[CreditNoteNumber] = d.[CreditNoteNumber] COLLATE Latin1_General_CI_AS
OUTER APPLY (
           SELECT TOP 1 * 
           FROM [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] e1 WITH(NOLOCK)
           WHERE e1.[TransactionType] = 'Base' AND 
                (CAST(a.[CreateDateTime] as date) = CAST(e1.[IssueTimeUTC] as date) OR CAST(a.[CreateDateTime] as date) = CAST(e1.[IssueTime] as date)) AND
                 b.[PolicyKey] = e1.[PolicyKey]
           ORDER BY e1.[IssueTimeUTC] DESC
           ) e1
OUTER APPLY (
           SELECT TOP 1 * 
           FROM [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] e2 WITH(NOLOCK)
           WHERE e2.[TransactionType] = 'Base' AND 
                 b.[PolicyKey] = e2.[PolicyKey]
           ORDER BY e2.[IssueTimeUTC]
           ) e2
OUTER APPLY (
           SELECT TOP 1 * 
           FROM [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] f1 WITH(NOLOCK)
           WHERE f1.[TransactionType] = 'Base' AND 
                 f1.[TransactionStatus] = 'Active' AND
                 f1.[AutoComments] = 'Base Policy Redeemed' AND
                (CAST(a.[UpdateDateTime] as date) = CAST(f1.[IssueTimeUTC] as date) OR CAST(a.[UpdateDateTime] as date) = CAST(f1.[IssueTime] as date)) AND
                 COALESCE(a.[RedeemAmount],0) > 0 AND
                 c.[PolicyKey] = f1.[PolicyKey]
           ORDER BY f1.[IssueTimeUTC] DESC
           ) f1
OUTER APPLY (
           SELECT TOP 1 * 
           FROM [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] f2 WITH(NOLOCK)
           WHERE f2.[TransactionType] = 'Base' AND 
                 f2.[TransactionStatus] <> 'Active' AND
                (CAST(a.[UpdateDateTime] as date) = CAST(f2.[IssueTimeUTC] as date) OR CAST(a.[UpdateDateTime] as date) = CAST(f2.[IssueTime] as date)) AND
                 COALESCE(a.[RedeemAmount],0) < 0 AND
                 c.[PolicyKey] = f2.[PolicyKey]
           ORDER BY f2.[IssueTimeUTC] DESC
           ) f2
OUTER APPLY (
           SELECT TOP 1 * 
           FROM [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] f3 WITH(NOLOCK)
           WHERE f3.[TransactionType] = 'Base' AND 
                 c.[PolicyKey] = f3.[PolicyKey]
           ORDER BY [IssueTimeUTC]
           ) f3
LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTraveller]  g WITH(NOLOCK) ON b.[PolicyKey] = g.[PolicyKey] AND g.[isPrimary] = 1
LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTraveller]  h WITH(NOLOCK) ON c.[PolicyKey] = h.[PolicyKey] AND h.[isPrimary] = 1
LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penOutlet]           i WITH(NOLOCK) ON b.[OutletAlphaKey] = i.[OutletAlphaKey] AND i.[OutletStatus] = 'Current'
LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penOutlet]           j WITH(NOLOCK) ON c.[OutletAlphaKey] = j.[OutletAlphaKey] AND j.[OutletStatus] = 'Current'
LEFT JOIN ( SELECT DISTINCT [OriginalPolicyId],[CreditNoteNumber]
            FROM [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyCreditNote] WITH(NOLOCK)) k ON a.[RedeemPolicyId] = k.[OriginalPolicyId] 
LEFT JOIN ( SELECT
                 [PolicyKey]
                ,MAX([PostingDate])                                                                          AS [Last Posting Date]
                ,SUM([GrossPremium]                                                                        ) AS [GrossPremium]
                ,SUM([TaxAmountSD]                                                                         ) AS [TaxAmountSD]
                ,SUM([TaxAmountGST]                                                                        ) AS [TaxAmountGST]
                ,SUM([Commission]                                                                          ) AS [Commission]
                ,SUM([TaxOnAgentCommissionSD]                                                              ) AS [TaxOnAgentCommissionSD]
                ,SUM([TaxOnAgentCommissionGST]                                                             ) AS [TaxOnAgentCommissionGST]
                ,SUM(CASE WHEN [TransactionStatus] =  'Active' THEN [GrossPremium]               ELSE 0 END) AS [GrossPremium - Active]
                ,SUM(CASE WHEN [TransactionStatus] =  'Active' THEN [TaxAmountSD]                ELSE 0 END) AS [TaxAmountSD - Active]
                ,SUM(CASE WHEN [TransactionStatus] =  'Active' THEN [TaxAmountGST]               ELSE 0 END) AS [TaxAmountGST - Active]
                ,SUM(CASE WHEN [TransactionStatus] =  'Active' THEN [Commission]                 ELSE 0 END) AS [Commission - Active]
                ,SUM(CASE WHEN [TransactionStatus] =  'Active' THEN [TaxOnAgentCommissionSD]     ELSE 0 END) AS [TaxOnAgentCommissionSD - Active]
                ,SUM(CASE WHEN [TransactionStatus] =  'Active' THEN [TaxOnAgentCommissionGST]    ELSE 0 END) AS [TaxOnAgentCommissionGST - Active]
                ,SUM(CASE WHEN [TransactionStatus] <> 'Active' THEN [GrossPremium]               ELSE 0 END) AS [GrossPremium - Cancelled]
                ,SUM(CASE WHEN [TransactionStatus] <> 'Active' THEN [TaxAmountSD]                ELSE 0 END) AS [TaxAmountSD - Cancelled]
                ,SUM(CASE WHEN [TransactionStatus] <> 'Active' THEN [TaxAmountGST]               ELSE 0 END) AS [TaxAmountGST - Cancelled]
                ,SUM(CASE WHEN [TransactionStatus] <> 'Active' THEN [Commission]                 ELSE 0 END) AS [Commission - Cancelled]
                ,SUM(CASE WHEN [TransactionStatus] <> 'Active' THEN [TaxOnAgentCommissionSD]     ELSE 0 END) AS [TaxOnAgentCommissionSD - Cancelled]
                ,SUM(CASE WHEN [TransactionStatus] <> 'Active' THEN [TaxOnAgentCommissionGST]    ELSE 0 END) AS [TaxOnAgentCommissionGST - Cancelled]
            FROM [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary]
            GROUP BY [PolicyKey]) l ON b.[PolicyKey] = l.[PolicyKey]
LEFT JOIN ( SELECT
                 [PolicyKey]
                ,MAX([PostingDate])                                                                          AS [Last Posting Date]
                ,SUM([GrossPremium]                                                                        ) AS [GrossPremium]
                ,SUM([TaxAmountSD]                                                                         ) AS [TaxAmountSD]
                ,SUM([TaxAmountGST]                                                                        ) AS [TaxAmountGST]
                ,SUM([Commission]                                                                          ) AS [Commission]
                ,SUM([TaxOnAgentCommissionSD]                                                              ) AS [TaxOnAgentCommissionSD]
                ,SUM([TaxOnAgentCommissionGST]                                                             ) AS [TaxOnAgentCommissionGST]
                ,SUM(CASE WHEN [TransactionStatus] =  'Active' THEN [GrossPremium]               ELSE 0 END) AS [GrossPremium - Active]
                ,SUM(CASE WHEN [TransactionStatus] =  'Active' THEN [TaxAmountSD]                ELSE 0 END) AS [TaxAmountSD - Active]
                ,SUM(CASE WHEN [TransactionStatus] =  'Active' THEN [TaxAmountGST]               ELSE 0 END) AS [TaxAmountGST - Active]
                ,SUM(CASE WHEN [TransactionStatus] =  'Active' THEN [Commission]                 ELSE 0 END) AS [Commission - Active]
                ,SUM(CASE WHEN [TransactionStatus] =  'Active' THEN [TaxOnAgentCommissionSD]     ELSE 0 END) AS [TaxOnAgentCommissionSD - Active]
                ,SUM(CASE WHEN [TransactionStatus] =  'Active' THEN [TaxOnAgentCommissionGST]    ELSE 0 END) AS [TaxOnAgentCommissionGST - Active]
                ,SUM(CASE WHEN [TransactionStatus] <> 'Active' THEN [GrossPremium]               ELSE 0 END) AS [GrossPremium - Cancelled]
                ,SUM(CASE WHEN [TransactionStatus] <> 'Active' THEN [TaxAmountSD]                ELSE 0 END) AS [TaxAmountSD - Cancelled]
                ,SUM(CASE WHEN [TransactionStatus] <> 'Active' THEN [TaxAmountGST]               ELSE 0 END) AS [TaxAmountGST - Cancelled]
                ,SUM(CASE WHEN [TransactionStatus] <> 'Active' THEN [Commission]                 ELSE 0 END) AS [Commission - Cancelled]
                ,SUM(CASE WHEN [TransactionStatus] <> 'Active' THEN [TaxOnAgentCommissionSD]     ELSE 0 END) AS [TaxOnAgentCommissionSD - Cancelled]
                ,SUM(CASE WHEN [TransactionStatus] <> 'Active' THEN [TaxOnAgentCommissionGST]    ELSE 0 END) AS [TaxOnAgentCommissionGST - Cancelled]
            FROM [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary]
            GROUP BY [PolicyKey]) m ON c.[PolicyKey] = m.[PolicyKey]
--LEFT JOIN [db-au-actuary].[cng].[UWPremiumEndorsement_202104] n ON b.[PolicyKey] = n.[PolicyKey] AND b.[ProductCode] = n.[Product_Code]
--LEFT JOIN [db-au-actuary].[cng].[UWPremiumEndorsement_202104] o ON c.[PolicyKey] = o.[PolicyKey] AND c.[ProductCode] = o.[Product_Code]
--WHERE a.[CreditNoteNumber] IN ('CN-718000976112','CN-718000976100','CN-719000884445')
--ORDER BY a.[DomainKey],a.[CreditNoteNumber],a.[UpdateDateTime],a.[Status] DESC
;
GO
