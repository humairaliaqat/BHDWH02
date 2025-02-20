USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penProduct]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penProduct](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[ProductKey] [varchar](71) NULL,
	[ProductID] [int] NOT NULL,
	[PurchasePathID] [int] NOT NULL,
	[PurchasePathName] [nvarchar](50) NULL,
	[ProductCode] [nvarchar](50) NOT NULL,
	[ProductName] [nvarchar](50) NOT NULL,
	[ProductDisplayName] [nvarchar](50) NULL,
	[isCancellation] [bit] NOT NULL,
	[DomainID] [int] NOT NULL,
	[FinanceProductID] [int] NULL,
	[FinanceProductCode] [nvarchar](10) NULL,
	[FinanceProductName] [nvarchar](125) NULL
) ON [PRIMARY]
GO
