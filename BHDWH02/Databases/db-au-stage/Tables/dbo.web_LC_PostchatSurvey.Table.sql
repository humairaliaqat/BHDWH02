USE [db-au-stage]
GO
/****** Object:  Table [dbo].[web_LC_PostchatSurvey]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[web_LC_PostchatSurvey](
	[chat_id] [nvarchar](50) NULL,
	[poc_key] [nvarchar](max) NULL,
	[poc_value] [nvarchar](max) NULL,
	[id] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
