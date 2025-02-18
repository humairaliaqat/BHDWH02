USE [db-au-actuary]
GO
/****** Object:  Table [cng].[UWPremiumApr24_202409_Final]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[UWPremiumApr24_202409_Final](
	[PolicyKey] [varchar](50) NULL,
	[UW_Premium] [float] NULL,
	[Previous_UW_Premium] [float] NULL,
	[Movement] [float] NULL,
	[Previous_Policy_Status] [varchar](50) NULL,
	[Domain_Country] [varchar](50) NULL,
	[Product_Code] [varchar](50) NULL,
	[Segment] [varchar](50) NULL,
	[Excess] [float] NULL,
	[Segment2] [varchar](50) NULL,
	[UW_rating_group] [varchar](50) NULL,
	[Policy_Status] [varchar](50) NULL,
	[Issue_Year_Month] [datetime] NULL,
	[JV_Description] [varchar](50) NULL,
	[Product_Name] [varchar](50) NULL,
	[JV_Group] [varchar](50) NULL,
	[Additional_UWP] [float] NULL,
	[Cancellation_UWP] [float] NULL,
	[Large_UWP] [float] NULL,
	[Luggage_UWP] [float] NULL,
	[Medical_UWP] [float] NULL,
	[Non_GLM_UWP] [float] NULL,
	[Other_UWP] [float] NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_UWPremium_PolicyKeyProductCode]    Script Date: 18/02/2025 12:14:29 PM ******/
CREATE NONCLUSTERED INDEX [idx_UWPremium_PolicyKeyProductCode] ON [cng].[UWPremiumApr24_202409_Final]
(
	[PolicyKey] ASC,
	[Product_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
