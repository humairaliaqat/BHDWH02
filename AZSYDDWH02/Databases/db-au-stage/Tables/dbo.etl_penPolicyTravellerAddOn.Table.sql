USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penPolicyTravellerAddOn]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penPolicyTravellerAddOn](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[PolicyTravellerAddOnKey] [varchar](71) NULL,
	[PolicyTravellerTransactionKey] [varchar](71) NULL,
	[AddOnKey] [varchar](71) NULL,
	[PolicyTravellerAddOnID] [int] NOT NULL,
	[PolicyTravellerTransactionID] [int] NOT NULL,
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
