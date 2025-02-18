USE [db-au-stage]
GO
/****** Object:  Table [dbo].[ETLTransformationMetaData]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ETLTransformationMetaData](
	[Environment] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[isActive] [varchar](50) NULL,
	[SourceServerName] [varchar](50) NULL,
	[SourceDatabaseName] [varchar](50) NULL,
	[TargetServerName] [varchar](50) NULL,
	[TargetStoredProcedure] [varchar](300) NULL,
	[ExecutionOrder] [int] NULL,
	[TableType] [varchar](5) NULL,
	[Parameter] [varchar](200) NULL,
	[SQLCommand] [varchar](1000) NULL
) ON [PRIMARY]
GO
