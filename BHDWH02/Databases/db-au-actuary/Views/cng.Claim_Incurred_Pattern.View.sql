USE [db-au-actuary]
GO
/****** Object:  View [cng].[Claim_Incurred_Pattern]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Claim_Incurred_Pattern] AS 

WITH 
chdr AS (
    SELECT 
         [DomainCountry]

        ,CASE WHEN [TripType] = 'Single Trip'  THEN 'Single Trip'
              WHEN [TripType] = 'Cancellation' THEN 'Cancellation'
                                               ELSE 'AMT'
         END AS [TripType]
        ,CASE WHEN [TripType] = 'Single Trip' AND [PlanType] = 'Domestic' THEN 'Domestic'
              WHEN [TripType] = 'Single Trip'                             THEN 'International'
                                                                          ELSE 'Total'
         END AS [PlanType]

        ,CASE WHEN [LeadTime%]<1 AND [TripType] <> 'Cancellation'
              THEN CEILING([LeadTime%]*10) 
              ELSE 10 
         END AS [LeadTimeGroup]

        ,CASE WHEN [ActuarialBenefitGroup] NOT IN ('Additional Expenses','Cancellation','Medical') 
              THEN 'Other' 
              ELSE [ActuarialBenefitGroup]
         END AS [ActuarialBenefitGroup]

        ,[DaysToLoss%Rescale]

        ,[SectionCount]
        ,[NetIncurredMovementIncRecoveries]

    FROM [db-au-actuary].[cng].[Claim_Header_Policy_Time]
    WHERE [ReturnYear] >= 2018 AND 
          [ReturnYear] <= 2022 AND 
          [ActuarialBenefitGroup] IS NOT NULL AND 
          [JV] NOT IN ('BW NAC','CBA NAC') AND 
          [CATCode] NOT IN ('COR','COR1')
),

temp AS (
    SELECT [DomainCountry],[TripType],[PlanType],[LeadTimeGroup],[DaysToLoss%Rescale]
    FROM       (SELECT DISTINCT [DomainCountry],[TripType],[PlanType],[LeadTimeGroup] FROM chdr) a
    CROSS JOIN (SELECT (number*1.00)/100 AS [DaysToLoss%Rescale] FROM [master].[dbo].[spt_values] WHERE type = 'p' AND number < 101) b
),

summary1 AS (
    SELECT 
         [DomainCountry]
        ,[TripType]
        ,[PlanType]
        ,[LeadTimeGroup]
        ,[DaysToLoss%Rescale]
        ,SUM(CASE WHEN [ActuarialBenefitGroup] = 'Additional Expenses' THEN [SectionCount]                     ELSE 0 END) AS [SectionCount ADD]
        ,SUM(CASE WHEN [ActuarialBenefitGroup] = 'Cancellation'        THEN [SectionCount]                     ELSE 0 END) AS [SectionCount CAN]
        ,SUM(CASE WHEN [ActuarialBenefitGroup] = 'Medical'             THEN [SectionCount]                     ELSE 0 END) AS [SectionCount MED]
        ,SUM(CASE WHEN [ActuarialBenefitGroup] = 'Other'               THEN [SectionCount]                     ELSE 0 END) AS [SectionCount MIS]
        ,SUM([SectionCount])                                                                                               AS [SectionCount]
        ,SUM(CASE WHEN [ActuarialBenefitGroup] = 'Additional Expenses' THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [NetIncurred ADD]
        ,SUM(CASE WHEN [ActuarialBenefitGroup] = 'Cancellation'        THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [NetIncurred CAN]
        ,SUM(CASE WHEN [ActuarialBenefitGroup] = 'Medical'             THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [NetIncurred MED]
        ,SUM(CASE WHEN [ActuarialBenefitGroup] = 'Other'               THEN [NetIncurredMovementIncRecoveries] ELSE 0 END) AS [NetIncurred MIS]
        ,SUM([NetIncurredMovementIncRecoveries])                                                                           AS [NetIncurred]
    FROM chdr
    GROUP BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup],[DaysToLoss%Rescale]
),

summary2 AS (
    SELECT 
         a.[DomainCountry]
        ,a.[TripType]
        ,a.[PlanType]
        ,a.[LeadTimeGroup]
        ,a.[DaysToLoss%Rescale]
        ,COALESCE(b.[SectionCount ADD],0) AS [SectionCount ADD]
        ,COALESCE(b.[SectionCount CAN],0) AS [SectionCount CAN]
        ,COALESCE(b.[SectionCount MED],0) AS [SectionCount MED]
        ,COALESCE(b.[SectionCount MIS],0) AS [SectionCount MIS]
        ,COALESCE(b.[SectionCount]    ,0) AS [SectionCount]
        ,COALESCE(b.[NetIncurred ADD] ,0) AS [NetIncurred ADD]
        ,COALESCE(b.[NetIncurred CAN] ,0) AS [NetIncurred CAN]
        ,COALESCE(b.[NetIncurred MED] ,0) AS [NetIncurred MED]
        ,COALESCE(b.[NetIncurred MIS] ,0) AS [NetIncurred MIS]
        ,COALESCE(b.[NetIncurred]     ,0) AS [NetIncurred]
    FROM      temp     a 
    LEFT JOIN summary1 b ON a.[DomainCountry] = b.[DomainCountry] AND a.[TripType] = b.[TripType] AND a.[PlanType] = b.[PlanType] AND a.[LeadTimeGroup] = b.[LeadTimeGroup] AND a.[DaysToLoss%Rescale] = b.[DaysToLoss%Rescale]
),

summary3 AS (
    SELECT 
         [DomainCountry]
        ,[TripType]
        ,[PlanType]
        ,[LeadTimeGroup]
        ,[DaysToLoss%Rescale]
        ,[SectionCount ADD]
        ,[SectionCount CAN]
        ,CASE WHEN [TripType] = 'Cancellation' THEN NULL                                    ELSE [SectionCount MED] END AS [SectionCount MED]
        ,CASE WHEN [TripType] = 'Cancellation' THEN NULL                                    ELSE [SectionCount MIS] END AS [SectionCount MIS]
        ,CASE WHEN [TripType] = 'Cancellation' THEN [SectionCount ADD] + [SectionCount CAN] ELSE [SectionCount]     END AS [SectionCount] 
        ,[NetIncurred ADD]
        ,[NetIncurred CAN]
        ,CASE WHEN [TripType] = 'Cancellation' THEN NULL                                  ELSE [NetIncurred MED] END AS [NetIncurred MED]
        ,CASE WHEN [TripType] = 'Cancellation' THEN NULL                                  ELSE [NetIncurred MIS] END AS [NetIncurred MIS]
        ,CASE WHEN [TripType] = 'Cancellation' THEN [NetIncurred ADD] + [NetIncurred CAN] ELSE [NetIncurred]     END AS [NetIncurred] 
    FROM summary2
)

SELECT TOP 10000
     [DomainCountry]
    ,[TripType]
    ,[PlanType]
    ,[LeadTimeGroup]
    ,[DaysToLoss%Rescale]
    ,SUM([SectionCount ADD]) OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup] ORDER BY [DaysToLoss%Rescale])*1.00/SUM([SectionCount ADD]) OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup]) AS [SectionCount ADD %]
    ,SUM([SectionCount CAN]) OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup] ORDER BY [DaysToLoss%Rescale])*1.00/SUM([SectionCount CAN]) OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup]) AS [SectionCount CAN %]
    ,SUM([SectionCount MED]) OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup] ORDER BY [DaysToLoss%Rescale])*1.00/SUM([SectionCount MED]) OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup]) AS [SectionCount MED %]
    ,SUM([SectionCount MIS]) OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup] ORDER BY [DaysToLoss%Rescale])*1.00/SUM([SectionCount MIS]) OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup]) AS [SectionCount MIS %]
    ,SUM([SectionCount])     OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup] ORDER BY [DaysToLoss%Rescale])*1.00/SUM([SectionCount])     OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup]) AS [SectionCount %]
    ,SUM([NetIncurred ADD])  OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup] ORDER BY [DaysToLoss%Rescale])*1.00/SUM([NetIncurred])      OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup]) AS [NetIncurred ADD %]
    ,SUM([NetIncurred CAN])  OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup] ORDER BY [DaysToLoss%Rescale])*1.00/SUM([NetIncurred])      OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup]) AS [NetIncurred CAN %]
    ,SUM([NetIncurred MED])  OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup] ORDER BY [DaysToLoss%Rescale])*1.00/SUM([NetIncurred])      OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup]) AS [NetIncurred MED %]
    ,SUM([NetIncurred MIS])  OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup] ORDER BY [DaysToLoss%Rescale])*1.00/SUM([NetIncurred])      OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup]) AS [NetIncurred MIS %]
    ,SUM([NetIncurred])      OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup] ORDER BY [DaysToLoss%Rescale])*1.00/SUM([NetIncurred])      OVER (PARTITION BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup]) AS [NetIncurred %]
FROM summary3
ORDER BY [DomainCountry],[TripType],[PlanType],[LeadTimeGroup],[DaysToLoss%Rescale]
;
GO
