USE [db-au-actuary]
GO
/****** Object:  Table [cng].[UW_Factors]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [cng].[UW_Factors](
	[Factor] [nvarchar](50) NULL,
	[Level] [nvarchar](50) NULL,
	[Loading] [float] NULL,
	[ADD_Freq_2017] [float] NULL,
	[ADD_Freq_2021] [float] NULL,
	[ADD_Size_2017] [float] NULL,
	[ADD_Size_2021] [float] NULL,
	[CAN_Freq_2017] [float] NULL,
	[CAN_Freq_2021] [float] NULL,
	[CAN_Size_2017] [float] NULL,
	[CAN_Size_2021] [float] NULL,
	[MED_Freq_2017] [float] NULL,
	[MED_Freq_2021] [float] NULL,
	[MED_Size_2017] [float] NULL,
	[MED_Size_2021] [float] NULL,
	[OTH_Freq_2017] [float] NULL,
	[OTH_Freq_2021] [float] NULL,
	[OTH_Size_2017] [float] NULL,
	[OTH_Size_2021] [float] NULL,
	[DOM_Freq_2017] [float] NULL,
	[DOM_Freq_2021] [float] NULL,
	[DOM_Size_2017] [float] NULL,
	[DOM_Size_2021] [float] NULL,
	[NZL_Freq_2017] [float] NULL,
	[NZL_Freq_2021] [float] NULL,
	[NZL_Size_2017] [float] NULL,
	[NZL_Size_2021] [float] NULL
) ON [PRIMARY]
GO
