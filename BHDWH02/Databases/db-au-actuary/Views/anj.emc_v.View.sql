USE [db-au-actuary]
GO
/****** Object:  View [anj].[emc_v]    Script Date: 18/02/2025 12:14:29 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE VIEW [anj].[emc_v] AS
WITH EMC as
(SELECT distinct a.* 
,b.ClaimKey
,b.EventDescription
,b.[AssessmentOutcome]
,b.[EventLocation]
,b.[EventCountryName]
,b.[PerilCode]
,b.[IssueDate]
,b.[ReceiptDate]
,b.[IncurredTime]
,b.[IncurredAgeBand]
,b.[OnlineClaimFlag]
,b.[MentalHealthClaimFlag]
,b.[LuggageClaimFlag]
,b.[ElectronicsClaimFlag]
,b.[CruiseClaimFlag]
,b.[MopedClaimFlag]
,b.[RentalCarClaimFlag]
,b.[WinterSportClaimFlag]
,b.[CrimeVictimClaimFlag]
,b.[FoodPoisoningClaimFlag]
,b.[AnimalClaimFlag]
,b.[CFARClaimFlag]
,b.[NetPaymentMovementIncRecoveries]
,b.[NetIncurredMovementIncRecoveries]
,b.[EstimateMovement]
,b.[PaymentMovement]
,b.[RecoveryMovement]
,b.[IncurredMovement]
,b.[NetPaymentMovement]
,b.[NetRecoveryMovement]
,b.[NetIncurredMovement]
,b.[NetRealRecoveryMovement]
,b.[NetApprovedPaymentMovement]
,b.[IncurredAtReference]
,b.[NetIncurredAtReference]
,b.[IncurredAtEOM]
,b.[NetIncurredAtEOM]
,b.[MaxIncurredEOM]
,b.[MaxNetIncurredEOM]
,b.[SizeAsAt]
,b.[Size500]
,b.[Size1k]
,b.[Size5k]
,b.[Size10k]
,b.[Size25k]
,b.[Size35k]
,b.[Size50k]
,b.[Size75k]
,b.[Size100k]
,b.[FXReferenceDate]
,b.[EstimateMovement_FX]
,b.[PaymentMovement_FX]
,b.[RecoveryMovement_FX]
,b.[IncurredMovement_FX]
,b.[NetPaymentMovement_FX]
,b.[NetRecoveryMovement_FX]
,b.[NetIncurredMovement_FX]
,b.[NetRealRecoveryMovement_FX]
,b.[NetApprovedPaymentMovement_FX]
,b.[Underwriter]
,b.[PurchasePathGroup]
,b.[Channel]
,b.[Distributor]
,b.[AlphaCode]
,b.[GroupName]
,b.[JVCode]
,b.[JV]
,b.[ProductCode]
,b.[AreaType]
,b.[AreaName]
,b.[Destination]
,b.[DepartureDate]
,b.[ReturnDate]
,b.[LeadTime]
,b.[LeadTimeBand]
,b.[LeadTimeGroup]
,b.[CancellationFlag]
,b.[CancellationCover]
,b.[CancellationCoverBand]
,b.[EMCFlag]
,b.[MaxEMCScore]
,b.[TotalEMCScore]
,b.[CruiseFlag]
,b.[ElectronicsFlag]
,b.[LuggageFlag]
,b.[MotorcycleFlag]
,b.[RentalCarFlag]
,b.[WinterSportFlag]
,b.[CaseNote]
,b.[Section]
,b.[Section2]
,b.[Section3]
,b.[ClaimCount]
,b.[FinalisedTime]
,ROW_NUMBER() OVER(PARTITION BY b.ClaimKey ORDER BY b.[IssueDate] ASC) as rownum
,REPLACE(
        COALESCE(b.EventDescription, '') + ' ' +
        COALESCE(a.[Medical Conditions], '') + ' ' +
        COALESCE(a.[Cause of Claim], '') + ' ' +
        COALESCE(a.[Comments to EMC Test], '') + ' ' +
        COALESCE(a.[Additional Comments], ''),
        '&lt;BR&gt;', ''
    ) AS [Description]

FROM [db-au-actuary].[anj].[EMCDATA1]  a WITH (NOLOCK) 
LEFT JOIN [db-au-actuary].[cng].[Claim_Header_Table] b WITH (NOLOCK) 
ON a. [Claim Key] = b.ClaimKey
)
select * from EMC where rownum = 1
GO
