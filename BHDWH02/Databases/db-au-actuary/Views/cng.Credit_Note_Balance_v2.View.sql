USE [db-au-actuary]
GO
/****** Object:  View [cng].[Credit_Note_Balance_v2]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Credit_Note_Balance_v2] AS
WITH 
--tblPolicyTransaction
Refunded_Credit_Notes AS (
    SELECT DISTINCT [PolicyID]
    FROM      [ULSQLAGR03].[AU_PenguinSharp_Active].[dbo].[tblPolicyTransaction] a WITH(NOLOCK)
    LEFT JOIN [ULSQLAGR03].[AU_PenguinSharp_Active].[dbo].[tblPolicyCNStatus]    b WITH(NOLOCK) ON a.[CNStatusID] = b.[CNStatusID]
    WHERE b.[CNStatus] = 'Refunded Credit Note'

    UNION ALL

    SELECT DISTINCT [PolicyID]
    FROM      [ULSQLAGR03].[AU_TIP_PenguinSharp_Active].[dbo].[tblPolicyTransaction] a WITH(NOLOCK)
    LEFT JOIN [ULSQLAGR03].[AU_TIP_PenguinSharp_Active].[dbo].[tblPolicyCNStatus]    b WITH(NOLOCK) ON a.[CNStatusID] = b.[CNStatusID]
    WHERE b.[CNStatus] = 'Refunded Credit Note'
)

--tblPolicyCreditNote
,Credit_Note_01 AS (
    SELECT
         a.*
        ,b.[CountryCode]
        ,'CM' AS [CompanyCode]
        ,c.[CNStatus]
        ,ROW_NUMBER() OVER (PARTITION BY a.[CreditNoteNumber] ORDER BY a.[UpdateDateTime],a.[Status] DESC) AS [Rank]
    FROM      [ULSQLAGR03].[AU_PenguinSharp_Active].[dbo].[tblPolicyCreditNote] a WITH(NOLOCK)
    LEFT JOIN [ULSQLAGR03].[AU_PenguinSharp_Active].[dbo].[tblDomain]           b WITH(NOLOCK) ON a.[DomainId]   = b.[DomainId]
    LEFT JOIN [ULSQLAGR03].[AU_PenguinSharp_Active].[dbo].[tblPolicyCNStatus]   c WITH(NOLOCK) ON a.[CNStatusID] = c.[CNStatusID]

    UNION ALL
    
    SELECT
         a.*
        ,b.[CountryCode]
        ,'TIP' AS [CompanyCode]
        ,c.[CNStatus]
        ,ROW_NUMBER() OVER (PARTITION BY a.[CreditNoteNumber] ORDER BY a.[UpdateDateTime],a.[Status] DESC) AS [Rank]
    FROM      [ULSQLAGR03].[AU_TIP_PenguinSharp_Active].[dbo].[tblPolicyCreditNote] a WITH(NOLOCK)
    LEFT JOIN [ULSQLAGR03].[AU_TIP_PenguinSharp_Active].[dbo].[tblDomain]           b WITH(NOLOCK) ON a.[DomainId]   = b.[DomainId]
    LEFT JOIN [ULSQLAGR03].[AU_TIP_PenguinSharp_Active].[dbo].[tblPolicyCNStatus]   c WITH(NOLOCK) ON a.[CNStatusID] = c.[CNStatusID]
)

--Rename columns
,Credit_Note_02 AS (
    SELECT 
         [CountryCode]                      AS [Country Key]
        ,[CompanyCode]                      AS [Company Key]
        ,[DomainId]                         AS [Domain Id]
        ,[CountryCode]+'-'+[CompanyCode]+'-'+CAST([DomainId] as varchar(1))     
                                            AS [Domain Key]
        ,[OriginalPolicyId]                 AS [Original PolicyId]
        ,[CountryCode]+'-'+[CompanyCode]+CAST([DomainId] as varchar(1))+'-'+CAST([OriginalPolicyId] as varchar(10))
                                            AS [Original PolicyKey]
        ,[Id]                               AS [Credit Note Id]
        ,[CountryCode]+'-'+[CompanyCode]+CAST([DomainId] as varchar(1))+'-'+CAST([Id] as varchar(10))          
                                            AS [Credit Note PolicyKey]
        ,[CreditNoteNumber]                 AS [Credit Note Number]
        ,[CreateDateTime]                   AS [Credit Note Issue Date]
        ,[TripStartDate]                    AS [Credit Note Start Date]
        ,[ExpiryDate]                       AS [Credit Note Expiry Date]
        ,[UpdateDateTime]                   AS [Credit Note Transaction Date]
        ,CAST(EOMONTH([UpdateDateTime]) as datetime)
                                            AS [Credit Note Transaction Month]
        ,[Rank]+1                           AS [Credit Note Transaction Order]
      --,IIF([CNStatus] = 'Redeemed within Group','Redeemed',[Status])
      --                                    AS [Credit Note Status]
        ,[Status]                           AS [Credit Note Status]
        ,CASE 
            --Redeemed within Group
            WHEN [Status] = 'Redeemed'  AND [CNStatus] IN ('Redeemed within Group' ,'Cancelled Redeemed Policy within Group' )  AND [RedeemPolicyId] >= 1   THEN 'Redeemed_Within'
            WHEN [Status] = 'Redeemed'  AND [CNStatus] IS NULL                                                                  AND [RedeemPolicyId] >= 1   THEN 'Redeemed_Within'
            --Redeemed outside Group
            WHEN [Status] = 'Redeemed'  AND [CNStatus] IN ('Redeemed outside Group','Cancelled Redeemed Policy outside Group')  AND [RedeemPolicyId] >= 1   THEN 'Redeemed_Outside'
            --Refunded
            WHEN [Status] = 'Refunded'                                                                                                                      THEN 'Refunded'
            WHEN [Status] = 'Redeemed'  AND [RedeemPolicyId] <= 0                                                                                           THEN 'Refunded'
            WHEN [Status] = 'Active'    AND [OriginalPolicyId] IN (SELECT [PolicyID] FROM Refunded_Credit_Notes) AND [ExpiryDate] >= GETDATE()              THEN 'Refunded'
            WHEN [Status] = 'Expired'   AND [OriginalPolicyId] IN (SELECT [PolicyID] FROM Refunded_Credit_Notes) AND [ExpiryDate] >= GETDATE()              THEN 'Refunded'
            --Expired
            WHEN [Status] = 'Expired'                                                                                                                       THEN 'Expired'
            WHEN [Status] = 'Active'    AND [ExpiryDate] < GETDATE()                                                                                        THEN 'Expired'
            --Active
            ELSE 'Active'
         END                                AS [Credit Note Status Fix]
        ,[Comments]                         AS [Credit Note Comments]
        ,[RedeemPolicyId]                   AS [Redeemed PolicyId]
        ,IIF([RedeemPolicyId]=-1,NULL,[CountryCode]+'-'+[CompanyCode]+CAST([DomainId] as varchar(1))+'-'+CAST([RedeemPolicyId] as varchar(10)))
                                            AS [Redeemed PolicyKey]
        ,[CNStatus]                         AS [Credit Note Redeemed Status]
        ,COALESCE([Amount],0)               AS [Credit Note Amount]
        ,COALESCE([Commission],0)           AS [Credit Note Commission]
        ,COALESCE([RedeemAmount],0)         AS [Credit Note Redeemed Amount]
        ,COALESCE([RedeemedCommission],0)   AS [Credit Note Redeemed Commission]
    FROM Credit_Note_01
    WHERE [CreditNoteNumber] IN ('CN-719000737480','CN-819000411916','CN-820000438288','CN-719000854112')
)

--Issued Transactions
,Credit_Note_03 AS (
    SELECT 
         [Country Key]
        ,[Company Key]
        ,[Domain Id]
        ,[Domain Key]
        ,[Original PolicyId]
        ,[Original PolicyKey]
        ,[Credit Note Id]
        ,[Credit Note PolicyKey]
        ,[Credit Note Number]
        ,[Credit Note Issue Date]
        ,[Credit Note Start Date]
        ,[Credit Note Expiry Date]
        ,[Credit Note Issue Date]           AS [Credit Note Transaction Date]
        ,CAST(EOMONTH([Credit Note Issue Date]) as datetime)
                                            AS [Credit Note Transaction Month]
        ,1                                  AS [Credit Note Transaction Order]
        ,'Issued'                           AS [Credit Note Status]
        ,'Issued'                           AS [Credit Note Status Fix]
        ,NULL                               AS [Credit Note Comments]
        ,NULL                               AS [Redeemed PolicyId]
        ,NULL                               AS [Redeemed PolicyKey]
        ,NULL                               AS [Credit Note Redeemed Status]
        ,-[Credit Note Amount]              AS [Credit Note Issued Amount]
        ,-[Credit Note Commission]          AS [Credit Note Issued Commission]
        ,0                                  AS [Credit Note Expired Amount]
        ,0                                  AS [Credit Note Expired Commission]
        ,0                                  AS [Credit Note Redeemed Amount]
        ,0                                  AS [Credit Note Redeemed Commission]
        ,0                                  AS [Credit Note Refunded Amount]
        ,0                                  AS [Credit Note Refunded Commission]
    FROM Credit_Note_02
    WHERE [Credit Note Transaction Order] = 2
)

--Expired & Redeemed Transactions
,Credit_Note_04 AS (
    SELECT 
         [Country Key]
        ,[Company Key]
        ,[Domain Id]
        ,[Domain Key]
        ,[Original PolicyId]
        ,[Original PolicyKey]
        ,[Credit Note Id]
        ,[Credit Note PolicyKey]
        ,[Credit Note Number]
        ,[Credit Note Issue Date]
        ,[Credit Note Start Date]
        ,[Credit Note Expiry Date]
        ,[Credit Note Transaction Date]
        ,[Credit Note Transaction Month]
        ,[Credit Note Transaction Order]
        ,[Credit Note Status]
        ,[Credit Note Status Fix]
        ,[Credit Note Comments]
      --,IIF([Credit Note Status]='Expired',[Original PolicyId] ,[Redeemed PolicyId] )      AS [Redeemed PolicyId]
      --,IIF([Credit Note Status]='Expired',[Original PolicyKey],[Redeemed PolicyKey])      AS [Redeemed PolicyKey]
        ,CASE WHEN [Credit Note Status Fix]='Expired'   THEN [Original PolicyId]
              WHEN [Credit Note Status Fix]='Refunded'  THEN [Original PolicyId]
                                                        ELSE [Redeemed PolicyId]
         END                                                                                                            AS [Redeemed PolicyId]
        ,CASE WHEN [Credit Note Status Fix]='Expired'   THEN [Original PolicyKey]
              WHEN [Credit Note Status Fix]='Refunded'  THEN [Original PolicyKey]
                                                        ELSE [Redeemed PolicyKey]
         END                                                                                                            AS [Redeemed PolicyKey]
        ,IIF([Credit Note Status Fix] IN ('Expired'),'Expired',[Credit Note Redeemed Status])                           AS [Credit Note Redeemed Status]
        ,0                                                                                                              AS [Credit Note Issued Amount]
        ,0                                                                                                              AS [Credit Note Issued Commission]
        ,IIF([Credit Note Status Fix] IN ('Expired')                           ,[Credit Note Amount]             ,0)    AS [Credit Note Expired Amount]
        ,IIF([Credit Note Status Fix] IN ('Expired')                           ,[Credit Note Commission]         ,0)    AS [Credit Note Expired Commission]
        ,IIF([Credit Note Status Fix] IN ('Redeemed_Within','Redeemed_Outside'),[Credit Note Redeemed Amount]    ,0)    AS [Credit Note Redeemed Amount]
        ,IIF([Credit Note Status Fix] IN ('Redeemed_Within','Redeemed_Outside'),[Credit Note Redeemed Commission],0)    AS [Credit Note Redeemed Commission]
        ,IIF([Credit Note Status Fix] IN ('Refunded')                          ,[Credit Note Amount]             ,0)    AS [Credit Note Refunded Amount]
        ,IIF([Credit Note Status Fix] IN ('Refunded')                          ,[Credit Note Commission]         ,0)    AS [Credit Note Refunded Commission]
    FROM Credit_Note_02
)

--Combine Transactions
,Credit_Note_05 AS (
    SELECT * FROM Credit_Note_03 
    UNION ALL 
    SELECT * FROM Credit_Note_04
)

--Cancelled to credit note premium
,Original_Policy_01 AS (
    SELECT 
         [PolicyKey]
        ,SUM([GrossPremium])            AS [Original Gross Amount]
        ,SUM([TaxAmountSD])             AS [Original SD Amount] 
        ,SUM([TaxAmountGST])            AS [Original GST Amount]
        ,SUM([GrossPremium]) 
        -SUM([TaxAmountSD]) 
        -SUM([TaxAmountGST])            AS [Original Net Amount]
        ,SUM([Commission])              AS [Original Gross Commission]
        ,SUM([TaxOnAgentCommissionSD])  AS [Original SD Commission]
        ,SUM([TaxOnAgentCommissionGST]) AS [Original GST Commission]
        ,SUM([Commission])
        -SUM([TaxOnAgentCommissionSD])
        -SUM([TaxOnAgentCommissionGST]) AS [Original Net Commission]
    FROM [uldwh02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] WITH(NOLOCK) 
    WHERE [CNStatusID] IN (1,4,6)
    GROUP BY [PolicyKey]
)

,Original_Policy_02 AS (
    SELECT 
         [PolicyKey]
        ,CAST([IssueTimeUTC] as date)   AS [IssueTimeUTC]
        ,SUM([GrossPremium])            AS [Original Gross Amount]
        ,SUM([TaxAmountSD])             AS [Original SD Amount] 
        ,SUM([TaxAmountGST])            AS [Original GST Amount]
        ,SUM([GrossPremium]) 
        -SUM([TaxAmountSD]) 
        -SUM([TaxAmountGST])            AS [Original Net Amount]
        ,SUM([Commission])              AS [Original Gross Commission]
        ,SUM([TaxOnAgentCommissionSD])  AS [Original SD Commission]
        ,SUM([TaxOnAgentCommissionGST]) AS [Original GST Commission]
        ,SUM([Commission])
        -SUM([TaxOnAgentCommissionSD])
        -SUM([TaxOnAgentCommissionGST]) AS [Original Net Commission]
    FROM [uldwh02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] WITH(NOLOCK) 
    WHERE [TransactionStatus] <> 'Active'
    GROUP BY [PolicyKey],CAST([IssueTimeUTC] as date)
)

,Original_Policy_03 AS (
    SELECT 
         [PolicyKey]
        ,CAST([IssueTime] as date)      AS [IssueTime]
        ,SUM([GrossPremium])            AS [Original Gross Amount]
        ,SUM([TaxAmountSD])             AS [Original SD Amount] 
        ,SUM([TaxAmountGST])            AS [Original GST Amount]
        ,SUM([GrossPremium]) 
        -SUM([TaxAmountSD]) 
        -SUM([TaxAmountGST])            AS [Original Net Amount]
        ,SUM([Commission])              AS [Original Gross Commission]
        ,SUM([TaxOnAgentCommissionSD])  AS [Original SD Commission]
        ,SUM([TaxOnAgentCommissionGST]) AS [Original GST Commission]
        ,SUM([Commission])
        -SUM([TaxOnAgentCommissionSD])
        -SUM([TaxOnAgentCommissionGST]) AS [Original Net Commission]
    FROM [uldwh02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] WITH(NOLOCK) 
    WHERE [TransactionStatus] <> 'Active'
    GROUP BY [PolicyKey],CAST([IssueTime] as date)
)

--Redeemed from credit note premium
,Redeemed_Policy_01 AS (
    SELECT 
         [PolicyKey]
        ,SUM([GrossPremium])            AS [Redeemed Gross Amount]
        ,SUM([TaxAmountSD])             AS [Redeemed SD Amount] 
        ,SUM([TaxAmountGST])            AS [Redeemed GST Amount]
        ,SUM([GrossPremium]) 
        -SUM([TaxAmountSD]) 
        -SUM([TaxAmountGST])            AS [Redeemed Net Amount]
        ,SUM([Commission])              AS [Redeemed Gross Commission]
        ,SUM([TaxOnAgentCommissionSD])  AS [Redeemed SD Commission]
        ,SUM([TaxOnAgentCommissionGST]) AS [Redeemed GST Commission]
        ,SUM([Commission])
        -SUM([TaxOnAgentCommissionSD])
        -SUM([TaxOnAgentCommissionGST]) AS [Redeemed Net Commission]
    FROM [uldwh02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] WITH(NOLOCK) 
    WHERE [CNStatusID] IN (2,3) AND [TransactionStatus] = 'Active'
    GROUP BY [PolicyKey]
)

,Redeemed_Policy_02 AS (
    SELECT 
         [PolicyKey]
        ,SUM([GrossPremium])            AS [Redeemed Gross Amount]
        ,SUM([TaxAmountSD])             AS [Redeemed SD Amount] 
        ,SUM([TaxAmountGST])            AS [Redeemed GST Amount]
        ,SUM([GrossPremium]) 
        -SUM([TaxAmountSD]) 
        -SUM([TaxAmountGST])            AS [Redeemed Net Amount]
        ,SUM([Commission])              AS [Redeemed Gross Commission]
        ,SUM([TaxOnAgentCommissionSD])  AS [Redeemed SD Commission]
        ,SUM([TaxOnAgentCommissionGST]) AS [Redeemed GST Commission]
        ,SUM([Commission])
        -SUM([TaxOnAgentCommissionSD])
        -SUM([TaxOnAgentCommissionGST]) AS [Redeemed Net Commission]
    FROM [uldwh02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] WITH(NOLOCK) 
    WHERE [CNStatusID] IN (4,6) AND [TransactionStatus] <> 'Active'
    GROUP BY [PolicyKey]
)

,Redeemed_Policy_03 AS (
    SELECT 
         [PolicyKey]
        ,CAST([IssueTimeUTC] as date)   AS [IssueTimeUTC]
        ,SUM([GrossPremium])            AS [Redeemed Gross Amount]
        ,SUM([TaxAmountSD])             AS [Redeemed SD Amount] 
        ,SUM([TaxAmountGST])            AS [Redeemed GST Amount]
        ,SUM([GrossPremium]) 
        -SUM([TaxAmountSD]) 
        -SUM([TaxAmountGST])            AS [Redeemed Net Amount]
        ,SUM([Commission])              AS [Redeemed Gross Commission]
        ,SUM([TaxOnAgentCommissionSD])  AS [Redeemed SD Commission]
        ,SUM([TaxOnAgentCommissionGST]) AS [Redeemed GST Commission]
        ,SUM([Commission])
        -SUM([TaxOnAgentCommissionSD])
        -SUM([TaxOnAgentCommissionGST]) AS [Redeemed Net Commission]
    FROM [uldwh02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] WITH(NOLOCK) 
    GROUP BY [PolicyKey],CAST([IssueTimeUTC] as date)
)

,Redeemed_Policy_04 AS (
    SELECT 
         [PolicyKey]
        ,CAST([IssueTime] as date)      AS [IssueTime]
        ,SUM([GrossPremium])            AS [Redeemed Gross Amount]
        ,SUM([TaxAmountSD])             AS [Redeemed SD Amount] 
        ,SUM([TaxAmountGST])            AS [Redeemed GST Amount]
        ,SUM([GrossPremium]) 
        -SUM([TaxAmountSD]) 
        -SUM([TaxAmountGST])            AS [Redeemed Net Amount]
        ,SUM([Commission])              AS [Redeemed Gross Commission]
        ,SUM([TaxOnAgentCommissionSD])  AS [Redeemed SD Commission]
        ,SUM([TaxOnAgentCommissionGST]) AS [Redeemed GST Commission]
        ,SUM([Commission])
        -SUM([TaxOnAgentCommissionSD])
        -SUM([TaxOnAgentCommissionGST]) AS [Redeemed Net Commission]
    FROM [uldwh02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] WITH(NOLOCK) 
    GROUP BY [PolicyKey],CAST([IssueTime] as date)
)

--UW premium
,UW_Premium AS (
    SELECT 
         [UW_Month]
        ,[PolicyKey]
        ,SUM([Movement]) AS [UW Premium]
    FROM [BHDWH02].[db-au-actuary].[cng].[UW_Premiums] WITH(NOLOCK) 
    WHERE ([Movement] <> 0 OR [Previous_Policy_Status] IS NULL)
    GROUP BY 
         [UW_Month]
        ,[PolicyKey]
)

--Join policy premium
,Credit_Note_06 AS (
    SELECT 
         a.*

        ,COALESCE(w1.[UW Premium],w2.[UW Premium],w3.[UW Premium],0) AS [Original UW Premium]
        ,COALESCE(x1.[UW Premium],x2.[UW Premium],x3.[UW Premium],0) AS [Expired UW Premium]
        ,COALESCE(y1.[UW Premium],y2.[UW Premium],y3.[UW Premium],0) AS [Redeemed UW Premium]
        ,COALESCE(z1.[UW Premium],z2.[UW Premium],z3.[UW Premium],0) AS [Refunded UW Premium]

        ,COALESCE(b.[Original Gross Amount]    ,c.[Original Gross Amount]    ,d.[Original Gross Amount]    ,0) AS [Original Gross Amount]
        ,COALESCE(b.[Original SD Amount]       ,c.[Original SD Amount]       ,d.[Original SD Amount]       ,0) AS [Original SD Amount]
        ,COALESCE(b.[Original GST Amount]      ,c.[Original GST Amount]      ,d.[Original GST Amount]      ,0) AS [Original GST Amount]
        ,COALESCE(b.[Original Net Amount]      ,c.[Original Net Amount]      ,d.[Original Net Amount]      ,0) AS [Original Net Amount]
        ,COALESCE(b.[Original Gross Commission],c.[Original Gross Commission],d.[Original Gross Commission],0) AS [Original Gross Commission]
        ,COALESCE(b.[Original SD Commission]   ,c.[Original SD Commission]   ,d.[Original SD Commission]   ,0) AS [Original SD Commission]
        ,COALESCE(b.[Original GST Commission]  ,c.[Original GST Commission]  ,d.[Original GST Commission]  ,0) AS [Original GST Commission]
        ,COALESCE(b.[Original Net Commission]  ,c.[Original Net Commission]  ,d.[Original Net Commission]  ,0) AS [Original Net Commission]

        ,-COALESCE(e.[Original Gross Amount]    ,f.[Original Gross Amount]    ,g.[Original Gross Amount]    ,0) AS [Expired Gross Amount]
        ,-COALESCE(e.[Original SD Amount]       ,f.[Original SD Amount]       ,g.[Original SD Amount]       ,0) AS [Expired SD Amount]
        ,-COALESCE(e.[Original GST Amount]      ,f.[Original GST Amount]      ,g.[Original GST Amount]      ,0) AS [Expired GST Amount]
        ,-COALESCE(e.[Original Net Amount]      ,f.[Original Net Amount]      ,g.[Original Net Amount]      ,0) AS [Expired Net Amount]
        ,-COALESCE(e.[Original Gross Commission],f.[Original Gross Commission],g.[Original Gross Commission],0) AS [Expired Gross Commission]
        ,-COALESCE(e.[Original SD Commission]   ,f.[Original SD Commission]   ,g.[Original SD Commission]   ,0) AS [Expired SD Commission]
        ,-COALESCE(e.[Original GST Commission]  ,f.[Original GST Commission]  ,g.[Original GST Commission]  ,0) AS [Expired GST Commission]
        ,-COALESCE(e.[Original Net Commission]  ,f.[Original Net Commission]  ,g.[Original Net Commission]  ,0) AS [Expired Net Commission]

        ,COALESCE(h.[Redeemed Gross Amount]    ,i.[Redeemed Gross Amount]    ,j.[Redeemed Gross Amount]    ,k.[Redeemed Gross Amount]    ,0) AS [Redeemed Gross Amount]
        ,COALESCE(h.[Redeemed SD Amount]       ,i.[Redeemed SD Amount]       ,j.[Redeemed SD Amount]       ,k.[Redeemed SD Amount]       ,0) AS [Redeemed SD Amount]
        ,COALESCE(h.[Redeemed GST Amount]      ,i.[Redeemed GST Amount]      ,j.[Redeemed GST Amount]      ,k.[Redeemed GST Amount]      ,0) AS [Redeemed GST Amount]
        ,COALESCE(h.[Redeemed Net Amount]      ,i.[Redeemed Net Amount]      ,j.[Redeemed Net Amount]      ,k.[Redeemed Net Amount]      ,0) AS [Redeemed Net Amount]
        ,COALESCE(h.[Redeemed Gross Commission],i.[Redeemed Gross Commission],j.[Redeemed Gross Commission],k.[Redeemed Gross Commission],0) AS [Redeemed Gross Commission]
        ,COALESCE(h.[Redeemed SD Commission]   ,i.[Redeemed SD Commission]   ,j.[Redeemed SD Commission]   ,k.[Redeemed SD Commission]   ,0) AS [Redeemed SD Commission]
        ,COALESCE(h.[Redeemed GST Commission]  ,i.[Redeemed GST Commission]  ,j.[Redeemed GST Commission]  ,k.[Redeemed GST Commission]  ,0) AS [Redeemed GST Commission]
        ,COALESCE(h.[Redeemed Net Commission]  ,i.[Redeemed Net Commission]  ,j.[Redeemed Net Commission]  ,k.[Redeemed Net Commission]  ,0) AS [Redeemed Net Commission]

        ,-COALESCE(l.[Original Gross Amount]    ,m.[Original Gross Amount]    ,n.[Original Gross Amount]    ,0) AS [Refunded Gross Amount]
        ,-COALESCE(l.[Original SD Amount]       ,m.[Original SD Amount]       ,n.[Original SD Amount]       ,0) AS [Refunded SD Amount]
        ,-COALESCE(l.[Original GST Amount]      ,m.[Original GST Amount]      ,n.[Original GST Amount]      ,0) AS [Refunded GST Amount]
        ,-COALESCE(l.[Original Net Amount]      ,m.[Original Net Amount]      ,n.[Original Net Amount]      ,0) AS [Refunded Net Amount]
        ,-COALESCE(l.[Original Gross Commission],m.[Original Gross Commission],n.[Original Gross Commission],0) AS [Refunded Gross Commission]
        ,-COALESCE(l.[Original SD Commission]   ,m.[Original SD Commission]   ,n.[Original SD Commission]   ,0) AS [Refunded SD Commission]
        ,-COALESCE(l.[Original GST Commission]  ,m.[Original GST Commission]  ,n.[Original GST Commission]  ,0) AS [Refunded GST Commission]
        ,-COALESCE(l.[Original Net Commission]  ,m.[Original Net Commission]  ,n.[Original Net Commission]  ,0) AS [Refunded Net Commission]

    FROM      Credit_Note_05     a

    LEFT JOIN Original_Policy_01 b ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = b.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Issued')
    LEFT JOIN Original_Policy_02 c ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = c.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Issued')                             AND CAST(a.[Credit Note Issue Date] as date) = CAST(c.[IssueTimeUTC] as date)
    LEFT JOIN Original_Policy_03 d ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = d.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Issued')                             AND CAST(a.[Credit Note Issue Date] as date) = CAST(d.[IssueTime]    as date)

    LEFT JOIN Original_Policy_01 e ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = e.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Expired')
    LEFT JOIN Original_Policy_02 f ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = f.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Expired')                            AND CAST(a.[Credit Note Issue Date] as date) = CAST(f.[IssueTimeUTC] as date)
    LEFT JOIN Original_Policy_03 g ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = g.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Expired')                            AND CAST(a.[Credit Note Issue Date] as date) = CAST(g.[IssueTime]    as date)

    LEFT JOIN Redeemed_Policy_01 h ON a.[Redeemed PolicyKey] COLLATE Latin1_General_CI_AS = h.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Redeemed_Within','Redeemed_Outside') AND a.[Credit Note Redeemed Amount] > 0
    LEFT JOIN Redeemed_Policy_02 i ON a.[Redeemed PolicyKey] COLLATE Latin1_General_CI_AS = i.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Redeemed_Within','Redeemed_Outside') AND a.[Credit Note Redeemed Amount] < 0
    LEFT JOIN Redeemed_Policy_03 j ON a.[Redeemed PolicyKey] COLLATE Latin1_General_CI_AS = j.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Redeemed_Within','Redeemed_Outside') AND CAST(a.[Credit Note Transaction Date] as date) = CAST(j.[IssueTimeUTC] as date)
    LEFT JOIN Redeemed_Policy_04 k ON a.[Redeemed PolicyKey] COLLATE Latin1_General_CI_AS = k.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Redeemed_Within','Redeemed_Outside') AND CAST(a.[Credit Note Transaction Date] as date) = CAST(k.[IssueTime]    as date)
 
    LEFT JOIN Original_Policy_01 l ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = e.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Refunded')
    LEFT JOIN Original_Policy_02 m ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = f.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Refunded')                           AND CAST(a.[Credit Note Issue Date] as date) = CAST(f.[IssueTimeUTC] as date)
    LEFT JOIN Original_Policy_03 n ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = g.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Refunded')                           AND CAST(a.[Credit Note Issue Date] as date) = CAST(g.[IssueTime]    as date)

    LEFT JOIN UW_Premium         w1 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = w1.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Issued')                             AND CAST(EOMONTH(a.[Credit Note Issue Date], 0)        as date) = CAST(w1.[UW_Month] as date) AND w1.[UW Premium] <= 0
    LEFT JOIN UW_Premium         w2 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = w2.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Issued')                             AND CAST(EOMONTH(a.[Credit Note Issue Date], 1)        as date) = CAST(w2.[UW_Month] as date) AND w2.[UW Premium] <= 0
    LEFT JOIN UW_Premium         w3 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = w3.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Issued')                             AND CAST(EOMONTH(a.[Credit Note Issue Date],-1)        as date) = CAST(w3.[UW_Month] as date) AND w3.[UW Premium] <= 0
    LEFT JOIN UW_Premium         x1 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = x1.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Expired')                            AND CAST(EOMONTH(a.[Credit Note Issue Date], 0)        as date) = CAST(x1.[UW_Month] as date) AND x1.[UW Premium] <= 0
    LEFT JOIN UW_Premium         x2 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = x2.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Expired')                            AND CAST(EOMONTH(a.[Credit Note Issue Date], 1)        as date) = CAST(x2.[UW_Month] as date) AND x2.[UW Premium] <= 0
    LEFT JOIN UW_Premium         x3 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = x3.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Expired')                            AND CAST(EOMONTH(a.[Credit Note Issue Date],-1)        as date) = CAST(x3.[UW_Month] as date) AND x3.[UW Premium] <= 0
    LEFT JOIN UW_Premium         y1 ON a.[Redeemed PolicyKey] COLLATE Latin1_General_CI_AS = y1.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Redeemed_Within','Redeemed_Outside') AND CAST(EOMONTH(a.[Credit Note Transaction Month], 0) as date) = CAST(y1.[UW_Month] as date) AND y1.[UW Premium] >= 0
    LEFT JOIN UW_Premium         y2 ON a.[Redeemed PolicyKey] COLLATE Latin1_General_CI_AS = y2.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Redeemed_Within','Redeemed_Outside') AND CAST(EOMONTH(a.[Credit Note Transaction Month], 1) as date) = CAST(y2.[UW_Month] as date) AND y2.[UW Premium] >= 0
    LEFT JOIN UW_Premium         y3 ON a.[Redeemed PolicyKey] COLLATE Latin1_General_CI_AS = y3.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Redeemed_Within','Redeemed_Outside') AND CAST(EOMONTH(a.[Credit Note Transaction Month],-1) as date) = CAST(y3.[UW_Month] as date) AND y3.[UW Premium] >= 0
    LEFT JOIN UW_Premium         z1 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = z1.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Refunded')                           AND CAST(EOMONTH(a.[Credit Note Issue Date], 0)        as date) = CAST(z1.[UW_Month] as date) AND z1.[UW Premium] <= 0
    LEFT JOIN UW_Premium         z2 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = z2.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Refunded')                           AND CAST(EOMONTH(a.[Credit Note Issue Date], 1)        as date) = CAST(z2.[UW_Month] as date) AND z2.[UW Premium] <= 0
    LEFT JOIN UW_Premium         z3 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = z3.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Refunded')                           AND CAST(EOMONTH(a.[Credit Note Issue Date],-1)        as date) = CAST(z3.[UW_Month] as date) AND z3.[UW Premium] <= 0
)

--Calculate credit note SD,GST and net amounts.
,Credit_Note_07 AS (
    SELECT 
         [Country Key]
        ,[Company Key]
        ,[Domain Id]
        ,[Domain Key]
        ,[Original PolicyId]
        ,[Original PolicyKey]
        ,[Credit Note Id]
        ,[Credit Note PolicyKey]
        ,[Credit Note Number]
        ,[Credit Note Issue Date]
        ,[Credit Note Start Date]
        ,[Credit Note Expiry Date]
        ,[Credit Note Transaction Date]
        ,[Credit Note Transaction Month]
        ,[Credit Note Transaction Order]
        ,[Credit Note Status]
        ,[Credit Note Status Fix]
        ,[Credit Note Comments]
        ,[Redeemed PolicyId]
        ,[Redeemed PolicyKey]
        ,[Credit Note Redeemed Status]

        ,[Credit Note Issued Amount]
        ,[Credit Note Issued Amount]        * IIF([Original Gross Amount]=0,0,[Original SD Amount] /[Original Gross Amount])    AS [Credit Note Issued SD Amount]
        ,[Credit Note Issued Amount]        * IIF([Original Gross Amount]=0,0,[Original GST Amount]/[Original Gross Amount])    AS [Credit Note Issued GST Amount]
        ,[Credit Note Issued Amount]
        -[Credit Note Issued Amount]        * IIF([Original Gross Amount]=0,0,[Original SD Amount] /[Original Gross Amount])
        -[Credit Note Issued Amount]        * IIF([Original Gross Amount]=0,0,[Original GST Amount]/[Original Gross Amount])    AS [Credit Note Issued Net Amount]
        ,[Credit Note Issued Commission]
        ,[Credit Note Issued Commission]    * IIF([Original Gross Commission]=0,0,[Original SD Commission] /[Original Gross Commission])    AS [Credit Note Issued SD Commission]
        ,[Credit Note Issued Commission]    * IIF([Original Gross Commission]=0,0,[Original GST Commission]/[Original Gross Commission])    AS [Credit Note Issued GST Commission]
        ,[Credit Note Issued Commission]
        -[Credit Note Issued Commission]    * IIF([Original Gross Commission]=0,0,[Original SD Commission] /[Original Gross Commission])
        -[Credit Note Issued Commission]    * IIF([Original Gross Commission]=0,0,[Original GST Commission]/[Original Gross Commission])    AS [Credit Note Issued Net Commission]

        ,[Credit Note Expired Amount]
        ,[Credit Note Expired Amount]       * IIF([Expired Gross Amount]=0,0,[Expired SD Amount] /[Expired Gross Amount])   AS [Credit Note Expired SD Amount]
        ,[Credit Note Expired Amount]       * IIF([Expired Gross Amount]=0,0,[Expired GST Amount]/[Expired Gross Amount])   AS [Credit Note Expired GST Amount]
        ,[Credit Note Expired Amount]
        -[Credit Note Expired Amount]       * IIF([Expired Gross Amount]=0,0,[Expired SD Amount] /[Expired Gross Amount])
        -[Credit Note Expired Amount]       * IIF([Expired Gross Amount]=0,0,[Expired GST Amount]/[Expired Gross Amount])   AS [Credit Note Expired Net Amount]
        ,[Credit Note Expired Commission]
        ,[Credit Note Expired Commission]   * IIF([Expired Gross Commission]=0,0,[Expired SD Commission] /[Expired Gross Commission])   AS [Credit Note Expired SD Commission]
        ,[Credit Note Expired Commission]   * IIF([Expired Gross Commission]=0,0,[Expired GST Commission]/[Expired Gross Commission])   AS [Credit Note Expired GST Commission]
        ,[Credit Note Expired Commission]
        -[Credit Note Expired Commission]   * IIF([Expired Gross Commission]=0,0,[Expired SD Commission] /[Expired Gross Commission])
        -[Credit Note Expired Commission]   * IIF([Expired Gross Commission]=0,0,[Expired GST Commission]/[Expired Gross Commission])   AS [Credit Note Expired Net Commission]

        ,[Credit Note Redeemed Amount]
        ,[Credit Note Redeemed Amount]      * IIF([Redeemed Gross Amount]=0,0,[Redeemed SD Amount] /[Redeemed Gross Amount])    AS [Credit Note Redeemed SD Amount]
        ,[Credit Note Redeemed Amount]      * IIF([Redeemed Gross Amount]=0,0,[Redeemed GST Amount]/[Redeemed Gross Amount])    AS [Credit Note Redeemed GST Amount]
        ,[Credit Note Redeemed Amount]
        -[Credit Note Redeemed Amount]      * IIF([Redeemed Gross Amount]=0,0,[Redeemed SD Amount] /[Redeemed Gross Amount])
        -[Credit Note Redeemed Amount]      * IIF([Redeemed Gross Amount]=0,0,[Redeemed GST Amount]/[Redeemed Gross Amount])    AS [Credit Note Redeemed Net Amount]
        ,[Credit Note Redeemed Commission]
        ,[Credit Note Redeemed Commission]  * IIF([Redeemed Gross Commission]=0,0,[Redeemed SD Commission] /[Redeemed Gross Commission])    AS [Credit Note Redeemed SD Commission]
        ,[Credit Note Redeemed Commission]  * IIF([Redeemed Gross Commission]=0,0,[Redeemed GST Commission]/[Redeemed Gross Commission])    AS [Credit Note Redeemed GST Commission]
        ,[Credit Note Redeemed Commission]
        -[Credit Note Redeemed Commission]  * IIF([Redeemed Gross Commission]=0,0,[Redeemed SD Commission] /[Redeemed Gross Commission])
        -[Credit Note Redeemed Commission]  * IIF([Redeemed Gross Commission]=0,0,[Redeemed GST Commission]/[Redeemed Gross Commission])    AS [Credit Note Redeemed Net Commission]

        ,[Credit Note Refunded Amount]
        ,[Credit Note Refunded Amount]      * IIF([Refunded Gross Amount]=0,0,[Refunded SD Amount] /[Refunded Gross Amount])   AS [Credit Note Refunded SD Amount]
        ,[Credit Note Refunded Amount]      * IIF([Refunded Gross Amount]=0,0,[Refunded GST Amount]/[Refunded Gross Amount])   AS [Credit Note Refunded GST Amount]
        ,[Credit Note Refunded Amount]
        -[Credit Note Refunded Amount]      * IIF([Refunded Gross Amount]=0,0,[Refunded SD Amount] /[Refunded Gross Amount])
        -[Credit Note Refunded Amount]      * IIF([Refunded Gross Amount]=0,0,[Refunded GST Amount]/[Refunded Gross Amount])   AS [Credit Note Refunded Net Amount]
        ,[Credit Note Refunded Commission]
        ,[Credit Note Refunded Commission]  * IIF([Refunded Gross Commission]=0,0,[Refunded SD Commission] /[Refunded Gross Commission])   AS [Credit Note Refunded SD Commission]
        ,[Credit Note Refunded Commission]  * IIF([Refunded Gross Commission]=0,0,[Refunded GST Commission]/[Refunded Gross Commission])   AS [Credit Note Refunded GST Commission]
        ,[Credit Note Refunded Commission]
        -[Credit Note Refunded Commission]  * IIF([Refunded Gross Commission]=0,0,[Refunded SD Commission] /[Refunded Gross Commission])
        -[Credit Note Refunded Commission]  * IIF([Refunded Gross Commission]=0,0,[Refunded GST Commission]/[Refunded Gross Commission])   AS [Credit Note Refunded Net Commission]

        , [Original UW Premium]   
        ,-[Expired UW Premium]  AS [Expired UW Premium]
        , [Redeemed UW Premium]
        ,-[Refunded UW Premium] AS [Refunded UW Premium]

        ,[Original Gross Amount]
        ,[Original SD Amount]
        ,[Original GST Amount]
        ,[Original Net Amount]
        ,[Original Gross Commission]
        ,[Original SD Commission]
        ,[Original GST Commission]
        ,[Original Net Commission]

        ,[Expired Gross Amount]
        ,[Expired SD Amount]
        ,[Expired GST Amount]
        ,[Expired Net Amount]
        ,[Expired Gross Commission]
        ,[Expired SD Commission]
        ,[Expired GST Commission]
        ,[Expired Net Commission]

        ,[Redeemed Gross Amount]
        ,[Redeemed SD Amount]
        ,[Redeemed GST Amount]
        ,[Redeemed Net Amount]
        ,[Redeemed Gross Commission]
        ,[Redeemed SD Commission]
        ,[Redeemed GST Commission]
        ,[Redeemed Net Commission]

        ,[Refunded Gross Amount]
        ,[Refunded SD Amount]
        ,[Refunded GST Amount]
        ,[Refunded Net Amount]
        ,[Refunded Gross Commission]
        ,[Refunded SD Commission]
        ,[Refunded GST Commission]
        ,[Refunded Net Commission]

    FROM Credit_Note_06
)

--Calculate balance movement
,Credit_Note_08 AS (
    SELECT
         *

        ,[Credit Note Issued Amount]     + [Credit Note Expired Amount]     + [Credit Note Redeemed Amount]     + [Credit Note Refunded Amount]     AS [Credit Note Balance Amount]
        ,[Credit Note Issued SD Amount]  + [Credit Note Expired SD Amount]  + [Credit Note Redeemed SD Amount]  + [Credit Note Refunded SD Amount]  AS [Credit Note Balance SD Amount]
        ,[Credit Note Issued GST Amount] + [Credit Note Expired GST Amount] + [Credit Note Redeemed GST Amount] + [Credit Note Refunded GST Amount] AS [Credit Note Balance GST Amount]
        ,[Credit Note Issued Net Amount] + [Credit Note Expired Net Amount] + [Credit Note Redeemed Net Amount] + [Credit Note Refunded Net Amount] AS [Credit Note Balance Net Amount]

        ,[Credit Note Issued Commission]     + [Credit Note Expired Commission]     + [Credit Note Redeemed Commission]     + [Credit Note Refunded Commission]     AS [Credit Note Balance Commission]
        ,[Credit Note Issued SD Commission]  + [Credit Note Expired SD Commission]  + [Credit Note Redeemed SD Commission]  + [Credit Note Refunded SD Commission]  AS [Credit Note Balance SD Commission]
        ,[Credit Note Issued GST Commission] + [Credit Note Expired GST Commission] + [Credit Note Redeemed GST Commission] + [Credit Note Refunded GST Commission] AS [Credit Note Balance GST Commission]
        ,[Credit Note Issued Net Commission] + [Credit Note Expired Net Commission] + [Credit Note Redeemed Net Commission] + [Credit Note Refunded Net Commission] AS [Credit Note Balance Net Commission]

        ,[Original UW Premium] + [Expired UW Premium] + [Redeemed UW Premium] + [Refunded UW Premium] AS [Balance UW Premium]

        ,[Original Gross Amount] + [Expired Gross Amount] + [Redeemed Gross Amount] + [Refunded Gross Amount] AS [Balance Gross Amount]
        ,[Original SD Amount]    + [Expired SD Amount]    + [Redeemed SD Amount]    + [Refunded SD Amount]    AS [Balance SD Amount]
        ,[Original GST Amount]   + [Expired GST Amount]   + [Redeemed GST Amount]   + [Refunded GST Amount]   AS [Balance GST Amount]
        ,[Original Net Amount]   + [Expired Net Amount]   + [Redeemed Net Amount]   + [Refunded Net Amount]   AS [Balance Net Amount]

        ,[Original Gross Commission] + [Expired Gross Commission] + [Redeemed Gross Commission] + [Refunded Gross Commission] AS [Balance Gross Commission]
        ,[Original SD Commission]    + [Expired SD Commission]    + [Redeemed SD Commission]    + [Refunded SD Commission]    AS [Balance SD Commission]
        ,[Original GST Commission]   + [Expired GST Commission]   + [Redeemed GST Commission]   + [Refunded GST Commission]   AS [Balance GST Commission]
        ,[Original Net Commission]   + [Expired Net Commission]   + [Redeemed Net Commission]   + [Refunded Net Commission]   AS [Balance Net Commission]

    FROM Credit_Note_07
)

--Calculate balance total
,Credit_Note_09 AS (
    SELECT
         *

        ,SUM([Credit Note Balance Amount]           ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Credit Note Balance Amount Total]
        ,SUM([Credit Note Balance SD Amount]        ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Credit Note Balance SD Amount Total]
        ,SUM([Credit Note Balance GST Amount]       ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Credit Note Balance GST Amount Total]
        ,SUM([Credit Note Balance Net Amount]       ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Credit Note Balance Net Amount Total]

        ,SUM([Credit Note Balance Commission]       ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Credit Note Balance Commission Total]
        ,SUM([Credit Note Balance SD Commission]    ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Credit Note Balance SD Commission Total]
        ,SUM([Credit Note Balance GST Commission]   ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Credit Note Balance GST Commission Total]
        ,SUM([Credit Note Balance Net Commission]   ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Credit Note Balance Net Commission Total]

        ,SUM([Balance UW Premium]                   ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Balance UW Premium Total]

        ,SUM([Balance Gross Amount]                 ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Balance Gross Amount Total]
        ,SUM([Balance SD Amount]                    ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Balance SD Amount Total]
        ,SUM([Balance GST Amount]                   ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Balance GST Amount Total]
        ,SUM([Balance Net Amount]                   ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Balance Net Amount Total]

        ,SUM([Balance Gross Commission]             ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Balance Gross Commission Total]
        ,SUM([Balance SD Commission]                ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Balance SD Commission Total]
        ,SUM([Balance GST Commission]               ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Balance GST Commission Total]
        ,SUM([Balance Net Commission]               ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Balance Net Commission Total]

    FROM Credit_Note_08
)

--Join policy details
,Credit_Note_10 AS (
    SELECT 
         [Country Key]
        ,[Company Key]
        ,[Domain Id]
        ,[Domain Key]

        ,[Credit Note Id]
        ,[Credit Note PolicyKey]
        ,[Credit Note Number]
        ,[Credit Note Issue Date]
        ,[Credit Note Start Date]
        ,[Credit Note Expiry Date]

        ,[Credit Note Transaction Date]
        ,[Credit Note Transaction Month]
        ,[Credit Note Transaction Order]
        ,[Credit Note Status]
        ,[Credit Note Status Fix]
        ,[Credit Note Comments]
        ,[Credit Note Redeemed Status]

        ,[Credit Note Issued Amount]
        ,[Credit Note Issued SD Amount]
        ,[Credit Note Issued GST Amount]
        ,[Credit Note Issued Net Amount]
        ,[Credit Note Issued Commission]
        ,[Credit Note Issued SD Commission]
        ,[Credit Note Issued GST Commission]
        ,[Credit Note Issued Net Commission]

        ,[Credit Note Expired Amount]
        ,[Credit Note Expired SD Amount]
        ,[Credit Note Expired GST Amount]
        ,[Credit Note Expired Net Amount]
        ,[Credit Note Expired Commission]
        ,[Credit Note Expired SD Commission]
        ,[Credit Note Expired GST Commission]
        ,[Credit Note Expired Net Commission]

        ,[Credit Note Redeemed Amount]
        ,[Credit Note Redeemed SD Amount]
        ,[Credit Note Redeemed GST Amount]
        ,[Credit Note Redeemed Net Amount]
        ,[Credit Note Redeemed Commission]
        ,[Credit Note Redeemed SD Commission]
        ,[Credit Note Redeemed GST Commission]
        ,[Credit Note Redeemed Net Commission]

        ,[Credit Note Refunded Amount]
        ,[Credit Note Refunded SD Amount]
        ,[Credit Note Refunded GST Amount]
        ,[Credit Note Refunded Net Amount]
        ,[Credit Note Refunded Commission]
        ,[Credit Note Refunded SD Commission]
        ,[Credit Note Refunded GST Commission]
        ,[Credit Note Refunded Net Commission]

        ,[Credit Note Balance Amount]
        ,[Credit Note Balance SD Amount]
        ,[Credit Note Balance GST Amount]
        ,[Credit Note Balance Net Amount]
        ,[Credit Note Balance Commission]
        ,[Credit Note Balance SD Commission]
        ,[Credit Note Balance GST Commission]
        ,[Credit Note Balance Net Commission]

        ,[Credit Note Balance Amount Total]
        ,[Credit Note Balance SD Amount Total]
        ,[Credit Note Balance GST Amount Total]
        ,[Credit Note Balance Net Amount Total]
        ,[Credit Note Balance Commission Total]
        ,[Credit Note Balance SD Commission Total]
        ,[Credit Note Balance GST Commission Total]
        ,[Credit Note Balance Net Commission Total]

        ,[Original PolicyId]
        ,[Original PolicyKey]
        ,b.[PolicyNumber]               AS [Original PolicyNumber]
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
        ,e1.[AutoComments]              AS [Original Auto Comments]
        ,g.[FirstName]                  AS [Original First Name]
        ,g.[LastName]                   AS [Original Last Name]

        ,[Redeemed PolicyId]
        ,[Redeemed PolicyKey]
        ,c.[PolicyNumber]               AS [Redeemed PolicyNumber]
        ,c.[StatusDescription]          AS [Redeem Policy Status]
        ,c.[ProductCode]                AS [Redeem Product Code]
        ,c.[AlphaCode]                  AS [Redeem Alpha Code]
        ,c.[IssueDate]                  AS [Redeem Issue Date]
        ,j.[OutletName]                 AS [Redeem Outlet Name]
        ,j.[JVCode]                     AS [Redeem JV Code]
        ,j.[JV]                         AS [Redeem JV]
        ,f3.[PaymentMode]               AS [Redeem Payment Mode]
        ,COALESCE(f1.[PolicyNumber]     
                 ,f2.[PolicyNumber])    AS [Redeem Transaction Number]
        ,COALESCE(f1.[IssueTimeUTC]
                 ,f2.[IssueTimeUTC])    AS [Redeem Transaction Date]
        ,COALESCE(f1.[TransactionStatus]
                 ,f2.[TransactionStatus]) 
                                        AS [Redeem Transaction Status]
        ,COALESCE(f1.[AutoComments]
                 ,f2.[AutoComments])    AS [Redeem Auto Comments]
        ,k.[CreditNoteNumber]           AS [Redeem Credit Note Number]
        ,h.[FirstName]                  AS [Redeem First Name]
        ,h.[LastName]                   AS [Redeem Last Name]

        ,[Original UW Premium]
        ,[Original Gross Amount]
        ,[Original SD Amount]
        ,[Original GST Amount]
        ,[Original Net Amount]
        ,[Original Gross Commission]
        ,[Original SD Commission]
        ,[Original GST Commission]
        ,[Original Net Commission]

        ,[Expired UW Premium]
        ,[Expired Gross Amount]
        ,[Expired SD Amount]
        ,[Expired GST Amount]
        ,[Expired Net Amount]
        ,[Expired Gross Commission]
        ,[Expired SD Commission]
        ,[Expired GST Commission]
        ,[Expired Net Commission]

        ,[Redeemed UW Premium]
        ,[Redeemed Gross Amount]
        ,[Redeemed SD Amount]
        ,[Redeemed GST Amount]
        ,[Redeemed Net Amount]
        ,[Redeemed Gross Commission]
        ,[Redeemed SD Commission]
        ,[Redeemed GST Commission]
        ,[Redeemed Net Commission]

        ,[Refunded UW Premium]
        ,[Refunded Gross Amount]
        ,[Refunded SD Amount]
        ,[Refunded GST Amount]
        ,[Refunded Net Amount]
        ,[Refunded Gross Commission]
        ,[Refunded SD Commission]
        ,[Refunded GST Commission]
        ,[Refunded Net Commission]

        ,IIF([Credit Note Balance Amount Total]=0,-[Balance UW Premium Total]      ,0) AS [Additional UW Premium]
        ,IIF([Credit Note Balance Amount Total]=0,-[Balance Gross Amount Total]    ,0) AS [Additional Gross Amount]
        ,IIF([Credit Note Balance Amount Total]=0,-[Balance SD Amount Total]       ,0) AS [Additional SD Amount]
        ,IIF([Credit Note Balance Amount Total]=0,-[Balance GST Amount Total]      ,0) AS [Additional GST Amount]
        ,IIF([Credit Note Balance Amount Total]=0,-[Balance Net Amount Total]      ,0) AS [Additional Net Amount]
        ,IIF([Credit Note Balance Amount Total]=0,-[Balance Gross Commission Total],0) AS [Additional Gross Commission]
        ,IIF([Credit Note Balance Amount Total]=0,-[Balance SD Commission Total]   ,0) AS [Additional SD Commission]
        ,IIF([Credit Note Balance Amount Total]=0,-[Balance GST Commission Total]  ,0) AS [Additional GST Commission]
        ,IIF([Credit Note Balance Amount Total]=0,-[Balance Net Commission Total]  ,0) AS [Additional Net Commission]

        ,IIF([Credit Note Balance Amount Total]=0,[Balance UW Premium]      -[Balance UW Premium Total]      ,[Balance UW Premium])       AS [Balance UW Premium]
        ,IIF([Credit Note Balance Amount Total]=0,[Balance Gross Amount]    -[Balance Gross Amount Total]    ,[Balance Gross Amount])     AS [Balance Gross Amount]
        ,IIF([Credit Note Balance Amount Total]=0,[Balance SD Amount]       -[Balance SD Amount Total]       ,[Balance SD Amount])        AS [Balance SD Amount]
        ,IIF([Credit Note Balance Amount Total]=0,[Balance GST Amount]      -[Balance GST Amount Total]      ,[Balance GST Amount])       AS [Balance GST Amount]
        ,IIF([Credit Note Balance Amount Total]=0,[Balance Net Amount]      -[Balance Net Amount Total]      ,[Balance Net Amount])       AS [Balance Net Amount]
        ,IIF([Credit Note Balance Amount Total]=0,[Balance Gross Commission]-[Balance Gross Commission Total],[Balance Gross Commission]) AS [Balance Gross Commission]
        ,IIF([Credit Note Balance Amount Total]=0,[Balance SD Commission]   -[Balance SD Commission Total]   ,[Balance SD Commission])    AS [Balance SD Commission]
        ,IIF([Credit Note Balance Amount Total]=0,[Balance GST Commission]  -[Balance GST Commission Total]  ,[Balance GST Commission])   AS [Balance GST Commission]
        ,IIF([Credit Note Balance Amount Total]=0,[Balance Net Commission]  -[Balance Net Commission Total]  ,[Balance Net Commission])   AS [Balance Net Commission]

        ,IIF([Credit Note Balance Amount Total]=0,0,[Balance UW Premium Total]      ) AS [Balance UW Premium Total]
        ,IIF([Credit Note Balance Amount Total]=0,0,[Balance Gross Amount Total]    ) AS [Balance Gross Amount Total]
        ,IIF([Credit Note Balance Amount Total]=0,0,[Balance SD Amount Total]       ) AS [Balance SD Amount Total]
        ,IIF([Credit Note Balance Amount Total]=0,0,[Balance GST Amount Total]      ) AS [Balance GST Amount Total]
        ,IIF([Credit Note Balance Amount Total]=0,0,[Balance Net Amount Total]      ) AS [Balance Net Amount Total]
        ,IIF([Credit Note Balance Amount Total]=0,0,[Balance Gross Commission Total]) AS [Balance Gross Commission Total]
        ,IIF([Credit Note Balance Amount Total]=0,0,[Balance SD Commission Total]   ) AS [Balance SD Commission Total]
        ,IIF([Credit Note Balance Amount Total]=0,0,[Balance GST Commission Total]  ) AS [Balance GST Commission Total]
        ,IIF([Credit Note Balance Amount Total]=0,0,[Balance Net Commission Total]  ) AS [Balance Net Commission Total]

    FROM      Credit_Note_09 a
    LEFT JOIN [uldwh02].[db-au-cmdwh].[dbo].[penPolicy] b WITH(NOLOCK) ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = b.[PolicyKey]
    LEFT JOIN [uldwh02].[db-au-cmdwh].[dbo].[penPolicy] c WITH(NOLOCK) ON a.[Redeemed PolicyKey] COLLATE Latin1_General_CI_AS = c.[PolicyKey]
    OUTER APPLY (
               SELECT TOP 1 * 
               FROM [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] e1 WITH(NOLOCK)
               WHERE e1.[TransactionType] = 'Base' AND 
                    (CAST(a.[Credit Note Issue Date] as date) = CAST(e1.[IssueTimeUTC] as date) OR CAST(a.[Credit Note Issue Date] as date) = CAST(e1.[IssueTime] as date)) AND
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
                    (CAST(a.[Credit Note Transaction Date] as date) = CAST(f1.[IssueTimeUTC] as date) OR CAST(a.[Credit Note Transaction Date] as date) = CAST(f1.[IssueTime] as date)) AND
                     COALESCE(a.[Credit Note Redeemed Amount],0) > 0 AND
                     c.[PolicyKey] = f1.[PolicyKey]
               ORDER BY f1.[IssueTimeUTC] DESC
               ) f1
    OUTER APPLY (
               SELECT TOP 1 * 
               FROM [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTransSummary] f2 WITH(NOLOCK)
               WHERE f2.[TransactionType] = 'Base' AND 
                     f2.[TransactionStatus] <> 'Active' AND
                    (CAST(a.[Credit Note Transaction Date] as date) = CAST(f2.[IssueTimeUTC] as date) OR CAST(a.[Credit Note Transaction Date] as date) = CAST(f2.[IssueTime] as date)) AND
                     COALESCE(a.[Credit Note Redeemed Amount],0) < 0 AND
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
    LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTraveller]  g WITH(NOLOCK) ON b.[PolicyKey]      = g.[PolicyKey]      AND g.[isPrimary] = 1
    LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penPolicyTraveller]  h WITH(NOLOCK) ON c.[PolicyKey]      = h.[PolicyKey]      AND h.[isPrimary] = 1
    LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penOutlet]           i WITH(NOLOCK) ON b.[OutletAlphaKey] = i.[OutletAlphaKey] AND i.[OutletStatus] = 'Current'
    LEFT JOIN [ULDWH02].[db-au-cmdwh].[dbo].[penOutlet]           j WITH(NOLOCK) ON c.[OutletAlphaKey] = j.[OutletAlphaKey] AND j.[OutletStatus] = 'Current'
    LEFT JOIN ( SELECT DISTINCT [OriginalPolicyId],[CreditNoteNumber]
                FROM Credit_Note_01 WITH(NOLOCK)) k ON a.[Redeemed PolicyId] = k.[OriginalPolicyId] 
)

SELECT TOP 1000000 *
FROM Credit_Note_10
ORDER BY [Credit Note Issue Date],[Credit Note Number],[Credit Note Transaction Order]
;
GO
