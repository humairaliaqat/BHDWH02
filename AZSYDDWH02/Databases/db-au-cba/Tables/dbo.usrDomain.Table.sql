USE [db-au-cba]
GO
/****** Object:  Table [dbo].[usrDomain]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[usrDomain](
	[DomainId] [int] NOT NULL,
	[DomainName] [nvarchar](50) NULL,
	[CurrencySymbol] [nvarchar](10) NULL,
	[Underwriter] [nvarchar](50) NULL,
	[CalculationRuleId] [int] NULL,
	[AgeCalcFromDeparture] [bit] NULL,
	[AddTripDays] [int] NULL,
	[PaymentUrlID] [int] NULL,
	[ShowAddOnGroup] [bit] NOT NULL,
	[DaysInAdvance] [int] NULL,
	[StartDateLimiter] [datetime] NULL,
	[EndDateLimiter] [datetime] NULL,
	[BonusDaysLimiter] [int] NULL,
	[CurrencyCode] [char](3) NULL,
	[CountryCode] [varchar](2) NOT NULL,
	[TimeZoneCode] [varchar](50) NOT NULL,
	[AgeCompareLimit] [int] NOT NULL,
	[CultureCode] [nvarchar](20) NOT NULL,
	[IsDefault] [bit] NOT NULL
) ON [PRIMARY]
GO
