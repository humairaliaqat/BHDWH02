USE [db-au-star]
GO
/****** Object:  Table [dbo].[factQuoteSummary]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[factQuoteSummary](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[DateSK] [int] NOT NULL,
	[DomainSK] [int] NOT NULL,
	[OutletSK] [int] NOT NULL,
	[ConsultantSK] [int] NOT NULL,
	[AreaSK] [int] NOT NULL,
	[DestinationSK] [int] NOT NULL,
	[DurationSK] [int] NOT NULL,
	[AgeBandSK] [int] NOT NULL,
	[ProductSK] [int] NOT NULL,
	[QuoteSessionCount] [int] NOT NULL,
	[QuoteCount] [int] NOT NULL,
	[QuoteWithPriceCount] [int] NOT NULL,
	[SavedQuoteCount] [int] NOT NULL,
	[ConvertedCount] [int] NOT NULL,
	[ExpoQuoteCount] [int] NOT NULL,
	[AgentSpecialQuoteCount] [int] NOT NULL,
	[PromoQuoteCount] [int] NOT NULL,
	[UpsellQuoteCount] [int] NOT NULL,
	[PriceBeatQuoteCount] [int] NOT NULL,
	[QuoteRenewalCount] [int] NOT NULL,
	[CancellationQuoteCount] [int] NOT NULL,
	[LuggageQuoteCount] [int] NOT NULL,
	[MotorcycleQuoteCount] [int] NOT NULL,
	[WinterQuoteCount] [int] NOT NULL,
	[EMCQuoteCount] [int] NOT NULL,
	[LoadDate] [datetime] NOT NULL,
	[LoadID] [int] NOT NULL,
	[updateDate] [datetime] NULL,
	[updateID] [int] NULL,
	[LeadTime] [int] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_factQuoteSummaryBot_BIRowID]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [idx_factQuoteSummaryBot_BIRowID] ON [dbo].[factQuoteSummary]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factQuoteSummaryBot_AgeBandSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factQuoteSummaryBot_AgeBandSK] ON [dbo].[factQuoteSummary]
(
	[AgeBandSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factQuoteSummaryBot_AreaSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factQuoteSummaryBot_AreaSK] ON [dbo].[factQuoteSummary]
(
	[AreaSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factQuoteSummaryBot_ConsultantSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factQuoteSummaryBot_ConsultantSK] ON [dbo].[factQuoteSummary]
(
	[ConsultantSK] ASC
)
INCLUDE([OutletSK],[DateSK]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factQuoteSummaryBot_DateSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factQuoteSummaryBot_DateSK] ON [dbo].[factQuoteSummary]
(
	[DateSK] ASC,
	[OutletSK] ASC
)
INCLUDE([DomainSK],[ConsultantSK],[QuoteSessionCount],[QuoteCount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factQuoteSummaryBot_DestinationSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factQuoteSummaryBot_DestinationSK] ON [dbo].[factQuoteSummary]
(
	[DestinationSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factQuoteSummaryBot_DomainSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factQuoteSummaryBot_DomainSK] ON [dbo].[factQuoteSummary]
(
	[DomainSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factQuoteSummaryBot_DurationSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factQuoteSummaryBot_DurationSK] ON [dbo].[factQuoteSummary]
(
	[DurationSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factQuoteSummaryBot_LeadTime]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factQuoteSummaryBot_LeadTime] ON [dbo].[factQuoteSummary]
(
	[LeadTime] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factQuoteSummaryBot_OutletSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factQuoteSummaryBot_OutletSK] ON [dbo].[factQuoteSummary]
(
	[OutletSK] ASC,
	[DateSK] ASC
)
INCLUDE([ConsultantSK],[QuoteSessionCount],[QuoteCount]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factQuoteSummaryBot_ProductSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factQuoteSummaryBot_ProductSK] ON [dbo].[factQuoteSummary]
(
	[ProductSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [QuoteSessionCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [QuoteCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [QuoteWithPriceCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [SavedQuoteCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [ConvertedCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [ExpoQuoteCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [AgentSpecialQuoteCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [PromoQuoteCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [UpsellQuoteCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [PriceBeatQuoteCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [QuoteRenewalCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [CancellationQuoteCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [LuggageQuoteCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [MotorcycleQuoteCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [WinterQuoteCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((0)) FOR [EMCQuoteCount]
GO
ALTER TABLE [dbo].[factQuoteSummary] ADD  DEFAULT ((-1)) FOR [LeadTime]
GO
