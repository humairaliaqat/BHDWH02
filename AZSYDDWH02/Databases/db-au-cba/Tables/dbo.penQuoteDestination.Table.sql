USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penQuoteDestination]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penQuoteDestination](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NOT NULL,
	[QuoteKey] [varchar](71) NOT NULL,
	[PrimaryCountry] [nvarchar](max) NULL,
	[DestinationOrder] [bigint] NULL,
	[Destination] [nvarchar](100) NULL,
	[Area] [nvarchar](100) NULL,
	[CountryAreaID] [int] NULL,
	[CountryID] [int] NULL,
	[AreaID] [int] NULL,
	[Weighting] [int] NULL,
	[isPrimaryDestination] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penQuoteDestination_QuoteKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penQuoteDestination_QuoteKey] ON [dbo].[penQuoteDestination]
(
	[QuoteKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penQuoteDestination_Destination]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penQuoteDestination_Destination] ON [dbo].[penQuoteDestination]
(
	[Destination] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penQuoteDestination_isPrimaryCountry]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penQuoteDestination_isPrimaryCountry] ON [dbo].[penQuoteDestination]
(
	[isPrimaryDestination] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
