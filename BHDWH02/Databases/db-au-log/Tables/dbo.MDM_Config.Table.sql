USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[MDM_Config]    Script Date: 18/02/2025 12:59:40 PM ******/
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
