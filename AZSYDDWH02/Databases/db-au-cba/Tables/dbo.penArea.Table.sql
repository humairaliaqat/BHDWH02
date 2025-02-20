USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penArea]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penArea](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[AreaKey] [varchar](41) NULL,
	[AreaID] [int] NULL,
	[DomainID] [int] NULL,
	[AreaName] [nvarchar](100) NULL,
	[Domestic] [bit] NULL,
	[MinimumDuration] [numeric](5, 4) NULL,
	[ChildAreaID] [int] NULL,
	[AreaGroup] [int] NULL,
	[NonResident] [bit] NULL,
	[Weighting] [int] NULL,
	[DomainKey] [varchar](41) NULL,
	[AreaType] [varchar](50) NULL,
	[AreaNumber] [varchar](20) NULL,
	[AreaSetID] [int] NULL,
	[AreaCode] [nvarchar](3) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penArea_AreaKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penArea_AreaKey] ON [dbo].[penArea]
(
	[AreaKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penArea_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penArea_CountryKey] ON [dbo].[penArea]
(
	[CountryKey] ASC,
	[CompanyKey] ASC,
	[AreaName] ASC
)
INCLUDE([AreaID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
