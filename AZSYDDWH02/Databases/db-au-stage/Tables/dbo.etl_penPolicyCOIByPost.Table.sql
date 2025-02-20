USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_penPolicyCOIByPost]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_penPolicyCOIByPost](
	[CountryKey] [varchar](2) NULL,
	[CompanyKey] [varchar](5) NULL,
	[PolicyCOIByPostKey] [varchar](71) NULL,
	[PolicyKey] [varchar](71) NULL,
	[DomainID] [int] NOT NULL,
	[PolicyCOIByPostID] [int] NOT NULL,
	[PolicyNumber] [varchar](25) NOT NULL,
	[CreateDateTime] [datetime] NULL,
	[UpdateDateTime] [datetime] NULL,
	[Postcode] [varchar](50) NULL,
	[AddressLine1] [nvarchar](200) NULL,
	[AddressLine2] [nvarchar](200) NULL,
	[Suburb] [nvarchar](100) NULL,
	[State] [nvarchar](200) NULL,
	[CountryName] [nvarchar](200) NULL,
	[CountryCode] [char](3) NULL,
	[Comments] [nvarchar](max) NULL,
	[UpdateDateTimeUTC] [datetime] NOT NULL,
	[CreateDateTimeUTC] [datetime] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
