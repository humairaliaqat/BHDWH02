USE [db-au-cba]
GO
/****** Object:  Table [dbo].[corpQuotes]    Script Date: 20/02/2025 10:13:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[corpQuotes](
	[CountryKey] [varchar](2) NOT NULL,
	[PolicyKey] [varchar](41) NULL,
	[AgencyKey] [varchar](10) NULL,
	[CompanyKey] [varchar](10) NULL,
	[QuoteKey] [varchar](10) NULL,
	[CountryPolicyKey] [varchar](13) NULL,
	[QuoteID] [int] NOT NULL,
	[QuoteDate] [datetime] NULL,
	[AgencyCode] [varchar](7) NULL,
	[CompanyID] [int] NULL,
	[QuoteType] [char](1) NULL,
	[isPolicy] [bit] NULL,
	[IssuedDate] [datetime] NULL,
	[PolicyNo] [int] NULL,
	[PolicyStartDate] [datetime] NULL,
	[PolicyExpiryDate] [datetime] NULL,
	[Excess] [money] NULL,
	[hasPreviousClaim] [bit] NULL,
	[hasCANX] [bit] NULL,
	[hasRefused] [bit] NULL,
	[RefusalDesc] [varchar](50) NULL,
	[CANXReasonDesc] [varchar](50) NULL,
	[PreviousPolicyNo] [int] NULL,
	[BDMID] [int] NULL,
	[DirectSalesExecutiveID] [int] NULL,
	[LeadTypeID] [int] NULL,
	[LeadTypeDesc] [varchar](50) NULL,
	[Operator] [varchar](10) NULL,
	[isGroupPolicy] [bit] NULL,
	[FreeDays] [int] NULL,
	[BIRowID] [bigint] IDENTITY(1,1) NOT NULL,
	[OutletKey] [varchar](33) NULL
) ON [PRIMARY]
GO
