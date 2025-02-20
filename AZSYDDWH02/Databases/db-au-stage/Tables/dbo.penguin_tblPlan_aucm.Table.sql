USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPlan_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPlan_aucm](
	[PlanId] [int] NOT NULL,
	[ProductVersionID] [int] NOT NULL,
	[UniquePlanID] [int] NOT NULL,
	[DurationSetID] [int] NOT NULL,
	[AgeBandSetID] [int] NOT NULL,
	[ExcessSetID] [int] NOT NULL,
	[PlanName] [nvarchar](50) NOT NULL,
	[DisplayName] [nvarchar](100) NULL,
	[PlanTypeId] [int] NOT NULL,
	[CancellationCover] [numeric](18, 5) NOT NULL,
	[TransactionProfileID] [int] NOT NULL,
	[IsBonusDays] [bit] NOT NULL,
	[TermsAndConditions] [nvarchar](4000) NULL,
	[TravellerSetID] [int] NULL,
	[IsAddOnOnly] [bit] NOT NULL,
	[PlanCode] [nvarchar](10) NOT NULL,
	[FinanceProductId] [int] NULL,
	[IsUnbundled] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblPlan_aucm_UniquePlanID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblPlan_aucm_UniquePlanID] ON [dbo].[penguin_tblPlan_aucm]
(
	[UniquePlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
