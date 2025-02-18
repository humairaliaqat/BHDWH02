USE [db-au-actuary]
GO
/****** Object:  Table [cng].[UWPremiumJun17_201810_Final]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[UWPremiumJun17_201810_Final](
	[PolicyKey] [nvarchar](50) NULL,
	[UW_Policy_Status] [nvarchar](50) NULL,
	[UW_Premium] [float] NULL,
	[Previous_Policy_Status] [nvarchar](50) NULL,
	[Previous_UW_Premium] [float] NULL,
	[Movement] [float] NULL,
	[Domain_Country] [nvarchar](50) NULL,
	[Issue_Mth] [datetime] NULL,
	[Rating_Group] [nvarchar](50) NULL,
	[JV_Description_Orig] [nvarchar](50) NULL,
	[JV_Group] [nvarchar](50) NULL
) ON [PRIMARY]
GO
