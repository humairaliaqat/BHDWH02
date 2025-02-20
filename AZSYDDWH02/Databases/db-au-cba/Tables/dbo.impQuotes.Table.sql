USE [db-au-cba]
GO
/****** Object:  Table [dbo].[impQuotes]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impQuotes](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[QuoteID] [varchar](50) NOT NULL,
	[OutletAlphaKey] [nvarchar](50) NULL,
	[businessUnitID] [int] NULL,
	[QuoteDate] [datetime] NULL,
	[YAGOQuoteDate] [datetime] NULL,
	[quoteDateUTC] [datetime] NULL,
	[issuerConsultant] [nvarchar](4000) NULL,
	[issuerAffiliateCode] [nvarchar](20) NULL,
	[tripStartDate] [date] NULL,
	[tripEndDate] [date] NULL,
	[RegionID] [int] NULL,
	[isPurchased] [bit] NULL,
	[quoteExcess] [float] NULL,
	[quoteGross] [float] NULL,
	[quoteDisplayPrice] [float] NULL,
	[quoteDuration] [int] NULL,
	[quoteProductID] [nvarchar](max) NULL,
	[lastTransactionTime] [datetime] NULL,
	[createdDateTime] [datetime] NULL,
	[domain] [nvarchar](max) NULL,
	[SessionID] [nvarchar](max) NULL,
	[ChannelID] [int] NULL,
	[CampaignID] [int] NULL,
	[PartnerTransactionID] [nvarchar](max) NULL,
	[SavedQuoteID] [nvarchar](max) NULL,
	[Data] [nvarchar](max) NULL,
	[PartnerUniqueId] [nvarchar](100) NULL,
	[Trip] [nvarchar](max) NULL,
	[policies] [nvarchar](max) NULL,
	[Travellers] [nvarchar](max) NULL,
	[Quote] [nvarchar](max) NULL,
	[Addons] [nvarchar](max) NULL,
	[Contact] [nvarchar](max) NULL,
	[appliedPromoCodes] [nvarchar](max) NULL,
	[PartnerMetadata] [nvarchar](max) NULL,
	[QuoteSource] [nvarchar](50) NULL,
	[cbaChannelID] [nvarchar](50) NULL,
 CONSTRAINT [PK_impQuotes] PRIMARY KEY CLUSTERED 
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_impQuotes_QuoteID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_impQuotes_QuoteID] ON [dbo].[impQuotes]
(
	[QuoteID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 90) ON [PRIMARY]
GO
