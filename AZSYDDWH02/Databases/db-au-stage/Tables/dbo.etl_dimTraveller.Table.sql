USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_dimTraveller]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_dimTraveller](
	[Country] [nvarchar](20) NOT NULL,
	[TravellerKey] [varchar](41) NULL,
	[PolicyKey] [varchar](41) NULL,
	[Title] [nvarchar](50) NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[FullName] [nvarchar](201) NULL,
	[DOB] [datetime] NULL,
	[Age] [int] NULL,
	[isAdult] [bit] NULL,
	[AdultCharge] [numeric](18, 5) NULL,
	[isPrimary] [bit] NULL,
	[StreetAddress] [nvarchar](201) NOT NULL,
	[PostCode] [nvarchar](50) NOT NULL,
	[Suburb] [nvarchar](50) NOT NULL,
	[State] [nvarchar](100) NOT NULL,
	[AddressCountry] [nvarchar](100) NOT NULL,
	[HomePhone] [varchar](50) NOT NULL,
	[WorkPhone] [varchar](50) NOT NULL,
	[MobilePhone] [varchar](50) NOT NULL,
	[EmailAddress] [nvarchar](255) NOT NULL,
	[OptFurtherContact] [bit] NOT NULL,
	[MemberNumber] [nvarchar](25) NOT NULL,
	[EMCRef] [varchar](100) NOT NULL,
	[EMCScore] [numeric](10, 4) NOT NULL,
	[DisplayName] [nvarchar](100) NOT NULL,
	[AssessmentType] [varchar](20) NOT NULL,
	[LoadDate] [datetime] NULL,
	[updateDate] [datetime] NULL,
	[LoadID] [int] NULL,
	[updateID] [int] NULL,
	[HashKey] [varbinary](30) NULL
) ON [PRIMARY]
GO
