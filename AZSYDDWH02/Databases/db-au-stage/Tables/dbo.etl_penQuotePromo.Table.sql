USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penQuotePromo]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penQuotePromo](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[PromoKey] [varchar](71) NULL,
	[QuoteCountryKey] [varchar](71) NULL,
	[QuoteID] [int] NOT NULL,
	[PromoID] [int] NOT NULL,
	[PromoCode] [varchar](50) NULL,
	[PromoName] [nvarchar](250) NOT NULL,
	[PromoType] [nvarchar](200) NULL,
	[Discount] [numeric](10, 4) NOT NULL,
	[IsApplied] [bit] NOT NULL,
	[ApplyOrder] [smallint] NOT NULL,
	[GoBelowNet] [bit] NOT NULL
) ON [PRIMARY]
GO
