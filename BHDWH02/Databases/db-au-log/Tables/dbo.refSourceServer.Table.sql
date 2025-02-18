USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[refSourceServer]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[refSourceServer](
	[srcServerID] [int] IDENTITY(0,1) NOT NULL,
	[serverName] [nvarchar](50) NULL,
	[envID] [int] NULL,
	[srcID] [int] NULL,
	[aliasName] [nvarchar](50) NULL
) ON [PRIMARY]
GO
