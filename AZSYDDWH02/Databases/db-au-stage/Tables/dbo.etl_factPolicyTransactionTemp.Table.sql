USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_factPolicyTransactionTemp]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_factPolicyTransactionTemp](
	[Country] [varchar](2) NOT NULL,
	[OutletAlphaKey] [nvarchar](50) NULL,
	[AlphaCode] [nvarchar](60) NULL,
	[DomainID] [int] NULL,
	[PolicyKey] [varchar](41) NULL,
	[PolicyNumber] [varchar](50) NULL,
	[AreaName] [nvarchar](100) NULL,
	[AreaType] [varchar](25) NULL,
	[PrimaryCountry] [nvarchar](max) NULL,
	[PromotionKey] [varchar](41) NULL,
	[PaymentKey] [varchar](41) NULL,
	[ProductKey] [nvarchar](243) NULL,
	[ProductCode] [nvarchar](50) NULL,
	[ProductName] [nvarchar](50) NULL,
	[ProductDisplayName] [nvarchar](50) NULL,
	[PlanID] [int] NULL,
	[PlanName] [nvarchar](50) NULL,
	[PlanDisplayName] [nvarchar](100) NULL,
	[TripDuration] [int] NULL,
	[CancellationCover] [nvarchar](50) NULL,
	[TripType] [nvarchar](50) NULL,
	[isCancellation] [bit] NULL,
	[PolicyTravellerKey] [varchar](41) NULL,
	[Age] [int] NULL,
	[UserKey] [varchar](41) NULL,
	[UserName] [nvarchar](200) NULL,
	[ConsultantID] [int] NULL,
	[IssueDate] [date] NOT NULL,
	[PostingDate] [date] NULL,
	[PaymentDate] [datetime] NULL,
	[PolicyTransactionKey] [varchar](41) NOT NULL,
	[TransactionNumber] [varchar](50) NULL,
	[TransactionType] [varchar](50) NULL,
	[TransactionStatus] [nvarchar](50) NULL,
	[isExpo] [varchar](1) NOT NULL,
	[isPriceBeat] [varchar](1) NOT NULL,
	[isAgentSpecial] [varchar](1) NOT NULL,
	[BonusDays] [int] NULL,
	[isClientCall] [varchar](1) NOT NULL,
	[AllocationNumber] [int] NULL,
	[RiskNet] [money] NOT NULL,
	[Premium] [money] NULL,
	[BookPremium] [money] NULL,
	[SellPrice] [money] NULL,
	[NetPrice] [money] NULL,
	[PremiumSD] [money] NULL,
	[PremiumGST] [money] NULL,
	[Commission] [money] NULL,
	[CommissionSD] [money] NULL,
	[CommissionGST] [money] NULL,
	[PremiumDiscount] [money] NULL,
	[AdminFee] [money] NULL,
	[AgentPremium] [money] NULL,
	[UnadjustedSellPrice] [money] NULL,
	[UnadjustedNetPrice] [money] NULL,
	[UnadjustedCommission] [money] NULL,
	[UnadjustedAdminFee] [money] NULL,
	[PolicyCount] [int] NOT NULL,
	[AddonPolicyCount] [int] NOT NULL,
	[ExtensionPolicyCount] [int] NOT NULL,
	[PreCancelledPolicyCount] [int] NOT NULL,
	[CancelledTransactionCount] [int] NOT NULL,
	[CancelledAddonPolicyCount] [int] NOT NULL,
	[CANXPolicyCount] [int] NOT NULL,
	[DomesticPolicyCount] [int] NOT NULL,
	[InternationalPolicyCount] [int] NOT NULL,
	[InboundPolicyCount] [int] NOT NULL,
	[TravellersCount] [int] NOT NULL,
	[AdultsCount] [int] NOT NULL,
	[ChildrenCount] [int] NOT NULL,
	[ChargedAdultsCount] [int] NOT NULL,
	[DomesticTravellersCount] [int] NOT NULL,
	[DomesticAdultsCount] [int] NOT NULL,
	[DomesticChildrenCount] [int] NOT NULL,
	[DomesticChargedAdultsCount] [int] NOT NULL,
	[InboundTravellersCount] [int] NOT NULL,
	[InboundAdultsCount] [int] NOT NULL,
	[InboundChildrenCount] [int] NOT NULL,
	[InboundChargedAdultsCount] [int] NOT NULL,
	[InternationalTravellersCount] [int] NOT NULL,
	[InternationalAdultsCount] [int] NOT NULL,
	[InternationalChildrenCount] [int] NOT NULL,
	[InternationalChargedAdultsCount] [int] NOT NULL,
	[LuggageCount] [int] NOT NULL,
	[MedicalCount] [int] NOT NULL,
	[MotorcycleCount] [int] NOT NULL,
	[RentalCarCount] [int] NOT NULL,
	[WintersportCount] [int] NOT NULL,
	[AttachmentCount] [int] NOT NULL,
	[EMCCount] [int] NOT NULL,
	[CRMUserName] [nvarchar](100) NULL,
	[AddonGroups] [nvarchar](max) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
