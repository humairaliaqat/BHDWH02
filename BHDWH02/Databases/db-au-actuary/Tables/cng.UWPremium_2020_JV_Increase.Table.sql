USE [db-au-actuary]
GO
/****** Object:  Table [cng].[UWPremium_2020_JV_Increase]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[UWPremium_2020_JV_Increase](
	[Domain_Country] [nvarchar](50) NOT NULL,
	[JV_Description_Orig] [nvarchar](50) NOT NULL,
	[2020_JV_Increase] [float] NOT NULL
) ON [PRIMARY]
GO
