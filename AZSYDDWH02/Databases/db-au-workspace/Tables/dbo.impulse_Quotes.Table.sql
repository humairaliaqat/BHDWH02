USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[impulse_Quotes]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_Quotes](
	[birowid] [bigint] NOT NULL,
	[ExtractedID] [varchar](50) NULL,
	[QuoteID] [varchar](50) NULL,
	[businessUnitID] [int] NULL,
	[quoteDateUTC] [datetime] NULL,
	[issuerConsultant] [nvarchar](4000) NULL,
	[issuerAffiliateCode] [nvarchar](4000) NULL,
	[tripStartDate] [date] NULL,
	[tripEndDate] [date] NULL,
	[RegionID] [nvarchar](4000) NULL,
	[isPurchased] [nvarchar](4000) NULL,
	[quoteExcess] [nvarchar](4000) NULL,
	[quoteGross] [nvarchar](4000) NULL,
	[quoteDisplayPrice] [nvarchar](4000) NULL,
	[quoteDuration] [nvarchar](4000) NULL,
	[quoteProductID] [nvarchar](4000) NULL,
	[lastTransactionTime] [nvarchar](4000) NULL,
	[createdDateTime] [nvarchar](4000) NULL,
	[domain] [nvarchar](4000) NULL,
	[token] [nvarchar](4000) NULL,
	[data] [nvarchar](max) NULL,
	[vpolicyid] [nvarchar](4000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
