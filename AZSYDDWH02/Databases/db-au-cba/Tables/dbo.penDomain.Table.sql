USE [db-au-cba]
GO
/****** Object:  Table [dbo].[penDomain]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penDomain](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[DomainKey] [varchar](41) NULL,
	[DomainID] [int] NULL,
	[DomainName] [nvarchar](50) NULL,
	[CurrencySymbol] [nvarchar](10) NULL,
	[Underwriter] [nvarchar](50) NULL,
	[CalculationRuleID] [int] NULL,
	[CalculationRule] [nvarchar](50) NULL,
	[AgeCalcFromDeparture] [bit] NULL,
	[AddTripDays] [int] NULL,
	[PaymentURLID] [int] NULL,
	[ShowAddOnGroup] [bit] NULL,
	[DaysInAdvance] [int] NULL,
	[StartDateLimiter] [datetime] NULL,
	[EndDateLimiter] [datetime] NULL,
	[BonusDaysLimiter] [int] NULL,
	[CurrencyCode] [varchar](3) NULL,
	[TimeZoneCode] [varchar](50) NULL,
	[AgeCompareLimit] [int] NULL,
	[CultureCode] [nvarchar](20) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penDomain_DomainKey]    Script Date: 20/02/2025 10:13:01 AM ******/
CREATE CLUSTERED INDEX [idx_penDomain_DomainKey] ON [dbo].[penDomain]
(
	[DomainKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penDomain_CountryKey]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penDomain_CountryKey] ON [dbo].[penDomain]
(
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_penDomain_DomainID]    Script Date: 20/02/2025 10:13:02 AM ******/
CREATE NONCLUSTERED INDEX [idx_penDomain_DomainID] ON [dbo].[penDomain]
(
	[DomainID] ASC,
	[CountryKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
