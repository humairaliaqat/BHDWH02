USE [db-au-actuary]
GO
/****** Object:  Table [ak].[DESTINATION_MAPPINGS]    Script Date: 18/02/2025 12:14:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ak].[DESTINATION_MAPPINGS](
	[Destination] [varchar](27) NULL,
	[Region] [varchar](31) NULL,
	[GLM_Region_2024_banded] [varchar](36) NULL
) ON [PRIMARY]
GO
