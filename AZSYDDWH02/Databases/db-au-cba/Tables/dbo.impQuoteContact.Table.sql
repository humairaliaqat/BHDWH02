USE [db-au-cba]
GO
/****** Object:  Table [dbo].[impQuoteContact]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impQuoteContact](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuoteSK] [bigint] NOT NULL,
	[QuoteID] [varchar](50) NULL,
	[email] [nvarchar](max) NULL,
	[city] [nvarchar](max) NULL,
	[state] [nvarchar](max) NULL,
	[suburb] [nvarchar](max) NULL,
	[country] [nvarchar](max) NULL,
	[street1] [nvarchar](max) NULL,
	[street2] [nvarchar](max) NULL,
	[postCode] [nvarchar](max) NULL,
	[optInMarketing] [nvarchar](max) NULL,
 CONSTRAINT [PK_impQuoteContact] PRIMARY KEY CLUSTERED 
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
