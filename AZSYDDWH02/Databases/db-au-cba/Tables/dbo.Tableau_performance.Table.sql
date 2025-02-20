USE [db-au-cba]
GO
/****** Object:  Table [dbo].[Tableau_performance]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tableau_performance](
	[DateRange] [varchar](19) NOT NULL,
	[Date] [smalldatetime] NOT NULL,
	[SubGroupName] [nvarchar](50) NULL,
	[OutletName] [nvarchar](50) NOT NULL,
	[OutletAlphaKey] [nvarchar](50) NOT NULL,
	[ProductName] [nvarchar](4000) NULL,
	[ProductClassification] [varchar](10) NOT NULL,
	[QuoteCount] [int] NULL,
	[PolicyCount] [int] NULL,
	[TravellersCount] [int] NULL,
	[GrossPremium] [money] NULL,
	[AddonGrossPremium] [money] NULL,
	[Commission] [money] NULL,
	[AddonCount] [int] NULL,
	[CMPhoneChannelSource] [int] NULL,
	[CBAOnlineChannelSource] [int] NULL,
	[CBAAppSource] [int] NULL,
	[CBANBSource] [int] NULL,
	[First Estimate Value] [money] NULL,
	[ClaimCount] [int] NULL,
	[Notification lag] [int] NULL,
	[Claim Value] [decimal](38, 6) NULL,
	[Online Claims] [int] NULL,
	[FinalisedClaimCount] [int] NULL,
	[ApprovedCount] [int] NULL,
	[DeniedCount] [int] NULL,
	[FraudDetectedCount] [int] NULL,
	[OtherCount] [int] NULL,
	[PaidAmount] [money] NULL,
	[MaximumPaid] [money] NULL,
	[Claim Finalised Age] [int] NULL,
	[ClaimActivityCount] [int] NULL,
	[FinalisedClaimActivityCount] [int] NULL,
	[ActiveBusinessDays] [int] NULL,
	[ActiveEvents] [int] NULL,
	[ClaimAvgTurnAroundTime] [float] NULL
) ON [PRIMARY]
GO
