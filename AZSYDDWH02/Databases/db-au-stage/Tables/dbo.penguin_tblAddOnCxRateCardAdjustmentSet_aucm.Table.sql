USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblAddOnCxRateCardAdjustmentSet_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblAddOnCxRateCardAdjustmentSet_aucm](
	[ID] [int] NOT NULL,
	[AddOnCxRateCardSetID] [int] NOT NULL,
	[Name] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
