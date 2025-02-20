USE [db-au-stage]
GO
/****** Object:  Table [dbo].[penguin_tblDomainLocalisation_aucm]    Script Date: 20/02/2025 10:25:22 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[penguin_tblDomainLocalisation_aucm](
	[Id] [int] NOT NULL,
	[TableName] [varchar](100) NOT NULL,
	[ColumnName] [varchar](100) NOT NULL,
	[DataId] [int] NOT NULL,
	[StringValue] [nvarchar](max) NULL,
	[UpdateDateTime] [datetime] NOT NULL,
	[DomainLanguageId] [int] NOT NULL,
	[IsDirty] [bit] NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
