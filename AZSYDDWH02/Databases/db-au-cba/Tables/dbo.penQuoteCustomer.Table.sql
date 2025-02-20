USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penQuoteCustomer]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penQuoteCustomer](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[QuoteCountryKey] [varchar](41) NULL,
	[CustomerKey] [varchar](41) NULL,
	[QuoteID] [int] NULL,
	[CustomerID] [int] NULL,
	[QuoteCustomerID] [int] NULL,
	[Age] [int] NULL,
	[IsPrimary] [bit] NULL,
	[PersonIsAdult] [bit] NULL,
	[HasEMC] [bit] NULL,
	[DomainKey] [varchar](41) NULL,
	[DomainID] [int] NULL,
	[EMCCoverLimit] [decimal](18, 2) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penQuoteCustomer_QuoteCountryKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penQuoteCustomer_QuoteCountryKey] ON [dbo].[penQuoteCustomer]
(
	[QuoteCountryKey] ASC,
	[IsPrimary] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
