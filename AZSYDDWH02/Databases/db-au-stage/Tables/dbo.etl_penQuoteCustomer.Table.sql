USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penQuoteCustomer]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penQuoteCustomer](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[QuoteCountryKey] [varchar](71) NULL,
	[CustomerKey] [varchar](71) NULL,
	[DomainID] [int] NOT NULL,
	[QuoteID] [int] NOT NULL,
	[CustomerID] [int] NULL,
	[QuoteCustomerID] [int] NOT NULL,
	[Age] [int] NULL,
	[IsPrimary] [bit] NOT NULL,
	[PersonIsAdult] [bit] NOT NULL,
	[HasEMC] [bit] NOT NULL,
	[EmcCoverLimit] [numeric](18, 2) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx]    Script Date: 20/02/2025 10:25:22 AM ******/
CREATE NONCLUSTERED INDEX [idx] ON [dbo].[etl_penQuoteCustomer]
(
	[QuoteCountryKey] ASC
)
INCLUDE([PersonIsAdult],[CustomerID]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
