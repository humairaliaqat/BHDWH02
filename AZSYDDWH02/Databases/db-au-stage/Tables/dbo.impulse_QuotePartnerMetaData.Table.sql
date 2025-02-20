USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_QuotePartnerMetaData]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_QuotePartnerMetaData](
	[QuoteSK] [bigint] NULL,
	[QuoteID] [varchar](max) NULL,
	[JSONKey] [varchar](50) NULL,
	[ValueText] [nvarchar](max) NULL,
	[ValueDate] [date] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
