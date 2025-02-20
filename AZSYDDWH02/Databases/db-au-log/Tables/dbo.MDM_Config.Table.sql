USE [db-au-log]
GO
/****** Object:  Table [dbo].[MDM_Config]    Script Date: 20/02/2025 10:24:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MDM_Config](
	[OrsId] [varchar](255) NULL,
	[UserName] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[Encrypted] [varchar](50) NULL
) ON [PRIMARY]
GO
