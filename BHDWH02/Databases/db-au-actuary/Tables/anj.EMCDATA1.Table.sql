USE [db-au-actuary]
GO
/****** Object:  Table [anj].[EMCDATA1]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [anj].[EMCDATA1](
	[Claim Key] [nvarchar](50) NULL,
	[Count Conditions] [nvarchar](50) NULL,
	[Medical Conditions] [nvarchar](max) NULL,
	[Cause of Claim] [nvarchar](max) NULL,
	[Policy Number] [nvarchar](max) NULL,
	[Claim EMC related?] [nvarchar](max) NULL,
	[MR score] [nvarchar](max) NULL,
	[EMC Test Outcome] [nvarchar](max) NULL,
	[Comments to EMC Test] [nvarchar](max) NULL,
	[Additional Comments] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
