USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblQuotePlanAddon_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblQuotePlanAddon_aucm](
	[ID] [int] NOT NULL,
	[QuotePlanID] [int] NOT NULL,
	[AddOnID] [int] NULL,
	[AddOnValueID] [int] NULL,
	[AddOnName] [nvarchar](50) NOT NULL,
	[AddOnGroup] [nvarchar](50) NULL,
	[Description] [nvarchar](500) NOT NULL,
	[ValueDescription] [nvarchar](200) NOT NULL,
	[ValueText] [nvarchar](500) NULL,
	[PremiumIncrease] [numeric](18, 5) NOT NULL,
	[CoverIncrease] [money] NOT NULL,
	[IsPercentage] [bit] NOT NULL,
	[IsRateCardBased] [bit] NOT NULL,
	[IsNotSelected] [bit] NOT NULL,
	[Active] [bit] NOT NULL
) ON [PRIMARY]
GO
