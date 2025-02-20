USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_QuotePolicyAddons]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuotePolicyAddons](
	[QuoteSK] [bigint] NULL,
	[QuoteID] [varchar](max) NULL,
	[AddonCode] [nvarchar](4000) NULL,
	[AddonName] [nvarchar](4000) NULL,
	[lineGrossPrice] [float] NULL,
	[lineActualGross] [float] NULL,
	[lineDiscountPercent] [float] NULL,
	[lineDiscountedGross] [float] NULL,
	[lineFormattedActualGross] [nvarchar](4000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
