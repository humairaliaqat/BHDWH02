USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penQuoteAddOn]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penQuoteAddOn](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[QuoteCountryKey] [varchar](71) NULL,
	[CustomerKey] [varchar](71) NULL,
	[QuoteID] [int] NOT NULL,
	[CustomerID] [int] NULL,
	[QuoteAddOnID] [int] NOT NULL,
	[AddOnName] [nvarchar](50) NOT NULL,
	[AddOnGroup] [nvarchar](50) NULL,
	[AddOnItem] [nvarchar](500) NULL,
	[PremiumIncrease] [numeric](18, 5) NOT NULL,
	[CoverIncrease] [money] NOT NULL,
	[CoverIsPercentage] [bit] NOT NULL,
	[IsRateCardBased] [bit] NOT NULL,
	[IsActive] [bit] NOT NULL
) ON [PRIMARY]
GO
