USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_tblRiskReasonLevel_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_tblRiskReasonLevel_aucm](
	[RISKREASON_ID] [int] NOT NULL,
	[RISKLEVEL_ID] [int] NOT NULL,
	[RISKREASONLEVEL_ID] [int] NOT NULL
) ON [PRIMARY]
GO
