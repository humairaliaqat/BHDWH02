USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penPolicyTraveller]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penPolicyTraveller](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[DomainKey] [varchar](41) NULL,
	[PolicyTravellerKey] [varchar](71) NULL,
	[PolicyKey] [varchar](71) NULL,
	[QuoteCustomerKey] [varchar](71) NULL,
	[DomainID] [int] NULL,
	[PolicyTravellerID] [int] NOT NULL,
	[PolicyID] [int] NOT NULL,
	[QuoteCustomerID] [int] NOT NULL,
	[Title] [nvarchar](50) NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[DOB] [datetime] NULL,
	[Age] [int] NULL,
	[isAdult] [bit] NULL,
	[AdultCharge] [numeric](18, 5) NULL,
	[isPrimary] [bit] NULL,
	[AddressLine1] [nvarchar](100) NULL,
	[AddressLine2] [nvarchar](100) NULL,
	[PostCode] [varchar](50) NULL,
	[Suburb] [nvarchar](50) NULL,
	[State] [nvarchar](100) NULL,
	[Country] [nvarchar](100) NULL,
	[HomePhone] [varchar](50) NULL,
	[WorkPhone] [varchar](50) NULL,
	[MobilePhone] [varchar](50) NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[OptFurtherContact] [bit] NULL,
	[MemberNumber] [nvarchar](25) NULL,
	[EMCRef] [varchar](100) NULL,
	[EMCScore] [numeric](10, 4) NULL,
	[DisplayName] [nvarchar](100) NULL,
	[AssessmentType] [varchar](13) NULL,
	[EmcCoverLimit] [numeric](18, 2) NULL,
	[MarketingConsent] [bit] NULL,
	[Gender] [nchar](1) NULL,
	[PIDType] [nvarchar](100) NULL,
	[PIDCode] [varchar](50) NULL,
	[PIDValue] [nvarchar](500) NULL,
	[StateOfArrival] [varchar](100) NULL,
	[MemberTypeId] [int] NULL,
	[TicketType] [nvarchar](50) NULL,
	[VelocityNumber] [nvarchar](50) NULL
) ON [PRIMARY]
GO
