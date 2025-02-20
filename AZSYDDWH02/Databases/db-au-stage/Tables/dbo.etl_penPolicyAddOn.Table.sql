USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penPolicyAddOn]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penPolicyAddOn](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[PolicyAddOnKey] [varchar](71) NULL,
	[PolicyTransactionKey] [varchar](71) NULL,
	[AddOnKey] [varchar](71) NULL,
	[DomainID] [int] NULL,
	[PolicyAddOnID] [int] NOT NULL,
	[PolicyTransactionID] [int] NOT NULL,
	[AddOnID] [int] NOT NULL,
	[AddonCode] [nvarchar](50) NULL,
	[AddonName] [nvarchar](50) NULL,
	[DisplayName] [nvarchar](100) NULL,
	[AddOnValueID] [int] NOT NULL,
	[AddonValueCode] [nvarchar](10) NULL,
	[AddonValueDesc] [nvarchar](50) NULL,
	[AddonValuePremiumIncrease] [numeric](18, 5) NULL,
	[CoverIncrease] [money] NOT NULL,
	[AddOnGroup] [nvarchar](50) NULL,
	[AddOnText] [nvarchar](500) NULL,
	[isRateCardBased] [bit] NOT NULL
) ON [PRIMARY]
GO
