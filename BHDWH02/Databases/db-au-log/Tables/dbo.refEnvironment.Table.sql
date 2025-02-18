USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[refEnvironment]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[refEnvironment](
	[envID] [int] IDENTITY(0,1) NOT NULL,
	[envName] [nvarchar](50) NULL,
	[targetServer] [nvarchar](50) NULL
) ON [PRIMARY]
GO
