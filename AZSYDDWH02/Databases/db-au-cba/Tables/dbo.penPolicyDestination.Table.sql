USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penPolicyDestination]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penPolicyDestination](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NOT NULL,
	[PolicyKey] [varchar](71) NOT NULL,
	[PrimaryCountry] [nvarchar](max) NULL,
	[DestinationOrder] [bigint] NULL,
	[Destination] [nvarchar](max) NULL,
	[Area] [nvarchar](200) NULL,
	[CountryAreaID] [int] NULL,
	[CountryID] [int] NULL,
	[AreaID] [int] NULL,
	[Weighting] [int] NULL,
	[isPrimaryDestination] [bit] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penPolicyDestination_PolicyKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penPolicyDestination_PolicyKey] ON [dbo].[penPolicyDestination]
(
	[PolicyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [idx_penPolicyDestination_isPrimaryCountry]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penPolicyDestination_isPrimaryCountry] ON [dbo].[penPolicyDestination]
(
	[isPrimaryDestination] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
