USE [db-au-cba]
GO
/****** Object:  Table [dbo].[impQuoteContactPhone]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impQuoteContactPhone](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuoteSK] [bigint] NOT NULL,
	[QuoteID] [varchar](50) NULL,
	[type] [nvarchar](max) NULL,
	[number] [nvarchar](max) NULL,
 CONSTRAINT [PK_impQuoteContactPhone] PRIMARY KEY CLUSTERED 
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
