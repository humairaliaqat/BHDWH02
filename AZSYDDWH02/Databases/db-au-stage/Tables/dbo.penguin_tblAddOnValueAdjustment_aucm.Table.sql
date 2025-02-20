USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblAddOnValueAdjustment_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblAddOnValueAdjustment_aucm](
	[AdjustmentID] [int] NOT NULL,
	[AdjustmentSetID] [int] NOT NULL,
	[AddOnValueID] [int] NOT NULL,
	[Discount] [numeric](12, 9) NULL,
	[Commission] [numeric](10, 9) NOT NULL
) ON [PRIMARY]
GO
