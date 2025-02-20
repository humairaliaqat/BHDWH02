USE [db-au-stage]
GO
/****** Object:  Table [dbo].[carebase_DISASTERS_aucm]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[carebase_DISASTERS_aucm](
	[DISASTER_ID] [int] NOT NULL,
	[DISASTER_DESC] [nvarchar](100) NULL,
	[DISASTER_DATE] [date] NULL,
	[CNTRY_CODE] [varchar](3) NULL
) ON [PRIMARY]
GO
