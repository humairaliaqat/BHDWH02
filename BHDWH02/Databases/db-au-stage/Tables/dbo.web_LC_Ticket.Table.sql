USE [db-au-stage]
GO
/****** Object:  Table [dbo].[web_LC_Ticket]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[web_LC_Ticket](
	[ticket_id] [nvarchar](50) NULL,
	[status] [nvarchar](50) NULL,
	[subject] [nvarchar](255) NULL,
	[modified] [nvarchar](50) NULL,
	[resolutionDate] [nvarchar](50) NULL,
	[rate] [nvarchar](50) NULL,
	[date] [nvarchar](50) NULL,
	[requester_mail] [nvarchar](50) NULL,
	[requester_name] [nvarchar](50) NULL,
	[requester_utc_offset] [nvarchar](50) NULL,
	[requester_ip] [nvarchar](50) NULL,
	[tags] [nvarchar](max) NULL,
	[url] [nvarchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
