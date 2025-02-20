USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penCountryArea]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penCountryArea](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[CountryAreaKey] [varchar](71) NULL,
	[DestinationKey] [varchar](71) NULL,
	[CountryAreaID] [int] NOT NULL,
	[CountryID] [int] NOT NULL,
	[Country] [nvarchar](50) NOT NULL,
	[AreaID] [int] NOT NULL,
	[Area] [nvarchar](100) NOT NULL,
	[Weighting] [int] NULL
) ON [PRIMARY]
GO
