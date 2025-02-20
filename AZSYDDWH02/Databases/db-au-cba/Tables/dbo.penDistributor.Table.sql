USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penDistributor]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penDistributor](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NULL,
	[DistributorKey] [varchar](41) NULL,
	[DistributorId] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Code] [nvarchar](10) NOT NULL,
	[Urls] [nvarchar](2000) NOT NULL,
	[DistributorAPIKeys] [nvarchar](1000) NOT NULL,
	[Status] [varchar](15) NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[DomainId] [int] NOT NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penDistributor_DistributorKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penDistributor_DistributorKey] ON [dbo].[penDistributor]
(
	[DistributorKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
