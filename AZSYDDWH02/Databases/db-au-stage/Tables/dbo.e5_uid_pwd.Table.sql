USE [db-au-stage]
GO
/****** Object:  Table [dbo].[e5_uid_pwd]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[e5_uid_pwd](
	[Server] [varchar](50) NULL,
	[databasename] [varchar](50) NULL,
	[UserID] [varchar](50) NULL,
	[pwd] [varbinary](500) NULL
) ON [PRIMARY]
GO
