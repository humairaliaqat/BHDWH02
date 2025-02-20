USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penQuoteCompetitor]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penQuoteCompetitor](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NULL,
	[QuoteKey] [varchar](41) NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[CreateDateTimeUTC] [datetime] NOT NULL,
	[UpdateDateTimeUTC] [datetime] NOT NULL,
	[QuoteID] [int] NOT NULL,
	[CompetitorID] [int] NULL,
	[CompetitorName] [nvarchar](50) NULL,
	[CompetitorPrice] [money] NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_penQuoteCompetitor_BIRowID]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penQuoteCompetitor_BIRowID] ON [dbo].[penQuoteCompetitor]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penQuoteCompetitor_CompetitorName]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penQuoteCompetitor_CompetitorName] ON [dbo].[penQuoteCompetitor]
(
	[CompetitorName] ASC
)
INCLUDE([QuoteKey]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penQuoteCompetitor_CreateDateTime]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penQuoteCompetitor_CreateDateTime] ON [dbo].[penQuoteCompetitor]
(
	[CreateDateTime] ASC
)
INCLUDE([QuoteKey],[CompetitorName],[CompetitorPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penQuoteCompetitor_QuoteKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penQuoteCompetitor_QuoteKey] ON [dbo].[penQuoteCompetitor]
(
	[QuoteKey] ASC
)
INCLUDE([CompetitorName],[CompetitorPrice]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
