USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblProductPricingTierBundle_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblProductPricingTierBundle_aucm](
	[ProductPriceBundleID] [int] NOT NULL,
	[CommissionTierID] [int] NULL,
	[ProductVersionID] [int] NOT NULL
) ON [PRIMARY]
GO
