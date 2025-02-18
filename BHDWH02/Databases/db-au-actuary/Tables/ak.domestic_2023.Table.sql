USE [db-au-actuary]
GO
/****** Object:  Table [ak].[domestic_2023]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ak].[domestic_2023](
	[JV Description] [nvarchar](100) NULL,
	[PolicyKey] [varchar](41) NULL,
	[DomainCountry] [varchar](2) NULL,
	[Outlet Channel] [nvarchar](100) NULL,
	[Product Code] [nvarchar](50) NULL,
	[Product Plan] [nvarchar](100) NULL,
	[Plan Type] [nvarchar](50) NULL,
	[premium] [float] NULL
) ON [PRIMARY]
GO
