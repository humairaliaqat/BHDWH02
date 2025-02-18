USE [db-au-actuary]
GO
/****** Object:  Table [SHL].[CustomerData_policyNo_2019_allJV_v2]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [SHL].[CustomerData_policyNo_2019_allJV_v2](
	[custKey0] [nvarchar](290) NULL,
	[isPrimary] [bit] NULL,
	[DOB] [datetime] NULL,
	[isAdult] [bit] NULL,
	[Base Policy No] [varchar](50) NULL,
	[Issue Date] [datetime] NULL,
	[PolicyKey] [varchar](41) NULL,
	[issueMonth] [int] NULL,
	[Trip Type] [nvarchar](50) NULL,
	[JV Description] [nvarchar](100) NULL,
	[Product Code] [nvarchar](50) NULL,
	[Oldest Age] [int] NULL,
	[Charged Traveller Count] [int] NULL,
	[Adult Traveller Count] [int] NULL
) ON [PRIMARY]
GO
