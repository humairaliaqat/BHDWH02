USE [db-au-actuary]
GO
/****** Object:  Table [DR].[penPolicy_CBA_SmartAwards_202305]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DR].[penPolicy_CBA_SmartAwards_202305](
	[CountryKey] [varchar](2) NOT NULL,
	[CompanyKey] [varchar](5) NOT NULL,
	[OutletAlphaKey] [nvarchar](50) NULL,
	[OutletSKey] [bigint] NULL,
	[PolicyKey] [varchar](41) NULL,
	[PolicyNoKey] [varchar](100) NULL,
	[PolicyID] [int] NOT NULL,
	[PolicyNumber] [varchar](50) NOT NULL,
	[AlphaCode] [nvarchar](60) NULL,
	[IssueDate] [datetime] NOT NULL,
	[IssueDateNoTime] [datetime] NOT NULL,
	[CancelledDate] [datetime] NULL,
	[StatusCode] [int] NULL,
	[StatusDescription] [nvarchar](50) NULL,
	[Area] [nvarchar](100) NULL,
	[PrimaryCountry] [nvarchar](max) NULL,
	[TripStart] [datetime] NULL,
	[TripEnd] [datetime] NULL,
	[AffiliateReference] [nvarchar](200) NULL,
	[HowDidYouHear] [nvarchar](200) NULL,
	[AffiliateComments] [varchar](500) NULL,
	[GroupName] [nvarchar](100) NULL,
	[CompanyName] [nvarchar](100) NULL,
	[PolicyType] [nvarchar](50) NULL,
	[isCancellation] [bit] NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductCode] [nvarchar](50) NULL,
	[ProductName] [nvarchar](50) NULL,
	[ProductDisplayName] [nvarchar](50) NULL,
	[UniquePlanID] [int] NOT NULL,
	[Excess] [money] NOT NULL,
	[AreaName] [nvarchar](100) NULL,
	[PolicyStart] [datetime] NOT NULL,
	[PolicyEnd] [datetime] NOT NULL,
	[DaysCovered] [int] NULL,
	[MaxDuration] [int] NULL,
	[PlanName] [nvarchar](50) NULL,
	[TripType] [nvarchar](50) NULL,
	[PlanID] [int] NULL,
	[PlanDisplayName] [nvarchar](100) NULL,
	[CancellationCover] [nvarchar](50) NULL,
	[TripCost] [nvarchar](50) NULL,
	[TripDuration] [int] NULL,
	[EmailConsent] [bit] NULL,
	[AreaType] [varchar](25) NULL,
	[PurchasePath] [nvarchar](50) NULL,
	[IsShowDiscount] [bit] NULL,
	[ExternalReference] [nvarchar](100) NULL,
	[DomainKey] [varchar](41) NULL,
	[DomainID] [int] NULL,
	[IssueDateUTC] [datetime] NULL,
	[IssueDateNoTimeUTC] [datetime] NULL,
	[AreaNumber] [varchar](20) NULL,
	[isTripsPolicy] [int] NULL,
	[ImportDate] [datetime] NULL,
	[PreviousPolicyNumber] [varchar](50) NULL,
	[CurrencyCode] [varchar](3) NULL,
	[CultureCode] [nvarchar](20) NULL,
	[AreaCode] [nvarchar](3) NULL,
	[TaxInvoiceNumber] [nvarchar](50) NULL,
	[MultiDestination] [nvarchar](max) NULL,
	[FinanceProductID] [int] NULL,
	[FinanceProductCode] [nvarchar](10) NULL,
	[FinanceProductName] [nvarchar](125) NULL,
	[InitialDepositDate] [date] NULL,
	[PlanCode] [nvarchar](50) NULL,
	[PolicyTravellerKey] [varchar](41) NULL,
	[QuoteCustomerKey] [varchar](41) NULL,
	[PolicyTravellerID] [int] NOT NULL,
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
	[PostCode] [nvarchar](50) NULL,
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
	[AssessmentType] [varchar](20) NULL,
	[EmcCoverLimit] [numeric](18, 2) NULL,
	[MarketingConsent] [bit] NULL,
	[Gender] [nchar](2) NULL,
	[PIDType] [nvarchar](100) NULL,
	[PIDCode] [nvarchar](50) NULL,
	[PIDValue] [nvarchar](256) NULL,
	[MemberRewardPointsEarned] [money] NULL,
	[StateOfArrival] [varchar](100) NULL,
	[MemberTypeID] [int] NULL,
	[TicketType] [nvarchar](50) NULL,
	[VelocityNumber] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
