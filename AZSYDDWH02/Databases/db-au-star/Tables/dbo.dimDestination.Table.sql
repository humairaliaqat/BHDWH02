USE [db-au-star]
GO
/****** Object:  Table [dbo].[dimDestination]    Script Date: 20/02/2025 10:26:11 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[dimDestination](
	[DestinationSK] [int] IDENTITY(1,1) NOT NULL,
	[DestinationID] [nvarchar](50) NOT NULL,
	[Destination] [nvarchar](50) NULL,
	[ISO3Code] [nvarchar](10) NULL,
	[ISO2Code] [nvarchar](10) NULL,
	[Continent] [nvarchar](100) NULL,
	[SubContinent] [nvarchar](100) NULL,
	[ABSCountry] [nvarchar](200) NULL,
	[ABSArea] [nvarchar](200) NULL,
	[LoadDate] [datetime] NOT NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NOT NULL,
	[updateID] [int] NULL,
	[HashKey] [varbinary](30) NULL
) ON [PRIMARY]
GO
/****** Object:  Index [idx_dimDestination_DestinationSK]    Script Date: 20/02/2025 10:26:11 AM ******/
CREATE CLUSTERED INDEX [idx_dimDestination_DestinationSK] ON [dbo].[dimDestination]
(
	[DestinationSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimDestination_Continent]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimDestination_Continent] ON [dbo].[dimDestination]
(
	[Continent] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimDestination_Destination]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimDestination_Destination] ON [dbo].[dimDestination]
(
	[Destination] ASC
)
INCLUDE([DestinationSK]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimDestination_DestinationID]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimDestination_DestinationID] ON [dbo].[dimDestination]
(
	[DestinationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimDestination_HashKey]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimDestination_HashKey] ON [dbo].[dimDestination]
(
	[HashKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_dimDestination_ISO2Code]    Script Date: 20/02/2025 10:26:12 AM ******/
CREATE NONCLUSTERED INDEX [idx_dimDestination_ISO2Code] ON [dbo].[dimDestination]
(
	[ISO2Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
