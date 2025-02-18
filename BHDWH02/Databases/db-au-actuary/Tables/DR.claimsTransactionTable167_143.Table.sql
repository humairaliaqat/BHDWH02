USE [db-au-actuary]
GO
/****** Object:  Table [DR].[claimsTransactionTable167_143]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DR].[claimsTransactionTable167_143](
	[Rank] [bigint] NULL,
	[DomainCountry] [varchar](2) NOT NULL,
	[Company] [varchar](5) NULL,
	[OutletKey] [varchar](41) NULL,
	[PolicyKey] [varchar](41) NULL,
	[BasePolicyNo] [varchar](50) NULL,
	[ClaimKey] [varchar](40) NOT NULL,
	[ClaimNo] [int] NOT NULL,
	[EventID] [int] NOT NULL,
	[SectionID] [int] NOT NULL,
	[CustomerCareID] [varchar](15) NOT NULL,
	[StatusAtEndOfDay] [nvarchar](100) NOT NULL,
	[StatusAtEndOfMonth] [nvarchar](100) NOT NULL,
	[AssessmentOutcome] [nvarchar](400) NULL,
	[EventCountryCode] [varchar](3) NULL,
	[EventCountryName] [nvarchar](45) NULL,
	[EventSubContinent] [nvarchar](100) NULL,
	[EventContinent] [nvarchar](100) NULL,
	[CATCodeOrg] [varchar](3) NULL,
	[CATCode] [varchar](4) NULL,
	[CatastropheShortDesc] [varchar](20) NULL,
	[CatastropheLongDesc] [nvarchar](60) NULL,
	[PerilCode] [varchar](3) NOT NULL,
	[PerilDesc] [nvarchar](65) NULL,
	[SectionCode] [varchar](25) NULL,
	[SectionDescription] [nvarchar](200) NULL,
	[BenefitLimit] [nvarchar](200) NULL,
	[BenefitSectionKey] [varchar](40) NULL,
	[BenefitCategory] [varchar](35) NULL,
	[ActuarialBenefitGroup] [varchar](19) NULL,
	[IssueQuarter] [date] NULL,
	[LossQuarter] [date] NULL,
	[ReceiptQuarter] [date] NULL,
	[RegisterQuarter] [date] NULL,
	[SectionQuarter] [date] NULL,
	[IncurredQuarter] [date] NULL,
	[IssueMonth] [date] NULL,
	[LossMonth] [date] NULL,
	[ReceiptMonth] [date] NULL,
	[RegisterMonth] [date] NULL,
	[SectionMonth] [date] NULL,
	[IncurredMonth] [date] NULL,
	[IssueDate] [date] NULL,
	[LossDate] [date] NULL,
	[ReceiptDate] [date] NULL,
	[RegisterDate] [date] NULL,
	[SectionDate] [date] NULL,
	[IncurredDate] [date] NULL,
	[IncurredTime] [datetime] NULL,
	[IncurredAgeBand] [varchar](10) NOT NULL,
	[IssueDevelopmentMonth] [int] NULL,
	[LossDevelopmentMonth] [int] NULL,
	[ReceiptDevelopmentMonth] [int] NULL,
	[IssueDevelopmentQuarter] [int] NULL,
	[LossDevelopmentQuarter] [int] NULL,
	[ReceiptDevelopmentQuarter] [int] NULL,
	[OnlineClaimFlag] [int] NOT NULL,
	[MedicalAssistanceClaimFlag] [int] NOT NULL,
	[MentalHealthClaimFlag] [bit] NULL,
	[LuggageClaimFlag] [bit] NULL,
	[ElectronicsClaimFlag] [bit] NULL,
	[CruiseClaimFlag] [bit] NULL,
	[MopedClaimFlag] [bit] NULL,
	[RentalCarClaimFlag] [bit] NULL,
	[WinterSportClaimFlag] [bit] NULL,
	[CrimeVictimClaimFlag] [bit] NULL,
	[FoodPoisoningClaimFlag] [bit] NULL,
	[AnimalClaimFlag] [bit] NULL,
	[BIRowID] [bigint] NOT NULL,
	[PaymentID] [int] NULL,
	[LocalCurrencyCode] [varchar](5) NULL,
	[ExposureCurrencyCode] [varchar](5) NULL,
	[OriginalCurrencyCode] [varchar](3) NULL,
	[OriginalFXRate] [numeric](25, 10) NULL,
	[ForeignCurrencyCode] [varchar](5) NULL,
	[ForeignCurrencyRate] [numeric](25, 10) NULL,
	[ForeignCurrencyRateDate] [date] NULL,
	[USDRate] [numeric](25, 10) NULL,
	[SectionCount] [int] NULL,
	[NetPaymentMovementIncRecoveries] [numeric](38, 6) NULL,
	[NetIncurredMovementIncRecoveries] [numeric](38, 6) NULL,
	[EstimateMovement] [numeric](38, 6) NULL,
	[PaymentMovement] [numeric](38, 6) NULL,
	[RecoveryMovement] [numeric](38, 6) NULL,
	[IncurredMovement] [numeric](38, 6) NULL,
	[NetPaymentMovement] [numeric](38, 6) NULL,
	[NetRecoveryMovement] [numeric](38, 6) NULL,
	[NetIncurredMovement] [numeric](38, 6) NULL,
	[NetRealRecoveryMovement] [numeric](38, 6) NULL,
	[NetApprovedPaymentMovement] [numeric](38, 6) NULL,
	[IncurredAtReference] [numeric](38, 6) NULL,
	[NetIncurredAtReference] [numeric](38, 6) NULL,
	[IncurredAtEOM] [numeric](38, 6) NULL,
	[NetIncurredAtEOM] [numeric](38, 6) NULL,
	[MaxIncurredEOM] [numeric](38, 6) NULL,
	[MaxNetIncurredEOM] [numeric](38, 6) NULL,
	[FXReferenceDate] [date] NULL,
	[FXReferenceRate] [numeric](25, 10) NULL,
	[USDRateReference] [numeric](25, 10) NULL,
	[UsedFXCode] [varchar](5) NULL,
	[UsedFXRateThen] [numeric](25, 10) NULL,
	[UsedFXRateNow] [numeric](25, 10) NULL,
	[FXConversion] [numeric](38, 13) NULL,
	[EstimateMovement_FX] [numeric](38, 6) NULL,
	[PaymentMovement_FX] [numeric](38, 6) NULL,
	[RecoveryMovement_FX] [numeric](38, 6) NULL,
	[IncurredMovement_FX] [numeric](38, 6) NULL,
	[NetPaymentMovement_FX] [numeric](38, 6) NULL,
	[NetRecoveryMovement_FX] [numeric](38, 6) NULL,
	[NetIncurredMovement_FX] [numeric](38, 6) NULL,
	[NetRealRecoveryMovement_FX] [numeric](38, 6) NULL,
	[NetApprovedPaymentMovement_FX] [numeric](38, 6) NULL,
	[Underwriter] [varchar](50) NULL,
	[PurchasePathGroup] [varchar](12) NULL,
	[Channel] [nvarchar](100) NULL,
	[Distributor] [nvarchar](255) NULL,
	[AlphaCode] [nvarchar](20) NULL,
	[GroupName] [nvarchar](50) NULL,
	[JVCode] [nvarchar](20) NULL,
	[JV] [nvarchar](100) NULL,
	[ProductCode] [nvarchar](50) NULL,
	[AreaType] [nvarchar](50) NOT NULL,
	[AreaName] [nvarchar](150) NOT NULL,
	[Destination] [nvarchar](max) NOT NULL,
	[DepartureDate] [datetime] NULL,
	[ReturnDate] [datetime] NULL,
	[LeadTime] [int] NULL,
	[LeadTimeBand] [varchar](22) NULL,
	[LeadTimeGroup] [varchar](15) NULL,
	[CancellationFlag] [varchar](25) NULL,
	[CancellationCover] [money] NULL,
	[CancellationCoverBand] [varchar](8) NULL,
	[EMCFlag] [varchar](10) NULL,
	[MaxEMCScore] [numeric](18, 2) NULL,
	[TotalEMCScore] [numeric](18, 2) NULL,
	[CruiseFlag] [varchar](25) NULL,
	[ElectronicsFlag] [varchar](25) NULL,
	[LuggageFlag] [varchar](25) NULL,
	[MotorcycleFlag] [varchar](25) NULL,
	[RentalCarFlag] [varchar](25) NULL,
	[WinterSportFlag] [varchar](25) NULL,
	[Section] [varchar](7) NOT NULL,
	[ClaimCount] [int] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
