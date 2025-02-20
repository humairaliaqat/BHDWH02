USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_CST_EMOTION_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_CST_EMOTION_aucm](
	[CASE_NO] [varchar](14) NOT NULL,
	[EM_DATE] [datetime] NOT NULL,
	[EM_ID] [numeric](10, 0) NOT NULL,
	[COMMENTS] [varchar](100) NULL
) ON [PRIMARY]
GO
