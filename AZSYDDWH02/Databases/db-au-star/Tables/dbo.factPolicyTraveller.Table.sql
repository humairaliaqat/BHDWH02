USE [db-au-star]
GO
/****** Object:  Table [dbo].[factPolicyTraveller]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[factPolicyTraveller](
	[DateSK] [int] NOT NULL,
	[DomainSK] [int] NOT NULL,
	[TravellerSK] [int] NOT NULL,
	[OutletSK] [int] NOT NULL,
	[PolicySK] [int] NOT NULL,
	[AreaSK] [int] NOT NULL,
	[DestinationSK] [int] NOT NULL,
	[DurationSK] [int] NOT NULL,
	[ProductSK] [int] NOT NULL,
	[AgeBandSK] [int] NOT NULL,
	[PolicyTransactionKey] [nvarchar](50) NULL,
	[TravellersCount] [int] NULL,
	[LoadDate] [datetime] NOT NULL,
	[LoadID] [int] NOT NULL,
	[updateDate] [datetime] NULL,
	[updateID] [int] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTraveller_DateSK]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [idx_factPolicyTraveller_DateSK] ON [dbo].[factPolicyTraveller]
(
	[DateSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTraveller_AgeBandSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTraveller_AgeBandSK] ON [dbo].[factPolicyTraveller]
(
	[AgeBandSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTraveller_AreaSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTraveller_AreaSK] ON [dbo].[factPolicyTraveller]
(
	[AreaSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTraveller_DestinationSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTraveller_DestinationSK] ON [dbo].[factPolicyTraveller]
(
	[DestinationSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTraveller_DomainSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTraveller_DomainSK] ON [dbo].[factPolicyTraveller]
(
	[DomainSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTraveller_DurationSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTraveller_DurationSK] ON [dbo].[factPolicyTraveller]
(
	[DurationSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTraveller_OutletSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTraveller_OutletSK] ON [dbo].[factPolicyTraveller]
(
	[OutletSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTraveller_PolicySK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTraveller_PolicySK] ON [dbo].[factPolicyTraveller]
(
	[PolicySK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTraveller_ProductSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTraveller_ProductSK] ON [dbo].[factPolicyTraveller]
(
	[ProductSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_factPolicyTraveller_TravellerSK]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_factPolicyTraveller_TravellerSK] ON [dbo].[factPolicyTraveller]
(
	[TravellerSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
