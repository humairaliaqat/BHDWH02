USE [db-au-actuary]
GO
/****** Object:  View [cng].[Policy_Month_Issue_v2]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Policy_Month_Issue_v2] AS 

WITH
--months AS (
--    SELECT DATEADD(month,number,'2017-06-01') AS [Month]
--    FROM [master].[dbo].[spt_values]
--    WHERE type = 'p' AND number <= 84
--),

chdr AS (
    SELECT * 
  --FROM [db-au-actuary].[cng].[Claim_Header]
    FROM [db-au-actuary].[cng].[Claim_Header_Table]
),

pattern AS (
    SELECT * 
  --FROM [db-au-actuary].[cng].[Claim_Incurred_Pattern]
    FROM [db-au-actuary].[cng].[Claim_Incurred_Pattern_Table]
),

phdr AS (
    SELECT 
         [PolicyKey]
        ,[Domain Country]
        ,[Policy Status]
        ,[Policy Status Detailed]
        ,[JV Code]
        ,[JV Description]
        ,[Outlet Channel]
        ,[Product Code]
        ,[Plan Code]
        ,[Product Plan]
      --,[Product Group]
        ,IIF([JV Description] IN ('CBA NAC','BW NAC'),'NAC',[Product Group]) AS [Product Group]
        ,IIF([Trip Type] = 'Car Hire',[Trip Type],[Policy Type]) AS [Policy Type]
        ,IIF([Trip Type] = 'Car Hire','Single Trip',[Trip Type]) AS [Trip Type]
        ,CASE WHEN [Trip Type] = 'Single Trip'  THEN 'Single Trip'
              WHEN [Trip Type] = 'Cancellation' THEN 'Cancellation'
                                                ELSE 'AMT'
         END AS [Trip Type 2]
      --,[Plan Type]
        ,CASE WHEN [Domain Country] = 'AU' AND [Plan Type] = 'International' AND [Country or Area] = 'New Zealand' THEN 'Int''l Trans-Tasman'
              WHEN [Domain Country] = 'NZ' AND [Plan Type] = 'International' AND [Country or Area] = 'Australia'   THEN 'Int''l Trans-Tasman'
              ELSE [Plan Type]
         END AS [Plan Type]
        ,CASE WHEN [Trip Type] = 'Single Trip' AND [Plan Type] = 'Domestic' THEN 'Domestic'
              WHEN [Trip Type] = 'Single Trip'                              THEN 'International'
                                                                            ELSE 'Total'
         END AS [Plan Type 2]
        ,CASE WHEN ([Addon Count Cancel For Any Reason] > 0 OR [Gross Premium Cancel For Any Reason] > 0)
              THEN 'Yes'
              ELSE 'No'
         END AS [CFAR Flag]
        ,[Policy Count]
        ,COALESCE([Sell Price - Active]   ,[Sell Price]) AS [Sell Price - Active]
        ,COALESCE([Sell Price - Cancelled],0           ) AS [Sell Price - Cancelled]
        ,COALESCE([Sell Price - Total]    ,[Sell Price]) AS [Sell Price]
        ,COALESCE([Premium - Active]      ,[Premium]   ) AS [Premium - Active]
        ,COALESCE([Premium - Cancelled]   ,0           ) AS [Premium - Cancelled]
        ,COALESCE([Premium - Total]       ,[Premium]   ) AS [Premium]
        ,[Agency Commission]
        ,[NAP]
        ,[GST on Sell Price]
        ,[Stamp Duty on Sell Price]
        ,[GST on Agency Commission]
        ,[Stamp Duty on Agency Commission]
        ,IIF([JV Description] IN ('CBA NAC','BW NAC'),0,[UW Premium]) AS [UW Premium]
		,IIF([JV Description] IN ('CBA NAC','BW NAC'),0,[UW Premium Current]) AS [UW Premium Current]
        ,IIF([JV Description] IN ('CBA NAC','BW NAC'),0,COALESCE([UW Premium COVID19],[UW Premium COVID19 Estimate])) AS [UW Premium COVID19]
        ,[UW Rating Group]
        ,[UW JV Description Orig]
        ,[UW Policy Status]
        ,[Issue Date]
        ,[TripStart]    AS [Departure Date]
        ,[TripEnd]      AS [Return Date]
        ,CASE WHEN DATEDIFF(DAY,[Issue Date],[TripStart]) > 0
              THEN DATEDIFF(DAY,[Issue Date],[TripStart])   
              ELSE 0
         END AS [Lead Time]
        ,CASE WHEN DATEDIFF(DAY,[TripStart],[TripEnd]) + 1 > 0
              THEN DATEDIFF(DAY,[TripStart],[TripEnd]) + 1
              ELSE 0
         END AS [Trip Duration]
  --FROM [db-au-actuary].[cng].[Policy_Header_Works]
    FROM [db-au-actuary].[cng].[Policy_Header_Works_Table]
    WHERE [Domain Country] IN ('AU','NZ') AND 
          CAST([Issue Date] AS date) >= '2017-06-01'
),

pmth_01 AS (
    SELECT 
         phdr.*
        --,CASE WHEN ROUND(ISNULL(CAST([Lead Time] AS float)/NULLIF([Lead Time] + [Trip Duration],0),0),2)<=0 THEN 1
        --      WHEN ROUND(ISNULL(CAST([Lead Time] AS float)/NULLIF([Lead Time] + [Trip Duration],0),0),2)>=1 THEN 5 
        --      ELSE CEILING(ROUND(ISNULL(CAST([Lead Time] AS float)/NULLIF([Lead Time] + [Trip Duration],0),0),2)*5+0.05) 
        -- END AS [Lead Time Group]
        ,CASE WHEN ROUND(ISNULL(CAST([Lead Time] AS float)/NULLIF([Lead Time] + [Trip Duration],0),0),2)<1 AND [Trip Type] <> 'Cancellation'
              THEN CEILING(ROUND(ISNULL(CAST([Lead Time] AS float)/NULLIF([Lead Time] + [Trip Duration],0),0),2)*10) 
              ELSE 10 
         END AS [Lead Time Group]
        --,[Month] AS [Exposure Month]
        --,CASE WHEN [Issue Date] <= [Departure Date] THEN DATEDIFF(month,[Issue Date]    ,[Month])
        --                                            ELSE DATEDIFF(month,[Departure Date],[Month])
        -- END AS [IssueDevelopmentMonth]
        --,CASE WHEN [Issue Date]              > [Departure Date]          THEN 0
        --      WHEN EOMONTH([Issue Date])     = EOMONTH([Month]) AND
        --           EOMONTH([Issue Date])     = EOMONTH([Departure Date]) THEN DATEDIFF(day,[Issue Date],[Departure Date])
        --      WHEN EOMONTH([Issue Date])     = EOMONTH([Month])          THEN DATEDIFF(day,[Issue Date],EOMONTH([Month]))+1
        --      WHEN EOMONTH([Departure Date]) = EOMONTH([Month])          THEN DATEDIFF(day,[Month]     ,[Departure Date])
        --      WHEN [Month] BETWEEN [Issue Date] AND [Departure Date]     THEN DATEDIFF(day,[Month]     ,EOMONTH([Month]))+1
        --                                                                 ELSE 0
        -- END AS [Lead Days]
        --,CASE WHEN EOMONTH([Departure Date]) = EOMONTH([Month]) AND
        --           EOMONTH([Departure Date]) = EOMONTH([Return Date])    THEN DATEDIFF(day,[Departure Date],[Return Date]   )+1
        --      WHEN EOMONTH([Departure Date]) = EOMONTH([Month])          THEN DATEDIFF(day,[Departure Date],EOMONTH([Month]))+1
        --      WHEN EOMONTH([Return Date]   ) = EOMONTH([Month])          THEN DATEDIFF(day,[Month]         ,[Return Date]   )+1
        --      WHEN [Month] BETWEEN [Departure Date] AND [Return Date]    THEN DATEDIFF(day,[Month]         ,EOMONTH([Month]))+1
        --                                                                 ELSE 0
        -- END AS [Trip Days]
      --,DATEDIFF(day,[Issue Date]    ,[Departure Date])   AS [Total Lead Days]
      --,DATEDIFF(day,[Departure Date],[Return Date]   )+1 AS [Total Trip Days]
    --FROM months
    --JOIN phdr ON (CAST([Issue Date]     AS date) <= EOMONTH([Month])  OR 
    --              CAST([Departure Date] AS date) <= EOMONTH([Month])) AND 
    --              CAST([Return Date]    AS date) >= [Month]
    FROM phdr
),

pmth_02 AS (
    SELECT
         *
        --,CASE 
        --    WHEN [Lead Time] > 0             THEN CAST([Lead Days] AS float)/[Lead Time]
        --    WHEN [IssueDevelopmentMonth] = 0 THEN 1
        --                                     ELSE 0
        -- END AS [Lead Days %]
        --,CASE
        --    WHEN [Trip Duration] > 0         THEN CAST([Trip Days] AS float)/[Trip Duration]
        --    WHEN [IssueDevelopmentMonth] = 0 THEN 1
        --                                     ELSE 0
        -- END AS [Trip Days %]
    FROM pmth_01
),

pmth_03 AS (
    SELECT
         *
        --,[Lead Days %] * 0.5 + [Trip Days %] * 0.5                                                                                      AS [Policy Time %]
        --,SUM([Lead Days %])                             OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]) AS [Lead Days % Total]
        --,SUM([Trip Days %])                             OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]) AS [Trip Days % Total]
        --,SUM([Lead Days %] * 0.5 + [Trip Days %] * 0.5) OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]) AS [Policy Time % Total]
    FROM pmth_02
),

pmth_04 AS (
    SELECT 
         a.*
        ,b.[SectionCount ADD %]
        ,b.[SectionCount CAN %]
        ,b.[SectionCount MED %]
        ,b.[SectionCount MIS %]
        ,b.[SectionCount %]
        ,b.[NetIncurred ADD %]
        ,b.[NetIncurred CAN %]
        ,b.[NetIncurred MED %]
        ,b.[NetIncurred MIS %]
        ,b.[NetIncurred %]
    FROM      pmth_03 a
    LEFT JOIN pattern b ON b.[DomainCountry]      = a.[Domain Country]  AND 
                           b.[TripType]           = a.[Trip Type 2]     AND 
                           b.[PlanType]           = a.[Plan Type 2]     AND 
                           b.[LeadTimeGroup]      = a.[Lead Time Group] AND 
                           b.[DaysToLoss%Rescale] = 1 --ROUND(a.[Policy Time % Total],2)
),

pmth_05 AS (
    SELECT
         [PolicyKey]
        ,[Domain Country]
        ,[Policy Status]
        ,[Policy Status Detailed]
        ,[JV Code]
        ,[JV Description]
        ,[Outlet Channel]
        ,[Product Code]
        ,[Plan Code]
        ,[Product Plan]
        ,[Product Group]
        ,[Policy Type]
        ,[Trip Type]
        ,[Plan Type]
        ,[CFAR Flag]
        ,[Policy Count]
        ,[Sell Price - Active]
        ,[Sell Price - Cancelled]
        ,[Sell Price]
        ,[Premium - Active]
        ,[Premium - Cancelled]
        ,[Premium]
        ,[Agency Commission]
        ,[NAP]
        ,[GST on Sell Price]
        ,[Stamp Duty on Sell Price]
        ,[GST on Agency Commission]
        ,[Stamp Duty on Agency Commission]
        ,[UW Premium]
		,[UW Premium Current]
        ,[UW Premium COVID19]
        ,[UW Rating Group]
        ,[UW JV Description Orig]
        ,[UW Policy Status]
        ,CASE WHEN CAST([Issue Date] AS date) >= '2021-01-01'
              THEN [UW Premium] * 0.8800
              ELSE [UW Premium] * 0.9275
         END AS [Target Cost]
        ,CASE WHEN CAST([Issue Date] AS date) >= '2021-01-01'
              THEN [UW Premium COVID19] * 0.8800
              ELSE [UW Premium COVID19] * 0.9275
         END AS [Target Cost COVID19]
        ,[Issue Date]
        ,[Departure Date]
        ,[Return Date]
        --,[Exposure Month]
        --,[IssueDevelopmentMonth]
        ,[Lead Time]
        ,[Trip Duration]
        --,[Lead Days]
        --,[Trip Days]
        --,[Lead Days %]
        --,[Trip Days %]
        --,[Policy Time %]
        --,[Lead Days % Total]
        --,[Trip Days % Total]
        --,[Policy Time % Total]
        --,[SectionCount ADD %] - COALESCE(LAG([SectionCount ADD %]) OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]),0) AS [Earned Policy ADD %]
        --,[SectionCount CAN %] - COALESCE(LAG([SectionCount CAN %]) OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]),0) AS [Earned Policy CAN %]
        --,[SectionCount MED %] - COALESCE(LAG([SectionCount MED %]) OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]),0) AS [Earned Policy MED %]
        --,[SectionCount MIS %] - COALESCE(LAG([SectionCount MIS %]) OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]),0) AS [Earned Policy MIS %]
        --,[SectionCount %]     - COALESCE(LAG([SectionCount %])     OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]),0) AS [Earned Policy %]
        --,[NetIncurred ADD %]  - COALESCE(LAG([NetIncurred ADD %])  OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]),0) AS [Earned Premium ADD %]
        --,[NetIncurred CAN %]  - COALESCE(LAG([NetIncurred CAN %])  OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]),0) AS [Earned Premium CAN %]
        --,[NetIncurred MED %]  - COALESCE(LAG([NetIncurred MED %])  OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]),0) AS [Earned Premium MED %]
        --,[NetIncurred MIS %]  - COALESCE(LAG([NetIncurred MIS %])  OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]),0) AS [Earned Premium MIS %]
        --,[NetIncurred %]      - COALESCE(LAG([NetIncurred %])      OVER (PARTITION BY [PolicyKey],[Product Code] ORDER BY [IssueDevelopmentMonth]),0) AS [Earned Premium %]
        ,[SectionCount ADD %] AS [Earned Policy ADD %]
        ,[SectionCount CAN %] AS [Earned Policy CAN %]
        ,[SectionCount MED %] AS [Earned Policy MED %]
        ,[SectionCount MIS %] AS [Earned Policy MIS %]
        ,[SectionCount %]     AS [Earned Policy %]
        ,[NetIncurred ADD %]  AS [Earned Premium ADD %]
        ,[NetIncurred CAN %]  AS [Earned Premium CAN %]
        ,[NetIncurred MED %]  AS [Earned Premium MED %]
        ,[NetIncurred MIS %]  AS [Earned Premium MIS %]
        ,[NetIncurred %]      AS [Earned Premium %]
        ,1.00                 AS [Refund Premium %]
        ,NULL AS [ClaimKey]
        ,NULL AS [SectionID]
        ,NULL AS [ActuarialBenefitGroup]
        ,NULL AS [Section]
        ,NULL AS [ClaimCount]
        ,NULL AS [SectionCount]
        ,NULL AS [NetPaymentMovementIncRecoveries]
        ,NULL AS [NetIncurredMovementIncRecoveries]
    FROM pmth_04
),

chdr_01 AS (
    SELECT
         a.[PolicyKey]
        ,a.[DomainCountry]    AS [Domain Country]
        ,b.[Policy Status]
        ,b.[Policy Status Detailed]
        ,b.[JV Code]
        ,b.[JV Description]
        ,b.[Outlet Channel]
        ,b.[Product Code]
        ,b.[Plan Code]
        ,b.[Product Plan]
        ,b.[Product Group]
        ,b.[Policy Type]
        ,b.[Trip Type]
        ,b.[Plan Type]
        ,b.[CFAR Flag]
        ,b.[Policy Count]
        ,b.[Sell Price - Active]
        ,b.[Sell Price - Cancelled]
        ,b.[Sell Price]
        ,b.[Premium - Active]
        ,b.[Premium - Cancelled]
        ,b.[Premium]
        ,b.[Agency Commission]
        ,b.[NAP]
        ,b.[GST on Sell Price]
        ,b.[Stamp Duty on Sell Price]
        ,b.[GST on Agency Commission]
        ,b.[Stamp Duty on Agency Commission]
        ,b.[UW Premium]
		,b.[UW Premium Current]
        ,b.[UW Premium COVID19]
        ,b.[UW Rating Group]
        ,b.[UW JV Description Orig]
        ,b.[UW Policy Status]
        ,CASE WHEN CAST(b.[Issue Date] AS date) >= '2021-01-01'
              THEN b.[UW Premium] * 0.8800
              ELSE b.[UW Premium] * 0.9275
         END AS [Target Cost]
        ,CASE WHEN CAST(b.[Issue Date] AS date) >= '2021-01-01'
              THEN b.[UW Premium COVID19] * 0.8800
              ELSE b.[UW Premium COVID19] * 0.9275
         END AS [Target Cost COVID19]
        ,b.[Issue Date]
        ,b.[Departure Date]
        ,b.[Return Date]
        --,a.[LossMonth]      AS [Exposure Month]
        --,CASE WHEN b.[Issue Date] <= b.[Departure Date] 
        --      THEN DATEDIFF(month,b.[Issue Date]    ,a.[LossDate])
        --      ELSE DATEDIFF(month,b.[Departure Date],a.[LossDate])
        -- END AS [IssueDevelopmentMonth]
        ,b.[Lead Time]
        ,b.[Trip Duration]
        --,NULL AS [Lead Days]
        --,NULL AS [Trip Days]
        --,NULL AS [Lead Days %]
        --,NULL AS [Trip Days %]
        --,NULL AS [Policy Time %]
        --,NULL AS [Lead Days % Total]
        --,NULL AS [Trip Days % Total]
        --,NULL AS [Policy Time % Total]
        ,NULL AS [Earned Policy ADD %]
        ,NULL AS [Earned Policy CAN %]
        ,NULL AS [Earned Policy MED %]
        ,NULL AS [Earned Policy MIS %]
        ,NULL AS [Earned Policy %]
        ,NULL AS [Earned Premium ADD %]
        ,NULL AS [Earned Premium CAN %]
        ,NULL AS [Earned Premium MED %]
        ,NULL AS [Earned Premium MIS %]
        ,NULL AS [Earned Premium %]
        ,NULL AS [Refund Premium %]
        ,a.[ClaimKey]
        ,a.[SectionID]
        ,a.[ActuarialBenefitGroup]
        ,a.[Section]
        --,CASE
        --    WHEN [CATCode] NOT IN (' ','CAT','MHC')                                           THEN 'CAT'
        --    WHEN [ActuarialBenefitGroup] = 'Additional Expenses' AND [Size50k] = 'Underlying' THEN 'ADD'
        --    WHEN [ActuarialBenefitGroup] = 'Additional Expenses' AND [Size50k] = 'Large'      THEN 'ADD_LGE'
        --  --WHEN [CFARClaimFlag]         = 1                     AND [Size50k] = 'Underlying' THEN 'CFR'
        --  --WHEN [CFARClaimFlag]         = 1                     AND [Size50k] = 'Large'      THEN 'CFR_LGE'
        --    WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size50k] = 'Underlying' THEN 'CAN'
        --    WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size50k] = 'Large'      THEN 'CAN_LGE'
        --    WHEN [ActuarialBenefitGroup] = 'Luggage'             AND [Size50k] = 'Underlying' THEN 'MIS'
        --    WHEN [ActuarialBenefitGroup] = 'Luggage'             AND [Size50k] = 'Large'      THEN 'MIS_LGE'
        --    WHEN [ActuarialBenefitGroup] = 'Medical'             AND [Size50k] = 'Underlying' THEN 'MED'
        --    WHEN [ActuarialBenefitGroup] = 'Medical'             AND [Size50k] = 'Large'      THEN 'MED_LGE'
        --    WHEN [ActuarialBenefitGroup] = 'Other'               AND [Size50k] = 'Underlying' THEN 'MIS'
        --    WHEN [ActuarialBenefitGroup] = 'Other'               AND [Size50k] = 'Large'      THEN 'MIS_LGE'
        --                                                                                      ELSE 'OTH'
        -- END AS [Section]
        ,a.[ClaimCount]
        ,a.[SectionCount]
        ,a.[NetPaymentMovementIncRecoveries]
        ,a.[NetIncurredMovementIncRecoveries]
    FROM       chdr a
    INNER JOIN phdr b ON a.[PolicyKey] = b.[PolicyKey] AND a.[ProductCode] = b.[Product Code] --a.[JVCode] = b.[JV Code]
)

SELECT * FROM pmth_05
UNION ALL
SELECT * FROM chdr_01
;
GO
