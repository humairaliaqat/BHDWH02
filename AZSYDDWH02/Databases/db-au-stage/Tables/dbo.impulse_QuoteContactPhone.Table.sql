USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_QuoteContactPhone]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuoteContactPhone](
	[QuoteSK] [bigint] NULL,
	[QuoteID] [varchar](max) NULL,
	[type] [nvarchar](4000) NULL,
	[number] [nvarchar](4000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
