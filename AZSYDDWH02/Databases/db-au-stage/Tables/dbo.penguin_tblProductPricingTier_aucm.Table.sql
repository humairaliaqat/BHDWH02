USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblProductPricingTier_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblProductPricingTier_aucm](
	[ProductPricingTierID] [int] NOT NULL,
	[BundleID] [int] NOT NULL,
	[VolumeCommission] [numeric](18, 9) NOT NULL,
	[Discount] [numeric](18, 9) NOT NULL,
	[Name] [nvarchar](200) NOT NULL
) ON [PRIMARY]
GO
