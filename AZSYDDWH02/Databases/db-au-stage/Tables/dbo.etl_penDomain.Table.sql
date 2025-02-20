USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penDomain]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penDomain](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](2) NOT NULL,
	[DomainKey] [varchar](36) NULL,
	[DomainID] [int] NOT NULL,
	[DomainName] [nvarchar](50) NULL,
	[CurrencySymbol] [nvarchar](10) NULL,
	[Underwriter] [nvarchar](50) NULL,
	[CalculationRuleID] [int] NULL,
	[CalculationRule] [nvarchar](50) NULL,
	[AgeCalcFromDeparture] [bit] NULL,
	[AddTripDays] [int] NULL,
	[PaymentURLID] [int] NULL,
	[ShowAddOnGroup] [bit] NOT NULL,
	[DaysInAdvance] [int] NULL,
	[StartDateLimiter] [datetime] NULL,
	[EndDateLimiter] [datetime] NULL,
	[BonusDaysLimiter] [int] NULL,
	[CurrencyCode] [char](3) NULL,
	[TimeZoneCode] [varchar](50) NOT NULL,
	[AgeCompareLimit] [int] NOT NULL,
	[CultureCode] [nvarchar](20) NOT NULL
) ON [PRIMARY]
GO
