USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penQuoteEMC]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penQuoteEMC](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[QuoteCountryKey] [varchar](71) NULL,
	[DomainID] [int] NOT NULL,
	[QuoteID] [int] NOT NULL,
	[CustomerID] [int] NULL,
	[EMCScore] [numeric](10, 4) NOT NULL,
	[PremiumIncrease] [numeric](18, 5) NOT NULL,
	[IsPercentage] [bit] NOT NULL,
	[EMCID] [int] NULL,
	[Condition] [int] NULL,
	[DeniedAccepted] [int] NULL
) ON [PRIMARY]
GO
