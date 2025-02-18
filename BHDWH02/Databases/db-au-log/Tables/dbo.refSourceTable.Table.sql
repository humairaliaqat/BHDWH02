USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[refSourceTable]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[refSourceTable](
	[srcTableID] [int] IDENTITY(0,1) NOT NULL,
	[srcDBName] [nvarchar](50) NULL,
	[srcTableName] [nvarchar](50) NULL,
	[srcTableType] [nvarchar](50) NULL,
	[dateColumn] [nvarchar](50) NULL,
	[extractSQL] [nvarchar](4000) NULL,
	[targetTableName] [nvarchar](255) NULL,
	[isEnabled] [bit] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[refSourceTable] ADD  DEFAULT ((1)) FOR [isEnabled]
GO
