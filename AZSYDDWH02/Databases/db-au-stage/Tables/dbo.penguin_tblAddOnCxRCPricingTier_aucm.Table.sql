USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblAddOnCxRCPricingTier_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblAddOnCxRCPricingTier_aucm](
	[ID] [int] NOT NULL,
	[AddOnID] [int] NOT NULL,
	[PlanProductPricingTierID] [int] NOT NULL,
	[CxAdjustmentSetID] [int] NOT NULL,
	[CxAdditionalAdjustmentSetID] [int] NULL
) ON [PRIMARY]
GO
