USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblAddOnRateCardCommission_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblAddOnRateCardCommission_aucm](
	[AddOnComID] [int] NOT NULL,
	[AdjustmentSetID] [int] NOT NULL,
	[AreaID] [int] NOT NULL,
	[AgeBandID] [int] NOT NULL,
	[DurationID] [int] NOT NULL,
	[Commission] [numeric](10, 9) NOT NULL
) ON [PRIMARY]
GO
