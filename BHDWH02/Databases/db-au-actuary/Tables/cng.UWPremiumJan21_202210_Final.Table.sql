USE [db-au-actuary]
GO
/****** Object:  Table [cng].[UWPremiumJan21_202210_Final]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[UWPremiumJan21_202210_Final](
	[PolicyKey] [nvarchar](50) NULL,
	[UW_Policy_Status] [nvarchar](50) NULL,
	[UW_Premium] [decimal](18, 10) NULL,
	[Previous_UW_Premium] [decimal](18, 10) NULL,
	[Movement] [decimal](18, 10) NULL,
	[Previous_Policy_Status] [nvarchar](50) NULL,
	[Domain_Country] [nvarchar](50) NULL,
	[Issue_Mth] [datetime2](7) NULL,
	[Rating_Group] [nvarchar](50) NULL,
	[JV_Description_Orig] [nvarchar](50) NULL,
	[JV_Group] [nvarchar](50) NULL,
	[Product_Code] [nvarchar](50) NULL,
	[Segment] [nvarchar](50) NULL,
	[AdditionalDirectCoverageCPP] [decimal](18, 10) NULL
) ON [PRIMARY]
GO
