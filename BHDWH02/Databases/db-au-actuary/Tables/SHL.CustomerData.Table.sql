USE [db-au-actuary]
GO
/****** Object:  Table [SHL].[CustomerData]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SHL].[CustomerData](
	[custKey0] [nvarchar](290) NULL,
	[PolicyTravellerKey] [varchar](41) NULL,
	[PolicyKey] [varchar](41) NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[Age] [int] NULL,
	[DOB] [datetime] NULL,
	[isPrimary] [bit] NULL,
	[isAdult] [bit] NULL,
	[AdultCharge] [numeric](18, 5) NULL,
	[AddressLine1] [nvarchar](100) NULL,
	[AddressLine2] [nvarchar](100) NULL,
	[Suburb] [nvarchar](50) NULL,
	[Postcode] [nvarchar](50) NULL,
	[State] [nvarchar](100) NULL,
	[Country] [nvarchar](100) NULL,
	[HomePhone] [varchar](50) NULL,
	[MobilePhone] [varchar](50) NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[OptFurtherContact] [bit] NULL,
	[MarketingConsent] [bit] NULL,
	[StateOfArrival] [varchar](100) NULL,
	[LoadDate] [datetime] NOT NULL,
	[UpdateDate] [datetime] NOT NULL
) ON [PRIMARY]
GO
