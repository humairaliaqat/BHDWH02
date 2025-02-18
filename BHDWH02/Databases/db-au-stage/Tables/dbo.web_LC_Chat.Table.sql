USE [db-au-stage]
GO
/****** Object:  Table [dbo].[web_LC_Chat]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[web_LC_Chat](
	[chat_id] [nvarchar](50) NULL,
	[chat_type] [nvarchar](50) NULL,
	[visitor_name] [nvarchar](50) NULL,
	[visitor_id] [nvarchar](50) NULL,
	[visitor_email] [nvarchar](50) NULL,
	[visitor_ip] [nvarchar](50) NULL,
	[rate] [nvarchar](50) NULL,
	[duration] [nvarchar](50) NULL,
	[chat_start_url] [nvarchar](max) NULL,
	[referer] [nvarchar](max) NULL,
	[pending] [nvarchar](50) NULL,
	[engagement] [nvarchar](50) NULL,
	[started_timestamp] [nvarchar](50) NULL,
	[started] [nvarchar](50) NULL,
	[ended_timestamp] [nvarchar](50) NULL,
	[ended] [nvarchar](50) NULL,
	[city] [nvarchar](50) NULL,
	[region] [nvarchar](50) NULL,
	[country] [nvarchar](50) NULL,
	[country_code] [nvarchar](50) NULL,
	[visitor_timezone] [nvarchar](50) NULL,
	[tags] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
