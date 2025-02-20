USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblOutlet_ProductPlanSettings_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblOutlet_ProductPlanSettings_aucm](
	[ID] [int] NOT NULL,
	[OutletProductPlanID] [int] NOT NULL,
	[DefaultExcess] [money] NOT NULL,
	[MaxAdminFee] [money] NOT NULL,
	[IsUpsell] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penguin_tblOutlet_ProductPlanSettings_aucm_OutletProductPlanID]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx_penguin_tblOutlet_ProductPlanSettings_aucm_OutletProductPlanID] ON [dbo].[penguin_tblOutlet_ProductPlanSettings_aucm]
(
	[OutletProductPlanID] ASC
)
INCLUDE([DefaultExcess],[MaxAdminFee],[IsUpsell]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
