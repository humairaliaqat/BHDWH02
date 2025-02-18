USE [db-au-stage]
GO
/****** Object:  StoredProcedure [dbo].[etlsp_credit_note_balance]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[etlsp_credit_note_balance]      
as      

/*
CHG0036878 - New change Finance Credit Note Report
*/
begin      

    set nocount on      

 --   if object_id('[UW_Premiums_test]') is null      
 --   begin      

 --   CREATE TABLE [UW_Premiums_test](
	--[Rank] [bigint] NULL,
	--[UW_Month] [date] NULL,
	--[PolicyKey] [nvarchar](50) NULL,
	--[UW_Policy_Status] [nvarchar](50) NULL,
	--[UW_Premium] [float] NULL,
	--[UW_Premium_COVID19] [float] NULL,
	--[Previous_Policy_Status] [nvarchar](50) NULL,
	--[Previous_UW_Premium] [float] NULL,
	--[Previous_UW_Premium_COVID19] [float] NULL,
	--[Movement] [float] NULL,
	--[Movement_COVID19] [float] NULL,
	--[Total_Movement] [float] NULL,
	--[Total_Movement_COVID19] [float] NULL,
	--[Domain_Country] [nvarchar](50) NULL,
	--[Issue_Mth] [datetime2](7) NULL,
	--[Rating_Group] [nvarchar](50) NULL,
	--[JV_Description_Orig] [nvarchar](50) NULL,
	--[JV_Group] [nvarchar](50) NULL,
	--[Product_Code] [nvarchar](50) NULL,
	--[UW_Premium_Current] [float] NULL
 --   )    

 --   end      


    if object_id('[UW_Premiums_test]') is not null      
        drop table [UW_Premiums_test]
		
    select * into [UW_Premiums_test]
    from [BHDWH02].[db-au-actuary].[cng].[UW_Premiums]  with(nolock)    

    CREATE CLUSTERED INDEX [idx_UW_Premiums_test_PolicyKeyProductCode_test] ON [UW_Premiums_test] ([PolicyKey],[Product_Code])
    CREATE NONCLUSTERED INDEX [idx_UW_Premiums_test_Movement_test] ON [UW_Premiums_test] ([Movement])  


	if object_id('[db-au-actuary].dbo.tmp_Finance_Credit_Note') is not null      
    drop table [db-au-actuary].dbo.tmp_Finance_Credit_Note

	;WITH 
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
            WHEN [Status] = 'Active'    AND [OriginalPolicyId] IN (SELECT [PolicyID] FROM Refunded_Credit_Notes) /*AND [ExpiryDate] >= GETDATE()*/              THEN 'Refunded'
            WHEN [Status] = 'Expired'   AND [OriginalPolicyId] IN (SELECT [PolicyID] FROM Refunded_Credit_Notes) /*AND [ExpiryDate] >= GETDATE()*/              THEN 'Refunded'
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
--UW premium
,UW_Premium AS (
    SELECT 
         [UW_Month]
        ,[PolicyKey]
        ,SUM([Movement]) AS [UW Premium]
    FROM [db-au-stage].[dbo].[UW_Premiums_test] WITH(NOLOCK) 
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
    FROM      Credit_Note_05     a
    LEFT JOIN UW_Premium         w1 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = w1.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Issued')                             AND CAST(EOMONTH(a.[Credit Note Issue Date], 0)        as date) = CAST(w1
.[UW_Month] as date) AND w1.[UW Premium] <= 0
    LEFT JOIN UW_Premium         w2 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = w2.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Issued')                             AND CAST(EOMONTH(a.[Credit Note Issue Date], 1)        as date) = CAST(w2.
[UW_Month] as date) AND w2.[UW Premium] <= 0
    LEFT JOIN UW_Premium         w3 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = w3.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Issued')                             AND CAST(EOMONTH(a.[Credit Note Issue Date],-1)        as date) = CAST(w3.
[UW_Month] as date) AND w3.[UW Premium] <= 0
    LEFT JOIN UW_Premium         x1 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = x1.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Expired')                            AND CAST(EOMONTH(a.[Credit Note Issue Date], 0)        as date) = CAST(x1.
[UW_Month] as date) AND x1.[UW Premium] <= 0
    LEFT JOIN UW_Premium         x2 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = x2.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Expired')                            AND CAST(EOMONTH(a.[Credit Note Issue Date], 1)        as date) = CAST(x2.
[UW_Month] as date) AND x2.[UW Premium] <= 0
    LEFT JOIN UW_Premium         x3 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = x3.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Expired')                            AND CAST(EOMONTH(a.[Credit Note Issue Date],-1)        as date) = CAST(x3.
[UW_Month] as date) AND x3.[UW Premium] <= 0
    LEFT JOIN UW_Premium         y1 ON a.[Redeemed PolicyKey] COLLATE Latin1_General_CI_AS = y1.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Redeemed_Within','Redeemed_Outside') AND CAST(EOMONTH(a.[Credit Note Transaction Month], 0) as date) = CAST(y1.
[UW_Month] as date) AND y1.[UW Premium] >= 0
    LEFT JOIN UW_Premium  y2 ON a.[Redeemed PolicyKey] COLLATE Latin1_General_CI_AS = y2.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Redeemed_Within','Redeemed_Outside') AND CAST(EOMONTH(a.[Credit Note Transaction Month], 1) as date) = 
	CAST(y2.[UW_Month] as date) AND y2.[UW Premium] >= 0
    LEFT JOIN UW_Premium         y3 ON a.[Redeemed PolicyKey] COLLATE Latin1_General_CI_AS = y3.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Redeemed_Within','Redeemed_Outside') AND CAST(EOMONTH(a.[Credit Note Transaction Month],-1) as date) = CAST(y3.
[UW_Month] as date) AND y3.[UW Premium] >= 0
    LEFT JOIN UW_Premium         z1 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = z1.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Refunded')                           AND CAST(EOMONTH(a.[Credit Note Issue Date], 0)        as date) = CAST(z1.
[UW_Month] as date) AND z1.[UW Premium] <= 0
    LEFT JOIN UW_Premium         z2 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = z2.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Refunded')                           AND CAST(EOMONTH(a.[Credit Note Issue Date], 1)        as date) = CAST(z2.
[UW_Month] as date) AND z2.[UW Premium] <= 0
    LEFT JOIN UW_Premium         z3 ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = z3.[PolicyKey] AND a.[Credit Note Status Fix] IN ('Refunded')                           AND CAST(EOMONTH(a.[Credit Note Issue Date],-1)        as date) = CAST(z3.
[UW_Month] as date) AND z3.[UW Premium] <= 0
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
        ,[Credit Note Expired Amount]
        ,[Credit Note Redeemed Amount]
        ,[Credit Note Refunded Amount]
        ,[Credit Note Issued Commission]
        ,[Credit Note Expired Commission]
        ,[Credit Note Redeemed Commission]
        ,[Credit Note Refunded Commission]
        , [Original UW Premium]   
        ,-[Expired UW Premium]  AS [Expired UW Premium]
        , [Redeemed UW Premium]
        ,-[Refunded UW Premium] AS [Refunded UW Premium]
    FROM Credit_Note_06
)

--Calculate balance movement
,Credit_Note_08 AS (
    SELECT
         *
        ,[Credit Note Issued Amount]     + [Credit Note Expired Amount]     + [Credit Note Redeemed Amount]     + [Credit Note Refunded Amount]     AS [Credit Note Balance Amount]
        ,[Credit Note Issued Commission]     + [Credit Note Expired Commission]     + [Credit Note Redeemed Commission]     + [Credit Note Refunded Commission]     AS [Credit Note Balance Commission]
        ,[Original UW Premium] + [Expired UW Premium] + [Redeemed UW Premium] + [Refunded UW Premium] AS [Balance UW Premium]
    FROM Credit_Note_07
)

--Calculate balance total
,Credit_Note_09 AS (
    SELECT
         *
        ,SUM([Credit Note Balance Amount]           ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Credit Note Balance Amount Total]
        ,SUM([Credit Note Balance Commission]       ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Credit Note Balance Commission Total]
        ,SUM([Balance UW Premium]                   ) OVER (PARTITION BY [Credit Note Number] ORDER BY [Credit Note Transaction Order]) AS [Balance UW Premium Total]
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
        ,IIF([Credit Note Status Fix]='Expired' AND [Credit Note Status]='Active',[Credit Note Expiry Date],[Credit Note Transaction Date]) AS [Credit Note Transaction Date]
        ,IIF([Credit Note Status Fix]='Expired' AND [Credit Note Status]='Active',EOMONTH([Credit Note Expiry Date]),[Credit Note Transaction Month]) AS [Credit Note Transaction Month]
        ,[Credit Note Transaction Order]
        ,[Credit Note Status]
        ,[Credit Note Status Fix]
        ,[Credit Note Comments]
        ,[Credit Note Redeemed Status]
        ,[Credit Note Issued Amount]
        ,[Credit Note Issued Commission]
        ,[Credit Note Expired Amount]
        ,[Credit Note Expired Commission]
        ,[Credit Note Redeemed Amount]
        ,[Credit Note Redeemed Commission]
        ,[Credit Note Refunded Amount]
        ,[Credit Note Refunded Commission]
        ,[Credit Note Balance Amount]
        ,[Credit Note Balance Commission]
        ,[Credit Note Balance Amount Total]
        ,[Credit Note Balance Commission Total]
        ,[Original PolicyId]
        ,[Original PolicyKey]
        ,b.[PolicyNumber] AS [Original PolicyNumber]
        ,b.[IssueDate] AS [Original Issue Date]
        ,d.[JV] AS [Original JV]
        ,d.[JVCode] AS [Original JV Code]
        ,[Redeemed PolicyId]
        ,[Redeemed PolicyKey]
        ,c.[PolicyNumber] AS [Redeemed PolicyNumber]
        ,c.[IssueDate] AS [Redeemed Issue Date]
        ,e.[JV] AS [Redeemed JV]
        ,e.[JVCode] AS [Redeemed JV Code]
        ,[Original UW Premium]
        ,[Expired UW Premium]
        ,[Redeemed UW Premium]
        ,[Refunded UW Premium]
        ,IIF([Credit Note Balance Amount Total]=0,-[Balance UW Premium Total]      ,0) AS [Additional UW Premium]
        ,IIF([Credit Note Balance Amount Total]=0,[Balance UW Premium]      -[Balance UW Premium Total]      ,[Balance UW Premium])       AS [Balance UW Premium]
        ,IIF([Credit Note Balance Amount Total]=0,0,[Balance UW Premium Total]      ) AS [Balance UW Premium Total]
    FROM      Credit_Note_09 a
    LEFT JOIN [uldwh02].[db-au-cmdwh].[dbo].[penPolicy] b WITH(NOLOCK) ON a.[Original PolicyKey] COLLATE Latin1_General_CI_AS = b.[PolicyKey]
    LEFT JOIN [uldwh02].[db-au-cmdwh].[dbo].[penPolicy] c WITH(NOLOCK) ON a.[Redeemed PolicyKey] COLLATE Latin1_General_CI_AS = c.[PolicyKey]
    LEFT JOIN [uldwh02].[db-au-cmdwh].[dbo].[penOutlet] d ON b.[OutletSKey] = d.[OutletSKey]
    LEFT JOIN [uldwh02].[db-au-cmdwh].[dbo].[penOutlet] e ON c.[OutletSKey] = e.[OutletSKey]
)

SELECT TOP 1000000 *
into [db-au-actuary].dbo.tmp_Finance_Credit_Note
FROM Credit_Note_10
ORDER BY [Credit Note Issue Date],[Credit Note Number],[Credit Note Transaction Order]
;

select * from [db-au-actuary].dbo.tmp_Finance_Credit_Note

end 
GO
