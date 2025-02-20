USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblOutlet_PurchasePath_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblOutlet_PurchasePath_aucm](
	[Id] [int] NOT NULL,
	[OutletId] [int] NOT NULL,
	[PurchasePathId] [int] NOT NULL,
	[IsSelected] [bit] NOT NULL,
	[DefaultCancellationPlanTypeId] [int] NULL,
	[IsCancellation] [bit] NOT NULL
) ON [PRIMARY]
GO
