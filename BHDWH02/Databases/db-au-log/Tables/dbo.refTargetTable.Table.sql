USE [DB-AU-LOG]
GO
/****** Object:  Table [dbo].[refTargetTable]    Script Date: 18/02/2025 12:59:40 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[refTargetTable](
	[targetTableID] [int] IDENTITY(0,1) NOT NULL,
	[targetTableName] [nvarchar](50) NULL
) ON [PRIMARY]
GO
