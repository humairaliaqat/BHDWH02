USE [db-au-stage]
GO
/****** Object:  Table [dbo].[web_LC_Agent]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[web_LC_Agent](
	[chat_id] [nvarchar](50) NULL,
	[display_name] [nvarchar](50) NULL,
	[email] [nvarchar](50) NULL,
	[ip] [nvarchar](50) NULL
) ON [PRIMARY]
GO
