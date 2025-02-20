USE [db-au-stage]
GO
/****** Object:  Table [dbo].[etl_TableSync]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[etl_TableSync](
	[SourceTableName] [varchar](200) NULL,
	[TargetTableName] [varchar](200) NULL,
	[SyncDate] [date] NULL,
	[SyncStatus] [varchar](50) NULL
) ON [PRIMARY]
GO
