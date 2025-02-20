USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblDataImport_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblDataImport_aucm](
	[Id] [int] NOT NULL,
	[SourceReference] [varchar](100) NOT NULL,
	[GroupCode] [varchar](50) NOT NULL,
	[CreateDateTime] [datetime] NOT NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[JobId] [int] NOT NULL,
	[Status] [varchar](50) NOT NULL
) ON [PRIMARY]
GO
