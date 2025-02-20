USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_factQuoteSummaryTemp]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_factQuoteSummaryTemp](
	[DateSK] [int] NOT NULL,
	[DomainSK] [int] NOT NULL,
	[OutletSK] [int] NOT NULL,
	[ConsultantSK] [int] NOT NULL,
	[AreaSK] [int] NOT NULL,
	[DestinationSK] [int] NOT NULL,
	[DurationSK] [int] NOT NULL,
	[LeadTime] [bigint] NOT NULL,
	[AgeBandSK] [int] NOT NULL,
	[ProductSK] [int] NOT NULL,
	[QuoteSessionCount] [bigint] NULL,
	[QuoteCount] [bigint] NULL,
	[QuoteWithPriceCount] [bigint] NULL,
	[SavedQuoteCount] [bigint] NULL,
	[ConvertedCount] [bigint] NULL,
	[ExpoQuoteCount] [bigint] NULL,
	[AgentSpecialQuoteCount] [bigint] NULL,
	[PromoQuoteCount] [bigint] NULL,
	[UpsellQuoteCount] [bigint] NULL,
	[PriceBeatQuoteCount] [bigint] NULL,
	[QuoteRenewalCount] [bigint] NULL,
	[CancellationQuoteCount] [bigint] NULL,
	[LuggageQuoteCount] [bigint] NULL,
	[MotorcycleQuoteCount] [bigint] NULL,
	[WinterQuoteCount] [bigint] NULL,
	[EMCQuoteCount] [bigint] NULL
) ON [PRIMARY]
GO
