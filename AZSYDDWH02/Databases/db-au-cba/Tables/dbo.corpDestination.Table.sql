USE [db-au-cba]
GO
/****** Object:  Table [dbo].[corpDestination]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[corpDestination](
	[CountryKey] [varchar](2) NOT NULL,
	[DestinationKey] [varchar](10) NULL,
	[QuoteKey] [varchar](10) NULL,
	[DestinationID] [int] NOT NULL,
	[QuoteID] [int] NULL,
	[DaysPaidID] [int] NULL,
	[CreateDate] [datetime] NULL,
	[PropBal] [char](1) NULL,
	[DestinationTypeID] [smallint] NULL,
	[DestinationDesc] [varchar](150) NULL,
	[DestinationType] [varchar](50) NULL,
	[NoJourns] [smallint] NULL,
	[NoDays] [smallint] NULL,
	[TotDays] [int] NULL,
	[DaysLoad] [money] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_corpDestination_QuoteKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_corpDestination_QuoteKey] ON [dbo].[corpDestination]
(
	[QuoteKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_corpDestination_TaxKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_corpDestination_TaxKey] ON [dbo].[corpDestination]
(
	[DestinationKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
