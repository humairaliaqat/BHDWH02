USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penAgeBand]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penAgeBand](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[AgeBandKey] [varchar](71) NULL,
	[DomainID] [int] NOT NULL,
	[AgeBandSetID] [int] NOT NULL,
	[AgeBandSetName] [nvarchar](50) NOT NULL,
	[AgeBandID] [int] NOT NULL,
	[StartAge] [int] NOT NULL,
	[EndAge] [int] NOT NULL
) ON [PRIMARY]
GO
