USE [db-au-workspace]
GO
/****** Object:  Table [dbo].[activation]    Script Date: 20/02/2025 10:27:08 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[activation](
	[FIRST_NAME] [nvarchar](255) NULL,
	[LAST_NAME] [nvarchar](255) NULL,
	[Full Name] [nvarchar](255) NULL,
	[Travel Start] [datetime] NULL,
	[Travel End] [datetime] NULL
) ON [PRIMARY]
GO
