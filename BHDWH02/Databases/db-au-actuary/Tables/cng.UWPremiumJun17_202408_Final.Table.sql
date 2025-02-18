USE [db-au-actuary]
GO
/****** Object:  Table [cng].[UWPremiumJun17_202408_Final]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[UWPremiumJun17_202408_Final](
	[PolicyKey] [varchar](50) NULL,
	[UW_Policy_Status] [varchar](50) NULL,
	[UW_Premium] [float] NULL,
	[Previous_UW_Premium] [float] NULL,
	[Movement] [float] NULL,
	[Previous_Policy_Status] [varchar](50) NULL,
	[Domain_Country] [varchar](50) NULL,
	[Issue_Mth] [datetime] NULL,
	[Rating_Group] [varchar](50) NULL,
	[JV_Description_Orig] [varchar](50) NULL,
	[JV_Group] [varchar](50) NULL,
	[Product_Code] [varchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_UWPremium_PolicyKeyProductCode]    Script Date: 18/02/2025 12:14:29 PM ******/
CREATE NONCLUSTERED INDEX [idx_UWPremium_PolicyKeyProductCode] ON [cng].[UWPremiumJun17_202408_Final]
(
	[PolicyKey] ASC,
	[Product_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
