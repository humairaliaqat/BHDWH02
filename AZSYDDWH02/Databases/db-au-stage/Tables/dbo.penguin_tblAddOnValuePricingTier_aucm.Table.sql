USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblAddOnValuePricingTier_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblAddOnValuePricingTier_aucm](
	[ID] [int] NOT NULL,
	[AddOnID] [int] NOT NULL,
	[PlanProductPricingTierID] [int] NOT NULL,
	[AddOnValueAdjustmentSetID] [int] NOT NULL,
	[AddOnValueAdditionalAdjustmentSetID] [int] NULL
) ON [PRIMARY]
GO
