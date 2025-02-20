USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblOutletSalesTargets_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblOutletSalesTargets_aucm](
	[ID] [int] NOT NULL,
	[OutletId] [int] NOT NULL,
	[Month] [int] NULL,
	[GrossSellPriceTarget] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblOutletSalesTargets_aucm_OutletID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE CLUSTERED INDEX [idx_penguin_tblOutletSalesTargets_aucm_OutletID] ON [dbo].[penguin_tblOutletSalesTargets_aucm]
(
	[OutletId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
