USE [db-au-actuary]
GO
/****** Object:  Table [DR].[processTypeClaims_unique]    Script Date: 18/02/2025 12:14:28 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [DR].[processTypeClaims_unique](
	[claimno] [varchar](50) NULL,
	[ProcessTypes] [varchar](560) NOT NULL
) ON [PRIMARY]
GO
