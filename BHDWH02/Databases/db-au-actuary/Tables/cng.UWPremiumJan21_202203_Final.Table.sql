USE [db-au-actuary]
GO
/****** Object:  Table [cng].[UWPremiumJan21_202203_Final]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[UWPremiumJan21_202203_Final](
	[PolicyKey] [nvarchar](50) NULL,
	[UW_Policy_Status] [nvarchar](50) NULL,
	[UW_Premium] [float] NULL,
	[Previous_UW_Premium] [float] NULL,
	[Movement] [float] NULL,
	[Previous_Policy_Status] [nvarchar](50) NULL,
	[Domain_Country] [nvarchar](50) NULL,
	[Issue_Mth] [datetime2](7) NULL,
	[Rating_Group] [nvarchar](50) NULL,
	[JV_Description_Orig] [nvarchar](50) NULL,
	[JV_Group] [nvarchar](50) NULL,
	[Product_Code] [nvarchar](50) NULL
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [idx_UWPremiumEndorsement_PolicyKeyProductCode]    Script Date: 18/02/2025 12:14:27 PM ******/
CREATE UNIQUE CLUSTERED INDEX [idx_UWPremiumEndorsement_PolicyKeyProductCode] ON [cng].[UWPremiumJan21_202203_Final]
(
	[PolicyKey] ASC,
	[Product_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
