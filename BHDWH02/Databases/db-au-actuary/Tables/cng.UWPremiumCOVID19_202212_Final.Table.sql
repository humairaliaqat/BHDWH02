USE [db-au-actuary]
GO
/****** Object:  Table [cng].[UWPremiumCOVID19_202212_Final]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[UWPremiumCOVID19_202212_Final](
	[COVID_Premium] [decimal](18, 10) NULL,
	[RP_Total] [decimal](18, 10) NULL,
	[PolicyKey] [nvarchar](50) NULL,
	[UW_Policy_Status] [nvarchar](50) NULL,
	[Issue_Mth] [datetime2](7) NULL,
	[Issue_Date] [datetime2](7) NULL,
	[Issue_Date_Clean] [datetime2](7) NULL,
	[Destination3] [nvarchar](50) NULL,
	[COVID_rategroup] [nvarchar](50) NULL,
	[Domain_Country] [nvarchar](50) NULL,
	[Integrated_Flag] [nvarchar](50) NULL,
	[Pre_Trip] [nvarchar](50) NULL,
	[Product_Code] [nvarchar](50) NULL,
	[Product_Plan] [nvarchar](max) NULL,
	[UY] [nvarchar](50) NULL,
	[Has_Cruise] [nvarchar](50) NULL,
	[JV_Description_Orig] [nvarchar](50) NULL,
	[Cruise_UWP] [decimal](18, 10) NULL,
	[Cruise_Charge_Flag] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_UWPremiumCOVID19_PolicyKeyProductCode]    Script Date: 18/02/2025 12:14:29 PM ******/
CREATE NONCLUSTERED INDEX [idx_UWPremiumCOVID19_PolicyKeyProductCode] ON [cng].[UWPremiumCOVID19_202212_Final]
(
	[PolicyKey] ASC,
	[Product_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
