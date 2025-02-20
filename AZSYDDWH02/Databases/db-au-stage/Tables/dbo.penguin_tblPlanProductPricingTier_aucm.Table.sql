USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblPlanProductPricingTier_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblPlanProductPricingTier_aucm](
	[ID] [int] NOT NULL,
	[ProductPricingTierID] [int] NOT NULL,
	[UniquePlanID] [int] NOT NULL,
	[PlanID] [int] NOT NULL,
	[PlanAdjustmentID] [int] NOT NULL,
	[AddionalAdjSetID] [int] NULL
) ON [PRIMARY]
GO
