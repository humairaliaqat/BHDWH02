USE [db-au-stage]
GO
/****** Object:  Table [dbo].[e5_WorkCaseNote_v3]    Script Date: 20/02/2025 10:25:21 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[e5_WorkCaseNote_v3](
	[Work_Id] [uniqueidentifier] NOT NULL,
	[Id] [bigint] NOT NULL,
	[CaseNoteDate] [datetime] NOT NULL,
	[CaseNoteUser] [uniqueidentifier] NULL,
	[CaseNote] [nvarchar](max) NULL,
	[PropertyId] [nvarchar](32) NOT NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
