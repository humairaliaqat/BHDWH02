USE [db-au-stage]
GO
/****** Object:  Table [dbo].[impulse_archive_sessions_FULL]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[impulse_archive_sessions_FULL](
	[Id] [varchar](max) NULL,
	[Trip] [varchar](max) NULL,
	[Agent] [float] NULL,
	[Quote] [varchar](max) NULL,
	[Token] [varchar](max) NULL,
	[Addons] [varchar](max) NULL,
	[Issuer] [varchar](max) NULL,
	[Contact] [varchar](max) NULL,
	[Culture] [varchar](max) NULL,
	[GigyaID] [float] NULL,
	[Payment] [varchar](max) NULL,
	[IsClosed] [varchar](max) NULL,
	[Policies] [varchar](max) NULL,
	[CapRegion] [float] NULL,
	[ChannelID] [varchar](max) NULL,
	[QuoteDate] [datetime] NULL,
	[CampaignID] [varchar](max) NULL,
	[PromoCodes] [varchar](max) NULL,
	[Travellers] [varchar](max) NULL,
	[IsPurchased] [varchar](max) NULL,
	[OfferQuotes] [float] NULL,
	[SavedQuoteID] [varchar](max) NULL,
	[BusinessUnitID] [varchar](max) NULL,
	[MatchedOfferID] [float] NULL,
	[ChargedRegionID] [varchar](max) NULL,
	[CreatedDateTime] [datetime] NULL,
	[PartnerMetadata] [varchar](max) NULL,
	[SelectedOfferID] [float] NULL,
	[CoverMoreQuoteId] [float] NULL,
	[AppliedPromoCodes] [varchar](max) NULL,
	[AdditionalPayments] [float] NULL,
	[ChargedCountryCode] [varchar](max) NULL,
	[CoverMoreDiscounts] [float] NULL,
	[MatchedConstructID] [float] NULL,
	[LastTransactionTime] [datetime] NULL,
	[RelatedSessionToken] [float] NULL,
	[MemberPointsDataList] [varchar](max) NULL,
	[PartnerTransactionID] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
