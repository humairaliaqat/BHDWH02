USE [db-au-actuary]
GO
/****** Object:  View [cng].[Claim_Header]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [cng].[Claim_Header] AS

WITH 
ClaimDataSet AS (
    SELECT * FROM [db-au-actuary].[cng].[ClaimDataSet]

  --SELECT * FROM [db-au-actuary].[dataout].[out_ClaimDataSet_20200926_Zurich]
  --UNION ALL
  --SELECT * FROM [db-au-actuary].[dataout].[out_Claim_20200926_Zurich_CBA]
),

clmEvent AS (
    SELECT * FROM [db-au-actuary].[cng].[clmEvent]
),

catcode AS (
  --SELECT [CountryKey]
  --      ,[CatastropheCode]
  --      ,[CatastropheShortDesc]
  --      ,[CatastropheLongDesc]
  --      ,ROW_NUMBER() OVER (PARTITION BY [CountryKey],[CatastropheCode] ORDER BY COUNT(*) DESC) AS [Rank]
  --FROM [db-au-actuary].[cng].[clmEvent]
  --GROUP BY [CountryKey],[CatastropheCode],[CatastropheShortDesc],[CatastropheLongDesc]

    SELECT 
         [CountryCode] collate SQL_Latin1_General_CP1_CI_AS AS [CountryKey]
        ,[KC_CODE]     collate SQL_Latin1_General_CP1_CI_AS AS [CatastropheCode]
        ,[KCSHORT]     collate SQL_Latin1_General_CP1_CI_AS AS [CatastropheShortDesc]
        ,[KCLONG]      collate SQL_Latin1_General_CP1_CI_AS AS [CatastropheLongDesc]
        ,1                                                  AS [Rank]
    FROM [db-au-actuary].[cng].[KLCatas]
),

perilcode AS (
    SELECT [CountryKey] 
          ,[PerilCode]
          ,[PerilDesc]
          ,ROW_NUMBER() OVER (PARTITION BY [CountryKey],[PerilCode] ORDER BY COUNT(*) DESC) AS [Rank]
    FROM [db-au-actuary].[cng].[clmEvent]
    GROUP BY [CountryKey],[PerilCode],[PerilDesc]
),

section AS (
    SELECT *
    FROM [db-au-actuary]. [cng].[clmSection]
),

ctrn AS (
    SELECT 
         ROW_NUMBER() OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID] ORDER BY [IncurredTime] DESC) AS [Rank]

        ,[Domain Country] AS [DomainCountry]
        ,[Company]
        ,[OutletKey]
        ,[PolicyKey]
        ,[BasePolicyNo]
        ,a.[ClaimKey]
        ,a.[ClaimNo]
        ,a.[EventID]
        ,[SectionID]
        ,[CustomerCareID]

        ,[StatusAtEndOfDay]
        ,[StatusAtEndOfMonth]
        ,[AssessmentOutcome]

        ,[EventDescription]
        ,a.[EventCountryCode]
        ,a.[EventCountryName]
        ,[EventSubContinent]
        ,[EventContinent]
        ,b.[CatastropheCode] AS [CATCodeOrg]
        ,CASE WHEN b.[CatastropheCode] NOT IN ('','CAT') THEN b.[CatastropheCode]
              WHEN ((LOWER([EventDescription]) LIKE '%coron%' AND LOWER([EventDescription]) LIKE '%virus%') OR 
                     LOWER([EventDescription]) LIKE '%covid%' OR
                     LOWER([EventDescription]) LIKE '%pcr%'   OR
                     LOWER([EventDescription]) LIKE '%c19%' )
                   AND [LossDate] >= '2020-01-01' THEN 'COR1'
              ELSE b.[CatastropheCode]
         END AS [CATCode]
        ,c.[CatastropheShortDesc]
        ,c.[CatastropheLongDesc]
        ,a.[PerilCode]
        ,d.[PerilDesc]
        ,a.[SectionCode]
        ,e.[SectionDescription]
        ,e.[BenefitLimit]
        ,[BenefitSectionKey]
        ,[BenefitCategory]
        ,[ActuarialBenefitGroup]

        ,CAST([IssueQuarter]    AS date) AS [IssueQuarter]
        ,CAST([LossQuarter]     AS date) AS [LossQuarter]
        ,CAST([ReceiptQuarter]  AS date) AS [ReceiptQuarter]
        ,CAST([RegisterQuarter] AS date) AS [RegisterQuarter]
        ,CAST([SectionQuarter]  AS date) AS [SectionQuarter]
        ,CAST([IncurredQuarter] AS date) AS [IncurredQuarter]

        ,[IssueMonth]
        ,[LossMonth]
        ,[ReceiptMonth]
        ,[RegisterMonth]
        ,[SectionMonth]
        ,[IncurredMonth]

        ,[IssueDate]
        ,[LossDate]
        ,[ReceiptDate]
        ,[RegisterDate]
        ,[SectionDate]
        ,[IncurredDate]
        ,[IncurredTime]

        ,[IncurredAgeBand]
        --,[IssueDevelopmentMonth]
        --,[LossDevelopmentMonth]
        --,[ReceiptDevelopmentMonth]
        --,[IssueDevelopmentQuarter]
        --,[LossDevelopmentQuarter]
        --,[ReceiptDevelopmentQuarter]

        ,[OnlineClaimFlag]              AS [OnlineClaimFlag]
        ,[MedicalAssistanceClaimFlag]   AS [MedicalAssistanceClaimFlag]
        ,[ClaimMentalHealthFlag]        AS [MentalHealthClaimFlag]
        ,[ClaimLuggageFlag]             AS [LuggageClaimFlag]
        ,[ClaimElectronicsFlag]         AS [ElectronicsClaimFlag]
        ,[ClaimCruiseFlag]              AS [CruiseClaimFlag]
        ,[ClaimMopedFlag]               AS [MopedClaimFlag]
        ,[ClaimRentalCarFlag]           AS [RentalCarClaimFlag]
        ,[ClaimWinterSportFlag]         AS [WinterSportClaimFlag]
        ,[ClaimCrimeVictimFlag]         AS [CrimeVictimClaimFlag]
        ,[ClaimFoodPoisoningFlag]       AS [FoodPoisoningClaimFlag]
        ,[ClaimAnimalFlag]              AS [AnimalClaimFlag]

        --,[BIRowID]
        --,[PaymentID]
        --,[LocalCurrencyCode]
        --,[ExposureCurrencyCode]
        --,[OriginalCurrencyCode]
        --,[OriginalFXRate]
        --,[ForeignCurrencyCode]
        --,[ForeignCurrencyRate]
        --,[ForeignCurrencyRateDate]
        --,[USDRate]

        --,[SectionCount]
        ,SUM([SectionCount]) OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [SectionCount]

        --,[NetPaymentMovementIncRecoveries],[NetIncurredMovementIncRecoveries]
        ,SUM([NetPaymentMovementIncRecoveries])  OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [NetPaymentMovementIncRecoveries]
        ,SUM([NetIncurredMovementIncRecoveries]) OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [NetIncurredMovementIncRecoveries]

        --,[EstimateMovement],[PaymentMovement],[RecoveryMovement],[IncurredMovement]
        ,SUM([EstimateMovement]) OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [EstimateMovement]
        ,SUM([PaymentMovement])  OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [PaymentMovement]
        ,SUM([RecoveryMovement]) OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [RecoveryMovement]
        ,SUM([IncurredMovement]) OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [IncurredMovement]
        --,[EstimateAsAt],[PaymentAsAt],[RecoveryAsAt],[IncurredAsAt]

        --,[NetPaymentMovement],[NetRecoveryMovement],[NetIncurredMovement],[NetRealRecoveryMovement],[NetApprovedPaymentMovement]
        ,SUM([NetPaymentMovement])         OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [NetPaymentMovement]
        ,SUM([NetRecoveryMovement])        OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [NetRecoveryMovement]
        ,SUM([NetIncurredMovement])        OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [NetIncurredMovement]
        ,SUM([NetRealRecoveryMovement])    OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [NetRealRecoveryMovement]
        ,SUM([NetApprovedPaymentMovement]) OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [NetApprovedPaymentMovement]
        --,[NetPaymentAsAt],[NetRecoveryAsAt],[NetIncurredAsAt],[NetRealRecoveryAsAt],[NetApprovedPaymentAsAt]

        ,[IncurredAtReference]
        ,[NetIncurredAtReference]
        ,[IncurredAtEOM]
        ,[NetIncurredAtEOM]
        ,[MaxIncurredEOM]
        ,[MaxNetIncurredEOM]
    
        --,[IncurredACS]
        ,[SizeAsAt]
        ,[Size500]
        ,[Size1k]
        ,[Size5k]
        ,[Size10k]
        ,[Size25k]
        ,[Size35k]
        ,[Size50k]
        ,[Size75k]
        ,[Size100k]

        ,[FXReferenceDate]
        --,[FXReferenceRate]
        --,[USDRateReference]
        --,[UsedFXCode]
        --,[UsedFXRateThen]
        --,[UsedFXRateNow]
        --,[FXConversion]

        --,[EstimateMovement_FX],[PaymentMovement_FX],[RecoveryMovement_FX],[IncurredMovement_FX]
        ,SUM([EstimateMovement_FX]) OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [EstimateMovement_FX]
        ,SUM([PaymentMovement_FX])  OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [PaymentMovement_FX]
        ,SUM([RecoveryMovement_FX]) OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [RecoveryMovement_FX]
        ,SUM([IncurredMovement_FX]) OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [IncurredMovement_FX]
        --,[EstimateAsAt_FX],[PaymentAsAt_FX],[RecoveryAsAt_FX],[IncurredAsAt_FX]

        --,[NetPaymentMovement_FX],[NetRecoveryMovement_FX],[NetIncurredMovement_FX],[NetRealRecoveryMovement_FX],[NetApprovedPaymentMovement_FX]
        ,SUM([NetPaymentMovement_FX])         OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [NetPaymentMovement_FX]
        ,SUM([NetRecoveryMovement_FX])        OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [NetRecoveryMovement_FX]
        ,SUM([NetIncurredMovement_FX])        OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [NetIncurredMovement_FX]
        ,SUM([NetRealRecoveryMovment_FX])     OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [NetRealRecoveryMovement_FX]
        ,SUM([NetApprovedPaymentMovement_FX]) OVER (PARTITION BY [Domain Country],a.[ClaimKey],[SectionID]) AS [NetApprovedPaymentMovement_FX]
        --,[NetPaymentAsAt_FX],[NetRecoveryAsAt_FX],[NetIncurredAsAt_FX],[NetRealRecoveryAsAt_FX],[NetApprovedPaymentAsAt_FX]

        ,[Underwriter]
        ,[PurchasePathGroup]
        ,[Channel]
        ,[Distributor]
        ,[AlphaCode]
        ,[GroupName]
        ,[JVCode]
        ,[JV]
        ,[ProductCode]

        ,[AreaType]
        ,[AreaName]
        ,[Destination]  
            
        ,[DepartureDate]
        ,[ReturnDate]

        ,[LeadTime]
        ,[LeadTimeBand]
        ,[LeadTimeGroup]

        ,[CancellationFlag]
        ,[CancellationCover]
        ,[CancellationCoverBand]

        ,[EMCFlag]
        ,[MaxEMCScore]
        ,[TotalEMCScore]

        ,[CruiseFlag]
        ,[ElectronicsFlag]
        ,[LuggageFlag]
        ,[MotorcycleFlag]
        ,[RentalCarFlag]
        ,[WinterSportFlag]

        --,[NumberOfRecords]

    FROM      ClaimDataSet  a
    LEFT JOIN clmEvent      b ON a.[ClaimKey] = b.[ClaimKey] AND a.[EventID] = b.[EventID]
    LEFT JOIN catcode       c ON a.[Domain Country] = c.[CountryKey] AND a.[CATCode]   = c.[CatastropheCode] AND c.[Rank] = 1
    LEFT JOIN perilcode     d ON a.[Domain Country] = d.[CountryKey] AND a.[PerilCode] = d.[PerilCode]       AND d.[Rank] = 1
    LEFT JOIN section       e ON CONCAT(a.[Domain Country],'-',a.[ClaimNo],'-',a.[EventID],'-',a.[SectionID]) = e.[SectionKey]
)

SELECT 
     *
    ,CASE
        WHEN [CATCode]     IN ('COR','COR1') AND CAST([IssueDate] as date)<= '2020-11-30' THEN 'CAT'
        WHEN [CATCode]     IN ('COR','COR1') AND CAST([IssueDate] as date)>= '2020-12-01'
                                             AND CAST([IssueDate] as date)<= '2023-06-30' THEN 'COV'
        WHEN [CATCode] NOT IN ('COR','COR1','CAT','CO1','MHC',' ')                        THEN 'CAT'
        WHEN [ActuarialBenefitGroup] = 'Additional Expenses' AND [Size50k] = 'Underlying' THEN 'ADD'
        WHEN [ActuarialBenefitGroup] = 'Additional Expenses' AND [Size50k] = 'Large'      THEN 'ADD_LGE'
      --WHEN [CFARClaimFlag]         = 1                     AND [Size50k] = 'Underlying' THEN 'CFR'
      --WHEN [CFARClaimFlag]         = 1                     AND [Size50k] = 'Large'      THEN 'CFR_LGE'
        WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size50k] = 'Underlying' THEN 'CAN'
        WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size50k] = 'Large'      THEN 'CAN_LGE'
        WHEN [ActuarialBenefitGroup] = 'Luggage'             AND [Size50k] = 'Underlying' THEN 'MIS'
        WHEN [ActuarialBenefitGroup] = 'Luggage'             AND [Size50k] = 'Large'      THEN 'MIS_LGE'
        WHEN [ActuarialBenefitGroup] = 'Medical'             AND [Size50k] = 'Underlying' THEN 'MED'
        WHEN [ActuarialBenefitGroup] = 'Medical'             AND [Size50k] = 'Large'      THEN 'MED_LGE'
        WHEN [ActuarialBenefitGroup] = 'Other'               AND [Size50k] = 'Underlying' THEN 'MIS'
        WHEN [ActuarialBenefitGroup] = 'Other'               AND [Size50k] = 'Large'      THEN 'MIS_LGE'
                                                                                          ELSE 'OTH'
     END AS [Section]
    ,CASE
        WHEN [CATCode]     IN ('COR','COR1') AND CAST([IssueDate] as date)<= '2020-11-30' THEN 'CAT'
      --WHEN [CATCode]     IN ('COR','COR1') AND CAST([IssueDate] as date)>= '2020-12-01'
      --                                     AND CAST([IssueDate] as date)<= '2023-06-30' THEN 'COV'
        WHEN [CATCode] NOT IN ('COR','COR1','CAT','CO1','MHC',' ')                        THEN 'CAT'
        WHEN [ActuarialBenefitGroup] = 'Additional Expenses' AND [Size50k] = 'Underlying' THEN 'ADD'
        WHEN [ActuarialBenefitGroup] = 'Additional Expenses' AND [Size50k] = 'Large'      THEN 'ADD_LGE'
      --WHEN [CFARClaimFlag]         = 1                     AND [Size50k] = 'Underlying' THEN 'CFR'
      --WHEN [CFARClaimFlag]         = 1                     AND [Size50k] = 'Large'      THEN 'CFR_LGE'
        WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size50k] = 'Underlying' THEN 'CAN'
        WHEN [ActuarialBenefitGroup] = 'Cancellation'        AND [Size50k] = 'Large'      THEN 'CAN_LGE'
        WHEN [ActuarialBenefitGroup] = 'Luggage'             AND [Size50k] = 'Underlying' THEN 'MIS'
        WHEN [ActuarialBenefitGroup] = 'Luggage'             AND [Size50k] = 'Large'      THEN 'MIS_LGE'
        WHEN [ActuarialBenefitGroup] = 'Medical'             AND [Size50k] = 'Underlying' THEN 'MED'
        WHEN [ActuarialBenefitGroup] = 'Medical'             AND [Size50k] = 'Large'      THEN 'MED_LGE'
        WHEN [ActuarialBenefitGroup] = 'Other'               AND [Size50k] = 'Underlying' THEN 'MIS'
        WHEN [ActuarialBenefitGroup] = 'Other'               AND [Size50k] = 'Large'      THEN 'MIS_LGE'
                                                                                          ELSE 'OTH'
     END AS [Section2]
    ,IIF(ROW_NUMBER() OVER (PARTITION BY [DomainCountry],[ClaimKey] ORDER BY [IncurredTime]) = 1,1,0) AS [ClaimCount]
    ,CASE WHEN [EstimateMovement] = 0 THEN [IncurredTime] ELSE '9999-12-31' END AS [FinalisedTime]

FROM ctrn
WHERE Rank = 1
;
GO
