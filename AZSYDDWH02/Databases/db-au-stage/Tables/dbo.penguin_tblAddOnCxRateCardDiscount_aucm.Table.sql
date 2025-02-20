USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblAddOnCxRateCardDiscount_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblAddOnCxRateCardDiscount_aucm](
	[ID] [int] NOT NULL,
	[CxAdjustmentSetID] [int] NOT NULL,
	[ExcessID] [int] NOT NULL,
	[AgeBandID] [int] NOT NULL,
	[LeadTimeID] [int] NOT NULL,
	[Discount] [numeric](12, 9) NULL,
	[AreaID] [int] NULL
) ON [PRIMARY]
GO
