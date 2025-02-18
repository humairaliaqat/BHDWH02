USE [db-au-stage]
GO
/****** Object:  Table [dbo].[web_LC_Event]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[web_LC_Event](
	[chat_id] [nvarchar](50) NULL,
	[author_name] [nvarchar](50) NULL,
	[text] [nvarchar](max) NULL,
	[date] [nvarchar](50) NULL,
	[timestamp] [nvarchar](50) NULL,
	[agent_id] [nvarchar](50) NULL,
	[user_type] [nvarchar](50) NULL,
	[event_type] [nvarchar](50) NULL,
	[welcome_message] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
