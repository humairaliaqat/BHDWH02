USE [db-au-log]
GO
/****** Object:  Table [dbo].[Package_Error_Log]    Script Date: 20/02/2025 10:24:01 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Package_Error_Log](
	[Batch_ID] [int] NOT NULL,
	[Package_ID] [varchar](100) NOT NULL,
	[Source_Table] [varchar](100) NULL,
	[Record] [varchar](2000) NULL,
	[Target_Table] [varchar](100) NULL,
	[Target_Field] [varchar](50) NULL,
	[Error_Code] [varchar](50) NULL,
	[Error_Description] [varchar](2000) NULL,
	[Insert_Date] [datetime] NULL
) ON [PRIMARY]
GO
