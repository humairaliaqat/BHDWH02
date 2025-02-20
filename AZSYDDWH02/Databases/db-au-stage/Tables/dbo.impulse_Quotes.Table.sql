USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_Quotes]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_Quotes](
	[QuoteID] [varchar](max) NULL,
	[businessUnitID] [varchar](max) NULL,
	[quoteDateUTC] [datetime] NULL,
	[issuerConsultant] [nvarchar](4000) NULL,
	[issuerAffiliateCode] [nvarchar](4000) NULL,
	[OutletAlphaKey] [nvarchar](50) NULL,
	[tripStartDate] [date] NULL,
	[tripEndDate] [date] NULL,
	[RegionID] [nvarchar](4000) NULL,
	[isPurchased] [bit] NULL,
	[quoteExcess] [float] NULL,
	[quoteGross] [float] NULL,
	[quoteDisplayPrice] [float] NULL,
	[quoteDuration] [float] NULL,
	[quoteProductID] [float] NULL,
	[lastTransactionTime] [datetime] NULL,
	[createdDateTime] [datetime] NULL,
	[domain] [int] NULL,
	[SessionID] [varchar](max) NULL,
	[ChannelID] [varchar](max) NULL,
	[CampaignID] [varchar](max) NULL,
	[PartnerTransactionID] [varchar](max) NULL,
	[SavedQuoteID] [varchar](max) NULL,
	[BIRowID] [bigint] NULL,
	[Trip] [varchar](max) NULL,
	[policies] [varchar](max) NULL,
	[Travellers] [varchar](max) NULL,
	[Quote] [varchar](max) NULL,
	[Addons] [varchar](max) NULL,
	[Contact] [varchar](max) NULL,
	[appliedPromoCodes] [varchar](max) NULL,
	[PartnerMetadata] [varchar](max) NULL,
	[QuoteSource] [nvarchar](4000) NULL,
	[cbaChannelID] [nvarchar](4000) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
