USE [db-au-actuary]
GO
/****** Object:  Table [cng].[UW_Destinations]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[UW_Destinations](
	[Destination] [nvarchar](100) NULL,
	[Fix] [nvarchar](50) NOT NULL,
	[Region] [nvarchar](50) NOT NULL,
	[GLM_Region_2017] [nvarchar](50) NOT NULL,
	[GLM_Region_2021] [nvarchar](50) NOT NULL,
	[GLM_Region_2024] [nvarchar](50) NOT NULL,
	[GLM_Region_20242_Banded] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO
