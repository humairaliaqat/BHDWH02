USE [db-au-stage]
GO
/****** Object:  Table [dbo].[ETL_ExtractionEngine_MetaData]    Script Date: 18/02/2025 11:53:55 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ETL_ExtractionEngine_MetaData](
	[Environment] [varchar](100) NULL,
	[Country] [varchar](100) NULL,
	[isActive] [varchar](100) NULL,
	[SourceServerName] [varchar](100) NULL,
	[SourceDatabaseName] [varchar](100) NULL,
	[SourceSchema] [varchar](100) NULL,
	[SourceTableName] [varchar](100) NULL,
	[FileFormatPath] [varchar](500) NULL,
	[FileFormatName] [varchar](1000) NULL,
	[FileFormatExt] [varchar](100) NULL,
	[OutputFilePath] [varchar](500) NULL,
	[OutputFileName] [varchar](1000) NULL,
	[OutputFileExt] [varchar](100) NULL,
	[ErrFilePath] [varchar](500) NULL,
	[ErrFilePrefix] [varchar](500) NULL,
	[TableType] [varchar](100) NULL,
	[DateColumn] [varchar](100) NULL,
	[TargetServerName] [varchar](100) NULL,
	[TargetDatabaseName] [varchar](100) NULL,
	[TargetTableName] [varchar](100) NULL,
	[BCP_FFSwitches] [varchar](100) NULL,
	[BCP_ExportSwitches] [varchar](100) NULL,
	[BCP_ImportSwitches] [varchar](100) NULL,
	[BCP_ExportQuery] [varchar](max) NULL,
	[BCP_FFCommand] [varchar](max) NULL,
	[BCP_ExportCommand] [varchar](max) NULL,
	[BCP_ImportCommand] [varchar](max) NULL,
	[SQL_CreateTableDef] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
