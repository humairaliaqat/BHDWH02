USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_dimDomain]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_dimDomain](
	[DomainID] [int] NULL,
	[CountryCode] [varchar](2) NOT NULL,
	[CurrencySymbol] [nvarchar](10) NULL,
	[CurrencyCode] [varchar](3) NULL,
	[Underwriter] [nvarchar](50) NULL,
	[TimeZoneCode] [varchar](50) NULL,
	[LoadDate] [datetime] NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NULL,
	[updateID] [int] NULL,
	[HashKey] [varbinary](30) NULL
) ON [PRIMARY]
GO
