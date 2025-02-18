USE [db-au-actuary]
GO
/****** Object:  Table [cng].[UWPremiumCOVID19_202409_Final]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[UWPremiumCOVID19_202409_Final](
	[COVID_Premium] [float] NULL,
	[RP_Total] [float] NULL,
	[PolicyKey] [varchar](50) NULL,
	[UW_Policy_Status] [varchar](50) NULL,
	[Issue_Mth] [datetime] NULL,
	[Issue_Date] [datetime] NULL,
	[Issue_Date_Clean] [datetime] NULL,
	[Destination3] [varchar](50) NULL,
	[COVID_rategroup] [varchar](50) NULL,
	[Domain_Country] [varchar](50) NULL,
	[Integrated_Flag] [varchar](50) NULL,
	[Pre_Trip] [varchar](50) NULL,
	[Product_Code] [varchar](50) NULL,
	[Product_Plan] [varchar](255) NULL,
	[UY] [varchar](50) NULL,
	[Has_Cruise] [varchar](50) NULL,
	[JV_Description_Orig] [varchar](50) NULL,
	[Cruise_UWP] [float] NULL,
	[Cruise_Charge_Flag] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_UWPremium_PolicyKeyProductCode]    Script Date: 18/02/2025 12:14:29 PM ******/
CREATE NONCLUSTERED INDEX [idx_UWPremium_PolicyKeyProductCode] ON [cng].[UWPremiumCOVID19_202409_Final]
(
	[PolicyKey] ASC,
	[Product_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
