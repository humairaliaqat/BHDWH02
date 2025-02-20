USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblOutlet_Product_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblOutlet_Product_aucm](
	[ID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[DeclarationSetID] [int] NOT NULL,
	[VolumeCommission] [numeric](18, 9) NOT NULL,
	[Discount] [numeric](18, 9) NOT NULL,
	[CommissionTierID] [int] NOT NULL,
	[ProductPricingTierID] [int] NOT NULL,
	[OutletID] [int] NOT NULL,
	[IsStocked] [bit] NOT NULL,
	[VolumeCommissionName] [nvarchar](200) NOT NULL,
	[IsVolumeCommissionChanged] [bit] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblOutlet_Product_aucm_OutletID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblOutlet_Product_aucm_OutletID] ON [dbo].[penguin_tblOutlet_Product_aucm]
(
	[ID] ASC
)
INCLUDE([OutletID],[CommissionTierID],[VolumeCommission],[Discount],[ProductPricingTierID],[DeclarationSetID],[IsStocked]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
