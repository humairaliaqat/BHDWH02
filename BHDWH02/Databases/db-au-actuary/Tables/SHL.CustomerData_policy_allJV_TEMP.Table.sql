USE [db-au-actuary]
GO
/****** Object:  Table [SHL].[CustomerData_policy_allJV_TEMP]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SHL].[CustomerData_policy_allJV_TEMP](
	[custKey0] [nvarchar](290) NULL,
	[isPrimary] [bit] NULL,
	[DOB] [datetime] NULL,
	[isAdult] [bit] NULL,
	[PolicyKey] [varchar](41) NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[EmailAddress] [nvarchar](255) NULL,
	[Charged Traveller 1 DOB] [date] NULL,
	[Charged Traveller 2 DOB] [date] NULL,
	[Base Policy No] [varchar](50) NULL,
	[Issue Date] [datetime] NULL,
	[PolicyKey2] [varchar](41) NULL,
	[issueMonth] [int] NULL,
	[Trip Type] [nvarchar](50) NULL,
	[JV Description] [nvarchar](100) NULL,
	[Product Code] [nvarchar](50) NULL,
	[Oldest Age] [int] NULL,
	[Charged Traveller Count] [int] NULL,
	[Adult Traveller Count] [int] NULL,
	[Destination] [nvarchar](max) NULL,
	[Area Name] [nvarchar](150) NULL,
	[Policy Type] [nvarchar](50) NULL,
	[Product group] [nvarchar](100) NULL,
	[Policy Status] [varchar](50) NULL,
	[travel_group] [varchar](19) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
