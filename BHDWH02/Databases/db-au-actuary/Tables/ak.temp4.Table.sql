USE [db-au-actuary]
GO
/****** Object:  Table [ak].[temp4]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ak].[temp4](
	[JV Description] [nvarchar](100) NULL,
	[PolicyKey] [varchar](41) NULL,
	[DomainCountry] [varchar](2) NULL,
	[Outlet Channel] [nvarchar](100) NULL,
	[Product Code] [nvarchar](50) NULL,
	[Product Plan] [nvarchar](100) NULL,
	[Plan Type] [nvarchar](50) NULL,
	[issue date] [datetime] NULL,
	[premium] [float] NULL,
	[claimno] [int] NULL,
	[EventDescription] [nvarchar](max) NULL,
	[LossMonth] [date] NULL,
	[incurred] [numeric](38, 6) NULL,
	[paid] [numeric](38, 6) NULL,
	[sections] [int] NULL,
	[perildesc] [nvarchar](65) NULL,
	[sectiondescription] [nvarchar](200) NULL,
	[benefitcategory] [varchar](35) NULL,
	[actuarialbenefitgroup] [varchar](19) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
