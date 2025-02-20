USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblAddOnRateCardDiscount_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblAddOnRateCardDiscount_aucm](
	[AddOnDiscID] [int] NOT NULL,
	[AdjustmentSetID] [int] NOT NULL,
	[AreaID] [int] NOT NULL,
	[AgeBandID] [int] NOT NULL,
	[DurationID] [int] NOT NULL,
	[Discount] [numeric](12, 9) NULL
) ON [PRIMARY]
GO
