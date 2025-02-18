USE [db-au-actuary]
GO
/****** Object:  Table [ak].[temp6]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ak].[temp6](
	[JV Description] [nvarchar](100) NULL,
	[policykey] [varchar](41) NULL,
	[DomainCountry] [varchar](2) NULL,
	[Outlet Channel] [nvarchar](100) NULL,
	[Product Code] [nvarchar](50) NULL,
	[Product Plan] [nvarchar](100) NULL,
	[Plan Type] [nvarchar](50) NULL,
	[issue date] [datetime] NULL,
	[increased_premium] [float] NULL,
	[premium] [float] NULL,
	[sections] [int] NULL,
	[claims] [int] NULL,
	[incurred] [numeric](38, 6) NULL,
	[paid] [numeric](38, 6) NULL,
	[perildesc] [nvarchar](65) NULL,
	[sectiondescription] [nvarchar](200) NULL,
	[benefitcategory] [varchar](35) NULL,
	[actuarialbenefitgroup] [varchar](19) NULL,
	[loss_ratio] [float] NULL,
	[incurred_band] [numeric](38, 0) NULL,
	[lr_band] [float] NULL
) ON [PRIMARY]
GO
