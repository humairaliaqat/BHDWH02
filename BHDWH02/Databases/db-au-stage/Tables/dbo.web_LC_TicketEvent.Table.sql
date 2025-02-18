USE [db-au-stage]
GO
/****** Object:  Table [dbo].[web_LC_TicketEvent]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[web_LC_TicketEvent](
	[ticket_id] [nvarchar](50) NULL,
	[author_id] [nvarchar](50) NULL,
	[author_name] [nvarchar](50) NULL,
	[author_type] [nvarchar](50) NULL,
	[event_date] [nvarchar](50) NULL,
	[source_url] [nvarchar](max) NULL,
	[source_type] [nvarchar](50) NULL,
	[to_name] [nvarchar](50) NULL,
	[to_id] [nvarchar](50) NULL,
	[event_current] [nvarchar](50) NULL,
	[event_type] [nvarchar](50) NULL,
	[event_message] [nvarchar](max) NULL,
	[previous] [nvarchar](50) NULL,
	[from_name] [nvarchar](50) NULL,
	[from_id] [nvarchar](50) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
