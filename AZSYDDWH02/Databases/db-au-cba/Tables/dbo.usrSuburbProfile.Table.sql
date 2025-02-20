USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrSuburbProfile]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrSuburbProfile](
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[CountryDomain] [varchar](5) NULL,
	[PostCode] [varchar](10) NULL,
	[Suburb] [varchar](50) NULL,
	[State] [varchar](10) NULL,
	[JSONData] [nvarchar](max) NULL,
	[DemographyLocation] [varchar](50) NULL,
	[DemographyOwnership] [varchar](50) NULL,
	[DemographyRank] [decimal](4, 2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Index [cidx_usrSuburbProfile]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE UNIQUE CLUSTERED INDEX [cidx_usrSuburbProfile] ON [dbo].[usrSuburbProfile]
(
	[BIRowID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_postcode_usrSuburbProfile]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_postcode_usrSuburbProfile] ON [dbo].[usrSuburbProfile]
(
	[PostCode] ASC,
	[Suburb] ASC,
	[CountryDomain] ASC
)
INCLUDE([JSONData],[State]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_suburb_usrSuburbProfile]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_suburb_usrSuburbProfile] ON [dbo].[usrSuburbProfile]
(
	[Suburb] ASC,
	[PostCode] ASC,
	[CountryDomain] ASC
)
INCLUDE([JSONData],[State]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
