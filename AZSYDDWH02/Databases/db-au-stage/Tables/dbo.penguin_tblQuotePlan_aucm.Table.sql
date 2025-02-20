USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblQuotePlan_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblQuotePlan_aucm](
	[QuotePlanID] [int] NOT NULL,
	[QuoteID] [int] NULL,
	[ProductCode] [nvarchar](50) NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[PlanID] [int] NULL,
	[PlanName] [nvarchar](50) NOT NULL,
	[PlanCode] [nvarchar](50) NULL,
	[PlanType] [nvarchar](50) NOT NULL,
	[IsUpSell] [bit] NOT NULL,
	[Excess] [money] NOT NULL,
	[IsDefaultExcess] [bit] NOT NULL,
	[PolicyStart] [datetime] NOT NULL,
	[PolicyEnd] [datetime] NOT NULL,
	[DaysCovered] [int] NULL,
	[MaxDuration] [int] NULL,
	[GrossPremium] [money] NOT NULL,
	[PDSUrl] [varchar](100) NULL,
	[SortOrder] [int] NULL,
	[PlanDisplayName] [nvarchar](100) NULL,
	[RiskNet] [money] NULL,
	[PlanProductPricingTierID] [int] NULL,
	[VolumeCommission] [numeric](18, 9) NOT NULL,
	[Discount] [numeric](18, 9) NOT NULL,
	[CommissionTier] [varchar](50) NULL,
	[Area] [nvarchar](100) NULL,
	[COI] [varchar](100) NULL,
	[UniquePlanID] [int] NULL,
	[TripCost] [nvarchar](100) NULL,
	[PolicyID] [int] NULL,
	[IsPriceBeat] [bit] NOT NULL,
	[CancellationValueText] [nvarchar](50) NULL,
	[ProductDisplayName] [nvarchar](50) NULL,
	[AreaID] [int] NULL,
	[AgeBandID] [int] NULL,
	[DurationID] [int] NULL,
	[ExcessID] [int] NULL,
	[LeadTimeID] [int] NULL,
	[RateCardID] [int] NULL,
	[IsSelected] [bit] NULL,
	[AreaCode] [nvarchar](3) NULL,
	[IsUnbundled] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblQuotePlan_aucm_QuoteID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblQuotePlan_aucm_QuoteID] ON [dbo].[penguin_tblQuotePlan_aucm]
(
	[QuoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblQuotePlan_aucm_GrossPremium]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblQuotePlan_aucm_GrossPremium] ON [dbo].[penguin_tblQuotePlan_aucm]
(
	[QuoteID] ASC
)
INCLUDE([GrossPremium],[ProductCode],[QuotePlanID],[IsSelected]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
