USE [db-au-cba]
GO
/****** Object:  Table [dbo].[impQuotePolicyAddons]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impQuotePolicyAddons](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuoteSK] [bigint] NOT NULL,
	[QuoteID] [varchar](50) NULL,
	[AddonCode] [nvarchar](max) NULL,
	[AddonName] [nvarchar](max) NULL,
	[lineGrossPrice] [float] NULL,
	[lineActualGross] [float] NULL,
	[lineDiscountPercent] [float] NULL,
	[lineDiscountedGross] [float] NULL,
	[lineFormattedActualGross] [nvarchar](max) NULL,
 CONSTRAINT [PK_impQuotePolicyAddons] PRIMARY KEY CLUSTERED 
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
