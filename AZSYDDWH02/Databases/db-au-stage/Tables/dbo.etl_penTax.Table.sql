USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penTax]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penTax](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[TaxKey] [varchar](71) NULL,
	[DomainID] [int] NOT NULL,
	[RegionID] [int] NULL,
	[Region] [int] NULL,
	[TaxId] [int] NOT NULL,
	[TaxName] [nvarchar](50) NULL,
	[TaxRate] [numeric](18, 5) NULL,
	[TaxType] [nvarchar](50) NULL
) ON [PRIMARY]
GO
